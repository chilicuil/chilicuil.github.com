---
layout: post
title: "pbuilder tips"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

I'll write down some tips useful when dealting with pbuilder on Ubuntu, pbuilder is a builder for testing the creation of .deb packages from .dsc sources, however I often use as a light replacement for a full virtual machine.

## E: Release signed by unknown key (key id 8B48AD6246925553)

### Pbuilder fails to build Debian packages within Ubuntu.

<pre>
I: Distribution is sid.
I: Building the build environment
I: running debootstrap
/usr/sbin/debootstrap
I: Retrieving Release
I: Retrieving Release.gpg
I: Checking Release signature
E: Release signed by unknown key (key id 8B48AD6246925553)
</pre>

This messages indicates debootstrap has not been able to verify than **8B48AD6246925553** is a valid key, by default pbuilder in Ubuntu reads **/usr/share/keyrings/ubuntu-archive-keyring.gpg**. And this key is defined at: **/usr/share/pbuilder/pbuilderrc**. It sounds logic than a Debian key is not valid in an Ubuntu setup, however sometimes it's useful to test a package against Debian without installing a full Debian environment.

This problem can be solved by adding the Debian key to the Ubuntu keys:

<pre>
$ sudo gpg --no-default-keyring --keyring /usr/share/keyrings/ubuntu-archive-keyring.gpg --recv-keys 8B48AD6246925553
$ sudo DIST=sid ARCH=amd64 pbuilder create
</pre>

Or adding it to other ring and use it temporally:

<pre>
$ gpg --no-default-keyring --keyring /etc/apt/trusted.gpg --recv-keys 8B48AD6246925553
$ tail $HOME/.pbuilderrc
DEBOOTSTRAPOPTS=(
 '--variant=buildd'
 '--keyring' '/etc/apt/trusted.gpg'
)
$ sudo DIST=sid ARCH=amd64 pbuilder create
</pre>

If you don't want to mess with **~/.pbuilderrc** the parameter can also be set from in the prompt command:

<pre>
$ sudo DIST=sid ARCH=amd64 pbuilder create --debootstrapopts --keyring=/etc/apt/trusted.gpg
</pre>

## Run X apps

Pbuilder is a nothing but a chroot + debian enchantments, you can run virtually anything, from audio/video, to cli/gui applications, etc. It's however required to know how to enable them. Running a X app is a two step process:

<pre>
$ xhost +
</pre>

<pre>
[chroot] $ export DISPLAY=:0.0
[chroot] $ app
</pre>

## Run i18n apps

<pre>
[chroot] $ apt-get install language-pack-es #interchange -es for the \
                                   2 letters of your own lang
[chroot] $ LC_ALL=es_ES.utf-8 app
</pre>

## Run multimedia apps

You'll need to add **/proc** and **/dev** to your **BINDMOUNTS** variable:

<pre>
$ printf "%s\\n" 'BINDMOUNTS="${BINDMOUNTS} /dev /proc' &gt;&gt; ~/.pbuilderrc
</pre>
