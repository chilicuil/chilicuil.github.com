---
layout: post
title: "kernel -ck en ubuntu precise"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

###UPDATE: 05/Nov/2013, el script se ha actualizado para compilar la version 3.11.7 del kernel

**[ck](http://ck-hack.blogspot.mx/)** es la extensión de los parches de [Con Kolivas](http://en.wikipedia.org/wiki/Con_Kolivas) para incrementar el rendimiento de Linux en PC's y laptops "normales". Tradicionalmente el kernel viene optimizado para servidores, clusters, y mainframes, de ahí que estos parches sean populares entre las personas que desean mejorar su entorno para juegos, multimedia y trabajo ordinario (navegación en internet, edición de textos, mensajería instantanea, etc).

Se ha discutido un par de veces si deberían incluirse en los repositorios de Ubuntu, sin embargo hasta el momento no se ha llegado a ningún acuerdo principalmente porque no hay suficientes personas para mantenerlos, lo único que existe son algunos ppa's, y todos ellos estan desactualizados. Uno de los últimos intentos fue:

- [https://lists.launchpad.net/ck-patchset/msg00019.html](https://lists.launchpad.net/ck-patchset/msg00019.html)

Los pasos para compilar un kernel con estas modificaciones son:

- Descargar el kernel vanilla
- Descargar y aplicar los parches: -ubuntu, -bfq, -ck
- Configurar el kernel
- Compilar
- Instalar

Afortunadamente los usuarios de ubuntu-br.org han estado siguiendo la discusión de cerca, y han creado un script que automatiza el proceso:

- [http://ubuntuforum-br.org/index.php/topic,29799.0.html](http://ubuntuforum-br.org/index.php/topic,29799.0.html)
- [http://sourceforge.net/projects/scriptkernel/files/](http://sourceforge.net/projects/scriptkernel/files/)

Después de revisarlo, lo he modificado un poco (para evitar algunos errores y agregar un par de cosas) y lo he puesto en:

- [https://github.com/chilicuil/learn/blob/master/sh/is/kernel-ck-ubuntu](https://github.com/chilicuil/learn/blob/master/sh/is/kernel-ck-ubuntu)

La idea es que cada tanto revise el script y lo modifique para tener siempre la última versión de los parches para la última versión LTS de Ubuntu, al menos hasta que aprenda a empaquetarlo para subirlo a un ppa, si desean usarlo pueden descargarlo y ejecutarlo así:

<pre class="sh_sh">
$ wget https://raw.github.com/chilicuil/learn/master/sh/is/kernel-ck-ubuntu
$ time bash kernel-ck-ubuntu
$ sudo dpkg -i ./linux-*.deb
</pre>

**[![](/assets/img/59.png)](/assets/img/59.png)**

Y reiniciar el equipo

Si no desean compilarlo, he preparado paquetes para amd64 y para x86

*3.4.5*

- [amd64](http://f.javier.io/rep/deb/3.4.5-ck-amd64.tar.bz2)
- [x86](http://f.javier.io/rep/deb/3.4.5-ck-i386.tar.bz2)

*3.7.1*

- [amd64](http://f.javier.io/rep/deb/3.7.1-ck-i386.tar.bz2)
- [x86](http://f.javier.io/rep/deb/3.7.1-ck-amd64.tar.bz2)

*3.8.2*

- [amd64](http://f.javier.io/rep/deb/3.8.2-ck-amd64.tar.bz2)
- [x86](http://f.javier.io/rep/deb/3.8.2-ck-i386.tar.bz2)

*3.9.2*

- [amd64](http://f.javier.io/rep/deb/3.9.2-ck-amd64.tar.bz2)
- [x86](http://f.javier.io/rep/deb/3.9.2-ck-i386.tar.bz2)

*3.11.7*

- [amd64](http://f.javier.io/rep/deb/3.11.7-ck-amd64.tar.bz2)
- [x86](http://f.javier.io/rep/deb/3.11.7-ck-i386.tar.bz2)

*3.12.1*

- [amd64](http://f.javier.io/rep/deb/3.12.1-ck-amd64.tar.bz2)
- [x86](http://f.javier.io/rep/deb/3.12.1-ck-i386.tar.bz2)

*3.13.7*

- [amd64](http://f.javier.io/rep/deb/3.13.7-ck-i386.tar.bz2)
- [x86](http://f.javier.io/rep/deb/3.13.7-ck-amd64.tar.bz2)
