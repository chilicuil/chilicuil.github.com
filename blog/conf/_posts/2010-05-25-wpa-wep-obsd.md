---
layout: post
title: "configuración de WPA - WEP en openbsd"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

### WPA - ip estática

A partir de la versión 4.4 (4.5 para ath0) se ha agregado soporte para wpa, no todos los drivers lo soportan, pero para los que si lo hacen, un index rápido de los comandos son (aquí para atheros):

<pre class="sh_sh">
$ ifconfig ath0 nwid ACCESS_POINT wpa wpapsk $(wpa-psk ACCESS_POINT PASSWORD)
$ ifconfig ath0 10.0.0.2 255.255.255.0 10.0.0.1  
</pre>

También se puede agregar a **/etc/hostname.ath0**, para que se conecte al arranque:

<pre class="sh_sh">
$ cat /etc/hostname.ath0
  inet 10.0.0.2 255.255.255.0 10.0.0.255 \
  nwid ACCESS_POINT wpa wpapsk \
  0xc7bd82ef64a789369e18d6df63230a3b099f72a74b999bdbe837773e6081cb54
</pre>

Donde el último parámetro se obtiene de **$ wpa-psk ACCESS_POINT PASSWORD**

### WPA - ip dinámica

<pre class="sh_sh">
$ ifconfig ath0 nwid ACCESS_POINT wpa wpapsk $(wpa-psk ACCESS_POINT PASSWORD)
$ dhclient ath0
</pre>

Y agregandolo a **/etc/hostname.ath0** quedaría:

<pre class="sh_sh">
$ cat /etc/hostname.ath0
  dhcp nwid ACCESS_POINT wpa wpapsk \
  0xc7bd82ef64a789369e18d6df63230a3b099f72a74b999bdbe837773e6081cb54
</pre>

### WEP - ip estática

<pre class="sh_sh">
$ ifconfig ath0 nwid ACCESS_POINT nwkey 0xPASSWORD
$ ifconfig ath0 10.0.0.2 255.255.255.0 10.0.0.1
</pre>

Y agregandolo a **/etc/hostname.ath0** quedaría:

<pre class="sh_sh">
$ cat /etc/hostname.ath0
  inet 10.0.0.2 255.255.255.0 10.0.0.255 nwid ACCESS_POINT nwkey 0xPASSWORD
</pre>

### WEP - ip dinámica

<pre class="sh_sh">
$ ifconfig ath0 nwid ACCESS_POINT nwkey 0xPASSWORD
$ dhclient ath0
</pre>

Y agregandolo a **/etc/hostname.ath0** quedaría:

<pre class="sh_sh">
$ cat /etc/hostname.ath0
  dhcp nwid ACESS_POINT nwkey  0xPASSWORD
</pre>

Los mismos comandos pueden usarse desde la instalacion, escapandolos con !
