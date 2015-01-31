---
layout: post
title: "proxy ssh + socks"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

#### Problem

- Facebook, Twitter, Youtube, etc are blocked.

#### Solution

- Route traffic through ssh tunnels.

### Ingredients

- Unix account in an external host, eg; [cjb.net](http://cjb.net), vps, etc
- Ssh client
- Traffic allowed through the 22 port (or any other port)

### Procedure:

- Create an ssh tunnel:

<pre class="sh_sh">
[local]$ ssh -C2qTnN -D 9090 username@remote.machine
</pre>

- Configure firefox to use the tunnel:
    - Edit &#10158; Preferences &#10158; Advanced &#10158; Network &#10158; Settings &#10158; Manual proxy configuration
- SOCKS Proxy 127.0.0.1 Port 9090

### Extra

To get extra security connections can go through N nodes:
<pre>
Firefox (local) &#10143;  host-1 &#10143;  host-2 &#10143;  host-n -> Internet
</pre>

<pre class="sh_sh">
[local]$  ssh -C2qTnN username@host-1 -L 9090:localhost:9090
[host1]$  ssh -C2qTnN username@host-2 -L 9090:localhost:9090
...
...
[hostn-1]$ ssh -C2qTnN -D 9090 username@host-n
</pre>

Happy hacking &#128520;
