dotfiles
========

## overview ##
This is a repo for my shared configuration. It works across macos, linux and windows. It also contains scripts required to manage itself.

## todo ##
* Move functions etc out to seperate repo, keep this mainly for config. Powershell modules not required by dotfiles should be moved out.
* ~~Keep rc configs to single files to allow easy downloading on servers without downloading all dotfile~~s
* rc files should run without added dependencies, they should enable additional features on demand. e.g. use vim plugins if vim-plug is installed. (vim completed, zshrc still needs to be fixed)
* ~~rc configs should call a local override file also, for exta settings.~~ .config/local/<app>/
* dotfiles scripts should provide 2 basic purposes
  + ~~create correct symlinks for all platforms~~
  + basic file downloader for dependencies

## contents ##
| app          | os           | notes |
|--------------|--------------|-------|
| autohotkey   | windows      | |
| bash         | all          | |
| cmder        | windows      | |
| dotfiles     | all          | |
| external     | none         | used for storing external downloads |
| git          | all          | |
| hammerspoon  | macos        | |
| iterm        | macos        | |
| karabiners   | macos        | |
| networkutils | windows      | to be moved |
| powershell   | windows      | modules to be moved |
| sublimetext3 | all          | |
| tmux         | macos, linux | |
| typescript   | all          | to be moved |
| vim          | all          | |
| vscode       | all          | settings might need to be made platform agnostic |
| zsh          | all          | |

## installation ##
#### macos and linux ####
```zsh
git clone https://github.com/paulshir/dotfiles
cd dotfiles
./dotfiles/setup.sh --install
```

#### windows ####
Open powershell as an admin (required to create symlinks on windows)
```cmd
Set-ExecutionPolicy Unrestricted
git clone https://github.com/paulshir/dotfiles
cd dotfiles
./dotfiles/setup.ps1 -Install
```

## update ##
To update the installation scripts can be run again. There are also aliases available for different shells, that are installed with these dotfiles.

#### zsh ####
```zsh
dotfiles-update
```

#### powershell ####
```cmd
Update-Dotfiles
```

## uninstall ##
#### macos and linux ####
```zsh
cd $dotfiles
./dotfiles/setup.sh --uninstall
```

#### windows ####
```cmd
cd $dotfiles
./dotfiles/setup.ps1 -Uninstall
```
