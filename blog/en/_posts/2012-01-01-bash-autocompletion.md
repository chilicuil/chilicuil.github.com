---
layout: post
title: "bash autocompletion"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

**[![](/assets/img/54.jpg)](/assets/img/54.jpg)**

**Update:** It's highly recommended to upgrade [bash-completion](https://viajemotu.wordpress.com/2013/10/16/upgrade-to-bash-completion-2-0/) to version &gt;= 2.0 for an improved performance.

I really like minimalism systems (and cli apps), they are faster, more stable and easier to control. I think it's pretty cool to be able to write a command and get without hesitation a result (I'm aware I'm probably already deprecated, in a world where touch and gui applications are the norm, who would still prefer text based systems?). Sadly many of these commands are not specially user friendly, they contain tons of options and sometimes these options are quite hard to write correctly, when you download scripts from Internet it gets worse, all options must be written by hand because the lack autocompletion.

Many people don't realize this autocompletion magic work by programming simple bash scripts, so I decided to write a few notes about the process.

### Introduction

Bash triage autocompletion every time an user press **&lt;Tab&gt;&lt;Tab&gt;**, for most simple commands a single call to **complete** would be enough to generate correct alternatives. Let's suppose **foo** is a command who only take directories as arguments, the autocompletion logic can be described as:

<pre class="sh_sh">
$ complete -o plusdirs foo
</pre>

From then on **$ foo &lt;Tab&gt;&lt;Tab&gt;** will return a directory list, that one was easy &#128521; Now, let's give more examples:

<pre class="sh_sh">
$ complete -A user bar #will autocomplete bar with a list of system users
$ complete -W "-v --verbose -h" wop #will autocomplete wop with "-v", "--verbose" and "-h"
$ complete -f -X '!*.[pP][dD][fF]' evince foo #will autocomplete evince and foo with all pdf files
</pre>

The full syntax for **complete** can be reviewed in the bash help, **$ man bash**

### Function based

One of the options **complete** accept is **-F** who calls a function, this function can be programmed at any length &#9996; e.g:

<pre class="sh_sh">
$ source file_where_pump_function_is_defined
$ complete -F \_pump pump
</pre>

Now whenever pump is typed followed by &lt;Tab&gt;&lt;Tab&gt; **\_primp()** will be called and will require to fill the [COMPREPLY](http://www.gnu.org/software/bash/manual/html_node/Bash-Variables.html) array.

Most of the files who contain these functions live in **/etc/bash_completion.d/** and in recent years in **/usr/share/bash-completion/completions/** (in Debian/Ubuntu systems), let's suppose we've the following hand made script:

<pre class="sh_sh">
$ fix -h
Usage: fix module
   -h  or --help     List available arguments and usage (this message).
   -v  or --version  print version.
   apache            poves /etc/init.d/apache2.1 to apache2.
   ipw2200           restart the ipw2200 module.
   wl                restart the wl module.
   iwlagn            restart the iwlagn module.
   mpd               restart mpd.
</pre>

The autocompletion logic can be defined in two ways, the easiest one would be to dump the following line in **/etc/bash_completion.d/fix.autocp**:

<pre class="sh_sh">
$ complete -W "-h --help -v --version apache ipw2200 wl iwlagn mpd" fix
</pre>

After doing, it would be necessary to reload the environment:

<pre class="sh_sh">
$ source $HOME/.bashrc
</pre>

WARNING: autocompletion will only work if it's initialized in **$HOME/.bashrc** or other files read by bash (it also must be installed $ sudo apt-get install bash-completion):

<pre class="sh_sh">
if [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
fi
</pre>

The more elaborated case would involve defining a function, let's replace the **/etc/bash_completion.d/fix.autocp** content with this:

<pre class="sh_sh">
\_fix()
{

    if ! command -v "fix" &gt;/dev/null 2&gt;&amp;1; then
        return
    fi

    #defining local vars
    local cur prev words cword
    _init_completion || return #comment this line for bash-completion &lt;2.0

    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    COMPREPLY=() #clean out last completions, important!

    COMMANDS="apache ipw2200 wl iwlagn mpd"
    OPTS="-h --help -v --version"

    case "${cur}" in #if the current word have a '-' at the beginning..
        -*) completions="${OPTS}"     ;;
        *)  completions="${COMMANDS}" ;;
    esac
    COMPREPLY=($(compgen -W "${completions}" -- ${cur}))
    return 0
}
complete -F \_fix fix
</pre>

The **$cur** variable is important, parameters would be compared against it, in more complex examples, **$prev** and even **$prev_prev** can be compared.

To generate option lists, **compgen** is used regularly, this command compare and return matched results as a list, to wrap it up, here are some examples:

<pre class="sh_sh">
$ compgen -W "-v --verbose -h --help" -- "-v"
-v
$ compgen -W "-v --verbose -h --help" -- "--"
--verbose
--help
$ compgen -W "apache ipw2200 iwlagn mpd wl" -- "ap"
apache
$ compgen -W "apache ipw2200 iwlagn mpd wl" -- "i"
ipw2200
iwlagn
</pre>

Once this two step process is understood it's easy to see how most autocomplation scripts work. I'll review a more complex example, **android**:

<pre class="sh_sh">
$ android -h
  Usage: android [global options] action [action options]
  Global options:
      -v --verbose  Verbose mode: errors, warnings and informational messages are printed.
      -h --help     Help on a specific command.
      -s --silent   Silent mode: only errors are printed out.
  Valid actions are composed of a verb and an optional direct object:
      -   list          
      -   list avd         
      -   list target     
      - create avd        
      -   move avd       
      - delete avd       
      - update avd       
      - create project    
      - update project    
      - create test-project 
      - update test-project 
      - create lib-project  
      - update lib-project 
      - update adb 
      - update sdk     
