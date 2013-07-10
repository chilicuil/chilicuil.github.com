---
layout: post
title: "archivos .deb"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

Los archivos .deb son en realidad [contenedores ar](http://en.wikipedia.org/wiki/Ar_%28Unix%29) lo que los diferencia a parte de la extensión, es que integran 3 binarios:

- debian-binary: la versión del paquete, actualmente la 2.0
- control.tar.gz: la [sumatoria](http://en.wikipedia.org/wiki/Cryptographic_hash_function) de verificación, descripción y los scripts [post y pre](http://www.debian.org/doc/FAQ/ch-pkg_basics.html) de instalación / eliminación
- data.tar.gz: el programa (en formato binario), con una estructura de directorios que mimetiza el entorno

NOTA: Modificar directamente un archivo .deb no es la forma adecuada de hacer cambios a los programas del sistema, y debe utilizarse solo en caso extremo. Para una guía de como hacerlo de la forma adecuada, vease la guía de empaquetamiento de Debian:

- http://wiki.debian.org/HowToPackageForDebian

Si no es la forma adecuada, ¿por qué alguien querría modificarlo así?, no conozco las razones de otras personas, pero en mi caso, existe un archivo llamado **firefox-launchpad-plugin_0.4_all.deb** que depende de firefox para ser instalado. No tengo instalado firefox desde los repositorios porque es de los pocos programas que tienen un ciclo de actualización mucho más rápido que el de ubuntu. El plugin, contiene la definición de algunas máquinas de búsqueda que integran a <https://launchpad.net> con firefox

Sin embargo siendo un archivo ar, puedo modificarlo y obtener únicamente las partes que me interesen. Para comprimirse / descomprimirse se utilizan los comandos:

<pre class="sh_sh">
$ ar xv firefox-launchpad-plugin_0.4_all.deb
  x - debian-binary
  x - control.tar.gz
  x - data.tar.gz
#se modifican archivos

$ ar r firefox-launchpad-plugin_0.4_all.deb debian-binary control.tar.gz data.tar.gz
  ar: creating firefox-launchpad-plugin_0.4_all.deb
</pre>

Para este caso particular, podría comenzar descargando el archivo:

<pre class="sh_sh">
$ apt-get download firefox-launchpad-plugin
</pre>

Luego descomprimirlo:

<pre class="sh_sh">
$ ar xv firefox-launchpad-plugin_0.4_all.deb
  x - debian-binary
  x - control.tar.gz
  x - data.tar.gz

$ tar zxvf data.tar.gz
  ./
  ./usr/
  ./usr/lib/
  ./usr/lib/firefox-addons/
  ./usr/lib/firefox-addons/searchplugins/
  ./usr/lib/firefox-addons/searchplugins/launchpad-bug-lookup.xml
  ./usr/lib/firefox-addons/searchplugins/launchpad-bugs.xml
  ./usr/lib/firefox-addons/searchplugins/launchpad-package-bugs.xml
  ./usr/lib/firefox-addons/searchplugins/launchpad-packages.xml
  ./usr/lib/firefox-addons/searchplugins/launchpad-people.xml
  ./usr/lib/firefox-addons/searchplugins/launchpad-specs.xml
  ./usr/lib/firefox-addons/searchplugins/launchpad-support.xml
</pre>

Y con los archivos en la mano, ponerlos en el lugar adecuado:

<pre class="sh_sh">
$ find ~/.mozilla/ -type d  -iname searchplugins
  /home/chilicuil/.mozilla/firefox/h5xyzl6e.default/searchplugins

$ mv ./usr/lib/firefox-addons/searchplugins/* \
  ~/.mozilla/firefox/h5xyzl6e.default/searchplugins/
</pre>

El resultado final es:

**[![](/assets/img/34.png)](/assets/img/34.png)**

- https://synthesize.us/HOWTO_make_a_deb_archive_without_dpkg
