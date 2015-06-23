---
layout: post
title: "using vim objects in bash"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

I've been using [vi-mode](http://www.catonmat.net/blog/bash-vi-editing-mode-cheat-sheet/) in bash for a couple of years now, more than once I've tried to edit something with **ci"**, **ca(**, or any other popular [vim object](http://blog.carbonfive.com/2011/10/17/vim-text-objects-the-definitive-guide/).

This week decided to go further and see how to do it, and it turned out to be possible =), so if you've missed this feature too you can now enjoy it by following this procedure

### Setup

    $ sudo add-apt-repository ppa:minos-archive/main #only Ubuntu LTS releases
    $ sudo apt-get update && sudo apt-get install bash-minos-settings
    $ echo 'set -o vi' >> ~/.bashrc

If you're not interested in installing the whole enchilada or aren't running an apt-get powered OS, you can get the raw inputrc file at:

 - [https://github.com/minos-org/bash-minos-settings/blob/master/etc.inputrc](https://github.com/minos-org/bash-minos-settings/blob/master/etc.inputrc)

In the later case, the inputrc file should be placed at **~/.inputr** or **/etc/inputrc**

Happy editing &#128523;
