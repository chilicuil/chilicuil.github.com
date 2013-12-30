---
layout: post
title: "enviar correo desde terminal"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

En algunos sistemas, el comando *mail* se encuentra instalado por defecto, y se usa para enviar correos entre los usuarios del sistema. Por otra parte, desde que tengo memoria, nunca he usado sistemas basados en unix que tenga que compartir, siempre es mi propia maquina con un unico usuario (el mio). Sin embargo, la idea de tener un comando *mail* es atractiva. Esto no significa que este dispuesto a configurar un servidor de correos en mi computadora, solo quiero un cliente facil de configurar que use mi cuenta de gmail u otro servicio para enviar mensajes.

Hace años que uso [Sendemail](http://caspian.dotconf.net/menu/Software/SendEmail/), un script en perl que envia correos conectandose a un servidor smtp externo.

<pre class="sh_sh">
$ sendemail -f from@foo.org        \
            -u titulo              \
            -m mensaje             \
            -t to@bar.com          \
            -s mail.foo.com:26     \
            -xu usuario            \
            -xp contraseña
</pre>

Para gmail, se requieren las librerias *libio-socket-ssl-perl* y *libnet-ssleay-perl* y habilitar tls:

<pre class="sh_sh">
$ sendemail -f from@foo.org        \
            -u titulo              \
            -m mensaje             \
            -t to@bar.com          \
            -s smtp:gmail.com:587  \
            -o tls=yes             \
            -xu usuario            \
            -xp contraseña
</pre>

Esto funciona la mayoría de las veces. Por ejemplo, cuando se envian los correos desde la misma computadora donde se suela revisar el correo. Pero no cuando se utiliza desde servidores remotos, gmail rechazara el login desde ips desconocidas, una buena practica de seguridad, pero inconveniente cuando quiero enviar correos rapidos desde otros lugares.

Afortunadamente, existe [http://mailgun.com](http://mailgun.com) un servicio que encapsula el protocolo smtp en servicios web. Con ello, pude crear en poco tiempo un script *mail* que hace justamente lo que quiero, enviar correos, desde cualquier lugar rapido y sin configuraciones. Este ultimo, solo require **curl**, así que es lo que uso ahora.

<pre class="sh_sh">
$ wget https://raw.github.com/chilicuil/learn/master/sh/tools/mail
$ bash mail "hacia@gmail.com" "mensaje"
</pre>

<iframe src="http://showterm.io/6d595bb4e5424b943e54f" width="640" height="300" style="display:block; margin: 0 auto;">&nbsp;</iframe> 
