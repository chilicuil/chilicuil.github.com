---
layout: post
title: "removing passwords from git repositories"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

Here's how to remove a password from any file, in all revisions, in a git repository:

    $ git filter-branch --tree-filter \
        "find . -type f -exec sed -i -e 's/password/XXX/g' {} \;"

Another handy one, deleting all the lines containing **word**:

    $ git filter-branch --tree-filter \
        "find . -type f -exec sed -i -e '/word/d' {} \;"

Now, to force push your changes to a remote repository:

    $ git push -f

That's it, happy safe coding, &#128522;

- [http://www.davidverhasselt.com/git-how-to-remove-your-password-from-a-repository/](http://www.davidverhasselt.com/git-how-to-remove-your-password-from-a-repository/)
