---
layout: post
title: "installing openwrt as a wireless repeater"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

Last weekend I spend some time at my parents house and the occasion was appropriate to extend the wifi signal to cover the whole house, since I don't intend to repeat the setup in the nearby future but would like still to have a reference, I decided to wrap it up in a post &#9786;

First thing I did was to grab a TP-Link N750, formally a [TL-WDR4300 Version 1.7](http://www.amazon.com/TP-LINK-TL-WDR4300-Wireless-Gigabit-300Mbps/dp/B0088CJT4U) router for $60 at a nearby shop, I didn't choose it for anything particular, but because of its nice antennas and dual-band support.

**[![](/assets/img/98.jpg)](/assets/img/98.jpg)**

Getting the latest openwrt [trunk build](http://downloads.openwrt.org/snapshots/trunk/ar71xx/) and install it on the device is pretty straight forward.

<pre class="sh_sh">
$ wget downloads.openwrt.org/snapshots/trunk/ar71xx/generic/openwrt-ar71xx-generic-tl-wdr4300-v1-squashfs-factory.bin
</pre>

Or to upgrade it from a previous release:

<pre class="sh_sh">
$ wget downloads.openwrt.org/snapshots/trunk/ar71xx/generic/openwrt-ar71xx-generic-tl-wdr4300-v1-squashfs-sysupgrade.bin
</pre>

To flash the image go to the "System Tools" &#x25B7; "Firmware Upgrade" menu

**[![](/assets/img/99.png)](/assets/img/99.png)**

Be aware that the trunk build is minimal, it doesn't include the [luci web interface](luci.subsignal.org), so it's up to every person to decide if they want it or not.

To install additional software connect to the device and share temporary your laptop/desktop internet

<pre class="sh_sh">
# flush previous iptables rules
$ sudo iptables -F
$ sudo iptables -X
$ sudo iptables -t nat -F
$ sudo iptables -t nat -X
$ sudo iptables -t mangle -F
$ sudo iptables -t mangle -X
$ sudo iptables -P INPUT ACCEPT
$ sudo iptables -P FORWARD ACCEPT
$ sudo iptables -P OUTPUT ACCEPT
</pre>

<pre class="sh_sh">
# route laptop traffic through wlan0 (wireless) interface
$ sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
$ echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
$ while true; do sudo ifconfig eth0 192.168.1.2; sleep 1; done
$ telnet 192.168.1.1 #type "passwd" to set the root passwd
# be aware than in current openwrt releases telnet is no longer provided
# in those cases just skip this step
$ ssh root@192.168.1.1 #from other terminal window
openwrt # passwd #set the root passwd in case telnet service wasn't available
openwrt # ifconfig br-lan 10.9.8.7
$ while true; do sudo ifconfig eth0 10.9.8.10; sleep 1; done #bypass networkmanager
$ ssh root@10.9.8.7
openwrt # route add default gw 10.9.8.10
openwrt # echo "nameserver 8.8.8.8" &gt; /etc/resolv.conf
openwrt # opkg update
openwrt # opkg install luci relayd
openwrt # /etc/init.d/uhttpd enable
openwrt # /etc/init.d/uhttpd start
openwrt # /etc/init.d/relayd enable
openwrt # /etc/init.d/relayd start
</pre>

Upon completing the installation, go to the web interface, [http://10.9.8.7](http://10.9.8.7), and reconfigure the LAN interface to make permanent the IP address:

- Network &#x25B7; Interfaces &#x25B7; LAN

**[![](/assets/img/100.png)](/assets/img/100.png)**

Now, it's time to create the bridge interface (bonding the **lan** and **wwan** interfaces)

**[![](/assets/img/101.png)](/assets/img/101.png)**

**[![](/assets/img/openwrt-bridge.png)](/assets/img/openwrt-bridge.png)**

And join the nearby AP (linked to the **bridge/wwan** interface)

- Network &#x25B7; Wifi &#x25B7; Scan

**[![](/assets/img/openwrt-client.png)](/assets/img/openwrt-client.png)**

Finally, don't forget to create the AP repeater (linked to the **lan** interface)

- Network &#x25B7; Wifi &#x25B7; Add

**[![](/assets/img/openwrt-ap.png)](/assets/img/openwrt-ap.png)**

That's it!, a simple and robust wifi extender &#9996;

- [http://wiki.openwrt.org/toh/tp-link/tl-wdr4300](http://wiki.openwrt.org/toh/tp-link/tl-wdr4300)
- [http://tombatossals.github.io/openwrt-repetidor-wireless/](http://tombatossals.github.io/openwrt-repetidor-wireless/)
