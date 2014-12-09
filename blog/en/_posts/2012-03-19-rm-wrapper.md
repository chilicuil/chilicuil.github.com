---
layout: post
title: "rm wrapper"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

Sometimes when I run:

<pre class="sh_sh">
$ rm foo
</pre>

I realize I didn't mean it, so with this in my mind I made a little [wrapper](https://github.com/chilicuil/learn/blob/master/sh/tools/trash) around rm, now, when I remove files, they're send them to the trash bin, it's compatible with nautilus/pcmanfm.

Example: If I run from a terminal **$ rm img.png** I can then go to the Trash carpet in Nautilus and restore it. If I delete an item with Nautilus (by pressing the **Supr** button) I can open a terminal and type **$ rm -u img.png** and get back my stuff.

**[![](/assets/img/53.png)](/assets/img/53.png)**

If you want use the script, download and move it to **/usr/local/bin**, then you can use as **rm_** or even override rm through and alias defined in the **~/.bashrc** file:

<pre class="sh_sh">
$ alias rm='trash'
</pre>

<!--<iframe class="showterm" src="http://showterm.io/0a5b334fd24f82bd5ede1" width="640" height="350">&nbsp;</iframe> -->

&#128520;
