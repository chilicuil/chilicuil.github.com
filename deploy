#!/bin/sh
#description: deploy remote recipes locally
#usage: sh <(wget -qO- javier.io/deploy) TARGET

#example: sh <(wget -qO- javier.io/deploy) f.javier.io
#deploys f.javier.io in the local computer

trap _cleanup INT QUIT #trap ctrl-c
base_url="https://raw.githubusercontent.com/javier-lopez/learn/master/sh/deploy/"
#base_url="http://gitcdn.link/repo/javier-lopez/learn/master/sh/deploy/"

_usage() {
    printf "%s\\n" "Usage: sh <(wget -O- javier.io/deploy) TARGET [PARAM]..."
    printf "%s\\n" "Deploy remote recipes locally."
    printf "\\n"
    printf "%s\\n" "  -h, --help   show this help message and exit"
    printf "%s\\n" "  -c, --clean  clean cache"
    printf "\\n"
    printf "%s\\n" "Examples:"
    printf "\\n"
    printf "%s\\n" "  $ sh <(wget -qO- javier.io/deploy) f.javier.io"
}

_die() {
    [ -z "${1}" ] || printf "%s\\n" "${*}" >&2
    _usage >&2; exit 1
}

_mkdir_p() { #portable mkdir -p function
    [ -z "${1}" ] && return 1
    for _mkdir_p__dir; do
        _mkdir_p__IFS="$IFS"
        IFS="/"
        set -- $_mkdir_p__dir
        IFS="$_mkdir_p__IFS"
        (
        case "$_mkdir_p__dir" in
            /*) cd /; shift ;;
        esac
        for _mkdir_p__subdir; do
            [ -z "${_mkdir_p__subdir}" ] && continue
            if [ -d "${_mkdir_p__subdir}" ] || mkdir "${_mkdir_p__subdir}"; then
                if cd "${_mkdir_p__subdir}"; then
                    :
                else
                    printf "%s\\n" "_mkdir_p: Can't enter ${_mkdir_p__subdir} while creating ${_mkdir_p__dir}"
                    return 1
                fi
            else
                return 1
            fi
        done
        )
    done
}

_basename() {
    [ -z "${1}" ] && return 1 || _basename2__name="${1%%/}"
    [ -z "${2}" ] || _basename2__suffix="${2}"
    case "${_basename2__name}" in
        /*|*/*) _basename2__name="${_basename2__name##*/}"
    esac

    if [ -n "${_basename2__suffix}" ] && [ "${#_basename2__name}" -gt "${#2}" ]; then
        _basename2__name="${_basename2__name%$_basename2__suffix}"
    fi

    printf "%s" "${_basename2__name}"
}

_cleanup() {
    :
}

_fetcher() {
    [ -z "${1}" ] && return 1
    [ -f "${2}" ] && return 0
    if command -v "wget" >/dev/null 2>&1; then
        wget -q --no-check-certificate "${1}" -O "${2}"
    elif command -v "curl" >/dev/null 2>&1; then
        curl -L -k "${1}" -o "${2}"
    else
        return 1
    fi
}

[ "${#}" -eq "0" ] && _die

for arg in "${@}"; do #parse options
    case "${arg}" in
        -h|--help) _usage && exit ;;
        -c|--clean-cache)
            rm -r '/tmp/javier.io##deploy' && printf "%s\\n" "Cache cleared successfully"
            exit "${?}"
            ;;
    esac
done

_mkdir_p '/tmp/javier.io##deploy'
__remote_script="/tmp/javier.io##deploy/$(_basename "${1}")"
_fetcher "${base_url}/${1}" "${__remote_script}" && shift
__interpeter="$(awk '{sub("^#!", ""); print $0; exit}' "${__remote_script}")"
exec "${__interpeter}" "${__remote_script}" ${@}

# vim: set ts=8 sw=4 tw=0 ft=sh :
