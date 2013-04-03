---
layout: post
title: "autocompletado en bash"
---

## {{ page.title }}
<p class="date">{{ page.date | date_to_string }}</p>

<div align="center" id="img">
<a href="/assets/img/54.png"><img src="/assets/img/54.png" style="width: 306px; height: 75px;"></a>
</div>

<div class="p">Me gustan los entornos minimalistas y el uso de la consola, me parece genial poder escribir una línea y obtener un resultado concreto, lamentablemente algunos de los comandos para la terminal no son especialmente amigables, contienen muchas opciones y algunas veces esas opciones tienen nombres largos y extraños. Cuando se trata de scripts que encontraste en Internet, la cosa empeora, las opciones siempre hay que escribirlas porque el 99% de las veces no vienen con autocompletado.
</div>

<div class="p">Viendo este problema y habiendo generado archivos de autocompletado para mis propios scripts, he decidido escribir algunas notas.
</div>

<h3>Introducción</h3>

<div class="p">Bash es capaz de completar comandos con <strong>&lt;Tab&gt;&lt;Tab&gt;</strong>, sin embargo cuando se crean scripts caseros o se encuentran en Internet casi siempre vienen sin esa característica, escribir las opciones una y otra vez no es del todo práctico, además de eso, muchas veces esos comandos tienen tantas opciones que se olvidan||confunden.
</div>

<div class="p">El comando que está detrás de tal magia es <strong>complete</strong>, este comando define la forma en la que se completará una palabra (no necesariamente un comando), por ejemplo si se quisiera que '<strong>foo</strong>' se autocompletara con nombres de directorios se podría ejecutar:
</div>

<pre class="sh_sh">
$ complete -o plusdirs foo
</pre>

<div class="p">A partir de ese momento <strong>$ foo &lt;Tab&gt;&lt;Tab&gt;</strong> devolvería una lista de directorios, de la misma manera si existiera un directorio '<strong>imgs</strong>' y se pusiera <strong>$ foo i&lt;Tab&gt;&lt;Tab&gt;</strong> la terminal completaría '<strong>imgs</strong>', quedando <strong>$ foo imgs</strong>
</div>

<pre class="sh_sh">
$ complete -A user bar #autocompletará bar con los usuarios del sistema
$ complete -W "-v --verbose -h" wop #autocompletará con "-v", "--verbose" y "-h"
</pre>

<div class="p">La sintaxis completa esta definida en <strong>$ man bash</strong>
</div>

<h3>Desarrollo</h3>

<div class="p">Una de las opciones que acepta <strong>complete</strong> es <strong>-F</strong> que permite llamar a una función. Siendo así se puede ejecutar
</div>

<pre class="sh_sh">
$ source script_donde_se_define_primp()
$ complete -F _primp primp
</pre>

<div class="p">Y <strong>_primp()</strong> se encargaría de crear la lista de opciones, esto es útil para tomar el control total sobre el autocompletado, de esta forma se puede hacer que el autocompletado se comporte de diferente manera dependiendo del contexto.
</div>

<div class="p">Los archivos que declaran estas funciones 'viven' en <strong>/etc/bash_completion.d/</strong>, ejemplo, si se tiene el siguiente script, existen dos formas de obtener autocompletado en la terminal, el primero directo (pero menos configurable) y el segundo en forma de función, más dificil de implementar, pero también con mayores posibilidades.
</div>

<pre class="sh_sh">
$ fix -h
Usage: fix module
   -h  or --help     List available arguments and usage (this message).
   -v  or --version  Print version.
   apache            Moves /etc/init.d/apache2.1 to apache2.
   ipw2200           Restart the ipw2200 module.
   wl                Restart the wl module.
   iwlagn            Restart the iwlagn module.
   mpd               Restart mpd.
</pre>

<div class="p">Para el primer caso se puede crear la siguiente línea y agregarla a <strong>/etc/bash_completion.d/fix.autocp</strong>:
</div>

<pre class="sh_sh">
$ complete -W "-h --help -v --version apache ipw2200 wl iwlagn mpd" fix
</pre>

<div class="p">Una vez hecho, se recarga el entorno de bash y se puede usar el autocompletado:
</div>

