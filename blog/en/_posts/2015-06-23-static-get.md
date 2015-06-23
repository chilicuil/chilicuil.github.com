---
layout: post
title: "static-get: linux static binaries for lazy persons"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

[Lastly](http://javier.io/blog/en/2015/02/27/wget-finder.html) I've required static versions of common linux utilities, it's been fun to compile them a couple of times but not anymore, so I've created a repository with all the static recipes I've found on Internet ([bifrost](https://github.com/jelaas/bifrost-build), [morpheus](http://morpheus.2f30.org/), [etc](https://github.com/minos-org/minos-static/tree/master/misc-autosync-resources)).

Now I can get `git static` with:

<pre class="sh_sh">
$ [static-get](https://raw.githubusercontent.com/minos-org/minos-static/master/static-get) git
git-1.9.2.tar.xz
$ static-get -x git #to download and extract in one go
git-1.9.2.tar.xz
git-1.9.2/
$ sh <(wget -qO- s.minos.io/s) -x git #to retrieve the installer, download the target and extract it in one go
</pre>

To get the complete list of the available packages you can run:

<pre class="sh_sh">
$ static-get --search
</pre>

That's it, happy fetching &#128523;

- [bifrost](https://github.com/jelaas/bifrost-build)
- [morpheus](http://morpheus.2f30.org/)
- [sabotage, not real static recipes](https://github.com/sabotage-linux/sabotage)
- [portablelinuxapps, not real static recipes](http://portablelinuxapps.org)

- [https://github.com/minos-org/minos-static](https://github.com/minos-org/minos-static)
