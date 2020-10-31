dotfiles
========

# Overview
Git repo for storing machine configuration.
It is installed using git using a similar method to [1](https://news.ycombinator.com/item?id=11070797) and [2](https://www.atlassian.com/git/tutorials/dotfiles).

The install script clones the dotfiles repo with the `.git` directory as a `~/.dfgit`. Aliases exist in the `.zshrc` for interacting with this git repo. A secondary repo for local overrides (e.g. work machine) can also be cloned to `~/.dflgit`. By default only tracked files show up in the status.

# Installation
## install
`curl -Lks https://raw.githubusercontent.com/paulshir/dotfiles/master/.dotfiles/install.sh | $SHELL`

## uninstall
Ensure you have no uncommitted, unpushed changes
`./.dotfiles/uninstall.sh`

## install local repo
`./.dotfiles/install.sh <repo> .dflgit`

## uninstall local repo
Ensure you have no uncommitted, unpushed changes
`./.dotfiles/uninstall.sh .dflgit`

# Sparse Checkout
To prevent populating the home directory with non config files sparse checkout is used.
To update the sparse checkout edit the sparse checkout file to remove the desired files:

```
vim ~/.dfgit/info/sparse-checkout
git reset --hard
```

This will uncheckout the files if they are already checked out.

# Backup 
The install script will create a backup folder and copy any files that will overwritten. If any new files cause conflict, future `dfgit pull` will fail and the conflict will have to be manually resolved.


# Test
There are some tests using docker in `.dotfiles/test`
