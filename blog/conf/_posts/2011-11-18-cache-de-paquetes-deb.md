---
layout: post
title: "caché de paquetes .deb"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

### Introducción

Hay varias soluciones para crear cachés de paquetes, las únicas que he utilizado han sido [debmirror](http://packages.qa.debian.org/d/debmirror.html) y [apt-cacher-ng](http://www.unix-ag.uni-kl.de/%7Ebloch/acng/), la primera crea una copia exacta de los repositorios que se deseen, es decir 35GB~ por cada distribucion / arquitectura, lo que ha efectos prácticos no me parece óptimo (si de lo que se trata es de ahorrar ancho de banda), no solo se descargan demasiados GB inicialmente sino que cada noche se debe correr una actualización general. Tal vez sea práctico para organizaciones con no menos de 100 equipos.

Para el resto, y atendiendome a mi propia experiencia se pueden usar herramientas que van creando el cache **'on demand'**, es decir para que con cada nuevo programa que se descargue, se haga la petición al servidor, este lo obtenga y lo envie de vuelta a quien lo solicito, a partir de lo cual, cualquier otro equipo que lo necesite lo obtenga de la red LAN, lo que será mucho más rápido.

Algunas de estas herramientas son **apt-proxy**, **apt-cacher**, **apt-cacher-ng** y **squid-deb-proxy**, una revisión esta disponible en:

<http://askubuntu.com/questions/3503/best-way-to-cache-apt-downloads-on-a-lan>

A propósito de askubuntu, es increible ver la cantidad de respuestas útiles que se encuentran en ese sitio, creo que ha desbancado a <http://answers.launchpad.net/ubuntu> como el sitio predilecto para hacer preguntas de cualquier nivel técnico asociados a Ubuntu.

Regresando al tema, he optado por **apt-cacher-ng** porque es rápido, estable y mantiene todas las cosas unidas desde un solo programa, uno no requiere instalar un servidor web por ejemplo.

### Desarrollo

[+] Servidor:

<pre class="sh_sh">
$ sudo apt-get install apt-cacher-ng
$ sudo sed -i -e 's/3142/9999/g' /etc/apt-cacher-ng/acng.conf
$ sudo service apt-cacher-ng restart
</pre>

Lo que lo hará compatible con **apt-proxy** (por lo del puerto 9999)

[+] Cliente:

<pre class="sh_sh">
$ wget http://ubuntuone.com/4PXwbNWmNj5kK9AUkEb9fF -O add_proxy_repository
$ sudo chmod +x $_ 
$ sudo mv -v $_ /usr/local/bin
</pre>

Lo que dejará un script en **/usr/local/bin** llamado **add_proxy_repository**, el cual puede ser llamado de cualquiera de estas formas:

<pre class="sh_sh">
$ add_proxy_repository [add|remove]
</pre>

Por alguna torpe razón, apt-get se empeñará en usar el proxy aún cuando no este disponible.., cuando esto pase, se debe usar el script para deshabilitar el proxy, en caso de querer automatizarlo, se puede usar **_squid-deb-proxy-client_** que verifica la conexión y dependiendo del estado en [avahi](http://avahi.org) habilitaran deshabilitaran la línea que afecta a apt..., creo que sería mucho más práctico que apt-get siguiera leyendo sources.list y tomará los repositorios declarados ahí en caso de no encontrar accesible la dirección del proxy...

A efectos prácticos y para máquinas de escritorio, solo se correrá una única vez **$ add_proxy_repository add**.., mientras que para laptops significa estar habilitando/deshabilitando de acuerdo a la red en la que se encuentre, por lo que si puedo sugerir algo, es que se use este script para máquinas de escritorio y se de preferencia a **squid-deb-proxy** cuando se trate de una laptop

### Extra

#### Servidor / cliente

Para que los paquetes del servidor también se agreguen al caché, sera necesario configurarlo como cliente

[+] Servidor:

<pre class="sh_sh">
$ add_proxy_repository add #IP: localhost
</pre>

#### Importar paquetes del servidor

Se pueden importar los paquetes que han sido descargados con anterioridad en el servidor:

[+] Servidor:

<pre class="sh_sh">
$ sudo mkdir -pv -m 2755 /var/cache/apt-cacher-ng/_import
$ sudo mv -vuf /var/cache/apt/archives/*.deb /var/cache/apt-cacher-ng/_import/
$ sudo chown -R apt-cacher-ng:apt-cacher-ng /var/cache/apt-cacher-ng/_import
$ sudo apt-get update
$ tree /var/cache/apt-cacher-ng
</pre>

Se va a <http://localhost:9999/acng-report.html> y se presiona '**Start import**':

[![](/assets/img/57.png)](/assets/img/57.png)

#### Importar paquetes de otras máquinas

Se limpia _import

[+] Servidor:

<pre class="sh_sh">
$ sudo rm -rf /var/cache/apt-cacher-ng/_import
</pre>

[+] Cliente:

Se copian los paquetes \*.deb al servidor, tal vez generando un tar.gz:

<pre class="sh_sh">
$ tar zcvf debs.tar.gz /var/cache/apt/archives/*.deb
$ sudo python -m SimpleHTTPServer 80
</pre>

[+] Servidor:

Extrayendo los \*.deb y copiandolos a import

<pre class="sh_sh">
$ wget http://ip_cliente/debs.tar.gz        
$ tar zxvf debs.tar.gz import/
$ sudo mkdir -pv -m 2755 /var/cache/apt-cacher-ng/_import
$ sudo mv -vuf import/*deb /var/cache/apt-cacher-ng/_import
$ sudo chown -R apt-cacher-ng:apt-cacher-ng /var/cache/apt-cacher-ng/_import
</pre>

[+] Cliente:

<pre class="sh_sh">
$ sudo apt-get update
</pre>

[+] Servidor:

Después de lo cual se puede ir a <http://localhost:9999/acng-report.html> y presionar '**Start import**':

#### Eliminar apt-cacher-ng

[+] Servidor:

<pre class="sh_sh">
$ sudo apt-get remove apt-cacher-ng && sudo rm -rf /var/cache/apt-cacher-ng
</pre>

[+] Clientes:

<pre class="sh_sh">
$ sudo add_proxy_repository remove
$ sudo rm -rf /usr/local/bin/add_proxy_repository
</pre>

### Conclusión

Creo que para efectos prácticos las personas deberían usar squid-deb-proxy cuando fuera posible, de todas las soluciones es la que menos pasos requiere, dos paquetes para el servidor y uno para el cliente, con igual número de instrucciones. Además de ser la única de funcionar out-of-the-box para laptops o computadoras que se conectan a diferentes redes (aún tengo que ver como importar paquetes). apt-cacher-ng también es una buena opción para computadoras que permaneceran en la misma red y no requiere avahi.
