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

Un archivo `IMAGEN.PNG.gpg` es generado.

### Descifrar

    $ gpg -v --decrypt IMAGEN.PNG.gpg > IMAGEN.PNG
    # pregunta contraseña 2 veces

Un archivo `IMAGEN.PNG` es generado

## Seguridad adicional, estenografía

La esteneografía es la técnica de esconder mensajes / datos dentro de otros,
por ejemplo almacenar archivos cifrados dentro de canciones mp3.

### Instalación

    $ wget https://raw.githubusercontent.com/javier-lopez/learn/master/sh/dockerized/hideme.dockerized
    $ chmox +x hideme.dockerized
    $ sudo mv hideme.dockerized /usr/bin/hideme.dockerized

### Esconder datos en archivos de música

    $ hideme.dockerized ARCHIVO.MP3 IMAGEN.PNG.gpg
    #un archivo output.mp3 se creará localmente, este archivo contiene la cancion y el archivo escondido

### Descubrir datos en archivos de música

    $ hideme.dockerized output.mp3 -f
    #se creará un archivo 'output.' que deberá ser renombrado al archivo original
    $ mv output. IMAGEN.PNG.gpg

Listo, feliz transmisión de sus secretos &#128523;.

- [https://github.com/javier-lopez/learn/blob/master/sh/tools/wallet](https://github.com/javier-lopez/learn/blob/master/sh/tools/wallet)
