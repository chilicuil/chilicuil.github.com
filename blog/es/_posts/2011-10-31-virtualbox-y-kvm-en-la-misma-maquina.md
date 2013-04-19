---
layout: post
title: "virtualbox y kvm en la misma máquina"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

**[![](/assets/img/55.png)](/assets/img/55.png)**

La imagen de arriba es el error que sale cada vez que se intenta correr VirtualBox cuando KVM esta instalado, en algunos foros sugieren desinstalar kvm, sin embargo si se quieren usar ambas soluciones se pueden deshabilitar los módulos de uno, cuando se quiera usar el otro.

Para Ubuntu, cada vez que se quiera usar Virtualbox se deshabilitan los módulos de KVM:

<pre class="sh_sh">
$ sudo service qemu-kvm stop &amp&amp sudo service vboxdrv start
</pre>

Y visceversa:

<pre class="sh_sh">
$ sudo service vboxdrv stop &amp&amp sudo service qemu-kvm
 </pre>

Para otras distribuciones **rmmod/modprobe/lsmod** hacen el truco
