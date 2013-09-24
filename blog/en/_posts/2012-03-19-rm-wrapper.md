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

I realize I didn't mean it, so with this in my mind I made a little [wrapper](https://github.com/chilicuil/learn/blob/master/sh/tools/rm_), now instead of removing my files, it sends them to the trash bin, it's compatible with nautilus|pcmanfm.

Example: If I run from a terminal **$ rm img.png** I can then go to the Trash carpet in Nautilus and restore it. If I delete it in Nautilus (by pressing the **Supr** button) I can open a terminal and type **$ rm -u img.png**

**[![](/assets/img/53.png)](/assets/img/53.png)**

If you want use the script, download it, move it to **/usr/local/bin** and add an alias to the **~/.bashrc** file:

<pre class="sh_sh">
$ alias rm='rm_'
</pre>

Hope it helps
