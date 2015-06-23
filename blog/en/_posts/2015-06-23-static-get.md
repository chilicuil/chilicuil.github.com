---
layout: post
title: "static-get: linux static binaries for lazy persons"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

[Lastly](http://javier.io/blog/en/2015/02/27/wget-finder.html) I've required static versions of common linux utilities, it's been fun to compile them a couple of times but it gets boring pretty quickly, so I've decided to create a repository with all the static recipes I've found on Internet ([bifrost](https://github.com/jelaas/bifrost-build), [morpheus](http://morpheus.2f30.org/), [etc](https://github.com/minos-org/minos-static/tree/master/misc-autosync-resources)).

Now I can get `git static` with:

<pre class="sh_sh">
$ static-get git
git-1.9.2.tar.xz
$ static-get -x git #download and extract in one go
git-1.9.2.tar.xz
git-1.9.2/
$ sh <(wget -qO- s.minos.io/s) -x git #retrieve the installer, download the target and extract in one go
</pre>

To get a list of all available packages, you can run:

<pre class="sh_sh">
$ static-get --search
</pre>

Be aware than using static binaries have its [drawbacks](http://www.akkadia.org/drepper/no_static_linking.html), I take no responsability for any damage caused by any binary downloaded with [static-get](https://raw.githubusercontent.com/minos-org/minos-static/master/static-get).

That's it, happy fetching &#128523;

- [bifrost](https://github.com/jelaas/bifrost-build)
- [morpheus](http://morpheus.2f30.org/)
- [sabotage, not real static recipes](https://github.com/sabotage-linux/sabotage)
- [portablelinuxapps, not real static recipes](http://portablelinuxapps.org)

- [https://github.com/minos-org/minos-static](https://github.com/minos-org/minos-static)
- [https://www.janhouse.lv/blog/linux/building-static-binaries-on-linux/](https://www.janhouse.lv/blog/linux/building-static-binaries-on-linux/)
