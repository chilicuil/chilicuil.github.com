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

El comando anterior crea una carpeta **pxe_setup** con todas las herramientas necesarias. Teniendo esto, se descarga el sistema que se desea arrancar, lo que conmunmente significa descargar por lo menos otros dos archivos:

- [linux](http://archive.ubuntu.com/ubuntu/dists/precise-updates/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/linux) (kernel)
- [initrd.gz](http://archive.ubuntu.com/ubuntu/dists/precise-updates/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/initrd.gz) (sistema base)

Suponiendo que se quisiera instalar Ubuntu 12.04 amd64:

<pre class="sh_sh">
$ cd pxe_setup
$ wget http://archive.ubuntu.com/.../amd64/initrd.gz -O ubuntu/1204/amd64/initrd.gz
$ wget http://archive.ubuntu.com/.../amd64/linux     -O ubuntu/1204/amd64/initrd.gz
</pre>

Con los archivos en su lugar, se ejecutan los servidores dhcpd y tftp. En algunos casos no es necesario ejecutar el primero, depende de si en la red local existe un router con soporte para PXE. Los router profesionales (cisco) o con un firmware libre potente (<a href="http://www.pfsense.org/" target="_blank">pfsense</a>) tienen esa opción (incluso se pueden crear <a href="http://es.wikipedia.org/wiki/VLAN" target="_blank">vlans</a>, segmentos de red donde existan instaladores), en caso contrario (routers de telmex, etc.) no.

### router con soporte pxe

En el primer de los casos, cuando existe un router con soporte para PXE, se puede configurar el mismo para que al arranque envie las peticiones PXE a la IP del servidor tftp (el equipo donde se ejecutó el script). La ruta será **pxelinux.0**:

<pre class="sh_sh">
$ sudo python ./simple-tftpd
</pre>

### router sin soporte pxe

En el segundo caso (lo que ocurre con mayor frecuencia), se ejecutan ambos. Sin embargo correr dos servidores dhcp en una misma red local (el del router y el del equipo con pxe) puede crear conflictos con las direcciones IP. Lo mejor en esos casos es correr el segundo servidor dhcpd en otra interfaz de red no conectada al router local. Las laptops son perfectas para ello, suelen tener dos interfaces, una inalámbrica y otra alámbrica (eth0, wlan0, eth1, etc). Idea: Crear una máquina virtual con 2 interfaces, una en modo *bridge* para wlan0, o donde se encuentre la fuente de internet y otra en modo *bridge* | *internal network* a eth0 o donde se puedan conectar otros equipos para tener un instalador de distribuciones portable.

Suponiendo que wlan0 es la interfaz inalambrica conectada al router local y con acceso a internet, se configura para que haga de puente entre los hosts que se van a arrancar y la red de redes.

<pre class="sh_sh">
$ sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
$ echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
</pre>

Es importante hacer esto porque casi siempre los archivos *linux* y *initrd.gz* que vienen con los instaladores minimalistas denden de internet.

A la interfaz eth0 (sin conexion a internet) se le asigna una IP local (donde se ejecutará dhcpd). La ip que se configura puede ser cualquiera siempre y cuando sea local (eg, 192.X.X.X, 169.X.X.X o 10.X.X.X).

<pre class="sh_sh">
$ while :; do sudo ifconfig eth0 10.99.88.1; sleep 3; done
</pre>

NOTA: En sistemas con NetworkManager, es mejor configurar la ip desde su interfaz, o desactivarlo completamente.

Configuradas ambas interfaces se ejecutan dhcp y tftp:

<pre class="sh_sh">
$ sudo python ./simple-dhcpd -i eth0 -a 10.99.88.1
$ sudo python ./simple-tftpd
</pre>

Ahora se pueden conectar equipos a eth0 y arrancarlos en red, cuando se termine, se puede eliminar el entorno con:

<pre class="sh_sh">
$ rm -rf pxe_setup
</pre>

<br>
- [https://github.com/psychomario/PyPXE](https://github.com/psychomario/PyPXE)
- [http://javier.io/blog/es/2010/12/14/compartir-conexion-pc-a-pc.html](http://javier.io/blog/es/2010/12/14/compartir-conexion-pc-a-pc.html)
