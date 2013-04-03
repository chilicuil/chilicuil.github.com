---
layout: post
title: "configuración de WPA - WEP en openbsd"
---

## {{ page.title }}
<p class="date">{{ page.date | date_to_string }}</p>

<h3>WPA - ip estática</h3>

<div class="p">A partir de la versión 4.4 (4.5 para ath0) se ha agregado soporte para wpa, no todos los drivers lo soportan, pero para los que si lo hacen, un index rápido de los comandos son (aquí para atheros):
</div>

<pre class="sh_sh">
$ ifconfig ath0 nwid ACCESS_POINT wpa wpapsk $(wpa-psk ACCESS_POINT PASSWORD)
$ ifconfig ath0 10.0.0.2 255.255.255.0 10.0.0.1  
</pre>

<div class="p">También se puede agregar a <strong>/etc/hostname.ath0</strong>, para que se conecte al arranque:
</div>

<pre class="sh_sh">
$ cat /etc/hostname.ath0
  inet 10.0.0.2 255.255.255.0 10.0.0.255 \
  nwid ACCESS_POINT wpa wpapsk \
  0xc7bd82ef64a789369e18d6df63230a3b099f72a74b999bdbe837773e6081cb54
</pre>

<div class="p">Donde el último parámetro se obtiene de <strong>$ wpa-psk ACCESS_POINT PASSWORD</strong>
</div>

<h3>WPA - ip dinámica</h3>

<pre class="sh_sh">
$ ifconfig ath0 nwid ACCESS_POINT wpa wpapsk $(wpa-psk ACCESS_POINT PASSWORD)
$ dhclient ath0
</pre>

<div class="p">Y agregandolo a <strong>/etc/hostname.ath0</strong> quedaría:
</div>

<pre class="sh_sh">
$ cat /etc/hostname.ath0
  dhcp nwid ACCESS_POINT wpa wpapsk \
  0xc7bd82ef64a789369e18d6df63230a3b099f72a74b999bdbe837773e6081cb54
</pre>

<h3>WEP - ip estática</h3>

<pre class="sh_sh">
$ ifconfig ath0 nwid ACCESS_POINT nwkey 0xPASSWORD
$ ifconfig ath0 10.0.0.2 255.255.255.0 10.0.0.1
</pre>

<div class="p">Y agregandolo a <strong>/etc/hostname.ath0</strong> quedaría:
</div>

<pre class="sh_sh">
$ cat /etc/hostname.ath0
  inet 10.0.0.2 255.255.255.0 10.0.0.255 nwid ACCESS_POINT nwkey 0xPASSWORD
</pre>

<h3>WEP - ip dinámica</h3>

<pre class="sh_sh">
$ ifconfig ath0 nwid ACCESS_POINT nwkey 0xPASSWORD
$ dhclient ath0
</pre>

<div class="p">Y agregandolo a <strong>/etc/hostname.ath0</strong> quedaría:
</div>

<pre class="sh_sh">
$ cat /etc/hostname.ath0
  dhcp nwid ACESS_POINT nwkey  0xPASSWORD
</pre>

<div class="p">Los mismos comandos pueden usarse desde la instalacion, escapandolos con !
</div>
