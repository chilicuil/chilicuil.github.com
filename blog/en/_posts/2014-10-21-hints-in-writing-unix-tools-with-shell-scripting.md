---
layout: post
title: "hints for writing unix tools with shell scripting"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

Yesterday I started my day reading [Hints for writing Unix tools](http://monkey.org/~marius/unix-tools-hints.html). And since I agree to a great extend I though in giving more details about how to build such tools with my favorite language. I'd really enjoy reading similar entries aimed to other langs.

## Consume input from stdin, produce output to stdout

In Unix you can usually refer to stdin and stdout using file descriptors 1 and 2, we do it all the time, for example to send all errors in the `find` command to /dev/null you can type:

    $ find / -name "*pattern*" 2>/dev/null

And it so happens than bash/zsh/sh/ and probably many other shells can test if a fd is open and associated to a terminal with the `-t` test.

With this knowledge consuming input and modifying the behavior of your programs to act different depending to where it goes (pipe, file, stdout) is as easy as testing if the appropriate fd is active. For instance to consuming input the following will work if placed properly (before parsing options?):

<pre class="sh_sh">
if [ ! -t 0 ]; then
    #there is input comming from pipe or file, add to the end of $@
    set -- $(for arg in "${@}"; do printf "%s\\n" "${arg}"; done) $(cat)
fi
</pre>

In the other hand, to print or copy the output to the clipboard depending whether the tool is part of one-liner or not you can test for fd 1:

<pre class="sh_sh">
if command -v "xclip" >/dev/null 2>&amp;1 || [ -t 1 ];  then
    printf "%s\\n" "${_translate_var_result}" | xclip -selection clipboard &amp;&amp; xclip -o -selection clipboard
else
    printf "%s\\n" "${_translate_var_result}"
fi
</pre>

The above will allow to use [translate](https://github.com/chilicuil/learn/blob/master/sh/tools/translate) in the following ways:

    $ translate hola
    $ echo hola | translate
    $ echo hola | translate | sed "s:$: world:"

## Output should be free from header or other decoration

Adding options in shell scripts are easy, if you like adding extra sugar to your output, consider doing it within extra options; -v, --verbose, -a, --all, etc, but by default try to output the simplest response, consider [howdoi](https://github.com/chilicuil/learn/blob/master/sh/tools/howdoi)

    $ howdoi extract a tar.bz2 package in unix
    tar -xjf /path/to/archive.tar.bz

    $ howdoi -a extract a tar.bz2 package in unix
    use the -j option of tar.
       tar -xjf /path/to/archive.tar.bz
    -----
    If it's really an old bzip 1 archive, try:
       bunzip archive.tar.bz
    and you'll have a standard tar file.
    Otherwise, it's the same as with .tar.bz2 files.
    -----
    http://stackoverflow.com/questions/9454929/how-can-i-untar-a-tar-bz-file-in-unix

    $ howdoi -l extract a tar.bz2 package in unix
    http://stackoverflow.com/questions/9454929/how-can-i-untar-a-tar-bz-file-in-unix

Global vars are a good way to track output options.

<pre class="sh_sh">
for arg; do #parse options
case "${arg}" in
-a) AFLAG="set"; shift;;
-l) LFLAG="set"; shift;;
-c) CFLAG="set"; shift;;
</pre>

## Treat a tool's output as an API

You can create tests to ensure your output format doesn't change and actually works. There are [several](http://shunit.sourceforge.net/) [test suites](http://bmizerany.github.io/roundup/) capable of managing [shell](https://github.com/lehmannro/assert.sh) [scripts](http://joyful.com/shelltestrunner/), but one of the simplest is [shtool test suite](http://fossies.org/linux/shtool/test.sh) by Ralf S. Engelschall.

Let's retake the previous script and add some tests:

