---
layout: post
title: "ver la hora de cualquier país"
---

<h2>{{ page.title }}</h2>

<div class="publish_date">{{ page.date | date_to_string }}</div>

<div class="p">Nada, siempre me confundo con los horarios a la hr de sumar o restar y vi una forma de saberlo desde la consola, lo anoto antes de que se me olvide:
</div>

<pre class="sh_sh">
$ TZ=CUBA date
</pre>
