---
layout: post
title: "installing openwrt as a dumb access point"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

In a previous post I wrote about how to use [openwrt as an independent access point](http://javier.io/blog/en/2017/11/23/installing-openwrt-as-wireless-repeater.html), this time however I'll mention how to configure it to extend a network that already has a router with dhcp in place or where a subnet is not required / desired.

The target device is a [TP-Link N750](http://www.amazon.com/TP-LINK-TL-WDR4300-Wireless-Gigabit-300Mbps/dp/B0088CJT4U), and I'm using the latest [stable build](http://downloads.openwrt.org/releases/18.06.2/targets/ar71xx/generic/openwrt-18.06.2-ar71xx-generic-tl-wdr4300-v1-squashfs-factory.bin). The installation process is pretty straight forward.

**[![](/assets/img/98.jpg)](/assets/img/98.jpg)**

<pre class="sh_sh">
$ wget downloads.openwrt.org/releases/18.06.2/targets/ar71xx/generic/openwrt-18.06.2-ar71xx-generic-tl-wdr4300-v1-squashfs-factory.bin
</pre>

Or, when there is a previous openwrt version already installed:

<pre class="sh_sh">
$ wget downloads.openwrt.org/releases/18.06.2/targets/ar71xx/generic/openwrt-18.06.2-ar71xx-generic-tl-wdr4300-v1-squashfs-sysupgrade.bin
</pre>

After completing the download, it can be installed by going to the **Firmware Upgrade** menu and selecting the openwrt firmware.

**[![](/assets/img/99.png)](/assets/img/99.png)**

The stable version already includes the [luci web interface](https://github.com/openwrt/luci), so there is no need to install anything else.

### Configuration via Web Interface LUCI

Unplug all but your own computer to the device and wait for a valid ip, by default in the range 192.168.1.X, connect to the router through the http://192.168.1.1 address and select the **LAN INTERFACE**

Edit with a valid static IP within the range of your main router, eg, (if your router has IP 192.168.1.1, enter 192.168.1.2). Set DNS and gateway to point into your main router to enable internet access for the dumb AP itself.

**[![](/assets/img/openwrt-dumb-ap-lan.png)](/assets/img/openwrt-dumb-ap-lan.png)**

Then scroll down and select the checkbox **Ignore interface: Disable DHCP for this interface.**

**[![](/assets/img/openwrt-dumb-ap-disable-dhcp.png)](/assets/img/openwrt-dumb-ap-disable-dhcp.png)**

Before applying the change prepare the ethernet wire, you'll have 30 seconds to connect it, request a new IP address and access the router web interface, otherwise it'll revert the change and you'll have to redo the configuration. Use a LAN/switch from your main router to a LAN/switch of your dumb AP, **avoid the WAN/Internet ports**, click **Save & Apply**.

Access the dumb AP (on this example) through the [http://10.9.8.7](http://10.9.8.7) IP, and go to the **Network &#x25B7; Interfaces** page for disabling the **WAN** interfaces.

**[![](/assets/img/openwrt-dumb-ap-disable-wan-interfaces.png)](/assets/img/openwrt-dumb-ap-disable-wan-interfaces.png)**

We're almost done, as a final step, setup the wireless APs, go to **Network &#x25B7; Wireless** section and configure as desired your Access Pointsmaking sure the **Network** parameter is set to **LAN**

**[![](/assets/img/openwrt-dumb-ap-wireless-details.png)](/assets/img/openwrt-dumb-ap-wireless-details.png)**

**[![](/assets/img/openwrt-dumb-ap-wireless-general.png)](/assets/img/openwrt-dumb-ap-wireless-general.png)**

That's it!, enjoy your extended network, &#9996;

- [https://openwrt.org/docs/guide-user/network/wifi/dumbap](https://openwrt.org/docs/guide-user/network/wifi/dumbap)
