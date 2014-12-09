---
layout: post
title: "dmenu for everything"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

I love minimalism systems and programs who focus in doing a single task very well, **dmenu** is one of those programs I use it for all my launch needs.

[dmenu](http://tools.suckless.org/dmenu/) is a program who read a list of options and present them to the user, when the user select an option it prints the result and exits, simple! &#128522;
You can easily create scripts for launch anything, really!, let's review how to create a virtualbox launcher:

The first step (and the hardest) is to figure out how to create a list of the options you wanna present in screen, on thix example vbox machines:

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

Everything In 7 LOC!, this script can now be saved at **/usr/local/bin/** and used as a shortcut, in my use case, I added it to **~/.i3/config**:

<pre>
# vbox:
bindsym $Altgr+v exec dmenu_vbox
</pre>

So now I can launch vbox machines by pressing **Altrg + v** and select the appropiated machine, if you liked dmenu as much as I did, I've made a handful of such scripts to control music, user sessions, apps, etc. Feel free to grab them at:

- [https://github.com/chilicuil/learn/tree/master/sh/tools](https://github.com/chilicuil/learn/tree/master/sh/tools)

**[![](/assets/img/61.png)](/assets/img/61.png)**
**[![](/assets/img/62.png)](/assets/img/62.png)**
**[![](/assets/img/63.png)](/assets/img/63.png)**
**[![](/assets/img/64.png)](/assets/img/64.png)**
