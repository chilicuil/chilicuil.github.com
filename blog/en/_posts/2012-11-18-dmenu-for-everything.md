---
layout: post
title: "dmenu for everything"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

I love minimalism systems and programs who focus in doing a single task very well, [dmenu](http://tools.suckless.org/dmenu/) is one of them, it reads input from user, matches patterns and returns results, simple! With this functionality it can (ab)used to create launchers for almost anything, let's review how to create a virtualbox launcher...

The first step (and the hardest) is to figure out how to create an option list to present in screen, on this example vbox machines:

<pre class="sh_sh">
$ vboxmanage list vms | cut -d\" -f2
</pre>

Once defined, it's easy to come up with missing parts:

<pre class="sh_sh">
DMENU='dmenu -p > -i -nb #000000 -nf #ffffff -sb #000000 -sf #3B5998'
vboxmachine="$(vboxmanage list vms | cut -d\" -f2 | $DMENU)"
[ -z "${vboxmachine}" ] && exit 0 || vboxmanage -q startvm "$vboxmachine" --type gui
</pre>

Everything in 3 LOC!, this script can now be saved at **/usr/local/bin/** and used as a shortcut, in my use case, I added it to **~/.i3/config**:

<pre>
# vbox:
bindsym $Altgr+v exec dmenu_vbox
</pre>

So now I can launch vbox machines by pressing **Altrg + v** and select the appropiated machine, if you liked dmenu as much as I did, I've made a handful of scripts to control music, user sessions, apps, etc. Feel free to grab them at:

- [https://github.com/javier-lopez/learn/tree/master/sh/tools](https://github.com/javier-lopez/learn/tree/master/sh/tools)

**[![](/assets/img/61.png)](/assets/img/61.png)**
**[![](/assets/img/62.png)](/assets/img/62.png)**
**[![](/assets/img/63.png)](/assets/img/63.png)**
**[![](/assets/img/64.png)](/assets/img/64.png)**
