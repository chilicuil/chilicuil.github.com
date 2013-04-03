---
layout: post
title: "conexión alámbrica e inalámbrica al mismo tiempo con wicd"
---

## {{ page.title }}
<p class="date">{{ page.date | date_to_string }}</p>

<div class="p">Cuando se esta usando <a href="http://wicd.sourceforge.net" target="_blank">wicd</a>, se pueden configurar 2 conexiones al mismo tiempo editando <strong>/etc/network/interfaces</strong>:
</div>

<pre class="sh_sh">
$ cat /etc/network/interfaces
  auto eth0
  iface eth0 inet static
          address 10.0.0.1
          netmask 255.255.255.0
          network 10.0.0.0
          broadcast 10.0.0.255
</pre>

<div class="p">Y luego eliminando la conexión alámbrica desde |propiedades| en wicd, la máquina se conectará a la red inalámbrica usando wicd y usará ifup/ifdown para configurar la interfaz ethernet.  
</div>

<ul>
    <li><a href="https://bugs.launchpad.net/wicd/+bug/228578">https://bugs.launchpad.net/wicd/+bug/228578</a></li>
</ul>
