---
layout: post
title: "strip mp3 tags with ffmpeg"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

I use mpd to satisfy my local music player needs, mpd reads multimedia tags and attaches them to its database, I use these tags to look for tracks and artists fastly, however sometimes I end with mp3 files containing unuseful tags, on these cases I wish mpd could look for filenames instead of mp3 tags because when it doesn't it makes incredible difficult to find these tracks. Since I've not managed to find this feature (if such feature exist) I just strip the problematic tags (someday I'll learn to edit them instead or to program the missing part).

<pre class="sh_sh">
$ ffmpeg -i track.mp3 -acodec copy -map_metadata -1 track.t.mp3 &amp;&amp; mv track.t.mp3 track.mp3
</pre>

If you find the above command useful you can create an alias/function.

    alias strip.mp3tags='sh -c '\''ffmpeg -i "$1" -acodec copy -map_metadata -1 "$1".t.mp3 && mv "${1}".t.mp3 "${1}"'\'' -'

Happy stripping &#128523;
