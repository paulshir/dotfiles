#! /bin/sh
#
# install dotfiles.

# Set Variables
script=$(readlink -f $0)
dotfiles=$(dirname $SCRIPT)
set -e

MakeSymlinkWithBackup(){
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

RemoveSymlinkWithBackup(){
	local path $1

	if [ -h $path ];
	then
		rm -rf $path
	fi

	if [ ! -e $path];
	then
		path_bak="$path}.bak"
		if [ -e $path_bak ];
		then
			mv "$path_bak" "$path"
		fi
	fi
}
