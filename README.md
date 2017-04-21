dotfiles
========

# Overview #

This is the repro that contains scripts used to setting up and syncing configuration files. It is currently a bit of a mess but I hope to tidy that up soon.

# Modules #
## Current Modules ##

| Module | Operating Systems | Extendable |
|--------|-------------------|------------|
|Powershell|Windows|Extension **.ps1** in dotfiles sub-dirs will be sourced. **PowershellModules** folders in dotfiles sub-dirs will be added to *PSModulePath* on install and update.|
|zsh|OSX, Linux|Extensions **.dsh** & **.zsh** in dotfiles sub-dirs will be sourced.|
|bash|OSX, Linux|Extensions **.dsh** & **.bash** in dotfiles sub-dirs will be sourced.|
|git|All|Files **git/windows.gitconfig** for windows and **git/unix.gitconfig** for unix are loaded with platform specific settings. The following config files are also loaded: *git/user.gitconfig* *git/standard.gitconfig*, *git/aliases.gitconfig*, *git/plugins.gitconfig*, *~/.gitconfig.local*.|
|Sublime Text 3|All|User preferences will be synced and packages if using [Package Conrol](https://packagecontrol.io/).|
|vim|All|Plan to extend to automatically install vim-plug|

# Usage #
Currently symlinks are created for source folders. These are hardcoded into the setup scripts. As the script doesn't make the link if the source folder doesn't exist this isn't an issue if only a subset of the source programs are being used.

In the master branch the following files are available and include dynamic loading of all files in the dotfiles subdirectory ending with a given extension.

|Program   |Extensions |
|----------|-----------|
|Powershell|.ps1       |
|Zsh       |.dsh, .zsh |
|Bash      |.shd, .bash|

In addition to this a .gitconfig is also included which will dynamically load a few files in the dotfiles/git/configs directory. It will also load ~/.gitconfig.local where you can put settings specific to your current computer.

# Setup and Installation #
TODO

# The Goal #
```
./dotfiles/dotfiles/setup.sh -uninstall
git clean -fdx
./dotfiles/dotfiles/setup.sh -install
```
