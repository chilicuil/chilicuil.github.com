---
layout: post
title: "mejorar el tiempo de arranque en ubuntu precise"
---

## {{ page.title }}
<p class="date">{{ page.date | date_to_string }}</p>

<p>Antes de empezar quiero aclarar que las siguientes instrucciones funcionan para Ubuntu desde la versión 11.04, hago énfasis en Ubuntu Precise porque es la versión LTS. Comparto los pasos porque en mi máquina se nota la diferencia incluso cuando mi configuración ya estaba <a href="http://chilicuil.github.com/all/os/2012/05/03/actualizacion-ubuntu-1204.html" target="_blank">optimizada</a> (kernel -ck, slim/i3wm), eso no quiere decir que funcione en la suya.</p>

<p>El proyecto <a href="http://e4rat.sourceforge.net/" target="_blank">e4rat</a> desarrolla herramientas que mejoran el tiempo de arranque en Linux, para ello se apoya en la reasignación de archivos de arranque en sistemas <a href="http://es.wikipedia.org/wiki/Ext4" target="_blank">ext4</a>, así que si no usan ext4, no servirá de nada. Tampoco servirá si sus discos son <a href="http://es.wikipedia.org/wiki/Unidad_de_estado_s%C3%B3lido" target="_blank">SSD</a> (de estado sólido), para esos discos <a href="https://launchpad.net/ureadahead" target="_blank">ureadahead</a> ya hace un buen trabajo.</p>

<h3>Introducción</h3>

<p>Mucho del tiempo que se invierte en arrancar una computadora se debe a la espera e inicialización de los discos duros (esto no aplica para la tecnología ssd), pueden verlo por ustedes mismos con la utilidad <a href="http://www.bootchart.org/" target="_blank">bootchart</a> que crea diagramas sobre el arranque de Linux.</p>

<p align="center" id="img"><a href="/assets/img/66.png"><img src="/assets/img/66.png" style="width: 606px;"></a></p>

<p>El rojo es el tiempo de espera del disco duro, el azul el tiempo de ejecución del cpu</p>

<p><strong>e4rat</strong> mueve los archivos críticos de arranque a una zona de fácil acceso en el disco duro para que esos archivos se carguen de una sola vez o en pocas lecturas a la ram. Una vez en la ram se continua el arranque y debido a que la ram es mucho más rápida, se mejora el tiempo de arranque.</p>

<p align="center" id="img"><a href="/assets/img/67.png"><img src="/assets/img/67.png" style="width: 606px;"></a></p>

<p>El rojo es el tiempo de espera del disco duro, el azul el tiempo de ejecución del cpu. Se nota una mejora considerable</p>

<p>Sabiendo esto, se comprende porque el procedimiento debe repetirse cada vez que se instala un nuevo kernel, o se hace una actualización mayor al sistema. También se comprende porque <strong>e4rat</strong> no funciona en distribuciones rolling release (arch, gentoo) o en distribuciones en desarrollo (Ubuntu raring), pues estos sistemas hacen constantes actualizaciones a los archivos de arranque.</p>

<h3>Desarrollo</h3>

<h4>Instalación</h4>

<p>Para poder tomar partido de <strong>e4rat</strong> se requiere una versión del kernel no menor a 2.6.31, en Ubuntu, desde la versión 11.04 se instalan kernels superiores, también funciona sobre el <a href="http://chilicuil.github.com/all/os/2012/07/03/kernel-ck-en-ubuntu-1204.html" target="_blank">kernel vanilla + ck</a> que recomiendo.</p>

<p>Si se cumple ese requisito entonces puede descargarse de:</p>

<ul>
        <li><a href="http://sourceforge.net/projects/e4rat/files/" target="_blank">http://sourceforge.net/projects/e4rat/files/</a></li>
</ul>

<p>Dependiendo de la arquitectura de su sistema, querran descargar la última versión de <strong>e4rat</strong> para x86 | amd64 en formato <strong>.deb</strong> (para una instalación fácil y limpia), en mi caso he descargado <strong>e4rat_0.2.3_amd64.deb</strong>. Antes de instalar el paquete, hay que desinstalar <strong>ureadahead</strong>.</p>

<pre class="sh_sh">
$ sudo apt-get purge ureadahead
</pre>

<p>Esto desinstalará también <strong>ubuntu-minimal</strong>, ojo: esto no causará ningún daño, <strong>ubuntu-minimal</strong> es un paquete <strong>vacío</strong> que se usa en Ubuntu para 'jalar' paquetes iniciales del sistema.</p>

