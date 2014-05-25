---
layout: post
title: "kexec reboot"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

Since the 2.6 Linux kernel version came out, there is a new way to reboot quite fast. [Kexec](http://en.wikipedia.org/wiki/Kexec) is a new call system who replaces the running kernel with a new one without the need to go through the bios initialization process. It means than now you're able to reboot faster, taking away 20, 30 or even 60 seconds from the boot process.

To use it, the "kexec-tools" package must be installed and the option "CONFIG_KEXEC" enabled, after setting up the system, kexec can be used this way:

<pre class="sh_sh">
$ kexec -l /boot/vmlinuz --command-line="`cat /proc/cmdline`" --initrd=/boot/initrd
$ kexec -e
</pre>

The first line loads the kernel in memory and returns the control to the user, it's now up to you to decide when to "reboot" the system (the second line will do it), [some persons](http://www.redhat.com/docs/en-US/Red_Hat_Enterprise_MRG/1.0/html/Realtime_Tuning_Guide/sect-Realtime_Tuning_Guide-Realtime_Specific_Tuning-Using_kdump_and_kexec_with_the_RT_kernel.html) are already using this technique to load new kernels when the running one panics.

In the current upstream implementation, kexec doesn't auto unmount the plugged devices, so it's must be done manually:

<pre class="sh_sh">
$ kexec -l /boot/vmlinuz --command-line="`cat /proc/cmdline`" --initrd=/boot/initrd
$ sync
$ umount -a
$ kexec -e
</pre>

Fortunately the Debian/Ubuntu maintainers had already integrated this logic on the reboot/halt scripts and therefore it's now possible to reboot the system without unmounting anything:

<pre class="sh_sh">
$ kexec -l /boot/vmlinuz --command-line="`cat /proc/cmdline`" --initrd=/boot/initrd
$ shutdown -r now
</pre>

In [OpenSuse 11.1](http://lizards.opensuse.org/2008/10/13/automatic-reboot-with-kexec/">) kexec may even be an opt-in. The day where I never shutdown my computer gets closer.

- <http://www.ibm.com/developerworks/linux/library/l-kexec.html>
- <http://www.linux.com/feature/150202>
- <http://lwn.net/Articles/15468/>
- <http://code.google.com/p/atv-bootloader/wiki/Understandingkexec>
