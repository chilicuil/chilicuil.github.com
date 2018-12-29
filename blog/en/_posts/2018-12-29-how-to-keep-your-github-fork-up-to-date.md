---
layout: post
title: "how to keep your Git-Fork up to date"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

When it comes to the situation that you fork a repository and you contribute to
it, then it could happen that your fork and the upstream are not in sync
anymore. So the goal is, that you get a current version of the upstream
repository and then you can merge the new changes into your fork, right? Okay!
Let’s get started.

### 1. Create a Fork

A fork [is a copy of someone others repository in your
account](https://help.github.com/articles/fork-a-repo/), which can be an
independent development project, This tutorial is for GitHub but works for any
other git hosted platform, like Bitbucket or GitLab.

**[![](/assets/img/fork_button.jpg)](/assets/img/fork_button.jpg)**

### 2. Clone the fork

    $ git clone git@github.com:your-user/your-fork.git

### 3. Add the upstream

Now we should add the "upstream" branch. You can call it however you want.
Upstream is just best practice.

    $ git remote add upstream git://github.com/original-author/original-project.git

If you now have a look at your remote urls, you should see the following:

    $ git remote -v
    origin https://github.com/your-user/your-fork (fetch)
    origin https://github.com/your-user/your-fork (push)
    upstream https://github.com/original-author/original-project (fetch)
    upstream https://github.com/original-author/original-project (push)

### 4. Keep the upstream updated

Now as we have both urls tracked, we can update the two sources independently. With

    $ git fetch upstream

### 5. Merge/Rebase your work with the upstream repository

Then you can just merge the changes.

    $ git merge upstream/master master

With that, you merge the latest changes from the master branch of the upstream
into your local master branch. If you like, you can also use git pull, which is
nothing else than fetching and merging in one step.

**Pro Tip:** The best way in my eyes is, to rebase because that fetches the
latest changes of the upstream branch and replay your work on top of that. Here
is, how it works:

    $ git rebase upstream/master

### 6. Push your changes online

Finally, you can push your changes so others can benefit

    $ git push

That's it, happy coding, &#128522;
