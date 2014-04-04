---
layout: post
title: "compilar software sin ensuciar el sistema"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

Soy un paranóico del orden en mi sistema, así que cada vez que tengo que instalar software que no esta en los repositorios veo si puedo crear un .deb a partir de su código, algunas veces basta con quitar dependencias o cambiar un par de líneas para obtener la última versión. O usar [checkinstall](http://asic-linux.com.mx/%7Eizto/checkinstall/) para crear un paquete .deb a partir del Makefile.

Esto no toma en cuenta las dependencias que hay que instalar para la compilación, sin embargo esto se puede arreglar si se usa **pbuilder**, que crea un chroot donde se puede experimentar tanto como se quiera antes de obtener la versión final. Ya he escrito sobre como [configurar pbuilder](https://viajemotu.wordpress.com/2010/08/10/notas-sobre-pbuilder) para obtener varios entornos en un mismo sistema. Muy a modo, pbuilder tiene una opción llamada **--login** que descomprime la imagen de uno de esos entornos y lo instala, los cambios en estos sistemas son descartados, por lo que la próxima vez que se mande a llamar **pbuilder --login** se obtiene un sistema completamente nuevo.

Se pueden combinar ambas herramientas para crear .debs que pueden ser instalados limpiamente, como ejemplo para compilar la última versión de ffmpeg (tomada de git):

<pre class="sh_sh">
$ sudo apt-get -y remove ffmpeg x264 libx264-dev libmp3lame-dev 
$ sudo apt-get update
$ sudo pbuilder.lucid --login
[lucid-chroot] # apt-get install wget
[lucid-chroot] # apt-get -y install nasm build-essential git-core \
                 checkinstall yasm texi2html libfaac-dev libopencore-amrnb-dev     \
                 libopencore-amrwb-dev libsdl1.2-dev libtheora-dev libvorbis-dev   \
                 libx11-dev libxfixes-dev libxvidcore-dev zlib1g-dev
</pre>

Para empaquetar lame (con soporte para .mp3)

<pre class="sh_sh">
[lucid-chroot] # wget <a href="http://downloads.sourceforge.net/project/lame/lame/3.98.4/lame-3.98.4.tar.gz" target="_blank">http://downloads.sourceforge.net/project/lame/.../lame-3.98.4.tar.gz</a>
[lucid-chroot] # tar xzvf lame-3.98.4.tar.gz 
[lucid-chroot] # cd lame-3.98.4
[lucid-chroot] # ./configure --enable-nasm --disable-shared
[lucid-chroot] # make 
[lucid-chroot] # checkinstall --pkgname=lame-ffmpeg --pkgversion="3.98.4" --backup=no\
                 --default --deldoc=yes
</pre>

Para empaquetar x264

<pre class="sh_sh">
[lucid-chroot] # git clone git://git.videolan.org/x264
[lucid-chroot] # cd x264
[lucid-chroot] # ./configure --enable-static --disable-asm
[lucid-chroot] # make
[lucid-chroot] # checkinstall --pkgname=x264 --pkgversion=""3:$(./version.sh \
                | awk -F'[" ]' '/POINT/{print $4"+git"$5}')"" --backup=no \
                --deldoc=yes --fstrans=no --default
</pre>

Para empaquetar ffmpeg

<pre class="sh_sh">
[lucid-chroot] # git clone git://git.videolan.org/ffmpeg
[lucid-chroot] # cd ffmpeg
[lucid-chroot] # ./configure --enable-gpl --enable-version3 --enable-nonfree \
                --enable-postproc --enable-libfaac --enable-libopencore-amrnb \
                --enable-libopencore-amrwb --enable-libtheora --enable-libvorbis \
                --enable-libx264 --enable-libxvid --enable-x11grab --enable-libmp3lame
[lucid-chroot] # make
[lucid-chroot] # checkinstall --pkgname=ffmpeg --pkgversion="5:$(./version.sh)" \
                --backup=no --deldoc=yes --default
</pre>

Una vez empaquetado el software que nos interesa se copia al sistema **/var/cache/pbuilder/lucid-amd64/build/{numero}/home/user/{x264,lame-3.98.4,ffmpeg}/.deb**

Y fuera del chroot, se instalan los .debs:

<pre class="sh_sh">
$ sudo dpkg -i ffmpeg_5:201111091946-git-1_amd64.deb
$ sudo dpkg -i lame-ffmpeg_3.98.4-1_amd64.deb
$ sudo dpkg -i x264_3:0.119.2106+git07efeb4-1_amd64.deb
</pre>

Instalados los programas, se puede eliminar el entorno de construcción.

<pre class="sh_sh">
[lucid-chroot] # exit
</pre>

Lo que eliminará todos los archivos utilizados (incluyendo los .debs creados).
