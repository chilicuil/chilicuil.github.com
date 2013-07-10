---
layout: post
title: "detener la creación automática de Desktop por firefox"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

La creación de la carpeta 'Desktop/Escritorio' por firefox es una característica un tanto molesta para algunos (incluyendome) cuya estructura de directorios pueda diferir.

Firefox sigue las reglas de [freedesktop.org](http://www.freedesktop.org/wiki/Software/xdg-user-dirs) y crea o usa el directorio cada vez que se encuentra con un elemento &lt;input type='file'&gt;, para detener ese comportamiento, se crea un archivo en **$HOME/.config/user-dirs.dirs** con lo siguiente:

<pre class="sh_sh">
$ cat $HOME/.config/user-dirs.dirs
XDG_DESKTOP_DIR="$HOME/./"
</pre>
