#!/bin/zsh

# DOTFILES {{{1
function dfgit {
   git --git-dir=$HOME/.dfgit/ --work-tree=$HOME $@
}

function dflgit {
   git --git-dir=$HOME/.dflgit/ --work-tree=$HOME $@
}

# INTERNAL UTILITY FUNCTIONS {{{1
_error() {
	echo
	echo "[31;1m$*[0m"
	echo
}

# ENVIRONMENT {{{1
df_dir="${HOME}/.dotfiles"

export ZPLUG_HOME=${df_dir}/external/zplug

if [[ ! -f ${ZPLUG_HOME}/init.zsh ]]; then
	_error "currently zplug must be installed for this to work; exiting"
	return 1
fi

HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000

export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND=${FZF_DEFAULT_COMMAND}
if command -v fzf &> /dev/null; then
	eval "$(fzf --zsh)"	
elif [[ -f ${HOME}/.fzf.zsh ]]; then
	source ~/.fzf.zsh
else
	_error "fzf is not installed"
fi

export LS_COLORS='di=34:ln=35:so=36:pi=33:ex=32:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
export LSCOLORS='exfxgxdxcxegedabagacad'
export CLICOLOR=1
export EDITOR=hx

# ALIASES {{{1
alias g='git'
alias gA='git add .'
alias ga='git add'
alias gd='git diff'
alias gc='git commit'
alias gca='git commit --amend'
alias gct='git commit -m "TMP"'
alias gcm='git commit -m'
alias gdc='git diff --cached'
alias gdd='git difftool'
alias gddc='git difftool --cached'
alias gf='git commit --fixup HEAD'
alias gr='git rebase -i --autosquash'
alias gfr='git commit --fixup HEAD && git rebase -i --autosquash'
alias gs='git status'
alias pd='popd'
alias isodate='date +"%FT%TZ"'
alias ita='tmux -CC new-session -A -s'
alias reload='. ~/.zshrc'
alias ta='tmux new-session -A -s'
alias td='tmux detach -s'
alias tl='tmux list-sessions'
alias tk='tmux kill-session -t'
alias vf='hx $(fzf)'
alias vi='hx'
alias vim='hx'
alias zls='zellij ls'
alias zk='zellij delete-session'
alias zshrc-time='time  zsh -i -c exit'

# FUNCTIONS {{{1

function za {
	session=$1
	shift

	if $(zellij ls | grep -w "$session" > /dev/null); then
    zellij attach $session
		return
  fi

	zellij -s $session "$@"
}

# PLUGINS {{{1

source ${ZPLUG_HOME}/init.zsh
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"
# zplug "oskarkrawczyk/honukai-iterm-zsh", as:theme
zplug mafredri/zsh-async, from:github
zplug sindresorhus/pure, use:pure.zsh, from:github, as:theme

if ! zplug check; then
    zplug install
fi

# PLUGIN OPTIONS {{{1
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
# ZSH OPTIONS {{{1

# cd
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_silent

# completion
setopt always_to_end
setopt auto_menu
setopt complete_in_word

# history
setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt hist_verify

# other
setopt extended_glob
setopt no_beep
bindkey -v # vim mode

# SOURCE OTHER FILES AND LOAD PLUGINS {{{1
if [ -f ${HOME}/.dev.env ]; then
    source ${HOME}/.dev.env
fi

if [ -f ${HOME}/.zshrc_local ]; then
    source $${HOME}/.zshrc_local
fi

zplug load

# CLEANUP {{{1

# vim:ft=zsh:foldmethod=marker
export JAVA_TOOLS_OPTIONS="-Dlog4j2.formatMsgNoLookups=true"

export PATH=$PATH:/Users/psshirle/.toolbox/bin
