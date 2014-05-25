---
layout: post
title: "multicursor in ubuntu"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

**[![](/assets/img/88.png)](/assets/img/88.png)**

During my last holidays I found myself into a position where I had to share my laptop with other persons. I knew it was possible to use different keyboards/mice with Linux but never had tried.., till now &#128527;

On this scenario, I had an extra monitor and an extra mouse, so the first thing I did was to enable the monitor, since I use [i3](http://i3wm.org/) as my window manager I use raw xrandr to extend my visual setup.

<pre>
$ xrandr --output VGA1 --mode 1680x1050 --right-of LVDS1
</pre>

Pretty simple, I just love this kind of tools. Next item, enable mouse. For this device to work I used [xinput](http://cgit.freedesktop.org/xorg/app/xinput/).

<pre>
$ xinput create-master Auxiliary
$ xinput list #get the mouse id
$ xinput reattach 10 "Auxiliary pointer" #use the id to set it as auxiliar pointer
</pre>

After applying these changes, the xinput configuration looked like this: 

<pre>
xinput list
⎡ Virtual core pointer                    	id=2	[master pointer  (3)]
⎜   ↳ Virtual core XTEST pointer              	id=4	[slave  pointer  (2)]
⎜   ↳ Microsoft Microsoft® Nano Transceiver v1.0	id=11	[slave  pointer  (2)]
⎜   ↳ SynPS/2 Synaptics TouchPad              	id=14	[slave  pointer  (2)]
⎜   ↳ TPPS/2 IBM TrackPoint                   	id=15	[slave  pointer  (2)]
⎣ Virtual core keyboard                   	id=3	[master keyboard (2)]
    ↳ Virtual core XTEST keyboard             	id=5	[slave  keyboard (3)]
    ↳ Power Button                            	id=6	[slave  keyboard (3)]
    ↳ Video Bus                               	id=7	[slave  keyboard (3)]
    ↳ Power Button                            	id=8	[slave  keyboard (3)]
    ↳ Microsoft Microsoft® Nano Transceiver v1.0	id=9	[slave  keyboard (3)]
    ↳ Integrated Camera                       	id=12	[slave  keyboard (3)]
    ↳ AT Translated Set 2 keyboard            	id=13	[slave  keyboard (3)]
    ↳ ThinkPad Extra Buttons                  	id=16	[slave  keyboard (3)]
⎡ Auxiliary pointer                       	id=17	[master pointer  (18)]
⎜   ↳ Microsoft Microsoft® Nano Transceiver v1.0	id=10	[slave  pointer  (17)]
⎜   ↳ Auxiliary XTEST pointer                 	id=19	[slave  pointer  (17)]
⎣ Auxiliary keyboard                      	id=18	[master keyboard (17)]
    ↳ Auxiliary XTEST keyboard                	id=20	[slave  keyboard (18)]
</pre>

That's it, the experience wasn't really bad, i3 reacts correctly most of the time and although there were confusion, it is manageable &#128522;

- [https://wiki.archlinux.org/index.php/Multi-pointer_X](https://wiki.archlinux.org/index.php/Multi-pointer_X)
