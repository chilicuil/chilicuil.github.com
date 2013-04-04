---
layout: post
title: "less is more, and even more with color"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

![](/assets/img/1.png)

No tenia idea de  que la salida de less se podia colorear, es decir a quien no le ha pasado que quiera listar "ls -la" todo el directorio y la salida es tan larga que tiene que recurrir a less, perdiendo con ello el color. Mucho menos estaba enterado de que la salida de man tambien tuviera esta caracteristica, ni tree o similares, la solucion es bien sencilla y probablemente la hubiera descubierto antes si me hubiera leido las respectivas man con cuidado y que sin embargo he encontrado de forma super clara en "Linux desktop hacks", que ademas trae chorrocientos de otros truquillos que podrian interesarles.

Para listar a traves de less sin perder el color, basta con:

<pre class="sh_sh">
$ ls -la --color |less -R
</pre>

![](/assets/img/2.png)

Para usarlo con man, hay que agregar esto a  **~/.bashrc**

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

![](/assets/img/3.png)

Y para usarlo con tree, supongo que el resto de comandos, al menos los que producen alguna salida muy verbosa, trae una opcion similar:

<pre class="sh_sh">
$ tree -Ca /sys/ |less -R
</pre>

![](/assets/img/4.png)

Pueden encontrar mas de esos codigos raros que se ponen en ~/.bashrc en <http://ascii-table.com/ansi-escape-sequences.php>.
