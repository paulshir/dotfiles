function dfgit {
   git --git-dir=$HOME/.dfgit/ --work-tree=$HOME $@
}

function dflgit {
   git --git-dir=$HOME/.dflgit/ --work-tree=$HOME $@
}

if [ -f ~/.zshrc_local ]; then
    source ~/.zshrc_local
fi

