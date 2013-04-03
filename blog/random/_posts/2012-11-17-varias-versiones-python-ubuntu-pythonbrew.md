---
layout: post
title: "instalar varias versiones de python en ubuntu - pythonbrew"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

<div class="p">Para instalar varias versiones de python, se requiere pythonbrew y curl:
</div>

<pre class="sh_sh">
$ sudo apt-get install curl python-setuptools
</pre>

<h3>Instalación</h3>
<div class="p">Cumplidas las dependencias se instala con:
</div>

<pre class="sh_sh">
$ sudo easy_install pythonbrew
$ pythonbrew_install
Well-done! Congratulations!

The pythonbrew is installed as:
    
  /home/chilicuil/.pythonbrew

Please add the following line to the end of your ~/.bashrc

  [[ -s "$HOME/.pythonbrew/etc/bashrc" ]] && source "$HOME/.pythonbrew/etc/bashrc"

After that, exit this shell, start a new one, and install some fresh
pythons:

  pythonbrew install 2.7.2
  pythonbrew install 3.2

For further instructions, run:

  pythonbrew help

The default help messages will popup and tell you what to do!

Enjoy pythonbrew at /home/chilicuil/.pythonbrew!!
</pre>

<div class="p">Se siguen las instrucciones
</div>

<pre class="sh_sh">
$ tail ~/.bashrc
[[ -s "$home/.pythonbrew/etc/bashrc" ]] && source "$home/.pythonbrew/etc/bashrc"
$ source ~/.bashrc
$ python install 3.2 #or pythonbrew install --force 3.2
</pre>

<h3>Cambiar entre versiones</h3>

<div class="p">Para empezar a usar python 3.2:
</div>

<pre class="sh_sh">
$ pythonbrew switch 3.2
</pre>

<div class="p">Para que el sistema utilice nuevamente la versión de python que viene con el (2.7 en Ubuntu precise):
</div>

<pre class="sh_sh">
$ pythonbrew off
</pre>

<div class="p">Para eliminar una versión instalada con pythonbrew
</div>

<pre class="sh_sh">
$ pythonbrew uninstall 3.2
</pre>

<ul>
    <li><a href="https://www.edx.org/courses/MITx/6.00x/2012_Fall/wiki/6.00x/installing-different-versions-python-linux-ubuntu/" target="_blank">https://www.edx.org/courses/MITx/6.00x/2012_Fall/wiki/6.00x/installing-different-versions-python-linux-ubuntu/</a></li>
</ul>
