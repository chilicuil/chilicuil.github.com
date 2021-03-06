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

I used to use byobu because of its ease of installation (at least on Ubuntu) and default status bar. However, for my needs, it looked overwhealming and was difficult to modify, I prefer systems with a plugin centric approach (like [vim + vundle](https://github.com/javier-lopez/vundle), or [sh + shundle](http://javier.io/blog/en/2013/11/15/shundle.html)), so at the end I decided to migrate. Since tmux is way better than screen, I focused on it.

There is a recent attempt to create a general tmux plugin environment:

 - [tpm](https://github.com/tmux-plugins/tpm)
 - [tmux-plugins](https://github.com/tmux-plugins)

Tpm and plugins is a great effort to cover the missing tmux features through an organized plugin system, it covers a fair amount of functionality and allows good granulity between plugins, however it also has its drawbacks, the most important ones for me are its dependency on bash and recent tmux releases (>=1.9), and its inability to install other but the latest version of any plugin (what if I want and older version with less features but more stability?). The tpm maintainer is a great guy however these issues are not at its top list and considering the amount of refactoring required to unmarry tpm from bash/specific tmux features, I finally decided to go my own, that's how [tundle](https://github.com/javier-lopez/tundle) was born, an alternative tmux plugin environment with compatibility and control version in mind.

I've gone to a great lenght to ensure tundle runs in as many platforms as possible (at least where tmux is available) degrading slowly depending in the tmux features available (right now running in tmux >= 1.6 , older versions can be discussed), in addition to improved portability/performance it's now possible to install plugins by git hash ensuring you only run code you trust. All other features are similiar, with the tipical fix here and there result of a complete code review.

### Quick start

    $ git clone --depth=1 https://github.com/javier-lopez/tundle ~/.tmux/plugins/tundle

After installing tundle additional bundle/plugin modules can be defined at `~/.tmux.conf`

    run-shell "~/.tmux/plugins/tundle/tundle"

    #let tundle manage tundle, required!
    setenv -g @bundle "javier-lopez/tundle"

    #from GitHub
    #you can specify a branch or commit sha checksum
    setenv -g @bundle "javier-lopez/tundle-plugins/tmux-sensible:c7b09"
    setenv -g @bundle "gh:javier-lopez/tundle-plugins/tmux-pain-control"
    setenv -g @bundle "github:javier-lopez/tundle-plugins/tmux-resurrect"

And installed by starting `tmux` and pressing `Ctrl-b + I` or running `~/.tmux/plugins/tundle/scripts/install_plugins.sh`

Tundle is able to install and run tpm plugins as well, but if you do so, portability is lost since tpm plugins will only work in tmux >= 1.9 and bash, if that's not a problem go ahead you still will get extra syntax sugar and version control over your tmux environment.

Additional tundle plugins are available at:

 - [tundle-plugins](https://github.com/javier-lopez/tundle-plugins)

Happy multiplexing &#128523;
