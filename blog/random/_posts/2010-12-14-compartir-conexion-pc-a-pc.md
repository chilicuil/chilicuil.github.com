---
layout: post
title: "compartir conexión pc a pc"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

<h3>Inalámbrica a alámbrica</h3>

<ul>
        <li><strong>eth0:</strong> conexión cruzada a otra máquina</li>
        <li><strong>eth1:</strong> conexión inalámbrica a internet</li>
</ul>

<pre class="sh_sh">
$ sudo ifconfig eth0 10.0.0.1
$ sudo iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
$ sudo su
# echo 1 > /proc/sys/net/ipv4/ip_forward
</pre>

<h3>Alámbrica a inalámbrica</h3>

<ul>
	<li><strong>eth0:</strong> conexión cableada a internet</li>
	<li><strong>eth1:</strong> access point, compartición ad-hoc</li>
</ul>

<pre class="sh_sh">
$ iwconfig wlan0 mode ad-hoc
$ iwconfig wlan0 essid proxywlan
$ ifconfig wlan0 10.0.0.1 up #o la ip que gustes
$ iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
$ sudo su
# echo 1 > /proc/sys/net/ipv4/ip_forward
</pre>

<div class="p">En la máquina 'cliente', se configura la conexión con los siguientes datos:
</div>

<ul>
	<li><strong>ip:</strong> 10.0.0.2</li>
	<li><strong>gatewat:</strong> 10.0.0.1</li>
	<li><strong>dns:</strong> 10.0.0.1</li>
</ul>

<div class="p"><a href="http://mononeurona.org/entries/view/vendaval/20911" target="_blank">ad-hoc para compartir internet</a>
</div>
