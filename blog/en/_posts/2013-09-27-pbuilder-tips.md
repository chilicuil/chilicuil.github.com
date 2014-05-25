---
layout: post
title: "pbuilder tips"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

I'll write down some tips useful when dealting with pbuilder in Ubuntu, pbuilder is a builder for testing the creation of .deb packages from .dsc sources, however I often use it as a light replacement for full virtual machines.

## E: Release signed by unknown key (key id 8B48AD6246925553)

<pre class="sh_sh">
I: Distribution is sid.
I: Building the build environment
I: running debootstrap
/usr/sbin/debootstrap
I: Retrieving Release
I: Retrieving Release.gpg
I: Checking Release signature
E: Release signed by unknown key (key id 8B48AD6246925553)
</pre>

This messages indicates debootstrap has not been able to verify than **8B48AD6246925553** is a valid key, by default pbuilder in Ubuntu reads **/usr/share/keyrings/ubuntu-archive-keyring.gpg**. This key is defined at: **/usr/share/pbuilder/pbuilderrc**. It sounds logic than a Debian key is not valid in an Ubuntu setup, however sometimes it's useful to test a package against Debian without installing a full Debian environment.

This problem can be solved by adding the Debian key to the Ubuntu keys:

<pre class="sh_sh">
$ sudo gpg --no-default-keyring --keyring /usr/share/keyrings/ubuntu-archive-keyring.gpg --recv-keys 8B48AD6246925553
$ sudo DIST=sid ARCH=amd64 pbuilder create
</pre>

Or adding it to other ring and use it temporally:

<pre class="sh_sh">
$ gpg --no-default-keyring --keyring /etc/apt/trusted.gpg --recv-keys 8B48AD6246925553
$ tail $HOME/.pbuilderrc
DEBOOTSTRAPOPTS=(
 '--variant=buildd'
 '--keyring' '/etc/apt/trusted.gpg'
)
$ sudo DIST=sid ARCH=amd64 pbuilder create
</pre>

If you don't want to mess with **~/.pbuilderrc** the parameter can also be set from the prompt command:

<pre class="sh_sh">
$ sudo DIST=sid ARCH=amd64 pbuilder create --debootstrapopts --keyring=/etc/apt/trusted.gpg
</pre>

## Run X apps

Pbuilder is a nothing but a chroot + debian enchantments, you can run virtually anything, from audio/video, to cli/gui applications, etc. Running a X app is a two step process:

<pre class="sh_sh">
$ xhost + #in the host environment
</pre>

<pre class="sh_sh">
[chroot] $ export DISPLAY=:0.0
[chroot] $ app
</pre>

## Run i18n apps

Running apps in other languages requires to download extra language packages and modify the LC_ALL variable:

<pre class="sh_sh">
[chroot] $ apt-get install language-pack-es #interchange -es for the 2 letters of your own lang
[chroot] $ LC_ALL=es_ES.utf-8 app
</pre>

## Run multimedia apps

To run multimedia applications besides enabling X, you'll need to mount **/proc** and **/dev**:

<pre class="sh_sh">
$ printf "%s\\n" 'BINDMOUNTS="${BINDMOUNTS} /dev /proc' &gt;&gt; ~/.pbuilderrc
$ pbuilder login
</pre>
