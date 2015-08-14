---
layout: post
title: "papers I liked"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

From time to time I read papers about any subject, mostly about computer science, and then forgot which or where it's available for future reference. So I'm creating this list as a kind of personal wiki to do not forget anymore.

## Computer Security

- [PrivExec: Private Execution as an Operating System Service](http://www.iseclab.org/papers/sp2013privexec) - 2013. [[pdf]](http://f.javier.io/rep/papers/sp2013privexec.pdf) 16 Pag.

Kernel side private / temporal / irrecoverable execution environments.

- [Alcatraz: An Isolated Environment for Experimenting with Untrusted Software](https://www.comp.nus.edu.sg/~liangzk/papers/tissec09.pdf) - 2009. [[pdf]](http://f.javier.io/rep/papers/alcatraz-an-isolated-environment-for-experimenting-with-untrusted-software.pdf) 37 Pag.

Commit + policy driven temporal sandboxing environments.

- [The state of the art of application restrictions and sandboxes and its shortfalls](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.300.4042&rep=rep1&type=pdf) - 2012. [[pdf]](http://f.javier.io/rep/papers/state-of-art-of-application-restrictions-and-sandboxes-2012.pdf) 40 Pag.

Compilation of current security trends and its shortfalls, eg: selective execution (by white/black lists, heuristic -antivirus software, statistic based -symantec quorum, spynet, mcafee artemis, etc); rule based (DAC, Linux standard, Rainbow, polaris); application oriented access control (mapbox, android, bitfrost, dte, apparmor, selinux, tomoyo, systrace, alcatraz, some web apps); isolation based {permanent (virtual machines - kvm,xen,uml,virtualbox, containers - chroot, lxe, openvz, linux vserver, jails), ephemeral (privexec), both (alcatraz, sandboxie, pastures, returnil), isolated two ways (virtual machines, containers), isolated one way (privexec,alcatraz)}; monitoring system calls (systrace, plash, callgraph, pulse); combinations (app oriented access control + isolation: qubes, windowbox, apiary, peadpod).

## Computer Virtualization

- [Performance Evaluation of Container-based Virtualization for High Performance Computing Environments](http://marceloneves.org/papers/pdp2013-containers.pdf) - 2014. [[pdf]](http://f.javier.io/rep/papers/pdp2013-containers.pdf) 8 Pag.

Xen, Openvz, Linux Vserver, LXC performance evaluation.

## Computer Operation Systems

- [Flexible Operating System Internals: The Design and Implementation of the Anykernel and Rump Kernels](http://lib.tkk.fi/Diss/2012/isbn9789526049175/isbn9789526049175.pdf) - 2012. [[pdf]](http://f.javier.io/rep/papers/anykernel-rump-kernel-isbn9789526049175.pdf) 362 Pag.

Portable drivers across minimal kernels (anykernels) and system applications (rump kernels). Drivers as system libraries.

## Community driven papers repositories

- [https://github.com/papers-we-love/papers-we-love](https://github.com/papers-we-love/papers-we-love)
- [http://www.reddit.com/r/paperswelove](http://www.reddit.com/r/paperswelove)

By the way, if you're new (as I'm) to read scientific papers, don't forget to checkout the guidelines to read efficiently academic articles.

- [How to read an academic article](http://organizationsandmarkets.com/2010/08/31/how-to-read-an-academic-article/)
- [How to read and understand a scientific paper](http://violentmetaphors.com/2013/08/25/how-to-read-and-understand-a-scientific-paper-2/)

Happy reading &#128523;
