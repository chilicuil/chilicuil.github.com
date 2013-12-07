---
layout: post
title: "configurar entorno pxe"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

**[![](/assets/img/87.jpg)](/assets/img/87.jpg)**

Existen varias guías en internet para configurar entornos <a href="http://es.wikipedia.org/wiki/Preboot_Execution_Environment" target="_blank">pxe</a>, una forma de arrancar máquinas desde la red (muy util en la instalacion masiva de equipos), la mayoría de ellas son largas y complicadas. O si son faciles, requieren que descargues medio internet. Me gustan los sistemas minimalistas y sencillos, como no vi nada que me satisfaciera, tome algunos dias para estudiar el tema, y este es el resultado. Un entorno pxe en 68KB con baterias incluidas, pxelinux, dhcpd, tftp y manos libres.

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

El comando anterior es el corazon del entorno, un script que genera una estructura de directorios con las herramientas y menus preconfiguradoras para arrancar por lo menos ubuntu y fedora (puede personalizarse facilmente si se leen los archivos con terminacion .menu). El script anterior, solo crea la estructura, aun hay que descargar los sistemas que se desean arrancar, es decir por lo menos 2 archivos de su distribucion favorita.

- [linux](http://archive.ubuntu.com/ubuntu/dists/precise-updates/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/linux) (kernel)
- [initrd.gz](http://archive.ubuntu.com/ubuntu/dists/precise-updates/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/initrd.gz) (sistema base)

Tomando como ejemplo Ubuntu 12.04 de 64 bits:

<pre class="sh_sh">
$ cd pxe_setup
$ wget http://archive.ubuntu.com/.../amd64/initrd.gz -O ubuntu/1204/amd64/initrd.gz
$ wget http://archive.ubuntu.com/.../amd64/linux     -O ubuntu/1204/amd64/initrd.gz
</pre>

Se descargan los archivos *linux* e *initrd.gz* y se colocan en *ubuntu/1204/amd64/*. No es obligatorio descargarlos ahi, pero si no se hace se tendra que modificar *ubuntu/ubuntu.menu* con la nueva ruta. Una vez finalizadas las descargas, se tendran todos los archivos que se necesitan para arrancar otros equipos en red.

Lamentablemente, aun queda otro paso, que parece ser el mas complicado, configurar la red local. Este paso es complicado porque es dificil de automatizar, existen muchas configuraciones de redes y de equipos.

Por lo general, el equipo donde se instala el entorno pxe tiene 2 interfaces de red (una conectada a internet, y otra conectada al equipo que se desea arrancar). Puede estar conectada directa o indirectamente (que se conecten entre si con switches u otros routers). Si el equipo solo tiene 1 interfaz de red, entonces se require un router con soporte pxe.

## Caso 1, router con soporte pxe (facil)

Existen routers comerciales (cisco) y firmwares libres (pfsense) que pueden redireccionar peticiones de arranque (dhcp) hacia otros equipos. En este caso se configura el router para que envie la peticion a la ip del equipo donde se ejecuto el script con la direccion **pxelinux.0** y se inicia el servidor tftp:

<pre class="sh_sh">
$ sudo python ./simple-tftpd
</pre>

## Caso 2, router sin soporte pxe, servidor pxe con al menos 2 interfaces de red

El segundo caso, es mucho mas frecuente, ya sea porque el router no soporte redirecciones de peticiones pxe o porque no se tenga acceso. Ejemplo, una laptop en una cafeteria.

Suponiendo que wlan0 es una interfaz inalambrica de una laptop conectada a internet, y que eth0 es la interfaz conectada al equipo que se desea arrancar. Se configura la primera para actuar de puente entre internet y el equipo objetivo.

<pre class="sh_sh">
$ sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
$ echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
</pre>

La segunda interfaz (eth0) se configura con una ip local fuera del rango de cualquier otro equipo (eg, 192.X.X.X, 169.X.X.X, 10.X.X.X) 

<pre class="sh_sh">
$ while :; do sudo ifconfig eth0 10.99.88.1; sleep 3; done
</pre>

NOTA: En sistemas con NetworkManager, es mejor configurar la ip desde su interfaz, o desactivarlo completamente y luego configurar la ip con el comando anterior

Configuradas ambas interfaces se ejecuta dhcp en la interfaz conectada a la maquina objetivo y tftp:

<pre class="sh_sh">
$ sudo python ./simple-dhcpd -i eth0 -a 10.99.88.1
$ sudo python ./simple-tftpd
</pre>

Si los equipos conectados al otro lado de eth0 ya estan configurados (desde la bios) para arrancar en red, se pueden encender. En sus pantallas se dibujara un menu, con opciones para instalar ubuntu o fedora. Dependiendo de los archivos que hayan descargado se podran instalar cualquiera de esos sistemas. Cuando se termine, se puede eliminar el entorno con:

<pre class="sh_sh">
$ rm -rf pxe_setup
</pre>

Idea: Crear una máquina virtual con 2 interfaces, una en modo *bridge* para wlan0, o donde se encuentre la fuente de internet y otra en modo *bridge* | *internal network* a eth0 o donde se puedan conectar otros equipos para tener un instalador de distribuciones portable.

<br>
- [https://github.com/psychomario/PyPXE](https://github.com/psychomario/PyPXE)
- [http://javier.io/blog/es/2010/12/14/compartir-conexion-pc-a-pc.html](http://javier.io/blog/es/2010/12/14/compartir-conexion-pc-a-pc.html)
