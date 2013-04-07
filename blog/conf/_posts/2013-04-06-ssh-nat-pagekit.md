---
layout: post
title: "conexión a ssh transpasando nats en dominio personalizado"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

Muy bien, admito que el título pudo ser mejor, pero piensen en esto, una forma de conectarse a una computadora sin tener que modificar las reglas de nateo de un router y utilizando siempre el mismo dominio (su dominio), incluso cuando la maquina a la que deseen conectarse este cambiando entre redes. Todo esto con solo 1 comando, si esto no los emociona, pueden dejar de leer ahora.

[![alt text](/assets/img/67.png)](/assets/img/67.png)

Si han pensado en dyndns y proyectos similares han estado cerca, pero dyndns solo permite mantener un sub dominio (no muy atractivo) y se tienen que seguir configurando los routers para permitir el paso a los puertos que nos interesan. Antes de continuar un poco de background, soy un fanatico de la personalización, mi computadora tiene una configuración que me ha tomado años definir, y que me permite (en mi propia opinion) hacer mas con menos. Cientos de aliases, 5-6 entornos chroots preconfigurados, maquinas virtuales locales (y remotas, ec2), un archivo .bash_history de ~38,000 lineas... También soy fan de la portabilidad, no me gusta llevar nada conmigo a excepción de un telefono, unos audifonos y un libro.

Así pues, la solución es conectarme a mi equipo desde donde sea que este yo y el, ahora mismo lo hago de esta forma:

<pre class="sh_sh">
[algun_lugar] $ ssh home.javier.io
</pre>

No importa donde este, tampoco importa en que red se encuentre mi equipo personal, este comando funcionará, =) Esto no solo puede usarse para logearse a su computadora, si se dedican al desarrollo web y quieren mostrar su trabajo en menos de 1min y solo por el tiempo que deseen puede servirles. Todo empieza con una cuenta en <http://pagekite.net> (un proyecto de software libre), startup de [Bjarni Einarsson](http://bre.klaki.net/), hacker islandes.

Una vez con su una cuenta, podran correr:

<pre class="sh_sh">
$ curl -s https://pagekite.net/pk/ |sudo bash #lo que instalara pagekite, 1 solo archivo
$ pagekite.py 80 yourname.pagekite.me
</pre>

Y tendran su servidor web accesible en la red, tomaré por sentado que pueden instalar y configurar pagekite hasta aquí. Ahora mostrare como hacerlo para que resuelva a su dominio y con el protocolo ssh en lugar del http (corriendo en el puerto 1003).

<pre class="sh_sh">
$ ssh home.javier.io
</pre>

           192.168.1.x       home.javier.io  home.javier.pagekite.me   192.168.1.x
           :::::::::::        :::::::::::          ::::::::::::        :::::::::::::::
           | cliente |   =>   | dominio |    =>    | pagekite |     => | servidor ssh|
           :::::::::::        :::::::::::          ::::::::::::        :::::::::::::::

Hay que notar, que aunque el servidor ssh corre en el puerto 1003 (o en el que ustedes quieran), al momento de conectarse, se hace la referencia al puerto por defecto (22), corto y seguro.

- Cname

Para que esto funcione, home.javier.io debe apuntar a pagekite, esto se hace agregando una entrada CNAME al dns de su dominio, para mi caso, he creado una entrada de **home** a **home.javier.pagekite.me** desde <http://iwantmyname.com>, que es donde registro mis dominios y que recomiendo.

[![alt text](/assets/img/69.png)](/assets/img/69.png)

- Subdominio en [pagekite.me](http://pagekite.net)

Cuando se registra una cuenta, pagekite otorga un subdominio en forma de **su_nick.pagekite.me**, sin embargo a esos subdominios tambien se les [pueden agregar más](https://pagekite.net/signup/?more=free) subdominios a la vez, **subdominio.su_nick.pagekite.me**: 

[![alt text](/assets/img/70.png)](/assets/img/70.png)

- Kite home.javier.io

Finalmente, [se crea una entrada](https://pagekite.net/signup/?more=cname#cnameForm) con **home.javier.io** en el registreo de kites.

[![alt text](/assets/img/71.png)](/assets/img/71.png)

De regreso al [índice](https://pagekite.net/home/), la cuenta debería lucir así.

[![alt text](/assets/img/72.png)](/assets/img/72.png)

### Servidor

Si esto es verdad, se puede configurar el 'servidor' (la máquina a la que queremos conectarnos) editando el archivo) **$HOME/.pagekite.rc**:

    ###[ Current settings for pagekite.py v0.5.6a. ]#########
    #
    ## NOTE: This file may be rewritten/reordered by pagekite.py.
    #
     
    ##[ Default kite and account details ]##
    kitename = javier.pagekite.me
    kitesecret = KITESECRET_KEY
     
    ##[ Front-end settings: use pagekite.net defaults ]##
    defaults
     
    ##[ Back-ends and local services ]##
    service_on = http:@kitename : localhost:80 : @kitesecret
    service_on = raw-22:@kitename : localhost:1003 : @kitesecret
    service_on = raw-22:home.javier.pagekite.me : localhost:1003 : @kitesecret
    service_on = raw-22:home.javier.io : localhost:1003 : @kitesecret
     
    ##[ Miscellaneous settings ]##
    savefile = /home/chilicuil/.pagekite.rc
     
    ###[ End of pagekite.py configuration ]#########
    END

Una vez hecho eso, se arranca:

maquina_a_la_que_quiero_conectarme $ ./pagekite.py

Y en menos de 1 minuto las urls se actualizaran para poder entrar a los servicios configurados (para este ejemplo, http y ssh).

### Cliente

Para conectarse desde cualquier cliente via ssh. Se edita **$HOME/.ssh/config**:

    Host home.javier.io
        CheckHostIP no
        ProxyCommand /bin/nc -X connect -x %h:443 %h %p

Es todo, desde ese momento, cada vez que tengan que dejar su equipo en algun lugar, se ejecuta $ pagekite.py , y desde otro equipo, $ ssh subdominio@dominio.com

Pagekite es software libre, pueden correr la parte que hace de intermediaria en un [vps](http://es.wikipedia.org/wiki/Servidor_virtual_privado) o en una computadora que tenga ip pública.