<p>Una vez completado el paso anterior, se puede instalar <strong>e4rat</strong>:</p>

<pre class="sh_sh">
$ sudo dpkg -i e4rat_0.2.3_amd64.deb
</pre>

<h4>Configuración</h4>

<p>Reconocimiento de los habitos del sistema</p>

<p>Para que <strong>e4rat</strong> mejore el tiempo de arranque necesita conocer los archivos que se utilizan, lo que sigue son las instrucciones para hacer que el sistema arranque en un modo especial que le permitirá aprender de los hábitos del mismo, sugiero que cuando se haga se abran las aplicaciones que se usan con mayor frecuencia, por ejemplo firefox.</p>

<p> <strong>1.-</strong> Agregar el parámetro <strong>init=/sbin/e4rat-collect</strong> a la línea <strong>kernel</strong> en <strong>/boot/grub/menu.lst</strong> o a su equivalente en grub2, para mi caso:</p>

<pre class="config">
title   Ubuntu 12.04.2 LTS, kernel 3.8.2-ck1
uuid    793e9a6d-d545-46f0-ac9c-49071c450b62
kernel  /boot/vmlinuz-3.8.2-ck1 root=UUID=793e9a6d-d545-46f0-ac9c-49071c450b62 ro  init=/sbin/e4rat-collect
initrd  /boot/initrd.img-3.8.2-ck1
quiet
</pre>

<p><strong>2.-</strong> Reiniciar y lanzar durante los primeros 2 minutos las aplicaciones que se usen con mayor frecuencia</p>

<p><strong>3.-</strong> Verificar que se haya creado un archivo en <strong>/var/lib/e4rat/startup.log</strong>, este archivo contiene las estadísticas del sistema</p>

<pre class="sh_sh">
$ file /var/lib/e4rat/startup.log
/var/lib/e4rat/startup.log: ASCII text
</pre>

<p>Reasignación de archivos</p>

<p>Después de que <strong>e4rat</strong> conozca los hábitos del sistema, sigue la reasignación de los archivos (la parte que traerá la mejora en el rendimiento), para ello se:</p>

<p> <strong>1.-</strong> Reinicia desde el modo recuperación (modo texto), en el menú del grub de mi sistema se ve así:</p>

<pre class="config">
Ubuntu 12.04.2 LTS, kernel 3.8.2-ck1 (recovery mode)
</pre>

<p> <strong>2.-</strong> Se corre e4rat-realloc hasta que el sistema indique que no se puede optimizar más</p>

<pre class="sh_sh">
# e4rat-realloc /var/lib/e4rat/startup.log
...
...
No further improvements...
</pre>

<p> <strong>3.-</strong> Se cambia el parámetro <strong>init=/sbin/e4rat-collect</strong> por <strong>init=/sbin/e4rat-preload</strong> en la línea <strong>kernel</strong> del archivo <strong>/boot/grub/menu.lst</strong> o el archivo correspondiente para grub2:</p>

<pre class="config">
title   Ubuntu 12.04.2 LTS, kernel 3.8.2-ck1
uuid    793e9a6d-d545-46f0-ac9c-49071c450b62
kernel  /boot/vmlinuz-3.8.2-ck1 root=UUID=793e9a6d-d545-46f0-ac9c-49071c450b62 ro  init=/sbin/e4rat-preload
initrd  /boot/initrd.img-3.8.2-ck1
quiet
</pre>

<p> <strong>4.-</strong> Se reinicia</p>

<p> <strong>5.-</strong> Si todo ha ido bien, su sistema deberia arrancar más rápido y sentirse más liviano con las aplicaciones de uso frecuente</p>

<h4>Desinstalación</h4>

<p>Aunque el sistema no trae problemas incluso cuando no mejore el rendimiento algunas personas podrian querer desinstalarlo, para dejar su sistema como antes de <strong>e4rat</strong> pueden hacer:</p>

<pre class="sh_sh">
$ sudo apt-get purge e4rat
$ sudo apt-get install ubuntu-minimal ureadahead
$ sudo vim /boot/grub/menu.lst #y quitar la parte init=/sbin/e4rat-preload
</pre>

<ul>
	<li><a href="http://rafalcieslak.wordpress.com/2013/03/17/e4rat-decreasing-bootup-time-on-hdd-drives/" target="_blank">http://rafalcieslak.wordpress.com/2013/03/17/e4rat-decreasing-bootup-time-on-hdd-drives/</a></li>
</ul>