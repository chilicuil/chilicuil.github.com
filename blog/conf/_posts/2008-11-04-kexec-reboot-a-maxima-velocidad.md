---
layout: post
title: "kexec, rebooteando a máxima velocidad"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

<div class="p">Hace un ratito me acabo de enterar de que existe una manera de rebootear realmente rápido en Linux, y a estado ahí desde el comienzo de la rama 2.6. Se trata de Kexec un conjunto de llamadas al sistema, que reemplazan al kernel actual con el nuevo, saltandose a la bios y a la inicialización del hardware. Lo que en pocas palabras reducen el tiempo de booteo en 20, 30 y hasta en 60!!!!!! segundos.
</div>
<div class="p">Para usarse solo hay que instalar el packete "kexec-tools" y asegurarse de que tenemos habilitada su opción en el kernel "CONFIG_KEXEC" lo que muy probable ya este hecho.
</div>

<div class="p">Después de eso ya puede usarse de la siguiente forma:
</div>

<pre class="sh_sh">
$ kexec -l /boot/vmlinuz --command-line="`cat /proc/cmdline`" --initrd=/boot/initrd
$ kexec -e
</pre>

<div class="p">La primera línea carga el kernel y regresa la terminal, nosotros especificamos exactamente en que momento queremos pasarnos al nuevo kernel, de hecho he leído por <a href="http://www.redhat.com/docs/en-US/Red_Hat_Enterprise_MRG/1.0/html/Realtime_Tuning_Guide/sect-Realtime_Tuning_Guide-Realtime_Specific_Tuning-Using_kdump_and_kexec_with_the_RT_kernel.html">ahi</a> que lo usan para que cuando haya un kernel panic, salga otro al rescate.
</div>

<div class="p">La segunda lanza el segundo kernel, pero kexec no se preocupa de desmontar cuidadosamente los dispositivos y de cerrar los procesos, así que hay que hacerlo manualmente:
</div>

<pre class="sh_sh">
$ kexec -l /boot/vmlinuz --command-line="`cat /proc/cmdline`" --initrd=/boot/initrd
$ sync
$ umount -a
$ kexec -e
</pre>

<div class="p">Eso en caso de que tengas alguna distribución atrasada o poco usual, porque en las más populares, al instalar el paquete "kexec-tools" también modifica el script /etc/init.d/boot para que no haya pierde.
</div>

<pre class="sh_sh">
$ kexec -l /boot/vmlinuz --command-line="`cat /proc/cmdline`" --initrd=/boot/initrd
$ shutdown -r now
</pre>

<div class="p">En <a href="http://lizards.opensuse.org/2008/10/13/automatic-reboot-with-kexec/">openSuse 11.1</a> ya ni siquiera será necesario hacer eso, vendrá habilitado por default y en <a href="http://bugs.debian.org/cgi-bin/bugreport.cgi?bug">Debian</a> se habilita por defecto al instalarse.
</div>

<div class="p">Links relacionados:
</div>

<ul>
    <li><a href="http://www.ibm.com/developerworks/linux/library/l-kexec.html" target="_blank">http://www.ibm.com/developerworks/linux/library/l-kexec.html</a></li>
    <li><a href="http://www.linux.com/feature/150202" target="_blank">http://www.linux.com/feature/150202</a></li>
    <li><a href="http://ubuntuforums.org/showthread.php?t=785347" target="_blank">http://www.linux.com/feature/150202</a></li>
    <li><a href="http://lwn.net/Articles/15468/" target="_blank">http://lwn.net/Articles/15468/</a></li>
    <li><a href="http://code.google.com/p/atv-bootloader/wiki/Understandingkexec" target="_blank">http://code.google.com/p/atv-bootloader/wiki/Understandingkexec</a></li>
</ul>
