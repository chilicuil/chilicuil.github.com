---
layout: post
title: "stop firefox directory autocreation"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

By default Firefox creates a **Desktop** and **Download** directories in **$HOME** accordying to [freedesktop policies](http://www.freedesktop.org/wiki/Software/xdg-user-dirs). This feature can be annoying for some persons (including me). IMO nobody should force you to use a pre-fixed directory layout.

To disable this feature the **$HOME/.config/user-dirs.dirs** file should be edited as follows:

<pre class="sh_sh">
$ cat $HOME/.config/user-dirs.dirs
XDG_DESKTOP_DIR="$HOME/./"
XDG_DOWNLOAD_DIR="$HOME/./"
XDG_TEMPLATES_DIR="$HOME/./"
</pre>

The Linux desktop specifications are pretty dumb &#128532;
