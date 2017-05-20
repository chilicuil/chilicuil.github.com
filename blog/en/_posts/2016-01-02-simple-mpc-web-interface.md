---
layout: post
title: "a simple mpc web interface"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

Sometimes while listening music at my desk my niece (~8y/o) shows up and asks me to skip the current song, most of the times I do it instantly, however when I'm really busy I may delay some seconds, in those occasions she goes over my keyboard and press the `next` button by herself. Today morning was one of those days, so I though it shouldn't be too difficult to install a mpd client in her ipad to give her full control =)

It turned to be more trouble that I though, first, there are no free mpd clients on the ipad software store (or it's not available in my region, LATAM), and most [web clients](http://mpd.wikia.com/wiki/Clients) require a fair amount of dependencies and some work to get them running. I don't want yet another service to maintain, so I decided to hack a simple web interface for `mpc`, based on Gwenn Englebienne previous work on [mplayer](http://www.gwenn.dk/mplayer-remote.html) and this is the result:

<pre class="sh_sh">
$ wget https://raw.githubusercontent.com/javier-lopez/learn/master/python/simple-mpc-remote
$ python simple-mpc-remote -p 8080
Started httpserver on port 8080
</pre>

**[![](/assets/img/simple-mpc-remote.png)](/assets/img/simple-mpc-remote.png)**

`simple-mpc-remote` has no dependencies, other than python +2.7, mpc and mpd and it's really simple to install/use. Since it does little effort to sanitize input it could be dangerous, however since I trust my local network I'll leave it like that for now.

Happy skipping &#128523;

- [mplayer-remote](http://www.gwenn.dk/mplayer-remote.html)
- [simple-mpc-remote](https://raw.githubusercontent.com/javier-lopez/learn/master/python/simple-mpc-remote)
