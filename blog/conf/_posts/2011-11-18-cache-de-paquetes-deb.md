---
layout: post
title: "caché de paquetes .deb"
---

## {{ page.title }}
<p class="date">{{ page.date | date_to_string }}</p>

<h3>Introducción</h3>

<p>Hay varias soluciones para crear cachés de paquetes, las únicas que he utilizado han sido <a href="http://packages.qa.debian.org/d/debmirror.html">debmirror</a> y <a href="http://www.unix-ag.uni-kl.de/%7Ebloch/acng/">apt-cacher-ng</a>, la primera crea una copia exacta de los repositorios que se deseen, es decir 35GB~ por cada distribucion / arquitectura, lo que ha efectos prácticos no me parece óptimo (si de lo que se trata es de ahorrar ancho de banda), no solo se descargan demasiados GB inicialmente sino que cada noche se debe correr una actualización general. Tal vez sea práctico para organizaciones con no menos de 100 equipos.</p>

<p>Para el resto, y atendiendome a mi propia experiencia se pueden usar herramientas que van creando el cache <strong>'on demand'</strong>, es decir para que con cada nuevo programa que se descargue, se haga la petición al servidor, este lo obtenga y lo envie de vuelta a quien lo solicito, a partir de lo cual, cualquier otro equipo que lo necesite lo obtenga de la red LAN, lo que será mucho más rápido.</p>

<p>Algunas de estas herramientas son <strong>apt-proxy</strong>, <strong>apt-cacher</strong>, <strong>apt-cacher-ng</strong> y <strong>squid-deb-proxy</strong>, una revisión esta disponible en:</p>

<p><a href="http://askubuntu.com/questions/3503/best-way-to-cache-apt-downloads-on-a-lan" target="_blank">http://askubuntu.com/questions/3503/best-way-to-cache-apt-downloads-on-a-lan</a></p>

<p>A propósito de askubuntu, es increible ver la cantidad de respuestas útiles que se encuentran en ese sitio, creo que ha desbancado a <a href="http://answers.launchpad.net/ubuntu">answers.launchpad.net/ubuntu</a> como el sitio predilecto para hacer preguntas de cualquier nivel técnico asociados a Ubuntu.</p>

<p>Regresando al tema, he optado por <strong>apt-cacher-ng</strong> porque es rápido, estable y mantiene todas las cosas unidas desde un solo programa, uno no requiere instalar un servidor web por ejemplo.</p>

<h3>Desarrollo</h3>

<p>[+] Servidor:</p>

<pre class="sh_sh">
$ sudo apt-get install apt-cacher-ng
$ sudo sed -i -e 's/3142/9999/g' /etc/apt-cacher-ng/acng.conf
$ sudo service apt-cacher-ng restart
</pre>

<p>Lo que lo hará compatible con <strong>apt-proxy</strong> (por lo del puerto 9999)</p>

<p>[+] Cliente:</p>

<pre class="sh_sh">
$ wget http://ubuntuone.com/4PXwbNWmNj5kK9AUkEb9fF -O add_proxy_repository
$ sudo chmod +x $_ 
$ sudo mv -v $_ /usr/local/bin
</pre>

<p>Lo que dejará un script en <strong>/usr/local/bin</strong> llamado <strong>add_proxy_repository</strong>, el cual puede ser llamado de cualquiera de estas formas:</p>

<pre class="sh_sh">
$ add_proxy_repository [add|remove]
</pre>

<p>Por alguna torpe razón, apt-get se empeñará en usar el proxy aún cuando no este disponible.., cuando esto pase, se debe usar el script para deshabilitar el proxy, en caso de querer automatizarlo, se puede usar <u>squid-deb-proxy-client</u> que verifica la conexión y dependiendo del estado en <a href="http://avahi.org">avahi</a> habilitaran deshabilitaran la línea que afecta a apt..., creo que sería mucho más práctico que apt-get siguiera leyendo sources.list y tomará los repositorios declarados ahí en caso de no encontrar accesible la dirección del proxy...</p>

