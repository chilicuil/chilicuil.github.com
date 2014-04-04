---
layout: post
title: "sincronizar clipboards entre X y gnome"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

Es un problema tener varios portapapeles @.@, así que he agregado las siguientes dos líneas en **~/.xsession** para mantenerlos sincronizados, ahora si selecciono algo en urxtv y paso a firefox, puedo pegar lo que seleccione con Ctrl-v y al revés pegando con Ctrl-Insert o botón de enmedio del ratón, ehh, un poco más cómodo...

<pre class="sh_sh">
autocutsel &amp;
autocutsel -s PRIMARY &amp;
</pre>
