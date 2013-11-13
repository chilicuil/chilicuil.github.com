#!/usr/bin/env bash

trap _cleanup SIGINT SIGTERM #trap ctrl-c

dotfiles="https://github.com/chilicuil/dotfiles"
utils="https://github.com/chilicuil/learn"
updates="http://javier.io/s"

apps_remote="git-core vim-nox exuberant-ctags byobu wcd htop rsync curl bzip2 gzip html2text ncurses-bin
             command-not-found"
apps_local="i3-wm alsa-utils alsa-base mpd pms mpc slim rxvt-unicode-256color xorg git-core autocutsel
            acpi suckless-tools feh notify-osd hibernate html2text htop irssi mplayer2 mutt-patched dzen2
            pcmanfm pm-utils rlpr tree unetbootin wodim xclip zsync gnupg-agent lxappearance libwww-perl
            i3lock conky-cli zathura gtk2-engines-pixbuf openssh-server wicd-curses geoclue-ubuntu-geoip
            redshift zram-config gvfs gvfs-common gvfs-daemons gvfs-fuse gvfs-libs libatasmart4 lame unzip
            libdevmapper-event1.02.1 libgdu0 libgnome-keyring-common libgnome-keyring0 libgudev-1.0-0
            liblvm2app2.2 libsgutils2-2 udisks policykit-1 google-talkplugin libmad0 libdvdcss2 sxiv
            libdvdread4 curl dkms libio-socket-ssl-perl libnet-ssleay-perl sendemail xdotool dbus-x11
            gxmessage wcd"
apps_ubuntudev="apt-file cvs subversion bzr bzr-builddeb pbuilder tidy zsync"
apps_purge="xinetd sasl2-bin sendmail-base sendmail-bin sensible-mda rmail bsd-mailx apache2.2-common
            sendmail apache2 nano"

if [ -z "${BASH_ARGV[0]}" ]; then
    mode="remote"
else
    case "${BASH_ARGV[0]}" in
        l|local)
            mode="local" ;;
        b|boot)
            mode="boot" ;;
        *)
            mode="remote" ;;
    esac
fi

#############################################################################################################
# General functions #########################################################################################
#############################################################################################################

_header()
{
    clear
    printf "%b\\n" "\033[1m----------------------\033[7m The Setup \033[0m\033[1m---------------------------\033[0m"
    printf "%b\\n" "\033[1m Dotfiles:\033[0m        $dotfiles"
    printf "%b\\n" "\033[1m Utils:\033[0m           $utils"
    printf "%b\\n" "\033[1m Updates:\033[0m         $updates"
    printf "\\n"

    case $mode in
        remote)
            printf "%b\\n" "\033[1m > Remote:                \033[0m$ bash <(wget -qO- javier.io/s)"
            printf "%b\\n" "\033[1m Local (includes Remote): \033[0m$ bash <(wget -qO- javier.io/s) l"
            printf "%b\\n" "\033[1m Boot:                    \033[0m$ bash <(wget -qO- javier.io/s) b"
            ;;
        local)
            printf "%b\\n" "\033[1m Remote:                    \033[0m$ bash <(wget -qO- javier.io/s)"
            printf "%b\\n" "\033[1m > Local (includes Remote): \033[0m$ bash <(wget -qO- javier.io/s) l"
            printf "%b\\n" "\033[1m Boot:                      \033[0m$ bash <(wget -qO- javier.io/s) b"
            ;;
        boot)
            printf "%b\\n" "\033[1m Remote:                  \033[0m$ bash <(wget -qO- javier.io/s)"
            printf "%b\\n" "\033[1m Local (includes Remote): \033[0m$ bash <(wget -qO- javier.io/s) l"
            printf "%b\\n" "\033[1m > Boot:                  \033[0m$ bash <(wget -qO- javier.io/s) b"
        esac
    printf "%b\\n" "\033[1m------------------------------------------------------------\033[0m"
}

_die()
{   #print a stacktrace with a msg, exits with 1
    local frame=0
    while caller $frame; do
        $((frame=frame+1));
    done

    printf "%s\\n" "$*"
    exit 1
}

