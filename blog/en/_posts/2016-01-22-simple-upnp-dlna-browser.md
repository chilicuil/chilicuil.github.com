---
layout: post
title: "a simple cli upnp/dlna browser"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

Last weekend I installed a usb hard disk to my [openwrt](https://openwrt.org/) [router](http://javier.io/blog/en/2014/06/10/installing-openwrt-as-wireless-repeater.html), added some content, setup [minidlna](https://wiki.openwrt.org/doc/uci/minidlna) and called it a day, easy way to stream movies locally. I tested the setup with all my endpoints and while it worked great with most of them I was having problems streaming to my Linux laptop, that's funny considering the router itself runs the same OS.

Looking around I read suggestions about installing vlc,totem,xbmc,etc. All of those media players are great however I already have mplayer2 which is able to play http streams, that's [a great deal](https://gxben.wordpress.com/2008/08/24/why-do-i-hate-dlna-protocol-so-much/) about upnp/dlna. So I took some time to hack a quick and dirty script and that's how [simple-dlna-browser](https://github.com/javier-lopez/learn/blob/master/sh/tools/simple-dlna-browser) was born.

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

$ simple-dlna-browser contacto | xargs mplayer

$ simple-dlna-browser -s 192.168.1.254 contacto | xargs mplayer
</pre>

I used minidlna 1.1.4-2 as a reference, so it may not work with other media servers.

That's it, happy streaming &#128523;

- [https://github.com/javier-lopez/learn/blob/master/sh/tools/simple-dlna-browser](https://github.com/javier-lopez/learn/blob/master/sh/tools/simple-dlna-browser)