<pre class="sh_sh">
@begin{howdoi}
howdoi; test X"${?}"                                      = X"1"
printf "%s" '-h' | howdoi; test X"${?}"                   = X"1"
howdoi --help ; test X"${?}"                              = X"1"
howdoi --cui; test X"${?}"                                = X"1"
test X"$(howdoi 2>&amp;1|head -1)"                        = X"Usage: howdoi [options] query ..."
test X"$(howdoi -h 2>&amp;1|head -1)"                     = X"Usage: howdoi [options] query ..."
test X"$(printf "%s" '--help' | howdoi 2>&amp;1|head -1)" = X"Usage: howdoi [options] query ..."
test X"$(howdoi -cui 2>&amp;1|head -1)"                   = X"howdoi: unrecognized option \`-cui'"
test X"$(howdoi -n 2>&amp;1|head -1)"                     = X"Option \`-n' requires a parameter"
test X"$(howdoi -n cui 2>&amp;1|head -1)"                 = X"Option \`-n' requires a number: 'cui'"
test X"$(howdoi XaMTWGfu89iQpJk6 2>&amp;1|head -1)"       = X"howdoi: No results"
test X"$(howdoi -C 2>&amp;1)"                             = X"Cache cleared successfully"
test ! -d ~/.cache/howdoi
test X"$(howdoi XaMTWGfu89iQpJk6 2>&amp;1|head -1)"       = X"howdoi: No results"
test -d ~/.cache/howdoi
@end
</pre>

If you include the output format in your tests it would be harder to change it continuously.

## Place diagnostics output on stderr.

This one is really easy, adding `>&2` to all diagnostic, help and verbose messages will do it.

<pre class="sh_sh">
#before
printf "%s\\n" "$(expr "${0}" : '.*/\([^/]*\)'): unrecognized option '${arg}'"

#after
printf "%s\\n" "$(expr "${0}" : '.*/\([^/]*\)'): unrecognized option '${arg}'" >&amp;2
</pre>

## Signal failure with an exit status.

The current status can be set in bash/zsh/sh with either `true`, `: (true)`, `false`, `return` or `exit`

The first three can be used to set the current status in iterations, e,g.

<pre class="sh_sh">
_rdeps()
{
    [ -z "${1}" ] &amp;&amp; return 1

    for _rdeps_var_binary; do
        fpath="$(command -v "${_rdeps_var_binary}")"
        [ -z "${fpath}" ] &amp;&amp; continue

        if ldd "${fpath}" >/dev/null 2>/dev/null; then
            ldd "${fpath}" | sort -n | uniq | awk '{print $1}' | xargs -i apt-file search {} | cut -d':' -f1 | sort | uniq
        else
            printf "$(expr "${0}" : '.*/\([^/]*\)'): %s\\n" "not a dynamic executable '${fpath}'" >&amp;2 &amp;&amp; false
        fi
    done
}
</pre>

The above code will set the status to 1 without necessary quitting or returning from the function, except when no parameter is present

`exit #number` can be used at any to exit the program with the specified status, it's quite useful when testing for dependencies and exit with error if any of them is not available, e.g.

<pre class="sh_sh">
if ! command -v "curl" >/dev/null 2>&amp;1; then
    printf "%s\\n" "you need to install 'curl' to run this program" >&amp;2
    exit 1
fi
</pre>

## Omit needless diagnostics.

As stated in *Omit needless diagnostics.* output should be as clear and simple as possible, a verbose function can be defined and used as follows:

<pre class="sh_sh">
_verbose()
{
    [ -z "${1}" ] &amp;&amp; return 1
    [ -n "${VFLAG}" ] &amp;&amp; printf "%b\\n" "${*}"
}


for arg; do #parse options
case "${arg}" in
-v|--verbose) VFLAG="set"; shift;;
...
esac

_verbose "detailed message"
</pre>

And for debugging, `set -x` will help to see most of the issues most of the times.

## Avoid making interactive programs

Doing interactive programs in shell scripting is actually harder than parsing cli arguments and outputting simple strings. So it shouldn't be difficult to follow this principle, but if you still want breaking it, ensure interactive is only an additional mode and you still have a batch one.

Happy tooling &#128523;

- [http://monkey.org/~marius/unix-tools-hints.html](http://monkey.org/~marius/unix-tools-hints.html)
- [Personal guidelines](https://github.com/chilicuil/learn/blob/master/sh/guideline.md)
- [Beginning shell scripting](http://f.javier.io/rep/books/Beginning_shell_scripting.pdf)
- [Shell scripts following exposed advices](https://github.com/chilicuil/learn/tree/master/sh)
