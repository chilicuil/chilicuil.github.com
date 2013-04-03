---
layout: post
title: "sendemail"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

<div class="p"><a href="http://caspian.dotconf.net/menu/Software/SendEmail/">Sendemail</a> es un script en perl que permite enviar correo desde consola usando un servidor smtp externo:
</div>

<pre class="sh_sh">
$ sendemail -f from@foo.org        \
            -u titulo              \
            -m mensaje             \
            -t to@bar.com          \
            -s mail.foo.com:26     \
            -xu usuario            \
            -xp contraseña
</pre>