</pre>

As it can be noted most options depend of a previous command, "avd" should only be returned when list is used as an action:

<pre class="sh_sh">
$ android list[Tab][Tab]
</pre>

And **avd**/**target** should be returned when no substring is present after list

<pre class="sh_sh">
$ android create[Tab][Tab]
</pre>

Should return **avd**, **project**, **test-project** and **lib-project**:

<pre class="sh_sh">
$ android create avd[Tab][Tab]
</pre>

And **-a**, **-c**, **-f**, etc, should be returned when avd and create are the first parameters. The full autocompletion file for this example is located in [github](https://github.com/chilicuil/learn/blob/master/autocp/completions/android), I'll explain now the more important parts:

<pre class="sh_sh">
\_android()
{
    if ! command -v "android" &gt;/dev/null 2&gt;&amp;1; then
        return
    fi
    COMPREPLY=() #clean out last completions, important!
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    number_of_words=${#COMP_WORDS[@]}

    if [ "${number_of_words}" -gt "2" ]]; then
        prev_prev="${COMP_WORDS[COMP_CWORD-2]}"
    fi
</pre>

A **prev_prev** variable is declared only when two or more arguments are written in the prompt.

<pre class="sh_sh">
#=======================================================
#                  General options
#=======================================================
COMMANDS="list create move delete update"
#COMMANDS=`android -h | grep '^-' | sed -r 's/: .*//' \
           | awk '{print $2}' | sort | uniq 2> /dev/null`
</pre>

List options can be declared fixed or generated at run time by parsing help screens, depending of the command you can use whenever method feels more comfortable.

<pre class="sh_sh">
OPTS="-h --help -v --verbose -s --silent"
#=======================================================
#                   Nested options [1st layer]
#=======================================================
list_opts="avd target"
create_opts="avd project test-project lib-project"
move_opts="avd"...
</pre>

The same can be set for subcommands

<pre class="sh_sh">
#=======================================================
#                   Nested options [2nd layer]
#=======================================================
create_avd_opts="-c --sdcard -t --target -n --name -a \
                 --snapshot -p --path -f -s --skin"
create_project_opts="-n --name -t --target -p --path -k \
                     --package -a --activity"
create_test-project_opts="-p --path -m --main -n --name"
create_lib-project_opts="-n --name -p --path -t --target \
                         -k --package"...
</pre>

And subcommand options...

<pre class="sh_sh">
if [ -n "${prev_prev}" ]; then
#2nd layer
case "${prev_prev}" in
  create)
    case "${prev}" in
      avd)
         COMPREPLY=($(compgen -W "${create_avd_opts}" -- ${cur}))
         return 0
         ;;
      project)
         COMPREPLY=($(compgen -W "${create_project_opts}" -- ${cur}))
         return 0
         ;;
         ...
 esac
</pre>

Depending in **$prev_prev**, **$prev** and **$cur** the correct list will be return, **$ android subcomand option incomplete_option#CURSOR#**

<pre class="sh_sh">
case "${prev}" in
    ##1st layer
    list)
        COMPREPLY=($(compgen -W "${list_opts}" -- ${cur}))
        return 0
        ;;
    create)
        COMPREPLY=($(compgen -W "${create_opts}" -- ${cur}))
        return 0
        ;;
    ...
</pre>

**$ android subcommand incomplete_option#CURSOR#**

<pre class="sh_sh">
      #general options
      case "${cur}" in
         -*)
             COMPREPLY=($(compgen -W "${OPTS}" -- ${cur}))
             ;;
         *)
             COMPREPLY=($(compgen -W "${COMMANDS}" -- ${cur}))
             ;;
      esac
}
complete -F \_android android
</pre>

**$ android incomplete_subcommand#CURSOR#**

### Extra

#### Available functions

There exist plenty of available functions who can be used to autocomplete commonly used options, for example, if a command accepts a **-f** option for file arguments, the **\_filedir** function can be used:

<pre class="sh_sh">
-f)
    \_filedir
    return 0
    ;;
</pre>

Other pre-defined functions can be found at: <http://anonscm.debian.org/gitweb/?p=bash-completion/bash-completion.git;a=blob;f=bash_completion>

#### Debug

Bash autocompletion scripts are easy to create, however eventually (specially with larger cli commands) there are chances things doesn't work as expected, in those cases enabling bash verbose mode is the easiest and faster method to debug such scripts:

<pre class="sh_sh">
$ set -x
$ source ~/.bashrc #reload the environment
$ command opc[Tab][Tab] #testing the autocompletion
...
...
... verbose output
</pre>

### Examples

There are many bash completion scripts in [Internet](http://anonscm.debian.org/gitweb/?p=bash-completion/bash-completion.git;a=tree;f=completions) and [some others](https://github.com/chilicuil/learn/tree/master/autocp/completions) in my personal repository. Looking at examples is probably the easiest way to learn the harder details.

### Final thoughts

Bash autocompletion may seems scary at the beginning but once several examples are read a clear pattern can be dazzled, depending on your system usage they can save you a lot of time/typing, so next time you find yourself writing to much give them a shot and let the computer do the job for you &#128522; 

- [http://bash-completion.alioth.debian.org/](http://bash-completion.alioth.debian.org/)
