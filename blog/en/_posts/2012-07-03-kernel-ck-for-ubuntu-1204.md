---
layout: post
title: "kernel -ck for ubuntu precise"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

**UPDATE: 19/May/2014, the script was updated to compile the 3.14.4 kernel version**

**[ck](http://ck-hack.blogspot.mx/)** is the name for the Con Kolivas patchet which main purpose is to increment the performance for Linux in PC’s and laptops. Traditionally the kernel comes with a lot of things for enterprise environments, that’s why this patchset have some relative popularity with people who wants to improve their machine for games, multimedia and tradicional work (browsing the web, editing texts, im, etc).

The steps to compile a kernel with these modifications are:

    Download the vanilla kernel
    Download and apply the: -bfq, -ck patchsets
    Configure the kernel
    Compile
    Install

Fortunately some users at ubuntu-br.org have been following the -ck branch, close enough to create a script that automatize the process:

    Kernel Omnislash (Unofficial) – Aprendendo a voar sem segredos!!! (learning to fly without secrets)
    http://sourceforge.net/projects/scriptkernel/files/

After check it out, I’ve edited it (to avoid some errors and to add some bells and whistles) and I’ve put the result in: https://github.com/chilicuil/learn/blob/master/sh/is/kernel-ck-ubuntu
The idea is that from time to time I check the script to see that it compiles the last -ck patchset version for the last Ubuntu LTS version. If you want to try it, run the following commands:

<pre class="sh_sh">
$ wget https://raw.github.com/chilicuil/learn/master/sh/is/kernel-ck-ubuntu
$ time bash kernel-ck-ubuntu
$ sudo dpkg -i ./linux-*.deb
</pre>

**[![](/assets/img/59.png)](/assets/img/59.png)**

And reboot your system, if you don’t want to compile it yourself, I’ve build some .deb packages for amd64 and x86 &#128519; 

*3.4.5*

- [amd64](http://f.javier.io/rep/deb/3.4.5-ck-amd64.tar.bz2)
- [x86](http://f.javier.io/rep/deb/3.4.5-ck-i386.tar.bz2)

*3.7.1*

- [amd64](http://f.javier.io/rep/deb/3.7.1-ck-i386.tar.bz2)
- [x86](http://f.javier.io/rep/deb/3.7.1-ck-amd64.tar.bz2)

*3.8.2*

- [amd64](http://f.javier.io/rep/deb/3.8.2-ck-amd64.tar.bz2)
- [x86](http://f.javier.io/rep/deb/3.8.2-ck-i386.tar.bz2)

*3.9.2*

- [amd64](http://f.javier.io/rep/deb/3.9.2-ck-amd64.tar.bz2)
- [x86](http://f.javier.io/rep/deb/3.9.2-ck-i386.tar.bz2)

*3.11.7*

- [amd64](http://f.javier.io/rep/deb/3.11.7-ck-amd64.tar.bz2)
- [x86](http://f.javier.io/rep/deb/3.11.7-ck-i386.tar.bz2)

*3.12.1*

- [amd64](http://f.javier.io/rep/deb/3.12.1-ck-amd64.tar.bz2)
- [x86](http://f.javier.io/rep/deb/3.12.1-ck-i386.tar.bz2)

*3.13.7*

- [amd64](http://f.javier.io/rep/deb/3.13.7-ck-i386.tar.bz2)
- [x86](http://f.javier.io/rep/deb/3.13.7-ck-amd64.tar.bz2)

*3.14.4*

- [amd64](http://f.javier.io/rep/deb/3.14.4-ck-amd64.tar.bz2)
- [x86](http://f.javier.io/rep/deb/3.14.4-ck-i386.tar.bz2)
