---
layout: post
title: "latex and me"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

I maintain my CV in latex because it can easily generate different outputs, it's easy to modify and I think it gives extra geeky points. In the other hand not always is easy to compile.., so I'll write down the process to not forget it and do it faster next time.

[![](/assets/img/47.png)](http://www.sharepdfbooks.com/ZZKLWWMPNYPU/template_banking_black.pdf.html)

<pre class="sh_sh">
$ apt-get install texlive-latex-base texlive-latex-extra latex-xcolor texlive-fonts-recommended
$ wget http://mirror.ctan.org/macros/latex/contrib/moderncv.zip
$ unzip moderncv.zip
$ sudo mv moderncv /usr/share/texmf-texlive/tex/latex/
$ sudo mktexlsr
</pre>

After installing the dependencies and latex itself, the compilation process can be triggered as follows:

<pre class="sh_sh">
$ latex cv.tex
</pre>

The resulting .dvi file can then be converted to a pdf file:

<pre class="sh_sh">
$ dvipdfm cv.dvi
</pre>

[![](/assets/img/48.png)](https://gist.github.com/2704079)

If it seems like too much work, it can also be compiled [online](https://www.sharelatex.com) &#128513;
