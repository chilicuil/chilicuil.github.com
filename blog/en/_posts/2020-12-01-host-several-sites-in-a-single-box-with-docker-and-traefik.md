---
layout: post
title: "host several sites in a single box with docker and traefik v2"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

[Docker](https://www.docker.com/) is great and everything, however one
of the few things that I think could improve is how it's deployed to
production. There are many alternatives, nevertheless many of them
seems over complicated or expensive. I don't want to spend my free
time or money on them, for small/personal projects I'd prefer to host
everything in a single node.

So today I started reviewing the state of the art and found several
alternatives, one of them caught my eye because of its simplicity and
elegance, I'll describe it here for my future me.

**[![](/assets/img/traefik-docker-compose.png)](/assets/img/traefik-docker-compose.png)**

## Folder structure

    ┬
    ├── multisite
    │   ├── docker-compose.yml
    ├── site1.com
    │   ├── ...
    │   ├── docker-compose.site1.yml
    ├── site2.com
        ├── ...
        ├── docker-compose.site2.yml

## multisite

**multisite/docker-compose.yml** contains the core of the setup:

    version: '3.4'

    services:
      traefik:
        image: traefik:v2.3
        command:
          - "--api.insecure=true"
          - "--providers.docker"
          - "--providers.docker.exposedbydefault=false"
          - "--providers.docker.network=traefik_global"
        ports:
          - "80:80"     #all traffic will arrive through this point
          - "8080:8080" #traefik dashboard/api
        volumes:
          - /var/run/docker.sock:/var/run/docker.sock
        networks:
          - traefik

    networks:
      traefik:
        name: traefik_global

Based on [traefik](https://traefik.io/), the above recipe define
several things.

<pre class="lyric">
--api.insecure=true
</pre>

Gives access to a pretty traefik dashboard/api from where to review the exposed
services: [http://localhost:8080](http://localhost:8080) and
[http://localhost:8080/api/rawdata](http://localhost:8080/api/rawdata)

**[![](/assets/img/traefik-dashboard.png)](/assets/img/traefik-dashboard.png)**

Allows Traefik to autoconfigure its routing depending on Docker
events/data but only to explicitly defined containers. More about this
in the next section.

<pre class="lyric">
--providers.docker
--providers.docker.exposedbydefault=false
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
</pre>

By default, **docker-compose** creates volumes/networks based in the
parent folder name, the **name:** parameter allows to override this and
create a stable shared network name **traefik_global**, the
**providers.docker.network** option gives to Traefik the instruction to
route by default all the traffic through this interface, if not
defined here every service would need to do it in its own
**docker-compose.yml** file.

<pre class="lyric">
--providers.docker.network=traefik_global

networks:
  traefik:
    name: traefik_global
</pre>

## site1.com

In order to make more realistic the scenario I'm going to use small
template applications that although simple contain enough complexity
to mirror a real world case:

    $ git clone https://github.com/nebulosa/docker-flask-hello-world-mongodb site1.com
    $ cd site1.com/
    $ git checkout 0de86a2

**[![](/assets/img/traefik-tier-3-app.png)](/assets/img/traefik-tier-3-app.png)**

The above image don't consider docker, if we do it and split the app
in different subnets we would arrive at the following diagram:

**[![](/assets/img/traefik-tier-3-dockerized-app.png)](/assets/img/traefik-tier-3-dockerized-app.png)**

This is close to our final setup, there is only the **traefik_global**
network missing, it will be connected to every front-end web container to
send/receive requests while the rest of the service stack is hidden in
its own namespace, that will improve security and maintenance.

I'll create a copy of **docker-compose-cherry.yml** and apply a patch to
connect it with traefik.

    $ cp docker-compose-cherry.yml docker-compose.site1.yml

**site1.com/docker-compose.site1.yml.patch**:

    --- docker-compose.site1.yml	2020-11-30 23:06:48.186590271 -0600
    +++ docker-compose.site1.yml.patch	2020-12-01 02:03:30.940486004 -0600
    @@ -18,15 +18,18 @@

       nginx:
         image: nginx:1.13.10-alpine
    -    ports:
    -      - "5000:80"
         volumes:
           - ./nginx/default/:/etc/nginx/conf.d
           - /etc/localtime:/etc/localtime:ro
         depends_on:
           - app
         networks:
    +      - traefik
           - frontend
    +    labels:
    +      - "traefik.enable=true"
    +      - "traefik.http.routers.site1_com.rule=Host(`site1.com`)"
    +      - "traefik.http.services.site1_com.loadbalancer.server.port=80"

       app:
         build: .
    @@ -52,3 +55,6 @@
         driver: bridge #or overlay in swarm mode
       backend:
         driver: bridge #or overlay in swarm mode
    +  traefik:
    +    external:
    +      name: traefik_global

There is no need to export/bind additional ports, all our traffic will
arrive to port 80 in localhost/traefik, therefore the ports section
can be removed or commented:

<pre class="lyric">
ports:
- "5000:80"
</pre>

The front-end web container, **nginx** on this case, is connected to the
global traefik network.

<pre class="lyric">
networks:
  - traefik

traefik:
  external:
    name: traefik_global
</pre>

Only the **nginx** container is announced to traefik, **enable=true**, it
will respond to the **site1.com** domain and will be available in the
local port **80** (**grep "listen" nginx/default/default.conf**), an
important step is to verify that the routers/services id is unique, on
this case **site1_com**:

<pre class="lyric">
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.site1_com.rule=Host(`site1.com`)"
  - "traefik.http.services.site1_com.loadbalancer.server.port=80"
</pre>

Lets apply the changes:
 
    $ patch -p0 < docker-compose.site1.yml.patch
    patching file docker-compose.site1.yml


## site2.com

The second site is an API, really simple but also with its own
database and nginx containers.

    $ git clone https://github.com/nebulosa/flask-api-rest site2.com
    $ cd site2.com/
    $ git checkout 9489597

I'll also create a copy of **docker-compose-cherry.yml** and apply a patch similar
to the last one:

    $ cp docker-compose-cherry.yml docker-compose.site2.yml

**site2.com/docker-compose.site2.yml.patch**:

    --- docker-compose.site2.yml	2020-11-30 23:06:48.186590271 -0600
    +++ docker-compose.site2.yml.patch	2020-12-01 02:03:30.940486004 -0600
    @@ -17,14 +17,17 @@
     
       nginx:
         image: nginx:1.13.10-alpine
    -    ports:
    -      - "5000:80"
         volumes:
           - ./nginx:/etc/nginx/conf.d
         depends_on:
           - app
         networks:
    +      - traefik
           - frontend
    +    labels:
    +      - "traefik.enable=true"
    +      - "traefik.http.routers.site2_com.rule=Host(`site2.com`)"
    +      - "traefik.http.services.site2_com.loadbalancer.server.port=80"
     
       app:
         build: .
    @@ -46,3 +49,6 @@
         driver: bridge #or overlay in swarm mode
       backend:
         driver: bridge #or overlay in swarm mode
    +  traefik:
    +    external:
    +      name: traefik_global

As you already notice, all changes are the same except for:

<pre class="lyric">
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.site2_com.rule=Host(`site2.com`)"
  - "traefik.http.services.site2_com.loadbalancer.server.port=80"
</pre>

This time, the routers/services id is **site2_com**, look how the server
port can be the same for all sites.

## docker-compose up

Before launching everything up, I'm going to edit **/etc/hosts** so I
can access the sites directly:

**/etc/hosts**:

    ...

    127.0.0.1	site1.com
    127.0.0.1	site2.com

Done, let's deploy this:

    $ cd multisite/ && docker-compose up -d
    $ cd site1.com/ && docker-compose -f docker-compose.site1.yml up -d
    $ cd site2.com/ && docker-compose -f docker-compose.site2.yml up -d

That's it! a simple setup that is only limited by the amount of
RAM/CPU in your machine:

    $ curl site1.com
    hello world from 7b7d6302-e162-3806-9595-17f854dd5b98

    $ curl site2.com; echo
    {"Greetings": "Hello World!"}

Happy hacking &#128522;
