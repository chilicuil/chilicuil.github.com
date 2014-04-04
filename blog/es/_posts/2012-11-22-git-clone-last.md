---
layout: post
title: "descargar solo la última versión de un proyecto git"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

Mantengo algunos archivos de configuración y scripts en un repositorio git, cuando quiero copiarlos a otra computadora utilizo:

<pre class="sh_sh">
$ git clone url
</pre>

Esto descarga una copia exacta del repositorio, lo cual es bueno si quiero ver el historial o quiero modificar la configuración, sin embargo en algunas ocaciones lo único que quiero es poder usarlo lo más rápido posible, en ese caso, hay que pedir a git que unicamente descargue la última revisión:

<pre class="sh_sh">
$ git clone --dept=1 git://github.com/chilicuil/dotfiles.git
</pre>

- <http://stackoverflow.com/questions/1209999/using-git-to-get-just-the-latest-revision>
