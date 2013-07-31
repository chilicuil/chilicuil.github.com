---
layout: post
title: "activar extensiones en firefox nightly"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

**[![](/assets/img/78.jpg)](/assets/img/78.jpg)**

Firefox nightly es la versión de Firefox que se compila cada noche, por defecto arranca sin plugins, sin embargo pueden activarse usando el parámetro, *extensions.checkCompatibility.nightly*, los pasos detallados siguen:

1. Ir a about:config
2. Escribir *extensions.checkCompatibility.nightly*
3. Presionar el botón secundario del mouse y seleccionar 'New -&gt; Boolean'
4. Escribir nuevamente *extensions.checkCompatibility.nightly* en la ventana de Nuevo valor
5. Seleccionar 'false' como valor
6. Reiniciar Firefox

A partir de ese momento, se puede ir a about:plugins y activar los plugins que queramos.

- [Firefox nightly](http://nightly.mozilla.org/)
- [Extensions.checkCompatibility](http://kb.mozillazine.org/Extensions.checkCompatibility)
