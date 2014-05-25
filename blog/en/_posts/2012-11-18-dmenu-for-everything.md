---
layout: post
title: "dmenu for everything"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

I love minimalism systems and programs who can do a single task well done, **dmenu** as many of the suckless tools shine at this, so it didn't took me a long time before I discovered it and started to use it for all my launch needs.

dmenu is a program who read a list of options and present them to the user, once the user select an option it prints it and exit, simple! &#128522; 

You can easily create scripts for launch anything, e,g., let's review how to launch virtualbox machines:

The first step (and the hardest) is to figure out how to create a list of current vbox machines:

<pre class="sh_sh">
$ vboxmanage list vms | cut -d\" -f2
</pre>

Once defined, it's quite easy to come up with a complete launcher script:

<pre class="sh_sh">
DMENU='dmenu -p > -i -nb #000000 -nf #ffffff -sb #000000 -sf #3B5998'
vboxmachine=$(vboxmanage list vms | cut -d\" -f2 | $DMENU)

if [ -z "${vboxmachine}" ]; then
    exit 0;
else
    vboxmanage -q startvm "$vboxmachine" --type gui
fi
</pre>

Everything In 7 LOC!, this script can now be saved at **/usr/local/bin/** and used as a shortcut, in my user case, I added it to **~/.i3/config**:

<pre>
# vbox:
bindsym $Altgr+v exec /usr/local/bin/dmenu_vbox
</pre>

I can now launch the available vbox machines by pressing Altrg + v, if you liked dmenu as much as I did, I've made a handful of such scripts to control music, user sessions, applications, etc. Feel free to grab them at:

- [https://github.com/chilicuil/learn/tree/master/sh/tools](https://github.com/chilicuil/learn/tree/master/sh/tools)

**[![](/assets/img/61.png)](/assets/img/61.png)**
**[![](/assets/img/62.png)](/assets/img/62.png)**
**[![](/assets/img/63.png)](/assets/img/63.png)**
**[![](/assets/img/64.png)](/assets/img/64.png)**
