---
layout: post
title: "usar whatsapp desde terminal en Linux"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

**[![](http://openwhatsapp.org/static/img/logo.jpg)](http://openwhatsapp.org/static/img/logo.jpg)**

Ultimamente he tenido que comunicarme a través de whatsapp (una aplicación muy popular en teléfonos moviles) y como no tengo teléfono inteligente, me ha tocado averiguar como usar el servicio desde una pc.

Los posts más populares al respecto hablan de instalar un emulador de android y luego usar whatsapp desde ahí. Sin embargo, y con mucha menos publicidad también se encuentran librerias no oficiales. Esta pues, es la forma en la que he logrado comunicarme con whatsapp desde Linux.

Wazapp es una aplicación dirigida a Blackberry que fue iniciada por Tarek Galal (programador egipcio), la idea era crear un cliente para mongo que pudiera ser tan buena como la oficial, al comienzo todo fue bien, pero eventualmente Whatsapp y Blackberry se pusieron de acuerdo y decidieron desechar el trabajo de Tarek. Tarek fuera de claudicar siguio con su trabajo y eventualmente publicó yowsup, que es la librería que usa Wazapp. Yowsup incluye un cliente cli, y ese es el que uso.

Por otra parte Whatsapp requiere un número para brindar el servicio. Se puede usar un número real o virtual, en mi caso uso [twilio](https://www.twilio.com), un proveedor que vende números virtuales para enviar/recibir sms/llamadas.

## instalación

<pre class="sh_sh">
$ sudo apt-add-repository ppa:chilicuil/sucklesstools
$ sudo apt-get update
$ sudo apt-get install yowsup
</pre>

También se puede descargar el repositorio y usar desde el directorio principal, si se hace esto, se tendra que reemplazar yowsup por yowsup-cli y agregar "-c ~/.yowsup" como primer parámetro:

<pre class="sh_sh">
$ git clone https://github.com/tgalal/yowsup
$ cd yowsup
</pre>

## registro

Instalado yowsup, se tendrá que inicializar, para hacerlo, se crea el archivo **~/.yowsup**:

<pre>
phone=[numero_completo_con_lada_nacional_e_internacional]
id=0000000000
password=
</pre>

Y luego se ejecuta:

<pre class="sh_sh">
$ yowsup --requestcode sms
</pre>

Un mensaje sms se enviará al número configurado, si es real, llegará en 1-5 min. Si es virtual (y alojado en twilio.com), habrá que revisar la carpeta de entrada. Logs &#x25B7; Messages.

**[![](/assets/img/94.png)](/assets/img/94.png)**

Y luego **Incomming**:

**[![](/assets/img/95.png)](/assets/img/95.png)**

Con el código de verificación en mano, se puede registrar la cuenta:

<pre class="sh_sh">
$ yowsup --register codigo-de-registro #(de 3 a 6 digitos)
</pre>

Lo que devolvera una contraseña, esa contraseña debe agregarse al archivo **~/.yowsup**, después de lo cual se podrán enviar/recibir mensajes:

<pre class="sh_sh">
$ yowsup -l                     #queda a escucha de nuevos mensajes
$ yowsup -s XXXXXXXX "mensaje"  #envia mensaje al número XXXXXXXX
$ yowsup -i XXXXXXXX            #inicia una charla con el número XXXXXXXX
</pre>

Referencias

- [http://openwhatsapp.org/faq/](http://openwhatsapp.org/faq/)
