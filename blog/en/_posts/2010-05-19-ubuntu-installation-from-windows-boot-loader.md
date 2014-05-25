---
layout: post
title: "install ubuntu from the windows boot loader"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

I got a new netbook some weeks ago, I tested it fully for a month to verify the hardware didn't have any defects, and decided to move on with the recent Ubuntu 10.04 release.

The machine came pre-installed with Windows and I didn't have any cd/usb available so I decided to use the system itself to install Ubuntu. The first step was to download [grub4dos](http://grub4dos.sourceforge.net/), uncompress it and copy **grldr** and menu.lst (grub loader) to **C:**

**[![](/assets/img/26.png)](/assets/img/26.png)**
**[![](/assets/img/27.png)](/assets/img/27.png)**

Then I created a **C:\boot\grub** directory and saved initrd (installer) and linux (kernel) in **C:\boot**

For the x86 architecture, the files can be downloaded from:

- [http://archive.ubuntu.com/ubuntu/dists/lucid/main/installer-i386/current/images/netboot/ubuntu-installer/i386/initrd.gz](http://archive.ubuntu.com/ubuntu/dists/lucid/main/installer-i386/current/images/netboot/ubuntu-installer/i386/initrd.gz)
- [http://archive.ubuntu.com/ubuntu/dists/lucid/main/installer-i386/current/images/netboot/ubuntu-installer/i386/linux](http://archive.ubuntu.com/ubuntu/dists/lucid/main/installer-i386/current/images/netboot/ubuntu-installer/i386/linux)

For amd64:

- [http://archive.ubuntu.com/ubuntu/dists/lucid/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/initrd.gz](http://archive.ubuntu.com/ubuntu/dists/lucid/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/initrd.gz)
- [http://archive.ubuntu.com/ubuntu/dists/lucid/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/linux](http://archive.ubuntu.com/ubuntu/dists/lucid/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/linux)

**[![](/assets/img/28.png)](/assets/img/28.png)**

Afterwards I copied **C:\menu.lst** to **C:\boot\grub** and edit it this way:

**[![](/assets/img/29.png)](/assets/img/29.png)**

Finally I added the entry to the Windows loader and rebooted the system:

**[![](/assets/img/30.png)](/assets/img/30.png)**
**[![](/assets/img/31.png)](/assets/img/31.png)**
**[![](/assets/img/32.png)](/assets/img/32.png)**
**[![](/assets/img/33.png)](/assets/img/33.png)**

At startup a new entry called **Start GRUB** will showed up. That's it, it will bring up the rest of the process.

WARNING: This method requires an Internet connection through a wired interface, it may work with some wifi cards but the installer won't recognize most of them so it's better not to rely on it.

- [https://help.ubuntu.com/community/Installation/FromWindows](https://help.ubuntu.com/community/Installation/FromWindows)
