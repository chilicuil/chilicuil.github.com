---
layout: post
title: "less is more, and even more with color"
---

## {{ page.title }}
<p class="date">{{ page.date | date_to_string }}</p>

<div style="text-align: center;"><img style="width: 327px; height: 243px;" src="/assets/img/1.jpg"></div>

<div class="p">No tenia idea de  que la salida de less se podia colorear, es decir a quien no le ha pasado que quiera listar "ls -la" todo el directorio y la salida es tan larga que tiene que recurrir a less, perdiendo con ello el color. Mucho menos estaba enterado de que la salida de man tambien tuviera esta caracteristica, ni tree o similares, la solucion es bien sencilla y probablemente la hubiera descubierto antes si me hubiera leido las respectivas man con cuidado y que sin embargo he encontrado de forma super clara en "Linux desktop hacks", que ademas trae chorrocientos de otros truquillos que podrian interesarles.
</div>

<div class="p">Para listar a traves de less sin perder el color, basta con:
</div>

<pre class="sh_sh">
$ ls -la --color |less -R
</pre>

<div style="text-align: center;"><img style="width: 437px; height: 217px;" src="/assets/img/2.png"></div>

<div class="p">Para usarlo con man, hay que agregar esto a  ~/.bashrc
</div>

<pre class="sh_sh">
# Less Colors for Man Pages
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
</pre>

<div style="text-align: center;"><img style="width: 435px; height: 227px;" src="/assets/img/3.png"></div>

<div class="p">Y para usarlo con tree, supongo que el resto de comandos, al menos los que producen alguna salida muy verbosa, trae una opcion similar:
</div>

<pre class="sh_sh">
$ tree -Ca /sys/ |less -R
</pre>

<div style="text-align: center;"><img style="width: 434px; height: 242px;" src="/assets/img/4.png"></div>

<div class="p">Pueden encontrar mas de esos codigos raros que se ponen en ~/.bashrc en <a href="http://ascii-table.com/ansi-escape-sequences.php">http://ascii-table.com/ansi-escape-sequences.php</a>
</div>
