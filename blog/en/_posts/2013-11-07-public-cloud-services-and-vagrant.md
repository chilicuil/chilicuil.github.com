---
layout: post
title: "public cloud services (aws, digitalocean) and vagrant"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

<!--**[![](/assets/img/86.png)](/assets/img/86.png)**-->
<iframe class="showterm" src="http://showterm.io/ce9681926ec6875d743f1" width="640" height="350">&nbsp;</iframe> 

I like to keep a fast, ordered and stable computer, that's why I use virtual machines, containers, public cloud services and vps to experiment and deploy services, all my ram belongs to firefox &#128517;

The cloud is great, I can do more with less time because they usually have more resources than my laptop and plenty of bandwidth &#128525;. Some of my favorite public clouds are [Ec2](http://aws.amazon.com/ec2/) (1 year free) and [DigitalOcean](http://digitalocean.com/) ($5/month). I also use plenty of [Low End Boxes](http://lowendbox.com/) (LEB), I prefer the former when I'm gonna setup a service for a long time. They are organized by computer resources:

- l1.javier.io (low)
- m1.javier.io (medium)
- m2.javier.io (medium)
- ...

Vps are great, unfortunately they don't have advanced [apis](http://en.wikipedia.org/wiki/Application_programming_interface) and therefore its provision lacks some automatization. They also are usualy busy (I don't pay servers I don't use), for experimentation I prefer launching virtual machines per request, that's why having a way to launch instantly remote machines is a **must** in my work flow. I've tried several solutions, and currently [vagrant](http://www.vagrantup.com/) has proven to be the suckless method.

At the beginning I used [juju](http://juju.ubuntu.com) for a while, it wasn't designed to act as a light client but can be missued if you reused the bootstrap node:

<pre class="sh_sh">
$ juju boostrap
$ juju ssh/0
</pre>

The above command will launch and login to a remote machine, the [provisioning](http://javier.io/s) can be triggered manually, the complete process won't take more than 5 min but neither less than 3. Since I started using juju I was aware I would need to replace it, it wasn't designed to do the job.., in the other hand the "right" way to use it doesn't seem to me like a good approach (I created a [couple](https://jujucharms.com/fullscreen/search/precise/wesnoth-1/?text=wesnoth) of juju [charms](https://jujucharms.com/fullscreen/search/~chilicuil/precise/assaultcube-2/?text=assaultcube) so I like to think I'm conscious about my opinion).

Upon given juju up I found [http://instantserver.io/](http://instantserver.io/), during the short period it was active it was the closest solution to perfection I've ever used, it was trully instant (1/2 sec on average), auto destructible (after 40 min) and it didn't even required signup. Beautiful, unfortunately it didn't support provisioning and was shutdown after a couple of months because of abuse, if there were something commercial similar to it, I'd be happy to through them money at will.

Finally, during my third lookup, I found a lot of light/heavy clients for all kind of cloud services and decided to stay with vagrant due to the ease of the installation, the provision support, the popularity and the plugin design (which allow me to connect to my favorite cloud providers), it's not perfect, it takes ages just to print a help screen, but I think I can manage to use it till I find something better.

With vagrant now I can launch and provision machines in ~3 min on average.

<pre class="sh_sh">
$ vagrant up --provider=aws
$ vagrant up --provider=digital_ocean
</pre>

## Vagrant

The vagrant version available in the Ubuntu repositories is antique, fortunately the project provide deb packages which can be downloaded from:

- [http://downloads.vagrantup.com/](http://downloads.vagrantup.com/)

They can be installed with dpkg:

<pre class="sh_sh">
$ sudo dpkg -i vagrant_version.deb
</pre>

### Vagrant-aws

The vagrant-aws plugin is somekind troublesome, even when its documentation doesn't [mention it](https://github.com/mitchellh/vagrant-aws/issues/163), it requires some dependencies:

<pre class="sh_sh">
$ sudo apt-get install build-essential libxslt-dev libxml2-dev zlib1g-dev
</pre>

The plugin installation isn't that bad:

<pre class="sh_sh">
$ vagrant plugin install vagrant-aws
</pre>

The problem lies in the configuration, you'll need to create a new [default security group](https://github.com/mitchellh/vagrant-aws/issues/95) to connect through the 22 port, it's stupid considering the plugin can deploy new instances but it doesn't upload a valid security group afterwards.

Another common catch is the public ssh. You'll need to upload your public ssh key to aws and configure it. (it'd be much better if the plugin could create/upload a new key if no there are no public keys available).

### Vagrant-digitalocean

The digitialocean plugin fortunately is easier to build and configure:

<pre class="sh_sh">
$ vagrant plugin install vagrant-digitalocean
</pre>

It'll need to get a valid public ssh key configured and the api/client ids set though.

### Vagrantfile

Vagrant main concert is to help developers to clone different environments in different projects, that's why only one Vagrantfile can be specified per directory. It's a [powerful idea](http://mitchellh.com/the-tao-of-vagrant) but it doesn't apply to my use case. In my working flow all I want is to gain access to remote resources as fast as possible. To do it with vagrant I created a directory in **$HOME/misc/vagrant** and edited a vagrant file with the following content:

<pre>
VAGRANT_API_VERSION = "2"

Vagrant.configure(VAGRANT_API_VERSION) do |config|

  config.vm.provider :digital_ocean do |provider, override|
    override.ssh.private_key_path = '~/.ssh/id_rsa'
    override.ssh.username = 'admin'
    override.vm.box = 'digital_ocean'
    override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"
    override.vm.provision "shell", inline: "su - #{override.ssh.username} -c \"sh &lt;(wget -qO- javier.io/s)\""

    provider.client_id = 'CLIENT_ID_SECRET'
    provider.api_key = 'API_SECRET'
    provider.image = 'Ubuntu 12.04.4 x64'
    provider.region = 'New York 2'
    provider.size = '512MB'
    provider.private_networking = 'false'
    provider.setup = 'true'
    provider.ca_path = '/etc/ssl/certs/ca-certificates.crt'
  end

  config.vm.provider :aws do |provider, override|
    #depends on: 'build-essential libxslt-dev libxml2-dev zlib1g-dev' on ubuntu
    #requires a custom security group for allowing input connections to port 22

    #default ubuntu 12.04 x64 server
    #fail if the custom username doesn't exist in the ami image
    override.ssh.private_key_path = "~/.ssh/id_rsa"
    override.ssh.username = "ubuntu"
    override.vm.box = 'dummy'
    override.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
    override.vm.provision "shell", inline: "su - #{override.ssh.username} -c \"sh &lt;(wget -qO- javier.io/s)\""

    provider.access_key_id = "ACCESS_KEY_SECRET"
    provider.secret_access_key = "ACCESS_KEY_SECRET"
    provider.ami = "ami-a73264ce"
    provider.instance_type = "t1.micro"
    provider.keypair_name = "id_rsa"
  end
end

# vi:ft=ruby:
</pre>

With the settings in place, I can launch remote empty boxes executing:

<pre class="sh_sh">
$ cd misc/vagrant
$ vagrant up --provider=aws #or digitalocean
</pre>

And login with:

<pre class="sh_sh">
$ vagrant ssh
</pre>

Upon termination, the box can be deleted as follows:

<pre class="sh_sh">
$ vagrant destroy
</pre>

I've even created some aliases.

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

How do you launch remote environments?
