---
layout: post
title: "ssh captcha"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

**[![](/assets/img/pam_captcha.png)](https://github.com/chilicuil/pam_captcha)**
<!--<iframe class="showterm" src="http://showterm.io/53a85bc1b41c096c83130" width="640" height="350">&nbsp;</iframe>-->

Some days ago while I was reviewing some data I noticed a spammer in one of my remote machines. Since I was mostly using the box for running experiments I decided to rebuild it. Upon completion, I decided to improve my default ssh settings. I just liked too much to use a single password for all my ssh needs &#128542;

I know some ways to improve security, I could change the password to a really difficult one, change the default port, filter by ip, by tries (fail2ban), disable completely password login and allow only key based logins, etc.

At the end however I decided to just add a captcha protection, why?, most of the ssh attacks are automatized, people run scripts who tests thousand of passwords and run certain commands on success, these scritps won't be able to recognized the slighly modification in the login process (they're really dumb). In the other hand, I don't need over complicated solutions, or more systems to administer. Ssh key based login is great but sometimes I just need access from third party machines.

Lastly some other popular solutions have come up but for one or other reason I couldn't feel comfortable with them:

- [google authenticator](https://code.google.com/p/google-authenticator/) (my cellphone is most of the time lost, turn off or without battery, do I live under a rock?, not at all!, but I don't get the always online hype.)
- [barada](http://barada.sourceforge.net/) (see above reason)
- [otpw](https://www.cl.cam.ac.uk/~mgk25/otpw.html) (printing and carrying passwords with me?, you must be kidding)
- [otp](http://ubuntuforums.org/showthread.php?t=1891356) (I may try this one)
- [github auth](https://github.com/chrishunt/github-auth) (unrelated but it's a nice way to do pair programming fast)
- [authy](http://blog.authy.com/two-factor-ssh-in-thirty-seconds) (people seems to really like cellphones)
- any other method who involves [ForceCommand](https://www.duosecurity.com/)

### Installation

<pre>
$ sudo add-apt-repository ppa:minos-archive/main
$ sudo apt-get update &amp;&amp; sudo apt-get install libpam-captcha
</pre>

Be aware than the previous steps will only work in supported Ubuntu LTS versions.

### Extra

If additional security is desired, the next fail2ban regex will match the ssh captcha generated messages

    #/etc/fail2ban/filter.d/sshd.conf
    ^%(__prefix_line)s(?:error: PAM: )?Permission denied for .* from <HOST>$

Thanks Jordan! &#128522;

- [http://www.semicomplete.com/projects/pam_captcha/](http://www.semicomplete.com/projects/pam_captcha/)
- [https://github.com/minos-org/libpam-captcha](https://github.com/minos-org/libpam-captcha)
- [https://github.com/minos-org/libpam-captcha-deb](https://github.com/minos-org/libpam-captcha-deb)
