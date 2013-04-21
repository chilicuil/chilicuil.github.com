---
layout: post
title: "sendemail"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

[Sendemail](http://caspian.dotconf.net/menu/Software/SendEmail/) es un script en perl que permite enviar correo desde consola usando un servidor smtp externo:

<pre class="sh_sh">
$ sendemail -f from@foo.org        \
            -u titulo              \
            -m mensaje             \
            -t to@bar.com          \
            -s mail.foo.com:26     \
            -xu usuario            \
            -xp contraseña
</pre>

Para gmail, se instalan *libio-socket-ssl-perl* y *libnet-ssleay-perl* y luego:

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
