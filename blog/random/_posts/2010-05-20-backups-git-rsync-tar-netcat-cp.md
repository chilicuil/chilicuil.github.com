---
layout: post
title: "backups: git, rsync, tar, netcat y cp"
---

## {{ page.title }}
<p class="date">{{ page.date | date_to_string }}</p>

<div class="p">Mi sistema de backups es realmente malo, no me siento particularmente orgulloso de decirlo pero es la verdad, cada vez que me acuerdo de propagarlo (si es que lo hago), me pongo a buscar los comandos para hacerlo y al finalizar siempre olvido las opciones, por lo que tengo que volver a buscarlas. Así que un primer paso será dejarlos por aquí para tenerlos a la vista rápidamente, en lo que me decido a hechar todo esto a la basura y configurar algo que valga la pena. Las propuestas son bienvenidas.
</div>

<h3>git</h3>

<div class="p">Soy el afortunado dueño de 3 equipos, 1 laptop (que uso mayormente para hacer pruebas), 1 netbook (a la que traigo para todos lados) y 1 workstation (que casi no prendo). Hago un uso razonable de la consola, por lo que mis dotfiles tienen que estar en sincronia la mayor parte del tiempo, es raro el día que no agregue un alias o configure cualquier cosita. Soy un obsesivo. Otra de las cosas que muy comunmente cambio son pequeños scripts en bash, python o perl (estos últimos los voy encontrando), son cambios muy tontos y pequeños, pero ya me acostumbre a muchos de ellos. Esto no se limita a estas máquinas, cuando necesito usar una computadora por más de un par de dias tengo que hacer un 'git clone' para sentirme confortable, no puedo vivir sin colores!.
</div>

<div class="p">Así que he creado un par de repositorios para seguirles el rastro:
</div>

<pre class="sh_sh">
#para cuando estoy en una máquina que no me pertenece (lectura)
$ git clone git://github.com/chilicuil/dotfiles.git 
$ git clone git://github.com/chilicuil/learn.git

#para cuando estoy en una máquina de confianza (lectura+escritura)
$ git clone git@github.com:chilicuil/dotfiles.git 
$ git clone git@github.com:chilicuil/learn.git
</pre>

<div class="p">Me parece indispensable agregar a .gitconfig:
</div>

<pre class="sh_properties">
[branch "master"]
    remote = origin
    merge  = refs/heads/master
</pre>

<div class="p">De lo contrario git siempre encontrara la forma de hacerme la vida miserable en el momento menos oportuno, alguien ha dicho que git es como tu mejor amigo que te odia en secreto. También hay que irse con cuidado con <strong>.gitignore</strong> no es muy lógico desde mi punto de vista.
</div>

<div class="p">Una vez configurado, puedo hacer <strong>git push</strong> y <strong>git pull</strong> en cualquier de las máquinas, y todas mantienen la última versión. Creo que este es el sistema que menos apesta , desafortunadamente no me ayuda mucho cuando se trata de más de unos cuantos megas.
</div>

<h3>rsync</h3>

<div class="p">Para complicarme menos las cosas uso la misma estructura en las 3 computadoras y en cualquier otra en la que tenga pensado pasar un buen tiempo. Umm, en realidad manejo directorios 'principales' que siempre deben estar sincronizados (en teoria), como <strong>code,</strong>, <strong>misc</strong> (donde pongo trabajo propio y backups de otras máquinas) y <strong>data</strong> (donde pongo películas, libros, música, imgs, etc).<br><br>

Algunos dotfiles importantes, como .mozilla .compiz .e .gnome* .gtk* .mutt* .ssh* .purple .VirtualBox .ecomp .gconf, no los integro en git porque son muy pesados pero trato de mantener una sola versión de ellos.
</div>

<div class="p">Por lo más 1 vez por semana o cada vez que requiera algo de otra máquina, utilizo los siguientes comandos, intento verificar antes que rsync no me sorprenda listandolos con la opción <strong>-n</strong>. Uso rsync porque fácilmente son 100Gb, y su diferencial es lo más rápido que he encontrado.
</div>

<pre class="sh_sh">
#también uso el mismo usuario en todos los equipos
$ rsync -e "ssh -p 1001" -av --delete misc/ ndia:/home/chilicuil/misc   
$ rsync -e "ssh -p 1001" -av --delete misc/ mater:/home/chilicuil/misc
$ rsync -e "ssh -p 1001" -av --delete misc/ buzz:/home/chilicuil/misc
===== AQUÍ EL MISMO COMANDO PARA EL RESTO DE DIRECTORIOS X 3 =====
</pre>

<h3>tar</h3>

<div class="p">Bien podría decirse que estas 3 computadoras son las principales, entre ellas son jerarquicamente iguales, los datos se comparten por igual.
</div>

<div class="p">Sin embargo en casa tengo otras 3 (regaladas, pentium 3) que me sirven para hacer pruebas, ahorita mismo corren las 3 versiones principales de los bsd. Cada una, tiene crontabs que hacen backups locales.
</div>

<h3>netcat</h3>

<div class="p">Tengo entonces en cada máquina un directorio .backup en /home/usuario/, cada mes mas o menos, copio los directorios hacia alguna de las 3 máquinas en ~/misc/conf/sistema, donde sistema es la distribucion o sistema operativo que corre, existen carpetas como: ubuntu, ubuntu-netbook, ubuntu-server, etc. Al estar dentro de los directorios 'importantes' dentro de una de las máquinas 'principales', tarde o temprano las copiare a las otras 2.
</div>

<div class="p">Dentro del objetivo:
</div>

<pre class="sh_sh">
$ tar czf - /home/usuario/.backup | nc -l 9999
</pre>

<div class="p">Dentro de una de mis maquinas de confianza:
</div>

<pre class="sh_sh">
$ nc remote 9999 | pv -bep \
  > ~/misc/conf/sistema/sistema-$(date +%Y-%m-%d).tar.gz
</pre>

<h3>cp</h3>

<div class="p">Finalmente cuando he sincronizado las remotas y las principales, me aseguro que el último 'snapshot' este en la workstation, ahí conecto un disco duro externo por usb. Esto lo hago cada 3-4 meses, para lo cual el backup anterior ya no es muy útil. El disco es de 150 Gb, por lo que solo le cabe 1 captura.
</div>

<pre class="sh_sh">
$ sudo rm -rf /media/hd/*
$ sudo cp -av /home /opt /media/hd
</pre>

<div class="p">Graficamente creo que se vería así:
</div>

<div style="text-align: center;">
<a href="/assets/img/35.png" target="_blank"><img src="/assets/img/35.png"></a>
</div>

<div class="p">También esta el tema del blog, originalmente no tenia una forma de hacer backup, pero ahora que ha sido movido a github, ya no tengo que preocuparme por el.
</div>
