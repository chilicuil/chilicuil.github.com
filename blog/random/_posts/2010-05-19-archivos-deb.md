---
layout: post
title: "archivos .deb"
---

<h2>{{ page.title }}</h2>

<div class="publish_date">{{ page.date | date_to_string }}</div>
<!--<div class="publish_date">19 May 2010</div>-->

<div class="p">Los archivos .deb son en realidad <a href="http://en.wikipedia.org/wiki/Ar_%28Unix%29">contenedores ar</a> lo que los diferencia a parte de la extensión, es que integran 3 binarios:
</div>

<ul>
	<li>debian-binary: la versión del paquete, actualmente la 2.0</li>
	<li>control.tar.gz: la <a href="http://en.wikipedia.org/wiki/Cryptographic_hash_function">sumatoria</a> de verificación, descripción y los scripts <a href="http://www.debian.org/doc/FAQ/ch-pkg_basics.html">post y pre</a> de instalación / eliminación</li>
	<li>data.tar.gz: el programa (en formato binario), con una estructura de directorios que mimetiza el entorno.</li>
</ul>

<div class="p">NOTA: Modificar directamente un archivo .deb no es la forma adecuada de hacer cambios a los programas del sistema, y debe utilizarse solo en caso extremo. Para una guía de como hacerlo de la forma adecuada, vease la guía de empaquetamiento de Debian:
</div>

<ul>
	<li><a href="http://wiki.debian.org/HowToPackageForDebian" target="_blank">http://wiki.debian.org/HowToPackageForDebian</a></li>
</ul>

<div class="p">Si no es la forma adecuada, ¿por qué alguien querría modificarlo así?, no conozco las razones de otras personas, pero en mi caso, existe un archivo llamado <em>firefox-launchpad-plugin_0.4_all.deb</em> que depende de firefox para ser instalado. No tengo instalado firefox desde los repositorios porque es de los pocos programas que tienen un ciclo de actualización mucho más rápido que el de ubuntu. El plugin, contiene la definición de algunas máquinas de búsqueda que integran a <a href="https://launchpad.net" target="_blank">https://launchpad.net</a> con firefox.
</div>

<div class="p">Sin embargo siendo un archivo ar, puedo modificarlo y obtener únicamente las partes que me interesen. Para comprimirse / descomprimirse se utilizan los comandos:
</div>

<pre class="sh_sh">
$ ar xv firefox-launchpad-plugin_0.4_all.deb
  x - debian-binary
  x - control.tar.gz
  x - data.tar.gz
#se modifican archivos

$ ar r firefox-launchpad-plugin_0.4_all.deb debian-binary control.tar.gz data.tar.gz
  ar: creating firefox-launchpad-plugin_0.4_all.deb
</pre>

<div class="p">Para este caso particular, podría comenzar descargando el archivo:
</div>

<pre class="sh_sh">
$ apt-get download firefox-launchpad-plugin
</pre>

<div class="p">Luego descomprimirlo:
</div>

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

<div class="p">Y con los archivos en la mano, ponerlos en el lugar adecuado:
</div>

<pre class="sh_sh">
$ find ~/.mozilla/ -type d  -iname searchplugins
  /home/chilicuil/.mozilla/firefox/h5xyzl6e.default/searchplugins

$ mv ./usr/lib/firefox-addons/searchplugins/* \
  ~/.mozilla/firefox/h5xyzl6e.default/searchplugins/
</pre>

<div class="p">El resultado final es:
</div>

<div style="text-align: center;">
    <img src="/assets/img/34.png">
</div>

<ul>
    <li>
    <a href="https://synthesize.us/HOWTO_make_a_deb_archive_without_dpkg">https://synthesize.us/HOWTO_make_a_deb_archive_without_dpkg</a></li>
</ul>
