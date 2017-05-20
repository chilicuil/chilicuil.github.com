---
layout: post
title: "git clone only the last snapshot of a project"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

Git clone by default download all the data attached to a repository, there are sometimes however when I'm only interested in getting the latest snapshot. This can be done with the **--depth=1** option:

<pre class="sh_sh">
$ git clone --depth=1 git://github.com/javier-lopez/dotfiles.git
</pre>

It's called shallow clone

- <http://stackoverflow.com/questions/1209999/using-git-to-get-just-the-latest-revision>
