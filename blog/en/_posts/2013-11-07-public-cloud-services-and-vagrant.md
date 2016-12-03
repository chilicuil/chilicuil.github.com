---
layout: post
title: "public cloud services (digitalocean, aws) and vagrant"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

**[![](/assets/img/86.png)](/assets/img/86.png)**
<!--<iframe class="showterm" src="http://showterm.io/ce9681926ec6875d743f1" width="640" height="350">&nbsp;</iframe>-->

I like to keep a fast, ordered and stable computer, that's why I use virtual machines, containers, public cloud services and other means to keep it that way, all my ram belongs to firefox &#128517;

The cloud is great, I can do more with less because they usually have more resources than my laptop and plenty of bandwidth &#128525;. My favorite elastic cloud is [DigitalOcean](http://digitalocean.com/) ($5/month), sometime ago also tried [Ec2](http://aws.amazon.com/ec2/) but its pricing scheme made me uncomfortable. Other than that, I also use [Low End Boxes](http://lowendbox.com/) (LEB) when running long term tasks, it's amazing how far you can go with a $20/year box.

So, getting back to the main topic, it turns out than through plugins, [vagrant](http://www.vagrantup.com/) is able to launch and provision to remote machines, that's what I'm using to interact with cloud instances.

<pre class="sh_sh">
$ vagrant up --provider=digital_ocean
$ vagrant up --provider=aws
</pre>

It's not perfect, vagrant takes ages just to print a help screen, but I think I can manage to use it till I find something better, recommendations are welcome.

## Vagrant

Vagrant installation process is a breeze, it supports OSX, Windows and Linux, in some Linux distributions it's even included in official repositories, but such versions are commonly out of date, that's the case with Ubuntu, so it's better to download Vagrant from its site.

- [http://downloads.vagrantup.com/](http://downloads.vagrantup.com/)

<pre class="sh_sh">
$ sudo dpkg -i vagrant_version.deb
$ #vagrant will be installed in /opt/vagrant/
</pre>

### Vagrant-digitalocean

Once vagrant is onboard, it can be used to download plugins.

<pre class="sh_sh">
$ vagrant plugin install vagrant-digitalocean
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

To play well with aws, you'll need to create a new [default security group](https://github.com/mitchellh/vagrant-aws/issues/95) that allows inbound connections through port 22, it's dump considering the plugin can deploy new instances but it doesn't upload a valid security group afterwards. Don't forget to upload your public ssh key too.

### Vagrantfile

Finally, the additional providers can be used in Vagrantfile files:

<pre>
VAGRANT_API_VERSION = "2"

Vagrant.configure(VAGRANT_API_VERSION) do |config|

  config.vm.provider :digital_ocean do |provider, override|
    override.ssh.private_key_path = '~/.ssh/id_rsa'
    override.ssh.username = 'admin'
    override.vm.box = 'digital_ocean'
    override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"
    override.vm.provision "shell", inline: "su - #{override.ssh.username} -c \"sh <(wget -qO- javier.io/s)\""

    provider.image = 'ubuntu-12-04-x64'
    provider.region = 'nyc2'
    #provider.size = '16gb'
    #provider.size = '8gb'
    #provider.size = '4gb'
    #provider.size = '2gb'
    #provider.size = '1gb'
    provider.size = '512mb'
    provider.private_networking = 'false'
    provider.setup = 'true'
    provider.token = 'ACCESS_KEY_SECRET'
    provider.ca_path = '/etc/ssl/certs/ca-certificates.crt'
  end

  config.vm.provider :aws do |provider, override|
    #depends on: 'build-essential libxslt-dev libxml2-dev zlib1g-dev' on ubuntu
    #requires a custom security group to allow input connections to port 22

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

And used with vagrant to launch empty remote boxes:

<pre class="sh_sh">
$ vagrant up --provider=digital && vagrant ssh
$ vagrant up --provider=aws     && vagrant ssh
</pre>

Don't forget to destroy the instances to avoid extra charges.

<pre class="sh_sh">
$ vagrant destroy
</pre>

That's it, how do you launch remote environments?
