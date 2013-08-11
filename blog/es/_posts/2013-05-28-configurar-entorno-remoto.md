---
layout: post
title: "configuración de un entorno remoto"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

Tener una configuracion personalizada es una arma de doble filo, por una lado, puedes ser más eficiente con ella (o tener la sensación), y por otro, te vuelves torpe en otros sistemas.

En mi caso, me pasan ambas, me he vuelto dependiente y torpe en otras configuraciones, asi que con frecuencia termino descargando y aplicando mis cambios en servidores remotos, esto toma tiempo, asi que he decidido automatizarlo y desarrollar una dependencia total:

<pre class="sh_sh">
$ bash $(wget -qO- javier.io/s)
</pre>

**[![](/assets/img/73.png)](/assets/img/73.png)**

Algunos de los cambios, son:

    [+] Instalacion de: byobu, vim-nox, curl, html2txt, etc (no mas de 20 aplicaciones)
    [+] Eliminacion de programas no esenciales, sendemail, apache, etc
    [+] $PS1 coloreada con acortamiento de direcciones, historial eterno, modo VI en bash, +100 aliases (ver .alias* y .bashrc)
    [+] Vim amigable y con modos adicionales para redactar cartas (ingles|español), desarrollar y hacer presentaciones (ver ~/.vimrc)
    [+] Wcd como reemplazo a cd
    [+] +50 scripts en /usr/local/bin:
        [+] pastebin, $ cat archivo | pastebin
        [+] extract, $ extract archivo.comprimido
        [+] fu-search, $ fu-search comando #busca ejemplos
        [+] rm_, $ rm archivo && rm -u archivo #envia a papelera en lugar de eliminar archivos
        [+] timg, $ timg imagen.png #sube imagen
        [+] ...

Por defecto hace backup de cualquier archivo antes de sobreescribirlo (.old), asi que pueden probarlo sin perder sus cambios, si deciden usarlo no me hago responsable por ningun daño. El script se encuentra en:

- [https://github.com/chilicuil/chilicuil.github.com/blob/master/s](https://github.com/chilicuil/chilicuil.github.com/blob/master/s)

Pueden modificarlo y enviar su push request =)
