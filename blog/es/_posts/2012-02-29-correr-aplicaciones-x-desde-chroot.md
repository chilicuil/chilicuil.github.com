---
layout: post
title: "correr aplicaciones X desde un chroot"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

Ya había escrito [anteriormente](http://javier.io/blog/es/2011/11/09/compilar-software-sin-ensuciar-el-sistema.html) sobre como compilar programas sin 'ensuciar' el sistema con dependencias, hoy lo haŕe sobre como hacerlo utilizando herramientas gráficas.

[Lazarus](http://www.lazarus.freepascal.org/) es un ide de pascal, [magnifier](http://magnifier.sourceforge.net/) es una lupa minimalista, la única que he podido integrar con [i3](http://javier.io/blog/es/2010/06/16/i3-ebf3.html).

Hace poco magnifier dejo de funcionar, así que tuve que recompilarla, sin embargo la única forma que conocía era a través de Lazarous, Lazarous es una aplicacion gui, para hacerla funcionar desde el chroot utilicé '[xhost](http://linux.about.com/library/cmd/blcmdl_xhost.htm)' desde FUERA del chroot:

<pre class="sh_sh">
$ xhost + #lo que hará que X acepte cualquier conexión, incluyendo la del chroot
</pre>

Y luego dentro del chroot:

<pre class="sh_sh">
[chroot] # export DISPLAY=:0.0
</pre>

Después de lo cual he podido correr:

<pre class="sh_sh">
[chroot] # lazarous-ide
</pre>

Una vez compilado, he podido copiar y usar magnifier satisfactoriamente en el sistema original, dejo el [binário](http://f.javier.io/repository/s/magnifier.bin) para amd64 para el que quiera usarlo.
