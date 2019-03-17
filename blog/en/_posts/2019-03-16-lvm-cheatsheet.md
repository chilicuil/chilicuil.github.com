---
layout: post
title: "lvm cheatsheet"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

There are certain technical things I keep forgetting not matter how many times
I try them, `ln` usage, `git` parameters and the reason for this post, `LVM`.
So, here goes a quick how-to for my future me.

### Basics

In order to understand **LVM** it's required to grasp its components.

## Physical Volume (PV)

A PV is **any block device** that can be used as storage

**[![](/assets/img/lvm_pv.png)](/assets/img/lvm_pv.png)**

## Volume Group (VG)

A VG is a group of at least one PV, commonly contains many thought.

**[![](/assets/img/lvm_vg.png)](/assets/img/lvm_vg.png)**

## Logical Volume (LV)

A LV is a portion (partition) of a VG.

**[![](/assets/img/lvm_lv.png)](/assets/img/lvm_lv.png)**

### How to set up multiple hard drives as one volume?

## Define /dev/sda, /dev/sdb2 and /dev/sdc3 as PVs

    $ sudo pvcreate /dev/sda /dev/sdb2 /dev/sdc3

## Create a Volume Group (VG) out of three just defined PVs

    $ sudo vgcreate vg_name /dev/sda /dev/sdb2 /dev/sdc3

## Create a Logical Volume (LV) out of the just defined VG

    $ sudo lvcreate -l 100%FREE -n lv_name vg_name

Done!, now it can be formated and mounted as a normal HD, eg:

    $ sudo mkfs.ext4 /dev/vg_name/lv_name
    $ echo '/dev/vg_name/lv_name /mount_point ext4 defaults 0 0' | sudo tee -a /etc/fstab
    $ sudo mount -a

That's it!, I'll keep adding **LVM** recipes as I find fit, happy storing,
&#128522;

- [https://askubuntu.com/questions/7002/how-to-set-up-multiple-hard-drives-as-one-volume](https://askubuntu.com/questions/7002/how-to-set-up-multiple-hard-drives-as-one-volume)
- [https://www.digitalocean.com/community/tutorials/how-to-use-lvm-to-manage-storage-devices-on-ubuntu-16-04](https://www.digitalocean.com/community/tutorials/how-to-use-lvm-to-manage-storage-devices-on-ubuntu-16-04)
- [https://blog.inittab.org/administracion-sistemas/lvm-para-torpes-i/](https://blog.inittab.org/administracion-sistemas/lvm-para-torpes-i/)
