#!/usr/bin/env bash

trap _cleanup SIGINT SIGTERM #trap ctrl-c

dotfiles="https://github.com/chilicuil/dotfiles"
utils="https://github.com/chilicuil/learn"
updates="http://javier.io/s"
revision=1

apps_default="git-core vim-nox exuberant-ctags byobu wcd"
apps_ubuntudev="apt-file cvs subversion bzr bzr-builddeb pbuilder"

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

_barcui()
{
    [ -z $1 ] && return 1
    pid=$1
    animation_state=1

    if [ ! "$(ps -p $pid -o comm=)" ]; then
        printf "%4s\n" ""
        return
    fi

    printf "%s" " "
    local c=0; j=0;
    
    exec < /dev/tty
    oldstty=$(stty -g)
    stty raw -echo min 0
    echo -en "\033[6n" > /dev/tty
    IFS=';' read -r -d R -a pos
    stty $oldstty
    local col=$((${pos[1]} - 1))
    col=$((col+4))

    while [ "`ps -p $pid -o comm=`" ]; do
        case $animation_state in
            1)
                printf "%s" "o@o"
                animation_state=2
                ;;
            2)
                if (( j < $(tput cols)-col )); then
                    for (( i = 0; i < c+4; i++ )); do
                        printf "%b" "\b";
                    done
                    printf "%*s%s" $((c+1)) "" "o @o"
                    (( j=j+1 ))
                    (( c=c+1 ))
                    if ! (( j < $(tput cols)-col )); then
                        animation_state=3
                    fi
                fi
                ;;
            3)
                for (( i = 0; i < c+3; i++ )); do
                    printf "%b" "\b";
                done
                printf "%*s%s" $((c)) "" "o@o "
                animation_state=4
                ;;
            4)
                for (( i = 0; i < c+4; i++ )); do
                    printf "%b" "\b";
                done
                printf "%*s%s" $((c)) "" "o@o?"
                animation_state=5
                ;;
            5)
                for (( i = 0; i < c+4; i++ )); do
                    printf "%b" "\b";
                done
                printf "%*s%s" $((c)) "" "o@o "
                animation_state=6
                ;;
            6)
                if (( j > 0 )); then
                    for (( i = 0; i < c+4; i++ )); do
                        printf "%b" "\b";
                    done
                    #set -x
                    printf "%*s%s" $((c-1)) "" "o@ o"
                    printf "%*s" 1 ""
                    printf "%b" "\b";
                    #set +x

                    (( j=j-1 ))
                    (( c=c-1 ))
                else
                    for (( i = 0; i < 4; i++ )); do
                        printf "%b" "\b";
                    done
                    printf "%4s" ""
                    for (( i = 0; i < 4; i++ )); do
                        printf "%b" "\b";
                    done
                    printf "%s" "o@o"
                    animation_state=2
                fi
                ;;
        esac
        sleep 1
    done
    for (( i = 0; i < 4; i++ )); do
        printf "%b" "\b";
    done
    printf "%4s\n" ""
}

