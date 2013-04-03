---
layout: post
title: "correr aplicaciones X desde un chroot"
---

## {{ page.title }}
<p class="date">{{ page.date | date_to_string }}</p>

<div class="p">Ya había escrito <a href="http://chilicuil.github.com/all/os/2011/11/09/compilar-software-sin-ensuciar-el-sistema.html">anteriormente</a> sobre como compilar programas sin 'ensuciar' el sistema con dependencias, hoy lo haŕe sobre como hacerlo utilizando herramientas gráficas.
</div>

<div class="p"><a href="http://www.lazarus.freepascal.org/">Lazarus</a> es un ide de pascal, <a href="http://magnifier.sourceforge.net/">magnifier</a> es una lupa minimalista, la única que he podido integrar con <a href="http://chilicuil.github.com/all/random/2010/06/16/i3-ebf3.html">i3</a>.
</div>

<div class="p">Hace poco magnifier dejo de funcionar, así que tuve que recompilarla, sin embargo la única forma que conocía era a través de Lazarous, Lazarous es una aplicacion gui, para hacerla funcionar desde el chroot utilicé '<a href="http://linux.about.com/library/cmd/blcmdl_xhost.htm">xhost</a>' desde FUERA del chroot:
</div>

<pre class="sh_sh">
$ xhost + #lo que hará que X acepte cualquier conexión, incluyendo la del chroot
</pre>

<div class="p">Y luego dentro del chroot:
</div>

<pre class="sh_sh">
[chroot] # export DISPLAY=:0.0
</pre>

<div class="p">Después de lo cual he podido correr:
</div>

<pre class="sh_sh">
[chroot] # lazarous-ide
</pre>

<div class="p">Una vez compilado, he podido copiar y usar magnifier satisfactoriamente en el sistema original, dejo el <a href="http://ubuntuone.com/1pA0A2gDBxfQQdxZVGuuTq">binário</a> para amd64 para el que quiera usarlo.
</div>
