---
layout: post
title: "virtualbox and kvm sideways"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

**[![](/assets/img/55.png)](/assets/img/55.png)**

The above image contain a common error persons have whenever they try to use VirtualBox and KVM at the same time. Some forum posts suggest to uninstall kvm, however it's quite simple to keep both solutions installed sideways.

In Ubuntu, everytime VirtualBox is going to be used, KVM kernel modules should be disabled:

<pre class="sh_sh">
$ sudo service qemu-kvm stop &amp;&amp; sudo service vboxdrv start
</pre>

And viceversa:

<pre class="sh_sh">
$ sudo service vboxdrv stop &amp;&amp; sudo service qemu-kvm
</pre>

For other distributions, **rmmod/modprobe/lsmod** can do the job &#128521;
