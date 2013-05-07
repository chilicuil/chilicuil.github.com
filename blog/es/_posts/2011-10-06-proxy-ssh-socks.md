---
layout: post
title: "proxy shh + socks"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

**Problema**

- No se pueden accesar a páginas como facebook, youtube, foobar.com:3468, etc, porque han sido bloqueadas
- No se pueden accesar a paginas como foobar.com:3468 por que estan en el mismo rango de IP (configuraciones raras de proveedores de Internet), y se desea accesar a traves de un host intermedio

**Solución** : Utilizar un(os) tunel(es) shh

**Ingredientes:**

- Cuenta(s) ssh, ejemplo: [cjb.net](http://cjb.net), vps, etc
- Cliente ssh
- Que no se bloquee el tráfico ssh (22 por defecto, pero si se bloquea puede cambiarse al 80)

**Procedimiento:**

- Crear un tunel

<pre class="sh_sh">
[local]$  ssh -C2qTnN -D 9090 username@maquina_remota.com
</pre>

- Configurar firefox, editar - preferencias - avanzado - red - configuración - configuración manual del proxy
- SOCKS Proxy 127.0.0.1 Puerto 9090

**Extra**

Algunas veces no basta un solo host, asi que pueden usarse N nodos como intermediarios:

<pre>
Firefox (local) -> host1 -> host2 -> host n -> Internet
</pre>

**Procedimiento:**

<pre class="sh_sh">
[local]$  ssh -C2qTnN username@host1 -L 9090:localhost:9090
[host1]$  ssh -C2qTnN username@host2 -L 9090:localhost:9090
...
...
[hostn-1]$ ssh -C2qTnN -D 9090 username@hostn
</pre>

- Configurar firefox, editar - preferencias - avanzado - red - configuración - configuración manual del proxy
- SOCKS Proxy 127.0.0.1 Puerto 9090
