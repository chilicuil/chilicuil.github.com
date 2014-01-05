#!/usr/bin/env sh

trap _cleanup INT QUIT #trap ctrl-c

dotfiles="https://github.com/chilicuil/dotfiles"
utils="https://github.com/chilicuil/learn"
updates="http://javier.io/s"
liner="$ sh <(wget -qO- javier.io/s)"

#default apps
apps_remote="git-core vim-nox byobu wcd htop rsync curl bzip2 gzip html2text
ncurses-bin command-not-found libpam-captcha"
apps_local="i3-wm alsa-utils alsa-base mpd ncmpcpp mpc slim
rxvt-unicode-256color xorg git-core autocutsel acpi suckless-tools feh sxiv
notify-osd hibernate html2text htop irssi mplayer2 mutt-patched dzen2 pcmanfm
pm-utils rlpr unetbootin wodim xclip zsync gnupg-agent lxappearance
exuberant-ctags i3lock conky-cli zathura gtk2-engines-pixbuf openssh-server
wicd-curses geoclue-ubuntu-geoip redshift zram-config lame unzip udisks gvfs
gvfs-common gvfs-daemons gvfs-fuse gvfs-libs policykit-1 google-talkplugin
libmad0 libdvdcss2 libdvdread4 curl dkms xdotool dbus-x11 gxmessage wcd"
apps_ubuntudev="apt-file cvs subversion bzr bzr-builddeb pbuilder tidy zsync"
apps_purge="xinetd sasl2-bin sendmail sendmail-base sendmail-bin sensible-mda
rmail bsd-mailx apache2.2-common apache2 nano"

if [ -z "$1" ]; then
    mode="remote"; rx="\b>"
else
    case "$1" in
        l|local)
            mode="local";  lx="\b>";;
        b|boot)
            mode="boot";   bx="\b>";;
        *)
            mode="remote"; rx="\b>";;
    esac
fi

################################################################################
# General functions ############################################################
################################################################################

_arch()
{   #check for system arch, returns [64|32]
    if [ -z "$MACHTYPE" ]; then
        _arch_var_arch=$(uname -m)
    else
        _arch_var_arch=$(printf "%s" "$MACHTYPE" | cut -d- -f1)
    fi

    case "$_arch_var_arch" in
        x86_64)
            _arch_var_arch="64";
            ;;
        i686)
            _arch_var_arch="32";
            ;;
        *)
            return 1
            ;;
    esac

    printf "%s" "$_arch_var_arch"
}

_addcron()
{   #adds cron job, returns 1 on error
    [ -z "$1" ] && return 1
    ( crontab -l 2>/dev/null; printf "%s\\n" "$1" ) | crontab -
}

