---
layout: post
title: "compartiendo archivos cifrados x internet"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

Un archivo cifrado es aquel que ha sido ofuscado mediante algoritmos públicos,
sólo las personas con la llave secreta pueden acceder a ellos.

### Cifrar

    $ gpg -v --cipher-algo AES256 --symmetric IMAGEN.PNG
    # pregunta contraseña 2 veces

Un archivo **IMAGEN.PNG.gpg** es generado, este es el que debemos pasar al
contacto junto con la contraseña

**OJO: En el ejemplo anterior se ha usado una IMAGEN.PNG pero usarse con
cualquier tipo de archivo**

### Descifrar

    $ gpg -v --decrypt IMAGEN.PNG.gpg > IMAGEN.PNG
    # pregunta contraseña 2 veces

Un archivo **IMAGEN.PNG** es generado el cual puede abrirse con cualquier visor
de imagenes.

## Seguridad adicional, estenografía

La esteneografía es la técnica de esconder mensajes / datos dentro de otros,
por ejemplo almacenar archivos cifrados dentro de canciones mp3.

### Instalación

    $ wget https://raw.githubusercontent.com/javier-lopez/learn/master/sh/dockerized/hideme.dockerized
    $ chmod +x hideme.dockerized
    $ sudo mv hideme.dockerized /usr/bin/hideme.dockerized

### Esconder datos en archivos de música

    $ hideme.dockerized ARCHIVO.MP3 IMAGEN.PNG.gpg

Un archivo **output.mp3** es generado, este es el archivo que debemos pasar al
contacto junto con la contraseña del arcihvo **IMAGEN.PNG.gpg**

### Descubrir datos en archivos de música

    $ hideme.dockerized output.mp3 -f

Un archivo **output.U** es generado, este debe renombrarse al archivo original, por ejemplo:

    $ mv output.U IMAGEN.PNG.gpg

Y descifrarse en caso de ser necesario:

    $ gpg -v --decrypt IMAGEN.PNG.gpg > IMAGEN.PNG
    # pregunta contraseña 2 veces

Listo, feliz transmisión de secretos &#128523;.
