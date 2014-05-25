---
layout: post
title: "send emails from terminal"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

In some systems the command *mail* is installed by default and as its name suggests it's used to send/read emails (usually between users of the same system), for this to work a mail server needs to be installed locally, I'm not sure about others but it sounds like a lot of work for me. I just want a light client from where I could send some emails (I read my email using the gmail web interface or mutt, so I don't need that functionality). So after searching on Internet I came to [Sendemail](http://caspian.dotconf.net/menu/Software/SendEmail/), a perl script who connects to external smtp servers and use them to deliver messages:

<pre class="lyric">
$ sendemail -f from@foo.org        \
            -u titulo              \
            -m mensaje             \
            -t to@bar.com          \
            -s mail.foo.com:26     \
            -xu usuario            \
            -xp contraseña
</pre>

It requires the following libraries to work with gmail, *libio-socket-ssl-perl*, *libnet-ssleay-perl*:

<pre class="lyric">
$ sendemail -f from@foo.org        \
            -u titulo              \
            -m mensaje             \
            -t to@bar.com          \
            -s smtp:gmail.com:587  \
            -o tls=yes             \
            -xu usuario            \
            -xp contraseña
</pre>

Now, since gmail blocks hosts per ip, it sometimes doesn't work when I try to send emails from new locations, it can be very annoying. Fortunately, there are other ways to send emails within a system, my favorite method is to use [http://mailgun.com](http://mailgun.com). When using mailgun you only need **curl** in your system and you're ready to go. I've created a script who wraps the required logic and just do that, send emails.

<pre class="sh_sh">
$ wget https://raw.github.com/chilicuil/learn/master/sh/tools/mail
$ sh mail "address@to.com" "message"
</pre>

<iframe class="showterm" src="http://showterm.io/6d595bb4e5424b943e54f" width="640" height="300">&nbsp;</iframe> 

- [http://mailgun.com/](http://mailgun.com/)
