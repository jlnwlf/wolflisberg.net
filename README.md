# VM Sandbox for web development

## Requirements

- Docker (or Vagrant - **DEPRECATED**)
- VirtualBox
- An OS compatible with both of them (Windows should work, but not tested yet)
- An internet connection
- Some patience...

## About

This will do a couple of things:

- Download and install latest Ubuntu release
- Download and install latest updates from servers
- Download and install tools needed to compile and install environment we need to work with.
- Install and compile:
    - 2 latest Python releases with pyenv (it compiles it from source code, which can be slooooow)
    - Node.js stable release
    - Bower and Grunt (globally)

## Installation (Docker)

Just `cd` into this directory and run:

``` bash
docker build --force-rm=true -t wolf/wolflisberg.net:latest .
```

And then run a new container with:

``` bash
docker run -it -h sandbox wolf/wolflisberg.net:latest
```

## Installation (Vagrant) - DEPRECATED

Just `cd` into this directory and run:

``` bash
vagrant up
```

...then wait (like...forever) for the compilation to end and:

``` bash
vagrant ssh
```

to connect to your new local dev server
