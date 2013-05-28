---
layout: post
title: "configuración de un entorno remoto"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

Tener una configuracion demasiado personalizada es una arma de doble filo, por una lado, puede que seas mas eficiente con ella (o que se tengas la sensacion de ello), y por otro, te puedes sentir torpe en otros entornos.

En mi caso, me pasan ambas, me he vuelto dependiente y torpe en otros entornos, asi que con frecuencia descargo mis cambios y los introduzco en servidores remotos, esto toma tiempo, asi que he decidido automatizarlo y desarrollar una dependencia total:

<pre class="sh_sh">
$ bash $(wget -qO- javier.io/s)
</pre>

**[![](/assets/img/73.png)](/assets/img/73.png)**

Algunos de los cambios que introduzco, son:

    [+] instalacion de: byobu, vim-nox, curl, html2txt, sendemail, etc (no mas de 20 programas para terminal)
    [+] $PS1 coloreada y con acortamiento de direcciones largas, +100 aliases (ver .alias* y .bashrc)
    [+] Un vim amigable y con modos adicionales para redactar cartas (ingles|español), desarrollo y presentacion (ver ~/.vimrc)
    [+] Wcd como reemplazo a cd, desde ahora si tienen ~/dir1/dir2 pueden ir a dir2 asi: $ cd dir2
    [+] +50 scripts en /usr/local/bin con cosas como:
        [+] pastebin, $ cat archivo | pastebin
        [+] extract, $ extract archivo.comprimido
        [+] fu-search, $ fu-search comando #busca ejemplos
        [+] rm_, $ rm archivo && rm -u archivo #envia a papelera en lugar de eliminar archivos
        [+] timg, $ timg imagen.png #sube imagen
        [+] ...

Por defecto, hace backup de cualquier dotfile antes de sobreescribirlo (.old), asi que si quieren pueden probarlo, aunque no me hago resopnsable por ningun daño que provoque. El repositorio se encuentra en:

- https://github.com/chilicuil/chilicuil.github.com/blob/master/s

Sientanse libres de modificarlo y de enviar su push request.
