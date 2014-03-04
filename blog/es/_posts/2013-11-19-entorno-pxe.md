---
layout: post
title: "configurar entorno pxe"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

**[![](/assets/img/87.jpg)](/assets/img/87.jpg)**

Existen varias guías en internet para configurar entornos [pxe](http://es.wikipedia.org/wiki/Preboot_Execution_Environment) (útiles en la instalación masiva de equipos), la mayoría de ellas son largas y complicadas (cuando instalan versiones clásicas de dhcpd, tftp, etc). O si son fáciles, requieren que descargues medio internet ([clobber](https://fedorahosted.org/cobbler/) y [maas](https://maas.ubuntu.com/)). Cuando pienso en pxe, generalmente pienso en un entorno que pueda instalar y desechar rápidamente, como no encontré nada que me permitiera hacerlo de esa forma decidí ir por mi cuenta y este es el resultado. 

Un entorno pxe en 68KB con baterías incluidas, pxelinux, dhcpd, tftp y manos libres.

<iframe class="showterm" src="http://showterm.io/ccd5bb10d887b3e6bbd87" width="640" height="300">&nbsp;</iframe> 

<!--
   -<pre>
   -$ bash &lt;(wget -qO- https://raw.github.com/chilicuil/learn/master/sh/is/pxe)
   -[+] setting pxe environment in ./pxe_setup ...
   -  - creating ./pxe_setup/menu.c32 ...
   -  - creating ./pxe_setup/pxelinux.0 ...
   -  - creating ./pxe_setup/simple-dhcpd ...
   -  - creating ./pxe_setup/simple-tftpd ...
   -  - creating ./pxe_setup/pxelinux.cfg/default ...
   -  - creating ./pxe_setup/ubuntu/ubuntu.menu ...
   -  - creating ./pxe_setup/pxe/fedora/fedora.menu ...
   -  - creating ./pxe_setup/tools/tools.menu ...
   -</pre>
   -->

El comando anterior es el corazón del sistema, un script que genera una estructura de directorios con las herramientas y menus preconfigurados para arrancar por lo menos ubuntu y fedora (puede personalizarse fácilmente si se leen los archivos con terminación .menu). El script anterior, solo crea la estructura, aun hay que descargar los sistemas que se desean arrancar, es decir por lo menos 2 archivos de su distribución favorita.

- [linux](http://archive.ubuntu.com/ubuntu/dists/precise-updates/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/linux) (kernel)
- [initrd.gz](http://archive.ubuntu.com/ubuntu/dists/precise-updates/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/initrd.gz) (sistema base)

Para este ejemplo Ubuntu 12.04 LTS de 64 bits.

<pre class="sh_sh">
$ bash &lt;(wget -qO- https://raw.github.com/chilicuil/learn/master/sh/is/pxe)
$ cd pxe_setup #es importante cambiar a este directorio
$ wget http://archive.ubuntu.com/.../amd64/initrd.gz -O ubuntu/1204/amd64/initrd.gz
$ wget http://archive.ubuntu.com/.../amd64/linux     -O ubuntu/1204/amd64/linux
</pre>

No es obligatorio descargar los archivos *linux* e *initrd.gz* en *ubuntu/1204/amd64/* pero si no se hace, se tendrá que modificar *ubuntu/ubuntu.menu* con la nueva ruta. Una vez finalizadas las descargas, el sistema esta casi listo para arrancar otros equipos. ¡Simple!

Lamentablemente aun queda otro paso, configurar la red local. Este paso es complicado porque es difícil de automatizar, existen muchas configuraciones de redes.

Por lo general, el equipo donde se instala el entorno pxe tiene 2 interfaces de red (una conectada a internet, y otra conectada al equipo que se desea arrancar). Puede estar conectada directa o indirectamente (que se conecten entre si con switches u otros routers). Si el equipo solo tiene 1 interfaz de red, entonces se requiere un router con soporte pxe.

## Caso 1, router con soporte pxe (fácil)

Existen routers comerciales (cisco) y firmwares libres (pfsense) que pueden redireccionar peticiones de arranque (dhcp) hacia otros equipos. Si este es el caso, se puede configurar el router para que envié la petición a la ip del equipo con el entorno pxe (en la ruta **pxelinux.0**) y ejecutar el servicio tftp en la computadora local:

<pre class="sh_sh">
$ sudo python ./simple-tftpd
</pre>

## Caso 2, router sin soporte pxe, servidor pxe con al menos 2 interfaces de red

El segundo caso, es mucho más frecuente, ya sea porque el router no soporte redirecciones (telmex, iusacell, otro isp) o porque no se tenga acceso. Ejemplo, una laptop en una cafetería.

Suponiendo que wlan0 es una interfaz inalámbrica de una laptop conectada a internet, y que eth0 es una interfaz alámbrica conectada al equipo que se desea arrancar. Se configura la primera para actuar de puente entre internet y el equipo objetivo.

<pre class="sh_sh">
$ sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
$ echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
</pre>

La segunda interfaz (eth0) se configura con una ip local fuera del rango de cualquier otro equipo (eg, 192.X.X.X, 169.X.X.X, 10.X.X.X) 

<pre class="sh_sh">
$ while :; do sudo ifconfig eth0 10.99.88.1; sleep 3; done
</pre>

NOTA: En sistemas con [NetworkManager](https://wiki.gnome.org/Projects/NetworkManager), es mejor configurar la ip desde su interfaz, o desactivarlo completamente y luego configurar la ip con el comando anterior

Configuradas ambas interfaces se ejecuta dhcp y tftp en la interfaz conectada a la máquina objetivo:

<pre class="sh_sh">
$ sudo python ./simple-dhcpd -i eth0 -a 10.99.88.1
$ sudo python ./simple-tftpd
</pre>

Si los equipos conectados al otro lado de eth0 ya están configurados (desde la bios) para arrancar en red, se pueden encender. En sus pantallas se dibujara un menú, con opciones para instalar ubuntu o fedora. Dependiendo de los archivos que se hayan descargado se podrá instalar cualquiera de esos sistemas. Cuando se termine, se puede eliminar el entorno con:

<pre class="sh_sh">
$ rm -rf pxe_setup
</pre>

Idea: Crear una máquina virtual con 2 interfaces, una en modo *bridge* para wlan0, o donde se encuentre la fuente de internet y otra en modo *bridge* | *internal network* a eth0 o donde se puedan conectar otros equipos para tener un instalador de distribuciones portable.

## extra, manos libres

Las distribuciones más populares (debian,ubuntu,redhat,centos,etc) soportan instalaciones automatizadas (preseed, kickstart). El entorno descrito en esta nota configura una opción para instalar Ubuntu en modo manos libres. El archivo [preseed](http://people.ubuntu.com/~chilicuil/conf/preseed/minimal.preseed) puede usarse por si solo desde cualquier instalador de Ubuntu, **url=http://url** y soporta las siguientes opciones de personalización a través de la línea APPEND:

- **proxy=http://url**, para configurar un proxy
- **user=juan**, para especificar un usuario administrador diferente al de por defecto (chilicuil)

Referencias:

- [https://github.com/psychomario/PyPXE](https://github.com/psychomario/PyPXE)
- [http://javier.io/blog/es/2010/12/14/compartir-conexion-pc-a-pc.html](http://javier.io/blog/es/2010/12/14/compartir-conexion-pc-a-pc.html)
