---
layout: post
title: "youtube videos from terminal"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

There are multiple ways to see youtube videos from a linux terminal, one of the simplest (and more unix ways) is with mplayer+youtube-dl. Mplayer for playing and youtube-dl for fetching the content.

To do so, go to a shell terminal and define the following alias:

    $ alias youtube-slice='sh -c '\''youtube-dl -q -o- "${1}" | mplayer -cache 8192 -'\'' -'

After that:

    $ youtube-slice $url

Will work nicely. If you are interested in this and more cool aliases, checkout aliazator, it's tons of handy ones waiting for you to discover them.

 - [youtube-dl](http://rg3.github.io/youtube-dl/download.html)
 - [aliazator](https://github.com/chilicuil/shundle-plugins/tree/master/aliazator)

Happy watching &#128523;
