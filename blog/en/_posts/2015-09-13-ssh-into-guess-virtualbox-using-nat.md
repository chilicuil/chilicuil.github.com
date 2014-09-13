---
layout: post
title: "ssh into a guest vbox machine on NAT mode"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

This is a quick reminder to myself, for this to work a ssh server must be running in the guest machine.

### Configuration

In the VM network panel, click in **advanced** and then in the **Port Forwarding** button, there setup the next rule:

- Host IP: 127.0.0.1
- Host Port: 2222
- Guest IP: 10.0.0.2 (or the ip of the guest machine)
- Guest Port: 22 (or personalized ssh port)

Save changes

### Usage

    ssh -p 2222 user@localhost

Happy remote working &#128523;

- [https://forums.virtualbox.org/viewtopic.php?f=8&t=55766](https://forums.virtualbox.org/viewtopic.php?f=8&t=55766)
