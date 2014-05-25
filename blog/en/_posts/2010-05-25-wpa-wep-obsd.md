---
layout: post
title: "configure WPA/WEP in openbsd"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

### WPA - static ip

Since openbsd 4.4 (4.5 for ath0) it's possible to connect to wpa networks, it doesn't work with all drivers but eventually it should be viable with most of them.

<pre class="sh_sh">
$ ifconfig ath0 nwid ACCESS_POINT wpa wpapsk $(wpa-psk ACCESS_POINT PASSWORD)
$ ifconfig ath0 10.0.0.2 255.255.255.0 10.0.0.1  
</pre>

It can also be configured in **/etc/hostname.ath0** for connecting at boot time:

<pre class="sh_sh">
$ cat /etc/hostname.ath0
  inet 10.0.0.2 255.255.255.0 10.0.0.255 nwid ACCESS_POINT wpa wpapsk \
  0xc7bd82ef64a789369e18d6df63230a3b099f72a74b999bdbe837773e6081cb54
</pre>

The last parameter is taken from **$ wpa-psk ACCESS_POINT PASSWORD**

### WPA - dinamic ip

<pre class="sh_sh">
$ ifconfig ath0 nwid ACCESS_POINT wpa wpapsk $(wpa-psk ACCESS_POINT PASSWORD)
$ dhclient ath0
</pre>

**/etc/hostname.ath0**:

<pre class="sh_sh">
$ cat /etc/hostname.ath0
  dhcp nwid ACCESS_POINT wpa wpapsk \
  0xc7bd82ef64a789369e18d6df63230a3b099f72a74b999bdbe837773e6081cb54
</pre>

### WEP - static ip

<pre class="sh_sh">
$ ifconfig ath0 nwid ACCESS_POINT nwkey 0xPASSWORD
$ ifconfig ath0 10.0.0.2 255.255.255.0 10.0.0.1
</pre>

**/etc/hostname.ath0**:

<pre class="sh_sh">
$ cat /etc/hostname.ath0
  inet 10.0.0.2 255.255.255.0 10.0.0.255 nwid ACCESS_POINT nwkey 0xPASSWORD
</pre>

### WEP - dinamic ip

<pre class="sh_sh">
$ ifconfig ath0 nwid ACCESS_POINT nwkey 0xPASSWORD
$ dhclient ath0
</pre>

**/etc/hostname.ath0**:

<pre class="sh_sh">
$ cat /etc/hostname.ath0
  dhcp nwid ACESS_POINT nwkey  0xPASSWORD
</pre>

The same commands can be used from the installer (by using ! as prefix)
