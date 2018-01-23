---
layout: post
title: "share connection between personal computers"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

### Wireless to wired

- **eth0:** wired link to other machine
- **eth1:** wireless link to internet

<pre class="sh_sh">
$ sudo ifconfig eth0 10.0.0.1
$ sudo iptables -F
$ sudo iptables -X
$ sudo iptables -t nat -F
$ sudo iptables -t nat -X
$ sudo iptables -t mangle -F
$ sudo iptables -t mangle -X
$ sudo iptables -P INPUT ACCEPT
$ sudo iptables -P FORWARD ACCEPT
$ sudo iptables -P OUTPUT ACCEPT
$ sudo iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
$ echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
</pre>

### Wired to wireless

- **eth0:** wired link to internet
- **eth1:** wireless interface as access point in ad-hoc mode

<pre class="sh_sh">
$ sudo iwconfig wlan0 mode ad-hoc
$ sudo iwconfig wlan0 essid proxywlan
$ sudo ifconfig wlan0 10.0.0.1 up
$ sudo iptables -F
$ sudo iptables -X
$ sudo iptables -t nat -F
$ sudo iptables -t nat -X
$ sudo iptables -t mangle -F
$ sudo iptables -t mangle -X
$ sudo iptables -P INPUT ACCEPT
$ sudo iptables -P FORWARD ACCEPT
$ sudo iptables -P OUTPUT ACCEPT
$ sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
$ echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
</pre>

After completing any of the previous steps (and if no dhcp daemon has been set up) the client machine will require to be configured manually, eg:

- **ip:** 10.0.0.2
- **gateway:** 10.0.0.1
- **dns:** 8.8.8.8

Otherwise you can run a [simple dhcpd](https://raw.githubusercontent.com/javier-lopez/learn/master/python/tools/simple-dhcpd) daemon:

<pre class="sh_sh">
$ sudo simple-dhcpd -i eth0 -a 10.0.0.1
</pre>
