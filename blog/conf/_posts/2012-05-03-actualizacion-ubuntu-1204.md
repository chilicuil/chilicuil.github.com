---
layout: post
title: "actualización ubuntu 12.04"
---

## {{ page.title }}

<p class="date">{{ page.date | date_to_string }}</p>

<div align="center" id="img"><a href="/assets/img/49.png" target="_blank"><img src="/assets/img/49.png" style="width: 417px; height: 234px;"></a>
</div>

He actualizado mi laptop de Ubuntu 10.04 a la 12.04 LTS (n___n)/, así que pasaré a describir el proceso por si necesito volver a hacerlo.

Mi computadora es una netbook, así que no tiene disquetera, mmm, sin embargo eso no importa porque desde que <a href="http://chilicuil.github.com/all/os/2010/05/19/ubuntu-desde-windows-nowubi-netinstaller.html" target="_blank">descubrí</a> que Ubuntu se puede instalar sin USB ni CDROM, no descargo imágenes ISO a menos que quiera participar en el testing (<a href="http://iso.qa.ubuntu.com" target="_blank">iso.qa.ubuntu.com</a>), así pues lo primero que hice, fue cambiar el gestor de grub2 a grub-legacy

<pre class="sh_sh">
$ sudo rm -rf /boot/grub;  sudo mkdir /boot/grub
$ sudo apt-get --purge remove grub-pc grub-common
$ sudo apt-get install grub; sudo update-grub
$ sudo grub-install /dev/sda
</pre>

Después descargue el instalador y el kernel (20Mb~) y los puse en la raíz **"/"**

<pre class="sh_sh">
$ sudo wget  http://preview.tinyurl.com/7uedctd -O /initrd.gz #instalador
$ sudo wget http://preview.tinyurl.com/72wwv2c -O /linux #kernel
</pre>

Los agregué al grub, para que cuando reiniciara, viera una opción "Instalar Ubuntu":

<pre class="sh_properties">
/boot/grub/menu.lst:
title Instalar Ubuntu
kernel (hd0,0)/linux
initrd (hd0,0)/initrd.gz
</pre>

Reinicie y seleccioné "<em>Instalar Ubuntu</em>", una cosa que note es que el instalador, aunque pesa muy poco, 16MB~, reconoció mi tarjeta inalámbrica =3 (RTL8111/8168B), así que me ahorre el <a href="http://chilicuil.github.com/all/random/2010/12/14/compartir-conexion-pc-a-pc.html" target="_blank">cable cruzado</a> a otra máquina. El disco duro esta particionado en 3, /, /home y swap (5gb), a la hr de particionar, formatié la primera y la última y deje intacta home. También me aseguré de seleccionar <a href="http://chilicuil.github.com/all/random/2010/12/07/conexion-alambrica-inalambrica-al-mismo-tiempo.html" target="_blank">wicd-curses</a> (para tener red, cuando reiniciara) y openssh-server. Probé "<a href="http://en.wikipedia.org/wiki/Btrfs" target="_blank">btrfs</a>", pero después lo descarte porque me daba errores extraños cuando interactuaba con el grub, así que preferĺ quedarme con ext4 en <strong><span style="color: rgb(255, 0, 0);">/</span></strong>

Terminada la instalación, reinicie, eliminé el directorio home por defecto y monté y actualicé **/etc/fstab** con el mio, /dev/sda2

<pre class="sh_sh">
$ sudo rm -rf /home \&\& sudo mkdir /home
$ sudo mount /dev/sda2 /home \&\& sudo vi /etc/fstab
</pre>

Obtuve el uuid de /dev/sda2 haciendo **$ ls -lah /dev/disk/by-uuid**

<pre>
# /home was on /dev/sda2 during installation
UUID=04acdd58-ef63-4756-8d47-44050de3eb2f /home ext4  errors=remount-ro 0 1
# /tmp
tmpfs /tmp tmpfs defaults,noexec,nosuid 0 0
</pre>

Modifiqué **/etc/network/interfaces** para deshabilitar dhcp, prefiero darle el control de mi red a "wicd", quedó algo así:

<pre class="sh_properties">
/etc/network/interfaces:
auto lo
iface lo inet loopback
</pre>

Y cambie algunos parámetros para acelerar el sistema, (funciona por que tengo 4GB de ram, deben tomarse con cuidado cuando la memoria no es tan amplia):

<pre class="sh_properties">
$ tail /etc/sysctl.conf
  vm.swappiness=10
</pre>

Instalé el editor, scripts aleatorios y firefox:

