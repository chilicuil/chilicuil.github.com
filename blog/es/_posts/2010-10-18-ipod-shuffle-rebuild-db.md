---
layout: post
title: "ipod shuffle - rebuild_db"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

Hace tiempo compré un ipod shuffle, y como todos los dispositivos de apple, es un poco complicado usarlo en linux, rythmobox y gtkpod de repente hacen cosas raras, sin embargo hace poco encontré un proyecto llamado [rebuild_db](http://shuffle-db.sourceforge.net/) que resuelve el problema de manera elegante, al menos en mi opinión.

Fácil, se conecta el dispositivo (solo funciona con el ipod shuffle), se crea una carpeta en el dispositivo, 'musica' por ejemplo, se copian las canciones y al final se corre el script, ya, es todo.

Se me ocurre que se podría crear una regla con udev para que lanzará el script antes de desmontarse, o que se sincronizará con una carpeta al conectarse... ya actualizaré el post si descubro como hacerlo.
