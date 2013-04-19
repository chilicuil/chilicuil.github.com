---
layout: post
title: "proxy shh + socks"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

**Problema:** páginas como foobar.com:3468, youtube, facebook, twitter, estan bloqueadas

**Solución**: Utilizar un tunel shh

**Ingredientes:**

- Cuenta ssh, [cjb.net](http://cjb.net) es la mejor opción que he encontrado hasta ahora
- Cliente ssh
- Que no se bloquee el tráfico ssh (22 por defecto, pero puede cambiarse al 80)

**Procedimiento:**

- Crear un tunel **$  ssh -C2qTnN -D 9090 username@maquina_remota.com**
- Configurar firefox, editar - preferencias - avanzado - red - configuración - configuración manual del proxy
- SOCKS Proxy 127.0.0.1 Puerto 9090