_distro()
{   #return distro name in a lower string
    _distro_var_DIST_INFO="/etc/lsb-release"
    if [ -r "$_distro_var_DIST_INFO" ]; then
        . "$_distro_var_DIST_INFO"
    fi

    if [ -z "$DISTRIB_ID" ]; then
        _distro_var_DISTRIB_ID="Unknown";
        if [ -f /etc/arch-release ]; then
            _distro_var_DISTRIB_ID="Arch"
        elif [ -r /etc/knoppix-version ]; then
            _distro_var_DISTRIB_ID="Knoppix"
        elif [ -r /etc/sidux-version ]; then
            _distro_var_DISTRIB_ID="Sidux"
        elif [ -r /etc/debian_version ]; then
            _distro_var_DISTRIB_ID="Debian"
        elif [ -r /etc/issue ]; then
            _distro_var_DISTRIB_ID=$(cat /etc/issue.net | awk '{print $1}')
            if [ X"$_distro_var_DISTRIB_ID" = X"Ubuntu" ]; then
                _distro_var_DISTRIB_ID=Ubuntu
            fi
        elif [ -r /etc/gentoo-release ]; then
            _distro_var_DISTRIB_ID="Gentoo"
        elif [ -f /etc/lfs-version ]; then
            _distro_var_DISTRIB_ID="LFS"
        elif [ -r /etc/pclinuxos-release ]; then
            _distro_var_DISTRIB_ID="PCLinuxOS"
        elif [ -f /etc/mandriva-release ] || [ -f /etc/mandrake-release ]; then
            _distro_var_DISTRIB_ID="Mandriva"
        elif [ -f /etc/redhat-release ]; then
            _distro_var_DISTRIB_ID="RedHat"
        elif [ -f /etc/fedora-release ]; then
            _distro_var_DISTRIB_ID="Fedora"
        elif [ -r /etc/vector-version ]; then
            _distro_var_DISTRIB_ID="VectorLinux"
        elif [ -r /etc/slackware-version ]; then
            _distro_var_DISTRIB_ID="$(cat /etc/slackware-version)"
        elif [ -f /etc/release ]; then
            _distro_var_DISTRIB_ID="Solaris"
        elif [ -r /etc/SuSE-release ]; then
            _distro_var_DISTRIB_ID="$(grep -i suse /etc/SuSE-release)"
        elif [ -f /etc/yellowdog-release ]; then
            _distro_var_DISTRIB_ID="YellowDog Linux"
        elif [ -f /etc/zenwalk-version  ]; then
            _distro_var_DISTRIB_ID="Zenwalk"
        fi
        printf "%s\\n" "$_distro_var_DISTRIB_ID" | tr 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' 'abcdefghijklmnopqrstuvwxyz'
    else
        printf "%s\\n" "$DISTRIB_ID" | tr 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' 'abcdefghijklmnopqrstuvwxyz'
    fi
}

_cmd()
{   #print current command, exits on fail
    [ -z "$1" ] && return 1

    printf "%s " "    $ $@"
    printf "\\n"
    eval "$@"

    _cmd_var_status=$?
    [ X"$_cmd_var_status" != X"0" ] && exit $_cmd_var_status || return 0
}

_addcron()
{   #adds cron job, returns 1 on error
    [ -z "$1" ] && return 1
    ( crontab -l; printf "%s\\n" "$1" ) | crontab -
}

_cmdsudo()
{   #print && execute a command, exits if command fails
    [ -z "$1" ] && return 1
    _cmdsudo_var_serr=$$

    printf "%s " "    $ $@"
    printf "\\n"
    printf "%s" "$sudopwd" | $sudocmd eval "$@" > /tmp/"$_cmdsudo_var_serr".out 2>&1

    _cmdsudo_var_status=$?
    [ X"$_cmdsudo_var_status" != X"0" ] && { cat /tmp/"$_cmdsudo_var_serr".out; \
        rm -rf /tmp/"$_cmdsudo_var_serr".out; exit $_cmdsudo_var_status; } \
        || { rm -rf /tmp/"$_cmdsudo_var_serr".out; return $_cmdsudo_var_status; }
}

_arch()
{   #check for system arch, returns [64|32]
    [ -z "$MACHTYPE" ] && _arch_var_arch=$(uname -m) || _arch_var_arch=$(printf "%s" "$MACHTYPE" | cut -d- -f1)

    case $_arch_var_arch in
        x86_64)
            _arch_var_arch=64;
            ;;
        i686)
            _arch_var_arch=32;
            ;;
        *)
            return 1
            ;;
    esac

    printf "%s" "$_arch_var_arch"
}

_animcui()
{
    [ -z "$1" ] && { printf "%5s\n" ""; return 1; }
    printf "%s" "$1" | grep -v "[^0-9]" >/dev/null || { printf "%5s\n" ""; return 1; }
    _animcui_var_pid="$1"
    _animcui_var_animation_state=1

    if [ ! "$(ps -p $_animcui_var_pid -o comm=)" ]; then
        printf "%5s\n" ""
        return 1
    fi

    printf "%s" "      "

    while [ "$(ps -p $_animcui_var_pid -o comm=)" ]; do
        printf "%b" "\b\b\b\b\b"
        case $_animcui_var_animation_state in
            1)
                printf "%s" '\o@o\'
                _animcui_var_animation_state=2
                ;;
            2)
                printf "%s" '|o@o|'
                _animcui_var_animation_state=3
                ;;
            3)
                printf "%s" '/o@o/'
                _animcui_var_animation_state=4
                ;;
            4)
                printf "%s" '|o@o|'
                _animcui_var_animation_state=1
                ;;
        esac
        sleep 1
    done
    printf "%b" "\b\b\b\b\b" && printf "%5s\n" ""
}

