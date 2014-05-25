---
layout: post
title: "wire and wireless concurrent connections with wicd"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

Even when it's not possible to configure two concurrent connections from within [wicd](http://wicd.sourceforge.net) it can be tricked to do so. To do this the **/etc/network/interfaces** file must be edited with the wired interface details, eg:

<pre class="sh_sh">
$ cat /etc/network/interfaces
  auto eth0
  iface eth0 inet static
          address 10.0.0.1
          netmask 255.255.255.0
          network 10.0.0.0
          broadcast 10.0.0.255
</pre>

Afterwards, the wired interface will need to be removed from wicd **properties**. That's it!, now the wireless interface can be controled from wicd and the wired one through **ifup**/**ifdown** &#128519;

- [https://bugs.launchpad.net/wicd/+bug/228578](https://bugs.launchpad.net/wicd/+bug/228578)
