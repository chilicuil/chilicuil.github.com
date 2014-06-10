---
layout: post
title: "installing openwrt as a wireless repeater"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

I just love how certain peaces of technology can help to fix annoying problems. Back at home during the last weekend besides having a lot of compliments, hugs, and great food was also the perfect time to fix technological problems, as the official techi of the family. I recovered from trash an [old netbook](http://www.laptopmag.com/review/laptops/lenovo-ideapad-s10e.aspx), fixed the power button of a [mini component](http://www.lg.com/ae/support-product/lg-LX-U250D), replaced lightbulbs and setup a wireless repeater. And since the last activity was quite interesting I decided to wrap it up in a post &#9786;

My parents house isn't really big, but even so the wifi signal doesn't cover some parts of it, [ISP routers](http://www.ebay.com/ctg/2Wire-2701HG-T-54-Mbps-4-Port-10-100-Wireless-G-Router-/110406908) are getting worst year after year =/... anyway I decided to buy a repeater and setup everything as fast as possible. I got a TP-Link N750, formally a [TL-WDR4300 Version 1.7](http://www.amazon.com/TP-LINK-TL-WDR4300-Wireless-Gigabit-300Mbps/dp/B0088CJT4U), for $60, ate some noddles and got back happily. I didn't even repared in the fact that the device wasn't suppose to act as a repeater, I was just looking for any dual-band router with nice antennas, so when I look at this I just bought it.

**[![](/assets/img/98.jpg)](/assets/img/98.jpg)**

Later on, when I actually read the manual and realized it wasn't going to be as easy as I though I promptly replaced the original firmware with openwrt, I prefer minimalism systems because with them you have at least a remote chance of understanding what's happening.., the process isn't really dificult, it starts by downloading the latest openwrt [trunk build](http://downloads.openwrt.org/snapshots/trunk/ar71xx/) (I read [somewhere](https://forum.openwrt.org/viewtopic.php?pid=228641#p228641) there are [problems](https://forum.openwrt.org/viewtopic.php?id=48226) with the stable version):

<pre class="sh_sh">
$ wget downloads.openwrt.org/snapshots/trunk/ar71xx/openwrt-ar71xx-generic-tl-wdr4300-v1-squashfs-factory.bin
</pre>

After completing the download, it can be installed by going to the "Firmware Upgrade" menu of the Link web interface and selecting the openwrt firmware.

**[![](/assets/img/99.png)](/assets/img/99.png)**

The trunk build is quite raw it doesn't install the [classic web interface](luci.subsignal.org), so it's up to every person to decide if they want it or not, in my case I decided to install it because it's not a device I'll manage but my sister (who lives with my parents) and I don't think she'll be happy with the idea of using a cli interface =)

So, I got connected to the device, changed temporally the network (to provide internet to the device) and installed luci (web interface) and relayd (repeater).

<pre class="sh_sh">
$ sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE #share temporally wireless internet
$ echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward 
$ telnet 192.168.1.1 #and type "passwd"
$ ssh root@192.168.1.1
openwrt # ifconfig br-lan 10.9.8.7
$ sudo ifconfig eth0 10.9.8.10
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

After completing the installation phase, I went to the web interface, [http://10.9.8.7](http://10.9.8.7), created a root password (equals to the wifi's one) and reconfigured the LAN interface to make permanent the ip changes:

- Network &#x25B7; Interfaces &#x25B7; LAN

**[![](/assets/img/100.png)](/assets/img/100.png)**

Afterwards, I joined our local network, and created a repeater

- Network &#x25B7; Wifi &#x25B7; Scan
- Network &#x25B7; Wifi &#x25B7; Add

**[![](/assets/img/101.png)](/assets/img/101.png)**

Finally I created a bridge to connect both networks through the relay protocol:

<pre class="sh_sh">
openwrt # echo "config interface 'stabridge'"      &gt;&gt; /etc/config/network
openwrt # echo "      option 'proto' 'relay'"      &gt;&gt; /etc/config/network
openwrt # echo "      option 'network' 'lan wwan'" &gt;&gt; /etc/config/network
</pre>

And that's it!, a simple and robust wifi extender, happy repeating &#9996;

- [http://wiki.openwrt.org/toh/tp-link/tl-wdr4300](http://wiki.openwrt.org/toh/tp-link/tl-wdr4300)
- [http://tombatossals.github.io/openwrt-repetidor-wireless/](http://tombatossals.github.io/openwrt-repetidor-wireless/)