_getroot()
{   #get sudo's password, define $sudopasswd and $sudocmd
    _getroot_var_tmp_path="/tmp"

    if [ ! X"$LOGNAME" = X"root" ]; then
        printf "%s\\n" "Detecting user $LOGNAME (non-root) ..."
        printf "%s\\n" "Checking if sudo is available ..."
        _getroot_var_sudotest=$(type sudo >/dev/null 2>/dev/null; printf "%s\\n" "$?")

        if [ X"$_getroot_var_sudotest" = X"0" ]; then
            sudo -K
            if [ -e "$_getroot_var_tmp_path/sudo.test" ]; then
                rm -f "$_getroot_var_tmp_path/sudo.test"
            fi
            while [ -z "$sudopwd" ]; do
                printf "%s" "   - enter sudo-password: "
                stty -echo
                read sudopwd
                stty echo

                # password check
                printf "%s" "$sudopwd" | sudo -S touch "$_getroot_var_tmp_path/sudo.test" > "$_getroot_var_tmp_path/sudo.output" 2>&1
                _getroot_var_insudoers=$(grep -i "sudoers" "$_getroot_var_tmp_path/sudo.output")
                if [ -n "$_getroot_var_insudoers" ]; then
                    printf "%s" "$sudopwd" | sudo -S rm "$_getroot_var_tmp_path/sudo.output" > /dev/null 2>&1
                    exit
                fi 
                if [ ! -e "$_getroot_var_tmp_path/sudo.test" ]; then
                    sudopwd=""
                fi
            done

            sudocmd="/usr/bin/sudo -S"

            printf "%s" "$sudopwd" | $sudocmd rm -f "$_getroot_var_tmp_path/sudo.test" > /dev/null 2>&1
            printf "\\n"
        else
            printf "%s\\n" "You're not root and sudo isn't available. Please run this script as root!"
            exit
        fi
    fi
}

