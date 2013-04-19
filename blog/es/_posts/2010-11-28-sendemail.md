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
