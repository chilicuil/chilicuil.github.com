---
layout: post
title: "rm wrapper"
---

## {{ page.title }}
<p class="date">{{ page.date | date_to_string }}</p>

<div class="p">Sometimes when I run:
</div>

<pre class="sh_sh">
$ rm foo
</pre>

<div class="p">I realize I didn't mean it, so with this in my mind I made a little <a href="https://github.com/chilicuil/learn/blob/master/sh/rm_" target="_blank">wrapper</a>, now instead of removing my files, it sends them to the trash bin, it's compatible with [nautilus|pcmanfm].
</div>

<div class="p"> <em>Example</em>: If I run from a terminal <strong>$ rm img.png</strong> I can then go to the Trash carpet in Nautilus and restore it. If I delete it in Nautilus (by pressing the [Supr] button) I can open a terminal and type <strong>$ rm -u img.png</strong>
</div>

<div align="center"><img src="/assets/img/53.png" style="width: 552px; height: 230px;">
</div>

<div class="p">If you want use the script, download it, move it to <strong>/usr/local/bin</strong> and add an alias to the <strong>~/.bashrc</strong> file:
</div>

<pre class="sh_sh">
$ alias rm='rm_'
</pre>

<div class="p">Hope it helps
</div>