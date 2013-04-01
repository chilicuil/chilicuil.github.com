---
layout: post
title: "vim + vundle"
---

<h2>{{ page.title }}</h2>

<div class="publish_date">{{ page.date | date_to_string }}</div>

<div align="center"><img src="/assets/img/58.png" style="width: 306px; height: 214px;">
</div>

<div class="justify">En entradas anteriores he escrito sobre <a href="http://chilicuil.github.com/all/random/2010/04/17/vimmer.html" target="_blank">Vim</a>, y aunque no lo hago muy seguido, la verdad es que me la paso modificando su <a href="https://github.com/chilicuil/dotfiles/blob/master/.vimrc" target="_blank">configuración</a> a tal grado que dudo que justifique el tiempo que le he invertido, de no ser porque me causa alguna clase de enfermiza diversión.
</div>

<div class="p">Siendo así, uso/pruebo algunos plugins, por lo que mi <strong>$HOME/.vim/</strong> luce un poco desordenado. Estos plugins se distribuyen de 2 principales formas; desde <a href="http://vim.org" target="_blank">vim.org</a> como <strong>.zip/tar.gz/.vba</strong> y como repositorios <strong>git (github)</strong>.
</div>

<div class="p">En cualquiera de los casos, la instalación/actualización/eliminación requiere modificar los archivos adecuados en <strong>$HOME/.vim/{doc,plugin,autoload,etc}</strong>, esto esta bien para tipos como yo, a los que no les importa volver a descargar un plugin para ver su estructura y así poder eliminar los archivos correctos. Pero esta lejos de ser una opción cómoda.
</div>

<div class="p">Ya habia escuchado hablar con anterioridad de 'manejadores de scripts' para vim como <a href="https://github.com/tpope/vim-pathogen">pathogen</a>/<a href="https://github.com/gmarik/vundle">vundle</a>, pero no los habia probado porque dada mi configuración, tenia pereza por hacerlo. Sin embargo hace 2 semanas me he convertido a vundle (me ha tomado un par de hrs) y la diferencia es tan buena que me he dado por escribir.
</div>

<div align="center"><strong>USEN VUNDLE</strong>
</div>

<h4>Definición</h4>

<div class="p">Vundle/pathogen son scripts que permiten aislar otros scripts, esto es, que cada script tenga su propia raíz para poder mejorar el control sobre ellos:
</div>

<div class="p">_antes_</div>

<pre>
after autoload colors compiler doc extra-snippets ftdetect
ftplugin indent plugin skeletons snippets spell syntax syntax_checker
</pre>

<div class="p">Los plugins estan distribuidos en <strong>plugin, autoload, after, ftdetect</strong> al estilo de cuando apt-get instala los archivos de programas en /usr, /etc, /var
</div>

<div class="p">_después_</div>

<pre>
bundle  colors  extra-snippets  skeleton
</pre>

<div class="p">Todos los plugins tienen su propia carpeta en <strong>bundle</strong>, por lo que <strong>$ rm -rf ./bundle/nerdtree</strong> elimina completamente nerdtree, cool.
</div>

<div class="p">No solo eso, estos scripts permiten instalar nuevos plugins através de un solo comando, para el caso de vundle, <strong>:BundleInstall QuickBuf</strong> instalará el QuickBuf (tomado de vim.org)}
</div>

<h4>Vundle vs Pathogen</h4>

<div class="p">Elegí Vundle porque no me obliga a usar submódulos de git, con Vundle se especifica en <strong>$HOME/.vimrc</strong> los plugins que se usan y estos se pueden instalar en cualquier momento, así, solo se tiene control <strong>$HOME/.vimrc</strong>. Hay una mejor explicación en:
</div>

<div class="p"><a href="http://www.charlietanksley.net/philtex/sane-vim-plugin-management/" target="_blank">http://www.charlietanksley.net/philtex/sane-vim-plugin-management/</a>

<h4>Migración</h4>

<div class="p">Describiré como lo he hecho yo, no significa que sea la forma correcta, pero si algún día tengo que volver a hacerlo, seguramente lo haré así.
</div>

<div class="p">Lo primero que he hecho ha sido mover <strong>.vim</strong> a <strong>.vimb</strong> y ejecutar <strong>$ git rm -r $HOME/.vim</strong> para empezar de 0 
</div>

<div class="p">Después he habilitado vundle, lo que se puede hacer si se agrega a <strong>$HOME/.vimrc:</strong>
</div>

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

<div class="p">Una vez ahí, he creado una lista con los plugins que no he modificado, ejemplo:
</div>

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

<div class="p">De esta lista, los scripts que tienen un nombre simple, por ejemplo <strong>Align</strong> o <strong>FindMate</strong> son tomados de vim.org y deben estar escritos igual a como aparece en la descripción (no con el nombre que tienen en la descarga), los otros, por ejemplo <strong>mhz/vim-matchit</strong> o <strong>scrooloose/syntastic</strong> serán tomados de <a href="http://github.com/username/repository" target="_blank">http://github.com/username/repository</a>
</div>

<div class="p">Es interesante notar que existe <a href="https://github.com/vim-scripts/" target="_blank">vim-scripts</a> donde se alojan en forma de espejo algunos de los scripts de vim.org. Aunque lo óptimo sería que existiera una copia para cada uno.
</div>

<div class="p">Para los otros (y aquí es donde entraba la pereza) he creado repositorios, ya sea haciendo un fork primero y luego introduciendo mis cambios (no olvidando hacer una petición de push) o creando el repositorio de una estructura que respetará la que tiene el resto de plugins, es decir con sus directorios, plugin/autoload/ftautoload y los he agregado a la lista. Mil gracias GITHUB por hacer el proceso mucho más facil de lo que se lee.
</div>

<pre>
Bundle 'chilicuil/taglist.vim'
Bundle 'chilicuil/dbext.vim'
Bundle 'chilicuil/nextCS'
Bundle 'chilicuil/TeTrIs.vim'
Bundle 'chilicuil/vimbuddy.vim'
</pre>

<div class="p">Listo, hasta aquí llega el proceso estandar, ejecutando <strong>:BundleInstall</strong> dentro de vim, instalará todos los plugins.
</div>

<div class="p">Para mi caso particular he copiado de .vimb <strong>skeletons/colors/extra-snippets</strong> a <strong>.vim</strong> y los he reagregado a git.
</div>

<div class="p">Los pasos para regenerar mi configuración, son:
</div>

<pre class="sh_sh">
$ git clone https://github.com/chilicuil/dotfiles dotfiles
$ cd dotfiles
$ mv .vimrc .vim ../
</pre>

<div class="p">Abrir vim, y correr <strong>:BundleInstall</strong>.
</div>

<div class="p">Para finalizar, mantener la configuración de esta forma es tan práctico que ya me ha permitido identificar dos formas de manejar el autocompletado de vim, neocomplcache vs el duo snipmate/acp
</div>
