---
layout: post
title: "active extensions in firefox nightly"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

**[![](/assets/img/78.jpg)](/assets/img/78.jpg)**

Firefox nightly is the firefox version who is compiled every night. By default it will avoid loading any extension, however this behaviour can be override, to do so add the variable **extensions.checkCompatibility.nightly** to its configuration:

1. Open 'about:config'
2. Write **extensions.checkCompatibility.nightly**
3. Select 'New -&gt; Boolean'
4. Write **extensions.checkCompatibility.nightly** again in "New value"
5. Select 'false' as the predefined state
6. Reboot firefox

From now on **'about:plugins'** will be available as usual &#128522;

This procedure is also available as a plugin in the [Disable Compatibility Checks Add-on](https://addons.mozilla.org/en-US/firefox/addon/checkcompatibility/) it works in all Firefox releases, nightly and stable ones.

Happy browsing &#128523;

- [Firefox nightly](http://nightly.mozilla.org/)
- [Extensions.checkCompatibility](http://kb.mozillazine.org/Extensions.checkCompatibility)
