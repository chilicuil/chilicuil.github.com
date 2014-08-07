---
layout: post
title: "detect file moves and renames with rsync"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

**[![](/assets/img/102.png)](/assets/img/102.png)**

I use rsync to backup my $HOME directory once a month with something like this:

<pre class="sh_sh">
$ sudo rsync -az --one-file-system --delete $HOME/ admin@backup.javier.io:~/backup/$(hostname)
</pre>

Most of the times it takes me **4-5** hours at 10MB/s to re-sync everything, however last weekend it took me almost **20 hours!** so while I was waiting I decided to take a look more closely to see what was happening.

It turned out rsync was re-uploading some pretty heavy files because I had renamed them locally. I couldn't believe rsync was so dumb, I was shocked &#128552;

So I went to Internet and looked for a solution, and I found a couple of patches:

- [detect-renamed](https://attachments.samba.org/attachment.cgi?id=7435)
- [detect-renamed-lax](https://git.samba.org/?p=rsync-patches.git;a=blob;f=detect-renamed-lax.diff;h=4cd23bd4524662f1d0db0bcc90336a77d0bb61c9;hb=HEAD)

These patches add the following options:

- --detect-renamed, --detect-renamed-lax
- --detect-moved

Since I'm not the kind of person who enjoys spending their time compiling software I packaged a modified rsync version for Debian/Ubuntu and upload it somewhere, while doing it I updated the patches to compile with the latest rsync version (at the moment of writing this version 3.1.1):

<pre class="sh_sh">
$ sudo apt-add-repository ppa:minos-archive/main
$ sudo apt-get updata &amp;&amp; sudo apt-get install rsync
</pre>

In my personal tests the modified rsync shows an amazing speed up for uploads who involve renamed/moved files. I hope this helps others as well.

**Note: For this to work, both, server and client must have installed the modified rsync version**

References:

- https://bugzilla.samba.org/show_bug.cgi?id=2294
- https://bugzilla.samba.org/attachment.cgi?id=7435
- http://gitweb.samba.org/?p=rsync-patches.git;a=blob;f=detect-renamed-lax.diff;h=4cd23bd4524662f1d0db0bcc90336a77d0bb61c9;hb=HEAD
- https://github.com/chilicuil/learn/blob/master/patches/rsync-3.1.1-trusty-detect-renamed.diff
- https://github.com/chilicuil/learn/blob/master/patches/rsync-3.1.1-trusty-detect-renamed-lax.diff
