---
layout: post
title: "use citrix on linux"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

### Issue

    Error: "SSL Error 61: You have not chosen to trust 'Certificate Authority'..." on Receiver for Linux

### Fix

<pre class="sh_sh">
$ sudo mv /opt/Citrix/ICAClient/keystore/cacerts   /opt/Citrix/ICAClient/keystore/cacerts.bk
$ sudo ln -s /etc/ssl/certs/   /opt/Citrix/ICAClient/keystore/cacerts
</pre>

That's it, happy coworking, &#128522;
