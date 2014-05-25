---
layout: post
title: "installing debian build dependencies the smart way"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

### The Problem

So you're trying to build a Debian package from an upstream source tree, but you're not sure what build dependencies you should install? I have this problem all the time. For example, if I wanted to build the unity source tree into a debian package, I'd branch it:

<pre class="sh_sh">
$ bzr branch lp:unity
</pre>

...change into the directory:

<pre class="sh_sh">
$ cd unity
</pre>

...and then try and build it. Needless to say, I almost never have the required build dependencies installed. You can try and use apt-get to install the build dependencies for you:

<pre class="sh_sh">
$ sudo apt-get build-dep unity
</pre>

But that reads the build dependencies from whatever version is present in the distribution, not the dependencies in the source tree.

### The Solution

The solution is easy. First, install a couple of packages:

<pre class="sh_sh">
$ sudo apt-get install devscripts equivs
</pre>

Then run this from within the source tree to install the build dependencies:

<pre class="sh_sh">
$ sudo mk-build-deps -i
</pre>

If, after this command completes you still cannot build the package, you should probably file a bug against the upstream project!

- [http://www.tech-foo.net/installing-build-dependencies-the-smart-way.html](http://www.tech-foo.net/installing-build-dependencies-the-smart-way.html)
