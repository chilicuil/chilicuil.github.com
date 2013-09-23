---
layout: post
title: "agregar papelera a samba en openfiler"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

En algunos casos puede ser util habilitar una papelera para archivos compartidos en un entorno samba/cifs. Lamentablemente en [openfiler](http://www.openfiler.com/) (solución nas/san para almacenamiento de archivos) no es fácil hacerlo.

### /opt/openfiler/var/www/includes/generate.inc

El archivo tradicional para establecer las preferencias de samba es /etc/samba/smb.conf, en openfiler sin embargo se modifica otro archivo para mantener los cambios despues de usar la interfaz web.

Línea 1588:

<script src="https://gist.github.com/chilicuil/6678260.js"></script>

Adicionalmente, se puede configurar un trabajo en cron para eliminar los archivos mas viejos de X dias:

<pre>
0 6 * * * root    find /mnt/vol/compartido/.papelera -type f -mtime +14 -delete &gt; /dev/null
</pre>
