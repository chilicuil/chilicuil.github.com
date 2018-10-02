---
layout: post
title: "package python scripts and dependencies in single files with pex"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

So you want to create a pex that packages your script and its dependencies? Ok,
first to make our script! call it **my-script.py**:

    import requests

    if __name__ == '__main__':
      req = requests.get("https://raw.githubusercontent.com/pantsbuild/pex/master/README.rst")
      print req.text.split("\n")[0]

**requirements.txt**

    requests

Now, it's time to package it!:

    $ pex -o my-script.pex -D . -r requirements.txt -e my-script
      my-script.pex

Done, but wait, are you too lazy to even download pex/pip?, try docker:

**Dockerfile**:

    #FROM python:3.6.4
    FROM ubuntu:16.04

    RUN  apt-get update && apt-get install -y libev-dev python-pip

    RUN mkdir -p /usr/src/app
    WORKDIR /usr/src/app

    COPY requirements.txt /usr/src/app/
    RUN  pip install --no-cache-dir -r requirements.txt

    COPY . /usr/src/app

    CMD [ "python", "my-script.py" ]

And then:

    $ docker build -t pex-builder .
    $ docker run -v "$PWD:/usr/src/app" pex-builder \
        pex -o my-script.pex -D . -r requirements.txt -e my-script

Done, now we have a (relative) portable way of distributing and running our scripts:

    $ ./my-script.pex
    ...

That's it, happy packaging &#128522;

- [https://www.pither.com/simon/blog/2018/09/18/how-build-portable-executable-single-python-script](https://www.pither.com/simon/blog/2018/09/18/how-build-portable-executable-single-python-script)
