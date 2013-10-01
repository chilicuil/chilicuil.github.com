---
layout: post
title: "reportar errores en debian desde ubuntu"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

**[![](/assets/img/79.png)](/assets/img/79.png)**

Soy una persona normal, no corro servidores de correo en mi computadora personal (tengo mi cuenta con gmail), esto es un problema si quieres interactuar con el sistema de reportes de Debian, un sistema antiquisimo basado en correos electronicos.

Para reportar un problema en Debian desde Ubuntu se usa **reportbug -B debian paquete** sin embargo si se ejecuta después de instalarse (y despues de perder 10-15 minutos a traves de su interfaz) el reporte no se enviara por que no habra encontrado un servidor de correo local.

Para solucionarlo, y mientras el sistema BTS no tenga una alternativa moderna (escuche que se esta trabajando en una nueva plataforma basada en django.., no pudieron adaptar launchpad?...), se debe reconfigurar reportbug:

<pre>
$ reportbug --reconfigure
</pre>

Y asegurarse de introducir los siguientes datos:

- smtp.gmail.com:587
- usuario@gmail.com

O los datos de su proveedor.., una vez finalizado este paso se generara un archivo en *$HOME/.reportbugrc*, si se ha creado, se puede volver a lanzar reportbug:

<pre>
$ reportbug -B debian paquete
</pre>

Y con un poco de suerte, esta vez se podran crear|editar reportes...
