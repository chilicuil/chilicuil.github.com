---
layout: post
title: "deb file structure"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

Deb packages are nothing but [ar containers](http://en.wikipedia.org/wiki/Ar_%28Unix%29), what set them apart (besides the sufix) are the 3 blobs they always contain.

- debian-binary: package version, normally 2.0
- control.tar.gz: compressed package files containing [checksums](http://en.wikipedia.org/wiki/Cryptographic_hash_function), scripts (http://www.debian.org/doc/FAQ/ch-pkg_basics.html), metadata, etc.
- data.tar.gz: compressed package files containing the program itself (commonly in binary format)

NOTE: Modifying .deb packages directly is not the right way to do it. The formal procedure is described at the Debian packaging guide:

- [http://wiki.debian.org/HowToPackageForDebian](http://wiki.debian.org/HowToPackageForDebian)

On this example I required to extract some files from firefox-launchpad-plugin. I had already installed firefox from a third party source and Ubuntu wanted to install its own version as a dependency which wasn't going to happen.

To uncompress deb packages a call to ar is enough:

<pre class="sh_sh">
$ ar xv firefox-launchpad-plugin_0.4_all.deb
  x - debian-binary
  x - control.tar.gz
  x - data.tar.gz
</pre>

If all you want is to modify the package, you can extract the .tar.gz files, modify them and repackage them with:

<pre class="sh_sh">
$ ar r firefox-launchpad-plugin_0.4_all.deb debian-binary control.tar.gz data.tar.gz
  ar: creating firefox-launchpad-plugin_0.4_all.deb
</pre>

On this example however I'll only copy some files to the file system:

<pre class="sh_sh">
$ tar zxvf data.tar.gz
  ./
  ./usr/
  ./usr/lib/
  ./usr/lib/firefox-addons/
  ./usr/lib/firefox-addons/searchplugins/
  ./usr/lib/firefox-addons/searchplugins/launchpad-bug-lookup.xml
  ./usr/lib/firefox-addons/searchplugins/launchpad-bugs.xml
  ./usr/lib/firefox-addons/searchplugins/launchpad-package-bugs.xml
  ./usr/lib/firefox-addons/searchplugins/launchpad-packages.xml
  ./usr/lib/firefox-addons/searchplugins/launchpad-people.xml
  ./usr/lib/firefox-addons/searchplugins/launchpad-specs.xml
  ./usr/lib/firefox-addons/searchplugins/launchpad-support.xml
$ find ~/.mozilla/ -type d  -iname searchplugins
  /home/chilicuil/.mozilla/firefox/h5xyzl6e.default/searchplugins
$ mv ./usr/lib/firefox-addons/searchplugins/* ~/.mozilla/firefox/h5xyzl6e.default/searchplugins/
</pre>

Done!, I don't need to mess with a dependency hell for a bunch of files &#128527; 

**[![](/assets/img/34.png)](/assets/img/34.png)**
