---
layout: post
title: "gentoo useflags"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

These are the flags I'm using for a pentium-m laptop.

    #console USE="${USE} bash-completion gpm ncurses slang fbcon"
    
    #graphical interface USE="${USE} dbus X gnome -kde cairo libnotify "
    
    #cd/dvd USE="${USE} cdr -dvdr dvdread "
    
    #hardware USE="${USE} -3dfx -3dnow acpi -apm -altivec bluetooth hal
    ieee1394 ipod lirc lm_sensors mmx hddtemp -mpi -multilib -netboot nocd pcmcia
    pda ppds -scanner sse sse2 usb wifi gphoto2 opengl"
    
    #dev USE="${USE} cscope dbm doc emacs examples expat -fortran -gcj
    gtk -ifc -jikes java java6 javascript -mule pcre perl php python -qt3 -qt4
    readline ruby sdl spl subversion"
    
    #net USE="${USE} -aim cups -freewnn ftp -icq idn imap ipv6 jabber libgda
    mime mozilla -msn -oscar samba sockets socks5 ssl vhosts -yahoo evo mailwrapper
    rss"
    
    #sound USE="${USE} alsa -oss ao esd osc ladspa lame
    libsamplerate pulseaudio aac -arts audiofile -cddb cdparanoia dts flac jack
    lash mad matroska mikmod modplug mp3 musepack musicbrainz&nbsp; ogg openal
    shorten sox speex vorbis "
    
    #misc formats USE="${USE} bzip2 pdf xml zlib "
    
    #images USE="${USE} imagemagick gif jbig jpeg jpeg2k lcms mng openexr png
    raw svg -wmf xpm"
    
    #video USE="${USE} a52 aalib dv dvb dvd encode exif
    ffmpeg gstreamer libcaca mpeg mplayer quicktime theora v4l2 vcd -win32codecs xv
    xvid"
    
    #security USE="${USE} clamav cracklib crypt pam syslog "
    
    #random USE="${USE} -accessibility -bindist cdinstall -debug fam nptl
    offensive -old-linux posix session source spell threads truetype unicode videos
    xprint xscreensaver nls"
    
    #dangerous flags: alpha, amd64, arm, hppa, ia64, mips, ppc, ppc64
    #ppc-macos, s390, sh, sparc, x86 
    
    #*******************************************
    #*******************************************
        
After changing use global flags, gentoo needs to be recompiled:

<pre class="sh_sh">
$ emerge --update --deep --with-bdeps=y --newuse world
</pre>
