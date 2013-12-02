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

El comando anterior crea una carpeta **pxe_setup** con todas las herramientas necesarias para lograrlo. Uso pxe casi exclusivamente para instalar computadoras con Ubuntu y solo me interesa ejecutar al arranque:

- [linux](http://archive.ubuntu.com/ubuntu/dists/precise-updates/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/linux) (kernel)
- [initrd.gz](http://archive.ubuntu.com/ubuntu/dists/precise-updates/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/initrd.gz) (sistema base)

Estos 2 archivos suelen estar disponibles para la mayoría de distribuciones (en i386 y amd64). Suponiendo que se quisiera instalar Ubuntu 12.04 amd64:

<pre class="sh_sh">
$ cd pxe_setup
$ wget http://archive.ubuntu.com/.../amd64/initrd.gz -O ubuntu/1204/amd64/initrd.gz
$ wget http://archive.ubuntu.com/.../amd64/linux     -O ubuntu/1204/amd64/initrd.gz
</pre>

Se descargan los archivos y se edita el menu *./pxe_setup/ubuntu/ubuntu.menu*, o el que corresponda, para este caso no es necesario porque el script ya crea su configuracion, si no se ha descargado fuera de *ubuntu/1204/amd64*, debería funcionar por defecto.

Con los archivos en su lugar, se puede ejecutar el servidor dhcpd y tftp. Algunas veces no es necesario ejecutar el primero, depende de si en la red local existe un router con soporte para PXE. Los router profesionales (cisco) o con un firmware libre potente (<a href="http://www.pfsense.org/" target="_blank">pfsense</a>) tienen esa opción (incluso se pueden crear <a href="http://es.wikipedia.org/wiki/VLAN" target="_blank">vlans</a>, segmentos de red donde existan instaladores), en caso contrario (routers de telmex, etc.) no.

## router con soporte pxe

En el primer de los casos, cuando existe un router con soporte para PXE, se puede configurar el mismo para que al arranque envie las peticiones PXE a la IP del equipo donde se encuentre el servidor tftp. Por ejemplo, donde se ejecutó el script. La ruta será **pxelinux.0** y el servicio se inicia así:

<pre class="sh_sh">
$ sudo python ./simple-tftpd
</pre>

## router sin soporte pxe

En el segundo caso (lo que pasa con mayor frecuencia), se ejecutan ambos. Sin embargo correr dos servidores dhcp en una misma red local (el del router y el del equipo con pxe) puede crear conflictos con las direcciones IP. Lo mejor en esos casos es ejecutar el segundo servidor dhcpd en otra interfaz de red no conectada al router local. Las laptops son perfectas para ello, suelen tener una interfaz inalámbrica y otra alámbrica (eth0, wlan0, eth1, etc). Idea: Crear una máquina virtual en [VirtualBox](https://www.virtualbox.org/) con 2 interfaces, una en modo *bridge* para eth1, o donde se encuentre la fuente de internet y otra en modo *bridge* | *internal network* a eth0 o donde se puedan conectar otros equipos para tener un instalador de distribuciones portable.

Suponiendo que eth1 es la interfaz inalambrica conectada al router local y con acceso a internet, puede configurarse para hacer de puente entre los hosts que se conecten a eth0 (la interfaz sin internet, pero conectada a los equipos locales que se van a instalar)

<pre class="sh_sh">
$ sudo iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
$ echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
</pre>

Es importante hacer esto porque casi siempre los archivos *linux* y *initrd.gz* contienen instaladores que dependen de internet.

A la interfaz eth0 se asigna una IP local (donde se ejecute dhcpd), así existira comunicación entre los hosts entre ellos y hacia internet. La ip que se configura puede ser cualquiera siempre y cuando sea local (eg, 192.X.X.X, 169.X.X.X o 10.X.X.X).

<pre class="sh_sh">
$ sudo ifconfig eth0 10.99.88.1
</pre>

NOTA: En sistemas donde se ejecute NetworkManager, es mejor configurar la ip desde su interfaz, o desactivarlo completamente.

Configuradas ambas interfaces se ejecuta dhcp y tftp:

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