<pre class="sh_sh">
$ source $HOME/.bashrc
</pre>

<div class="p">OJO: esto solo funciona si en el archivo <strong>$HOME/.bashrc</strong> se inicializa bash_completion (también debe estar instalado $ sudo apt-get install bash-completion)
</div>

<pre class="sh_sh">
if [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
fi
</pre>

<div class="p">Para el segundo caso, se crea una función, y se relaciona con el script 'fix', las funciones también se declaran en <strong>/etc/bash_completion.d/fix.autocp</strong>:
</div>

<pre class="sh_sh">
_fix()
{
    #program_name=$1
    #cur=$2
    #cur="${COMP_WORDS[COMP_CWORD]}"
    #cur=$(_get_cword)
    #prev=$3
    #$4 doesn't exist
    local cur prev opts #$cur, $prev & $opts are local vars
    COMPREPLY=() #clean out last completions, important!
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    COMMANDS="apache ipw2200 wl iwlagn mpd"
    OPTS="-h --help -v --version"
    case "${cur}" in #if the current word containst '-' at the beginning..
        -*)
            completions="$OPTS"
            ;;
        *)
            completions="$COMMANDS"
            ;;
    esac
    COMPREPLY=( $( compgen -W "$completions" -- $cur ))
    return 0
}
complete -F _fix fix
</pre>

<div class="p">La variable <strong>$cur</strong> es importante porque contra ella se hará la comparación (en una función de opciones anidadas tambien se leera la variable <strong>$prev</strong>, o incluso la <strong>$prev_prev</strong>, que es como le llamo a la opción previa de la previa...), sin embargo este es un ejemplo simple.
</div>

<div class="p">El único propósito de estas funciones es llenar con valores la variable <strong>$COMPREPLY</strong>, esta es la única que sobrevivirá al proceso y contendrá la lista de opciones finales.
</div>

<div class="p">Una herramienta que se usa en el 99% de las funciones es <strong>compgen</strong>, este comando hace comparaciones entre cadenas, recibe una lista de palabras (como un array) y luego una cadena, compara estas contra la lista en el array y devuelve las que concuerden.
</div>

<pre class="sh_sh">
$ compgen -W "-v --verbose -h --help" -- "-v"
-v
$ compgen -W "-v --verbose -h --help" -- "--"
--verbose
--help
$ compgen -W "apache ipw2200 iwlagn mpd wl" -- "ap"
apache
$ compgen -W "apache ipw2200 iwlagn mpd wl" -- "i"
ipw2200
iwlagn
</pre>

<div class="p">Entiendiendo estas dos partes, es más fácil ver que la función compara lo que hay en <strong>$cur</strong> contra la lista de <strong>$completions</strong> y el resultado se guarda en <strong>$COMPREPLY</strong>, ese resultado es el que devuelve la shell una vez se haya presionado <strong>&lt;Tab&gt;&lt;Tab&gt;</strong>
</div>

<div class="p">
En el ejemplo anterior, no se puede ver la ventaja de usar una función en lugar de una línea de <strong>complete</strong>, sin embargo en comandos que manejan más opciones, como <strong>android</strong>, la única forma de crear autocompletado pseudo-inteligente es con una función.
</div>

<pre class="sh_sh">
$ android -h
Usage:
android [global options] action [action options]
Global options:
-v --verbose  Verbose mode: errors, warnings and informational messages are printed.
-h --help     Help on a specific command.
-s --silent   Silent mode: only errors are printed out.
Valid actions are composed of a verb and an optional direct object:
-   list          
-   list avd         
-   list target     
- create avd        
-   move avd       
- delete avd       
- update avd       
- create project    
- update project    
- create test-project 
- update test-project 
- create lib-project  
- update lib-project 
- update adb 
- update sdk     
</pre>

<div class="p">El autocompletado de este script varia dependiendo del subcomando:
</div>

<pre class="sh_sh">
$ android list[Tab][Tab]
</pre>

<div class="p">Esto devolvería <strong>avd</strong> o <strong>target</strong>:
</div>

<pre class="sh_sh">
$ android create[Tab][Tab]
</pre>