_getroot()
{   #get sudo's password, define $sudopasswd and $sudocmd

    local tmp_path="/tmp"; local sudotest; local insudoers;

    if [ ! "$LOGNAME" = root ]; then
        echo "Detecting user $LOGNAME (non-root) ..."
        echo "Checking if sudo is available ..."
        sudotest=`type sudo &>/dev/null ; echo $?`

        if [ "$sudotest" = 0 ]; then
            echo "    Requesting sudo's password, I'll be carefull I promise =)"
            sudo -K
            if [ -e "$tmp_path/sudo.test" ]; then
                rm -f "$tmp_path/sudo.test"
            fi
            while [ -z "$sudopwd" ]; do
                echo -n "    - enter sudo-password: "
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
    echo
    echo -e "\033[1m-------------------\033[7m Cleanup \033[0m\033[1m-------------------\033[0m"
    echo "[+] recovering old conf ..."
    for FILE in $HOME/*.old; do
        [ -e "$FILE" ] || continue
        mv -v "$FILE" ${FILE%.old}
    done

    echo "[+] recovering scripts ..."
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

    echo -n "    $ $@ ..."
    $@ > /dev/null 2>&1 &
    sleep 1s

    _barcui $(pidof $1)
}

_smv()
{
    if [ "$(basename $1)" = "." ] || [ "$(basename $1)" = ".." ]; then
        return
    fi
    owner=$(stat -c %U "$2")

    if [ "$owner" != "$LOGNAME" ]; then
        [ -e "$2"/$(basename "$1") ] && echo "$sudopwd" | $sudocmd mv "$2"/$(basename "$1") "$2"/$(basename "$1").old
        echo "$sudopwd" | $sudocmd mv -v "$1" "$2"
    else
        [ -e "$2"/$(basename "$1") ] && mv "$2"/$(basename "$1") "$2"/$(basename "$1").old
        mv -v "$1" "$2"
    fi

}

_ubuntudev()
{
    echo -e "\033[1m----\033[7m Preparing the system for Ubuntu dev \033[0m\033[1m------\033[0m"
    echo "$sudopwd" | _waitfor $sudocmd apt-get install --no-install-recommends -y $apps_ubuntudev
}

_header
_getroot

echo -e "\033[1m----------------------\033[7m Fixing dependencies \033[0m\033[1m-------------------------\033[0m"
echo "[+] installing deps ..."
echo -n "    $ apt-get update ..."
echo "$sudopwd" | $sudocmd apt-get update > /dev/null 2>&1 &
sleep 2s && _barcui $(pidof apt-get)

echo -n "    $ apt-get install --no-install-recommends -y $apps_default ..."
echo "$sudopwd" | $sudocmd apt-get install --no-install-recommends -y $apps_default > /dev/null 2>&1 &
sleep 2s && _barcui $(pidof apt-get)
#_cmd echo
#####################################################################################################

[ ! -f /usr/bin/git ] && { echo "Dependecy step failed"; exit 1; }

echo -e "\033[1m-----------------------\033[7m Downloading files \033[0m\033[1m----------------------------\033[0m"
echo "[+] downloading reps ... "
_waitfor git clone --dept=1 "$dotfiles.git"
_waitfor git clone --dept=1 "$utils.git"

[ ! -d "$HOME/dotfiles" ] && { echo "Download step failed"; exit 1; }

echo -e "\033[1m------------------------\033[7m Installing files \033[0m\033[1m---------------------------\033[0m"
echo "[+] installing dotfiles (old dotfiles will get an .old suffix) ... "
for FILE in dotfiles/.*; do
    [ -e "$FILE" ] || break
    _smv "$FILE" $HOME
done

echo "[+] installing utils (old scripts will get an .old suffix) ... "
for FILE in learn/autocp/bash_completion.d/*; do
    [ -e "$FILE" ] || break
    _smv "$FILE" /etc/bash_completion.d/
done

for FILE in learn/python/*; do
    [ -f "$FILE" ] || continue
    _smv "$FILE" /usr/local/bin/
done

for FILE in learn/sh/*; do
    [ -f "$FILE" ] || continue
    _smv "$FILE" /usr/local/bin/
done

echo -e "\033[1m---------------\033[7m Configuring main apps \033[0m\033[1m-------------------\033[0m"
echo "[+] configuring vim (3 min aprox) ..."
_waitfor git clone --dept=1 https://github.com/gmarik/vundle ~/.vim/bundle/vundle
_waitfor vim -es -u ~/.vimrc -c "BundleInstall" -c qa

echo "[+] configuring cd ... "
mkdir $HOME/.wcd && /usr/bin/wcd.exec -GN -j -xf $HOME/.ban.wcd -S $HOME && mv $HOME/.treedata.wcd $HOME/.wcd/

echo -e "\033[1m----------------------\033[7m DONE \033[0m\033[1m-------------------\033[0m"
echo
echo "Reload the configuration to start having fun, n@n/"
echo "$ source ~/.bashrc"

#_cleanup 1