_cleanup()
{
    stty echo
    printf "\\n"
    printf "%b\\n" "\033[1m---------------\033[7m Cleanup \033[0m\033[1m---------------\033[0m"
    printf "%s\\n" "[+] recovering old conf ..."
    for FILE in $HOME/*.old; do
        [ ! -e "$FILE" ] && continue
        mv "$FILE" ${FILE%.old}
    done

    printf "%s\\n" "[+] recovering scripts ..."
    for FILE in /etc/bash_completion.d/*.old; do
        [ ! -e "$FILE" ] && continue
        mv "$FILE" ${FILE%.old}
    done

    for FILE in /usr/local/bin/*.old; do
        [ ! -e "$FILE" ] && continue
        mv "$FILE" ${FILE%.old}
    done

    _cmd rm -rf dotfiles learn

    [ -z "$1" ] && exit
}

_waitfor()
{
    [ -z "$1" ] && return 1

    printf "%s " "    $ $@ ..."
    eval "$@" > /dev/null 2>/dev/null &
    sleep 1s

    _handscui $(pidof $1)
}

_waitforsudo()
{
    [ -z "$1" ] && return 1

    printf "%s " "    $ sudo $@ ..."
    printf "%s" "$sudopwd" | $sudocmd "$@" > /dev/null 2>&1 &
    sleep 1s

    if [ X"$1" = X"DEBIAN_FRONTEND=noninteractive" ]; then
        _handscui $(pidof $2)
    else
        _handscui $(pidof $1)
    fi
}

_smv()
{
    if [ "$(basename $1)" = "." ] || [ "$(basename $1)" = ".." ]; then
        return
    fi
    owner=$(stat -c %U "$2")

    if [ X"$owner" != X"$LOGNAME" ]; then
        [ -e "$2"/$(basename "$1") ] && printf "%s" "$sudopwd" | $sudocmd mv "$2"/$(basename "$1") "$2"/$(basename "$1").old > /dev/null 2>&1
        printf "%s" "$sudopwd" | $sudocmd mv "$1" "$2"  > /dev/null 2>&1
    else
        [ -e "$2"/$(basename "$1") ] && mv "$2"/$(basename "$1") "$2"/$(basename "$1").old
        mv "$1" "$2"
    fi
}

_strreplace()
{
    [ -z "$1" ] && return 1
    [ -z "$2" ] && return 1
    [ -z "$3" ] && return 1
    _strreplace_var_replace=$(printf "%s\\n" "$1" | sed -e "s/${2}/${3}/g")
    printf "%s" "${_strreplace_var_replace}"
}

_getuuid()
{
    [ -z "$1" ] && return 1
    udevadm info -q all -n "$1" | grep -i uuid | egrep "^S:" | cut -f3 -d'/'
}

_getfs()
{
    [ -z "$1" ] && return 1
    udevadm info -q all -n "$1" | grep -i ID_FS_TYPE | cut -f2 -d'='
}

_existaptproxy()
{   #test if an apt proxy exist on the local network, return 0 on sucess, 1 otherwise
    avahi-browse -a  -t | grep apt-cacher-ng >/dev/null && return 0
    return 1
}

_setrepos()
{
    if [ "$mode" = local ]; then
        for repository in /etc/apt/sources.list.d/*.list; do
            if [ -f "${repository}" ]; then
                non_standard_repositories="true"
                _cmdsudo mv "${repository}" "${repository}".s
            fi
        done

        if [ -n "$non_standard_repositories" ]; then
            printf "%s\\n" "[+] disabling temporaly non standard repos ..."
        fi
    fi

    printf "%s\\n" "[+] adding repos ..."

    if [ -f /usr/bin/lsb_release ]; then
        DISTRO=$(lsb_release -si)
        RELEASE=$(lsb_release -s -c)
    else
        if [ -d /etc/dpkg ]; then
            DISTRO=$(cat /etc/dpkg/origins/default | grep -i vendor | head -1 | cut -d' ' -f2)
            RELEASE=$(cat /etc/apt/sources.list | grep '^deb .*' | head -1 | cut -d' ' -f 3)
        fi
    fi

    case $DISTRO in
        Ubuntu)
            printf "%s\\n" "deb http://archive.ubuntu.com/ubuntu/ $RELEASE multiverse" > multiverse.list
            _cmdsudo mv multiverse.list /etc/apt/sources.list.d/

            [ -z "${BASH_ARGV[0]}" ] && return 1

            printf "%s\\n" "deb http://ppa.launchpad.net/chilicuil/sucklesstools/ubuntu $RELEASE main" > chilicuil-sucklesstools.list
            _cmdsudo mv chilicuil-sucklesstools.list /etc/apt/sources.list.d/

            printf "%s\\n" "deb http://dl.google.com/linux/talkplugin/deb/ stable main" > google-talkplugin.list
            _cmdsudo mv google-talkplugin.list /etc/apt/sources.list.d/

            printf "%s\\n" "deb http://download.videolan.org/pub/debian/stable/ /" > libdvdcss.list
            _cmdsudo mv libdvdcss.list /etc/apt/sources.list.d/

            _waitforsudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8AC54C683AC7B5E8
            _waitforsudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A040830F7FAC5991
            _waitforsudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6BCA5E4DB84288D9
            ;;
    esac
}

_homedetected()
{
    [ -z "$1" ] && return 1
    dirs=("$1"/*/)
    for dir in "${dirs[@]}"; do
        [ -d "$dir"/.local ] && return 0
    done
    return 1
}

