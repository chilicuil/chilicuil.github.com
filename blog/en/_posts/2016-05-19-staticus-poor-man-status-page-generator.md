---
layout: post
title: "staticus, a poor man status page generator"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

I'm not sure what excuse to use to back this entry, I guess I'm just a lazy and irresponsible person, last week I got myself in need for a basic status page generator and all the alternatives I looked at were either too complicated or non free (as in speech and beer), so I decided to go my own (that's the irresponsible part) and bundle everything in a single shell script to avoid dependencies (that's the lazy one).

[Staticus](https://github.com/javier-lopez/learn/blob/master/sh/tools/staticus) is the result.

**[![](/assets/img/staticus-1.png)](/assets/img/staticus-1.png)**

The tools itself is pretty simple, to generate the above picture I ran:

    staticus go #generate staticus.txt and staticus.html in the current directory

Could be added to a cronjob to run periodically

    * * * * * /path/to/staticus -o /var/www/status/index.html -O /tmp/staticus.txt

The script accepts several options, however to set threshold values and other _advanced_ parameters it's best to define a configuration file (by default /etc/staticus.conf):

    module_memory_threshold="80"
    module_swap_threshold="80"
    module_load_threshold="4"
    module_storage_threshold="80"

Other possible values are described in the [configuration section](https://github.com/javier-lopez/learn/blob/master/sh/tools/staticus#L8).

That's it, if you ever use staticus, you didn't get it from me &#128523;

- [@jayfk's statuspage project, from where I stole the html theme](https://github.com/jayfk/statuspage)
