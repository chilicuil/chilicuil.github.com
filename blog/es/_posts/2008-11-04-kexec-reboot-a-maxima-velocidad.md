---
layout: post
title: "kexec, rebooteando a máxima velocidad"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

Desde la version 2.6 de Linux existe una manera de reiniciar realmente rápido. Se trata de Kexec un conjunto de llamadas al sistema, que reemplazan al kernel actual con uno nuevo, evitando la bios y con ello la inicialización del hardware. Lo que en pocas palabras reducen el tiempo de reinicio en 20, 30 y hasta en 60! segundos.

Para usarse se debe instalar el packete "kexec-tools" y asegurarse de tener habilitada su opción en el kernel "CONFIG_KEXEC" lo que muy probable se autoconfigure (dependera de los mantenedores).

Después de eso ya se puede usar de la siguiente forma:

<pre class="sh_sh">
$ kexec -l /boot/vmlinuz --command-line="`cat /proc/cmdline`" --initrd=/boot/initrd
$ kexec -e
</pre>

La primera línea carga el kernel y regresa el control del sistema, despues se puede elegir en que momento hacer el reinicio, de hecho he leído por [ahi](http://www.redhat.com/docs/en-US/Red_Hat_Enterprise_MRG/1.0/html/Realtime_Tuning_Guide/sect-Realtime_Tuning_Guide-Realtime_Specific_Tuning-Using_kdump_and_kexec_with_the_RT_kernel.html) que lo usan para que cuando haya un kernel panic, salga otro al rescate.

Por otra parte, Kexec no se preocupa de desmontar cuidadosamente los dispositivos, así que hay que hacerlo manualmente:

<pre class="sh_sh">
$ kexec -l /boot/vmlinuz --command-line="`cat /proc/cmdline`" --initrd=/boot/initrd
$ sync
$ umount -a
$ kexec -e
</pre>

En Debian y Ubuntu el paquete "kexec-tools" contienen scripts que ya hacen eso, asi que en esos sistemas se puede ejecutar:

<pre class="sh_sh">
$ kexec -l /boot/vmlinuz --command-line="`cat /proc/cmdline`" --initrd=/boot/initrd
$ shutdown -r now
</pre>

En [OpenSuse 11.1](http://lizards.opensuse.org/2008/10/13/automatic-reboot-with-kexec/">) pronto estara habilitado por defecto.

- <http://www.ibm.com/developerworks/linux/library/l-kexec.html>
- <http://www.linux.com/feature/150202>
- <http://lwn.net/Articles/15468/>
- <http://code.google.com/p/atv-bootloader/wiki/Understandingkexec>
