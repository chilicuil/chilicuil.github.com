---
layout: post
title: "vim + vundle"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

[![alt text](/assets/img/58.png)](/assets/img/58.png)

En entradas anteriores he escrito sobre [Vim](http://chilicuil.github.com/all/random/2010/04/17/vimmer.html), y aunque no lo hago muy seguido, la verdad es que me la paso modificando su [configuración](https://github.com/chilicuil/dotfiles/blob/master/.vimrc) a tal grado que dudo que justifique el tiempo que le he invertido, de no ser porque me causa alguna clase de enfermiza diversión.

Siendo así, uso/pruebo algunos plugins, por lo que mi **$HOME/.vim/** luce un poco desordenado. Estos plugins se distribuyen de 2 principales formas; desde <http://vim.org> como **.zip/tar.gz/.vba** y como repositorios **git (github)**.

En cualquiera de los casos, la instalación/actualización/eliminación requiere modificar los archivos adecuados en **$HOME/.vim/{doc,plugin,autoload,etc}**, esto esta bien para tipos como yo, a los que no les importa volver a descargar un plugin para ver su estructura y así poder eliminar los archivos correctos. Pero esta lejos de ser una opción cómoda.

Ya habia escuchado hablar con anterioridad de 'manejadores de scripts' para vim como [pathogen](https://github.com/tpope/vim-pathogen)/[vundle](https://github.com/gmarik/vundle), pero no los habia probado porque dada mi configuración, tenia pereza por hacerlo. Sin embargo hace 2 semanas me he convertido a vundle (me ha tomado un par de hrs) y la diferencia es tan buena que me he dado por escribir.

**USEN VUNDLE**

#### Definición

Vundle/pathogen son scripts que permiten aislar otros scripts, esto es, que cada script tenga su propia raíz para poder mejorar el control sobre ellos:

_antes_

<pre>
after autoload colors compiler doc extra-snippets ftdetect
ftplugin indent plugin skeletons snippets spell syntax syntax_checker
</pre>

Los plugins estan distribuidos en **plugin, autoload, after, ftdetect** al estilo de cuando apt-get instala los archivos de programas en /usr, /etc, /var

_después_

<pre>
bundle  colors  extra-snippets  skeleton
</pre>

Todos los plugins tienen su propia carpeta en **bundle**, por lo que **$ rm -rf ./bundle/nerdtree** elimina completamente nerdtree, cool.

No solo eso, estos scripts permiten instalar nuevos plugins através de un solo comando, para el caso de vundle, **:BundleInstall QuickBuf** instalará el QuickBuf (tomado de vim.org)}

#### Vundle vs Pathogen

Elegí Vundle porque no me obliga a usar submódulos de git, con Vundle se especifica en **$HOME/.vimrc** los plugins que se usan y estos se pueden instalar en cualquier momento, así, solo se tiene control **$HOME/.vimrc**. Hay una mejor explicación en:

<http://www.charlietanksley.net/philtex/sane-vim-plugin-management/>

#### Migración

Describiré como lo he hecho yo, no significa que sea la forma correcta, pero si algún día tengo que volver a hacerlo, seguramente lo haré así.

Lo primero que he hecho ha sido mover **.vim** a **.vimb** y ejecutar **$ git rm -r $HOME/.vim** para empezar de 0 

Después he habilitado vundle, lo que se puede hacer si se agrega a **$HOME/.vimrc:**

<pre class="sh_sh">
if !isdirectory(expand(expand("~/.vim/bundle/vundle/.git/"))) "call inputsave()
    echon "Setting up vundle, this may take a while, wanna continue? (y/n): "
    if nr2char(getchar()) ==? 'y'
         !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
endif
"call inputrestore()
endif
set runtimepath+=~/.vim/bundle/vundle/
call vundle#rc()
</pre>

Una vez ahí, he creado una lista con los plugins que no he modificado, ejemplo:

<pre>
Bundle 'gmarik/vundle'
Bundle 'mhz/vim-matchit'
Bundle 'vim-scripts/CRefVim'
Bundle 'scrooloose/nerdtree'
Bundle 'msanders/snipmate.vim'
Bundle 'Shougo/neocomplcache'
Bundle 'Townk/vim-autoclose'
Bundle 'gmunkhbaatarmn/vim-largefile'
Bundle 'vim-scripts/matrix.vim--Yang'
Bundle 'scrooloose/nerdcommenter'
Bundle 'vim-scripts/TaskList.vim'
Bundle 'godlygeek/csapprox'
Bundle 'vim-scripts/DrawIt'
Bundle 'vim-scripts/netrw.vim'
Bundle 'ciaranm/securemodelines'
Bundle 'tpope/vim-markdown'
Bundle 'vim-scripts/irssilog.vim'
Bundle 'mattn/gist-vim'
Bundle 'scrooloose/syntastic'
Bundle 'gmarik/github-search.vim'
Bundle 'QuickBuf'
Bundle 'surround.vim'
Bundle 'repeat.vim'
Bundle 'FindMate'
Bundle 'IndexedSearch'
Bundle 'Align'
</pre>

De esta lista, los scripts que tienen un nombre simple, por ejemplo **Align** o **FindMate** son tomados de vim.org y deben estar escritos igual a como aparece en la descripción (no con el nombre que tienen en la descarga), los otros, por ejemplo **mhz/vim-matchit** o **scrooloose/syntastic** serán tomados de [http://github.com/username/repository](http://github.com/username/repository).

Es interesante notar que existe [vim-scripts](https://github.com/vim-scripts/) donde se alojan en forma de espejo algunos de los scripts de vim.org. Aunque lo óptimo sería que existiera una copia para cada uno.

Para los otros (y aquí es donde entraba la pereza) he creado repositorios, ya sea haciendo un fork primero y luego introduciendo mis cambios (no olvidando hacer una petición de push) o creando el repositorio de una estructura que respetará la que tiene el resto de plugins, es decir con sus directorios, plugin/autoload/ftautoload y los he agregado a la lista. Mil gracias GITHUB por hacer el proceso mucho más facil de lo que se lee.

<pre>
Bundle 'chilicuil/taglist.vim'
Bundle 'chilicuil/dbext.vim'
Bundle 'chilicuil/nextCS'
Bundle 'chilicuil/TeTrIs.vim'
Bundle 'chilicuil/vimbuddy.vim'
</pre>

Listo, hasta aquí llega el proceso estandar, ejecutando **:BundleInstall** dentro de vim, instalará todos los plugins.

Para mi caso particular he copiado de .vimb **skeletons/colors/extra-snippets** a **.vim** y los he reagregado a git.

Los pasos para regenerar mi configuración, son:

<pre class="sh_sh">
$ git clone https://github.com/chilicuil/dotfiles dotfiles
$ cd dotfiles
$ mv .vimrc .vim ../
</pre>

Abrir vim, y correr **:BundleInstall**.

Para finalizar, mantener la configuración de esta forma es tan práctico que ya me ha permitido identificar dos formas de manejar el autocompletado de vim, neocomplcache vs el duo snipmate/acp
