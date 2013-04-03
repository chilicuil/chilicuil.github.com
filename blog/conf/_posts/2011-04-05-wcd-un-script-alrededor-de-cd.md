---
layout: post
title: "wcd, un script alrededor de cd"
---

## {{ page.title }}
<p class="date">{{ page.date | date_to_string }}</p>

<div class="p">Usar la consola, tiene varios inconvenientes, algunos de los cuales son, desde mi punto de vista, la manipulación de archivos, los cambios de directorios y las opciones de los comandos (lo que es para uno no lo es para otro y menos entre SO's).
</div>

<div class="p">Algunas de las cosas que hago para contra-restar estos problemas son el uso de <a href="http://ss64.com/bash/alias.html" target="_blank">alias</a>, 150~ al momento de escribir esto, funciones envolvedoras, y últimamente y lo que me llevo a escribir esta entrada, <a href="http://www.xs4all.nl/~waterlan/" target="_blank">wcd</a>
</div>

<div class="p">Configurar adecuadamente el bash, también ayuda, en la versión 4, soporta correción de directorios y 'autocd':
</div>

<pre class="sh_sh">
$ head ~/.bashrc
# http://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
if [ $BASH_VERSINFO -ge 4 ]; then
    shopt -s autocd cdspell dirspell                  
fi
</pre>

<div class="p">De tal forma que para llegar al directorio <strong>1/2/3/foo</strong> se puede escribir:
</div>

<pre class="sh_sh">
$ cd 1/2/3/foo
$ cd 1/2/3/ofo
$ 1/2/3/foo
</pre>

<div class="p">Creando alias se puede agregar otra capa de confort:
</div>

<pre class="sh_sh">
$ head ~/.alias.common
alias ..="cd .."
alias ....="cd ../.."
alias ubuntu.natty="cd misc/packaging/ubuntu/natty"
alias facu.algebra="cd misc/facu/doc/algebra"
</pre>

<div class="p"> Existen herramientas como <a href="https://github.com/relevance/etc/blob/master/bash/project_aliases.sh" target="_blank">project_aliases.sh</a> que lo llevan al extremo y crean alias sobre todo.
</div>

<div class="p"> <a href="http://www.zsh.org">Zsh</a> por defecto soporta reconocimiento de patrones, <strong>$ cd s*/*/pl*</strong> podría llevarlos a <strong>super/master/plan</strong>.⎈
</div>

<div class="p">Esta es la idea detras de wcd, traer el reconocimiento de zsh a bash.
</div>

<div class="p">Ya que <strong>cd</strong> es un comando especial, solo se puede mandar a llamar a través del comando <strong>source</strong> (con un alias)
</div>

<pre class="sh_sh">
$ sudo apt-get install wcd
$ head ~/.alias.common
alias cd='. wcd'
</pre>

<div class="p">Donde <strong>wcd</strong> no es el binario (ver $ sudo dpkg -L wcd para saber a lo que me refiero), sino un script en <strong>/usr/local/bin/wcd</strong> con el siguiente contenido:
</div>

<pre class="sh_sh">
#due to cd & subshells nature this script only works if it's sourced
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

<div class="p">De esta manera <strong>$ cd s*/*/pl*</strong> me lleva a <strong>super/master/plan</strong>.
</div>

<div class="p">¿Cómo funciona?, wcd crea un índice de los directorios y los guarda en <strong>$HOME/.treedata.wcd</strong>, después compara las cadenas con este indice y devuelve el más cercano. Una cosa que se me ocurrio al ver esto es hacerlo con 'locate' como en un <a href="http://www.vim.org/scripts/script.php?script_id=2871" target="_blank">hack</a> anterior, ummm pero no he podido obtener el resultado que esperaba (todavía), así que usaré esto por un rato...
</div>

<div class="p">OJO: como habia dicho, wcd requiere de un índice, este índice se generará cada tanto, sin embargo en caso de que se necesite regenerar antes de tiempo, se puede hacer de esta manera:
</div>

<pre class="sh_sh">
$ alias update-cd='mkdir $HOME/.wcd; /usr/bin/wcd.exec \
                   -GN -j -xf $HOME/.ban.wcd -S $HOME"
$ update-cd
</pre>

<div class="p">Para poder usar <strong>$ update-cd</strong> permanentemente se puede agregar el alias a <strong>~/.bashrc</strong> o a un archivo que lo lea, en mi caso <strong>~/.alias.common</strong>
</div>

<pre class="sh_sh">
$ man wcd
</pre>
