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

Regresando al tema, he optado por una combinación entre **apt-cacher-ng** y **squid-deb-proxy-client**, juntos crean una solución rápida, estables, fácil de usar y dinámica.

### Desarrollo

&#91;+&#93; Servidor:

<pre class="sh_sh">
$ sudo apt-get install apt-cacher-ng squid-deb-proxy-client
$ sudo wget http://javier.io/mirror/apt-cacher-ng.service -O /etc/avahi/services/apt-cacher-ng.service
$ sudo service apt-cacher-ng restart
</pre>

&#91;+&#93; Cliente:

<pre class="sh_sh">
$ squid-deb-proxy-client
</pre>

Esto hará que el servidor anuncie apt-cacher-ng y que los clientes lo usen, cuando se encuentren en la misma red copiaran paquetes desde ahí, y cuando se muevan a otras localidades descargaran de Internet.

### Extra

#### Importar paquetes del servidor

Se pueden importar los paquetes que han sido descargados con anterioridad en el servidor:

&#91;+&#93; Servidor:

<pre class="sh_sh">
$ sudo mkdir -pv -m 2755 /var/cache/apt-cacher-ng/_import
$ sudo mv -vuf /var/cache/apt/archives/*.deb /var/cache/apt-cacher-ng/_import/
$ sudo chown -R apt-cacher-ng:apt-cacher-ng /var/cache/apt-cacher-ng/_import
$ sudo apt-get update
$ tree /var/cache/apt-cacher-ng
</pre>

Ahora se va a <http://localhost:9999/acng-report.html> y se presiona '**Start import**':

**[![](/assets/img/57.png)](/assets/img/57.png)**

#### Importar paquetes de otras máquinas

Se limpia \_import

&#91;+&#93; Servidor:

<pre class="sh_sh">
$ sudo rm -rf /var/cache/apt-cacher-ng/_import
</pre>

&#91;+&#93; Cliente:

Se copian los paquetes \*.deb al servidor, tal vez generando un tar.gz:

<pre class="sh_sh">
$ tar zcvf debs.tar.gz /var/cache/apt/archives/*.deb
$ sudo python -m SimpleHTTPServer 80
</pre>

&#91;+&#93; Servidor:

Extrayendo los \*.deb y copiandolos a import

<pre class="sh_sh">
$ wget http://ip_cliente/debs.tar.gz
$ tar zxvf debs.tar.gz import/
$ sudo mkdir -pv -m 2755 /var/cache/apt-cacher-ng/_import
$ sudo mv -vuf import/*deb /var/cache/apt-cacher-ng/_import
$ sudo chown -R apt-cacher-ng:apt-cacher-ng /var/cache/apt-cacher-ng/_import
</pre>

&#91;+&#93; Cliente:

<pre class="sh_sh">
$ sudo apt-get update
</pre>

&#91;+&#93; Servidor:

Después de lo cual se puede ir a <http://localhost:9999/acng-report.html> y presionar '**Start import**':

#### Nuevos equipos en nueva red

Los pasos descritos en la parte superior son buenos si ya se sabe de antemano el roll que desempeñara el equipo que tenemos, sin embargo que pasa cuando llegas a una nueva red?, como saber si ya existe un cache de apt-get?. Como el servicio se anuncia vía avahi, se puede hacer una busqueda e instalar solo la parte servidor/cliente dependiendo de si existe o no un proxy de apt-get.

<script src="https://gist.github.com/chilicuil/6207489.js"></script>

#### Eliminar apt-cacher-ng

&#91;+&#93; Servidor:

<pre class="sh_sh">
$ sudo apt-get remove apt-cacher-ng squid-deb-proxy-client
$ sudo rm -rf /var/cache/apt-cacher-ng
</pre>

&#91;+&#93; Clientes:

<pre class="sh_sh">
$ sudo apt-get remove squid-deb-proxy-client
</pre>

### Conclusión

Creo que para efectos prácticos las personas deberían usar squid-deb-proxy cuando fuera posible, de todas las soluciones es la que menos pasos requiere, dos paquetes para el servidor y uno para el cliente, con igual número de instrucciones. Además de ser la única de funcionar out-of-the-box para laptops o computadoras que se conectan a diferentes redes (aún tengo que ver como importar paquetes). apt-cacher-ng también es una buena opción para computadoras que permaneceran en la misma red y no requiere avahi.
