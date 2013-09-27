---
layout: post
title: "cambiar el anillo de claves para pbuilder"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

Nada, en el viaje semi eterno que sigo recorriendo para convertirme en desarrollador de Ubuntu me encuentro con problemas particulares del sistema dpkg. Esta vez mientras trabajaba con pbuilder he encontrado el siguiente error:

<pre>
I: Distribution is sid.
I: Building the build environment
I: running debootstrap
/usr/sbin/debootstrap
I: Retrieving Release
I: Retrieving Release.gpg
I: Checking Release signature
E: Release signed by unknown key (key id 8B48AD6246925553)
</pre>

Lo que significa que pbuilder (espeficamente debootstrap no ha podido verificar que 8B48AD6246925553 sea una llave de confianza, por defecto, pbuilder en Ubuntu revisa en: **/usr/share/keyrings/ubuntu-archive-keyring.gpg**. Esta variable esta definida en: **/usr/share/pbuilder/pbuilderrc**

Analizando el problema, parece un tanto logico que una llave publica de Debian no se encuentre en el anillo de confianza de Ubuntu (hay que probar muchos paquetes de Ubuntu contra versiones en desarrollo de Debian, quien dijo que desarrollar Ubuntu era facil?). Para solucionarlo se puede agregar la llave **8B48AD6246925553** al anillo de seguridad:

<pre>
$ gpg --no-default-keyring --keyring /usr/share/keyrings/ubuntu-archive-keyring.gpg --recv-keys 8B48AD6246925553
$ sudo DIST=sid ARCH=amd64 pbuilder create
</pre>

O agregarlo a algun otro anillo, y luego usar temporalmente ese anillo en pbuilder...

<pre>
$ gpg --no-default-keyring --keyring /etc/apt/trusted.gpg --recv-keys 8B48AD6246925553
$ tail $HOME/.pbuilderrc
DEBOOTSTRAPOPTS=(
 '--variant=buildd'
 '--keyring' '/etc/apt/trusted.gpg'
)
$ sudo DIST=sid ARCH=amd64 pbuilder create
</pre>

Ojala pueda conseguir esta meta antes de quedarme ciego n_n!
