---
layout: post
title: "terminfo variable"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

This is a quick reminder to my future self about how to fix some annoying TERM errors

    ./bin/atop
    Error opening terminal: rxvt-unicode-256color.

On these cases it could help defining the TERM variable to a more standard type, eg;

    TERM=xterm ./bin/atop

Or/and specify the TERMINFO variable, eg:

    TERMINFO='/usr/share/terminfo/'  ./bin/atop

This is specially useful for compiled programs who configure the TERMINFO variable to a different one during compilating time.

That's it, happy launching &#128523;

- [screen cannot find terminfo entry](http://stackoverflow.com/questions/12345675/screen-cannot-find-terminfo-entry-for-xterm-256color)