_animcui()
{   #wait animation
    [ -z "$1" ] && { printf "%5s\n" ""; return 1; }

    if ! printf "%s" "$1" | grep -v "[^0-9]" >/dev/null; then
        printf "%5s\n" ""
        return 1; 
    fi

    _animcui_var_pid="$1"
    _animcui_var_animation_state="1"

    if [ ! "$(ps -p "$_animcui_var_pid" -o comm=)" ]; then
        printf "%5s\n" ""
        return 1
    fi

    printf "%5s" ""

    while [ "$(ps -p "$_animcui_var_pid" -o comm=)" ]; do
        printf "%b" "\b\b\b\b\b"
        case "$_animcui_var_animation_state" in
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
{   #get sudo's password, define $sudopwd and $sudocmd
    if [ ! X"$LOGNAME" = X"root" ]; then
        printf "%s\\n" "Detecting user $LOGNAME (non-root) ..."
        printf "%s\\n" "Checking if sudo is available ..."

        if command -v "sudo" >/dev/null 2>&1; then
            sudo -K

            if [ -n "$sudopwd" ]; then
                # password check
                _getroot_var_test=$(printf "%s\\n" "$sudopwd" | sudo -S ls 2>&1)
                _getroot_var_status="$?"
                _getroot_var_not_allowed=$(printf "%s" "$_getroot_var_test" | \
                                         grep -i "sudoers")

                if [ -n "$_getroot_var_not_allowed" ]; then
                    printf "%s %s\\n" "You're not allowed to use sudo," \
                    "get in contact with your local administrator"
                    exit
                fi 

                if [ X"$_getroot_var_status" != X"0" ]; then
                    sudopwd=""
                    printf "%s\\n" "Incorrect preseed password"
                    exit
                else
                    sudocmd="sudo -S"
                fi 
                printf "%s\\n" "    - all set ..."
                return
            fi

            i=0 ; while [ "$i" -lt 3 ]; do
                i=$(expr $i + 1);
                printf "%s" "   - enter sudo password: "
                stty -echo
                read sudopwd
                stty echo

                # password check
                _getroot_var_test=$(printf "%s\\n" "$sudopwd" | sudo -S ls 2>&1)
                _getroot_var_status="$?"
                _getroot_var_not_allowed=$(printf "%s" "$_getroot_var_test" | \
                                         grep -i "sudoers")

                if [ -n "$_getroot_var_not_allowed" ]; then
                    printf "\\n%s %s\\n" "You're not allowed to use sudo," \
                    "get in contact with your local administrator"
                    exit
                fi 

                printf "\\n"
                if [ X"$_getroot_var_status" != X"0" ]; then
                    sudopwd=""
                else
                    sudocmd="sudo -S"
                    break
                fi 
            done

            if [ -z "$sudopwd" ]; then
                printf "%s\\n" "Failed authentication"
                exit
            fi
        else
            printf "%s %s\\n" "You're not root and sudo isn't available." \
            "Please run this script as root!"
            exit
        fi
    fi
}

_printfl()
{   #print lines
    _printfl_var_max_len="80"
    if [ -n "$1" ]; then
        _printfl_var_word_len=$(expr ${#1} + 2)
        _printfl_var_sub=$(expr $_printfl_var_max_len - $_printfl_var_word_len)
        _printfl_var_half=$(expr $_printfl_var_sub / 2)
        _printfl_var_other_half=$(expr $_printfl_var_sub - $_printfl_var_half)
        printf "%b" "\033[1m" #white strong
        printf '%*s' "$_printfl_var_half" '' | tr ' ' -
        printf "%b" "\033[7m" #white background
        printf " %s " "$1"
        printf "%b" "\033[0m\033[1m" #white strong
        printf '%*s' "$_printfl_var_other_half" '' | tr ' ' -
        printf "%b" "\033[0m" #back to normal
        printf "\\n"
    else
        printf "%b" "\033[1m" #white strong
        printf '%*s' "$_printfl_var_max_len" '' | tr ' ' -
        printf "%b" "\033[0m" #back to normal
        printf "\\n"
    fi
}

_printfs()
{   #print step
    [ -z "$1" ] && return 1
    printf "%s\\n" "[+] $*"
}

_printfc()
{   #print command
    [ -z "$1" ] && return 1
    printf "%s\\n" "    $ $*"
}

_unprintf()
{   #unprint sentence
    [ -z "$1" ] && return 1
    _unprintf_var_word_len=$(expr ${#1})
    _unprintf_var_i=0
    while [ "$_unprintf_var_i" -lt $(expr $_unprintf_var_word_len) ]; do
        _unprintf_var_i=$(expr $_unprintf_var_i + 1)
        printf "%b" "\b"
    done
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
                _distro_var_DISTRIB_ID="Ubuntu"
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
        printf "%s\\n" "$_distro_var_DISTRIB_ID" | \
            tr 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' 'abcdefghijklmnopqrstuvwxyz'
    else
        printf "%s\\n" "$DISTRIB_ID" | \
            tr 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' 'abcdefghijklmnopqrstuvwxyz'
    fi
}

_smv()
{   #move files, create backups before overriding 
    [ -z "$1" ] && return 1 || _smv_var_origin_basename="$(basename "$1")"
    [ -z "$2" ] && return 1

    if [ X"$_smv_var_origin_basename" = X"." ] || \
       [ X"$_smv_var_origin_basename" = X".." ]; then
        return 1
    fi

    if [ -e "$2"/"$_smv_var_origin_basename" ]; then
        if diff -qr "$1" "$2"/"$_smv_var_origin_basename" >/dev/null 2>&1; then
            return 0
        fi
    else
        if diff -qr "$1" "$2" >/dev/null 2>&1; then
            return 0
        fi
    fi

    _smv_var_owner=$(stat -c %U "$2")
    _smv_var_version=$(date +"%d-%m-%Y-[%H:%M]")

    _printfc "mv $1 $2"

    if [ X"$_smv_var_owner" != X"$LOGNAME" ]; then
        #if target has a file with the same name as origin
        if [ -e "$2"/"$_smv_var_origin_basename" ]; then
            printf "%s\\n" "$sudopwd" | \ $sudocmd mv "$2"/"$_smv_var_origin_basename" \
                "$2"/"$_smv_var_origin_basename".old."$_smv_var_version" \
                >/dev/null 2>&1
            printf "%s\\n" "$sudopwd" | \
                $sudocmd chown -R "$_smv_var_owner" \
                "$2"/"$_smv_var_origin_basename".old."$_smv_var_version" \
                >/dev/null 2>&1
        fi
        printf "%s\\n" "$sudopwd" | $sudocmd mv "$1" "$2" >/dev/null 2>&1
    else
        if [ -e "$2"/"$_smv_var_origin_basename" ]; then 
            mv "$2"/"$_smv_var_origin_basename" \
               "$2"/"$_smv_var_origin_basename".old."$_smv_var_version"
        fi
        mv "$1" "$2"
    fi
}

_hooks()
{
    [ -z "$1" ] && return 1
    case $1 in
        A|B|C)
            for _hooks_var_script in "$HOME"/.s/"$1"*; do
                break
            done

            if [ -f "$_hooks_var_script" ]; then
                _printfl "Executing $1 hooks"
            else
                return 1
            fi

            for _hooks_var_script in "$HOME"/.s/"$1"*; do
                if [ -f "$_hooks_var_script" ]; then
                    _printfs "$_hooks_var_script ..."
                    . "$_hooks_var_script"
                fi
            done
            ;;
    esac
}

_getvars()
{   #source $HOME/.s/config
    if [ -f "$HOME"/.s/config ]; then
        . "$HOME"/.s/config
    fi
}

_getuuid()
{   #get partition uuid, eg, _getuuid /dev/sda1
    [ -z "$1" ] && return 1
    udevadm info -q all -n "$1" | grep -i uuid | egrep "^S:" | cut -f3 -d'/'
}

_getfs()
{   #get partition fs, eg, _getfs /dev/sda1
    [ -z "$1" ] && return 1
    udevadm info -q all -n "$1" | grep -i ID_FS_TYPE | cut -f2 -d'='
}

_getlastversion()
{   #get last version of a bunch of .old files
    [ -z "$1" ] && return 1

    _getlastversion_var_files="$1".old.*
    _getlastversion_var_counter="0"

    for _getlastversion_var_file in $_getlastversion_var_files; do
        _getlastversion_var_counter=$(expr $_getlastversion_var_counter + 1)
    done

    if [ $_getlastversion_var_counter -eq 1 ]; then
        if [ -e "$_getlastversion_var_file" ]; then
            printf "%s" "$_getlastversion_var_file"
        fi
    else
        _getlastversion_var_newer="$_getlastversion_var_file"
        for _getlastversion_var_file in $_getlastversion_var_files; do
            if [ "$_getlastversion_var_file" -nt "$_getlastversion_var_newer" ]; then
                _getlastversion_var_newer="$_getlastversion_var_file"
            fi
        done
        if [ -e "$_getlastversion_var_newer" ]; then
            printf "%s" "$_getlastversion_var_newer"
        fi
    fi
}

_getrelease()
{   #print debian|ubuntu release version
    if command -v "lsb_release" 1>/dev/null 2>&1; then
        _getrelease_var_release=$(lsb_release -s -c)
    else
        if [ -f /etc/apt/sources.list ]; then
            _getrelease_var_release=$(cat /etc/apt/sources.list \
				    | grep '^deb .*'            \
                                    | head -1 | cut -d' ' -f 3)
        fi
    fi

    printf "%s" "$_getrelease_var_release"
}

_fetchfile()
{
    [ -z "$1" ] && return 1 || _fetchfile_var_url="$1"
    [ -z "$2" ] && _fetchfile_var_output="" || _fetchfile_var_output="$2"
    _fetchfile_var_max_retries="10"

    _fetchfile_var_i=0
    while [ $_fetchfile_var_i -lt $_fetchfile_var_max_retries ]; do
        _fetchfile_var_i=$(expr $_fetchfile_var_i + 1);

        if [ -z "$_fetchfile_var_output" ]; then
            _waitfor wget "$_fetchfile_var_url"
        else
            _waitfor wget "$_fetchfile_var_url" -O "$_fetchfile_var_output"
        fi

        if [ -n "$_fetchfile_var_output" ] && [ -f "$_fetchfile_var_output" ]; then
            break
        elif [ -z "$_fetchfile_var_output"]; then
            if [ -f "./$(basename "$_fetchfile_var_url")" ] || \
            [ -f index.html ]; then
                break
            fi
        else
            if [ $_fetchfile_var_i -eq $(expr $_fetchfile_var_max_retries - 1) ]; then
                printf "%s" "Impossible to retrive files"
                exit 1
            else
                _printfs "$_fetchfile_var_url seems down, retrying in $_fetchfile_var_i minute(s) ..."
                sleep $(expr $_fetchfile_var_i \* 60)
                printf "\\n"
            fi
        fi
    done
}

_fetchrepo()
{   #git clone doesn't support retry, this function fix that
    [ -z "$1" ] && return 1 || _fetchrepo_var_url="$1"
    [ -z "$2" ] || _fetchrepo_var_output="$2"
   _fetchrepo_var_max_retries="10"

    _fetchrepo_var_i=0
    while [ "$_fetchrepo_var_i" -lt $(expr $_fetchrepo_var_max_retries) ]; do
        _fetch_var_i=$(expr $_fetchrepo_var_i + 1);

        if [ -z "$_fetchrepo_var_output" ]; then
            _waitfor git clone --dept=1 "$_fetchrepo_var_url"
        else
            _waitfor git clone --dept=1 "$_fetchrepo_var_url" "$_fetchrepo_var_output"
        fi

        if [ -d "./$(basename "$_fetchrepo_var_url" ".git")" ] || \
           [ -d "$_fetchrepo_var_output" ]; then
            break
        else
            if [ $_fetchrepo_var_i -eq $(expr $_fetchrepo_var_max_retries - 1) ]; then
                printf "%s" "Impossible to retrive files"
                exit 1
            else
                _printfs "$_fetchrepo_var_url seems down, retrying in $_fetchrepo_var_i minute(s) ..."
                sleep $(expr $_fetchrepo_var_i \* 60)
                printf "\\n"
            fi
        fi
    done
}

_existaptproxy()
{   #look for apt proxies, return 0 on sucess, 1 otherwise
    avahi-browse -a  -t | grep apt-cacher-ng >/dev/null && return 0
    return 1
}

_die()
{   #print a stacktrace with a msg and exit
    if [ -n "$BASH" ]; then
        _die_var_frame=0
        while caller $_die_var_frame; do
            _die_var_frame=$(expr $_die_var_frame + 1);
        done
    fi

    printf "%s\\n" "$*"
    exit
}

_cmd()
{   #print and execute a command, exit on fail
    [ -z "$1" ] && return 1

    printf "%s \\n" "    $ $*"
    _cmd_var_output="$(eval $@ 2>&1)"
    _cmd_var_status="$?"

    if [ X"$_cmd_var_status" != X"0" ]; then
        printf "> %s:%s" "$*" "$_cmd_var_output"
        exit "$_cmd_var_status"
    else
        return "$_cmd_var_status"
    fi
}

_cmdsudo()
{   #print && execute a command, exit on fail
    [ -z "$1" ] && return 1

    printf "%s \\n" "    $ sudo $*"
    _cmdsudo_var_output=$(printf "%s\\n" "$sudopwd" | $sudocmd sh -c "eval $*" 2>&1)
    _cmdsudo_var_status="$?"

    if [ X"$_cmdsudo_var_status" != X"0" ]; then
        printf "> %s:%s\\n" "$*" "$_cmdsudo_var_output"
        exit "$_cmdsudo_var_status"
    else
        return "$_cmdsudo_var_status";
    fi
}

_waitfor()
{   #print, execute and wait for a command to finish
    [ -z "$1" ] && return 1

    printf "%s " "    $ $@ ..."
    eval "$@" >/dev/null 2>&1 &
    sleep 1s

    _animcui $(pidof "$1")
}

_waitforsudo()
{   #print, execute and wait for a command to finish
    [ -z "$1" ] && return 1

    printf "%s " "    $ sudo $@ ..."
    printf "%s\\n" "$sudopwd" | $sudocmd sh -c "eval $*" >/dev/null 2>&1 &
    sleep 1s

    if [ X"$1" = X"DEBIAN_FRONTEND=noninteractive" ]; then
        _animcui $(pidof "$2")
    else
        _animcui $(pidof "$1")
    fi
}

_homedetected()
{   #does a partition has /home files?, 0 yes, 1 no
    [ -z "$1" ] && return 1
    _homedetected_test=$(find "$1" -maxdepth 2 -type d -iname ".local" 2>/dev/null | grep local)
    [ -z "$_homedetected_test" ] && return 1 || return 0
}

_sethome()
{   #mount a partition as /home, update /etc/fstab
    #TODO 17-09-2013 02:54 >> only mount partitions with id=83 (linux)
    if mountpoint -q /home; then
        if [ -f /etc/mtab ]; then
            _sethome_var_hd=$(cat /etc/mtab | grep '^/' | grep '/home' | sed 's/[ ].*//')
        else
            _sethome_var_hd=$(mount | grep '^/' | grep '/home' | sed 's/[ ].*//')
        fi
        _sethome_var_uuid=$(_getuuid "$_sethome_var_hd")
        _sethome_var_fs=$(_getfs "$_sethome_var_hd")

        if [ ! -f /etc/fstab ]; then
            _printfs "/etc/fstab doesn't exist, continuing ..."
            return 1
        fi

        if ! grep "^UUID=$_sethome_var_uuid" /etc/fstab >/dev/null; then
            _printfs "/home is mounted but not listed in /etc/fstab, adding up ..."
            _sethome_var_fstab="UUID=$_sethome_var_uuid /home"
            _sethome_var_fstab="$_sethome_var_fstab $_sethome_var_fs"
            _sethome_var_fstab="$_sethome_var_fstab errors=remount-ro 0 1"
            _cmdsudo sed -i -e \"\\$a${_sethome_var_fstab}\" /etc/fstab
        fi
    else
        _sethome_var_total=$(awk '{print $4}' /proc/partitions |             \
                            sed -e '/name/d' -e '/^$/d' -e '/[1-9]/!d' |     \
                            tr '\n' ' ')

        if [ -n "$_sethome_var_total" ]; then
            _sethome_var_swap=$(cat /proc/swaps | grep partition |           \
                              cut -f1 -d' ' | cut -f3 -d'/' | tr '\n' ' ')
            if [ -f /etc/mtab ]; then
                _sethome_var_mounted=$(cat /etc/mtab | grep '^/' |           \
                                     sed 's/[ ].*//' | cut -f3 -d'/' |       \
                                     tr '\n' ' ')
            else
                _sethome_var_mounted=$(mount | grep '^/' | sed 's/[ ].*//' | \
                                     cut -f3 -d'/' | tr '\n' ' ')
            fi

            if [ -n "$_sethome_var_swap" ]; then
                for _sethome_var_swapp in $_sethome_var_swap; do
                    _sethome_var_total=$(printf "%s" "$_sethome_var_total" | \
                                       sed "s/${_sethome_var_swapp}//g")
                done
            fi

            if [ -n "$_sethome_var_mounted" ]; then
                for _sethome_var_mountedp in $_sethome_var_mounted; do
                    _sethome_var_total=$(printf "%s" "$_sethome_var_total" | \
                                      sed "s/${_sethome_var_mountedp}//g")
                done
            fi

            if [ -n "$_sethome_var_total" ]; then
                for _sethome_var_partition in $_sethome_var_total; do
                    mkdir /tmp/"$_sethome_var_partition"
                    _cmdsudo mount /dev/"$_sethome_var_partition" \
                             /tmp/"$_sethome_var_partition"

                    if _homedetected /tmp/"$_sethome_var_partition"; then
                        _printfs "/home partition found in: $_sethome_var_partition"
                        _printfs "replacing /home with partition ..."

                        _cmdsudo umount /tmp/"$_sethome_var_partition" &&    \
                                 rm -rf /tmp/"$_sethome_var_partition"
                        _cmdsudo mv /home /home.old && _cmdsudo mkdir /home
                        _cmdsudo mount /dev/"$_sethome_var_partition" /home
                        _cmdsudo chown -R $(whoami):$(whoami) /home/$(whoami)

                        _sethome
                    fi

                    if [ -d /tmp/$_sethome_var_partition ]; then
                        _cmdsudo umount /tmp/$_sethome_var_partition
                        rm -rf /tmp/$_sethome_var_partition
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
    _supported_var_distro="$(_distro)"
    case "$_supported_var_distro" in
        ubuntu|debian) return 0 ;;
    esac
    return 1
}

_installfirefoxnightly()
{   #custom ff version
    _installfirefoxnightly_var_arch=$(_arch)

    #while australis stay as the default firefox ui, use custom ff 27.x version
    #_installfirefoxnightly_var_url="http://ftp.mozilla.org/pub/mozilla.org"
    #_installfirefoxnightly_var_url="$_installfirefoxnightly_url"/firefox"
    #_installfirefoxnightly_var_url="$_installfirefoxnightly_url"/nightly"
    #_installfirefoxnightly_var_url="$_installfirefoxnightly_url"/latest-trunk"
    _installfirefoxnightly_var_url="http://files.javier.io/rep/bin"
    if [ X"$_installfirefoxnightly_var_arch" = X"32" ]; then
        #_installfirefox_var_version=$(curl "$_installfirefoxnightly_var_url" 2>&1 \
                                 #| egrep -o 'href="([^"#]+)"' | cut -d'"' -f2\
                                 #| grep "linux-i686.tar.bz2")
        _installfirefox_var_version="firefox32.tar.bz2"
    else
        #_installfirefox_var_version=$(curl "$_installfirefoxnightly_var_url" 2>&1 \
                                 #| egrep -o 'href="([^"#]+)"' | cut -d'"' -f2\
                                 #| grep "linux-x86_64.tar.bz2")
        _installfirefox_var_version="firefox64.tar.bz2"
    fi

    _fetchfile "$_installfirefoxnightly_var_url"/"$_installfirefox_var_version" \
               firefox"$_installfirefoxnightly_var_arch".tar.bz2

    _waitfor tar jxf firefox"$_installfirefoxnightly_var_arch".tar.bz2
    _cmd rm -rf firefox"$_installfirefoxnightly_var_arch".tar.bz2 index.html
    _cmd mv firefox"$_installfirefoxnightly_var_arch" "$HOME"/.bin/

    if [ ! -f /usr/local/bin/firefox ] && \
       [ -f "$HOME"/.bin/firefox${_installfirefoxnightly_var_arch}/firefox ]; then
        _cmdsudo ln -s $HOME/.bin/firefox${_installfirefoxnightly_var_arch}/firefox /usr/local/bin/
    fi
}

_siteup()
{   #check if a site us up, return 0 on sucess, 1 otherwise
    [ -z "$1" ] && return 1 || _siteup_var_url="$1"
    _siteup_var_max_retries="3"

    _siteup_var_i=0
    while [ $_siteup_var_i -lt $_siteup_var_max_retries ]; do
        _siteup_var_i=$(expr $_siteup_var_i + 1);
        wget "$_siteup_var_url" -O _siteup.out >/dev/null 2>&1
        if [ $_siteup_var_i -eq $(expr $_siteup_var_max_retries - 1) ]; then
            return 1
        else
            sleep $(expr $i \* 3)
        fi
        [ -f _siteup.out ] && break
    done

    rm -rf _siteup.out
    return 0
}

_header()
{
    clear
    _printfl "The Setup"
    printf "%b\\n" "\033[1m Dotfiles:\033[0m $dotfiles"
    printf "%b\\n" "\033[1m Utils:\033[0m    $utils"
    printf "%b\\n" "\033[1m Updates:\033[0m  $updates"
    printf "\\n"

    printf "%b\\n" "\033[1m  $rx Remote:                  \033[0m$liner"
    printf "%b\\n" "\033[1m  $lx Local (includes Remote): \033[0m$liner l"
    printf "%b\\n" "\033[1m  $bx Boot:                    \033[0m$liner b"

    if [ "$(id -u)" != "0" ]; then
        _printfl
    fi
}

_diesendmail()
{   #stupid apt-get purge doesn't kill sendmail instances
    _diesendmail_var_pid=$(ps aux | grep [s]endmail | awk '{print $2}')
    if [ -n "$_diesendmail_var_pid" ]; then
        _printfs 'die sendmail, die!!'
        _cmdsudo kill "$_diesendmail_var_pid"
    fi
}

_cleanup()
{
    [ "$_cleanup_var_init" ] && return
    _cleanup_var_init="done"

    stty echo
    [ -z "$sudopwd" ] && return

    printf "\\n"
    _printfl "Cleanup"

    _printfs "recovering old conf ..."
    for _cleanup_var_file in $HOME/*.old; do
        [ ! -e "$_cleanup_var_file" ] && continue
        mv "$_cleanup_var_file" ${_cleanup_var_file%.old}
    done

    _printfs "recovering scripts ..."
    for _cleanup_var_file in /etc/bash_completion.d/*.old; do
        [ ! -e "$_cleanup_var_file" ] && continue
        mv "$_cleanup_var_file" ${_cleanup_var_file%.old}
    done

    for _cleanup_var_file in /usr/local/bin/*.old; do
        [ ! -e "$_cleanup_var_file" ] && continue
        mv "$_cleanup_var_file" ${_cleanup_var_file%.old}
    done

    _cmd rm -rf dotfiles learn
    _recoverreps

    [ -z "$1" ] && exit
}

_backupreps()
{   #create a backup of /etc/apt/sources.list.d/* files
    for _backupreps_var_file in /etc/apt/sources.list.d/*.list; do
        break
    done

    if [ -f "$_backupreps_var_file" ]; then
        _printfs "disabling temporaly non standard repos ..."
    fi

    for _backupreps_var_file in /etc/apt/sources.list.d/*.list; do
        if [ -f "$_backupreps_var_file" ]; then
            _cmdsudo mv "$_backupreps_var_file" "$_backupreps_var_file".backup_rep
        fi
    done
}

_recoverreps()
{   #recover files at /etc/apt/sources.list.d/*
    for _recoverreps_var_file in /etc/apt/sources.list.d/*.list.backup_rep; do
        break
    done

    if [ -f "$_recoverreps_var_file" ]; then
        _printfs "recovering non standard repos ..."
    fi

    for _recoverreps_var_file in /etc/apt/sources.list.d/*.list.backup_rep; do
        if [ -f "$_recoverreps_var_file" ]; then
            _cmdsudo mv "$_recoverreps_var_file" "${_recoverreps_var_file%.backup_rep}"
        fi
    done
}

_ensurerepo()
{   #ensure rep is enabled
    [ -z "$1" ] && return 1
    [ -z "$2" ] && _ensurerepo_var_key="" || _ensurerepo_var_key="$2"

    _ensurerepo_var_baseurl=$(printf "%s" "$1" | cut -d' ' -f2 | grep "//")
    if [ -z "$(printf "%s" "$1" | cut -d' ' -f3)" ] || \
       [ -z "$_ensurerepo_var_baseurl" ]; then
        _die "Bad formated repository: $1"
    fi

    [ ! -d /etc/apt/sources.list.d ] && _cmdsudo mkdir /etc/apt/sources.list.d
    if [ -z "$_ensurerepo_var_list" ]; then
        _ensurerepo_var_extras=/etc/apt/sources.list.d/*.list

        for _ensurerepo_var_extra in $_ensurerepo_var_extras; do
            break
        done

        if [ -e "$_ensurerepo_var_extra" ]; then
            _ensurerepo_var_list=$(grep -h ^deb \
                /etc/apt/sources.list /etc/apt/sources.list.d/*.list)
        else
            _ensurerepo_var_list=$(grep -h ^deb /etc/apt/sources.list)
        fi
    fi

    case $_ensurerepo_var_baseurl in
        *archive.ubuntu.com*)
            _ensurerepo_var_regex=$(printf "%s" "$1" | cut -d' ' -f3-4)
            _ensurerepo_var_name=$(printf "%s" "$1" | cut -d' ' -f3-4 | tr ' ' '-')
            ;;
        *)
            _ensurerepo_var_regex="$_ensurerepo_var_baseurl"
            if [ -n "$(printf "%s" "$_ensurerepo_var_baseurl" | cut -d'/' -f5)" ]; then
                _ensurerepo_var_name=$(printf "%s" "$_ensurerepo_var_baseurl" \
                                     | cut -d'/' -f4-5 | tr '/' '-')
            else
                _ensurerepo_var_name=$(printf "%s" "$_ensurerepo_var_baseurl" \
                                     | cut -d'/' -f3-4 | tr '/' '-')
            fi
            if [ -z "$(printf "%s" "$1" | cut -d' ' -f4)" ]; then
                _ensurerepo_var_name="$(printf "%s" "$_ensurerepo_var_baseurl" \
                    | cut -d'/' -f 3 | awk -F. '{print $(NF-1)}')"-"$_ensurerepo_var_name"
            fi
            ;;
    esac

    if ! printf "%s" "$_ensurerepo_var_list" | grep "$_ensurerepo_var_regex" >/dev/null; then
        printf "%s\\n" "$1" > "$_ensurerepo_var_name".list
        _cmdsudo mv "$_ensurerepo_var_name".list /etc/apt/sources.list.d/
        if [ -n "$_ensurerepo_var_key" ]; then
            if printf "%s" "$_ensurerepo_var_key" | grep "http" >/dev/null; then
                _fetchfile $_ensurerepo_var_key keyfile.asc
                _waitforsudo apt-key add keyfile.asc
                _cmd rm -rf keyfile.asc
            else
                _waitforsudo apt-key adv --keyserver keyserver.ubuntu.com \
                --recv-keys "$_ensurerepo_var_key"
            fi
        fi
    fi
}

_ensuresetting()
{   #ensure setting($1) is set in a configuration file($2)
    [ -z "$1" ] && return 1 || _ensuresetting_var_line="$1"
    [ -z "$2" ] && return 1 || _ensuresetting_var_file="$2"

    [ ! -f "$_ensuresetting_var_file" ] && return 1

    _ensuresetting_var_regex=$(printf "%s" "$_ensuresetting_var_line" |   \
                             sed 's: :[ \\t]\\+:g')
    _ensuresetting_var_setting=$(printf "%s" "$_ensuresetting_var_line" | \
                               cut -d' ' -f1)

    if grep "$(printf "^%s" "$_ensuresetting_var_setting")"               \
    "$_ensuresetting_var_file" >/dev/null; then
        if ! grep "$(printf "^%s" "$_ensuresetting_var_regex")"           \
        "$_ensuresetting_var_file" >/dev/null; then
            _cmdsudo sed -i -e \\\"/^$_ensuresetting_var_setting/         \
            s:.*:$_ensuresetting_var_line:\\\" "$_ensuresetting_var_file"
        fi
    else
        if grep "$(printf "^#%s[ \t]" "$_ensuresetting_var_setting")"     \
        "$_ensuresetting_var_file" >/dev/null; then
            _cmdsudo sed -i -e                                            \
            \\\"/^#$_ensuresetting_var_setting/ s:#.*:$_ensuresetting_var_line:\\\" \
            "$_ensuresetting_var_file"
        else
            _cmdsudo sed -i -e \\\"\$ a$_ensuresetting_var_line\\\"        \
            "$_ensuresetting_var_file" #'
        fi
    fi
}

_what-virt()
{   #check for virtualization system, returns technology used
    if [ -d /proc/vz ] && [ ! -d /proc/bc ]; then
        printf "openvz"
    elif grep 'UML' /proc/cpuinfo >/dev/null; then
        printf "uml"
    elif  [ -f /proc/xen/capabilities ]; then
        printf "xen"
    elif grep 'QEMU' /proc/cpuinfo >/dev/null; then
        printf "qemu"
    fi
}

_enableremotevnc()
{
    _printfl "Enabling Xvnc"
    _printfs "installing dependencies ..."
    _waitforsudo apt-get install --no-install-recommends -y x11vnc xserver-xorg-video-dummy
    _printfs "forcing xorg to use dummy driver ..."

    printf "%s\\n" 'Section "Monitor"' > xorg.conf
    printf "%s\\n" '    Identifier "Monitor0"' >> xorg.conf
    printf "%s\\n" '    HorizSync 28.0-80.0' >> xorg.conf
    printf "%s\\n" '    VertRefresh 48.0-75.0' >> xorg.conf
    printf "%s\\n" '    #Modeline "1280x800"  83.46  1280 1344 1480 1680  800 801 804 828 -HSync +Vsync' >> xorg.conf
    printf "%s\\n" '    # 1224x685 @ 60.00 Hz (GTF) hsync: 42.54 kHz; pclk: 67.72 MHz' >> xorg.conf
    printf "%s\\n" '    Modeline "1224x685" 67.72 1224 1280 1408 1592 685 686 689 709 -HSync +Vsync' >> xorg.conf
    printf "%s\\n" 'EndSection' >> xorg.conf

    printf "%s\\n" 'Section "Device"' >> xorg.conf
    printf "%s\\n" '    Identifier "Card0"' >> xorg.conf
    printf "%s\\n" '    Option "NoDDC" "true"' >> xorg.conf
    printf "%s\\n" '    Option "IgnoreEDID" "true"' >> xorg.conf
    printf "%s\\n" '    Driver "dummy"' >> xorg.conf
    printf "%s\\n" 'EndSection' >> xorg.conf

    printf "%s\\n" 'Section "Screen"' >> xorg.conf
    printf "%s\\n" '    DefaultDepth 24' >> xorg.conf
    printf "%s\\n" '    Identifier "Screen0"' >> xorg.conf
    printf "%s\\n" '    Device "Card0"' >> xorg.conf
    printf "%s\\n" '    Monitor "Monitor0"' >> xorg.conf
    printf "%s\\n" '    SubSection "Display"' >> xorg.conf
    printf "%s\\n" '        Depth 24' >> xorg.conf
    printf "%s\\n" '        #    Virtual 1280 800' >> xorg.conf
    printf "%s\\n" '        Modes "1224x685"' >> xorg.conf
    printf "%s\\n" '    EndSubSection' >> xorg.conf
    printf "%s\\n" 'EndSection' >> xorg.conf

    _smv xorg.conf /etc/X11/

    _printfs "run $ sudo x11vnc -display :0 -auth /var/run/slim.auth -forever -safer -shared"
    _printfl
}

################################################################################
# Deployment functions #########################################################
################################################################################

_remotesetup()
{
    _printfl "Fixing dependencies"
    _remotesetup_var_release=$(_getrelease)
    if [ -n "$_remotesetup_var_release" ]; then
        _backupreps
        _printfs "adding repos ..."
        _ensurerepo "deb http://ppa.launchpad.net/chilicuil/sucklesstools/ubuntu $_remotesetup_var_release main" "8AC54C683AC7B5E8"
        _ensurerepo "deb http://archive.ubuntu.com/ubuntu/ $_remotesetup_var_release multiverse"
        _ensurerepo "deb http://archive.ubuntu.com/ubuntu/ $_remotesetup_var_release-updates multiverse"
    else
        _die "Impossible to find release"
    fi

    _printfs "fixing locales ..."
    _waitforsudo locale-gen en_US en_US.UTF-8
    _waitforsudo dpkg-reconfigure -f noninteractive locales
    #https://bugs.launchpad.net/ubuntu/+source/pam/+bug/155794
    if [ ! -f /etc/default/locale ]; then
        printf "%s\\n%s\\n" 'LANG="en_US.UTF-8"' \
                            'LANGUAGE="en_US:en"' > locale
        _smv locale /etc/default/
        #_cmdsudo update-locale LANG=en_US.UTF-8 LC_MESSAGES=POSIX
    fi

    _printfs "installing deps ..."
    _waitforsudo apt-get update
    _waitforsudo apt-get install --no-install-recommends -y $apps_remote

    _printfs "purging non essential apps ..."
    _waitforsudo DEBIAN_FRONTEND=noninteractive apt-get purge -y $apps_purge
    _diesendmail

    [ ! -f /usr/bin/git ] && _die "Dependency step failed"

    ############################################################################

    _printfl "Downloading files"
    _printfs "getting reps ..."

    _fetchrepo "$dotfiles.git"
    _fetchrepo "$utils.git"

    ############################################################################

    _printfl "Installing files"
    _remotesetup_var_target="/usr/local/bin/"
    if [ -d /usr/share/bash-completion/completions/ ]; then
        _remotesetup_var_completions="/usr/share/bash-completion/completions/"
    elif [ -d /etc/bash_completion.d/ ]; then
        _remotesetup_var_completions="/etc/bash_completion.d/"
    fi

    if [ ! -f $HOME/.not_override ]; then
        _printfs "installing dotfiles (old files will get an .old suffix) ..."
        for _remotesetup_var_file in dotfiles/.*; do
            [ ! -e "$_remotesetup_var_file" ] && continue
            _smv "$_remotesetup_var_file" "$HOME"
        done

        #special case, avoid removing my own certificates
        _remotesetup_var_ssh_old=$(_getlastversion "$HOME"/.ssh)
        if [ -n "$_remotesetup_var_ssh_old" ] && \
        [ ! X"$_remotesetup_var_ssh_old" = X"$HOME"/.ssh ]; then
            cp "$_remotesetup_var_ssh_old"/* "$HOME"/.ssh/
        fi
    fi

    if [ ! -f /usr/local/bin/not_override ]; then
        if [ -n "$_remotesetup_var_completions" ]; then
            _printfs "installing completions ..."
            for _remotesetup_var_file in learn/autocp/completions/*; do
                [ ! -e "$_remotesetup_var_file" ] && continue
                _smv "$_remotesetup_var_file" "$_remotesetup_var_completions"
            done
        fi

        _printfs "installing utils ..."
        for _remotesetup_var_file in learn/python/*; do
            [ ! -e "$_remotesetup_var_file" ] && continue
            [ -f "$_remotesetup_var_file" ] && chmod +x "$_remotesetup_var_file"
            _smv "$_remotesetup_var_file" "$_remotesetup_var_target"
        done

        for _remotesetup_var_file in learn/sh/is/*; do
            [ ! -e "$_remotesetup_var_file" ] && continue
            [ -f "$_remotesetup_var_file" ] && chmod +x "$_remotesetup_var_file"
            _smv "$_remotesetup_var_file" "$_remotesetup_var_target"
        done

        for _remotesetup_var_file in learn/sh/tools/*; do
            [ ! -e "$_remotesetup_var_file" ] && continue
            [ -f "$_remotesetup_var_file" ] && chmod +x "$_remotesetup_var_file"
            _smv "$_remotesetup_var_file" "$_remotesetup_var_target"
        done
    fi

    rm -rf dotfiles learn

    ############################################################################

    _printfl "Configuring main apps"

    _printfs "configuring ssh ..."

    #http://javier.io/blog/es/2013/12/17/captcha-para-ssh.html
    if [ -f /etc/pam.d/sshd ]; then
        if ! grep "pam_captcha.so" /etc/pam.d/sshd >/dev/null; then
            _cmdsudo sed -i                                           \
            1i\\\"auth requisite pam_captcha.so math randomstring\\\" \
            /etc/pam.d/sshd
        fi
        _ensuresetting "PasswordAuthentication no" /etc/ssh/sshd_config
        _ensuresetting "ChallengeResponseAuthentication yes" /etc/ssh/sshd_config
        _ensuresetting "UsePAM yes" /etc/ssh/sshd_config
        _cmdsudo service ssh restart
    else
        printf "%s\\n" "    /etc/pam.d/sshd not found, continuing without libpam-captcha ..."
    fi

    _printfs "configuring vim (3 min aprox) ..."
    if [ ! -d "$HOME"/.vim/bundle/vundle/.git/ ]; then
        #while shallow clone doesn't get accepted
        #_fetchrepo https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
        _fetchrepo "https://github.com/chilicuil/vundle.git" "$HOME/.vim/bundle/vundle"
    fi
    _waitfor vim -es -u ~/.vimrc -c "BundleInstall" -c qa

    _printfs "configuring shell (1 min aprox) ..."
    if [ ! -d "$HOME"/.shundle/bundle/shundle/.git/ ]; then
        _fetchrepo "https://github.com/chilicuil/shundle.git" "$HOME/.shundle/bundle/shundle"
    fi
    _cmd SHUNDLE_RC=~/.bashrc ~/.shundle/bundle/shundle/bin/shundle install

    _printfs "configuring cd ..."
    [ ! -d "$HOME"/.wcd ] && _cmd mkdir "$HOME"/.wcd
    if command -v "wcd.exec" >/dev/null 2>/dev/null; then
        _cmd wcd.exec -GN -j -xf "$HOME"/.ban.wcd -S "$HOME"
    fi
    [ -f "$HOME"/.treedata.wcd ] && _cmd mv "$HOME"/.treedata.wcd "$HOME"/.wcd/

    _recoverreps

    ############################################################################

    _printfl "DONE"
    printf "\\n%s\\n" "Reload the configuration to start having fun, n@n/"
    printf "%s\\n"    "    $ source ~/.bashrc"
}

_localsetup()
{
    _printfl "Verifying mirrors"
    _printfs "testing http://files.javier.io ..."
    if ! _siteup "http://files.javier.io"; then
        _die "http://files.javier.io seems down, retry when up"
    fi

    _printfs "testing http://javier.io ..."
    if ! _siteup "http://.javier.io"; then
        _die "http://javier.io seems down, retry when up"
    fi
    _printfs "everything seems ok, continuing..."

    _printfl "Fixing dependencies"
    _remotesetup_var_release=$(_getrelease)
    _remotesetup_var_arch=$(_arch)
    if [ -n "$_remotesetup_var_release" ]; then
        _backupreps
        _printfs "adding repos ..."
        _ensurerepo "deb http://ppa.launchpad.net/chilicuil/sucklesstools/ubuntu $_remotesetup_var_release main" "8AC54C683AC7B5E8"
        _ensurerepo "deb http://archive.ubuntu.com/ubuntu/ $_remotesetup_var_release multiverse"
        _ensurerepo "deb http://archive.ubuntu.com/ubuntu/ $_remotesetup_var_release-updates multiverse"
        _ensurerepo "deb http://dl.google.com/linux/talkplugin/deb stable main" "A040830F7FAC5991"
        _ensurerepo "deb http://download.videolan.org/pub/debian/stable/ /" "http://download.videolan.org/pub/debian/videolan-apt.asc"
    else
        _die "Impossible to find release"
    fi

    _sethome

    _printfs "fixing locales ..."
    _waitforsudo locale-gen en_US en_US.UTF-8
    _waitforsudo dpkg-reconfigure -f noninteractive locales
    #https://bugs.launchpad.net/ubuntu/+source/pam/+bug/155794
    if [ ! -f /etc/default/locale ]; then
        printf "%s\\n%s\\n" 'LANG="en_US.UTF-8"' \
                            'LANGUAGE="en_US:en"' > locale
        _smv locale /etc/default/
        #_cmdsudo update-locale LANG=en_US.UTF-8 LC_MESSAGES=POSIX
    fi

    _printfs "setting up an apt-get proxy ..."
    _waitforsudo apt-get update
    _waitforsudo apt-get install --no-install-recommends -y avahi-utils

    if _existaptproxy; then
        _remotesetup_var_apt_proxy_server=$(avahi-browse -a -t -r -p | grep apt-cacher-ng | grep = | cut -d";" -f8)
        _printfs "exists an apt-get proxy in the network at $_remotesetup_var_apt_proxy_server, setting up the client ..."
        _waitforsudo apt-get install --no-install-recommends -y squid-deb-proxy-client
    else
        _printfs "no apt-get proxy found, installing one locally ..."
        _waitforsudo apt-get install --no-install-recommends -y squid-deb-proxy-client apt-cacher-ng
        if [ ! -f /etc/avahi/services/apt-cacher-ng.service ]; then
            _fetchfile http://javier.io/mirror/apt-cacher-ng.service
            _cmdsudo mv apt-cacher-ng.service /etc/avahi/services/apt-cacher-ng.service
        fi
        if [ -d "$HOME"/misc/ubuntu/proxy/apt-cacher-ng/ ]; then
            _printfs "exporting files ..."
            _cmdsudo rm -rf /var/cache/apt-cacher-ng
            _cmdsudo ln -s "$HOME"/misc/ubuntu/proxy/apt-cacher-ng/ /var/cache/apt-cacher-ng
        fi
    fi

    _printfs "installing apps ..."
    _waitforsudo DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y $apps_local

    _printfs "installing /usr/local/bin utilities and dotfiles ..."
    _fetchfile http://javier.io/s
    _cmd mkdir "$HOME"/.s
    _cmd touch "$HOME"/.s/config
    printf "%s" "sudopwd=$sudopwd" > "$HOME"/.s/config
    _cmd sh ./s
    _cmd touch "$HOME"/.not_override
    _cmd rm -rf s .s/

    [ ! -f /usr/bin/i3 ] && _die "Dependency step failed"

    if [ ! -d "$HOME"/.bin/firefox${_remotesetup_var_arch} ]; then
        _cmd mkdir "$HOME"/.bin
        _installfirefoxnightly
    fi

    if [ ! -f /usr/local/bin/magnifier ]; then
        _fetchfile http://files.javier.io/rep/s/magnifier${_remotesetup_var_arch}.bin magnifier
        _cmd chmod +x magnifier
        _cmdsudo mv magnifier /usr/local/bin/
    fi

    _printfs "purging non essential apps ..."
    _waitforsudo DEBIAN_FRONTEND=noninteractive apt-get purge -y $apps_purge

    ############################################################################

    _printfl   "Downloading theme files"
    _printfs   "downloading confs, themes and so on ..."
    _fetchfile http://files.javier.io/rep/s/iconf.tar.bz2
    _waitfor   tar jxf iconf.tar.bz2
    _cmd       rm iconf.tar.bz2

    [ ! -d "./iconf" ] && _die "Download step failed"

    ############################################################################

    _printfl "Configuring system"
    _printfs "configuring swappiness ..."
    _ensuresetting "vm.swappiness=10" /etc/sysctl.conf
    _printfs "configuring kernel messages ..."
    _ensuresetting "kernel.printk = 4 4 1 7" /etc/sysctl.conf

    _printfs "configuring network ..."
    printf "%s\\n" "auto lo" > interfaces
    printf "%s\\n" "iface lo inet loopback" >> interfaces
    _cmdsudo mv interfaces /etc/network/
    _cmdsudo usermod -a -G netdev $(whoami)

    _printfs "configuring audio ..."
    _ensuresetting "snd-mixer-oss" /etc/modules
    _cmdsudo mv iconf/mpd/mpd.conf /etc
    _cmdsudo sed -i -e \\\"/music_directory/ s:chilicuil:$(whoami):\\\" /etc/mpd.conf

    _printfs "configuring groups ..."
    _cmdsudo usermod -a -G dialout $(whoami)
    _cmdsudo usermod -a -G sudo    $(whoami)
    _cmdsudo usermod -a -G plugdev $(whoami)

    _printfs "configuring cron ..."
    if [ -f /usr/local/bin/watch-battery ]; then
        printf "%s\\n" "    $ echo \"*/1 * * * * /usr/local/bin/watch-battery\" | crontab -"
        _addcron "*/1 * * * * /usr/local/bin/watch-battery";
    fi

    if [ -f /usr/local/bin/wcd ] && [ -f /usr/bin/wcd.exec ] && [ -f /usr/local/bin/update-cd ]; then
        printf "%s\\n" "    $ echo \"* 23 * * *  /usr/local/bin/update-cd\" | crontab -"
        _addcron "* 23 * * *  /usr/local/bin/update-cd";
    fi

    if [ -f /usr/local/bin/backup-mozilla ]; then
        printf "%s\\n" "    $ echo \"15 */4 * * * /usr/local/bin/backup-mozilla\" | crontab -"
        _addcron "15 */4 * * * /usr/local/bin/backup-mozilla";
    fi

    if [ -f "$HOME"/misc/conf/ubuntu/etc/lenovo-edge-netbook/crontabs.tar.gz ]; then
        _waitforsudo tar zxf "$HOME"/misc/conf/ubuntu/etc/lenovo-edge-netbook/crontabs.tar.gz -C /
    fi

    _printfs "configuring login manager ..."
    _smv iconf/slim/slim.conf /etc/
    _smv iconf/slim/custom /usr/share/slim/themes/
    _cmdsudo sed -i -e \\\"/default_user/ s:chilicuil:$(whoami):\\\" /etc/slim.conf
    #[ -f /usr/share/xsessions/i3.desktop ] && \
        #_cmdsudo sed -i -e \\\"/Exec/ s:=.*:=/etc/X11/Xsession:\\\" /usr/share/xsessions/i3.desktop

    _printfs "configuring gpg/ssh agents ..."
    if [ -f /etc/X11/Xsession.d/90gpg-agent ]; then
        if ! grep -- "--enable-ssh-support" /etc/X11/Xsession.d/90gpg-agent >/dev/null; then
            _cmdsudo sed -i -e \
                \\\"/STARTUP/ s:--daemon:--enable-ssh-support --daemon:\\\" \
                /etc/X11/Xsession.d/90gpg-agent
        fi
    fi

    if [ -f /etc/X11/Xsession.options ]; then
        _cmdsudo sed -i -e \\\"s:^use-ssh-agent:#use-ssh-agent:g\\\" \
            /etc/X11/Xsession.options
    fi

    [ -d "$HOME"/.gnupg ]          || _cmd mkdir "$HOME"/.gnupg
    [ -f "$HOME"/.gnupg/gpg.conf ] || _ensuresetting "use-agent" "$HOME"/.gnupg/gpg.conf

    #allow use of shutdown/reboot through dbus-send
    if [ ! -f /etc/polkit-1/localauthority/50-local.d/org.freedesktop.consolekit.pkla ]; then
        _fetchfile http://javier.io/mirror/org.freedesktop.consolekit.pkla
        _cmdsudo mv org.freedesktop.consolekit.pkla \
        /etc/polkit-1/localauthority/50-local.d/org.freedesktop.consolekit.pkla
    fi

    _printfs "configuring file manager ..."
    #https://bugs.launchpad.net/ubuntu/+source/policykit-1/+bug/600575
    if [ ! -f /etc/polkit-1/localauthority/50-local.d/55-storage.pkla ]; then
        _fetchfile http://javier.io/mirror/55-storage.pkla
        _cmdsudo mv 55-storage.pkla /etc/polkit-1/localauthority/50-local.d/55-storage.pkla
    fi

    _printfs "configuring browser ..."
    _waitfor tar jxf iconf/firefox/mozilla.tar.bz2 -C iconf/firefox
    for mozilla_old_profile in iconf/firefox/.mozilla/firefox/*.default; do break; done
    mozilla_old_profile=$(basename "$mozilla_old_profile" .default)
    mozilla_new_profile=$(strings /dev/urandom | grep -o '[[:alnum:]]' | \
                          head -n 8 | tr -d '\n'; printf "\\n")

    _smv iconf/firefox/libflashplayer${_remotesetup_var_arch}.so /usr/lib/mozilla/plugins/
    _cmd mv iconf/firefox/.mozilla/firefox/$mozilla_old_profile.default \
            iconf/firefox/.mozilla/firefox/$mozilla_new_profile.default
    find iconf/firefox/.mozilla -type f | xargs sed -i -e "s/$mozilla_old_profile/$mozilla_new_profile/g"
    find iconf/firefox/.mozilla -type f | xargs sed -i -e "s/admin/$(whoami)/g"
    find iconf/firefox/.mozilla -type f | xargs sed -i -e "s/chilicuil/$(whoami)/g"
    _smv iconf/firefox/.mozilla "$HOME"

    _cmd rm -rf ~/.macromedia ~/.adobe
    _cmd ln -s      /dev/null ~/.adobe
    _cmd ln -s      /dev/null ~/.macromedia

    _printfs "configuring gtk, icon, cursor themes ..."
    mv iconf/icons iconf/.icons
    mv iconf/gtk/themes iconf/gtk/.themes
    mv iconf/fonts iconf/.fonts
    mv iconf/data iconf/.data
    _smv iconf/.icons      "$HOME"
    _smv iconf/gtk/.themes "$HOME"
    _smv iconf/.fonts      "$HOME"
    _smv iconf/.data       "$HOME"

    _waitforsudo fc-cache -f -v #required for update font information
    _cmdsudo update-alternatives --set x-terminal-emulator /usr/bin/urxvt

    [ -d "$HOME"/.gvfs ] && fusermount -u "$HOME"/.gvfs

    #stackoverflow.com/q/8887972
    find "$HOME" -maxdepth 3                  \
        \(  -type f -iname "*gtkrc*"          \
         -o -type f -iname "*Trolltech.conf*" \
         -o -type f -iname "*Xdefaults*"      \
         -o -type f -iname "*bazaar.conf*"    \
         -o -type f -iname "*conkyrc*" \) -exec sed -i "s/chilicuil/$(whoami)/g" '{}' \;

    if [ -d /proc/acpi/battery/BAT0 ] && [ -f "$HOME"/.conkyrc ]; then
        _cmd sed -i \\\"s:BAT1:BAT0:g\\\" "$HOME"/.conkyrc
    fi

    localsetup_var_virt=$(_what-virt)
    case $localsetup_var_virt in
        openvz|uml|xen) _enableremotevnc ;;
    esac

    _printfs "cleaning up ..."
    _cmd rm -rf iconf*

    ############################################################################

    _printfl "DONE"
    printf "\\n"
    printf "%s\\n" "Restart your computer to start having fun, n@n/"
}

_ubuntudev()
{
    _printfl "Preparing the system for Ubuntu dev"
    _waitforsudo apt-get update
    _waitforsudo apt-get install --no-install-recommends -y $apps_ubuntudev
}

################################################################################
# Main #########################################################################
################################################################################

_header
if _supported; then
    #the _hook function execute $HOME/s/[LETTER][NUMBER] scripts
    #eg: $HOME/s/A01action, $HOME/s/B01installextra, $HOME/s/Z01finish
    _hooks A #these hooks wont have super powers
    _getvars
    _getroot
    _hooks B #super powers are available through the "_cmdsudo" function
             #e.g, _cmdsudo mkdir /root/forbidden_directory
    case "$mode" in
        remote) _remotesetup;;
        local)  _localsetup;;
    esac
    _hooks C; : #finish script with 0, independly of latest hooks result
else
    printf "%s %s\\n" "FAILED: Non supported distribution system detected," \
            "run this script on $supported systems only"
fi
