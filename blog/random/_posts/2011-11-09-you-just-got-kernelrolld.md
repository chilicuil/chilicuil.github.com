---
layout: post
title: "you just got kernelroll'd ;)"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

[![alt text](/assets/img/56.png)](/assets/img/56.png)

Esto ha sido demasiado bueno para dejarlo olvidado en las quicknews, rickrolling en el espacio del kernel, intercepta cualquier llamada para abrir archivos multimedia y los reemplaza por rickrolling.mp3 ;)

Para Ubuntu 10.04:

<pre class="sh_sh">
$ sudo apt-get install systemtap
</pre>

systemtap requiere de los [simbolos](http://en.wikipedia.org/wiki/Debug_symbol) del kernel, [no instalables](https://bugs.launchpad.net/ubuntu/+source/linux/+bug/289087) a través de los repositorios para **lucid**, sin embargo accesibles desde: <http://ddebs.ubuntu.com/pool/main/l/linux/>

Para mi caso particular

<pre class="sh_sh">
$ sudo dpkg -l|grep linux-image
  ii  linux-image-2.6.32-34-generic
$ uname -m
  x86_64
</pre>

Por lo tanto (~450MB):

<pre class="sh_sh">
$ wget <a href="http://ddebs.ubuntu.com/pool/main/l/linux/linux-image-2.6.32-34-generic-dbgsym_2.6.32-34.77_amd64.ddeb" target="_blank">http://ddebs.ubuntu.com/pool/main/l/linux/linux-image-2.6.32-34...ddeb</a>
$ sudo dpkg -i linux-image-2.6.32-34-generic-dbgsym_2.6.32-34.77_amd64.ddeb
</pre>

Después de lo cual lo que se escribe en: <http://blog.yjl.im/2011/09/kernelroll.html> tendrá sentido:

<pre class="sh_sh">
$ sudo stap -e 'probe kernel.function("do_filp_open")\
 { p = kernel_string($pathname); l=strlen(p); \
 ext = substr(p, l - 4, l); if (ext == ".mp3" || ext == ".ogg" \
 || ext == ".mp4") { system("mplayer /path/to/rirckroll.mp3"); }}'
</pre>

De paso aprendí­ que [stap](http://sources.redhat.com/systemtap/) sirve para compilar módulos del kernel al momento y cargarlos.
