---
layout: post
title: "sentry, an alternative to fail2ban and other bruteforce blocking daemons"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

I've just migrated my servers from using fail2ban to sentry, and it feels quite efficient =), so I'm doing this post as a way to increase sentry awareness.

Sentry is a program who detects and prevents bruteforce attacks against sshd and other network services using minimal system resources. Instead of running a daemon who constantly reads log files it runs a perl script who uses tcpwrappers for tracking connections and blocking access by ip, tcpwrappers is already installed in most modern UNICES systems (Linux, Mac OSX and FreeBSD). So if you additionally have perl installed it adds 0 dependencies.

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

### Usage

Upon installation it doesn't require anything else, it'll just works, to see some statistics run:

    $ sudo /var/db/sentry/sentry.pl -r
    no IP, skip info
       -------- summary ---------
      42 unique IPs have connected 190 times
       1 IPs are whitelisted
      38 IPs are blacklisted

Or to see the IP's blocked

    $ sudo head -3 /var/db/sentry/hosts.deny
    ALL: 103.41.124.119 : deny
    ALL: 103.41.124.136 : deny
    ALL: 115.230.124.208 : deny

The list can be edited either manually or through the --whitelist, --blacklist and --delist sentry.pl options

    $ sudo /var/db/sentry/sentry.pl --ip=103.41.124.119 --delist
    $ sudo /var/db/sentry/sentry.pl --ip=103.41.124.119 --whitelist
    $ sudo /var/db/sentry/sentry.pl --ip=103.41.124.119 --delist
    $ sudo /var/db/sentry/sentry.pl --ip=103.41.124.119 --blacklist

-[https://www.tnpi.net/wiki/Sentry](https://www.tnpi.net/wiki/Sentry)
