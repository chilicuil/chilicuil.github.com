---
layout: post
title: "imprimir a un servidor ldp sin cups"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

Nada, he descubierto que se puede imprimir a una impresora en red que soporte [LDP](http://en.wikipedia.org/wiki/Line_Printer_Daemon_protocol) (supongo que también a una que soporte [IPP](http://es.wikipedia.org/wiki/Internet_Printing_Protocol)) sin [CUPS](http://www.cups.org/) (específicamente cups-ldp para Ubuntu).

Por alguna razón siempre habia tenido la idea de que para imprimir lo que sea a donde sea se requería de CUPS, es por eso que me ha sorprendido cuando he visto que no es así

<pre class="sh_sh">
$ rlpr -h -Plp -HIP_OF_THE_PRINTER_LDP_SERVER_HERE  file.[ps|pdf]
</pre>

En el 2011 la mayoría de aplicaciones en Linux soporta imprimir directamente hacia pdf/ps por lo que tampoco se requiere instalar cups-pdf.

Para imprimir imagenes, **convert** (parte de la suite [imagemagick](http://www.imagemagick.org/script/index.php), que también tiene cosas como **import** o **display**) puede hacer la transformación:

<pre class="sh_sh">
$ convert image.jpg  file.ps
</pre>

Y para archivos de texto plano, con vim:

<pre class="sh_sh">
:hardcopy > file.ps
</pre>

Finalmente con **alias print.192.168.1.11='rlpr -h -Plp -H192.168.1.11'** puedo hacer:

<pre class="sh_sh">
$ print.192.168.1.11  file[.ps|pdf]
</pre>

Eso cubre todas mis necesidades, aunque para efectos prácticos (o para usuarios no amantes de la consola) concuerdo que es mejor instalar CUPS, permite imprimir directamente desde las aplicaciones.

La copiadora/impresora a la que me refiero en este post es la canon ImageRunner [6570](http://usa.canon.com/cusa/support/office/b_w_imagerunner_copiers/imagerunner_5050_5055_5065_5070_5075_5570_6570/imagerunner_6570),

  - <http://www.mail-archive.com/misc@openbsd.org/msg56753.html>
  - <http://www.gnu.org/software/a2ps>
  - <http://www.wizards.de/~frank/pstill.html>
  - <http://www.ghostscript.com/>
