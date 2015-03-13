---
layout: post
title: "wget-finder for packagers"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

Since some days ago I've been playing with [bifrost-build](https://github.com/jelaas/bifrost-build), a github repository with recipes for building static linux binaries.

The recipes are no different from other linux distributions where an archive hardcoded (containing the original source code) needs to be downloaded and match an specific hash (in this case a md5sum) to continue the build.

While I was reviewing the recipes I noticed than some origins wheren't available anymore. Fortunately there are plenty of mirrors for the most common utils installed with any linux system, so it wasn't difficult to find alternative urls from where to fetch the missing bits (thanks mirrors and bifrost-build!).

After completing the builds I though that it shouldn't be too difficult to automate this task, to create a program who could search and download an specific archive matching a checksum. That's how [wget-finder](https://github.com/chilicuil/learn/blob/master/sh/tools/wget-finder) was born.

<pre class="sh_sh">
$ wget-finder
Usage: wget-finder [OPTION]... FILE:CHECKSUM...
</pre>

The idea is simple, wget-finder will search for files e.g. socat-1.7.2.0.tar.gz matching an specific checksum(it supports md5, sha1, sha256 and sha512) on different search engines (currently google, filemare and ftplike, more engines are welcome!) and will download the appropiate (actually it will download some of them till the checksum matches)

<pre class="sh_sh">
$ wget-finder socat-1.7.2.0.tar.gz:0565dd58800e4c50534c61bbb453b771
socat-1.7.2.0.tar.gz
$ wget-finder -O libssh.tar.gz libssh2-1.3.0.tar.gz:6425331899ccf1015f1ed79448cb4709
libssh.tar.gz
</pre>

That's it, happy fetching &#128523;
