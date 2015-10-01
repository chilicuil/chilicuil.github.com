---
layout: post
title: "using imagemagick, awk and kmeans to find dominant colors in images"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

Some days ago I was reading ["Using python to generate awesome linux desktop themes"](http://charlesleifer.com/blog/using-python-to-generate-awesome-linux-desktop-themes/) and got impressed by a technique to obtain dominant colors from images, I went ahead and tried to run the examples but [PIL](http://www.pythonware.com/products/pil/) proved difficult to install, so I looked around to see if I could replace it for some other utility and it turned out that [**convert**](http://www.imagemagick.org/script/convert.php) (which is part of the imagemagick package) is powerful enough for the duty.

Besides resizing, **convert** can output the rgb values of any image, so I reimplemented the kmean algorithm on awk and that's how [dcolors](https://raw.githubusercontent.com/chilicuil/learn/master/sh/tools/dcolors) was born. By default dcolor will resize (on RAM) the input image to 25x25 using a 1px deviation and 3 clusters for an average time of 1s per image, further customization are possible to increase quality, quantity or performance.

<pre class="sh_sh">
$ time dcolors akira
163,80,50
65,77,93
40,26,34

real    0m1.176s
</pre>
**[![](/assets/img/akira_800x800.jpg)](/assets/img/akira_800x800.jpg)**
<div style="text-align: center;">
    <span style="background-color: #a35032">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
    <span style="background-color: #414d5d">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
    <span style="background-color: #281a22">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
</div>

<pre class="sh_sh">
time ./dcolors --resize 100x100 --deviation 10 akira-cycle-2.png
49,85,118
19,42,69
125,173,165

real    0m3.188s
</pre>
**[![](/assets/img/akira-cycle-2_800x800.png)](/assets/img/akira-cycle-2_800x800.png)**
<div style="text-align: center;">
    <span style="background-color: #315576">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
    <span style="background-color: #132a45">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
    <span style="background-color: #7dada5">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
</div>

<pre class="sh_sh">
time ./dcolors --format hex --kmeans 8 akira-neo-tokyo-7_800x800.png
#495D66
#223634
#1C293A
#68706E
#3C4F4A
#38495D
#293C48
#0B1016

real    0m1.005s
</pre>
**[![](/assets/img/akira-neo-tokyo-7_800x800.png)](/assets/img/akira-neo-tokyo-7_800x800.png)**
<div style="text-align: center;">
    <span style="background-color: #495D66">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
    <span style="background-color: #223634">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
    <span style="background-color: #1C293A">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
    <span style="background-color: #68706E">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
    <span style="background-color: #3C4F4A">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
    <span style="background-color: #38495D">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
    <span style="background-color: #293C48">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
    <span style="background-color: #0B1016">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
</div>

That's it, happy hacking &#128523;

- [http://charlesleifer.com/blog/using-python-and-k-means-to-find-the-dominant-colors-in-images/](http://charlesleifer.com/blog/using-python-and-k-means-to-find-the-dominant-colors-in-images/)
- [https://en.wikipedia.org/wiki/K-means_clustering](https://en.wikipedia.org/wiki/K-means_clustering)
