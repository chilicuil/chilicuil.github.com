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

[Composition](http://en.wikipedia.org/wiki/Unix_philosophy) applied to logging has been a great sucess lately, this week I've verified how easy is to use logstash and friends with 48 servers distributed in two datacenters, I've created a script to deploy all programs in a single node.

<pre class="sh_sh">
$ bash &lt;(wget -qO- https://raw.github.com/chilicuil/learn/master/sh/is/log-stack)
</pre>

**[![](/assets/img/77.jpg)](/assets/img/77.jpg)**

If you prefer using a node per service you'll need to go your own way, it shouldn't be too difficult.

##Extra, patterns

To send emails when a pattern is found, I used the grep and file logstash filters:

<pre class="sh_sh">
$ sudo service logstash-shipper stop
$ sudo vi /home/logstash/shipper.conf
$ sudo service logstash-shipper start
</pre>

**/home/logstash/shipper.conf**

<pre>
filter {
  grep {
    type =&gt; "syslog"
    match =&gt; ["@message","pattern"]
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

WARNING: shipper.conf doesn't look exactly like this, these snippets must be integrated with your own files, copy and paste won't work. If you're not sure about the syntax, take a look at logstash [documentation](http://logstash.net/docs/1.1.13/).

So, after rebooting the service logstash will add an "Alert_flood" tag to all messages where the pattern is found and will copy these messages (besides sending them to redis) to **/tmp/logstash_alert**.

Finally I wrote a [script](https://gist.github.com/chilicuil/6066888) to send warning messages by email to the admins:

<pre class="sh_sh">
$ sudo crontab -l
*/1 * * * * /usr/local/bin/check_alerts_logstash.sh
</pre>

- [http://cleversoft.wordpress.com/2013/04/05/887/](http://cleversoft.wordpress.com/2013/04/05/887/)
