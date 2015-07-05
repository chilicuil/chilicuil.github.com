---
layout: post
title: "tundle, a tmux plugin manager"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

In the past I've been a regular [byobu](http://byobu.co/) user, a distribution for common terminal multiplexers ([tmux](http://tmux.github.io/), [screen](https://www.gnu.org/software/screen/)). A terminal multiplexer is a utility who allows you to manage several sessions and windows within the same program, kind of a window manager for the console. In my case I mostly use it to improve the robustness of remote ssh connections. In default ssh sessions if you lose the connection you lose your work, with terminal multiplexers you can 'dettach/attach' eternal living sessions which is quite useful to keep movility.

<br>
**![](/assets/img/tundle.gif)**

Unfortunately, like vi/emacs, the default screen/tmux settings are quite bad, so many people either personalize heavily its own settings or use a distribution/plugin system.

I used to use byobu because of its ease of installation (at least on Ubuntu) and default status bar. However for my needs it looked overwhealming and was difficult to modify, I prefer systems with a plugin centric approach (like [vim + vundle](https://github.com/chilicuil/vundle), or [sh + shundle](http://javier.io/blog/en/2013/11/15/shundle.html)), so at the end I decided to migrate.

Since tmux is way better than screen, I focused on it. There is a recent attempt to create a general tmux plugin environment:

 - [tpm](https://github.com/tmux-plugins/tpm)
 - [tmux-plugins](https://github.com/tmux-plugins)

Tpm and plugins is a great effort to cover the missing tmux features through an organized plugin system, however it targets bash, recent tmux versions (>=1.9) and only allows to grab the latest versions of every plugin. Those are kind of blockers for me, first, even when bash is a great interactive shell I don't consider it to be the best option for scripting, it's easy to start using bash unique features (losing portability) and its performance is not that great when compared with other shells. Second, even though tmux 1.9 isn't really that new, only older releases are available in popular stable Linux distributions (tmux 1.6 on Ubuntu 12.04), in addition, after looking at the tpm plugins source code the decision seems some kind arbitrary, older tmux versions have in place virtually all the required features for most plugins. And finally, unfortunately, in the current computer world updates aren't guaranted to be improved versions of the solicited software. So I find important to be able to chooice which version I really want to use, even if that means I'm not all the time in the bleeding edge.

With this in mind [tundle](https://github.com/chilicuil/tundle) was born, an alternative tmux plugin environment with compatibility (tmux 1.6, posix shell) and control version in mind.

### Quick start

    $ git clone --depth=1 https://github.com/chilicuil/tundle ~/.tmux/plugins/tundle

After installing tundle additional bundle/plugin modules can be defined at `~/.tmux.conf`

    run-shell "~/.tmux/plugins/tundle/tundle"

    #let tundle manage tundle, required!
    setenv -g @bundle "chilicuil/tundle"

    #from GitHub
    #you can specify a branch or commit
    setenv -g @bundle "chilicuil/tundle-plugins/tmux-sensible:c7b09"
    setenv -g @bundle "chilicuil/tundle-plugins/tmux-pain-control"
    setenv -g @bundle "chilicuil/tundle-plugins/tmux-resurrect"

And installed by starting `tmux` and pressing `Ctrl-b + I`

Tundle is able to install and run tpm plugins as well, but if you do so, portability is lost since tpm plugins will only work in tmux >= 1.9 and bash, if that's not a problem for you go ahead you still will get extra syntax sugar and version control over your tmux environment.

Additional tundle plugins are available at:

 - [tundle-plugins](https://github.com/chilicuil/tundle-plugins)

Happy multiplexing &#128523;
