---
layout: post
title: "detener la creación automática de Desktop por firefox"
---

## {{ page.title }}
<p class="date">{{ page.date | date_to_string }}</p>

<div class="p">La creación de la carpeta 'Desktop/Escritorio' por firefox es una característica un tanto molesta para algunos (incluyendome) cuya estructura de directorios pueda diferir.
</div>

<div class="p">Firefox sigue las reglas de <a href="http://www.freedesktop.org/wiki/Software/xdg-user-dirs">freedesktop.org</a> y crea o usa el directorio cada vez que se encuentra con un elemento &lt;input type='file'&gt;, para detener ese comportamiento, basta con crear un archivo en <strong>$HOME/.config/user-dirs.dirs</strong> con lo siguiente:
</div>

<pre class="sh_sh">
$ cat $HOME/.config/user-dirs.dirs
XDG_DESKTOP_DIR="$HOME/./"
</pre>

<ul>
	<li><a href="https://bbs.archlinux.org/viewtopic.php?id=117829" target="_blank">https://bbs.archlinux.org/viewtopic.php?id=117829</a></li>
</ul>
