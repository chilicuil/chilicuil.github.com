---
layout: post
title: "clipboard synchronization between X11 and gnome apps"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

By default X11 powered systems have at least [two different clipboards](http://en.wikipedia.org/wiki/X_Window_selection#Clipboard) which may cause confusion sometimes &#128534;

There is no way to disable/delete them, so the next best solution is to synchronizate them. [Autocutsel](http://www.nongnu.org/autocutsel/) is a free cli utility who can do this. It works by adding it to the **~/.xsession** file or any other initialization file your windows system execute:

<pre class="sh_sh">
autocutsel &amp; #sync between X and Gnome apps
</pre>

Happy copy/pasting &#9787;
