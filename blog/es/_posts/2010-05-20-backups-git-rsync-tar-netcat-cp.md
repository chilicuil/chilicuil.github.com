---
layout: post
title: "backups: git, rsync, tar, netcat y cp"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

Mi sistema de backups es realmente malo, cada vez que me acuerdo de propagarlo (si es que lo hago), me pongo a buscar los comandos para hacerlo y al finalizar siempre olvido las opciones, por lo que tengo que volver a buscarlas. Así que un primer paso será dejarlos por aquí para tenerlos a la vista rápidamente, en lo que me decido a echar todo esto a la basura y configurar algo que no sea tan pesado. Las propuestas son bienvenidas.

**Actualización Feb/2014**

Ya no es tan malo, tengo un script que copio en las maquinas que quiera respaldar, los datos de esas computadoras se sincronizan a backup.javier.io, cada computadora tiene su carpeta. Las utilidades y configuraciones siguen en git, y he creado scripts para configurar nuevos equipos. El blog sigue en github, y me deshice del disco duro externo. Ya no hago backups de forma conciente, así que ya no esta el factor humano en mi contra. Podría mejorar, si consiguiera mas espacio en linea podria guardar mas de 1 version de los archivos locales, o sincronizarlos con otro servidor, en el caso de que estalle el data center del primero. La recuperacion de archivos es ineficiente (ejecuto un servidor web cada vez que quiero un archivo) y podría instalar un sistema de monitoreo. Las ideas, siguen siendo bienvenidas.

### git

Tengo 3 equipos, 1 laptop (que uso cuando estoy en casa), 1 netbook (para hacer pruebas) y 1 workstation (que ya no prendo). Hago un uso razonable de la consola, así que intento mantener los dotfiles sincronizados, es raro el día que no agregue un alias o configure cualquier cosita. Soy un obsesivo. Tambien me gusta escribir pequeñas utilidades para no repetir procesos o para evitar usar interfaces graficas y web (me gustan los sistemas minimalistas, creo que porque son mas estables (no se desconfiguran porque hay menos programas instalados, menos probabilidades de que algo vaya mal).

He creado un par de repositorios para seguirles el rastro:

<pre class="sh_sh">
$ git clone http://github.com/chilicuil/dotfiles.git 
$ git clone http://github.com/chilicuil/learn.git
</pre>

Como estan en git, puedo usar **git push** y **git pull** para mantenerme en la ultima version.

### rsync

Para complicarme menos las cosas uso la misma estructura en las 3 computadoras y en cualquier otra en la que tenga pensado pasar un buen tiempo. Manejo directorios 'principales' que van con mi estilo de organizar las cosas, **code,**, **misc** y **data**. Todo lo que tenga que hacer por mas de 2 días lo pongo en misc, programas personales en code, musica, fotos y videos en data y cualquier otra cosa en **$HOME**.

Algunos dotfiles importantes, como .mozilla .compiz .e .gnome* .gtk* .mutt* .ssh* .purple .VirtualBox .ecomp .gconf, no los pongo en github porque son muy grandes.

Cada vez que requiero algo de otra computadora, utilizo los siguientes comandos:

<pre class="sh_sh">
#uso el mismo usuario en todos los equipos
$ rsync -e "ssh -p 1001" -av --delete misc/ ndia:$HOME/misc
$ rsync -e "ssh -p 1001" -av --delete code/ mater:$HOME/code
$ rsync -e "ssh -p 1001" -av --delete data/ buzz:$HOME/data
</pre>

### tar

Bien podría decirse que estas 3 computadoras son las principales, entre ellas son jerarquicamente iguales, los datos se comparten por igual.

Sin embargo en casa tengo otras 3 (regaladas, pentium 3) que me sirven para hacer pruebas, ahorita mismo corren las 3 versiones principales de los bsd. Cada una, tiene crontabs que hacen backups locales.

### netcat

En cada computadora se encuentra un .backup en $HOME, cada mes mas o menos, copio los directorios hacia alguna de las 3 máquinas en ~/misc/conf/sistema, donde sistema es la distribucion o sistema operativo que corre, existen carpetas como: openbsd-nick, freebsd-nick, ubuntu-nick, etc. Al estar dentro de los directorios 'importantes' dentro de una de las máquinas 'principales', tarde o temprano se copiaran a las otras 2.

Dentro del objetivo:

<pre class="sh_sh">
$ tar czf - /home/usuario/.backup | nc -l 9999
</pre>

Dentro de una de mis maquinas de confianza:

<pre class="sh_sh">
$ nc remote 9999 | pv -bep \
  > ~/misc/conf/sistema/sistema-$(date +%Y-%m-%d).tar.gz
</pre>

### cp

Finalmente cuando he sincronizado las remotas y las principales, me aseguro que el último 'snapshot' este en la workstation (o en la computadora que más tiempo este usando en ese momento), ahí conecto un disco duro externo por usb. Esto lo hago cada 3-4 meses, para lo cual el backup anterior ya no es muy útil. El disco es de 150 Gb, por lo que solo le cabe 1 captura.

<pre class="sh_sh">
$ sudo rm -rf /media/hd/*
$ sudo cp -av /home /opt /media/hd
</pre>

Graficamente creo que se vería así:

**[![](/assets/img/35.png)](/assets/img/35.png)**

También esta el tema del blog, originalmente no tenia una forma de hacer backup, pero ahora que esta en github ya no tengo que preocuparme por el.
