---
layout: post
title: "logstash + redis + elasticsearch + kibana3"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

**[![](/assets/img/76.jpg)](/assets/img/76.jpg)**

- [logstash](http://logstash.net/)
- [redis](http://redis.io/)
- [elasticsearch](http://elasticsearch.org/)
- [kibana3](http://three.kibana.org/)
- [sendemail](http://caspian.dotconf.net/menu/Software/SendEmail/)

Un arcoiris de software libre + aws, linode, digital ocean.., es muy facil ser informatico en estos dias =), ¿interesado?, pruebalo (todo en uno, no recomendable para produccion, min 2gb):

<pre class="sh_sh">
$ bash &lt;(wget -qO- https://raw.github.com/chilicuil/learn/master/sh/log-stack)
</pre>

Si ya te convencio, entonces puedes asignarles a cada servicio su maquina(s).

##Extra, patterns

Para enviar correos dependiendo de los eventos se pueden usar varios plugins en logstash(exec, mail, etc), yo use el plugin file:

<pre class="sh_sh">
$ sudo service logstash-shipper stop
$ sudo vi /home/logstash/shipper.conf
$ sudo service logstash-shipper start
</pre>

<pre>
filter {
  grep {
    type =&gt; "syslog"
    match =&gt; ["@message","patron_aqui"]
    add_tag =&gt; "Alert_flood"
    drop =&gt; false
  }

output {
  file {
    type =&gt; "syslog"
    tags =&gt; [ "Alert_flood" ]
    message_format =&gt; "%{@message}"
    path =&gt; "/tmp/logstash_alert"
  }
</pre>

Y luego un script se ejecuta cada minuto para enviar las alertas:

<pre class="sh_sh">
$ sudo crontab -l
*/1 * * * * /usr/local/bin/check_alerts_logstash.sh
</pre>

- [http://cleversoft.wordpress.com/2013/04/05/887/](http://cleversoft.wordpress.com/2013/04/05/887/)
