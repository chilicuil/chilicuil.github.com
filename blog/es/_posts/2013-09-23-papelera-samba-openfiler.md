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
 
<pre>
/* papelera - auditoria */
$ac_smb_fp-&gt;AddLine( "\n");
$ac_smb_fp-&gt;AddLine( " ; papelera - auditoria");
$ac_smb_fp-&gt;AddLine( " vfs objects = audit recycle" );
$ac_smb_fp-&gt;AddLine( " recycle: repository = /ruta/.papelera " );
$ac_smb_fp-&gt;AddLine( " recycle: keeptree = Yes" );
$ac_smb_fp-&gt;AddLine( " recycle: exclude = *.tmp, *.temp, *.log, *.ldb" );
$ac_smb_fp-&gt;AddLine( " recycle: exclude_dir = tmp " );
$ac_smb_fp-&gt;AddLine( " recycle: versions = Yes " );
$ac_smb_fp-&gt;AddLine( " recycle: noversions = *.docx|*.doc|*.xls|*xlsx|*.ppt|*.odt" );
$ac_smb_fp-&gt;AddLine( "\n");
/* termina configuracion de la papelera */
</pre>

Adicionalmente, se puede configurar un trabajo en cron para eliminar los archivos mas viejos de X dias:

<pre>
0 6 * * * root    find /ruta/.papelera -type f -mtime +14 -delete &gt; /dev/null
</pre>
