---
layout: post
title: "compile software in pristine environments with pbuilder"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

I'm a paranoid of the order (at least in my system), every time I have to install software which is not included in the Ubuntu repositories I create .deb packages for such programs, sometimes it's easy enough to do it manually (if the program doesn't envolve a lot of dependencies), other times I rely on [checkinstall](http://asic-linux.com.mx/%7Eizto/checkinstall/) or [fpm](https://github.com/jordansissel/fpm) to do the job. Some persons wonder why I do still create hand made packages if fpm and checkinstall are available, well I do it because both tools can only create .deb packages but not .dsc definitions (a kind of .deb source package), these .dsc files can be upload to a ppa in [launchpad.net](http://launchpad.net/) where they'll be compiled and saved. You want to do that because then you can use the url of your ppa to get automatic dependency resolution and good download speeds.

When creating such packages (using any method) you'll still need to download (at least temporally) build dependencies. As an order obsessed person I avoid doing it directly in my system and use chroot environments instead, these chroot boxes are way cheaper than virtualization solutions and faster to setup. Since I already use [pbuilder](https://viajemotu.wordpress.com/2010/08/10/notas-sobre-pbuilder) and it has a very nice **--login** option, I use it to create temporal environments and destroy them on exit.

Let's suppose a new ffmpeg version has just been released and you want to try it on your stable Ubuntu system, these would be the steps necessary to compile, package and install it in your host system.

<pre class="sh_sh">
$ sudo apt-get -y remove ffmpeg x264 libx264-dev libmp3lame-dev
$ sudo pbuilder.natty --login
[natty-chroot] # apt-get install wget
[natty-chroot] # apt-get -y install nasm build-essential git-core \
                 checkinstall yasm texi2html libfaac-dev libopencore-amrnb-dev     \
                 libopencore-amrwb-dev libsdl1.2-dev libtheora-dev libvorbis-dev   \
                 libx11-dev libxfixes-dev libxvidcore-dev zlib1g-dev
[natty-chroot] # git clone git://git.videolan.org/ffmpeg
[natty-chroot] # cd ffmpeg
[natty-chroot] # ./configure --enable-gpl --enable-version3 --enable-nonfree \
                --enable-postproc --enable-libfaac --enable-libopencore-amrnb \
                --enable-libopencore-amrwb --enable-libtheora --enable-libvorbis \
                --enable-libx264 --enable-libxvid --enable-x11grab --enable-libmp3lame
[natty-chroot] # make
[natty-chroot] # checkinstall --pkgname=ffmpeg --pkgversion="5:$(./version.sh)" \
                --backup=no --deldoc=yes --default
$ cp /var/cache/pbuilder/natty-amd64/build/{number}/home/user/ffmpeg.deb ~
$ sudo dpkg -i ffmpeg_5:201111091946-git-1_amd64.deb
</pre>

Once installed, the tmp chroot environment can be destroyed by terminating the session

<pre class="sh_sh">
[natty-chroot] # exit
</pre>

Sweet &#252;
