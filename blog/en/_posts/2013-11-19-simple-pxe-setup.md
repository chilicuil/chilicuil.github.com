---
layout: post
title: "simple pxe setup"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

**[![](/assets/img/87.jpg)](/assets/img/87.jpg)**

There are several ways to setup a [pxe](http://es.wikipedia.org/wiki/Preboot_Execution_Environment) (which are useful mostly for massive installations), this is my personal method. A preboot execution environment in 68KB with batteries included, pxelinux, dhcpd, tftp, and hands-free installation.

<iframe class="showterm" src="http://showterm.io/f2ac25e4df1e7ad5e989a" width="640" height="300">&nbsp;</iframe> 

<!--
   -<pre>
   -$ sh &lt;(wget -qO- https://raw.githubusercontent.com/chilicuil/learn/master/sh/tools/pxe)
   -[+] setting pxe environment in ./pxe_setup ...
   -  - creating ./pxe_setup/menu.c32 ...
   -  - creating ./pxe_setup/pxelinux.0 ...
   -  - creating ./pxe_setup/simple-dhcpd ...
   -  - creating ./pxe_setup/simple-tftpd ...
   -  - creating ./pxe_setup/pxelinux.cfg/default ...
   -  - creating ./pxe_setup/ubuntu/ubuntu.menu ...
   -  - creating ./pxe_setup/pxe/fedora/fedora.menu ...
   -  - creating ./pxe_setup/tools/tools.menu ...
   -</pre>
   -->

The above command is the heart of the system, a script who creates a directory structure with all the tools and menus required to boot at least ubuntu/fedora (it can personalized to boot other distros). After executing the script, you'll need to download two extra files; an initrd installer and a linux kernel.

As an example I'll download the Ubuntu 12.04 amd64 corresponding files:

- [linux](http://archive.ubuntu.com/ubuntu/dists/precise-updates/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/linux)
- [initrd.gz](http://archive.ubuntu.com/ubuntu/dists/precise-updates/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/initrd.gz)

<pre class="sh_sh">
$ sh &lt;(wget -qO- https://raw.githubusercontent.com/chilicuil/learn/master/sh/tools/pxe)
$ wget http://archive.ubuntu.com/.../amd64/initrd.gz -O pxe_setup/ubuntu/1204/amd64/initrd.gz
$ wget http://archive.ubuntu.com/.../amd64/linux     -O pxe_setup/ubuntu/1204/amd64/linux
</pre>

## Pxe enabled router

Some routers can forward pxe petitions, you can configure them to point all pxe request to the machine running the tftp server (who will provide the pxelinux.0 and other required files) to boot other systems. In this scenarios the ip assigned to the host where this setup was done needs to be entered in the router with the **pxelinux.0** string as path.

And start the tftp daemon in the source machine:

<pre class="sh_sh">
$ cd pxe_setup && sudo python ./simple-tftpd
</pre>

## Computer with at least 2 network interfaces

If the router cannot forward pxe requests or you don't have the permissions to do so, you can run a local dhcpd and connect to the target machines through a second network interface (the first one will be used to connect to Internet to download the installation files).

Let's imagine wlan0 and eth0 are the wireless and wired interfaces of a laptop, the first one is connected to Internet and the second one to other machines through a switch/router or directly. The first step on this scenario is to allow wlan0 to act as a bridge between the target computers and Internet:

<pre class="sh_sh">
$ sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
$ echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
</pre>

And assign a local ip to the wired interface (eth0):

<pre class="sh_sh">
$ while :; do sudo ifconfig eth0 10.99.88.1; sleep 3; done
</pre>

NOTE: In systems governed by [NetworkManager](https://wiki.gnome.org/Projects/NetworkManager) it's better to use its infrastructure or disable it completely before running the above command.

Finally, the dhcp and tftp daemons can be launched:

<pre class="sh_sh">
$ cd pxe_setup && sudo python ./simple-dhcpd -i eth0 -a 10.99.88.1
$ cd pxe_setup && sudo python ./simple-tftpd
</pre>

Upon booting the target machines will print a menu asking for a which system to install (ubuntu or fedora), sweet n_n/

## extra, hands-free

Most popular distributions support completely automated installations through preseed, kickstart, etc. This setup is no exception, it's been configured to provide a hands-free installation for Ubuntu. The preseed file used can be retrieved at:

- [http://people.ubuntu.com/~chilicuil/conf/preseed/minimal.preseed](http://people.ubuntu.com/~chilicuil/conf/preseed/minimal.preseed)

It supports two extra boot parameters:

- **proxy=http://url**, for using a proxy who doesn't break the installation process
- **user=joe**, for setting a default user (chilicuil by default)

## uninstallation

When the installation process ends, the pxe environmente can be easily removed with:

<pre class="sh_sh">
$ rm -rf pxe_setup
</pre>

Simple! &#128527; 

**Idea**: Create a vm with 2 network interfaces, the first one in *bridge* mode assigned to wlan0, and the second one in *bridge* / *internal network* assigned to eth0, configure this setup and take an snapshot for an instant pxe installer experience.

References:

- [https://github.com/psychomario/PyPXE](https://github.com/psychomario/PyPXE)
- [http://javier.io/blog/es/2010/12/14/compartir-conexion-pc-a-pc.html](http://javier.io/blog/es/2010/12/14/compartir-conexion-pc-a-pc.html)
