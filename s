#!/usr/bin/env bash

trap _cleanup SIGINT SIGTERM #trap ctrl-c

dotfiles="https://github.com/chilicuil/dotfiles"
utils="https://github.com/chilicuil/learn"
updates="http://javier.io/s"

_header()
{
    clear
    echo -e "\033[1m----------------------------\033[7m setup \033[0m\033[1m---------------------------------\033[0m"
    echo -e "\033[1m  Dotfiles:\033[0m        $dotfiles"
    echo -e "\033[1m  Utils:\033[0m           $utils"
    echo -e "\033[1m  Updates:\033[0m         $updates"
    echo
    echo -e "\033[1m  Run with defaults:"
    echo
    echo -e "\033[1m      $ \033[0mbash <(wget -qO- javier.io/s)"
    echo
    echo -e "\033[1m  Or interactive:"
    echo
    echo -e "\033[1m      $ \033[0mwget $updates"
    echo -e "\033[1m      $ \033[0mbash s -i"
    echo -e "\033[1m--------------------------------------------------------------------\033[0m"
    echo
}

_cmd()
{   #print current command, exits on fail
    [ -z $1 ] && return 0

    echo "[+] $@"
    $@

    status=$?
    [ $status != 0 ] && exit $status || return
}

_rotate()
{
    [ -z $1 ] && return 1
    pid=$1
    animation_state=1

    while [ "`ps -p $pid -o comm=`" ]; do
        # rotating star
        echo -e -n "\b\b\b"
        case $animation_state in
            1)
                echo -n "["
                echo -n -e "\033[1m|\033[0m"
                echo -n "]"
                animation_state=2
                ;;
            2)
                echo -n "["
                echo -n -e "\033[1m/\033[0m"
                echo -n "]"
                animation_state=3
                ;;
            3)
                echo -n "["
                echo -n -e "\033[1m-\033[0m"
                echo -n "]"
                animation_state=4
                ;;
            4)
                echo -n "["
                echo -n -e "\033[1m"
                echo -n "\\"
                echo -n -e "\033[0m"
                echo -n "]"
                animation_state=1
                ;;
        esac
        sleep 1
    done
}

_getroot()
{   #get sudo's password, define $sudopasswd and $sudocmd

    local tmp_path="/tmp"; local sudotest; local insudoers;

    if [ ! "$LOGNAME" = root ]; then
        echo "Detecting user $LOGNAME (non-root) ..."
        echo "Checking if sudo is available ..."
        sudotest=`type sudo &>/dev/null ; echo $?`

        if [ "$sudotest" = 0 ]; then
            echo "    sudo was found!"
            echo "    Requesting sudo's password, I'll be carefull I promise =)"
            sudo -K
            if [ -e "$tmp_path/sudo.test" ]; then
                rm -f "$tmp_path/sudo.test"
            fi
            while [ -z "$sudopwd" ]; do
                echo -n "   - enter sudo-password: "
                stty -echo
                read sudopwd
                stty echo

                # password check
                echo "$sudopwd" | sudo -S touch "$tmp_path/sudo.test" > "$tmp_path/sudo.output" 2>&1
                insudoers=$(grep -i "sudoers" "$tmp_path/sudo.output")
                if [ -n "$insudoers" ]; then
                    echo "$sudopwd" | sudo -S rm "$tmp_path/sudo.output" > /dev/null 2>&1
                    exit
                fi

                if [ ! -e "$tmp_path/sudo.test" ]; then
                    sudopwd=""
                fi
            done

            sudocmd="/usr/bin/sudo -S"

            echo "$sudopwd" | $sudocmd rm -f "$tmp_path/sudo.test" > /dev/null 2>&1
            echo
        else
            echo "You're not root and sudo isn't available. Please run this script as root!"
            exit
        fi
    fi
}

_cleanup()
{
    echo -e "\033[1m--------------------------------\033[7m Downloading files \033[0m\033[1m-------------------------------\033[0m"
    echo "[+] recovering old conf ... "
    for FILE in $HOME/*.old; do
        [ -e "$FILE" ] || continue
        mv -v "$FILE" ${FILE%.old}
    done

    echo "[+] recovering scripts ... "
    for FILE in /etc/bash_completion.d/*.old; do
        [ -e "$FILE" ] || continue
        mv -v "$FILE" ${FILE%.old}
    done

    for FILE in /usr/local/bin/*.old; do
        [ -e "$FILE" ] || continue
        mv -v "$FILE" ${FILE%.old}
    done

    _cmd rm -rf dotfiles learn

    [ -z "$1" ] && exit
}

_waitfor()
{
    [ -z $1 ] && return 1
    status=$?
    [ $status != 0 ] && exit $status

    echo "[+] $@"
    $@ &

    running=$(pidof $1); running=$?
    if [ "$running" = 1 ]; then
        echo -e "\b\b\b\b\b done"
    else
        _rotate $(pidof $1)
        echo -e "\b\b\b\b\b done"
    fi
}

_smv()
{
    [ -e "$2"/$(basename "$1") ] && mv "$2"/$(basename "$1").old
    mv -v "$1" "$2"
}

_ubuntudev()
{
    echo -e "\033[1m----------------------------\033[7m Preparing the system for Ubuntu dev \033[0m\033[1m------------------------------------\033[0m"
    echo "$sudopwd" | _waitfor $sudocmd apt-get install --no-install-recommends apt-file cvs subversion bzr bzr-builddeb pbuilder -y
}

_header
_getroot

echo -e "\033[1m--------------------------------\033[7m Fixing dependencies \033[0m\033[1m--------------------------------\033[0m"

echo "$sudopwd" | $sudocmd apt-get update &
_rotate $(pidof apt-get) && echo -e "\b\b\b\b\b done"

echo "$sudopwd" | $sudocmd apt-get install --no-install-recommends git-core vim-nox exuberant-ctags byobu wcd -y &
_rotate $(pidof apt-get) && echo -e "\b\b\b\b\b done"
#_cmd echo
#####################################################################################################

echo -e "\033[1m--------------------------------\033[7m Downloading files \033[0m\033[1m-------------------------------\033[0m"
echo "[+] downloading reps ... "
_waitfor git clone --dept=1 "$dotfiles.git"
_waitfor git clone --dept=1 "$utils.git"

echo -e "\033[1m--------------------------------\033[7m Installing files \033[0m\033[1m-------------------------------\033[0m"
echo "[+] installing dotfiles (old dotfiles will get an .old suffix) ... "
for FILE in dotfiles/.*; do
    [ -e "$FILE" ] || break
    smv "$FILE" $HOME
done

echo "[+] installing utils (old scripts will get an .old suffix) ... "
for FILE in learn/autocp/bash_completion.d/*; do
    [ -e "$FILE" ] || break
    smv "$FILE" /etc/bash_completion.d/
done

for FILE in learn/python/*; do
    [ -f "$FILE" ] || continue
    smv "$FILE" /usr/local/bin/
done

for FILE in learn/sh/*; do
    [ -f "$FILE" ] || continue
    smv "$FILE" /usr/local/bin/
done

echo -e "\033[1m--------------------------------\033[7m Configuring main apps \033[0m\033[1m-------------------------------\033[0m"
echo "[+] configuring vim ... "
_waitfor git clone --dept=1 https://github.com/gmarik/vundle ~/.vim/bundle/vundle
_cmd vim -es -u ~/.vimrc -c "BundleInstall" -c q


echo -e "\033[1m-------------------------------------\033[7m DONE \033[0m\033[1m----------------------------------\033[0m"

#_cleanup 1
