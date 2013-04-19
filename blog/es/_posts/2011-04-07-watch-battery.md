---
layout: post
title: "watch_battery"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

**[![](/assets/img/40.png)](/assets/img/40.png)**

Hice un pequeño [script](https://gist.github.com/913004) para vigilar que no se me apague la computadora cuando ya no tenga pila (mejor que hiberne), requiere de **notify-send**, **hibernate** y **acpi,** en ubuntu:

<pre class="sh_sh">
$ sudo apt-get install acpi libnotify-bin hibernate
</pre>

NOTA: Para que pueda hibernar el equipo debe contar con suficiente espacio SWAP (más de 3 GB). Sugiero que se coloque en /usr/local/bin y que se agregue a crontab -e (aquí para que corra cada 3 minutos)

<pre class="sh_log">
*/3 * * * * /usr/local/bin/watch_battery
</pre>

Para apagar el equipo en lugar de hibernarlo, se modifica la variable **$ACTION**

<pre class="sh_sh">
#=====VARS=====
# Current battery status (Charging/Discharging/AC/Unknown)
STAT=$(acpi -b | awk '{print $3}' | awk 'sub(".$", "")')
# Battery percentage
BATT=$(acpi -b | awk '{print $4}' | awk 'sub("..$", "")')
# Actions
ACTION="hibernate"
WATCH_BATTERY_CURRENT=$(cat /tmp/watch_battery_current 2>/dev/null)
</pre>

Sugiero que se modifique **/etc/sudoers** para que el script no requiera de contraseña para llevar a cabo **$ACTION**

<pre class="sh_properties">
#===================================
# Cmnd alias specification
Cmnd_Alias SESSION=/usr/sbin/pm-suspend,/usr/sbin/hibernate,/sbin/shutdown

# usuario may use specific commands without passwd
usuario ALL=(root) NOPASSWD:SESSION
#===================================
</pre>

Gracias a [smasty](http://forums.debian.net/viewtopic.php?f=8&amp;t=52115#p299406) por el snippet inicial.

- <https://gist.github.com/913004>
