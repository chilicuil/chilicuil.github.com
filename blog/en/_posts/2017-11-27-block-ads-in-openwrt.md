---
layout: post
title: "block ads in openwrt routers"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

In previous posts I wrote about how to [block YouTube and other services by ip](http://javier.io/blog/en/2017/11/26/block-youtube-in-openwrt.html), this time I'll show how to do the same by dns, kind of adblock for openwrt.

The target router is a [TP-Link N750](http://www.amazon.com/TP-LINK-TL-WDR4300-Wireless-Gigabit-300Mbps/dp/B0088CJT4U), and I'm using the latest [trunk build](http://downloads.openwrt.org/snapshots/trunk/ar71xx/).

**[![](/assets/img/98.jpg)](/assets/img/98.jpg)**

Since revision [39312](https://dev.openwrt.org/changeset/39312/) OpenWRT configures the dnsmasq service to read from **/tmp/dnsmasq.d/**, so it's easy to dump block list there and reload the dnsmasq service to block undesired domains.

<pre>
# wget http://rawgit.com/javier-lopez/learn/master/sh/is/adblockupdater-openwrt -O /usr/bin/adblockupdater-openwrt
# chmod +x /usr/bin/adblockupdater-openwrt
# adblockupdater-openwrt
Getting yoyo ad list...
Getting winhelp2002 ad list...
Getting adaway ad list...
Getting hosts-file ad list...
Getting malwaredomainlist ad list...
Getting adblock.gjtech ad list...
Failed to establish connection
Getting someone who cares ad list...
69191 ad domains blocked.
Everything fine, restarting dnsmasq to implement new serverlist...
</pre>

Add it to the cron job manager:

<pre class="sh_sh">
# crontab -e
0 0 */1 * * /usr/bin/adblockupdater.sh
</pre>

That's it, happy blocking &#128523;

- [Original blog post](http://homepage.ruhr-uni-bochum.de/Jan.Holthuis/misc/adblock-on-your-openwrt-router/)
