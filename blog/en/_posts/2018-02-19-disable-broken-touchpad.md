---
layout: post
title: "disable broken touchpad device"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

From time to time I accidentally drop liquids into my thinkpad laptop and the touchpad start behaving funny, when it happens I prefer to disable it completely for some hours/days until it gets fixed by itself.

**Distro: Ubuntu 16.04**

<pre>
$ xinput list
⎡ Virtual core pointer                id=2  [master pointer  (3)]
⎜   ↳ Virtual core XTEST pointer      id=4  [slave  pointer  (2)]
⎜   ↳ TPPS/2 IBM TrackPoint           id=12 [slave  pointer  (2)]
⎜   ↳ SynPS/2 Synaptics TouchPad      id=11 [slave  pointer  (2)] => THIS ONE
⎣ Virtual core keyboard               id=3  [master keyboard (2)]
    ↳ Virtual core XTEST keyboard     id=5  [slave  keyboard (3)]
    ↳ Power Button                    id=6  [slave  keyboard (3)]
    ↳ Video Bus                       id=7  [slave  keyboard (3)]
    ↳ Sleep Button                    id=8  [slave  keyboard (3)]
    ↳ Integrated Camera: Integrated C id=9  [slave  keyboard (3)]
    ↳ AT Translated Set 2 keyboard    id=10 [slave  keyboard (3)]
    ↳ ThinkPad Extra Buttons          id=13 [slave  keyboard (3)]

$ xinput --disable 11
$ xinput --enable  11 #when the time comes
</pre>

That's it, happy accidents &#128523;

- https://askubuntu.com/questions/65951/how-to-disable-the-touchpad
