#!/bin/zsh
set -euo pipefail

DIR=`pwd`

DF_REPO=${1:-"git@github.com:paulshir/dotfiles.git"}
DF_GIT=${2:-".dfgit"}

echo "Installing dotfiles from $DF_REPO to $DF_GIT"

git clone --bare $DF_REPO $DIR/$DF_GIT
function __dfgit {
   git --git-dir=$DIR/$DF_GIT/ --work-tree=$DIR $@
}

if __dfgit checkout; then
    echo "Checked out config.";
else
    BACKUP_DIR="${DIR}/${DF_GIT}_backup"
    mkdir -p "${BACKUP_DIR}"
    echo "Backing up existing config files to ${BACKUP_DIR}"
    for f in $(__dfgit ls-tree -r --name-only --full-tree HEAD); do
        echo $f
        if [[ -a "${DIR}/$f" ]]; then
            echo "Backup up ${DIR}/${f} to ${BACKUP_DIR}/${f}"
            mkdir -p `dirname "${BACKUP_DIR}/${f}"`;
            mv "${f}" "${BACKUP_DIR}/${f}";
        fi
    done
    __dfgit checkout
fi;
__dfgit config status.showUntrackedFiles no
__dfgit submodule update --init --recursive
unset -f __dfgit
