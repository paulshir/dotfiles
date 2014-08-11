#! /bin/sh
#
# install dotfiles.

# Set Variables
script=$(readlink -f $0)
df_setup=$(dirname $script)
dotfiles=$(dirname $df_setup)
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

make_symlink "${dotfiles}/bash/bashrc" ~/.bashrc
make_symlink "${dotfiles}/zsh/zshrc" ~/.zshrc
make_symlink "${dotfiles}/vim" ~/.vim

echo "export dotfiles=${dotfiles}" > ~/.dotfiles.env

# Hack to force the reload of the rc file for the current shell.
$SHELL
