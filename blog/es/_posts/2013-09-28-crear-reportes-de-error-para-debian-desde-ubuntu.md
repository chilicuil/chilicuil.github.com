---
layout: post
title: "reportar errores en debian desde ubuntu"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

**[![](/assets/img/79.png)](/assets/img/79.png)**

Soy una persona normal, no corro servidores de correo en mi computadora personal (tengo mi cuenta con gmail), esto es un problema si quieres interactuar con el sistema de reportes de Debian, un sistema antiquisimo basado en correos electronicos.

Para reportar un problema en Debian desde Ubuntu se usa **reportbug -B debian paquete** sin embargo si se ejecuta después de instalarse (y despues de perder 10-15 minutos a traves de su interfaz) el reporte no se enviara porque no habra encontrado un servidor de correo local.

Para solucionarlo, y mientras el sistema BTS no tenga una alternativa moderna (escuche que se esta trabajando en una nueva plataforma basada en django.., no pudieron adaptar launchpad?...), se debe reconfigurar reportbug:

<pre>
$ reportbug --configure
</pre>

Y asegurarse de introducir los siguientes datos:

- smtp.gmail.com:587
- usuario@gmail.com
- habilitar tls

O los datos de su proveedor.., una vez finalizado este paso se generara un archivo en *$HOME/.reportbugrc*, si se ha creado, se puede volver a lanzar reportbug:

<pre>
$ reportbug -B debian paquete
</pre>

Y con un poco de suerte, esta vez se podran crear|editar reportes...

### extra

En el caso de que el reporte fuese a contener un parche, y despues de haber configurado *reportbug*, se puede usar **submittodebian** para enviar el reporte. Usar *submittodebian* en lugar de *reportbug* tiene sus ventajas cuando se trata de reenviar parches.

- Agrega [etiquetas](https://wiki.ubuntu.com/Debian/Usertagging)
- Permite editar el parche antes de enviarlo (para quitar las partes que se refieren a Ubuntu)
- Usa reportbug para crear el reporte

Para poder usar *submittodebian* se debe tener los archivos .orig, .diff, .changes y otros generados por *debuild*

#### apt-get source (tradicional)

<pre>
$ apt-get source xicc
$ cd cd xicc-0.2/
$ sed -i 's/colour/color/g' debian/control
$ dch -i 'debian/control: replaced "colour" with "color".'
$ debuild -S
$ submittodebian
</pre>

#### bzr (sistema centralizado)

<pre>
$ bzr branch lp:ubuntu/xicc
$ cd xicc
$ sed -i 's/colour/color/g' debian/control
$ dch -i 'debian/control: replaced "colour" with "color".'
$ bzr commit -m 'replaced "colour" with "color".'
$ bzr bd -- -S
$ submittodebian
</pre>

- [http://www.debian.org/Bugs/Reporting](http://www.debian.org/Bugs/Reporting)
- [https://wiki.ubuntu.com/Debian/Bugs](https://wiki.ubuntu.com/Debian/Bugs)
