---
layout: post
title: "watch_battery"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

**[![](/assets/img/40.png)](/assets/img/40.png)**

I made a little [script](https://github.com/chilicuil/learn/blob/master/sh/tools/watch-battery) to look after my laptop battery so it doesn't shutdown at the middle of me working. It requieres **notify-send**, **hibernate** and **acpi,** and targets Ubuntu:

<pre class="sh_sh">
$ sudo apt-get install acpi libnotify-bin hibernate
</pre>

**WARNING:** For the hibernation to work the computer requires to have enough SWAP space (more than the amount of RAM)

The scripts analyze the battery status and send notifications if the charge is less than 15%,10% or 7%, if the equipment reaches 5% it sends a final warning and hibernate the machine.

I recommend to execute it every minute, a cron job can help:

<pre class="sh_log">
*/1 * * * * /usr/local/bin/watch_battery
</pre>

If you prefer to shutdown or suspend the equipment modify the **$ACTION** variable:

<pre class="sh_sh">
# Actions
ACTION="$(command -v hibernate)"
</pre>

Make sure **sudo** can call the action command without requering password:

<pre class="sh_properties">
#===================================
# Cmnd alias specification
Cmnd_Alias SESSION=/usr/sbin/pm-suspend,/usr/sbin/hibernate,/sbin/shutdown

# usuario may use specific commands without passwd
user ALL=(root) NOPASSWD:SESSION
#===================================
</pre>

Special thanks to [smasty](http://forums.debian.net/viewtopic.php?f=8&amp;t=52115#p299406) for the initial snippet.

- [https://gist.github.com/913004](https://gist.github.com/913004)
