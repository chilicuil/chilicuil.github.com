---
layout: post
title: "you just got kernelroll'd ;)"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

**[![](/assets/img/56.png)](/assets/img/56.png)**

Rickrollin in kernel space &#9786;, this hack will intercept any system call to open multimedia files and replace them with rickrolling.mp3 &#128521;

To set it up in Ubuntu 10.04 you'll need systemtap:

<pre class="sh_sh">
$ sudo apt-get install systemtap
</pre>

Systemtap requires the kernel [debug symbols](http://en.wikipedia.org/wiki/Debug_symbol) who [cannot be installed](https://bugs.launchpad.net/ubuntu/+source/linux/+bug/289087) from the repositories in **lucid**, although they can be installed from <http://ddebs.ubuntu.com/pool/main/l/linux/>.

In this particular case I've installed the 2.6.32 kernel:

<pre class="sh_sh">
$ sudo dpkg -l|grep linux-image
  ii  linux-image-2.6.32-34-generic
$ uname -m
  x86_64
</pre>

Therefore I'll download the following files(~450MB):

<pre class="sh_sh">
$ wget http://ddebs.ubuntu.com/pool/main/l/linux/linux-image-2.6.32-34-generic-dbgsym_2.6.32-34.77_amd64.ddeb
$ sudo dpkg -i linux-image-2.6.32-34-generic-dbgsym_2.6.32-34.77_amd64.ddeb
</pre>

Upon completion, the hack can be enabled this way:

<pre class="sh_sh">
$ sudo stap -e 'probe kernel.function("do_filp_open")\
 { p = kernel_string($pathname); l=strlen(p); \
 ext = substr(p, l - 4, l); if (ext == ".mp3" || ext == ".ogg" \
 || ext == ".mp4") { system("mplayer /path/to/rirckroll.mp3"); }}'
</pre>

If you're curious about other stap user cases, take a look at the documentation:

- [http://sources.redhat.com/systemtap/](http://sources.redhat.com/systemtap/)
