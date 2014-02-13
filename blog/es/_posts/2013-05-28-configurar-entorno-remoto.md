---
layout: post
title: "configuración de un entorno remoto"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

Tener una configuracion personalizada es una arma de doble filo, por una lado, puedes ser más eficiente con ella (o tener la sensación), y por otro, te vuelves torpe en otros sistemas.

En mi caso, me pasan ambas, me he vuelto dependiente y torpe en otras configuraciones, asi que con frecuencia termino descargando y aplicando mis cambios en servidores remotos, esto toma tiempo, asi que he decidido automatizarlo y desarrollar una dependencia total:

<pre class="sh_sh">
$ sh &lt;(wget -qO- javier.io/s)
</pre>

<iframe class="showterm" src="http://showterm.io/3bfc94afe0f51e8d6411f" width="640" height="350">&nbsp;</iframe> 

Algunos de los cambios, son:

    [+] Instalacion de: byobu, vim-nox, curl, command-not-found, libpam-captcha y htop
    [+] Eliminacion de programas no esenciales, sendemail, apache, etc
    [+] Shundle ($PS1 coloreada, historial eterno, modo VI en bash, +100 aliases, buscar por shundle en github)
    [+] Vim con modos adicionales y plugins (ver ~/.vimrc)
    [+] Wcd como reemplazo a cd
    [+] +60 scripts en /usr/local/bin:
        [+] pastebin, $ cat archivo | pastebin
        [+] extract, $ extract archivo.comprimido
        [+] fu-search, $ fu-search grep
        [+] rm_, $ rm .bashrc && rm -u .bashrc
        [+] timg, $ timg imagen.png #sube imagen
        [+] ...

Por defecto hace backup de cualquier archivo antes de sobreescribirlo (.old), asi que pueden probarlo sin perder sus cambios, si deciden usarlo no me hago responsable por ningun daño. El script se encuentra en:

- [https://github.com/chilicuil/chilicuil.github.com/blob/master/s](https://github.com/chilicuil/chilicuil.github.com/blob/master/s)

Pueden modificarlo y enviar su push request =)

- [dotfiles](https://github.com/chilicuil/dotfiles/)
- [shundle](https://github.com/chilicuil/shundle)
- [utils](https://github.com/chilicuil/learn/)
