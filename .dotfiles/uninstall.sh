#!/bin/zsh
set -euo pipefail

DIR=`pwd`

DF_GIT=${1:-".dfgit"}

echo "Uninstalling dotfiles stored in $DF_GIT"
function __dfgit {
   git --git-dir=$DIR/$DF_GIT/ --work-tree=$DIR $@
}

__dfgit checkout -b cleanup
__dfgit rm -rf .

rm -rf ${DF_GIT}

BACKUP_DIR="${DIR}/${DF_GIT}_backup"
if [[ -d ${BACKUP_DIR} ]]; then
    echo "Restoring backups from ${BACKUP_DIR}"
    pushd ${BACKUP_DIR}

    for f in $(find .*); do
        echo "Moving ${f} to ${DIR}"
        mv ${f} ${DIR}/${f}
    done
fi

unset -f __dfgit
