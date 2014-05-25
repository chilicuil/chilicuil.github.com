---
layout: post
title: "setting up jekyll locally"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

<iframe class="showterm" src="http://showterm.io/dd994deaf00a01fcb9c65" width="640" height="350">&nbsp;</iframe> 

I &#x2661; [github](https://github.com/), it has never been easier to start working in open source projects =). One of their rock star services is [github pages](http://pages.github.com/), which allows people to setup static pages for their projects, it even provides some nice themes so your page doesn't look awful. Many people however (mostly technical) use it to host their blogs (such as this one), you get great infrastructure, a subdomain (and the possibility of using your own domain), revisions (git) and markdown, all for free!, isn't that freaking awesome!?

Github pages could be perfect, however they're not (although they're really close), sometimes when you're using markdown and the translation markdown &#x21E8; html fails you'll get a nice mail such as this one:

    The page build failed with the following error:

    page build failed

    For information on troubleshooting Jekyll see:
     https://help.github.com/articles/using-jekyll-with-pages#troubleshooting

    If you have any questions please contact GitHub Support.

Beautiful!, no signal of what went wrong =), ok, to be fair, github has recently started to [add more details](https://github.com/blog/1706-descriptive-error-messages-for-failed-github-pages-builds), however they're still not sufficient, I still require to mirror their jekyll setup in order to see what's really happening. Since I've done more than a couple of times, I thought it would be a good idea to automatize it.

<pre class="sh_sh">
$ sh &lt;(wget -qO- https://raw2.github.com/chilicuil/learn/master/sh/is/gitpages)
...
$ git clone --depth=1 https://github.com/username/site.github.com
$ cd site.github.com
$ jekyll serve #fix errors till it works
</pre>

It requires an Ubuntu &#x21E8; 12.04 system and sudo credentials. Additional gotchas:

- [http://dwdii.github.io/2013/08/28/GitHub-Pages-Jekyll-Ampersands.html](http://dwdii.github.io/2013/08/28/GitHub-Pages-Jekyll-Ampersands.html)

Happy blogging &#128516;!
