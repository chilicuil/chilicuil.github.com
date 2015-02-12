---
layout: post
title: "fix github rendering in old firefox releases with greasemonkey"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

When the new firefox interface (aurora) was announced I knew I would never install it, since then I've been looking for alternatives, in the meantime I've been using an [old](http://f.javier.io/rep/bin/firefox32.tar.bz2) [firefox](http://f.javier.io/rep/bin/firefox64.tar.bz2) release (27.0), it's been great so far, however some days ago [https://github.com](https://github.com) started looking funny. Paniiiic &#128561;!

**[![](/assets/img/102.png)](/assets/img/102.png)**

I contacted support but they told me they didn't support such old releases (and think it's barely 1 year old, pff, progress...) so I went ahead and hacked a quick greasemonkey script.

<pre class="sh_javascript">
function addGlobalStyle(css) {
    var head, style;
    head = document.getElementsByTagName('head')[0];
    if (!head) { return; }
    style = document.createElement('style');
    style.type = 'text/css';
    style.innerHTML = css;
    head.appendChild(style);
}

//github.com/user
addGlobalStyle('.one-fourth {width: 20%}');
addGlobalStyle('.one-half {width: 47%}');
addGlobalStyle('img.avatar {max-width: 200px; max-height: 200px;}');

//github.com
addGlobalStyle('.two-thirds {width: 63%}');
addGlobalStyle('.site-search input[type="text"] {width: 90%}');
</pre>

**[![](/assets/img/103.png)](/assets/img/103.png)**

That's it, happy collaborating &#128523;
