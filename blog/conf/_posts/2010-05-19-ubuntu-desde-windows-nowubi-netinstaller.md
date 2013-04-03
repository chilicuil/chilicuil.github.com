---
layout: post
title: "instalar ubuntu desde windows sin wubi + netinstaller"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

Hace relativamente poco me pude hacer de una netbook, la estuve probando el primer mes con windows para verificar que funcionara bien y con la salida de ubuntu 10.04 decidí instalarle la nueva versión.

Habia estado viendo la forma de instalar core linux a mi usb y no pensaba detener el proceso, así que me puse a buscar métodos alternativos (que no requirieran mi usb), primero busqué alguna guía sobre la instalación en red (al parecer solo hay que montar un servidor tftp y dhcp). Sin embargo también vi otra forma, instalar grub desde windows, decidí usar primero la segunda forma porque creí que sería más fácil, y no me equivoque :)

Igual sigue en mi lista de cosas por hacer lo de la instalación sobre red, un día de estos lo investigaré...

Primero he descargado [grub4dos](http://grub4dos.sourceforge.net/), lo he descomprimido y he copiado los archivo grldr (grub loader) y menu.lst al root **C:**

>[![alt text](/assets/img/26.png)](/assets/img/26.png)
>[![alt text](/assets/img/27.png)](/assets/img/27.png)

Luego he creado el directorio **C:\boot\grub** y descargado el instalador y el kernel en **C:\boot**

Para x86:

- <http://archive.ubuntu.com/ubuntu/dists/lucid/main/installer-i386/current/images/netboot/ubuntu-installer/i386/initrd.gz>
- <http://archive.ubuntu.com/ubuntu/dists/lucid/main/installer-i386/current/images/netboot/ubuntu-installer/i386/linux>

Para amd64:

- <http://archive.ubuntu.com/ubuntu/dists/lucid/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/initrd.gz>
- <http://archive.ubuntu.com/ubuntu/dists/lucid/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/linux>

>[![alt text](/assets/img/28.png)](/assets/img/28.png)

He copiado **C:\menu.lst** hacia **C:\boot\grub** y he editado el archivo de esta forma:

>[![alt text](/assets/img/29.png)](/assets/img/29.png)

Finalmente lo he agregado al cargador de Windows, de esta forma este le pasará el control al grub y el grub podrá arrancar el instalador (chain loading):

>[![alt text](/assets/img/30.png)](/assets/img/30.png)
>[![alt text](/assets/img/31.png)](/assets/img/31.png)
>[![alt text](/assets/img/32.png)](/assets/img/32.png)
>[![alt text](/assets/img/33.png)](/assets/img/33.png)

He reiniciado y seleccionado la primera opción **Start GRUB** y luego **Install ubuntu** para comenzar la instalación, OJO: el instalador es similar al que se obtendría con el mínimal CD, es decir, viene sin wifitools y wpa_supplicant, por lo que hay que usar un cable ethernet para descargar los paquetes que sean necesarios.

- <https://help.ubuntu.com/community/Installation/FromWindows>
