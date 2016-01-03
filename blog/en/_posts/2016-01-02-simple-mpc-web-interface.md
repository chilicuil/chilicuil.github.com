---
layout: post
title: "a simple mpc web interface"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

Sometimes while listening music at my desk my niece (~8y/o) shows up and asks me to skip the current song, most of the times I do it instantenly, however when I'm really busy I may delay some seconds, in those occasions she goes over my keyboard and press the 'next' buttom by herself. Today morning was one of those days, so I though it shouldn't be too difficult to install a mpd client in its ipad and show her how to do it from her device. It turns out there are not free mpd clients on the ipad software store (or they aren't listed in my region, LATAM), no problem I though, I'll install a web client in my computer and will add a bookmark in her browser, however when looking [around](http://mpd.wikia.com/wiki/Clients) most clients required a fair amount of dependencies and looked complicated to install/maintain. I don't need more work =), so I quickly hacked a simple one based on Gwenn Englebienne [work](http://www.gwenn.dk/mplayer-remote.html):

<pre class="sh_sh">
$ wget https://raw.githubusercontent.com/chilicuil/learn/master/python/simple-mpc-remote
$ python simple-mplayer-remote -p 8080
Started httpserver on port 8080
</pre>

**[![](/assets/img/simple-mpc-remote.png)](/assets/img/simple-mpc-remote.png)**

The result has no dependencies, other than python +2.7, mpc and mpd and it's pretty simple. It could be even dangerous, however since I trust my local network I'll leave like that for now.

Happy skipping &#128523;

- [mplayer-remote](http://www.gwenn.dk/mplayer-remote.html)
- [simple-mpc-remote](https://raw.githubusercontent.com/chilicuil/learn/master/python/simple-mpc-remote)
