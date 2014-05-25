---
layout: post
title: "remote environments normalization"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

I access a fair amount of remote environments through ssh, when I do it most of the times I end copying little bits of configuration files to make them easier to use. I do it so often than I created script to do it for me.

<pre class="sh_sh">
$ sh &lt;(wget -qO- javier.io/s)
</pre>

<iframe class="showterm" src="http://showterm.io/3bfc94afe0f51e8d6411f" width="640" height="350">&nbsp;</iframe> 

Some of my favorite changes are:

    [+] Installation of: byobu, vim-nox, curl, command-not-found, libpam-captcha, shundle and htop
    [+] Removal of services: sendemail, apache, bind, etc
    [+] Vim configuration
    [+] Wcd as a replacement to cd
    [+] +60 scripts:
        [+] pastebin,  $ cat file | pastebin
        [+] extract,   $ extract file.suffix
        [+] fu-search, $ fu-search grep
        [+] rm_,       $ rm .bashrc && rm -u .bashrc
        [+] uimg,      $ uimg image.png #img pastebin
        [+] ...

By default the script will backup(.old) any file before override it. Now all my new pristine environments are equal &#128522;

- [dotfiles](https://github.com/chilicuil/dotfiles/)
- [shundle](https://github.com/chilicuil/shundle)
- [utils](https://github.com/chilicuil/learn/)
