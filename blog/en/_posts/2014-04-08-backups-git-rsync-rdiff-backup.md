---
layout: post
title: "backups: rsync, rdiff-backup"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

I don't remember the last time I lost information, that's been mostly because of luck instead of preparation, but with internet services providing more bandwidth, efficient/modern compression algorithms and more affordable virtual and cloud services I finally decided to give up my luck and automate my backup plan.

I'm fortunate to work in an heterogeneous environment, linux + x32/x64 boxes, so I cling to the lowest denominator, ssh/rsync. Both programs are installed in virtually all linux distributions or are included in default repositories, so it's easy to backup new machines, besides, both are secure, efficient and well supported. A minor annoyance is that they may be difficult to use, specially rsync which has plenty of options.

After playing for a while, I grouped my favorite options in a [wrapper script](https://github.com/chilicuil/learn/blob/master/sh/tools/backup-remote-rsync), and deployed the result to the target boxes, eg:

    $ backup-remote-rsync -r b.javier.io #backup $HOME to b.javier.io:~/hostname
    $ backup-remote-rsync -r b.javier.io -u admin -k /home/admin/.ssh/id_rsa /var/www /etc
    #back up /var/www and /etc to b.javier.io:~/hostname, uses admin public key

The above lines are run once per day, per box.

    $ sudo cronjob -l
    0 22 * * * backup-remote-rsync -u admin -i /home/admin/.ssh/id_rsa -r backup.javier.io /home/admin

Since rsync only transfers deltas, once the backup is online further runs complete faster.

On the server side, besides setting up ssh, I used ([rdiff-backup](http://www.nongnu.org/rdiff-backup/examples.html)), a program designed to create dailies/weeklies/monthlies efficiently and another script, [share-backup](https://github.com/chilicuil/learn/blob/master/sh/tools/share-backup), to get easy, fast and secure access to specific files when a ssh/rsync client is not available, or when I want to share files with friends.

`share-backup` can be run from within any client machine, eg:

    $ ssh admin@b.javier.io share-backup
    Starting server ...
      address   : http://b.javier.io:7648

      username: guest
      password: M2U4ZDRj
      ssl     :

      serving:  /home/admin/recovery

    Run: share-backup stop, to stop sharing
    $ ssh admin@b.javier.io share-backup stop
    Stopped

Internally it runs a temporal [http server](https://github.com/chilicuil/learn/blob/master/python/simple-httpd) with basic authentication and optional ssl.

I configured cronjob entries for rdiff-backup, generating dailies(7), weeklies(4) and monthlies(12).

    0 1 * * * rdiff-backup /home/admin/backup/ /home/admin/recover/daily
    0 2 * * * rdiff-backup --remove-older-than 6D /home/admin/recover/daily

    0 1 * * 0 rdiff-backup /home/admin/backup/ /home/admin/recover/weekly
    0 2 * * 0 rdiff-backup --remove-older-than 3W /home/admin/recover/weekly

    0 1 1 * * rdiff-backup /home/admin/backup/ /home/admin/recover/monthly
    0 2 1 * * rdiff-backup --remove-older-than 12M /home/admin/recover/monthly

## Decisions

When dealing with backups you'll deal often with decisions, is it more important saving hard disk space or keep several copies around?, does your backup plan require detailed third party integration or will be generic?, how many resources in time and money are you willing to invest?, how fast your recovery process should be?, how private your data is?. It's important to ask yourself these questions and test as many alternatives as possible, then use the option(s) you feel comfortable with, those who make sense and you trust.

I've shared my personal backup plan, because even when there are plenty of options, I found most of them were over complicated or I didn't trust, it works for me (right now) but don't take for granted it'll do it for you.

If you're out of ideas take a look at:

- [ddumbfs](http://www.magiksys.net/ddumbfs/), [btrfs](https://btrfs.wiki.kernel.org/index.php/Main_Page), [s3fs](https://github.com/s3fs-fuse/s3fs-fuse), [opendedup](http://opendedup.org/), [bup](https://github.com/bup/bup), [obnam](http://obnam.org/), [bacula](http://bacula.org/), [etc](https://en.wikipedia.org/wiki/List_of_backup_software).

That's it, happy and safe hacking &#128523;
