---
layout: post
title: "xperia mini pro - custom roms"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

Nada, hace poco me he hecho de un xperia mini pro (por $2800), después de haber perdido un xperia mini =(, y este fin de semana he experimentado hasta dejarlo con una configuración aceptable (a mi gusto), así que dejo un breve resumen de los pasos que seguí para ayudarme en el futuro.

Este tutorial no debería seguirse a menos que se tenga exactamente el mismo teléfono y se desee obtener el mismo resultado.

ANTES

- Android **1.6** (SonyEricson) / **Donut**
- versión de banda base **M76XX-TSNCJOLYM-53404006**
- Modelo: u20a

[![alt text](/assets/img/41.png)](/assets/img/41.png)
[![alt text](/assets/img/42.jpeg)](/assets/img/42.jpeg)
[![alt text](/assets/img/43.png)](/assets/img/43.png)

DESPUÉS

- Android **2.3.5** (GinTonic.Se 1.3) / **Gingerbread**
- versión de banda base **M76XX-TSNCJOLYM-53404015**
- Modelo: u20i

[![alt text](/assets/img/44.png)](/assets/img/44.png)
[![alt text](/assets/img/45.png)](/assets/img/45.png)
[![alt text](/assets/img/46.png)](/assets/img/46.png)

Descarga:

- **build.prop** (útil para cambiar la banda **53404006** -&gt; **53404015**)
- **root-xrecovery_x10miniPro.exe** (rootea e instala xrecovery, requiere Windows)
- **mybackupPro.apk** (backup de contactos, sms, apps)

- <http://www.multiupload.com/4W2VJ6URER>

### FAQ

**¿Qué es android?**

Android es un sistema operativo enfocado a teléfonos y tabletas, principal competencia del sistema operativo que viene en los iphone, esta basado en linux, aunque modifica muchas partes esenciales del mismo. Tiene miles de aplicaciones, gps, reconocimiento de voz, skype, twitter, facebook, youtube, angrybirds, etc.

**¿Qué es un custom rom?**

Un custom rom es un sistema operativo modificado que reemplaza el que Sony Ericson/Telcel han puesto en tu teléfono.

**¿Cúal es la ventaja de un custom rom?**

En primer lugar que corre una versión más reciente de android, adquiriendo un aumento en el rendimiento, por ejemplo android 2.2 es dos veces más rapido que android 2.1, y android 2.3 es 25% más rapido que la versión 2.2. También puede hacer otras cosas, por ejemplo mover las aplicaciones a la memoria externa (app2sd) o compartir internet a otros dispositivos a través de usb/wifi (requiere plan de datos).

**¿Cuáles son los requerimientos?**

Tener instalado xrecovery y haber 'rooteado' el teléfono, adicionalmente se puede tener a la mano PC Companion o SEUS (sony ericson update service) para regresar el teléfono a su instalación de fabrica.

**¿Qué es 'rootear'?**

Rootear se refiere a obtener permisos de administrador, por defecto los teléfonos traen medidas de seguridad que evitan, por ejemplo, eliminar aplicaciones que vienen por defecto (muestras de juegos, ideas telcel, etc). Con un teléfono rooteado es posible eliminarlas.

**¿Qué es xrecovery?**

Xrecovery es un programa que se utiliza para instalar custom roms, se accede a el presionando la flecha &lt;- al arranque del movil (cuando aparece la leyenda 'sony ericson')

**¿Cómo se instala un custom rom?**

Los custom rom se distribuyen como archivos zip (1 archivo zip por rom), y se instalan con xrecovery

**¿Qué implicaciones legales conlleva instalar un custom rom?**

Se pierde la garantía, sin embargo el proceso puede ser revertido si es que en algún momento se requiere reinstalar la versión con la que venía el teléfono.

### Backup

Si el teléfono ya estaba siendo utilizado con anterioridad, es probable que haya datos que no se deseen perder, en el market existen aplicaciones que ayudan a hacer esto, adicionalmente de los datos que se sincronizan con la cuenta de google que se definio en el teléfono.

Personalmente utilice **mybackup pro** (sms's) y **titanium backup** (aplicaciones), mybackup pro viene incluido en el link de descarga, titanium puede adquirirse desde el market.

Para instalar aplicaciones fuera del market, hay que habilitar **'Origenes Desconocidos'**

- Ajustes/Aplicaciones/Origenes Desconocidos

### Rootear e instalar xrecovery

Existen métodos y aplicaciones que otorgan permisos e instalan xrecovery, pero el más simple que encontré fue usar 1click:

- root-xrecovery_x10miniPro.exe (viene incluido en el zip)

Para usarlo se siguen los siguientes pasos:

1. Preparar el teléfono, habilitar la "depuración USB" en **ajustes/aplicaciones/desarrollo**
2. Extraer el archivo (yo lo hice con WindRar)
3. Conectar el teléfono a la computadora
4. Abrir oneclickroot
5. Hacer click en 'root' y esperar que finalice (no debe demorar mas de 2 min)
6. Hacer click en 'xrecover' y esperar otro par de minutos
7. Reiniciar


Ahora el teléfono debería estar rooteado y tener xrecovery (se puede probar presionando la flecha al arranque - aparecerá un menú)

### Cambiar banda base

Muchos de los custom roms solo son compatibles con la versión 53404015, por lo que se tiene que actualizar a esa versión antes de volcar los roms, de lo contrario el teléfono entrará en un ciclo de reinicio infinito.

Para eso se copia

- **build.prop** a **/system**

Lo que requiere un navegador de archivos con permisos de administrador, se puede usar **'File Expert'** (accesible a través del market), aunque por defecto no esos permisos, sin embargo se puede habilitar en:

- File Expert/menu/mas/ajustes/ajustes de explorador de archivos/**explorador root**

Se reinicia el programa y se reemplaza **build.prop** por **/system**

Después de reiniciar, se conecta a una computadora, donde este corriendo PC Companion (viene incluido en el teléfono), y desde ahí se reestablece al setup de fábrica, el tiempo aproximado dependiendo de la conexión es de 40min (a 100kb/s).

Después de reiniciar el teléfono la banda base debería ser la **53404015**. Si es así se siguen los pasos de "**Rootear e instalar xrecovery**" para reinstalar los componentes necesarios.

### Instalar custom roms

Es recomendable hacer un backup del rom de fábrica, de esta manera si no convence el custom rom, se puede recuperar el sistema original, para probar con otro.

Para crear un backup se reinicia el teléfono, y se presiona la tecla que tiene una flecha, aparecerá un menú, ahí se selecciona (se mueve con las teclas de volúmen, y se selecciona con la tecla de en medio)

- backup and restore/**Backup**

Eso creará una copia de seguridad en **/sdcard/xrecovery**, para recuperarla se selecciona:

- backup and restore/**restore**

Algunos de los custom roms disponibles para el xperia mini pro, estan listados aquí:

- <http://tinyurl.com/3smura5>

Después de probar algunos, he decidido usar de forma continua **GinTonic.SE | v1.3** (120MB~), disponible en:

- <http://forum.xda-developers.com/showthread.php?t=1207740>

La instalación de este y de otros, pasa por:

1. Reiniciar el telefono
2. Entrar en xrecovery (presionar varias veces la tecla de la fecla derecha
3. Ir a **install zip from sdcard/choose zip from sdcard** y seleccionar el archivo zip
4. Esperar la instalación
5. Ir a **wipe data/factory reset**
6. Reiniciar

Con eso, arrancará el nuevo SO, se llenará el perfil (cuenta de gmail), se instalará mybackupPro/titanium y se recuperaran los datos/aplicaciones.

Estos custom roms ya viene rooteados y con xrecovery, así que no es necesario volver a correr 1click por tercera vez.

### EXTRA (intermedio)

Instalar (desde el market)

- Taskiller
- AdFree

Liberar espacio

Para mover las aplicaciones a la tarjeta externa se va a:

- **menu/administrar aplicaciones/descargadas**, luego se selecciona la aplicación y se presiona **mover a sdcard**, libera aprox el 50% del tamaño de la app.

- Otro truco es eliminar **/data/dalvik-cache** y reiniciar (libera 13~ MB)

- O eliminar la cache de los programas en **/data/data**, para saber cual app guarda más datos, se puede abrir una consola (viene incluida con el rom) y se escribe:

<pre class="sh_sh">
$ du -sk /data/data/* | sort -rn | head
</pre>

Y luego:

<pre class="sh_sh">
$ rm -rf /data/data/some_app/cache
</pre>

También se puede mover las caches de algunos programas a otros lugares, para eso se hace un softlink

<pre class="sh_sh">
$ mkdir -p /sdcard/cache/market
$ cd /data/data/com.android.vending
$ rm -R cache
$ ln -s /sdcard/cache/market cache
</pre>
