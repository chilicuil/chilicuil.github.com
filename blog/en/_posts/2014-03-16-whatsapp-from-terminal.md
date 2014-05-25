---
layout: post
title: "whatsapp from terminal"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

**[![](http://openwhatsapp.org/static/img/logo.jpg)](http://openwhatsapp.org/static/img/logo.jpg)**

Lastly I've been required to communicate through [whatsapp](http://www.whatsapp.com/), since I don't have a smart phone (and most of the times none at all) I had to figure out a way to use it from my laptop. The most popular posts on Internet talk about installing an android emulator and install whatsapp inside, there is however other ways to use the service much faster and easier. Non official libraries &#128520;

This is the way I managed to use the service and what I'll talk about in this post.

Wazapp is a whatsapp client for Blackberry, it was started by [Tarek Galal](https://github.com/tgalal) because of Blackberry (when they didn't have any agreement with Whatsapp). Tarek created an api instead of building all the protocol logic inside of the gui client and made it available on internet. The github project includes a minimalism cli client which is the one I use.

- [https://github.com/tgalal/yowsup/blob/master/src/yowsup-cli](https://github.com/tgalal/yowsup/blob/master/src/yowsup-cli)

To use whatsapp, besides the client, you'll need a number who can receive sms. [Twilio](https://www.twilio.com) is a great option if you don't have a cellphone or if yours is already taken for the official whatsapp client.

## Installation

<pre class="sh_sh">
$ sudo apt-add-repository ppa:chilicuil/sucklesstools
$ sudo apt-get update
$ sudo apt-get install yowsup
</pre>

## Configuration

Upon installation, yowsup will need to be initialized, to do it, you'll need to create a **~/.yowsup** file:

<pre>
phone=[full_number]
id=0000000000
password=
</pre>

And run:

<pre class="sh_sh">
$ yowsup --requestcode sms
</pre>

A sms will be send to the configured number, in twilio you can see these messages in Logs &#x25B7; Messages.

**[![](/assets/img/94.png)](/assets/img/94.png)**

**Incoming**:

**[![](/assets/img/95.png)](/assets/img/95.png)**

With the verification code under the belt, it'll be the time to register the account:

<pre class="sh_sh">
$ yowsup --register verification-code #(3-6 digits)
</pre>

The last command will return a password, this password has to be added to **~/.yowsup** to complete the process. Done, now you can send/receive and even start chats in Whatsapp.

<pre class="sh_sh">
$ yowsup -l                     #listen for new messages
$ yowsup -s XXXXXXXX "message"  #send message to XXXXXXXX
$ yowsup -i XXXXXXXX            #start a private chat with XXXXXXXX
</pre>

References:

- [http://openwhatsapp.org/faq/](http://openwhatsapp.org/faq/)
