---
layout: post
title: "rm + papelería"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

Nada, a veces me pasa que hago:

<pre class="sh_sh">
$ rm foo
</pre>

Y poco después me doy cuenta que hubiera preferido no hacerlo, con esto en mente me puse a hacer un pequeño [script](https://github.com/chilicuil/learn/blob/master/sh/tools/rm_) alrededor de rm para enviar los archivos a la papelería en lugar de eliminarlos, lo he hecho compatible con nautilus.

Ejemplo: Elimino desde la terminal un archivo **$ rm imagen.png** y luego desde nautilus voy a la papelera y lo restauro, o viceversa, lo puedo eliminar desde la papelera y cuando esté en la consola lo recupero con **$ rm -u imagen.png**

**[![](/assets/img/53.png)](/assets/img/53.png)**

Para usarlo lo he movido a **/usr/local/bin** y luego he creado un alias en **~/.bashrc**:

<pre class="sh_sh">
$ alias rm='/usr/local/bin/rm'
</pre>

<iframe class="showterm" src="http://showterm.io/0a5b334fd24f82bd5ede1" width="640" height="350">&nbsp;</iframe> 
<br />
