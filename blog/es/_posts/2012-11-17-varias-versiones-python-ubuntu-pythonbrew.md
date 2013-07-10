---
layout: post
title: "instalar varias versiones de python en ubuntu - pythonbrew"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

Para instalar varias versiones de python, se requiere pythonbrew y curl:

<pre class="sh_sh">
$ sudo apt-get install curl python-setuptools
</pre>

### Instalación

Cumplidas las dependencias se instala con:

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
    
Se siguen las instrucciones
    
<pre class="sh_sh">
$ tail ~/.bashrc
[[ -s "$home/.pythonbrew/etc/bashrc" ]]; source "$home/.pythonbrew/etc/bashrc"
$ source ~/.bashrc
$ python install 3.2 #or pythonbrew install --force 3.2
</pre>

### Cambiar entre versiones

Para empezar a usar python 3.2:

<pre class="sh_sh">
$ pythonbrew switch 3.2
</pre>

Para que el sistema utilice nuevamente la versión de python que viene con el (2.7 en Ubuntu precise):

<pre class="sh_sh">
$ pythonbrew off
</pre>

Para eliminar una versión instalada con pythonbrew

<pre class="sh_sh">
$ pythonbrew uninstall 3.2
</pre>

- https://www.edx.org/courses/MITx/6.00x/2012_Fall/wiki/6.00x/installing-different-versions-python-linux-ubuntu/
