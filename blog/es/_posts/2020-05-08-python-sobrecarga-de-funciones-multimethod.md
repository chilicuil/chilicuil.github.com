---
layout: post
title: "python: sobrecarga de funciones, multimethod"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

Uno de los **"defectos"** más molestos de python para mi es su falta de soporte
para sobrecargar funciones, es estos días con motivo de un nuevo proyecto me
tocó volver a revisar el tema, encontré algunas soluciones caseras, un nuevo
decorador 'singledispatch' y varias librerías, después de hacer algunos
experimentos por fin encontré una implementación lo suficientemente robusta
para zanjar el tema, lo comparto por si alguien trae el mismo hormigueo:

- [https://pypi.org/project/multimethod/](https://pypi.org/project/multimethod/)

**[![](/assets/img/python-sobrecarga-de-funciones-multimethod-example.png)](/assets/img/python-sobrecarga-de-funciones-multimethod-example.png)**

Listo, feliz multipass &#128523;

**[![](/assets/img/python-sobrecarga-de-funciones-multimethod.png)](/assets/img/python-sobrecarga-de-funciones-multimethod.png)**
