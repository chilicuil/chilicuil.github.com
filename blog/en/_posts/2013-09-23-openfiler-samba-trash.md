---
layout: post
title: "openfile and samba trash support"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

Sometimes it can useful to have trash support in samba/cifs. Sadly it's not straighforward to do in [openfiler](http://www.openfiler.com/).

**/opt/openfiler/var/www/includes/generate.inc**

In an average samba installation preferences are saved in **/etc/samba/smb.conf**, in openfiler however this and many other files are constantely rebuild, so this changes won't last if you apply them there. Modify **/opt/openfiler/var/www/includes/generate.inc** instead:

1588 line:
 
<pre>
/* enable trash support */
$ac_smb_fp-&gt;AddLine( "\n");
$ac_smb_fp-&gt;AddLine( " ; enable trash support");
$ac_smb_fp-&gt;AddLine( " vfs objects = audit recycle" );
$ac_smb_fp-&gt;AddLine( " recycle: repository = /path/.trash" );
$ac_smb_fp-&gt;AddLine( " recycle: keeptree = Yes" );
$ac_smb_fp-&gt;AddLine( " recycle: exclude = *.tmp, *.temp, *.log, *.ldb" );
$ac_smb_fp-&gt;AddLine( " recycle: exclude_dir = tmp " );
$ac_smb_fp-&gt;AddLine( " recycle: versions = Yes " );
$ac_smb_fp-&gt;AddLine( " recycle: noversions = *.docx|*.doc|*.xls|*xlsx|*.ppt|*.odt" );
$ac_smb_fp-&gt;AddLine( "\n");
</pre>

It may be a good idea to delete oldest files every now and then:

<pre>
0 6 * * * root find /path/.trash -type f -mtime +14 -delete &gt; /dev/null
</pre>

Happy trashing &#128521;
