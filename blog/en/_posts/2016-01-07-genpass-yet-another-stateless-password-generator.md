---
layout: post
title: "genpass, yet another stateless password generator"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

Since some time I've realized I'm pretty bad at memorizing strong passwords (phase-passwords too), as a result I've been using an unique "master" password and derivating others by using a shell alias:

    $ alias getpass='_getpass() { _g=$(printf "%s" "${*}" | \
        md5sum | openssl enc -base64     | \
        cut -c1-20); printf "%s" "${_g}" | \
        xclip -selection clipboard 2>/dev/null || \
        printf "%s\\n" "${_g}"; }; _getpass'

I knew than the resulting passwords weren't really good at keeping the master password secure, after all, md5 hashing is extremily fast and with known [collition](http://www.mscs.dal.ca/~selinger/md5collision/) [problems](http://natmchugh.blogspot.mx/2015/02/create-your-own-md5-collisions.html), even worse, I didn't even iterate over it. So I keep it in secret till I had the time or willingness to use an informed solution. During the last month I've been reviewing the state of art of password generation schemes and found than some [derivation](https://en.wikipedia.org/wiki/Bcrypt) [functions](https://en.wikipedia.org/wiki/Scrypt) have been designed specifically for this task. So I converted the shell alias to a C program and [genpass](https://github.com/chilicuil/genpass) is the result.

Genpass is by no means original, however when looking around I found than most password generators were plain broken, most of them were iterating fast checksum functions, md5, sha1, sha512, etc, or the ones using either bcrypt or scrypt used hard-coded parameters which could make them vulnerable to future computers. Using a slow key derivation function is as practical as the user is willing to wait, so often more secure default parameters aren't used because it would make the derivation painfully slow. Fortunatelly some smart guys have found this [problem before](https://www.cs.utexas.edu/%7Ebwaters/publications/papers/www2005.pdf) and have suggested to use a cache key to accelerate the process for legitimate users. That's what genpass uses to propose the following paranoid defaults.

Parameter             | Value
--------------------- | -------------
Cache cost (Scrypt N) | 2^20
Cost       (Scrypt N) | 2^10
Scrypt r              | 8 bits
Scrypt p              | 16 bits
Key length            | 32 bytes, 256 bits
Encoding              | z85

It's still convenient to use your own parameters, as the default settings will change as computers get updated on CPU/RAM.

### Usage

<a href="https://raw.githubusercontent.com/chilicuil/genpass/master/genpass.gif"><img src="https://raw.githubusercontent.com/chilicuil/genpass/master/genpass.gif" alt="" style="border: 1px solid white;margin-bottom: 3%;"></a>
<!--$ genpass-->
<!--Name: Guy Mann-->
<!--Site: github.com-->
<!--Master password: passwd #it won't be shown-->
<!--4c%7hZ5w]MZUB6RRPCJ&?wKTFtd[6Oj.P.02d+kIs-->

The first time it's executed it will take a relative long time (a couple of minutes) to get back. It'll create a cache key and will save it to `~/.genpass-cache` (this path can be customized), then it will combine it with the master password and the site string to generate the final password, which can be in z85(default), base64, skey, etc, encodings. The cache key file should be guarded with moderate caution, if it gets leaked possible attackers may have an easier time guessing the master password (although it still will be considerably harder than average brute force attacks). Later invocations will be instantly (taking on average 0.1secs). This way the scheme strives for the best balance between security and usability.

I've also added a `getpass` wrapper which paste the resulting password to the system clipboard and sets a timeout (10 seconds by default) after which the password is removed.


### Installation

##### Ubuntu based systems (LTS)

    $ sudo add-apt-repository ppa:minos-archive/main
    $ sudo apt-get update && sudo apt-get install genpass

##### Other Linux distributions, static binaries

    $ sh <(wget -qO- s.minos.io/s) -x genpass

##### From source

    $ make

That's it, happy password generation &#128523;

References

- [genpass](https://github.com/chilicuil/genpass)
- [bcrypt](https://en.wikipedia.org/wiki/Bcrypt), slow key derivation function
- [scrypt](https://en.wikipedia.org/wiki/Scrypt), slow key derivation function
- [pwdhash](https://www.pwdhash.com/), md5 based password generator, js
- [supergenpass](http://www.supergenpass.com/), md5 iteration based password generator, js
- [passwordmaker](http://passwordmaker.org), md5, sha1, sha256, [etc](http://passwordmaker.org/FAQ#Which_hash_algorithms_are_supported.3F) based password generator, several implementations
- [masterpassword](http://masterpasswordapp.com/), hard-coded scrypt based password generator, several implementations
- [npwd](https://github.com/kaepora/npwd), hard-coded scrypt based password generator, Nodejs
- [cpwd](https://github.com/postboy/cpwd), hard-coded scrypt based password generator, C
