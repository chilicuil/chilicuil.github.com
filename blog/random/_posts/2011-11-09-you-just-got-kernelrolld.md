---
layout: post
title: "you just got kernelroll'd ;)"
---

## {{ page.title }}
<p class="date">{{ page.date | date_to_string }}</p>

<div align="center"><img src="/assets/img/56.png" style="width: 320px; height: 240px;">
</div>

<div class="p">Esto ha sido demasiado bueno para dejarlo olvidado en las quicknews, rickrolling en el espacio del kernel, intercepta cualquier llamada para abrir archivos multimedia y los reemplaza por rickrolling.mp3 ;)
</div>

<div class="p">Para Ubuntu 10.04:
</div>

<pre class="sh_sh">
$ sudo apt-get install systemtap
</pre>

<div class="p">systemtap requiere de los <a href="http://en.wikipedia.org/wiki/Debug_symbol">simbolos</a> del kernel, <a href="https://bugs.launchpad.net/ubuntu/+source/linux/+bug/289087">no instalables</a> a trav�s de los repositorios para <strong><u>lucid</u></strong>, sin embargo accesibles desde: <a href="http://ddebs.ubuntu.com/pool/main/l/linux/">http://ddebs.ubuntu.com/pool/main/l/linux/</a>
</div>

<div class="p">Para mi caso particular
</div>

<pre class="sh_sh">
$ sudo dpkg -l|grep linux-image
  ii  linux-image-2.6.32-34-generic
$ uname -m
  x86_64
</pre>

<div class="p">Por lo tanto (~450MB):
</div>

<pre class="sh_sh">
$ wget <a href="http://ddebs.ubuntu.com/pool/main/l/linux/linux-image-2.6.32-34-generic-dbgsym_2.6.32-34.77_amd64.ddeb" target="_blank">http://ddebs.ubuntu.com/pool/main/l/linux/linux-image-2.6.32-34...ddeb</a>
$ sudo dpkg -i linux-image-2.6.32-34-generic-dbgsym_2.6.32-34.77_amd64.ddeb
</pre>

<div class="p">Después de lo cual lo que se escribe en: <a href="http://blog.yjl.im/2011/09/kernelroll.html">http://blog.yjl.im/2011/09/kernelroll.html</a> tendrá sentido:
</div>

<pre class="sh_sh">
$ sudo stap -e 'probe kernel.function("do_filp_open")\
 { p = kernel_string($pathname); l=strlen(p); \
 ext = substr(p, l - 4, l); if (ext == ".mp3" || ext == ".ogg" \
 || ext == ".mp4") { system("mplayer /path/to/rirckroll.mp3"); }}'
</pre>

<div class="p">De paso aprendí que <a href="http://sources.redhat.com/systemtap/">stap</a> sirve para compilar módulos del kernel al momento y cargarlos.
</div>