<p>A efectos prácticos y para máquinas de escritorio, solo se correrá una única vez <strong>$ add_proxy_repository add</strong>.., mientras que para laptops significa estar habilitando/deshabilitando de acuerdo a la red en la que se encuentre, por lo que si puedo sugerir algo, es que se use este script para máquinas de escritorio y se de preferencia a <strong>squid-deb-proxy</strong> cuando se trate de una laptop</p>

<h3>Extra</h3>

<h4>Servidor / cliente</h4>

<p>Para que los paquetes del servidor también se agreguen al caché, sera necesario configurarlo como cliente</p>

<p>[+] Servidor:</p>

<pre class="sh_sh">
$ add_proxy_repository add #IP: localhost
</pre>

<h4>Importar paquetes del servidor</h4>

<p>Se pueden importar los paquetes que han sido descargados con anterioridad en el servidor:</p>

<p>[+] Servidor:</p>

<pre class="sh_sh">
$ sudo mkdir -pv -m 2755 /var/cache/apt-cacher-ng/_import
$ sudo mv -vuf /var/cache/apt/archives/*.deb /var/cache/apt-cacher-ng/_import/
$ sudo chown -R apt-cacher-ng:apt-cacher-ng /var/cache/apt-cacher-ng/_import
$ sudo apt-get update
$ tree /var/cache/apt-cacher-ng
</pre>

<p>Se va a <a href="http://localhost:9999/acng-report.html">http://localhost:9999/acng-report.html</a> y se presiona '<strong>Start import</strong>':</p>

<p align="center" id="img"><img src="/assets/img/57.png" style="width: 406px; height: 175px;">
</p>

<h4>Importar paquetes de otras máquinas</h4>

<p>Se limpia _import</p>

<p>[+] Servidor:</p>

<pre class="sh_sh">
$ sudo rm -rf /var/cache/apt-cacher-ng/_import
</pre>

<p>[+] Cliente:</p>

<p>Se copian los paquetes *.deb al servidor, tal vez generando un tar.gz:</p>

<pre class="sh_sh">
$ tar zcvf debs.tar.gz /var/cache/apt/archives/*.deb
$ sudo python -m SimpleHTTPServer 80
</pre>

<p>[+] Servidor:</p>

<p>Extrayendo los *.deb y copiandolos a import</p>

<pre class="sh_sh">
$ wget http://ip_cliente/debs.tar.gz        
$ tar zxvf debs.tar.gz import/
$ sudo mkdir -pv -m 2755 /var/cache/apt-cacher-ng/_import
$ sudo mv -vuf import/*deb /var/cache/apt-cacher-ng/_import
$ sudo chown -R apt-cacher-ng:apt-cacher-ng /var/cache/apt-cacher-ng/_import
</pre>

<p>[+] Cliente:</p>

<pre class="sh_sh">
$ sudo apt-get update
</pre>

<p>[+] Servidor:
</p>

<p>Después de lo cual se puede ir a <a href="http://localhost:9999/acng-report.html">http://localhost:9999/acng-report.html</a> y presionar '<strong>Start import</strong>':</p>

<h4>Eliminar apt-cacher-ng</h4>

<p>[+] Servidor:
</p>

<pre class="sh_sh">
$ sudo apt-get remove apt-cacher-ng && sudo rm -rf /var/cache/apt-cacher-ng
</pre>

<p>[+] Clientes:
</p>

<pre class="sh_sh">
$ sudo add_proxy_repository remove
$ sudo rm -rf /usr/local/bin/add_proxy_repository
</pre>

<h3>Conclusión</h3>

<p> Creo que para efectos prácticos las personas deberían usar squid-deb-proxy cuando fuera posible, de todas las soluciones es la que menos pasos requiere, dos paquetes para el servidor y uno para el cliente, con igual número de instrucciones. Además de ser la única de funcionar out-of-the-box para laptops o computadoras que se conectan a diferentes redes (aún tengo que ver como importar paquetes). apt-cacher-ng también es una buena opción para computadoras que permaneceran en la misma red y no requiere avahi.</p>