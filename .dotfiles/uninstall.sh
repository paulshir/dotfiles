#!/bin/zsh
set -euo pipefail

DIR=`pwd`

DF_GIT=${1:-".dfgit"}

echo "Uninstalling dotfiles stored in $DF_GIT"
function __dfgit {
   git --git-dir=$DIR/$DF_GIT/ --work-tree=$DIR $@
}

__dfgit rm -rf . || true
rm -rf $DF_GIT

BACKUP_DIR="${DIR}/${DF_GIT}_backup"
if [[ -d ${BACKUP_DIR} ]]; then
    echo "Restoring backups from ${BACKUP_DIR}"
    pushd ${BACKUP_DIR}

    for f in $(find .* -type f); do
        echo "Moving ${BACKUP_DIR}/${f} to ${DIR}/${f}"
        mkdir -p `dirname "${DIR}/${f}"`;
        mv "${BACKUP_DIR}/${f}" "${DIR}/${f}"
    done

    find ${BACKUP_DIR} -type d -empty -delete
fi

unset -f __dfgit
