---
layout: post
title: "vagrant con proveedores en línea: aws, digitalocean"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

<!--**[![](/assets/img/86.png)](/assets/img/86.png)**-->
<iframe class="showterm" src="http://showterm.io/ce9681926ec6875d743f1" width="640" height="350">&nbsp;</iframe> 

Me gusta mantener una computadora rápida y estable, por eso cada vez que puedo instalo o compilo en máquinas virtuales, contenedores, o en la nube. La nube es genial porque puedo trabajar más rápido de lo que lo haría con mi conexión (las conexiones en México son lentas). Algunas de las nubes más baratas y rápidas que conozco son [Ec2](http://aws.amazon.com/ec2/) (de amazon, gratis 1 año) y [DigitalOcean](http://digitalocean.com/) (5 USD en promedio por mes). De la nube a una máquina [LEB](http://lowendbox.com/), prefiero las segundas cuando se trata de correr servicios a largo/mediano plazo. Tengo

- l1.javier.io
- m1.javier.io
- m2.javier.io
- ...

Sin embargo, estas vps no tienen [apis](http://es.wikipedia.org/wiki/Interfaz_de_programaci%C3%B3n_de_aplicaciones), por lo que son lentas para hacer provisionamiento y ademas, casi siempre estan ocupadas. Tener un comando o una página desde donde pueda provisionar en menos de 5 minutos es un must en mi configuración. Al principio usaba [juju](http://juju.ubuntu.com), esta herramienta aunque no esta diseñada para ello puede usarse para este fin:

<pre class="sh_sh">
$ juju boostrap
$ juju ssh/0
</pre>

El comando anterior creara una máquina remota y hara login, una vez ahí, se puede correr manualmente el [provisionamiento](http://javier.io/s) y empezar a trabajar, no más de 5 min, pero tampoco menos de 3. Ya desde que usaba juju me dí cuenta que tendría que usar otra cosa, juju nunca fue diseñado para lo que hacía, y la forma correcta de usarlo no me parecía que fuera a tener éxito (hice [un](https://jujucharms.com/fullscreen/search/precise/wesnoth-1/?text=wesnoth) [par](https://jujucharms.com/fullscreen/search/~chilicuil/precise/assaultcube-2/?text=assaultcube) de juju charms).

Poco después empecé a buscar alternativas y encontré [http://instantserver.io/](http://instantserver.io/) . Durante el poco tiempo que estuvo en servicio ha sido lo más cercano a una interfaz sobria que haya usado. Un click y se tenía una máquina accesible en un tiempo de 1-2 segundos (supongo que siempre se tenian máquinas precargadas). No solo eso, la máquina se autodestruía pasados 40 minutos, suficiente para instalar/compilar lo que fuera necesario. Lamentablemente debido al uso indebido de algunos individuos el servicio fue suspendido. No pierdo la esperanza de que en el futuro cercano regrese en una versión de pago, estaré feliz de aventarles dinero a las manos.

Finalmente, en una tercera búsqueda, me esforce por encontrar una solución que soportara diversas nubes y soluciones de virtualización y di con vagrant. No había sido la primera vez que escuchaba del proyecto, pero sí la primera que sabía que soportaba proveedores adicionales. La primera vez solo era una interfaz cli de VirtualBox (y dado que por ese entonces había escrito algunos scripts, no me daba la gana usar otra cosa).

Con vagrant y su sistema de plugins, ahora puedo provisionar en ~2 minutos (1 min para crear la instancia y otro para provisionar).

<pre class="sh_sh">
$ vagrant up --provider=aws
$ vagrant up --provider=digital_ocean
</pre>

Dependiendo del proveedor que quiera usar (suelo usar primero aws, porque es gratis y ¿qué vence a lo gratis?, pero uso digitalocean si ya tengo corriendo una instancia en aws porque es más barato).

## Vagrant

La versión de vagrant que se distribuye con Ubuntu 12.04 es antigua, es mejor descargar la versión del sitio oficial:

- [http://downloads.vagrantup.com/](http://downloads.vagrantup.com/)

Una vez descargado el archivo deb, se instala así:

<pre class="sh_sh">
$ sudo dpkg -i archivo_con_terminacion_en.deb
</pre>

### Vagrant-aws

El plugin de vagrant-aws, aunque en el README del proyecto no se lea, require las siguientes dependencias, reporte [163](https://github.com/mitchellh/vagrant-aws/issues/163):

<pre class="sh_sh">
$ sudo apt-get install build-essential libxslt-dev libxml2-dev zlib1g-dev
</pre>

Ademas tambien necesita que se cree un grupo de seguridad o que se modifique el que se usa por defecto (en ec2) para permitir las conexiones entrantes al puerto 22 (ssh), este paso se me hace absurdo (al igual que el siguiente), el plugin debería crear un grupo para vagrant con los permisos necesarios y subirlo la primera vez que se ejecute, sin embargo, mientras no se solucione, reporte [95](https://github.com/mitchellh/vagrant-aws/issues/95), deberá hacerse o vagrant esperara por siempre para establecer una conexión ssh. Este paso se hace en el panel de control de [Amazon Ec2](http://aws.amazon.com/ec2/), solo 1 vez.

También debe subirse la parte pública de una llave ssh, en mi caso esta llave se encuentra en **.ssh/id_rsa.pub**, en su caso puede variar, o puede que no tengan llaves ssh, si ese es el caso, deberan [crear](http://git-scm.com/book/es/Git-en-un-servidor-Generando-tu-clave-p%C3%BAblica-SSH) una. Para subir la llave pública, se accede al panel de control de [Amazon Ec2](http://aws.amazon.com/ec2/), este paso solo se hace 1 vez.

Completados los pasos previos y con los datos de los números de acceso (access_key_id y secret_access_key, disponibles en el panel de control), se puede instalar:

<pre class="sh_sh">
$ vagrant plugin install vagrant-aws
</pre>

### Vagrant-digitalocean

El plugin de digitalocean a diferencia del de aws, no tiene dependencias, puede instalarse así:

<pre class="sh_sh">
$ vagrant plugin install vagrant-aws
</pre>

Sin embargo, tambien deberá subirse la parte pública de la llave ssh, **.ssh/id_rsa.pub** (la misma llave mencionada arriba), y hacerse de los datos de cliente (client_id) y de la api (api key), estos datos estan disponibles desde el panel de control del [sitio](http://digitalocean.com/).

## Configuración del archivo Vagrantfile

Vagrant originalmente fue diseñado para desarrolladores que programan por proyecto, la idea es que cada proyecto tenga asociado un archivo **Vagrantfile** y que cuando una persona descargue código con ese archivo, pueda instalar el servicio descargado usando:

<pre class="sh_sh">
$ vagrant up
</pre>

Es una [idea poderosa](http://mitchellh.com/the-tao-of-vagrant), sin embargo en mi caso, uso vagrant para tener tener acceso a cajas vacias tan pronto como sea posible. Para lograrlo he creado un directorio **vagrant** en un lugar al cual puedo llegar rápido **$HOME/misc/vagrant**. El suyo puede variar, o tal vez deseen usar vagrant en la forma *correcta*. Dentro de ese directorio he declarado el siguiente archivo **Vagranfile**:

<pre>
VAGRANT_API_VERSION = "2"

Vagrant.configure(VAGRANT_API_VERSION) do |config|

  config.vm.provider :digital_ocean do |provider, override|
    override.ssh.private_key_path = '~/.ssh/id_rsa'
    override.ssh.username = 'admin'
    override.vm.box = 'digital_ocean'
    override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"
    override.vm.provision :shell, :inline =&gt; "su - #{override.ssh.username} -c \"bash &lt;(wget -qO- javier.io/s)\""

    provider.client_id = 'CLIENT_ID_SECRET'
    provider.api_key = 'API_SECRET'
    provider.image = 'Ubuntu 12.04 x64'
    provider.region = 'New York 2'
    provider.size = '512MB'
    provider.private_networking = 'false'
    provider.setup = 'true'
    provider.ca_path = '/etc/ssl/certs/ca-certificates.crt'
  end

  config.vm.provider :aws do |provider, override|
    #depends on: 'build-essential libxslt-dev libxml2-dev zlib1g-dev' on ubuntu
    #requires a custom security group who allows traffic on port 22

    #fail if custom username doesn't exist in the ami image

    #default ubuntu 12.04 x64 server
    override.ssh.private_key_path = "~/.ssh/id_rsa"
    override.ssh.username = "ubuntu"
    override.vm.box = 'dummy'
    override.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
    override.vm.provision :shell, :inline =&gt; "su - #{override.ssh.username} -c \"bash &lt;(wget -qO- javier.io/s)\""

    provider.access_key_id = "ACCESS_KEY_SECRET"
    provider.secret_access_key = "ACCESS_KEY_SECRET"
    provider.ami = "ami-a73264ce"
    provider.instance_type = "t1.micro"
    provider.keypair_name = "id_rsa"
  end
end

# vi:ft=ruby:
</pre>

Ahora se puede provisionar una máquina virtual con:

<pre class="sh_sh">
$ cd misc/vagrant
$ vagrant up --provider=aws #o digitalocean
</pre>

Se espera 1 minuto, y se entra:

<pre class="sh_sh">
$ vagrant ssh
</pre>

Al terminar, se puede eliminar la instancia con:

<pre class="sh_sh">
$ vagrant destroy
</pre>

He creado algunos aliases para escribir menos:

<pre>
alias v="vagrant"
alias vup="vagrant up"
alias vhlt="vagrant halt"
alias vspd="vagrant suspend"
alias vrsm="vagrant resume"
alias vrl="vagrant reload"
alias vs="vagrant ssh"
alias vstat="vagrant status"
alias vd="vagrant destroy"

alias vup.vbox="vagrant up --provider=virtualbox"
alias vup.digitalocean="vagrant up --provider=digital_ocean"
alias vup.aws="vagrant up --provider=aws"
</pre>

Por el momento voy a permanecer con vagrant, su sistema de plugins es un éxito, tiene proveedores para [virtualbox](https://www.virtualbox.org/), [vmware](http://www.vmware.com), [kvm](http://www.linux-kvm.org/page/Main_Page), [lxc](http://linuxcontainers.org/), y otras nubes, provisionadores extra como [puppet](http://puppetlabs.com/), [chef](http://www.opscode.com/) y [ansible](http://www.ansibleworks.com/), incluso esta siendo integrado con [docker](http://www.docker.com/) (un sistema que parecer popular ultimamente).
