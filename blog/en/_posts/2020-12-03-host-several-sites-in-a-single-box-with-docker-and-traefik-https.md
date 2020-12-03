---
layout: post
title: "host several sites in a single box with docker and traefik v2, https"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

Last time I wrote about how simple is to [host several sites with docker +
traefik on a single node](http://javier.io/blog/en/2020/12/01/host-several-sites-in-a-single-box-with-docker-and-traefik-http.html),
on this article I'll complement such information with https and automatic ssl
certification renewal.

If you'll continue reading this you **need** to get familiar with the previous
one since I'll build upon it. OK, ready?, let's recapitulate:

## Diagram and Folder Structure

**[![](/assets/img/traefik-docker-compose.png)](/assets/img/traefik-docker-compose.png)**

Traefik will recieve all requests and will send them to different containers
depending the domain/subdomains, in the process it'll provide ssl termination
for our users and dockerized applications, those certifications will be
autorenewed every 2/3 months and won't require any manual step, cool!

    ┬
    ├── multisite (traefik)
    │   ├── docker-compose.yml
    │   ├── docker-compose.ssl.yml        => NEW FILE
    │   ├── acme.json                     => NEW FILE
    ├── site1.com
    │   ├── ...
    │   ├── docker-compose.site1.yml
    │   ├── docker-compose.site1.ssl.yml  => NEW FILE
    ├── site2.com
        ├── ...
        ├── docker-compose.site2.yml
        ├── docker-compose.site1.ssl.yml  => NEW FILE


As you noticed, new files were added, the idea is that we maintain the
flexibility to either provision a **http only** or a **http + https** site.

## pre requisite, dns configuration

When working with **http only** there is no need to mv our code from our local
environment, it's easy to add some entries in **/etc/hosts** and call it a day,
this time however is different, we need to **upload our files into a box with
a public ip address** and verify that the dns routing is working as expected,
that is, if we are going to hosts these sites at:
185.199.109.153, **we need to make sure site1.com / site2.com resolve to
185.199.109.153**

I won't cover how to do that because it depends on your DNS Registrar, for
reference I'm using [RackNerd](https://www.racknerd.com/) and
[DNSPod](https://www.dnspod.com/) as my Linux / DNS servers.

Why do we need to prepare our setup like this before starting?, it has to do
with [Let's Encrypt](https://letsencrypt.org/), the Certification Authority
we're going to depend on, this CA generates challenges to verify that we are
the **owners of the referenced domain/subdomain**, fortunatelly that happens
automatically so we don't need to do anything besides making sure that Let's
Encrypt can communicate with our domains.

## multisite

Remember that starting here all changes are located in a remote public machine.
I'll start by creating a copy of **docker-compose-cherry.yml**, that would make
easier for us to track the ssl changes:

    $ cp docker-compose.yml  docker-compose.ssl.yml 

**multisite/docker-compose.ssl.yml.patch**:

<pre class="sh_diff">
--- docker-compose.ssl.yml           2020-12-03 10:02:48.186590271 -0600
+++ docker-compose.ssl.changes.yml   2020-12-03 10:03:30.940486004 -0600
@@ -9,11 +9,21 @@
       - "--providers.docker.exposedbydefault=false"
       - "--providers.docker.network=traefik_global"
       #- "--log.level=DEBUG"
+      - "--entrypoints.http.address=:80"
+      - "--entrypoints.https.address=:443"
+      - "--certificatesresolvers.myresolver.acme.email=your-personal@email.tld"
+      - "--certificatesresolvers.myresolver.acme.storage=/acme.json"
+      - "--certificatesresolvers.myresolver.acme.tlschallenge=true"
     ports:
       - "80:80"     #reverse proxy => input to all containerized services
+      - "443:443"   #reverse ssl proxy
       - "8080:8080" #traefik dashboard/api
     volumes:
       - /var/run/docker.sock:/var/run/docker.sock
+      # Run this command in the host machine before launching traefik:
+      #   $ touch acme.json && chmod 600 acme.json
+      - ${PWD}/acme.json:/acme.json
     networks:
       - traefik
</pre>

Now our original file it's more verbose, however every option is there for a
reason.

By default traefik only opens the **http port (80)**, so if we want to allow
both, **http/https**, we need to be more specific:

<pre class="sh_diff">
+      - "--entrypoints.http.address=:80"
+      - "--entrypoints.https.address=:443"
</pre>

We also need to select which *certification resolver*  we're going to use, on
this case, Let's encrypt, we specify that by filling the acme fields.

**acme.email** can be any personal/bussiness email. **acme.storage** is where
our ssl certificates will be saved, it does **need to exists but can be
empty**, if that is the case, traefik will override it with valid certs.
**acme.tlschallenge** is the challenge type, there are [other
types](https://doc.traefik.io/traefik/https/acme/#the-different-acme-challenges),
but I think this is the easiest.

<pre class="sh_diff">
+      - "--certificatesresolvers.myresolver.acme.email=your-personal@email.tld"
+      - "--certificatesresolvers.myresolver.acme.storage=/acme.json"
+      - "--certificatesresolvers.myresolver.acme.tlschallenge=true"
     ports:
       - "80:80"     #reverse proxy => input to all containerized services
+      - "443:443"   #reverse ssl proxy
</pre>

Finally we'll share the **acme.json** file between our host/container to avoid
requesting new certificates each time we launch our traefik container.

<pre class="sh_diff">
+      # Run this command in the host machine before launching traefik:
+      #   $ touch acme.json && chmod 600 acme.json
+      - ${PWD}/acme.json:/acme.json
</pre>

As the comments suggest, this file needs to be created with specific
permissions before running traefik.

    $ touch acme.json && chmod 600 acme.json

Ok, that's all on traefik side, let's apply the patch:

    $ patch -p0 < docker-compose.ssl.yml.patch
    patching file docker-compose.ssl.yml

## site1.com

Let's copy and analize what makes a new site https compatible:

    $ cp docker-compose.site1.yml docker-compose.site1.ssl.yml

**site1.com/docker-compose.site1.ssl.yml.patch**:

<pre class="sh_diff">
--- docker-compose.site1.ssl.yml           2020-12-03 10:02:48.186590271 -0600
+++ docker-compose.site1.ssl.changes.yml   2020-12-03 10:03:30.940486004 -0600
@@ -28,7 +28,15 @@
       - frontend
     labels:
       - "traefik.enable=true"
-      - "traefik.http.routers.site1_com.rule=Host(`site1.com`)"
+
+      - "traefik.http.routers.http_site1_com.rule=Host(`site1.com`)"
+      - "traefik.http.routers.http_site1_com.entrypoints=http"
+
+      - "traefik.http.routers.https_site1_com.rule=Host(`site1.com`)"
+      - "traefik.http.routers.https_site1_com.entrypoints=https"
+      - "traefik.http.routers.https_site1_com.tls=true"
+      - "traefik.http.routers.https_site1_com.tls.certresolver=myresolver"
+
       - "traefik.http.services.site1_com.loadbalancer.server.port=80"
 
   app:
</pre>

I don't know about you, but for me the syntax is confussing, happily this only
needs to be setup once and then can be reused in other domains/subdomains by
changing only some words. Also, the ssl endpoint is transparent, our
application doesn't need to be aware of it, that's great and IMO overrides the
verbose configuration.

As you noticed, the **site1_com** rules were split in two, **http_site1_com**
and **https_site1_com**, this is because each route needs to define a Host and
an entrypoint (port), repetitive right?, in the **https** route we enable
**tls** and point to our custom resolver **myresolver** which if we recall uses
let's encrypt. There is also one more detail:

<pre class="sh_diff">
       - "traefik.http.services.site1_com.loadbalancer.server.port=80"
</pre>

The service element redirects traefik routes to our app's 80 port, as each
route defines a domain and entrypoint, that means it affects the domain as a
whole and therefore it's kept as **site1_com** , @.@!

This configuration leaves an important use case that each year is more common,
forcing users to use **https** over **http**. Since I personally do not agree
with such IMO abusive behavior, I skipt it on purpose, however if you're
interested configuring it you can use a
[middleware](https://doc.traefik.io/traefik/middlewares/redirectscheme/) in
traefik terminology.

    $ patch -p0 < docker-compose.site1.yml.patch
    patching file docker-compose.site1.yml

## site2.com

The second site should be easier to review:

    $ cp docker-compose.site2.yml docker-compose.site2.ssl.yml

**site2.com/docker-compose.site2.ssl.yml.patch**:

<pre class="sh_diff">
--- docker-compose.site2.ssl.yml           2020-12-03 10:02:48.186590271 -0600
+++ docker-compose.site2.ssl.changes.yml   2020-12-03 10:03:30.940486004 -0600
@@ -26,7 +26,15 @@
       - frontend
     labels:
       - "traefik.enable=true"
-      - "traefik.http.routers.site2_com.rule=Host(`site2.com`)"
+
+      - "traefik.http.routers.http_site2_com.rule=Host(`site2.com`)"
+      - "traefik.http.routers.http_site2_com.entrypoints=http"
+
+      - "traefik.http.routers.https_site2_com.rule=Host(`site2.com`)"
+      - "traefik.http.routers.https_site2_com.entrypoints=https"
+      - "traefik.http.routers.https_site2_com.tls=true"
+      - "traefik.http.routers.https_site2_com.tls.certresolver=myresolver"
+
       - "traefik.http.services.site2_com.loadbalancer.server.port=80"
</pre>

Everything is the same, the only difference is that **site1** was replaced with
**site2**

    $ patch -p0 < docker-compose.site2.yml.patch
    patching file docker-compose.site2.yml

## docker-compose up

If you've followed everything up until this point, **congratulations!**,
technology is great but also tends to be harder to grasp as more elements are
incorporated, let's end this tutorial once for all so we can continue with our
lifes:

    $ cd multisite/ && docker-compose -f docker-compose.ssl.yml       up -d
    $ cd site1.com/ && docker-compose -f docker-compose.site1.ssl.yml up -d
    $ cd site2.com/ && docker-compose -f docker-compose.site2.ssl.yml up -d

That's it!, a kind of simple setup with ssl certs that is only limited by
the amount of **RAM/CPU** in your machine:

    $ curl https://site1.com
    hello world from 7b7d6302-e162-3806-9595-17f854dd5b98

    $ curl https://site2.com; echo
    {"Greetings": "Hello World!"}

Happy hacking!

- [http://javier.io/blog/en/2020/12/01/host-several-sites-in-a-single-box-with-docker-and-traefik-http.html](http://javier.io/blog/en/2020/12/01/host-several-sites-in-a-single-box-with-docker-and-traefik-http.html)
- [https://github.com/traefik/traefik/issues/5506#issuecomment-549100716](https://traefik.io/blog/traefik-2-0-docker-101-fc2893944b9d/)
