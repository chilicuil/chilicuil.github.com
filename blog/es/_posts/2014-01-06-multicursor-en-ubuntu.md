---
layout: post
title: "multicursor en ubuntu"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

**[![](/assets/img/88.png)](/assets/img/88.png)**

Durante las últimas vacaciones me encontré en una situación donde tuve que compartir mi laptop con otras personas. Sabía de un tiempo se podian habilitar mas dispositivos de entrada en Ubuntu sin embargo nunca lo había hecho.., hasta ahora =)

En el lugar a donde fuí, tuve acceso a una [pantalla](/assets/img/89.jpg) y a un [mouse](/assets/img/90.jpg) extra (adoro ese mouse). Supongo que no tiene mucho sentido hacer esto cuando se tiene solo una pantalla...

En [i3](http://i3wm.org/) se puede agregar otro monitor con el comando:

<pre>
$ xrandr --output VGA1 --mode 1680x1050 --right-of LVDS1
</pre>

Si el monitor es HDMI se usa *HDMI1*, si la imagen se desea ampliar a la izquierda se usa *--left-to*, el resto de las opciones se encuentran en el manual (**man xrandr**).

Para habilitar el mouse extra, se usa **xinput** (solo en versiones superiores a 1.7 de Xorg, Ubuntu 12.04 y posteriores):

<pre>
$ xinput create-master Auxiliary
$ xinput list #para obtener el id del mouse extra
$ xinput reattach 10 "Auxiliary pointer" #en su caso, el ID puede ser diferente
</pre>
 
La configuración final de mi equipo fué:

<pre>
xinput list
⎡ Virtual core pointer                    	id=2	[master pointer  (3)]
⎜   ↳ Virtual core XTEST pointer              	id=4	[slave  pointer  (2)]
⎜   ↳ Microsoft Microsoft® Nano Transceiver v1.0	id=11	[slave  pointer  (2)]
⎜   ↳ SynPS/2 Synaptics TouchPad              	id=14	[slave  pointer  (2)]
⎜   ↳ TPPS/2 IBM TrackPoint                   	id=15	[slave  pointer  (2)]
⎣ Virtual core keyboard                   	id=3	[master keyboard (2)]
    ↳ Virtual core XTEST keyboard             	id=5	[slave  keyboard (3)]
    ↳ Power Button                            	id=6	[slave  keyboard (3)]
    ↳ Video Bus                               	id=7	[slave  keyboard (3)]
    ↳ Power Button                            	id=8	[slave  keyboard (3)]
    ↳ Microsoft Microsoft® Nano Transceiver v1.0	id=9	[slave  keyboard (3)]
    ↳ Integrated Camera                       	id=12	[slave  keyboard (3)]
    ↳ AT Translated Set 2 keyboard            	id=13	[slave  keyboard (3)]
    ↳ ThinkPad Extra Buttons                  	id=16	[slave  keyboard (3)]
⎡ Auxiliary pointer                       	id=17	[master pointer  (18)]
⎜   ↳ Microsoft Microsoft® Nano Transceiver v1.0	id=10	[slave  pointer  (17)]
⎜   ↳ Auxiliary XTEST pointer                 	id=19	[slave  pointer  (17)]
⎣ Auxiliary keyboard                      	id=18	[master keyboard (17)]
    ↳ Auxiliary XTEST keyboard                	id=20	[slave  keyboard (18)]
</pre>

Parece ser que el proceso es similar para los teclados, pero eso ya no lo verifique (tal vez debería comenzar a cargar teclados extra =P). La experencia en general fue buena, el soporte de i3 para multi punteros no esta mal, aunque de repente pueda existir confusión, es manejable. Por otra parte, me causo alegría ver que el [entorno minimalista](http://javier.io/blog/es/2012/05/03/actualizacion-ubuntu-1204.html) que uso no fue impedimento para que otras personas usaran el equipo =D

- [https://wiki.archlinux.org/index.php/Multi-pointer_X](https://wiki.archlinux.org/index.php/Multi-pointer_X)