<div class="p">Devolvería <strong>avd</strong>, <strong>project</strong>, <strong>test-project</strong> o <strong>lib-project</strong>:
</div>

<pre class="sh_sh">
$ android create avd[Tab][Tab]
</pre>

<div class="p">Devolvería <strong>-a</strong>, <strong>-c</strong>, <strong>-f</strong>, etc. Es decir dependiendo del contexto devuelve diferentes valores, el archivo completo de este ejemplo esta en <a href="https://github.com/chilicuil/learn/blob/master/autocp/bash_completion.d/android.autocp" target="_blank">github</a>, ahora explicaré las partes más importantes:
</div>

<pre class="sh_sh">
_android()
{
    local cur prev opts #local vars
    COMPREPLY=() #clean out last completions, important!
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    number_of_words=${#COMP_WORDS[@]}

    if [[ $number_of_words -gt 2 ]]; then
        prev_prev="${COMP_WORDS[COMP_CWORD-2]}"
    fi
</pre>

<div class="p">Si el número de palabras es mayor que 2 (<strong>-gt</strong> "greater than"), entonces existe un anterior al anterior y se puede declarar esa variable, <strong>$prev_prev</strong>
</div>

<pre class="sh_sh">
#=======================================================
#                  General options
#=======================================================
COMMANDS="list create move delete update"
#COMMANDS=`android -h | grep '^-' | sed -r 's/: .*//' \
           | awk '{print $2}' | sort | uniq 2> /dev/null`
</pre>

<div class="p">Lo que se ponga en las variables que se usarán para autcompletar pueden deducir del binario (aunque sería un tanto más lento) o escribirlas directamente (lo que no las haría confiables si el programa decidiera quitar o agregar otras opciones en futuras versiones).
</div>

<pre class="sh_sh">
OPTS="-h --help -v --verbose -s --silent"
#=======================================================
#                   Nested options [1st layer]
#=======================================================
list_opts="avd target"
create_opts="avd project test-project lib-project"
move_opts="avd"...
</pre>

<div class="p">Opciones de subcomandos...
</div>

<pre class="sh_sh">
#=======================================================
#                   Nested options [2nd layer]
#=======================================================
create_avd_opts="-c --sdcard -t --target -n --name -a \
                 --snapshot -p --path -f -s --skin"
create_project_opts="-n --name -t --target -p --path -k \
                     --package -a --activity"
create_test-project_opts="-p --path -m --main -n --name"
create_lib-project_opts="-n --name -p --path -t --target \
                         -k --package"...
</pre>

<div class="p">y las opciones de esos comandos a su vez @.@'
</div>

<pre class="sh_sh">
if [[ -n $prev_prev ]]; then
#2nd layer
case "${prev_prev}" in
  create)
    case "${prev}" in
      avd)
         COMPREPLY=( $( compgen -W "$create_avd_opts" -- $cur ))
         return 0
         ;;
      project)
         COMPREPLY=( $( compgen -W "$create_project_opts" -- $cur ))
         return 0
         ;;
         ...
 esac
</pre>

<div class="p">Dependiendo de <strong>$prev_prev</strong>, de <strong>$prev</strong> y de <strong>$cur</strong> se devolverá la lista apropiada de opciones, el comando es de la forma <strong>$ android subcomando opcion opcion_incompleta#CURSOR#</strong>
</div>

<pre class="sh_sh">
case "${prev}" in
    ##1st layer
    list)
        COMPREPLY=( $( compgen -W "$list_opts" -- $cur ))
        return 0
        ;;
    create)
        COMPREPLY=( $( compgen -W "$create_opts" -- $cur ))
        return 0
        ;;
    ...
        ;;
esac ...
</pre>

<div class="p">Dependiendo de <strong>$prev</strong> y de <strong>$cur</strong> se devolverá la lista apropiada, <strong>$ android subcomando opcion_incompleta#CURSOR#</strong>
</div>

<pre class="sh_sh">
      #general options
      case "${cur}" in
         -*)
             COMPREPLY=( $( compgen -W "$OPTS" -- $cur ))
             ;;
         *)
             COMPREPLY=( $( compgen -W "$COMMANDS" -- $cur ))
             ;;
      esac
}
complete -F _android android
</pre>

<div class="p">Dependiendo de <strong>$cur</strong> se crea una lista, no existe ni <strong>$prev,</strong> ni <strong>$prev_prev</strong>, el comando es de la forma <strong>$ android opcion_incompleta#CURSOR#</strong>
</div>

<h3>Extra</h3>

<h4>Palabras clave</h4>

<div class="p">En el ejemplo anterior se utiliza <strong>case</strong> para determinar los comandos que siguen, sin embargo también se puede iterar para encontrar las palabras clave:
</div>

<pre class="sh_sh">
for (( i=0; i < ${#COMP_WORDS[@]}-1; i++ )); do
    if [[ ${COMP_WORDS[i]} == @(opcion1|opcion2|opcion3) ]]; then
        special=${COMP_WORDS[i]}
    fi
done

if [ -n "$special" ]; then
    case $special in
    ...
    esac
fi
</pre>

<h4>Sufijos y prefijos</h4>

<div class="p">Algunos comandos tienen opciones que requieren '=' al final:
</div>

<pre class="sh_sh">
$ foo source=/etc/foo.conf
</pre>

<div class="p">En ese caso <strong>compgen</strong> con las opciones <strong>-S</strong> y <strong>-P</strong> pueden ayudar con el sufijo y prefijo...
</div>

<h4>Funciones existentes</h4>

<div class="p">Se pueden usar funciones existes, por ejemplo si la opcion -f acepta archivos dentro de un comando (de file en inglés), se puede usar <strong>_filedir</strong> de la siguiente manera:
</div>

<pre class="sh_sh">
-f)
    _filedir
    return 0
    ;;
</pre>

<h4>IFS</h4>

<div class="p">Es posible que en algunos casos la lista que se use dentro de <strong>compgen</strong> tenga que ser separada por comas, saltos de carros u otros caracteres diferentes a los que se encuentran en por defecto en <strong>$IFS</strong> (TAB,SPACE,NEW LINE), en ese caso se puede cambiar temporalmente esa variable para partir las palabras de la forma adecuada, por ejemplo para detectar la lista de máquinas virtuales en vboxheadless (interfaz de virtualbox), cuyos nombres tienen espacios:
</div>

<pre class="sh_sh">
case $prev in
   @(-s|-startvm|--startvm))
       OLDIFS="$IFS"
       IFS=$'\n'
       COMPREPLY=($(compgen -W "$(vboxmanage list vms | cut -d\" -f2)" -- $cur))
       IFS="$OLDIFS"
       return 0
       ;;
       ...
esac
</pre>

<h4>Debug</h4>

<div class="p">La forma de corregir errores es habilitando el modo verbose de bash:
</div>

<pre class="sh_sh">
$ set -v
</pre>

<div class="p">Recargando la lista de funciones
</div>

<pre class="sh_sh">
$ source ~/.bashrc
</pre>

<div class="p">Y probando el autocompletado
</div>

<pre class="sh_sh">
$ comando opc[Tab][Tab]
...
...
... salida verbosa
</pre>

<div class="p">Una lista no exaustiva de archivos /etc/bash_completion.d donde he encontrado estas técnicas han sido:
</div>

<ul>
	<li>apt</li>
	<li>apt-build</li>
	<li>nslookup</li>
	<li>...</li>
</ul>

<div class="p">Además de eso tengo algunos scripts de estos en <a href="https://github.com/chilicuil/learn/tree/master/autocp/bash_completion.d" target="_blank">github</a>, tal vez a alguién se le ocurra usarlos como esqueletos a la hr de crear nuevos scripts.

<h3>Conclusión</h3>

<div class="p">El autocompletado puede parecer complicado, pero en realidad una vez que se leen varios snippets se puede vislumbrar un patrón bien definido, dado que son scripts en bash, la curva de aprendizaje es relativamente baja y provee recompensa inmediata, #bash en freenode ayuda mucho para encontrar sentido a los bashismos que son más dificiles de ver.
</div>

<ul>
	<li><a href="http://bash-completion.alioth.debian.org/" target="_blank">http://bash-completion.alioth.debian.org/</a></li>
</ul>