---
layout: post
title: "configurar entorno pxe"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

**[![](/assets/img/87.jpg)](/assets/img/87.jpg)**

Existen muchas guías en internet para configurar un entorno <a href="http://es.wikipedia.org/wiki/Preboot_Execution_Environment" target="_blank">pxe</a>, una forma de arrancar máquinas desde la red. Esta es mi propia forma de hacerlo.

<pre>
$ bash &lt;(wget -qO- https://raw.github.com/chilicuil/learn/master/sh/is/pxe)
[+] setting pxe environment in ./pxe_setup ...
  - creating ./pxe_setup/menu.c32 ...
  - creating ./pxe_setup/pxelinux.0 ...
  - creating ./pxe_setup/simple-dhcpd ...
  - creating ./pxe_setup/simple-tftpd ...
  - creating ./pxe_setup/pxelinux.cfg/default ...
  - creating ./pxe_setup/ubuntu/ubuntu.menu ...
  - creating ./pxe_setup/pxe/fedora/fedora.menu ...
  - creating ./pxe_setup/tools/tools.menu ...
</pre>

El comando anterior crea una carpeta **pxe_setup** con todas las herramientas necesarias para lograrlo, pxelinux.0,menu.c32 que se ejecutan al arranque (en el equipo remoto), simple-dhcpd un servidor dhcpd en python, simple-tftpd un servidor tftp en python, y varios menus predefinidos (default y aquellos archivos con terminación en .menu).

Uso casi exclusivamente pxe para instalar computadoras con Ubuntu LTS y solo me interesa ejecutar al arranque:

- [linux](http://archive.ubuntu.com/ubuntu/dists/precise-updates/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/linux) (kernel)
- [initrd.gz](http://archive.ubuntu.com/ubuntu/dists/precise-updates/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/initrd.gz) (sistema base)

Muchas distribuciones ponen en descarga por lo menos estos 2 archivos (generalmente para i386 y amd64). Suponiendo que se quisiera instalar Ubuntu 12.04 amd64:

<pre class="sh_sh">
$ cd pxe_setup
$ wget http://archive.ubuntu.com/.../amd64/initrd.gz -O ubuntu/1204/amd64/initrd.gz
$ wget http://archive.ubuntu.com/.../amd64/linux     -O ubuntu/1204/amd64/initrd.gz
</pre>

Despues de lo cual se edita *./pxe_setup/ubuntu/ubuntu.menu*, o el menú que corresponda, sin embargo en este caso no es necesario porque instalo con tanta frecuencia Ubuntu TLS en amd64 e i386 que el script citado ya crea su configuración.

Con los archivos en su lugar, se puede ejecutar el servidor dhcpd y tftp para comenzar a instalar equipos en red. Algunas veces no es necesario ejecutar el primero, depende de si en la red local existe un router con soporte para PXE. Los router profesionales (cisco) o con un firmware libre potente (<a href="http://www.pfsense.org/" target="_blank">pfsense</a>) tienen esa opción (incluso se pueden crear <a href="http://es.wikipedia.org/wiki/VLAN" target="_blank">vlans</a>), en caso contrario (routers de telmex, etc.) no.

## router con soporte pxe

En el primer de los casos, cuando existe un router con soporte para PXE, se puede configurar el mismo para que al arranque envie las peticiones PXE a la IP del equipo donde se ejecutó el script con la ruta **pxelinux.0**. Para ese caso solo se corre TFTP:

<pre class="sh_sh">
$ sudo python ./simple-tftpd
</pre>

## router sin soporte pxe

En el segundo caso (lo que pasa con mayor frecuencia), se ejecutan ambos. Sin embargo correr dos servidores dhcp en una misma red local (el del router y el del equipo con pxe) puede crear conflictos con las direcciones IP. Lo mejor en esos casos es ejecutar el segundo servidor dhcpd en otra interfaz de red no conectada al router local. Las laptops son perfectas para este caso, suelen tener una interfaz inalámbrica y otra alámbrica (eth1, y eth0, aunque pueden diferir). Idea: Crear una máquina virtual en [VirtualBox](https://www.virtualbox.org/) con 2 interfaces, una en modo *bridge* para eth1, o donde se encuentre la fuente de internet y otra en modo *bridge* a eth0 o donde puedan conectarse otros equipos para tener un instalador de distribuciones portable. La segunda interfaz tambien puede estar en modo *internal network* si lo que se desea es instalar a otras máquinas virtuales con PXE.

Suponiendo que eth1 es la interfaz inalambrica conectada al router local y con acceso a internet, se configura para hacer de puente entre los hosts que se conecten a eth0 (la interfaz sin internet, pero conectada a los equipos locales que se van a instalar)

<pre class="sh_sh">
$ sudo iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
$ echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
</pre>

Ahora todo el trafico de y hacia internet que vaya a eth0 pasara por eth1. Es importante hacer esto por que casi siempre, los archivos *linux* y *initrd.gz* contienen instaladores que dependen de internet.

A la interfaz eth0 se le debe configurar una IP (donde se ejecutará dhcpd), en sistemas con NetworkManager es mejor configurarlo desde ahí, en otros casos un comando de ifconfig basta:

<pre class="sh_sh">
$ sudo ifconfig eth0 10.99.88.1
</pre>

La ip que se configura puede ser cualquiera siempre y cuando sea local (eg, 192.X.X.X, 169.X.X.X o 10.X.X.X). Configuradas ambas interfaces se ejecutan dhcp y tftp:

<pre class="sh_sh">
$ sudo python simple-dhcpd -i eth0 -a 10.99.88.1
$ sudo python simple-tftpd
</pre>

Listo cuando se termine de instalar todo, se puede eliminar el entorno con:

<pre class="sh_sh">
$ rm -rf pxe_setup
</pre>

<br>
- [https://github.com/psychomario/PyPXE](https://github.com/psychomario/PyPXE)
- [http://javier.io/blog/es/2010/12/14/compartir-conexion-pc-a-pc.html](http://javier.io/blog/es/2010/12/14/compartir-conexion-pc-a-pc.html)
