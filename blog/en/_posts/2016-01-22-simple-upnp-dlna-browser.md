---
layout: post
title: "a simple cli upnp/dlna browser"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

Last week I installed a usb hard disk to my [openwrt](https://openwrt.org/) [router](http://javier.io/blog/en/2014/06/10/installing-openwrt-as-wireless-repeater.html) and added some movies, later on I installed [minidlna](https://wiki.openwrt.org/doc/uci/minidlna) and called it a day, I was able to access content from all the embeded devices within the house. Unexpectedly some hours later while trying to watch a movie from my Linux laptop I noticed how hard it was. Looking on Internet I read suggestions about installing vlc,totem,xbmc,etc. However I already have mplayer2 which is able to play http streams, that's [a great deal](https://gxben.wordpress.com/2008/08/24/why-do-i-hate-dlna-protocol-so-much/) about upnp/dlna. So I took some time to hack a quick and dirty script and that's how [simple-dlna-browser](https://github.com/chilicuil/learn/blob/master/sh/tools/simple-dlna-browser) was born.

<pre class="sh_sh">
$ simple-dlna-browser
Usage: simple-dlna-browser [OPTIONS] PATTERN
</pre>

### Examples

<pre class="sh_sh">
$ simple-dlna-browser -l #autodetection requires 'socat'
http://192.168.1.254:8200/rootDesc.xml (Multimedia)
┬
├── Apocalipto
├── Contacto
├── Coraline.y.la.puerta.secreta
...

$ simple-dlna-browser -s 192.168.1.254:8200 contacto
http://10.9.8.7:8200/MediaItems/23.avi

$ simple-dlna-browser -s 192.168.1.254 contacto | xargs mplayer
</pre>

I used minidlna 1.1.4-2 as a reference, so it may not work with other media servers.

That's it, happy streaming &#128523;

- [https://github.com/chilicuil/learn/blob/master/sh/tools/simple-dlna-browser](https://github.com/chilicuil/learn/blob/master/sh/tools/simple-dlna-browser)
