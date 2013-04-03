---
layout: post
title: "dmenu para todo"
---

## {{ page.title }}
<p class="date">{{ page.date | date_to_string }}</p>


<div class="p">Desde que uso sistemas <a href="http://chilicuil.github.com/all/random/2010/06/16/i3-ebf3.html" target="_blank">minimalistas</a> siento que tengo mayor control sobre mi computadora, una de las ventajas de tenerlo de esta forma es que puedo hacer que mi escritorio funcione justo como lo deseo. Hoy en la tarde, en vista de haberme visto abriendo constantemente VirtualBox para correr programas que no estan soportados en Ubuntu de 64 bits, se me ocurrio automatizarlo.
</div>

<div class="p">Antes de automatizarlo, abria Vbox (Alt+esc y escribia vir, lo que me devolvia la aplicacion, entonces daba enter) escogia la máquina virtual que queria correr y estaba listo. Puede parecer rápido en comparación con Ubuntu por defecto, hacer click en el Dash, escribir Vir, seleccionar VirtualBox y después la máquina virtual, pero si lo haces mas de 5 veces al día empiezas a creer que debería ser más rápido. Y así lo es, ahora presiono Altgr+v lo que me abre un menu, escribo 'net' y me completa la máquina de netflix, doy enter y listo, estoy frente a netflix listo para seleccionar la pelicula que deseo ver.
</div>

<div class="p">Nada, no puedo hacer nada más que recomendar dmenu
</div>

<h3>dmenu + virtualbox</h3>
<div class="p">Para hacerlo, se crea un script que envie a dmenu las posibles opciones
</div>

<pre class="sh_sh">
DMENU='dmenu -p > -i -nb #000000 -nf #ffffff -sb #000000 -sf #3B5998'
vboxmachine=$(vboxmanage list vms | cut -d\" -f2 | $DMENU)

if [ -z "${vboxmachine}" ]; then
    exit 0;
else
    vboxmanage -q startvm "$vboxmachine" --type gui
fi
</pre>

<div class="p">Se guarda en <strong>/usr/local/bin/</strong> y se agrega el atajo al manejador de ventanas que usen, en mi caso al ser i3-wm, lo agrego a <strong>~/.i3/config</strong>:
</div>

<pre>
# vbox:
bindsym $Altgr+v exec /usr/local/bin/dmenu_vbox
</pre>

<div class="p">Listo, se reinicia el gestor de ventanas (que por cierto mantiene todas las aplicaciones abiertas) y puedo usar este nuevo menú, ahora.., el nombre de este post es "dmenu para todo" y en mi caso así es, si tienen curiosidad para saber en que otras cosas lo utilizo (poner música, cerrar sesión, suspender el equipo, forzar a cerrar aplicaciones) pueden ver el resto de scripts (que comienzan con dmenu_*) en:
</div>

<ul>
        <li><a href="https://github.com/chilicuil/learn/tree/master/sh" target="_blank">https://github.com/chilicuil/learn/tree/master/sh</a></li>
</ul>

<div align="center" id="img">
<a href="/assets/img/61.png"><img src="/assets/img/61.png" style="width: 350px; height: 200px;"></a>
<a href="/assets/img/62.png"><img src="/assets/img/62.png" style="width: 350px; height: 200px;"></a>
<a href="/assets/img/63.png"><img src="/assets/img/63.png" style="width:  350px; height: 200px;"></a>
<a href="/assets/img/64.png"><img src="/assets/img/64.png" style="width:  350px; height: 200px;"></a>
</div>