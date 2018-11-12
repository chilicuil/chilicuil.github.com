---
layout: post
title: "say hi to react through docker integration"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

I've started learning [react](https://reactjs.org/) and there is no way I
install `npm/yarn/create-react-app` or any non sense just to develop single
pages.

Therefore here are some instructions to encapsulate everything within docker
containers.

### Bootstrapping

Being react the complex stack of software it's, it requires `create-react*`
scripts to bootstrap projects. Therefore the first step will be to create a
minimal container with such tools:

## Dockerfile

    FROM node:alpine
    RUN yarn global add create-react-app create-react-native-app react-native-cli

Let's call this container `bootstrap-react`:

<pre class="sh_sh">
$ docker build . -t bootstrap-react
</pre>

Then we can bootstrap `react/react-native` projects as usual:

<pre class="sh_sh">
$ docker run -it --rm --user "$(id -u):$(id -g)" \
      -v "${PWD}":/usr/src/app -w /usr/src/app   \
      bootstrap-react                            \
      create-react-app my-new-react-project
</pre>

The `my-new-react-project` folder contains a bunch of files required to start
hacking away:

    $ tree my-new-react-project/ | head
    ┬
    ├── .gitignore
    ├── node_modules
    │   ├── abab
    │   │   ├── CHANGELOG.md
    ├── package.json
    ├── public
    │   ├── index.html
    ├── src
        ├── App.css
        ├── App.js


### Dockerizing new project

Now, wouldn't be cool if every person could replicate the project with a single
step?, let's add some more magic.

## docker-compose.yml

    version: '3.4'

    services:
      app:
        image: node:alpine
        volumes:
          - .:/usr/src/app
        working_dir: /usr/src/app
        command: sh -c "yarn && yarn start"
        ports:
          - "3000:3000"

That's it!, now it can be launched and accessed through
[http://localhost:3000](http://localhost:3000):

    $ docker-compose up
    app_1  | You can now view my-new-react-project in the browser.
    app_1  | 
    app_1  |   Local:            http://localhost:3000/
    app_1  |   On Your Network:  http://172.18.0.2:3000/

**[![](/assets/img/react.png)](/assets/img/react.png)**

Sweet!, the autoreloading is working, so we can start modifying
files and the changes will show up instantly.

    $ vim src/App.js
    #some changes later ...

**[![](/assets/img/react-hello-world.png)](/assets/img/react-hello-world.png)**

If you enjoyed the process but still don't want to go thought all the steps,
feel free to grab the [docker-react-hello-world](https://github.com/javier-lopez/docker-react-hello-world)
template as your starting point.

That's it, happy coding, &#128522;
