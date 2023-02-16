#!/bin/bash
cd .foam/templates

main=$1

confirm() {
    read -r -p "${1} " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}

copy() {
    from=$1
    to=$2

    if [[ -f "$to" ]]; then
        if ! (diff $from $to || confirm "$to file already exists and it's contents differ. Do you want to continue [y/N]?"); then
            echo "Skipping"
            return 0
        fi
    fi

    cp $from $to
}

copy ${main}-note.md new-note.md
copy ${main}-note-daily.md daily-note.md
