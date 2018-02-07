---
layout: post
title: "x509: certificate signed by unknown authority docker error"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

At work we use internal docker registers and from to time I encounter this error when trying to pull/push to https registers, so I'm leaving the procedure to add autosigned certificates for the future me and others.

### Distro: Ubuntu 16.04
### Docker: 17.12.0-ce, build c97c6d

<pre>
$ # export registry certificate
$ openssl s_client -showcerts -connect                \
    registry.example.com:443 </dev/null 2>/dev/null | \
    openssl x509 -outform PEM > registry.example.com.crt
$ # add it globally
$ sudo mv registry.example.com.crt /usr/local/share/ca-certificates
$ # update global certificates definitions
$ sudo update-ca-certificates
$ # restart affected services
$ sudo systemctl daemon-reload
$ sudo systemctl restart docker
</pre>

That's it, happy pulling/pushing &#128523;
