#!/bin/zsh

if [[ ! -v ZELLIJ ]]; then
  >&2 echo "Must be in a zellij session"
  return 1
fi

zellij run -f -x 10% -y 10% --width 80% --height 80% -- zsh "${1}"
