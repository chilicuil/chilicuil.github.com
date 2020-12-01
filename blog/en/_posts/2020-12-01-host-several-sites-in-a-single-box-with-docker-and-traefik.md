---
layout: post
title: "host several sites in a single box with docker and traefik v2"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

[Docker](https://www.docker.com/) is great and everything, however one of the
things that still stress me is how to deploy it to production. I don't need
fancy stuff, nor I want to spend my free time or money hosting small/personal
projects. I just want to be able to **docker-compose up** and forget. And if
several projects can share a single node while maintaining their own
domain/subdomain even better.

Today, after completing another small service, I decided I had enough, I
reviewed several alternatives and finally found a sensitive one.
[Traefik](https://traefik.io/), a simple/yet powerful reverse proxy that is
compatible with Docker/Kubernetes/Blablabla and that just works. So here goes,
my own tutorial for future me and other in pain souls.

## Diagram and Folder Structure

**[![](/assets/img/traefik-docker-compose.png)](/assets/img/traefik-docker-compose.png)**

    ┬
    ├── multisite (traefik)
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
        volumes: #this is how traefik reads docker events
          - /var/run/docker.sock:/var/run/docker.sock
        networks:
          - traefik

    networks:
      traefik:
        name: traefik_global

It's amazing how simple it can get, let's review some of its sections:

    --api.insecure=true

Activate traefik's dashboard/api (should be disabled or protected in production
systems), [http://localhost:8080](http://localhost:8080) and
[http://localhost:8080/api/rawdata](http://localhost:8080/api/rawdata),
personally the latter was more useful to me, helped me to debug route
mismatches.

**[![](/assets/img/traefik-dashboard.png)](/assets/img/traefik-dashboard.png)**

Traefik is able to autoconfigure its routing from Docker events/data, that is
nice but if you don't want to end with dozens of routes because of auxiliary
services it's better to only allow specific ones, maybe only service's
front-ends?

    --providers.docker
    --providers.docker.exposedbydefault=false

By default, **docker-compose** creates volumes/networks based in the project
folder name, that's to protect from service collision, for our traefik case
however we need a global network that can be referred in multiple scenarios,
that's what the **name:** parameter does, the **providers.docker.network**
option gives to Traefik the instruction to route all its traffic through this
interface, if not defined here every service would need to do it in its own
**docker-compose.yml** file.

    --providers.docker.network=traefik_global

    networks:
      traefik:
        name: traefik_global

## site1.com

In order to make a realistic scenario I’m going to use small applications that
although simple contain enough complexity to mirror real world cases:

    $ git clone https://github.com/nebulosa/docker-flask-hello-world-mongodb site1.com
    $ cd site1.com/
    $ git checkout 0de86a2

**[![](/assets/img/traefik-tier-3-app.png)](/assets/img/traefik-tier-3-app.png)**

The above image don't consider docker, yet helps to describe how a common web
application works, once we take in account containers / subnets we would arrive
to the following diagram:

**[![](/assets/img/traefik-tier-3-dockerized-app.png)](/assets/img/traefik-tier-3-dockerized-app.png)**

As you can see, the only container that can communicate with both, **frontend**
and **database** is the **app**, this is just good practices, in our final
setup, an additional **traefik_global** network would be added, it will connect
every front-end web container to send/receive requests while the rest of the
service stack is hidden in its own namespace, simple/elegant and easy to scale.

I'll create a copy of **docker-compose-cherry.yml** and apply a patch to
showcase how traefik connection works:

    $ cp docker-compose-cherry.yml docker-compose.site1.yml

**site1.com/docker-compose.site1.yml.patch**:

    --- docker-compose.site1.yml	2020-12-30 10:02:48.186590271 -0600
    +++ docker-compose.site1.yml.patch	2020-12-30 10:03:30.940486004 -0600
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
    +      - traefik #add 1st so traefik performs better
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

Since all our traffic would pass through localhost:80/traefik there is no need
to expose/bind additional ports:

       nginx:
         image: nginx:1.13.10-alpine
    -    ports:
    -      - "5000:80"

The front-end container, **nginx** on this case, is connected to the global
traefik network.

         networks:
    +      - traefik #add 1st so traefik performs better
           - frontend

    +  traefik:
    +    external:
    +      name: traefik_global

Only the **nginx** container is announced to traefik, **enable=true**, it
will respond to the **site1.com** domain and will be available in the
local port **80** (**grep "listen" nginx/default/default.conf**), an
important step is to verify that the **routers/services id** is unique, on
this case **site1_com**:

    +    labels:
    +      - "traefik.enable=true"
    +      - "traefik.http.routers.site1_com.rule=Host(`site1.com`)"
    +      - "traefik.http.services.site1_com.loadbalancer.server.port=80"

That's all for a basic setup, I'll add https/automatic SSL renovation in a
future article, let's apply the patch:
 
    $ patch -p0 < docker-compose.site1.yml.patch
    patching file docker-compose.site1.yml


## site2.com

The second site is an API, really simple but also with its own
database and nginx containers.

    $ git clone https://github.com/nebulosa/flask-api-rest site2.com
    $ cd site2.com/
    $ git checkout 9489597

I'll also create a copy of **docker-compose-cherry.yml** and apply a patch similar
to the previous one:

    $ cp docker-compose-cherry.yml docker-compose.site2.yml

**site2.com/docker-compose.site2.yml.patch**:

    --- docker-compose.site2.yml	2020-12-30 10:02:48.186590271 -0600
    +++ docker-compose.site2.yml.patch	2020-12-30 10:03:30.940486004 -0600
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
    +      - traefik #add 1st so traefik performs better
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

As you notice, all changes are the same except for:

    +    labels:
    +      - "traefik.enable=true"
    +      - "traefik.http.routers.site2_com.rule=Host(`site2.com`)"
    +      - "traefik.http.services.site2_com.loadbalancer.server.port=80"

This time, the routers/services id is **site2_com**

## docker-compose up

One previous step I'm going to do before launching everything is edit
**/etc/hosts**:

    ...

    127.0.0.1	site1.com
    127.0.0.1	site2.com

That will help me test the sites locally, ok, let's end this tutorial:

    $ cd multisite/ && docker-compose up -d
    $ cd site1.com/ && docker-compose -f docker-compose.site1.yml up -d
    $ cd site2.com/ && docker-compose -f docker-compose.site2.yml up -d

That's it!, a simple setup that is only limited by the amount of
**RAM/CPU** in your machine:

    $ curl site1.com
    hello world from 7b7d6302-e162-3806-9595-17f854dd5b98

    $ curl site2.com; echo
    {"Greetings": "Hello World!"}

Happy hacking &#128522;
