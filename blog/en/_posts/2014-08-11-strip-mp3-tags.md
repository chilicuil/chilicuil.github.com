---
layout: post
title: "strip mp3 tags"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

**[![](/assets/img/102.png)](/assets/img/102.png)**

I use mpd to satisfy my local music player needs, mpd reads multimedia tags and attaches them to its database, I use these tags to look for tracks and artists fastly, however sometimes I end with mp3 files containing unuseful tags, on these cases I'd prefer mpd could look for filenames instead of mp3 tags because it when it doesn't it makes incredible difficult to find these tracks. Since I've not managed to find this feature (if such feature exist) I just strip the problematic tags (someday I'll learn to edit them instead).

<pre class="sh_sh">
$ ffmpeg -i track.mp3 -acodec copy -map_metadata -1 track.tagless.mp3 &amp;&amp; mv track.tagless.mp3 track.mp3
</pre>

If you find the above command you could create an alias/function.

    alias strip.mp3tags='sh -c '\''ffmpeg -i "${1}" -acodec copy -map_metadata -1 "${1}".tagsless.mp3 && mv "${1}".tagsless.mp3 "${1}"'\'' -'

Happy stripping &#128523;
