dotfiles
========

A repro to store and sync my config files.

# Install #
## Windows ##
## Linux ##
## Mac OSX ##

```sh
git init
git remote add origin git@github.com:paulshir/dotfiles.git
git fetch
git reset --soft origin/master
git status --porcelain | grep "D " | sed s/D\ /git \add/ | xargs -0 bash -c
```
