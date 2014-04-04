---
layout: post
title: "mejorar el tiempo de arranque en ubuntu precise"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

Antes de empezar quiero aclarar que las siguientes instrucciones funcionan para Ubuntu desde la versión 11.04, hago énfasis en Ubuntu Precise porque es la versión LTS. Comparto los pasos porque en mi máquina se nota la diferencia incluso cuando mi configuración ya estaba [optimizada](http://javier.io/blog/es/2012/05/03/actualizacion-ubuntu-1204.html) (kernel -ck, slim/i3wm), eso no quiere decir que funcione en la suya.

El proyecto [e4rat](http://e4rat.sourceforge.net/) desarrolla herramientas que mejoran el tiempo de arranque en Linux, para ello se apoya en la reasignación de archivos de arranque en sistemas [ext4](http://es.wikipedia.org/wiki/Ext4), así que si no usan ext4, no servirá de nada. Tampoco servirá si sus discos son [SSD](http://es.wikipedia.org/wiki/Unidad_de_estado_s%C3%B3lido) (de estado sólido), para esos discos [ureadahead](https://launchpad.net/ureadahead) ya hace un buen trabajo.

### Introducción

Mucho del tiempo que se invierte en arrancar una computadora se debe a la espera e inicialización de los discos duros (esto no aplica para la tecnología ssd), pueden verlo por ustedes mismos con la utilidad [bootchart](http://www.bootchart.org/) que crea diagramas sobre el arranque de Linux.

**[![](/assets/img/66.png)](/assets/img/66.png)**

El rojo es el tiempo de espera del disco duro, el azul el tiempo de ejecución del cpu

**e4rat** mueve los archivos críticos de arranque a una zona de fácil acceso en el disco duro para que esos archivos se carguen de una sola vez o en pocas lecturas a la ram. Una vez en la ram se continua el arranque y debido a que la ram es mucho más rápida, se mejora el tiempo de arranque.

**[![](/assets/img/67.png)](/assets/img/67.png)**

El rojo es el tiempo de espera del disco duro, el azul el tiempo de ejecución del cpu. Se nota una mejora considerable

Sabiendo esto, se comprende porque el procedimiento debe repetirse cada vez que se instala un nuevo kernel, o se hace una actualización mayor al sistema. También se comprende porque **e4rat** no funciona en distribuciones rolling release (arch, gentoo) o en distribuciones en desarrollo (Ubuntu raring), pues estos sistemas hacen constantes actualizaciones a los archivos de arranque.

### Desarrollo

#### Instalación

Para poder tomar partido de **e4rat** se requiere una versión del kernel no menor a 2.6.31, en Ubuntu, desde la versión 11.04 se instalan kernels superiores, también funciona sobre el [kernel vanilla + ck](http://javier.io/blog/es/2012/07/03/kernel-ck-en-ubuntu-1204.html) que recomiendo.

Si se cumple ese requisito entonces puede descargarse de:

- <http://sourceforge.net/projects/e4rat/files>

Dependiendo de la arquitectura de su sistema, querran descargar la última versión de **e4rat** para x86 | amd64 en formato **.deb** (para una instalación fácil y limpia), en mi caso he descargado **e4rat_0.2.3_amd64.deb**. Antes de instalar el paquete, hay que desinstalar **ureadahead**.

<pre class="sh_sh">
$ sudo apt-get purge ureadahead
</pre>

Esto desinstalará también **ubuntu-minimal**, ojo: esto no causará ningún daño, **ubuntu-minimal** es un paquete **vacío** que se usa en Ubuntu para 'jalar' paquetes iniciales del sistema.

Una vez completado el paso anterior, se puede instalar **e4rat**:

<pre class="sh_sh">
$ sudo dpkg -i e4rat_0.2.3_amd64.deb
</pre>

#### Configuración

Reconocimiento de los habitos del sistema

Para que **e4rat** mejore el tiempo de arranque necesita conocer los archivos que se utilizan, lo que sigue son las instrucciones para hacer que el sistema arranque en un modo especial que le permitirá aprender de los hábitos del mismo, sugiero que cuando se haga se abran las aplicaciones que se usan con mayor frecuencia, por ejemplo firefox.

1. Agregar el parámetro **init=/sbin/e4rat-collect** a la línea **kernel** en **/boot/grub/menu.lst** o a su equivalente en grub2, para mi caso:

<pre class="config">
title   Ubuntu 12.04.2 LTS, kernel 3.8.2-ck1
uuid    793e9a6d-d545-46f0-ac9c-49071c450b62
kernel  /boot/vmlinuz-3.8.2-ck1 root=UUID=793e9a6d-d545-46f0-ac9c-49071c450b62 ro  init=/sbin/e4rat-collect
initrd  /boot/initrd.img-3.8.2-ck1
quiet
</pre>

2. Reiniciar y lanzar durante los primeros 2 minutos las aplicaciones que se usen con mayor frecuencia

3. Verificar que se haya creado un archivo en **/var/lib/e4rat/startup.log**, este archivo contiene las estadísticas del sistema

<pre class="sh_sh">
$ file /var/lib/e4rat/startup.log
/var/lib/e4rat/startup.log: ASCII text
</pre>

Reasignación de archivos

Después de que **e4rat** conozca los hábitos del sistema, sigue la reasignación de los archivos (la parte que traerá la mejora en el rendimiento), para ello se:

1. Reinicia desde el modo recuperación (modo texto), en el menú del grub de mi sistema se ve así:

<pre class="config">
Ubuntu 12.04.2 LTS, kernel 3.8.2-ck1 (recovery mode)
</pre>

2. Se corre e4rat-realloc hasta que el sistema indique que no se puede optimizar más

<pre class="sh_sh">
# e4rat-realloc /var/lib/e4rat/startup.log
...
...
No further improvements...
</pre>

3. Se cambia el parámetro **init=/sbin/e4rat-collect** por **init=/sbin/e4rat-preload** en la línea **kernel** del archivo **/boot/grub/menu.lst** o el archivo correspondiente para grub2:

<pre class="config">
title   Ubuntu 12.04.2 LTS, kernel 3.8.2-ck1
uuid    793e9a6d-d545-46f0-ac9c-49071c450b62
kernel  /boot/vmlinuz-3.8.2-ck1 root=UUID=793e9a6d-d545-46f0-ac9c-49071c450b62 ro  init=/sbin/e4rat-preload
initrd  /boot/initrd.img-3.8.2-ck1
quiet
</pre>

4. Se reinicia

5. Si todo ha ido bien, su sistema deberia arrancar más rápido y sentirse más liviano con las aplicaciones de uso frecuente

#### Desinstalación

Aunque el sistema no trae problemas incluso cuando no mejore el rendimiento algunas personas podrian querer desinstalarlo, para dejar su sistema como antes de **e4rat** pueden hacer:

<pre class="sh_sh">
$ sudo apt-get purge e4rat
$ sudo apt-get install ubuntu-minimal ureadahead
$ sudo vim /boot/grub/menu.lst #y quitar la parte init=/sbin/e4rat-preload
</pre>

- <http://rafalcieslak.wordpress.com/2013/03/17/e4rat-decreasing-bootup-time-on-hdd-drives>
