---
layout: post
title: "print through the ldp protocol in a cups less environment"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

I've just discovered it's possible to print through the [LDP protocol](http://en.wikipedia.org/wiki/Line_Printer_Daemon_protocol) without [CUPS](http://www.cups.org/) (cups-ldp in Ubuntu).

For a unkown reason I had always though that all linux systems required to have CUPS installed to talk to any printer, which is not the case. LPD can be used perfectly to print to remote printers.

<pre class="sh_sh">
$ rlpr -h -Plp -HIP_OF_THE_PRINTER_LDP_SERVER_HERE  file.[ps|pdf]
</pre>

In 2011 most Linux application can print to pdf/ps files, so you can skip **cups-pdf** as well &#128522;. To print images, **convert** (part of the [imagemagick](http://www.imagemagick.org/script/index.php) suit) can do the job:

<pre class="sh_sh">
$ convert image.jpg  file.ps
</pre>

And for plain text files, vim shines:

<pre class="sh_sh">
:hardcopy > file.ps
</pre>

Aliases can help in case you find yourself typing the ip too often, eg **alias print.192.168.1.11='rlpr -h -Plp -H192.168.1.11'**:

<pre class="sh_sh">
$ print.192.168.1.11  file[.ps|pdf]
</pre>

All my requirements are covered &#128526;

The printer/copier referenced on this post is the [Canon ImageRunner 6570](http://usa.canon.com/cusa/support/office/b_w_imagerunner_copiers/imagerunner_5050_5055_5065_5070_5075_5570_6570/imagerunner_6570):

- <http://www.mail-archive.com/misc@openbsd.org/msg56753.html>
- <http://www.gnu.org/software/a2ps>
- <http://www.wizards.de/~frank/pstill.html>
- <http://www.ghostscript.com/>