_sethome()
{
    #TODO 17-09-2013 02:54 >> mount only partitions with id 83 (linux)
    if mountpoint -q /home; then
        local sd=$(cat /etc/mtab | grep '^/' | grep '/home' | sed 's/[ ].*//')
        local uuid=$(_getuuid "$sd")
        local fs=$(_getfs "$sd")

        if ! grep -qs "^UUID=$uuid" /etc/fstab; then
            printf "%s\\n" "[+] /home esta montado pero no esta en /etc/fstab, agregando ..."
            printf "%s\\n" "UUID=$uuid /home $fs errors=remount-ro 0 1" | _cmdsudo tee -a /etc/fstab
        fi
    else
        local total_partitions=$(awk '{print $4}' /proc/partitions | sed -e '/name/d' -e '/^$/d' -e '/[1-9]/!d')

        if [ -n "$total_partitions" ]; then
            local swap_partitions=$(cat /proc/swaps | grep partition | cut -f1 -d' ' | cut -f3 -d'/')
            local mounted_partitions=$(cat /etc/mtab | grep '^/' | sed 's/[ ].*//' | cut -f3 -d'/')

            if [ -n "$swap_partitions" ]; then
                for swap_partition in $swap_partitions
                do
                    total_partitions=$(_strreplace "$total_partitions" $swap_partition)
                done
            fi

            if [ -n "$mounted_partitions" ]; then
                for mounted_partition in $mounted_partitions
                do
                    total_partitions=$(_strreplace "$total_partitions" $mounted_partition)
                done
            fi

            if [ -n "$total_partitions" ]; then
                for partition in $total_partitions
                do
                    mkdir /tmp/$partition
                    _cmdsudo mount /dev/$partition /tmp/$partition
                    if _homedetected /tmp/$partition; then
                        printf "%s\\n" "[+] Se encontro una partición /home en: $partition"
                        printf "%s\\n" "[+] Reemplazando directorio /home con particion y agregando a /etc/fstab ..."

                        _cmdsudo umount /tmp/$partition && rm -rf /tmp/$partition
                        cd /; _cmdsudo rm -rf /home
                        _cmdsudo mount /dev/$partition /home
                        _cmdsudo chown -R $(whoami):$(whoami) /home/$(whoami)
                        cd $HOME

                        local sd=$(cat /etc/mtab | grep '^/' | grep '/home' | sed 's/[ ].*//')
                        local uuid=$(_getuuid "$sd")
                        local fs=$(_getfs "$sd")

                        if ! grep -qs "^UUID=$uuid" /etc/fstab; then
                            printf "%s" "UUID=$uuid /home $fs errors=remount-ro 0 1" | _cmdsudo tee -a /etc/fstab
                        fi

                        break
                    fi

                    if [ -d /tmp/$partition ]; then
                        _cmdsudo umount /tmp/$partition
                        rm -rf /tmp/$partition
                    fi
                done
            fi
        fi
        [ ! -d /home/$(whoami) ] && _cmdsudo mkdir -p /home/$(whoami)
    fi
}

_supported()
{   #retun 0 on a supported system, 1 otherwise
    supported="[Debian|Ubuntu]"
    distro=$(_distro)
    case $distro in
        ubuntu|debian)
            return 0
            ;;
    esac
    return 1
}

