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

Y poco después me doy cuenta que hubiera preferido no hacerlo, con esto en mente me puse a hacer un pequeño [script](https://github.com/chilicuil/learn/blob/master/sh/rm_) alrededor de rm para enviar los archivos a la papelería en lugar de eliminarlos, lo he hecho compatible con nautilus.

Ejemplo: Elimino desde terminal **$ rm imagen.png** y luego desde nautilus voy a papelería y lo restauro, o viceversa, lo puedo eliminar desde la papelería y cuando esté en la consola lo recupero con **$ rm -u imagen.png**

[![alt text](/assets/img/53.png)](/assets/img/53.png)

Para usarlo lo he movido a **/usr/local/bin** y luego he creado un alias en **~/.bashrc**:

<pre class="sh_sh">
$ alias rm='/usr/local/bin/rm'
</pre>
