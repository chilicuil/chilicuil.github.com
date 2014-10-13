---
layout: post
title: "improve boot performance in Ubuntu Precise and above"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

The project [e4rat](http://e4rat.sourceforge.net/) develops tools who improve the boot process in Linux, to do so, it takes advantage of the reassignment of files in [ext4](http://es.wikipedia.org/wiki/Ext4) if you're not using ext4 it won't work. It won't work neither if you are using [solid state drives](http://en.wikipedia.org/wiki/Solid-state_drive), for those disks [ureadahead](https://launchpad.net/ureadahead) (installed by default) already do a great job.

### Introduction

A lot of the time who is allocated at the boot process is wasted booting and initializing hard drives (it doesn't happen in ssds) you can see it by yourself with [bootchart](http://www.bootchart.org/).

**[![](/assets/img/66.png)](/assets/img/66.png)**

The red graph represent the time waiting for the hard drive and the blue one the time is cpu is being used.

**e4rat** technique move critical files (for the booting process) alongside so these files can be loaded with minimal machinery to the hard drives. After loading them in ram, the time required to read them will drop significantly.

**[![](/assets/img/67.png)](/assets/img/67.png)**

This a graph of the same system after using *e4rat*.

The process should be repeated every time a kernel upgrade is done or when non simple updates have been applied.

### Installation

**e4rat** requires at least a 2.6.31 linux kernel, in Ubuntu such kernels are distributed since Ubuntu 11.04. Fortunately the project provides .deb packages so the installation process is quite simple, grab the appropriate version for your cpu architecture from:

- <http://sourceforge.net/projects/e4rat/files>

Before installing **e4rat** you will need ensure **ureadahead** has been completely removed, to do so in Debian/Ubuntu run:

<pre class="sh_sh">
$ sudo apt-get purge ureadahead
</pre>

The system will ask to uninstall **ubuntu-minimal** too. Let it continue, ubuntu-minimal is a meta-package who doesn't contain anything by itself, it's useful however during the OS installation process to bring with it a bunch of packages.

After removing completely ureadahead, **e4rat** can be installed with dpkg:

<pre class="sh_sh">
$ sudo dpkg -i e4rat_0.2.3_amd64.deb
</pre>

### Configuration

For **e4rat** to work it needs to recognize which files are been used at the boot process, to do so add the **init=/sbin/e4rat-collect** string to the **kernel** line in **/boot/grub/menu.lst** or the equivalent file for grub2, etc:

<pre class="config">
title   Ubuntu 12.04.2 LTS, kernel 3.8.2-ck1
uuid    793e9a6d-d545-46f0-ac9c-49071c450b62
kernel  ... ro init=/sbin/e4rat-collect
initrd  /boot/initrd.img-3.8.2-ck1
quiet
</pre>

> Upon rebooting launch as fast as possible your most common applications (web/file browsers?, terminal emulator?, etc), e4rat will add to its index the files loaded in memory in the first 2 minutes after booting.

> Review **/var/lib/e4rat/startup.log** to confirm it's such information.

<pre class="sh_sh">
$ file /var/lib/e4rat/startup.log
/var/lib/e4rat/startup.log: ASCII text
</pre>

### File reallocation

To this moment **e4rat** already know what files should be loaded at boot time, to relocate them reboot the system in recovery (or safe) mode.

> In my system the grub entry looks like this:

<pre class="config">
Ubuntu 12.04.2 LTS, kernel 3.8.2-ck1 (recovery mode)
</pre>

> Once loaded execute **e4rat-realloc** several times till the software indicates there are no more improvements possible

<pre class="sh_sh">
# e4rat-realloc /var/lib/e4rat/startup.log
...
...
No further improvements...
</pre>

> Replace **init=/sbin/e4rat-collect** with **init=/sbin/e4rat-preload**:

<pre class="config">
title   Ubuntu 12.04.2 LTS, kernel 3.8.2-ck1
uuid    793e9a6d-d545-46f0-ac9c-49071c450b62
kernel  ... ro plymouth:force-splash init=/sbin/e4rat-preload
initrd  /boot/initrd.img-3.8.2-ck1
quiet
</pre>

> Reboot

Done, now the boot process time should be faster and smoother &#128526;

### Uninstallation

If you find **4rat** too difficult to use or buggy, you can uninstall it by following the next steps:

<pre class="sh_sh">
$ sudo apt-get purge e4rat
$ sudo apt-get install ubuntu-minimal ureadahead
$ sudo vim /boot/grub/menu.lst #and remove init=/sbin/e4rat-preload
</pre>

- <http://rafalcieslak.wordpress.com/2013/03/17/e4rat-decreasing-bootup-time-on-hdd-drives>
