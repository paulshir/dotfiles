#! /bin/sh
#
# install dotfiles.

# Set Variables
script=$(readlink -f $0)
set -e

make_symlink(){
	local target=$1
	local path=$2

	if [ -h $path ];
	then
		rm -rf $path
	fi

	if [ ! -e $target ];
	then
		return
	fi

	if [ -e $path ];
	then
		path_bak="${path}.bak"
		if [ -e $path_bak ];
		then
			return
		else
			mv "$path" "$path_bak"
		fi
	fi

	ln -s "$target" "$path"
}

remove_symlink(){
	local path $1

	if [ -h $path ];
	then
		rm -rf $path
	fi

	if [ ! -e $path];
	then
		path_bak="{$path}.bak"
		if [ -e $path_bak ];
		then
			mv "$path_bak" "$path"
		fi
	fi
}

dotfiles=~/.dotfiles
if [ ! -d $dotfiles ];
then
	echo "Dotfiles must be cloned to ~/.dotfiles"
	echo "Please clone this repro to ~/.dotfiles before continuing."
	exit 1
fi

make_symlink "${dotfiles}/bash/bashrc" ~/.bashrc
make_symlink "${dotfiles}/zsh/zshrc" ~/.zshrc
make_symlink "${dotfiles}/vim" ~/.vim
