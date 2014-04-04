---
layout: post
title: "conexión alámbrica e inalámbrica al mismo tiempo con wicd"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

Cuando se esta usando [wicd](http://wicd.sourceforge.net), se pueden configurar 2 conexiones al mismo tiempo editando **/etc/network/interfaces**:

<pre class="sh_sh">
$ cat /etc/network/interfaces
  auto eth0
  iface eth0 inet static
          address 10.0.0.1
          netmask 255.255.255.0
          network 10.0.0.0
          broadcast 10.0.0.255
</pre>

Y luego eliminando la conexión alámbrica desde |propiedades| en wicd, la máquina se conectará a la red inalámbrica usando wicd y usará ifup/ifdown para configurar la interfaz ethernet.  

- [https://bugs.launchpad.net/wicd/+bug/228578](https://bugs.launchpad.net/wicd/+bug/228578)
