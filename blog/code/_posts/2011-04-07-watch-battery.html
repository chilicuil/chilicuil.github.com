---
layout: post
title: "watch_battery"
---

<h2>{{ page.title }}</h2>

<div class="publish_date">{{ page.date | date_to_string }}</div>

<div style="text-align: center;" id="img">
    <a href="/assets/img/40.png" target="_blank"><img src="/assets/img/40.png" style="width: 662px; height: 421px;"></a>
</div>

<div class="p">Hice un pequeño <a href="https://gist.github.com/913004" target="_blank">script</a> para vigilar que no se me apague la computadora cuando ya no tenga pila (mejor que hiberne), requiere de <strong>notify-send</strong>, <strong>hibernate</strong> y <strong>acpi,</strong> en ubuntu:
</div>

<pre class="sh_sh">
$ sudo apt-get install acpi libnotify-bin hibernate
</pre>

<div class="p">NOTA: Para que pueda hibernar el equipo debe contar con suficiente espacio SWAP (más de 3 GB). Sugiero que se coloque en /usr/local/bin y que se agregue a crontab -e (aquí para que corra cada 3 minutos)
</div>

<pre class="sh_log">
*/3 * * * * /usr/local/bin/watch_battery
</pre>

<div class="p">Para apagar el equipo en lugar de hibernarlo, se modifica la variable <strong>$ACTION</strong>
</div>

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

<div class="p">Sugiero que se modifique <strong>/etc/sudoers</strong> para que el script no requiera de contraseña para llevar a cabo <strong>$ACTION</strong>
</div>

<pre class="sh_properties">
#===================================
# Cmnd alias specification
Cmnd_Alias SESSION=/usr/sbin/pm-suspend,/usr/sbin/hibernate,/sbin/shutdown

# usuario may use specific commands without passwd
usuario ALL=(root) NOPASSWD:SESSION
#===================================
</pre>

<div class="p">Gracias a <a href="http://forums.debian.net/viewtopic.php?f=8&amp;t=52115#p299406">smasty</a> por el snippet inicial.
</div>

  <ul>
    <li><a href="https://gist.github.com/913004">https://gist.github.com/913004</a></li>
  </ul>
