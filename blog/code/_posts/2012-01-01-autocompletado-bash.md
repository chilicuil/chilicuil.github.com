---
layout: post
title: "autocompletado en bash"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

[![alt text](/assets/img/54.png)](/assets/img/54.png)

Me gustan los entornos minimalistas y el uso de la consola, me parece genial poder escribir una línea y obtener un resultado concreto, lamentablemente algunos de los comandos para la terminal no son especialmente amigables, contienen muchas opciones y algunas veces esas opciones tienen nombres largos y extraños. Cuando se trata de scripts que encontraste en Internet, la cosa empeora, las opciones siempre hay que escribirlas porque el 99% de las veces no vienen con autocompletado.

Viendo este problema y habiendo generado archivos de autocompletado para mis propios scripts, he decidido escribir algunas notas.

### Introducción

Bash es capaz de completar comandos con **&lt;Tab&gt;&lt;Tab&gt;**, sin embargo cuando se crean scripts caseros o se encuentran en Internet casi siempre vienen sin esa característica, escribir las opciones una y otra vez no es del todo práctico, además de eso, muchas veces esos comandos tienen tantas opciones que se olvidan||confunden.

El comando que está detrás de tal magia es **complete**, este comando define la forma en la que se completará una palabra (no necesariamente un comando), por ejemplo si se quisiera que '**foo**' se autocompletara con nombres de directorios se podría ejecutar:

<pre class="sh_sh">
$ complete -o plusdirs foo
</pre>

A partir de ese momento **$ foo &lt;Tab&gt;&lt;Tab&gt;** devolvería una lista de directorios, de la misma manera si existiera un directorio '**imgs**' y se pusiera **$ foo i&lt;Tab&gt;&lt;Tab&gt;** la terminal completaría '**imgs**', quedando **$ foo imgs**

<pre class="sh_sh">
$ complete -A user bar #autocompletará bar con los usuarios del sistema
$ complete -W "-v --verbose -h" wop #autocompletará con "-v", "--verbose" y "-h"
</pre>

La sintaxis completa esta definida en **$ man bash**

### Desarrollo

Una de las opciones que acepta **complete** es **-F** que permite llamar a una función. Siendo así se puede ejecutar

<pre class="sh_sh">
$ source script_donde_se_define_primp()
$ complete -F _primp primp
</pre>

Y **_primp()** se encargaría de crear la lista de opciones, esto es útil para tomar el control total sobre el autocompletado, de esta forma se puede hacer que el autocompletado se comporte de diferente manera dependiendo del contexto.

Los archivos que declaran estas funciones 'viven' en **/etc/bash_completion.d/**, ejemplo, si se tiene el siguiente script, existen dos formas de obtener autocompletado en la terminal, el primero directo (pero menos configurable) y el segundo en forma de función, más dificil de implementar, pero también con mayores posibilidades.

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

Para el primer caso se puede crear la siguiente línea y agregarla a **/etc/bash_completion.d/fix.autocp**:

<pre class="sh_sh">
$ complete -W "-h --help -v --version apache ipw2200 wl iwlagn mpd" fix
</pre>

Una vez hecho, se recarga el entorno de bash y se puede usar el autocompletado:

<pre class="sh_sh">
$ source $HOME/.bashrc
</pre>

OJO: esto solo funciona si en el archivo **$HOME/.bashrc** se inicializa bash_completion (también debe estar instalado $ sudo apt-get install bash-completion)

