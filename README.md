dotfiles
========

This is the repro that contains scripts used to setting up and syncing configuration files. I am using dropbox as my syncing platform although the scripts can be used without dropbox and syncronized using git.

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
## Dropbox Setup ##
### First time creating folder ###
1. Create a folder in dropbox for the dotfiles
2. In this dotfiles folder create a folder called `external` and a folder called `.git`
3. Open dropbox settings and go to selective sync settings
4. Navigate to the dotfiles folder and ensure the `external` folder and `.git` folder are unchecked so they will not sync
5. You can now clone the repo here by running `git clone https://github.com/paulshir/dotfiles`

### Syncing folder on a different computer ###
1. Open dropbox settings on new computer and go to selective sync settings.
2. Navigate to the dotfiles folder and ensure the `external` folder and `.git` folder are unchecked so they will not sync

## Install ##
### Windows ###
1. Open a powershell window as an administrator
2. Run `Set-ExecutionPolicy Unrestricted`
3. Navigate to the dotfiles folder in dropbox. e.g. `cd $HOME\Dropbox\dotfiles`
4. Run `.\dotfiles\setup.ps1 -Install`

### Linux and OSX ###
Coming Soon

## Update ##
### Windows ###
1. Open a powershell windows and run `Update-Dotfiles`

## Uninstall ##
### Windows ###
1. Open a powershell window as an administrator and run the following@:

```powershell
cd $dotfiles
./dotfiles/setup.sh -Uninstall
```

## Add changes to git from new computer ##
```shell
git init
git remote add origin git@github.com:paulshir/dotfiles.git
git fetch
git reset --soft origin/master
git status --porcelain | grep "D " | sed s/D\ /git \add/ | xargs -0 bash -c
```
