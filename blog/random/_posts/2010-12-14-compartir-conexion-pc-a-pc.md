---
layout: post
title: "compartir conexión pc a pc"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

### Inalámbrica a alámbrica

**eth0:** conexión cruzada a otra máquina
**eth1:** conexión inalámbrica a internet

<pre class="sh_sh">
$ sudo ifconfig eth0 10.0.0.1
$ sudo iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
$ sudo su
# echo 1 > /proc/sys/net/ipv4/ip_forward
</pre>

### Alámbrica a inalámbrica

- **eth0:** conexión cableada a internet
- **eth1:** access point, compartición ad-hoc

<pre class="sh_sh">
$ iwconfig wlan0 mode ad-hoc
$ iwconfig wlan0 essid proxywlan
$ ifconfig wlan0 10.0.0.1 up #o la ip que gustes
$ iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
$ sudo su
# echo 1 > /proc/sys/net/ipv4/ip_forward
</pre>

En la máquina 'cliente', se configura la conexión con los siguientes datos:

- **ip:** 10.0.0.2
- **gatewat:** 10.0.0.1
- **dns:** 10.0.0.1

[ad-hoc para compartir internet](http://mononeurona.org/entries/view/vendaval/20911)
