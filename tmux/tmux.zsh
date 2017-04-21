alias tl='tmux list-sessions'

ta() {
    tmux new-session -A -s $1
}

tk() {
	tmux kill-session -t $1
	echo "killed session $1"
}

# Native iTerm Session
ita() {
    tmux -CC new-session -A -s $1
}