<pre class="sh_sh">
$ sudo apt-get remove --purge nano 
$ sudo apt-get install vim-gtk -curl exuberant-ctags
$ sudo cp $HOME/code/learn/* /usr/local/bin 
$ sudo cp $HOME/code/python/* /usr/local/bin
$ sudo cp $HOME/code/autocp/bash_completion.d/* /etc/bash_completion.d/
$ sudo ln -s $HOME/.bin/thunderbird64/thunderbird /usr/local/bin/
$ sudo ln -s $HOME/.bin/firefox64/firefox /usr/local/bin/
</pre>

Instalé un <a href="http://chilicuil.github.com/all/os/2011/11/18/cache-de-paquetes-deb.html" target="_blank">caché</a> de .debs antes de instalar más programas y un link para aprovechar los que ya tenía:

<pre class="sh_sh">
$ sudo apt-get install apt-cacher-ng #/etc/apt-cacher-ng/acng.conf //9999
$ sudo vim /etc/apt/apt.conf.d/01apt-cacher-ng
$ ln -s $HOME/misc/packaging/proxy/apt-cacher-ng/ /var/cache/apt-cacher-ng
$ sudo service apt-cacher-ng restart
</pre>

Agregué el repositorio de <a href="http://medibuntu.org/" target="_blank">medibuntu</a>, y luego instalé el audio:

<pre class="sh_sh">
$ sudo wget -O /etc/apt/sources.list.d/medibuntu.list \
  http://www.medibuntu.org/sources.list.d/$(lsb_release -cs).list
$ sudo apt-get -q update 
$ sudo apt-get -y -q --allow-unauthenticated install medibuntu-keyring
$ sudo apt-get -q update
$ apt-get install alsa-utils mpd alsa-base pms mpc
</pre>

Descubrí que mpd ya no soporta la opción **--create-db**, así que terminé agregando mi biblioteca con **$ mpc update**, que utiliza <a href="http://en.wikipedia.org/wiki/Inotify" target="_blank">inotify</a>

Agregué mi usuario al grupo '<em>audio</em>', para que pudiera empezar a escuchar música y cargué el módulo snd-mixer-oss para ver /dev/mixer (conky lo necesita para mostrar el volumen)

<pre class="sh_sh">
$ sudo usermode -a -G audio username (salí de la sesión tty y volví a entrar)
$ sudo su
# echo snd-mixer-oss >> /etc/modules
</pre>

Luego instalé una pantalla de login, una terminal y Xorg

<pre class="sh_sh">
$ sudo apt-get install slim rxvt-unicode-256color xorg
$ sudo vim /etc/slim.conf
$ sudo cp -r $HOME/misc/themes/slim/custom /usr/share/slim/themes
</pre>

Mi gestor de ventanas es i3 (una versión muy específica), utilicé <a href="http://viajemotu.wordpress.com/2010/08/10/notas-sobre-pbuilder/" target="_blank">pbuilder</a> para crear otra instancia de precise, y ahí <a href="http://chilicuil.github.com/all/random/2010/06/16/i3-ebf3.html" target="_blank">compilé</a> i3-wm, luego copie el resultado (.deb) fuera del chroot y lo instalé

<pre class="sh_sh">
$ sudo apt-get install pbuilder dpkg-dev ccache
$ pbuilder DIST=precise ARCH=amd64 create \&\& pbuilder DIST=precise ARCH=amd64 login
[chroot]# sudo apt-get install git-core \&\& git clone #repositorio-i3-git# \&\& cd i3-wm
[chroot]# dbuild -b -us -uc #antes instale las dependencias
$ sudo dpkg -i i3-wm-amd64.deb
</pre>

Reinicie y obtuve un entorno gráfico, con red y música, nada mal, instalé algunos otros programas, gestor de archivos (pcmanfm), unificador de portapapeles (autocutsel), efectos (xcompmgr), screensaver (i3-lock), lanzador de aplicaciones (dmenu), programas para el soporte de hibernación y suspensión (pm-utils, hibernate), reproductor de videos (mplayer), lector de pdfs (zathura) y widgets (conky+dzen)

<pre class="sh_sh">
$ sudo apt-get install git-core cvs subversion bzr apt-file synaptic unzip zip rar unrar
  autocutsel acpi archmage bzr-builddeb colormake dkms suckless-tools feh notify-osd
  libav-tools hibernate html2text htop imagemagick irssi liferea mkvtoolnix mpgtx mplayer
  mutt-patched nmap default-jre pcmanfm pm-utils rlpr rtorrent sox tree unetbootin wget
  wodim xcompmgr xclip zsync gnupg-agent lxappearance libwww-perl i3lock virtaal conky-cli
  zathura gtk2-engines-pixbuf geoclue-ubuntu-geoip redshift #dzen2 - $HOME/code/dzen2/dzen2
</pre>

En general la actualización fue buena, solo encontré 1 problema irresoluble; bugs #<a href="https://bugs.launchpad.net/ubuntu/+source/gdk-pixbuf/+bug/927393" target="_blank">927393</a> y #<a href="https://bugs.launchpad.net/ubuntu/+source/notification-daemon/+bug/927031" target="_blank">927031</a> sobre notificaciones, Ubuntu soporta 2 programas para mostrar notificaciones, notification-daemon (el que uso y que esta roto por el momento, solo soporta gtk3), y notify-osd (el que funciona y el que se usa por defecto), fuera de eso encontre mejoras sustanciales, no tuve que compilar: vim, mpd, slim, urxvt debido a que precise viene con versiones suficientemente actuales o con correcciones que no tenía Ubuntu Lucid

<div align="center" id="img"><a href="/assets/img/50.png" target="_blank"><img src="/assets/img/50.png" style="width: 320px; height: 200px;"></a> <a href="/assets/img/51.png" target="_blank"><img src="/assets/img/51.png" style="width: 320px; height: 200px;"></a> <a href="/assets/img/52.png" target="_blank"><img src="/assets/img/52.png" style="width: 320px; height: 200px;"></a>
</div>

Me siento en casa =)
