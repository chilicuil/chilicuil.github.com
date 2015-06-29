---
layout: post
title: "tundle, a tmux plugin manager"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

In the past I've been a regular [byobu](http://byobu.co/) user, a distribution for common terminal multiplexers ([tmux](http://tmux.github.io/)/[screen](https://www.gnu.org/software/screen/)), mostly to take advantage of continual remote ssh connections. In normal ssh sessions if you lose the connection you lose your work, with terminal multiplexers you can 'detach|attach' an eternal living connection which is quite great to keep movility.

Unfortunately, like vi/emacs, the default screen/tmux settings are quite bad, so many people either personalize heavily its own settings or use a ready to use distribution/plugin system.

I used to use byobu because of its ease of installation (integrated on Ubuntu) and default status bar. However for my needs it looked overwhealming, I prefer systems with a plugin centric approach (like [vim + vundle](https://github.com/chilicuil/vundle), or [sh+shundle](http://javier.io/blog/en/2013/11/15/shundle.html)), at the end I decided to migrate.

Since tmux is way better than screen, I focused on it, I found a recent attempt to create a general tmux plugin environment:

 - [tpm](https://github.com/tmux-plugins/tpm)
 - [tmux-plugins](https://github.com/tmux-plugins)

Unfortunately it targets recent tmux versions (>=1.9). Since I'm stuck with tmux 1.6 on some systems, I've forked the most popular plugins and that's how tundle was born:

### Quick start

    $ git clone --depth=1 https://github.com/chilicuil/tundle ~/.tmux/plugins/tundle

After installing tundle additional bundle/plugin modules can be defined at `~/.tmux.conf`

    run-shell "~/.tmux/plugins/tundle/tundle"

    #let tundle manage tundle, required!
    setenv -g @bundle "chilicuil/tundle" #set -g can be used if tmux >= 1.9

    #from GitHub
    setenv -g @bundle "chilicuil/tundle-plugins/tmux-sensible:c7b09"
    setenv -g @bundle "chilicuil/tundle-plugins/tmux-pain-control"
    setenv -g @bundle "chilicuil/tundle-plugins/tmux-resurrect"

And installed by starting `tmux` and pressing `Ctrl-b + I`

Other plugins are available at:

 - [tundle-plugins](https://github.com/chilicuil/tundle-plugins)

Happy multiplexing &#128523;
