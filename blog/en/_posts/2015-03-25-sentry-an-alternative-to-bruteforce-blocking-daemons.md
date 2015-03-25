---
layout: post
title: "sentry, an alternative to fail2ban and other bruteforce blocking daemons"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

I've just migrated my servers from using fail2ban to sentry, and it feels quite efficient =), so I'm doing this post as a way to increase sentry aweraness.

Sentry is a program who detects and prevents bruteforce attacks against sshd and other network services using minimal system resources. Instead of running a daemon who constantly reads log files it runs a perl script who uses tcpwrappers for tracking connections by ip, tcpwrappers is already installed in most modern UNICES systems (Linux, Mac OSX and FreeBSD). So if you additionally have perl installed it adds 0 dependencies.

### Installation

## Ubuntu | Minos

    $ sudo add-apt-repository ppa:minos-archive/main
    $ sudo apt-get update && sudo apt-get install sentry

## Others

    $ wget http://www.tnpi.net/internet/sentry.pl
    $ sudo perl sentry.pl
    $ echo "sshd : /var/db/sentry/hosts.deny : deny" > hosts
    $ echo "sshd : ALL : spawn /var/db/sentry/sentry.pl -c --ip=%a : allowsendmail: all" >> hosts
    $ cat hosts /etc/hosts.allow > hosts.allow
    $ sudo mv hosts.allow /etc/ && rm hosts

-[https://www.tnpi.net/wiki/Sentry](https://www.tnpi.net/wiki/Sentry)
