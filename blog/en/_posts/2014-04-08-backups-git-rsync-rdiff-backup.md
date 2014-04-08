---
layout: post
title: "backups: git, rsync, rdiff-backup"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

**[![](/assets/img/96.png)](/assets/img/96.png)**

I took the weekend to review my personal backup strategy and this is the result. Besides using git to track current projects (which also provides very good integrated backup) I created a [script](https://github.com/chilicuil/learn/blob/master/sh/is/backup-remote-rsync) to be allocated in the machines backing up, eg:

    $ backup-remote-rsync #will backup $HOME by default
    $ backup-remote-rsync -u admin -i /home/admin/.ssh/id_rsa /var/www /etc
    #will back up /var/www and /etc using admin ssh keys to login to b.javier.io

A program ([rdiff-backup](http://www.nongnu.org/rdiff-backup/examples.html)) to create dailys/weeklys/montlys on the backup server. And another [script](https://github.com/chilicuil/learn/blob/master/sh/is/share-backup) to get easy access to the files if needed (isn't the whole point?).  

The idea is to run backup-remote-rsync (which uses a popular synchronization program internally) daily and generate **~/backup/$(hostname)** folders in the backup server (it has hardcoded b.javier.io by default but it accepts other parameters). Then generate dailys(7), weeklys(4) and monthlys(12).

    0 1 * * * rdiff-backup /home/admin/backup/ /home/admin/recovery/daily
    0 2 * * * rdiff-backup --remove-older-than 6D /home/admin/recovery/daily

    0 1 * * 0 rdiff-backup /home/admin/backup/ /home/admin/recovery/weekly
    0 2 * * 0 rdiff-backup --remove-older-than 3W /home/admin/recovery/weekly

    0 1 1 * * rdiff-backup /home/admin/backup/ /home/admin/recovery/monthly
    0 2 1 * * rdiff-backup --remove-older-than 12M /home/admin/recovery/monthly

And finally run **share-backup** from any computer with access to b.javier.io to see files, eg:

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

The last step will run a temporal [http server](https://github.com/chilicuil/learn/blob/master/python/simple-httpd) with basic auth and optional ssl.

## Decisions

Dealing with backups will often make you wonder if you prefer clients contact the backup server or the other way around. Both have advantages and disadvantages so it's mostly up to you and what may be more important in your current setup. On this scenario most computers are behind a firewall so I decided to make them contact the backup server.

I added key ssh based auth and captcha to the server to improve security. Even when I don't think someone would like to login on purpose to this machine, there exist a fair amount of scripts, spammers and script kiddies looking for free computer resources, so I try to keep them behind the line.

In complex deployments there may be different OS, architectures or auth rules, fortunately in my personal environment I don't have to deal with those problems because I only use Linux on amd64/x86 machines and use solely ssh to get access. So it simplified a lot the tool selection phase. I chose rsync because it's installed by default in most modern distributions and made a wrapper around it because I don't like to type too much. The fact that it works with me doesn't mean it would work for you, I just chose the tool which seems right for the job.  Bacula or other enterprise solutions will make wonder for small to big enterprises and I would probably use them in a sophisticated environment but with my personal stuff I prefer to keep it simple.  The features you want will also make you think deep about the tools and policy of your backup setup. In my case I wanted **independency**, **simplicity**, history, de-duplication and encryption. And although I couldn't get the last one, I think it would work till the next time I review it. Still in 2014 is a pain to deploy a backup solution, so don't feel bad if your current setup is a peace of crap, most other solutions are equally bad or even worst =).

I took a look at prospects such as:

- zfs, ddumbfs, btrfs, s3fs, opendedup, fuse fs
- [bup](https://github.com/bup/bup), [obnam](http://code.liw.fi/obnam/manual/manual.html), bacula
- etc

But discard them because they laked the features I wanted, or where just to complex to deploy. Probably I'll add some kind of basic monitoring (not nagios) and gpg encryption nex time, who knows...
