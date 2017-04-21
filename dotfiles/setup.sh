#! /bin/bash
#
# install dotfiles.

# Set dotfiles variable
df_tmp="$(dirname $0)/../"
pushd $df_tmp > /dev/null
dotfiles=$(pwd -P)
popd > /dev/null
set -e

apply_symlink() {
	local target="$1"
	local path="$2"

	if [ $install == true ]; then
		make_symlink "$target" "$path"
	elif [ $install == false ]; then
		remove_symlink "$path"
	fi
}

make_symlink() {
	local target="$1"
	local path="$2"

	if [ -h "$path" ];
	then
		rm -rf "$path"
	fi

	if [ ! -e "$target" ];
	then
		return
	fi

	if [ -e "$path" ];
	then
		path_bak="${path}.bak"
		if [ -e "$path_bak" ];
		then
			return
		else
			mv "$path" "$path_bak"
		fi
	fi

	ln -s "$target" "$path"
}

remove_symlink() {
	local path="$1"

	if [ -h "$path" ];
	then
		rm -rf "$path"
	fi

	if [ ! -e "$path" ];
	then
		path_bak="{$path}.bak"
		if [ -e "$path_bak" ];
		then
			mv "$path_bak" "$path"
		fi
	fi
}

if [ "$1" == "-install" ]; then
	install=true
elif [ "$1" == "-uninstall" ]; then
	install=false
elif [ "$1" == "-test" ]; then
	echo "Dotfiles Location: $dotfiles"
	exit
else
	echo "Usage:"
	echo "	./setup.sh -install"
	echo "	./setup.sh -uninstall"
	exit 0
fi

echo "export dotfiles=${dotfiles}" > ~/.dotfiles.env
if [ "${dotfiles}" != "${HOME}/.dotfiles" ]; then
	apply_symlink "${dotfiles}" ~/.dotfiles
fi

apply_symlink "${dotfiles}/bash/bashrc" ~/.bashrc
apply_symlink "${dotfiles}/zsh/zshrc" ~/.zshrc
apply_symlink "${dotfiles}/vim" ~/.vim
apply_symlink "${dotfiles}/vim/vimrc" ~/.vimrc
apply_symlink "${dotfiles}/vim" ~/.config/nvim
apply_symlink "${dotfiles}/git/unix.gitconfig" ~/.gitconfig
apply_symlink "${dotfiles}/tmux/tmux.conf" ~/.tmux.conf

if [ "$(uname)" == "Darwin" ]; then
	apply_symlink "${dotfiles}/sublimetext3/userpreferences" ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
    apply_symlink "${dotfiles}/hammerspoon" ~/.hammerspoon
    apply_symlink "${dotfiles}/karabiner/karabiner.json" ~/.config/karabiner/karabiner.json
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
	apply_symlink "${dotfiles}/sublimetext3/userpreferences" ~/.sublimetext3
fi

if [ $install == true ]; then
	echo "dotfiles installed"
elif [ $install == false ]; then
	echo "dotfiles removed"
fi
