---
layout: post
title: "cd wrapper, wcd"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

<iframe  class="showterm" src="http://showterm.io/ae29f68bee555cd89c65d" width="640" height="350">&nbsp;</iframe> 

Using a console interface to manage a computer has some disadvantages, some of them are visible when handling files, moving within the file system, or typing hundred of different commands with thousands of options.  These problems are annoying yet IMO acceptable in exchange for the features you win, automation, standardization, power and control.

Even when I prefer using the cli I try hard to offset the shortcomings of doing so. Firstly, I use tons of [aliases](http://ss64.com/bash/alias.html), 150~ at the moment of writing this article. Secondly I use functions, custom scripts, autocompletion and what made me writing this, [wcd](http://www.xs4all.nl/~waterlan/).

Configuring correctly bash can also bring some improvements, eg, bash 4 does support autocorrection and autocd in many cases:

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

Using aliases to change directories faster is a good technique too:

<pre class="sh_sh">
$ head ~/.alias.common
alias ..="cd .."
alias ....="cd ../.."
alias important.path="cd important/path"
</pre>

There exist tools such as [project_aliases.sh](https://github.com/relevance/etc/blob/master/bash/project_aliases.sh) who take it to seriously and creates aliases for everything.

An important [zsh](http://www.zsh.org) feature I've always wanted is cd pattern recognition, with this **$ cd s*/*/pl** can take you to **super/master/plan**, that's very appeling IMO =), and it's the main idea behind **wcd**.

As many of you probably know, **cd** is a built-in command, it cannot be used in a child process because after terminating the instance the change will be lost. Therefore for **wcd** to work it must be *sourced*:

<pre class="sh_sh">
$ sudo apt-get install wcd
$ head ~/.alias.common
alias cd='. wcd'
</pre>

**wcd** is not a binary (see $ sudo dpkg -L wcd #for more information) but a custom script who can be downloaded from:

- [https://github.com/chilicuil/learn/blob/master/sh/tools/wcd](https://github.com/chilicuil/learn/blob/master/sh/tools/wcd)

Once installed and configured **$ cd s*/*/pl** will take us to **super/master/plan** &#128516; 

How does it work?, wcd creates an index containing all current directories and save it to **$HOME/.treedata.wcd**, when it's sourced it compares the parameter with the database and select the closest option.

WARNING: Wcd will require to regenerate the index db every now and then, a cronjob with the following content can help:

<pre class="sh_sh">
0 23 * * *   /usr/local/bin/update-cd
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

In addition to this, an update-cd alias can be configured to update the db on request:

<pre class="sh_sh">
$ alias update-cd='mkdir $HOME/.wcd; /usr/bin/wcd.exec -GN -j -xf $HOME/.ban.wcd -S $HOME"
$ update-cd
</pre>
