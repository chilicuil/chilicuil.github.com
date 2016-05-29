---
layout: post
title: "don't let cd slow you down, cd wrappers: wcd, commacd"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

<!--<iframe  class="showterm" src="http://showterm.io/ae29f68bee555cd89c65d" width="640" height="350">&nbsp;</iframe>-->

Using a console interface to manage a computer has its disadvantages, some of them are specially visible when dealing with multiple files at the same time (moving/renaming/copying), typing long and crypted commands/options or moving around. On this entry I'll talk about the last one.

The default `cd` behaviour on bash to change directories is quite strict, it requires to write full/relative paths and doesn't recognize fuzzy search or any more complicated way of finding directories, some people use many [aliases](https://github.com/relevance/etc/blob/master/bash/project_aliases.sh) to workaround these issues, others change its default shell or use third party tools, eg: [fasd](https://github.com/clvv/fasd), [bd](https://github.com/vigneshwaranr/bd), [fzf](https://github.com/junegunn/fzf), etc to create a semi automatic way of moving faster.

I prefer everything as minimalist and automatic as possible, so after reviewing lots of custom scripts, alternative shells and third party hacks, I think I've something good enough to write about and use on a daily basis.

All start by enabling semi hidden bash options for autocorrecting and autocompleting directories:

<pre class="sh_sh">
$ head ~/.bashrc
# http://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
if [ "${BASH_VERSINFO}" -ge "4" ]; then
    shopt -s autocd cdspell dirspell
fi
</pre>

Now, bash can autocomplete **1/2/3/foo** in the following scenarios:

<pre class="sh_sh">
$ cd 1/2/3/foo
$ cd 1/2/3/ofo
$ 1/2/3/foo
</pre>

Moving between important directories and parent directories can be optimized by adding some aliases:

<pre class="sh_sh">
$ head ~/.alias.common
alias ..="cd .."
alias ....="cd ../.."
alias important.path="cd important/path"
</pre>

Now it's time for some major improvements. An important [zsh](http://www.zsh.org) cd related feature is called pattern recognition, e.g. **$ cd s*/*/pl** will become **super/master/plan**, that's sweet, unfortunately bash is unable to recognize such patterns by itself, however with some [help](http://wcd.sourceforge.net/) it can do it even better.

<pre class="sh_sh">
$ sudo apt-get install wcd
$ head ~/.alias.common
alias cd='. wcd'
</pre>

**wcd** is not a binary, it's a wrapper script around `wcd.exec` (available on the `wcd` package):

- [https://github.com/chilicuil/learn/blob/master/sh/tools/wcd](https://github.com/chilicuil/learn/blob/master/sh/tools/wcd)

Once installed and configured `wcd`, **$ cd s*/*/pl** will take us to **super/master/plan** no matter what the current directory looks like &#128516;, [wcd](http://wcd.sourceforge.net/) works by creating an index file with all available directories and looking at it to find the best approximation.

**WARNING:** Wcd will require to regenerate the index db every now and then, a cronjob with the following content can help:

<pre class="sh_sh">
0 23 * * *  /usr/local/bin/update-cd
</pre>

<pre class="sh_sh">
$ cat /usr/local/bin/update-cd
#!/bin/sh
#description: update wcd db if available
#usage: update-cd

if [ -f "$(command -v "wcd")" ] &amp;&amp; [ -f "$(command -v "wcd.exec")" ]; then
    mkdir "${HOME}"/.wcd; wcd.exec -GN -j -xf "${HOME}"/.ban.wcd -S "${HOME}"
    [ -f "${HOME}"/.treedata.wcd ] &amp;&amp; mv "${HOME}"/.treedata.wcd "${HOME}"/.wcd/
fi
</pre>

In addition, an `update-cd` alias can also be configured to update the db on request:

<pre class="sh_sh">
$ alias update-cd='mkdir $HOME/.wcd; /usr/bin/wcd.exec -GN -j -xf $HOME/.ban.wcd -S $HOME"
$ update-cd
</pre>

Been able to move to any directory from any where is really helpful, however sometimes it's also desirable to move around parents and nearby directories efficiently, that's where [commacd](https://github.com/shyiko/commacd) get in. With `commacd` several aliases (`,`, `,,` and `,,,`) are defined which can be used on the following scenarios:

    $ , /u/l/b #moving through multiple directories
    => cd /usr/local/bin
    $ , d #moving through multiple directories with the same name
    => 1 Desktop
       2 Downloads
       : <type index of the directory to cd into>
    ~/code/projects/zion/src/module $ ,, #going up till a project directory is found (git/hg/svn based)
    => cd ~/code/projects/zion
    ~/code/projects/zion/src/module $ ,, pro #going into the first parent directory named pro*
    => cd ~/code/projects
    ~/code/projects/zion/src/module $ ,, zion matrix #subtituing and going into a parent directory
    => cd ~/code/projects/matrix/src/module
    ~/code/projects/zion/src/module $ ,,, matrix/tests #going into a sibling directory who has the same parent directory
    => cd ~/code/projects/matrix/tests/

As wcd, `commacd` is a script who can be downloaded from:

- [https://raw.githubusercontent.com/shyiko/commacd/master/commacd.bash](https://raw.githubusercontent.com/shyiko/commacd/master/commacd.bash)

Or to get my personal version:

- [https://raw.githubusercontent.com/chilicuil/learn/master/sh/tools/commacd](https://raw.githubusercontent.com/chilicuil/learn/master/sh/tools/commacd)

Upon getting any of them, the script should be used as an alias (due to the nature of the `cd` built-in), eg, `~/bashrc`:

<pre class="sh_sh">
if [ -f "$(command -v "commacd")" ]; then
    . commacd
    alias ,=_commacd_forward
    alias ,,=_commacd_backward
    alias ,,,=_commacd_backward_forward
fi
</pre>

That's it, now moving around should feel less archaic, happy cli browsing =)
