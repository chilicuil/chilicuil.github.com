---
layout: post
title: "less is more, and even more with color"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

**![](/assets/img/1.png)**

I've just discovered how to colorize **less** output, It may seems unimportant but I really prefer to colorize my life when possible.

<pre class="sh_sh">
$ ls -la --color |less -R
</pre>

**![](/assets/img/2.png)**

The colors are defined by editing the **~/.bashrc** file

<pre class="sh_sh">
# Less Colors for Man Pages
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
</pre>

**![](/assets/img/3.png)**

The same trick can be used for other commands who output colorized messages (except for those who they detect when stdout is going through a pipe such as grep):

<pre class="sh_sh">
$ tree -Ca /sys/ | less -R
</pre>

**![](/assets/img/4.png)**

More color codes can be consulted at: <http://ascii-table.com/ansi-escape-sequences.php>.
