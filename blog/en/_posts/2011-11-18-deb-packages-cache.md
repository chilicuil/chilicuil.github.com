---
layout: post
title: "deb package cache"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

**Update:** I created a [script](https://raw.github.com/chilicuil/learn/master/sh/is/apt-proxy) who automate the process described in this post.

<!--<iframe class="showterm" src="http://showterm.io/cfdfdda6da61dad9d9d5e" width="640" height="350">&nbsp;</iframe>-->

### Introduction

apt-cacher-ng is a kind of deb repository proxy, it caches deb packages **on demand** between the computer who share the cache, it's a great alternative for small environments. There are other alternatives, such as apt-cacher, apt-proxy and debmirror but those solutions can take more space or be harder to setup, so I won't talk about them.

In the client side, there exist mainly two ways of taking advantage of such services, [squid-deb-proxy](https://launchpad.net/squid-deb-proxy) and manual configuration. The first one uses [zeroconf](http://avahi.org/) to detect and use deb proxies whenever they're available and the second one, well, is manual and works by adding a string to **/etc/apt/apt.conf.d/01apt-cache** describing the proxy url. On this post I'll talk about squid-deb-proxy.

### Installation

&#91;+&#93; In the server side (which can be client at the same time):

<pre class="sh_sh">
$ sudo apt-get install apt-cacher-ng squid-deb-proxy-client
$ sudo wget http://javier.io/mirror/apt-cacher-ng.service -O /etc/avahi/services/apt-cacher-ng.service
$ sudo service apt-cacher-ng restart
</pre>

&#91;+&#93; In the client side:

<pre class="sh_sh">
$ sudo apt-get install squid-deb-proxy-client
</pre>

After executing these commands the apt-cacher-ng server will announce itself to all computers in the local network, and clients machines will be able to autoconfigure their apt preferences depending of whether they see an apt-cacher-ng server or not. Pretty cool &#128522;

### Extra

#### Import packages

Old packages (downloaded before setting up apt-cacher-ng) can be imported by executing:

<pre class="sh_sh">
$ sudo mkdir -pv -m 2755 /var/cache/apt-cacher-ng/_import
$ sudo mv -vuf /var/cache/apt/archives/*.deb /var/cache/apt-cacher-ng/_import/
$ sudo chown -R apt-cacher-ng:apt-cacher-ng /var/cache/apt-cacher-ng/_import
$ sudo apt-get update
</pre>

And going to <http://localhost:3142/acng-report.html> where a '**Start import**' button will show up:

**[![](/assets/img/57.png)](/assets/img/57.png)**

#### Delete apt-cacher-ng

This setup can be destroyed at any time by running:

&#91;+&#93; In the server:

<pre class="sh_sh">
$ sudo apt-get remove apt-cacher-ng squid-deb-proxy-client
$ sudo rm -rf /var/cache/apt-cacher-ng
</pre>

&#91;+&#93; In the clients:

<pre class="sh_sh">
$ sudo apt-get remove squid-deb-proxy-client
</pre>

Happy caching &#128527;
