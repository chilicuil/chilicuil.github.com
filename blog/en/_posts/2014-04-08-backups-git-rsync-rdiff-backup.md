---
layout: post
title: "backups with rsync and rdiff-backup"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

I don't remember the last time I lost information, that's been mostly luck since I'm not really careful with my data. However with internet providers increasing bandwidth, efficient compression algorithms all around and affordable servers in the cloud I finally decided to give up my luck and automate my backup plan.

I'm fortunate to work in an homogeneous environment, Linux x32/x64 boxes, so I prefer to cling to the lowest common denominator, on this case ssh/rsync. Both are installed (or available through default repositories) in virtually all Linux distributions and are secure, mature, efficient and well supported, there is a little issue with them though, they've too many options and can be tricky to remember.

So, with that in mind I grouped my favorite options and created a [wrapper script](https://github.com/chilicuil/learn/blob/master/sh/tools/backup-remote-rsync). That's what I use to backup machines, it works like this:

    $ backup-remote-rsync -r b.javier.io #the program will backup $HOME to b.javier.io:~/hostname using default ssh keys
    $ backup-remote-rsync -r b.javier.io -u admin -k /home/admin/.ssh/id_rsa /var/www /etc
    #the program will backup /var/www and /etc to b.javier.io:~/hostname, while using admin's public ssh keys

The above lines can be added to a cronjob to remove human dependency:

    $ sudo cronjob -l
    #every day at 22:00
    0 22 * * * backup-remote-rsync -r backup.javier.io -u admin -i /home/admin/.ssh/id_rsa /home/admin

It's well known than rsync transfers files using a delta based mechanism, so once the initial backup is done further invocations are considerably faster, this is a great incentive to run backups often.

On the server side, I used [rdiff-backup](http://www.nongnu.org/rdiff-backup/examples.html) to create dailies/weeklies/monthlies.

    0 1 * * * rdiff-backup /home/admin/backup/ /home/admin/recover/daily
    0 2 * * * rdiff-backup --remove-older-than 6D /home/admin/recover/daily

    0 1 * * 0 rdiff-backup /home/admin/backup/ /home/admin/recover/weekly
    0 2 * * 0 rdiff-backup --remove-older-than 3W /home/admin/recover/weekly

    0 1 1 * * rdiff-backup /home/admin/backup/ /home/admin/recover/monthly
    0 2 1 * * rdiff-backup --remove-older-than 12M /home/admin/recover/monthly

And added [share-backup](https://github.com/chilicuil/learn/blob/master/sh/tools/share-backup), to provide fast and secure access to single files. Complete recoveries are available through standard rsync.

`share-backup` usage example:

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

## Decisions

While testing backup utilities and differente strategies I found me asking me priority questions, is it more important to save hard disk space or to keep several copies around?, does the backup plan require third party integrations or can it be generic?, how many resources in time and money am I willing to invest?, how fast the recovery process must be?, how private the data is?.

I tried to answer these questions as honestly as possible and found than the above procesure covers me in most situations, that doesn't mean it will work for your. I urge you to test as many alternatives as possible and only stick with those that make you feel confortable and secure. If you're out of ideas take a look at:

- [ddumbfs](http://www.magiksys.net/ddumbfs/)
- [btrfs](https://btrfs.wiki.kernel.org/index.php/Main_Page)
- [s3fs](https://github.com/s3fs-fuse/s3fs-fuse)
- [opendedup](http://opendedup.org/)
- [bup](https://github.com/bup/bup)
- [obnam](http://obnam.org/)
- [bacula](http://bacula.org/)
- [etc](https://en.wikipedia.org/wiki/List_of_backup_software).

That's it, stay safe and backup your data now &#128523;!
