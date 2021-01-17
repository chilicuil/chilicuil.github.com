---
layout: post
title: "transfer files with netcat"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

Here goes a quick note about how to transfer files in a LAN between computers,
**netcat** is available in a wide range of different platforms because of its
simplicity.

### Receiving node (192.168.1.74)

<pre class="sh_sh">
$ mkdir backup/ && cd backup/
$ nc -l -p 7000 | pv (optional, pretty ETA visualizator) | tar x
</pre>

### Sending node

<pre class="sh_sh">
$ tar cf - * | nc 192.168.1.74 7000
</pre>

That's it, happy sharing, &#128522;
