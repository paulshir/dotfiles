zstyle :compinstall filename '/home/paul/.zshrc'

autoload -Uz compinit
compinit

setopt always_to_end
setopt auto_menu
setopt complete_in_word
unsetopt menu_complete