_installfirefoxnightly()
{
    arch=$(_arch)
    if [ X"$arch" = X"32" ]; then
        nightly=$(curl http://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-trunk/ 2>&1 | egrep -o 'href="([^"#]+)"' | cut -d'"' -f2 |  grep "linux-i686.tar.bz2")
    else
        nightly=$(curl http://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-trunk/ 2>&1 | egrep -o 'href="([^"#]+)"' | cut -d'"' -f2 | grep "linux-x86_64.tar.bz2")
    fi
        _waitfor wget -c http://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-trunk/"$nightly"
        _waitfor tar jxf firefox*bz2
        _cmd rm -rf firefox-* index.html
        _cmd mv firefox $HOME/.bin/firefox$arch
}

#############################################################################################################
# Ubuntu deployment functions ###############################################################################
#############################################################################################################

_remotesetup()
{
    printf "%b\\n" "\033[1m------------------\033[7m Fixing dependencies \033[0m\033[1m---------------------\033[0m"
    _setrepos

    printf "%s\\n" "[+] fixing locales ..."
    _waitforsudo locale-gen en_US en_US.UTF-8
    _waitforsudo dpkg-reconfigure -f noninteractive locales

    printf "%s\\n" "[+] installing deps ..."
    _waitforsudo apt-get update
    _waitforsudo apt-get install --no-install-recommends -y $apps_remote

    printf "%s\\n" "[+] purging non essential apps ..."
    _waitforsudo DEBIAN_FRONTEND=noninteractive apt-get purge -y $apps_purge

    [ ! -f /usr/bin/git ] && _die "Dependency step failed"

    #####################################################################################################

    printf "%b\\n" "\033[1m-------------------\033[7m Downloading files \033[0m\033[1m-----------------------\033[0m"
    printf "%s\\n" "[+] downloading reps ..."
    _waitfor git clone --dept=1 "$dotfiles.git"
    _waitfor git clone --dept=1 "$utils.git"

    [ ! -d "./dotfiles" ] && _die "Download step failed"

    #####################################################################################################

    printf "%b\\n" "\033[1m--------------------\033[7m Installing files \033[0m\033[1m----------------------\033[0m"

    if [ ! -f $HOME/.not_override ]; then
        printf "%s\\n" "[+] installing dotfiles (old dotfiles will get an .old suffix) ..."
        for FILE in dotfiles/.*; do
            [ ! -e "$FILE" ] && break
            _smv "$FILE" "$HOME"
        done

        #special case, ssh, don't want to block myself
        [ -d "$HOME/.ssh.old" ] && mv $HOME/.ssh.old/* $HOME/.ssh
    fi

    if [ ! -f /usr/local/bin/not_override ]; then
        printf "%s\\n" "[+] installing utils (old scripts will get an .old suffix) ..."
        for FILE in learn/autocp/completions/*; do
            [ ! -e "$FILE" ] && break
            _smv "$FILE" /usr/share/bash-completion/completions/
        done

        for FILE in learn/python/*; do
            [ ! -f "$FILE" ] && continue
            _smv "$FILE" /usr/local/bin/
        done

        for FILE in learn/sh/is/*; do
            [ ! -f "$FILE" ] && continue
            _smv "$FILE" /usr/local/bin/
        done

        for FILE in learn/sh/tools/*; do
            [ ! -f "$FILE" ] && continue
            _smv "$FILE" /usr/local/bin/
        done
    fi

    rm -rf dotfiles learn

    #####################################################################################################

    printf "%b\\n" "\033[1m-----------------\033[7m Configuring main apps \033[0m\033[1m---------------------\033[0m"
    printf "%s\\n" "[+] configuring vim (3 min aprox) ..."
    _waitfor git clone --dept=1 https://github.com/chilicuil/vundle.git ~/.vim/bundle/vundle
    #_waitfor git clone --dept=1 https://github.com/gmarik/vundle ~/.vim/bundle/vundle #till shallow clone doesn't get implemented, my own version is faster
    _waitfor vim -es -u ~/.vimrc -c "BundleInstall" -c qa

    printf "%s\\n" "[+] configuring shell (1 min aprox) ..."
    _waitfor git clone --dept=1 https://github.com/chilicuil/shundle.git ~/.shundle/bundle/shundle
    . ~/.bashrc
    _waitfor shundle install

    printf "%s\\n" "[+] configuring cd ..."
    mkdir $HOME/.wcd; /usr/bin/wcd.exec -GN -j -xf $HOME/.ban.wcd -S $HOME > /dev/null 2>&1 && mv $HOME/.treedata.wcd $HOME/.wcd/

    #####################################################################################################

    printf "%b\\n" "\033[1m-----------------------------\033[7m DONE \033[0m\033[1m--------------------------\033[0m"
    printf "\\n"
    printf "%s\\n" "Reload the configuration to start having fun, n@n/"
    printf "%s\\n" "    $ source ~/.bashrc"
}

_localsetup()
{
    printf "%b\\n" "\033[1m------------------\033[7m Fixing dependencies \033[0m\033[1m---------------------\033[0m"
    _setrepos
    _sethome

    printf "%s\\n" "[+] fixing locales ..."
    _waitforsudo locale-gen en_US en_US.UTF-8
    _waitforsudo dpkg-reconfigure -f noninteractive locales

    printf "%s\\n" "[+] setting up an apt-get proxy ..."
    _waitforsudo apt-get update
    _waitforsudo apt-get install --no-install-recommends -y avahi-utils

    if _existaptproxy; then
        printf "%s\\n" "[+] exists an apt-get proxy in the network, using it ..."
        _waitforsudo apt-get install --no-install-recommends -y squid-deb-proxy-client
    else
        printf "%s\\n" "[+] no apt-get proxy found, installing one locally ..."
        _waitforsudo apt-get install --no-install-recommends -y squid-deb-proxy-client apt-cacher-ng
        _waitforsudo wget http://javier.io/mirror/apt-cacher-ng.service -O /etc/avahi/services/apt-cacher-ng.service
        if [ -d "$HOME"/misc/ubuntu/proxy/apt-cacher-ng/ ]; then
            printf "%s\\n" "[+] exporting files ..."
            _cmdsudo rm -rf /var/cache/apt-cacher-ng
            _cmdsudo ln -s $HOME/misc/ubuntu/proxy/apt-cacher-ng/ /var/cache/apt-cacher-ng
        fi
    fi

    printf "%s\\n" "[+] installing apps ..."
    _waitforsudo apt-get update
    _waitforsudo DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y $apps_local

    [ ! -f /usr/bin/i3 ] && _die "Dependency step failed"

    if [ ! -d "$HOME"/.bin/firefox$(_arch) ]; then
        mkdir -p "$HOME"/.bin
        _installfirefoxnightly
    fi

    [ ! -f /usr/local/bin/firefox ] && _cmdsudo ln -s $HOME/.bin/firefox$(_arch)/firefox /usr/local/bin/

    if [ ! -f /usr/local/bin/magnifier ]; then
        if [ "$(_arch)" -eq 64 ]; then
            _cmdsudo wget http://files.javier.io/repository/s/magnifier64.bin -O /usr/local/bin/magnifier
            _cmdsudo chmod +x /usr/local/bin/magnifier
        fi
    fi

    printf "%s\\n" "[+] purging non essential apps ..."
    _waitforsudo DEBIAN_FRONTEND=noninteractive apt-get purge -y $apps_purge


    #####################################################################################################

    printf "%b\\n" "\033[1m---------------\033[7m Downloading theme files \033[0m\033[1m--------------------\033[0m"
    printf "%s\\n" "[+] downloading confs, themes and so on ..."
    _waitfor wget http://files.javier.io/repository/s/iconfaa.bin
    _waitfor wget http://files.javier.io/repository/s/iconfab.bin
    _waitfor wget http://files.javier.io/repository/s/iconfac.bin
    _waitfor wget http://files.javier.io/repository/s/iconfad.bin
    _waitfor wget http://files.javier.io/repository/s/iconfae.bin
    cat iconfa*.bin > iconf.tar.bz2

    _waitfor tar jxf iconf.tar.bz2; rm iconf.tar.bz2

    [ ! -d "./iconf" ] && _die "Download step failed"

    #####################################################################################################

    printf "%b\\n" "\033[1m--------------------\033[7m Configuring system \033[0m\033[1m-------------------\033[0m"
    printf "%s\\n" "[+] configuring swappiness ..."
    FSYSCTL="/etc/sysctl.conf"
    if grep vm.swappiness $FSYSCTL >/dev/null; then
        _cmdsudo cp $FSYSCTL $FSYSCTL.old
        _cmdsudo sed -i -e "/vm.swappiness/ s:=.*:=10:" $FSYSCTL
    else
        _cmdsudo sed -i -e "\$avm.swappiness=10" $FSYSCTL
    fi

    printf "%s\\n" "[+] configuring network ..."
    printf "%s\\n" "auto lo" > interfaces
    printf "%s\\n" "iface lo inet loopback" >> interfaces
    _smv interfaces /etc/network/
    _cmdsudo usermod -a -G netdev $(whoami)

    printf "%s\\n" "[+] configuring audio ..."
    _cmdsudo usermod -a -G audio $(whoami)
    _cmdsudo sed -i -e "\$asnd-mixer-oss" /etc/modules
    _cmdsudo mv iconf/mpd/mpd.conf /etc
    _cmdsudo sed -i -e "/music_directory/ s:chilicuil:$(whoami):" /etc/mpd.conf

    printf "%s\\n" "[+] configuring groups ..."
    _cmdsudo usermod -a -G dialout $(whoami)
    _cmdsudo usermod -a -G sudo $(whoami)

    printf "%s\\n" "[+] configuring cron ..."
    if [ -f /usr/local/bin/watch-battery ]; then
        printf "%s\\n" "    $ echo \"*/1 * * * * /usr/local/bin/watch-battery\" | crontab -"
        _addcron "*/1 * * * * /usr/local/bin/watch-battery";
    fi

    if [ -f /usr/local/bin/wcd ] && [ -f /usr/bin/wcd.exec ] && [ -f /usr/local/bin/update-cd ]; then
        printf "%s\\n" "    $ echo \"* 23 * * *  /usr/local/bin/update-cd\" | crontab -"
        _addcron "* 23 * * *  /usr/local/bin/update-cd";
    fi

    if [ -f "$HOME"/misc/conf/ubuntu/etc/lenovo-edge-netbook/crontabs.tar.gz ]; then
        _waitforsudo tar zxf "$HOME"/misc/conf/ubuntu/etc/lenovo-edge-netbook/crontabs.tar.gz -C /
    fi

    printf "%s\\n" "[+] configuring login manager ..."
    _cmdsudo mv iconf/slim/slim.conf /etc/
    _cmdsudo mv iconf/slim/custom /usr/share/slim/themes/
    _cmdsudo sed -i -e "/default_user/ s:chilicuil:$(whoami):" /etc/slim.conf
    [ -f /usr/share/xsessions/i3.desktop ] && _cmdsudo sed -i -e "/Exec/ s:=.*:=/etc/X11/Xsession:" /usr/share/xsessions/i3.desktop

    printf "%s\\n" "[+] configuring gpg/ssh agents ..."
    [ -f /etc/X11/Xsession.d/90gpg-agent ] && _cmdsudo sed -i -e "/STARTUP/ s:=.*:=\"\$GPGAGENT --enable-ssh-support --daemon --sh --write-env-file=\$PID_FILE \$STARTUP\":" /etc/X11/Xsession.d/90gpg-agent
    [ -f /etc/X11/Xsession.options ] && _cmdsudo sed -i -e "s:use-ssh-agent:#use-ssh-agent:g" /etc/X11/Xsession.options
    _cmd mkdir -p "$HOME"/.gnupg
    [ ! -f "$HOME"/.gnupg/gpg.conf ] && printf "%s\\n" "use-agent" > "$HOME"/.gnupg/gpg.conf

    #allow use of shutdown/reboot through dbus-send
    _waitforsudo wget http://javier.io/mirror/org.freedesktop.consolekit.pkla -O /etc/polkit-1/localauthority/50-local.d/org.freedesktop.consolekit.pkla

    printf "%s\\n" "[+] configuring file manager ..."
    #https://bugs.launchpad.net/ubuntu/+source/policykit-1/+bug/600575
    _waitforsudo wget http://javier.io/mirror/55-storage.pkla -O /etc/polkit-1/localauthority/50-local.d/55-storage.pkla
    _cmdsudo usermod -a -G plugdev $(whoami)

    printf "%s\\n" "[+] configuring browser ..."
    _cmdsudo mv iconf/firefox/libflashplayer$(_arch).so /usr/lib/mozilla/plugins/libflashplayer.so
    if [ ! -f $HOME/.not_override ]; then
        _waitfor tar jxf iconf/firefox/mozilla.tar.bz2 -C iconf/firefox
        mozilla_profile=$(strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 8 | tr -d '\n'; printf "\\n")
        _cmd mv iconf/firefox/.mozilla/firefox/*.default iconf/firefox/.mozilla/firefox/$mozilla_profile.default
        mozilla_files=$(grep -rl h5xyzl6e iconf/firefox/.mozilla) && { printf "%s\\n" "$mozilla_files" | xargs sed -i -e "s/h5xyzl6e/$mozilla_profile/g"; printf "%s\\n" "$mozilla_files" | xargs sed -i -e "s/admin/$(whoami)/g"; }
        _smv iconf/firefox/.mozilla "$HOME"
    fi

    printf "%s\\n" "[+] configuring gtk, icon, cursor themes ..."
    _cmd mkdir -p $HOME/.icons
    _cmd mkdir -p $HOME/.themes
    _cmd mkdir -p $HOME/.fonts

    _cmd mv iconf/icons/* $HOME/.icons
    _cmd mv iconf/gtk/themes/* $HOME/.themes
    _cmd mv iconf/fonts/* $HOME/.fonts
    _waitforsudo fc-cache -f -v
    _cmdsudo update-alternatives --set x-terminal-emulator /usr/bin/urxvt

    [ ! -d $HOME/.data ] && _cmd mv iconf/data $HOME/.data

    printf "%s\\n" "[+] applying rock star dotfiles ..."
    _waitfor wget --quiet javier.io/s
    _waitforsudo bash ./s
    _cmd rm s
    _cmd touch $HOME/.not_override

    if [ -d "$HOME"/.gvfs ]; then
        fusermount -u "$HOME"/.gvfs
    fi
    _cmdsudo chown -R $(whoami):$(whoami) $HOME

    #stackoverflow.com/q/8887972
    find $HOME -maxdepth 3 \( -type f -iname "*gtkrc*" \
         -o -type f -iname "*Trolltech.conf*"      \
         -o -type f -iname "*Xdefaults*"        \
         -o -type f -iname "*bazaar.conf*"      \
         -o -type f -iname "*conkyrc*" \) -exec sed -i "s/chilicuil/$(whoami)/g" '{}' \;

    if [ -d /proc/acpi/battery/BAT0 ]; then
        _cmd sed -i "s/BAT1/BAT0/g" ~/.conkyrc
    fi

    if [ -n "$non_standard_repositories" ]; then
        printf "%s\\n" "[+] renabling non standard repos ..."

        for repository in /etc/apt/sources.list.d/*.list.s; do
            if [ -f "${repository}" ]; then
                _cmdsudo mv "${repository}" "${repository%.s}"
            fi
        done
    fi

    printf "%s\\n" "[+] cleaning up ..."
    _cmdsudo rm -rf iconf*

    #####################################################################################################

    printf "%b\\n" "\033[1m------------------\033[7m DONE \033[0m\033[1m---------------\033[0m"
    printf "\\n"
    printf "%s\\n" "Restart your computer to start having fun, n@n/"
}

_ubuntudev()
{
    printf "%b\\n" "\033[1m----\033[7m Preparing the system for Ubuntu dev \033[0m\033[1m------\033[0m"

    _waitforsudo apt-get update
    _waitforsudo apt-get install --no-install-recommends -y $apps_ubuntudev
}

#############################################################################################################
# Main ######################################################################################################
#############################################################################################################

_header
if _supported; then
    _getroot
    if [ -z "$1" ]; then
        _remotesetup
    else
        _localsetup
    fi
else
    printf "%s\\n" "FAILED: Non supported distribution system detected, run this script on $supported systems only"
fi

#_cleanup 1