<pre class="sh_sh">
if [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
fi
</pre>

Para el segundo caso, se crea una función, y se relaciona con el script 'fix', las funciones también se declaran en **/etc/bash_completion.d/fix.autocp**:

<pre class="sh_sh">
_fix()
{
    #program_name=$1
    #cur=$2
    #cur="${COMP_WORDS[COMP_CWORD]}"
    #cur=$(_get_cword)
    #prev=$3
    #$4 doesn't exist
    local cur prev opts #$cur, $prev &amp $opts are local vars
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

La variable **$cur** es importante porque contra ella se hará la comparación (en una función de opciones anidadas tambien se leera la variable **$prev**, o incluso la **$prev_prev**, que es como le llamo a la opción previa de la previa...), sin embargo este es un ejemplo simple.

El único propósito de estas funciones es llenar con valores la variable **$COMPREPLY**, esta es la única que sobrevivirá al proceso y contendrá la lista de opciones finales.

Una herramienta que se usa en el 99% de las funciones es **compgen**, este comando hace comparaciones entre cadenas, recibe una lista de palabras (como un array) y luego una cadena, compara estas contra la lista en el array y devuelve las que concuerden.

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

Entiendiendo estas dos partes, es más fácil ver que la función compara lo que hay en **$cur** contra la lista de **$completions** y el resultado se guarda en **$COMPREPLY**, ese resultado es el que devuelve la shell una vez se haya presionado **&lt;Tab&gt;&lt;Tab&gt;**


En el ejemplo anterior, no se puede ver la ventaja de usar una función en lugar de una línea de **complete**, sin embargo en comandos que manejan más opciones, como **android**, la única forma de crear autocompletado pseudo-inteligente es con una función.

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

El autocompletado de este script varia dependiendo del subcomando:

<pre class="sh_sh">
$ android list[Tab][Tab]
</pre>

Esto devolvería **avd** o **target**:

<pre class="sh_sh">
$ android create[Tab][Tab]
</pre>

Devolvería **avd**, **project**, **test-project** o **lib-project**:

<pre class="sh_sh">
$ android create avd[Tab][Tab]
</pre>

Devolvería **-a**, **-c**, **-f**, etc. Es decir dependiendo del contexto devuelve diferentes valores, el archivo completo de este ejemplo esta en [github](https://github.com/chilicuil/learn/blob/master/autocp/bash_completion.d/android.autocp), ahora explicaré las partes más importantes:

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

Si el número de palabras es mayor que 2 (**-gt** "greater than"), entonces existe un anterior al anterior y se puede declarar esa variable, **$prev_prev**

<pre class="sh_sh">
#=======================================================
#                  General options
#=======================================================
COMMANDS="list create move delete update"
#COMMANDS=`android -h | grep '^-' | sed -r 's/: .*//' \
           | awk '{print $2}' | sort | uniq 2> /dev/null`
</pre>

Lo que se ponga en las variables que se usarán para autcompletar pueden deducir del binario (aunque sería un tanto más lento) o escribirlas directamente (lo que no las haría confiables si el programa decidiera quitar o agregar otras opciones en futuras versiones).

<pre class="sh_sh">
OPTS="-h --help -v --verbose -s --silent"
#=======================================================
#                   Nested options [1st layer]
#=======================================================
list_opts="avd target"
create_opts="avd project test-project lib-project"
move_opts="avd"...
</pre>

Opciones de subcomandos...

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

y las opciones de esos comandos a su vez @.@'

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

Dependiendo de **$prev_prev**, de **$prev** y de **$cur** se devolverá la lista apropiada de opciones, el comando es de la forma **$ android subcomando opcion opcion_incompleta#CURSOR#**

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

Dependiendo de **$prev** y de **$cur** se devolverá la lista apropiada, **$ android subcomando opcion_incompleta#CURSOR#**

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

Dependiendo de **$cur** se crea una lista, no existe ni **$prev,** ni **$prev_prev**, el comando es de la forma **$ android opcion_incompleta#CURSOR#**

### Extra

#### Palabras clave

En el ejemplo anterior se utiliza **case** para determinar los comandos que siguen, sin embargo también se puede iterar para encontrar las palabras clave:

<pre class="sh_sh">
for (( i=0; i < ${#COMP_WORDS[@]}-1; i++ )); do
    if [[ ${COMP_WORDS[i]} == @(opcion1|opcion2|opcion3) ]]; then
        special=${COMP_WORDS[i]}
    fi
done
</pre>

<pre class="sh_sh">
if [ -n "$special" ]; then
    case $special in
    ...
    esac
fi
</pre>

#### Sufijos y prefijos

Algunos comandos tienen opciones que requieren '=' al final:

<pre class="sh_sh">
$ foo source=/etc/foo.conf
</pre>

En ese caso **compgen** con las opciones **-S** y **-P** pueden ayudar con el sufijo y prefijo...

#### Funciones existentes

Se pueden usar funciones existes, por ejemplo si la opcion -f acepta archivos dentro de un comando (de file en inglés), se puede usar **_filedir** de la siguiente manera:

<pre class="sh_sh">
-f)
    _filedir
    return 0
    ;;
</pre>

#### IFS

Es posible que en algunos casos la lista que se use dentro de **compgen** tenga que ser separada por comas, saltos de carros u otros caracteres diferentes a los que se encuentran en por defecto en **$IFS** (TAB,SPACE,NEW LINE), en ese caso se puede cambiar temporalmente esa variable para partir las palabras de la forma adecuada, por ejemplo para detectar la lista de máquinas virtuales en vboxheadless (interfaz de virtualbox), cuyos nombres tienen espacios:

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

#### Debug

La forma de corregir errores es habilitando el modo verbose de bash:

<pre class="sh_sh">
$ set -v
</pre>

Recargando la lista de funciones

<pre class="sh_sh">
$ source ~/.bashrc
</pre>

Y probando el autocompletado

<pre class="sh_sh">
$ comando opc[Tab][Tab]
...
...
... salida verbosa
</pre>

Una lista no exaustiva de archivos /etc/bash_completion.d donde he encontrado estas técnicas han sido:


- apt
- apt-build
- nslookup
- ...

Además de eso tengo algunos scripts de estos en [github](https://github.com/chilicuil/learn/tree/master/autocp/bash_completion.d), tal vez a alguién se le ocurra usarlos como esqueletos a la hr de crear nuevos scripts.

### Conclusión

El autocompletado puede parecer complicado, pero en realidad una vez que se leen varios snippets se puede vislumbrar un patrón bien definido, dado que son scripts en bash, la curva de aprendizaje es relativamente baja y provee recompensa inmediata, #bash en freenode ayuda mucho para encontrar sentido a los bashismos que son más dificiles de ver.

- <http://bash-completion.alioth.debian.org/>
