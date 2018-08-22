---
layout: post
title: "minos, a tiling wm linux distribution"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

I've been working in my spare time in a yet another Linux respin for the last
7-8 years and I thought I better write something about it so my co-workers and
friends have a better time getting started.

### About

[Minos](https://github.com/minos-org/) is a personal effort to get a stable,
performant and productive Linux system for power user/dev roles.

    ▸ Based on Ubuntu LTS releases and with BedRock Linux support on its way
        ▸ 14.04 / 16.04 / 18.04
    ▸ Tiling window manager, i3wm + patches
    ▸ Full battery cli workflow, urxvt, tmux, vim, wicd, shundle, ...
    ▸ Non-intrusive and fast dmenu based launchers for sessions, process
      management, virtualization, etc.
    ▸ Handpicked minimal yet powerful apps for common tasks:
        ▸ file manager     -  pcmanfm     | login screen -  slim
        ▸ image viewing    -  feh, sxiv   | pdf reader   - zathura
        ▸ music indexing   -  mpd         | video player - mplayer2, umplayer
        ▸ network manager  -  wicd-curses | email client - mutt
        ▸ ...

[![](/assets/img/minos-movie.png)](/assets/img/minos-movie.png)

### Principles

In order to achieve its goal, minos design is lead by:

    Minimalism → use as few elements as possible but not less
    Coherence  → based on modularity and composition, elements relate to each other
    Stability  → incremental over revolutionary
    Control    → extensive configuration options
    Pluggable  → plugin based components
    Beauty     → subjective, but right now mostly black =P

There exist two versions of the system:

* **Core: X less environment, ideal for servers.**
* **Desktop: Graphic tiling wm environment for laptops/workstations.**

### Installation

#### Ubuntu LTS based distro

On any Ubuntu LTS release add the Minos repository:

    $ sudo add-apt-repository ppa:minos-archive
    $ sudo apt-get update

And install the core or/and desktop metapackages:

    $ sudo apt-get install -y minos-core
    $ sudo apt-get install -y minos-desktop #includes minos-core

Or run the [http://minos.io/s](http://minos.io/s) installer:

    $ sh <(wget -q -O- minos.io/s) core
    $ sh <(wget -q -O- minos.io/s) desktop

#### Live Ubuntu LTS based distro

From any [L/X/K]Ubuntu live usb run the [http://minos.io/s](http://minos.io/s)
installer:

    $ sh <(wget -q -O- minos.io/s) live core    /dev/sdX username passwd [/dev/sdaY]
    $ sh <(wget -q -O- minos.io/s) live desktop /dev/sdX username passwd [/dev/sdaY]

Where:

    /dev/sdX → / mount point
    username → admin minos user
    passwd   → admin minos user password

    /dev/sdY → /home mount point   (optional)
    --release  [14.04|16.04|18.04] (optional)

#### Vagrant

Minos is also available as portable VirtualBox images:

    $ vagrant init minos/core-18.04    && vagrant up
    $ vagrant init minos/desktop-18.04 && vagrant up

Additional boxes are located at
[https://app.vagrantup.com/minos](https://app.vagrantup.com/minos)

### Getting started

#### apt/dpkg

Minos is based on Debian/Ubuntu, as such, it uses `apt/dpkg` tools to
manage/install software, some of the configuration changes include:

**Core**

    ▸ Recommend and suggested packages[0] are disabled by default. Use
      → $ sudo dpkg-reconfigure minos-core-settings #to change it

    ▸ shundle/aliazator add install, purge, remove, update, upgrade, aliases:
      → $ type install
      > install is aliased to `sudo apt-get install --no-install-recommends'

      * Use:
      → $ aliazator [enable|disable] apt-get #to modify this behavior

    ▸ eix is provided as an alternative apt-get/apt/aptitude interface
      → $ eix -h

**Desktop**

    ▸ Deb packages are cached and shared over avahi (zeroconf)

* [https://www.debian.org/doc/manuals/debian-faq/ch-pkg_basics.en.html#s-depends](https://www.debian.org/doc/manuals/debian-faq/ch-pkg_basics.en.html#s-depends)
* [https://www.unix-ag.uni-kl.de/~bloch/acng/](https://www.unix-ag.uni-kl.de/~bloch/acng/)

#### static-get

[static-get](https://github.com/minos-org/minos-static) is included as an
alternative installation medium allowing to fetch statically linked Linux
binaries.

    ▸ Search tmux available versions
      → $ static-get -s tmux
        > tmux-1.9a-1.tar.xz:8ec9d37183d48d3e171e89b1dae6e212a5918262d10
        > tmux-2.1-1.tar.xz:8172e0f2b39818ee747fa5b445a0a69342c11d1afa72
        > tmux-2.2-1.tar.xz:f499f6e9368a5022f45b726759b588e52b16442ae2f3

    ▸ Download and extract the specified package
      → $ static-get -x tmux-2.2
        > tmux-2.2-1.tar.xz
        > tmux-2.2-1/

#### shell / shundle

The default bash editing mode is set to `vi` with some `emacs` exceptions
meaning than common shortcuts like `<Ctrl-l> (clear screen)`, `<Ctrl-r>
(reverse cmd search)`, `<Ctrl-a>/<Ctrl-e> (star/beginning sentence)` work
the same while vi keybindings are used for all other actions. One of the
most powerful characteristics of this mode are text objects.

    ▸ text objects:
      → $ echo "text object" #pressing ci" while in the 'text' word results in
      → $ echo "" #removing the inner " characters

Math operations are recognized:

    ▸ examples include: +, -, *, /, %
      → $ 5 + 5
        > 10
      → $ 7 \* 2.3
        > 16.1

Search and other common actions are integrated within the shell:

    ▸ open the default web browser
        → $ 1999, binary finary :google

    ▸ or get back results from cli utils who output to console directly
      → $ howdoi format date bash
        > today=`date +%Y-%m-%d.%H:%M:%S`
      → $ translate -en-pt 'deleted code is debugged code'
        > Código eliminado é código depurado

    ▸ open resources by its name/suffix or by using the `open` launcher
      → $ /path/to/image.png
      → $ open https://wikipedia.org

Autocd, auto ls, and directory indexing are enabled for faster jumping between
directories:

    ▸ create and jump in one cmd
      → $ mkcd ~/a/long/path/including/a/directory/

    ▸ change directories without requiring cd
      → $ ~/a/long/path/including/a/

    ▸ index directory paths, see `man wcd`
      → $ update-cd
      → $ cd including #go to ~/a/long/path/including/

    ▸ backward pwd search for normal and versioned projects, see `command -v ,,,`
      → $ ,, long #go to ~/a/long

Desktop:

    ▸ <Alt-Esc> is mapped to `dmenu-launcher` which supports the above
      attributes plus clipboard integration

In order to provide additional yet optional characteristics, plugins based
components are offered, [shundle](https://github.com/javier-lopez/shundle) is
the mechanism for which they're managed, alternatives include
[oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) /
[prezto](https://github.com/sorin-ionescu/prezto) /
[bash-it](https://github.com/Bash-it/bash-it), etc. Shundle allows installing
scripts/modules which enrich the shell environment with sane defaults, aliases,
functions and prompt themes.

By default the following plugins are enabled (**~/.profile.d/shundle.sh**):

    ▸ aliazator: An aliases manager, providing hundred of aliases for common
                 commands, eg: apt-get, git, ssh, sudo, wget, vim, etc.

    ▸ autocd: Current directory autosaving (pwd), allows external applications
              start "from here", used for new urxvt/tmux instances.

    ▸ colorize: Provides prompt, X resources and less/grep/ls themes.

    ▸ eternalize: Store an eternal history file across sessions

Shundle integration is provided by the `minos-core-settings` package, can be
disabled/enabled by running:

    $ sudo dpkg-reconfigure minos-core-settings #shundle option

#### tmux / tundle

Simply speaking, [tmux](https://tmux.github.io/) acts as a window manager for
terminals, on Minos, it's configured and installed by default in pair with
[mosh](https://mosh.org) to provide robust, secure and efficient access to
local and remote shell sessions.

tmux is launched on every incoming ssh connection and within the scratchpad
window `<Windows><Space>` (desktop edition). Of course, it can also be
initialized manually.

The default prefix sequence has been changed from `<Ctrl-b>` → `<Ctrl-a>`

As with the bash interpreter, tmux can be customized/extended through
additional plugins, Minos includes
[tundle](https://github.com/javier-lopez/tundle) as the default tmux plugin
manager.

By default the following plugins are enabled (**~/.tmux.conf**):

    ▸ tmux-sensible: improve tmux defaults, including <Ctrl-a> as default
      prefix.

    ▸ tmux-pain-control: rebinds default keybindings for pane management.

    ▸ tmux-yank: tmux/system clipboard integration

    ▸ tmux-resurrect: persists tmux environments across system restarts

    ▸ tmux-copycat: enhances tmux search to find easily files, git hashes,
                    urls, etc

Tundle integration is provided by the `minos-core-settings` package, and can
enabled/disabled by running:

    $ sudo dpkg-reconfigure minos-core-settings #tundle option

#### vim / vundle

[Vim](https://www.vim.org/) is a highly configurable text editor mostly used by
power users and developers to create content at the speed of thought. On Minos,
it's included by default with the `vim-nox` and `vim-gtk` packages (the latter
only in the desktop version). [Vundle](https://github.com/javier-lopez/vundle)
has been adopted as the default vim plugin manager.

A fair amount of vim plugins are included (~50), most of them are loaded on
demand or upon specific events in order to do not affect the editor startup
time. Some examples include:

    Bundle 'bogado/file-line'      "jump to line on startup, eg: $ vim file:23
    Bundle 'mhinz/vim-signify'     "git|svn modification viewer
    Bundle 'tpope/vim-surround'    "text :h objects on steroids
    Bundle 'msanders/snipmate.vim' "snippet support
    Bundle 'Shougo/neocomplcache'  "autocompletion

Vundle integration is provided by the `minos-core-settings` package, run
the following command to disable/enable it:

    $ sudo dpkg-reconfigure minos-core-settings #vundle option

#### minos-tools

Additional wrappers and power user scripts (>100) are available through the
`minos-core-tools` and `minos-desktop-tools` packages.

**Core**

    ▸ rm wrapper with nautilus/pcmanfm trash management integration
      → $ mkdir ~/a/long/path/including/a/directory
      → $ rm -r ~/a/long/path/including/a/directory
      → $ rm -l a #outputs recoverable files matching the 'a' pattern
      → $ rm -u a #recovers the files matching the 'a' pattern
      → $ ls    ~/a/long/path/including/a/directory/

    ▸ compress / extract wrappers to ease archive creation/decompression.
      → $ touch a b c && compress a b c abc.tar.gz
      → $ rm -f a b c && extract  abc.tar.gz

    ▸ text / image pastebins
      → $ cat ~/.bashrc | sprunge
        > http://sprunge.us/AYZC
      → $ uimg image.png
        > http://i.imgur.com/KyoFMH9.png

**Desktop**

    ▸ dmenu-*       #dmenu based launchers, i3 window jumper,
                    #process/session management, vbox/xrandr/mpd/ wrappers
    ▸ watch-battery #battery notifier, suspend/hibernate the system if
                    #no manual action is taken
    ▸ player-ctrl   #control multimedia players, mpd/mplayer/spotify

To get a full list of the included scripts run:

    $ dpkg -L minos-core-tools minos-desktop-tools

### minos-config

Minos is commanded by configuration files, those determinate global settings
(eg, wallpaper, autostart, etc), post-installation hooks, etc:

    - $HOME/.minos/config
    - /etc/minos/config

A simple ini like syntax is used, e.g.

    /etc/minos/config
        wallpaper /usr/share/minos/wallpapers/minos.png

To look-up a value, use `minos-config key`, e.g:

    $ minos-config wallpaper
     /usr/share/minos/wallpapers/minos.png

See `minos-config -h` and
[http://minos.io/doc/config](http://minos.io/doc/config) for further details.

### Development

Minos uses a Rolling Release over LTS cycle, meaning it pushes frequent and
small updates to LTS releases and doesn't provide named releases by itself.

There is a parity:

    ▸ 1 deb package => 2 git repositories
                   \
                    \__  program src
                     \__ deb packaging

Which requires a package to compile correctly in all LTS supported releases
with the same deb code in order to be accepted, other Debian based distros
create different packaging code for every release, that's unacceptable in Minos
due to the limited human resources and general waste it would be.

Deb **source files** are located at
[https://github.com/minos-org/](https://github.com/minos-org/)

    foo-program     (custom/freeze program)
    foo-program-deb (deb packaging)
        debian
            rules
                get-orig-source target (must retrieve content)
        debian/README.source (step by step instructions to build package)

Deb **binary packages** are located at
[https://launchpad.net/~minos-archive/+archive/main](https://launchpad.net/~minos-archive/+archive/main),
and are created using daily recipes asociated to every source mirror.

In certain ocasions, base repositories are modified to introduce changes or
delete problematic files, those changes are automatic and described at:
[https://github.com/minos-org/minos-sync](https://github.com/minos-org/minos-sync)

#### Choosing default applications

    ▸ Default applications are selected with good documentation, flexibility,
    configurability and as few dependencies as possible in mind.
    ▸ Systems supporting composition/specialization are preferred over
    generalization
    ▸ Keyboard oriented applications are preferred over pointing interfaces
    ▸ GUI programs are nice but rejected if they use ancient graphical
    interfaces or use considerable resources.
    ▸ When in doubt http://suckless.org/rocks provide additional hints about
    how software is selected into the project

#### Choosing default behavior

     ▸ Toggle solutions are preferred over multichoice.
     ▸ Use/Set vi like applications/settings are preferred
     ▸ Defaults are configured with a focus in the out-of-the-box experience

#### Roadmap

Minos is built on top of the most popular Linux distribution system to get a
lot of free software and an easy integration with third-party providers. At the
time of writing this, that's Ubuntu, however future development should be
towards a multi-channel system such as [SubUser](http://subuser.org/) or
[BedRock Linux](https://bedrocklinux.org/).

That's it, happy tiling &#128522;
