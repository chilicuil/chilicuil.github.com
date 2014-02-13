---
layout: post
title: "wcd, un script alrededor de cd"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

<iframe  class="showterm" src="http://showterm.io/ae29f68bee555cd89c65d" width="640" height="350">&nbsp;</iframe> 

Usar la consola, tiene varios inconvenientes, algunos de los cuales son, desde mi punto de vista, la manipulación de archivos, los cambios de directorios y las opciones de los comandos (lo que es para uno no lo es para otro y menos entre SO's).

Algunas de las cosas que hago para contra-restar estos problemas son el uso de [alias](http://ss64.com/bash/alias.html), 150~ al momento de escribir esto, funciones envolvedoras, y últimamente y lo que me llevo a escribir esta entrada, [wcd](http://www.xs4all.nl/~waterlan/).

Configurar adecuadamente el bash, también ayuda, en la versión 4, soporta correción de directorios y 'autocd':

<pre class="sh_sh">
$ head ~/.bashrc
# http://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
if [ $BASH_VERSINFO -ge 4 ]; then
    shopt -s autocd cdspell dirspell                  
fi
</pre>

De tal forma que para llegar al directorio **1/2/3/foo** se puede escribir:

<pre class="sh_sh">
$ cd 1/2/3/foo
$ cd 1/2/3/ofo
$ 1/2/3/foo
</pre>

Creando alias se puede agregar otra capa de confort:

<pre class="sh_sh">
$ head ~/.alias.common
alias ..="cd .."
alias ....="cd ../.."
alias ubuntu.natty="cd misc/packaging/ubuntu/natty"
alias facu.algebra="cd misc/facu/doc/algebra"
</pre>

Existen herramientas como [project_aliases.sh](https://github.com/relevance/etc/blob/master/bash/project_aliases.sh) que lo llevan al extremo y crean alias sobre todo.

[Zsh](http://www.zsh.org) por defecto soporta reconocimiento de patrones, **$ cd s*/*/pl** podría llevarlos a **super/master/plan**

Esta es la idea detras de wcd, traer el reconocimiento de zsh a bash.

Ya que **cd** es un comando especial, solo se puede mandar a llamar a través del comando **source** (con un alias)

<pre class="sh_sh">
$ sudo apt-get install wcd
$ head ~/.alias.common
alias cd='. wcd'
</pre>

Donde **wcd** no es el binario (ver $ sudo dpkg -L wcd para saber a lo que me refiero), sino un script en **/usr/local/bin/wcd** con el siguiente contenido:

<pre class="sh_sh">
#due to cd and subshells nature this script only works if it's sourced
#alias cd=". this_script"

WICD_BIN="/usr/bin/wcd.exec"
WICD_OPTIONS="-j -GN -c -i -f $HOME/.wcd/.treedata.wcd"
#-j     just go mode
#-GN    do not creat go script ($HOME/bin/wicd.go)
#-c     direct cd mode
#-i     case insensitve

#not sure why $@ looks like this if no param is given
if [[ $@ == "completion-ignore-case on" ]]; then
    \cd "`$WICD_BIN $WICD_OPTIONS $HOME`"
else
    #remove backslash before passing it to cd
    CD_PATH=$(echo "`$WICD_BIN $WICD_OPTIONS "$@"`" | sed -e 's:\\::g')                                                                                                                                                          
    \cd "$CD_PATH"
fi
</pre>

De esta manera **$ cd s*/*/pl** me lleva a **super/master/plan**.

¿Cómo funciona?, wcd crea un índice de los directorios y los guarda en **$HOME/.treedata.wcd**, después compara las cadenas con este indice y devuelve el más cercano. Una cosa que se me ocurrio al ver esto es hacerlo con 'locate' como en un [hack](http://www.vim.org/scripts/script.php?script_id=2871) anterior, ummm pero no he podido obtener el resultado que esperaba (todavía), así que usaré esto por un rato...

OJO: como habia dicho, wcd requiere de un índice, este índice se generará cada tanto, sin embargo en caso de que se necesite regenerar antes de tiempo, se puede hacer de esta manera:

<pre class="sh_sh">
$ alias update-cd='mkdir $HOME/.wcd; /usr/bin/wcd.exec \
                   -GN -j -xf $HOME/.ban.wcd -S $HOME"
$ update-cd
</pre>

Para poder usar **$ update-cd** permanentemente se puede agregar el alias a **~/.bashrc** o a un archivo que lo lea, en mi caso **~/.alias.common**

<pre class="sh_sh">
$ man wcd
</pre>
