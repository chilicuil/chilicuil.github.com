---
layout: post
title: "installing openwrt as an access point"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

In previous post I wrote about how to use [openwrt as a wireless repeater](http://javier.io/blog/en/2014/06/10/installing-openwrt-as-wireless-repeater.html), this time I'll use it as an independent access point with its own subnet, how practical!

The target device is a [TP-Link N750](http://www.amazon.com/TP-LINK-TL-WDR4300-Wireless-Gigabit-300Mbps/dp/B0088CJT4U), and I'm using the latest [trunk build](http://downloads.openwrt.org/snapshots/trunk/ar71xx/), the installation process is pretty straigh forward.

**[![](/assets/img/98.jpg)](/assets/img/98.jpg)**

<pre class="sh_sh">
$ wget downloads.openwrt.org/snapshots/trunk/ar71xx/generic/openwrt-ar71xx-generic-tl-wdr4300-v1-squashfs-factory.bin
</pre>

Or, when there is a previous openwrt version installed:

<pre class="sh_sh">
$ wget downloads.openwrt.org/snapshots/trunk/ar71xx/generic/openwrt-ar71xx-generic-tl-wdr4300-v1-squashfs-sysupgrade.bin
</pre>

After completing the download, install it by going to the **Firmware Upgrade** menu and selecting the openwrt firmware.

**[![](/assets/img/99.png)](/assets/img/99.png)**

Be aware that the trunk build is minimal, it doesn't include the [luci web interface](https://github.com/openwrt/luci), so it's up to every person to decide if they want it or not.

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
openwrt # passwd #set the root passwd in case telnet service isn't available
openwrt # ifconfig br-lan 10.9.8.7
$ while true; do sudo ifconfig eth0 10.9.8.10; sleep 1; done #bypass networkmanager
$ ssh root@10.9.8.7
openwrt # route add default gw 10.9.8.10
openwrt # echo "nameserver 8.8.8.8" &gt; /etc/resolv.conf
openwrt # opkg update
openwrt # opkg install luci
openwrt # /etc/init.d/uhttpd enable
openwrt # /etc/init.d/uhttpd start
</pre>

Upon completing the installation, go to [http://10.9.8.7](http://10.9.8.7) and reconfigure the LAN interface to make permanent the IP address:

- Network &#x25B7; Interfaces &#x25B7; LAN

**[![](/assets/img/100.png)](/assets/img/100.png)**

Create the Access Point (linked to the **lan** interface)

- Network &#x25B7; Wifi &#x25B7; Add

**[![](/assets/img/openwrt-ap.png)](/assets/img/openwrt-ap.png)**

Connect an ethernet cable to the WAN interface (on this device it's a blue port behind) and enjoy!, happy browsing &#9996;

- [http://wiki.openwrt.org/toh/tp-link/tl-wdr4300](http://wiki.openwrt.org/toh/tp-link/tl-wdr4300)
