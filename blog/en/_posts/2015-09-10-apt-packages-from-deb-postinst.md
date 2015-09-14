---
layout: post
title: "install apt packages from deb postinst"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

During the last couple of years I've been building [yet another Linux distribution](https://github.com/minos-org), mostly to have my favorite software nicely packaged, but also to experiment and have fun =)

One important part of it is its configuration file, **/etc/minos/config** or **~/.minos/config**, e.g.

<pre class="sh_sh">
wallpaper      ~/data/images/wallpapers/sunlight.png
lock-wallpaper ~/data/images/wallpapers/lock.png
app-core       mozilla-firefox mozilla-flashplayer
app-purge      xinetd sasl2-bin sendmail sendmail-base sendmail-bin sensible-mda
</pre>

I've chosen Debian/Ubuntu infrastructure for the initial implementation but probably will change it in the future (bedrock linux?). Anyway, since some of the parameters accept additional packages I've been having fun abusing the maintainer scripts to do so, this is the description.

## Locks

Apt, rpm, and most package managers use locks to ensure its operations are as atomic as possible, it helps them to keep packages under control, so when trying to abuse maintainer scripts (on this case postinst) the first error to come up will be:

<pre class="sh_sh">
E: Could not get lock /var/lib/dpkg/lock - open (11: Resource temporarily unavailable)
E: Unable to lock the administration directory (/var/lib/dpkg/), is another process using it?`
</pre>

These files can be moved temporally to launch additional apt/dpkg instances, after some experimentation the list is as follows:

    /var/lib/dpkg/lock
    /var/cache/apt/archives/lock
    /var/lib/dpkg/updates/

Dpkg/apt-get uses a database in text plain located at **/var/lib/dpkg/status**, it's kind of important to keep track of it too since the result of every apt/dpkg invocation is dumped to it upon completion (multiple backups are available at /var/backups/dpkg.status).

## Post execution

There seem to exist several options to abuse apt-get, cron jobs, daemons queues (aptdaemon?), custom waits, but all them require a considerable amount of time after the main apt-get/dpkg is done, what if the system go down short after?. I finally decided to install everything within the main apt-get process and merge changes at the end (that way it takes a couple of seconds processing the missing text operations instead of probably several minutes for further apt instances).

It was funny that even more locks were needed to provide some reliability.

<pre class="sh_sh">
#!/bin/sh

_suspend_dpkg_process()
{
    rm -rf /var/lib/dpkg/updates.suspended/
    mv /var/lib/dpkg/lock     /var/lib/dpkg/lock.suspended
    mv /var/lib/dpkg/updates/ /var/lib/dpkg/updates.suspended
    mkdir /var/lib/dpkg/updates/
    mv /var/cache/apt/archives/lock /var/cache/apt/archives/lock.suspended
    cp /var/lib/dpkg/status /var/lib/dpkg/status.suspended
    cp /var/lib/dpkg/status-old  /var/lib/dpkg/status-orig
    cp /var/lib/dpkg/status-orig /var/lib/dpkg/status
}

_continue_dpkg_process()
{
    rm -rf /var/lib/dpkg/updates
    mv /var/lib/dpkg/lock.suspended    /var/lib/dpkg/lock
    mv /var/lib/dpkg/updates.suspended /var/lib/dpkg/updates
    mv /var/cache/apt/archives/lock.suspended /var/cache/apt/archives/lock
    mv /var/lib/dpkg/status.suspended  /var/lib/dpkg/status
    mv /var/lib/dpkg/status-orig /var/lib/dpkg/status-old
}

_add_status_apt_queue()
{
    cp /var/lib/dpkg/status /var/lib/dpkg/status-append
    diff="$(busybox diff -u /var/lib/dpkg/status-orig /var/lib/dpkg/status-append | \
        busybox awk '/^\+/ {if($1 == "+++") {next}; sub(/^\+/,""); print}')"

    #it's important to add an additional \\n at the end to ensure the
    #format doesn't get weird after several invocations
    [ -z "${diff}" ] || printf "%s\\n\\n" "${diff}" >> /var/lib/dpkg/status-append-queue

    for pkg; do
        [ -f /var/lib/dpkg/status-remove-queue ] || continue
        busybox sed -i '/^'"${pkg}"'$/d' /var/lib/dpkg/status-remove-queue
    done; unset pkg
}

_rm_status_apt_queue()
{
    for pkg; do
        printf "%s\\n" "${pkg}" >> /var/lib/dpkg/status-remove-queue
    done; unset pkg
}

_append_status_db()
{
    [ -f /var/lib/dpkg/status-append-queue ] || return

    while [ -f /var/lib/dpkg/lock-custom ]; do sleep 0.1; done
    touch /var/lib/dpkg/lock-custom

    while busybox ps -o comm,pid | busybox grep apt-get >/dev/null 2>&1; do
        sleep 0.1
    done

    cat    /var/lib/dpkg/status-append-queue >> /var/lib/dpkg/status
    rm -rf /var/lib/dpkg/status-append-queue /var/lib/dpkg/status-append

    rm -rf /var/lib/dpkg/lock-custom
}

_remove_status_db()
{
    [ -f /var/lib/dpkg/status-remove-queue ] && sleep 0.1 || return

    while [ -f /var/lib/dpkg/lock-custom ]; do sleep 0.1; done
    touch /var/lib/dpkg/lock-custom

    while busybox ps -o comm,pid | busybox grep apt-get >/dev/null 2>&1; do
        sleep 0.1
    done

    for pkg in $(cat /var/lib/dpkg/status-remove-queue); do
        busybox sed -i '/Package: '"${pkg}"'$/,/^$/d' /var/lib/dpkg/status
    done; rm -rf /var/lib/dpkg/status-remove-queue

    rm -rf /var/lib/dpkg/lock-custom
}

_apt_install()
{
    [ -z "${1}" ] && return
    _suspend_dpkg_process
    apt-get install --no-install-recommends -y --force-yes ${@}
    _add_status_apt_queue ${@}
    _continue_dpkg_process
}

_apt_purge()
{
    [ -z "${1}" ] && return
    _suspend_dpkg_process
    cat /var/lib/dpkg/status-append-queue >> /var/lib/dpkg/status
    apt-get purge -y     ${@}
    _rm_status_apt_queue ${@}
    _continue_dpkg_process
}

_apt_sync_db()
{
    _append_status_db &
    _remove_status_db &
}

_apt_install additional packages
_apt_purge   ugly packages
_apt_sync_db
</pre>

Not the most elegant solution but it's works, I'll leave it like that until I find a better alternative or change base distros.

Happy experimentation &#128523;
