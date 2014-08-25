---
layout: post
title: "access localhost with pagekite"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

I &#x2661; pagekite, it allows me to connect to my laptop from anywhere, literally, it doesn't matter if my computer is behind a nat router or if my input traffic is blocked, as long as my computer can start connections to internet I'm covered. And I don't need to redefine anything, it will work even if I'm changing constantly networks.

**[![](/assets/img/68.jpg)](/assets/img/68.jpg)**

Why do I need to access my computer under every possible scenario?, personal portability, I prefer to travel lightly, just give me a book and some headphones and I'm ready to go to the end of the world. And even though I've most of my stuff in servers some things somehow end in my personal laptop.

So, right now I connect to home by typing:

<pre class="sh_sh">
$ ssh home.javier.io
</pre>

It doesn't matter where I'm, neither where my laptop is, it will just work &#128514;

If you're interested in setting something similar up, go and create an account in <http://pagekite.net>, personal startup of [Bjarni Einarsson](http://bre.klaki.net/), icelandic hacker.

Once done, you'll be able to run:

<pre class="sh_sh">
$ curl -s https://pagekite.net/pk/ |sudo bash #for installing pagekite in 1 line
$ pagekite.py 80 yourname.pagekite.me
</pre>

And now you'll be running your own web server available to the world, isn't it great? Now let's talk about more interesting stuff such us using your own domain and connecting to ssh or any other protocol.

This is what happens when someone uses pagekite:

<pre class="sh_sh">
$ ssh home.javier.io
</pre>

           192.168.1.x       home.javier.io  home.javier.pagekite.me   192.168.1.x
           :::::::::::        :::::::::::          ::::::::::::        :::::::::::::::
           | client  |   =>   | domain  |    =>    | pagekite |     => |   server    |
           :::::::::::        :::::::::::          ::::::::::::        :::::::::::::::


The computer where the client is run will connect to the original domain, which in return will send it to a pagekite subdomain and from there to reverse connection between pagekite and your server. Alloying to exchange data client and server through pagekite servers.

### Dns

- Cname

For this to work, home.javier.io must point to pagekite. This can be done with a CNAME entry, and it depends of your dns provider. In my case it can be easily done with the panel provided by <http://iwantmyname.com>:

**[![](/assets/img/69.png)](/assets/img/69.png)**

- [pagekite.me](http://pagekite.net) subdomain

Upon registration, pagekite will give you a **nick.pagekite.me** subdomain for free, you can add even [more subdomains](https://pagekite.net/signup/?more=free) to your nick subdomain to get **subdomain.nick.pagekite.me**

**[![](/assets/img/70.png)](/assets/img/70.png)**

- home.javier.io kite

You need to [register](https://pagekite.net/signup/?more=cname#cnameForm) the CNAME entry in pagekite as well:

**[![](/assets/img/71.png)](/assets/img/71.png)**

Now your [home page](https://pagekite.net/home/) should look like this:

**[![](/assets/img/72.png)](/assets/img/72.png)**

### Server

So now, you've to configure pagekite locally to use the available kites:

    ###[ Current settings for pagekite.py v0.5.6a. ]#########
    # ~/.pagekite.rc
    ## NOTE: This file may be rewritten/reordered by pagekite.py.
    #
     
    ##[ Default kite and account details ]##
    kitename = javier.pagekite.me
    kitesecret = KITESECRET_KEY
     
    ##[ Front-end settings: use pagekite.net defaults ]##
    defaults
     
    ##[ Back-ends and local services ]##
    service_on = http:@kitename : localhost:80 : @kitesecret
    service_on = raw-22:@kitename : localhost:1003 : @kitesecret
    service_on = raw-22:home.javier.pagekite.me : localhost:1003 : @kitesecret
    service_on = raw-22:home.javier.io : localhost:1003 : @kitesecret
     
    ##[ Miscellaneous settings ]##
    savefile = /home/chilicuil/.pagekite.rc
     
    ###[ End of pagekite.py configuration ]#########
    END

And launch the service:

    $ ./pagekite.py
    >>> Hello! This is pagekite v0.5.6a.                            [CTRL+C = Stop]
        Connecting to front-end 69.164.211.158:443 ...                             
         - Protocols: http http2 http3 https websocket irc finger httpfinger raw   
         - Protocols: minecraft                                                    
         - Ports: 79 80 443 843 2222 3000 4545 5222 5223 5269 5670 6667 8000 8080  
         - Ports: 8081 9292 25565                                                  
         - Raw ports: 22 virtual                                                   
        Quota: You have 2559.74 MB, 29 days and 4 connections left.                
        Connecting to front-end 173.230.155.164:443 ...                            
    ~<> Flying localhost:1003 as ssh://home.javier.io:22/ (HTTP proxied)           
    ~<> Flying localhost:1003 as ssh://home.javier.pagekite.me:22/ (HTTP proxied)  
    ~<> Flying localhost:1003 as ssh://javier.pagekite.me:22/ (HTTP proxied)       
    ~<> Flying localhost:80 as https://javier.pagekite.me/                         
     << pagekite.py [flying]   Kites are flying and all is well.

### Client

To connect to your laptop you can use any web browser or complete an extra step to be able to use ssh. The **$HOME/.ssh/config** file should be edited as follows:

    Host home.javier.io
        CheckHostIP no
        ProxyCommand /bin/nc -X connect -x %h:443 %h %p

**WARNING:** the nc command must be the openbsd version, in Ubuntu it's called **netcat-openbsd**

If everything is correct, you should now be able to login:

<pre class="sh_sh">
$ ssh home.javier.io
chilicuil@home.javier.io's password: 
</pre>

Pagekite is free software, both the client and the backend and it's awesome &#128525;

- [https://github.com/pagekite/PyPagekite](https://github.com/pagekite/PyPagekite)