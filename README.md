# VM Sandbox for web development

## Requirements

- Vagrant
- VirtualBox
- An OS compatible with both of them (Windows should work, but not tested yet)
- An internet connection
- Some patience...


## Installation

This will do a couple of things:

- Download and install latest Ubuntu release
- Download and install latest updates from servers
- Download and install tools needed to compile and install environment we need to work with.
- Install and compile:
    - 2 latest Python releases (2.7.10 and 3.5.0) with pyenv (it compiles it from source code, which can be slooooow)
    - Node.js 4.1.2 stable release (compile from source too, sloooooow)

Just `cd` into this directory and run:

``` bash
vagrant up
```

...then wait (like...forever) for the compilation to end and:

``` bash
vagrant ssh
```

to connect to your new local dev server
