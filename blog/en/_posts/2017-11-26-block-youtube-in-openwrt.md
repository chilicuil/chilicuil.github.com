---
layout: post
title: "block youtube in openwrt routers"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

In previous post I wrote about how to install [openwrt as an access point](http://javier.io/blog/en/2014/07/21/installing-openwrt-as-access-point.html) or as a [wireless repeater](http://javier.io/blog/en/2014/06/10/installing-openwrt-as-wireless-repeater.html), this time I'll show how to block youtube and other third party sites by ip. The procedure works in desktop / and mobile devices.

The target router is a [TP-Link N750](http://www.amazon.com/TP-LINK-TL-WDR4300-Wireless-Gigabit-300Mbps/dp/B0088CJT4U), and I'm using the latest [trunk build](http://downloads.openwrt.org/snapshots/trunk/ar71xx/).

**[![](/assets/img/98.jpg)](/assets/img/98.jpg)**

Openwrt uses [UCI](https://wiki.openwrt.org/doc/uci) to centralize the configuration of OpenWrt, firewall rules are located at:

- **/etc/config/firewall**

In order to block sites by IP you'll need to modify such file appending the desired rules, eg. for blocking YouTube:

<pre>
config rule
	option name		Block-YouTube-187.189.89.77/16
	option src		lan
	option family		ipv4
	option proto		all
	option dest		wan
	option dest_ip		187.189.89.77/16
	option target		REJECT

config rule
	option name		Block-YouTube-189.203.0.0/16
	option src		lan
	option family		ipv4
	option proto		all
	option dest		wan
	option dest_ip		189.203.0.0/16
	option target		REJECT

config rule
	option name		Block-YouTube-64.18.0.0/20
	option src		lan
	option family		ipv4
	option proto		all
	option dest		wan
	option dest_ip		64.18.0.0/20
	option target		REJECT

config rule
	option name		Block-YouTube-64.233.160.0/19
	option src		lan
	option family		ipv4
	option proto		all
	option dest		wan
	option dest_ip		64.233.160.0/19
	option target		REJECT

config rule
	option name		Block-YouTube-66.102.0.0/20
	option src		lan
	option family		ipv4
	option proto		all
	option dest		wan
	option dest_ip		66.102.0.0/20
	option target		REJECT

config rule
	option name		Block-YouTube-66.249.80.0/20
	option src		lan
	option family		ipv4
	option proto		all
	option dest		wan
	option dest_ip		66.249.80.0/20
	option target		REJECT

config rule
	option name		Block-YouTube-72.14.192.0/18
	option src		lan
	option family		ipv4
	option proto		all
	option dest		wan
	option dest_ip		72.14.192.0/18
	option target		REJECT

config rule
	option name		Block-YouTube-74.125.0.0/16
	option src		lan
	option family		ipv4
	option proto		all
	option dest		wan
	option dest_ip		74.125.0.0/16
	option target		REJECT

config rule
	option name		Block-YouTube-173.194.0.0/16
	option src		lan
	option family		ipv4
	option proto		all
	option dest		wan
	option dest_ip		173.194.0.0/16
	option target		REJECT

config rule
	option name		Block-YouTube-207.126.144.0/20
	option src		lan
	option family		ipv4
	option proto		all
	option dest		wan
	option dest_ip		207.126.144.0/20
	option target		REJECT

config rule
	option name		Block-YouTube-209.85.128.0/17
	option src		lan
	option family		ipv4
	option proto		all
	option dest		wan
	option dest_ip		209.85.128.0/17
	option target		REJECT

config rule
	option name		Block-YouTube-216.58.208.0/20
	option src		lan
	option family		ipv4
	option proto		all
	option dest		wan
	option dest_ip		216.58.208.0/20
	option target		REJECT

config rule
	option name		Block-YouTube-216.239.32.0/19
	option src		lan
	option family		ipv4
	option proto		all
	option dest		wan
	option dest_ip		216.239.32.0/19
	option target		REJECT
</pre>

Ensure to reboot the firewall service to apply the changes:

<pre class="sh_sh">
# /etc/init.d/firewall restart
</pre>

That's it, happy browsing &#9996;

- [Tl-wdr4300 in OpenWRT](http://wiki.openwrt.org/toh/tp-link/tl-wdr4300)
- [OpenWRT Firewall Documentation](https://wiki.openwrt.org/doc/uci/firewall)
- [YouTube IP Range](https://stackoverflow.com/a/28797030/890858)
