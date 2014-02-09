---
layout: post
title: "use flags (gentoo) para portatil"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

Flags para un portatil basado en un pentium-m, con soporte para gnome, multimedia, red, programacion y algunas otras cosas.

    #**************Variables USE**************** #Actualizado a vie feb 29
    17:42:10 CST 2008
    
    #Consola USE="${USE} bash-completion gpm ncurses slang fbcon"
    
    #Entorno grafico USE="${USE} dbus X gnome -kde cairo libnotify "
    
    #Grabacion/Lectura cd/dvd USE="${USE} cdr -dvdr dvdread "
    
    #Hardware USE="${USE} -3dfx -3dnow acpi -apm -altivec bluetooth hal
    ieee1394 ipod lirc lm_sensors mmx hddtemp -mpi -multilib -netboot nocd pcmcia
    pda ppds -scanner sse sse2 usb wifi gphoto2 opengl"
    
    #Desarrollo USE="${USE} cscope dbm doc emacs examples expat -fortran -gcj
    gtk -ifc -jikes java java6 javascript -mule pcre perl php python -qt3 -qt4
    readline ruby sdl spl subversion"
    
    #Red USE="${USE} -aim cups -freewnn ftp -icq idn imap ipv6 jabber libgda
    mime mozilla msn -oscar samba sockets socks5 ssl vhosts -yahoo evo mailwrapper
    rss"
    
    #Sonido y codecs de audio USE="${USE} alsa -oss ao esd osc ladspa lame
    libsamplerate pulseaudio aac -arts audiofile -cddb cdparanoia dts flac jack
    lash mad matroska mikmod modplug mp3 musepack musicbrainz&nbsp; ogg openal
    shorten sox speex vorbis "
    
    #Tipos de archivos USE="${USE} bzip2 pdf xml zlib "
    
    #Imagenes USE="${USE} imagemagick gif jbig jpeg jpeg2k lcms mng openexr png
    raw svg -wmf xpm"
    
    #Video y codecs de video USE="${USE} a52 aalib dv dvb dvd encode exif
    ffmpeg gstreamer libcaca mpeg mplayer quicktime theora v4l2 vcd -win32codecs xv
    xvid"
    
    #Seguridad USE="${USE} clamav cracklib crypt pam syslog "
    
    #Otros USE="${USE} -accessibility -bindist cdinstall -debug fam nptl
    offensive -old-linux posix session source spell threads truetype unicode videos
    xprint xscreensaver nls"
    
    #Use Flags peligrosas: alpha, amd64, arm, hppa, ia64, mips, ppc, ppc64
    #ppc-macos, s390, sh, sparc, x86 
    
    #*******************************************
    #*******************************************
        
Para recompilar el sistema despues de cambiar las use flags, se ejecuta:

<pre class="sh_sh">
$ emerge --update --deep --with-bdeps=y --newuse world
</pre>
