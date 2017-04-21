zshrc-getzgen() {
	if [[ -d ${dotfiles}/external/zsh/zgen ]]; then
		rm -rf ${dotfiles}/external/zsh/zgen
	fi

	git clone https://github.com/tarjoilija/zgen ${dotfiles}/external/zsh/zgen
	echo "Run regenerate to load plugins"
}

if [[ -d ${dotfiles}/external/zsh/zgen ]]; then
	source ${dotfiles}/external/zsh/zgen/zgen.zsh
fi

zshrc-zgen() {
	if [[ $ZSHRC_GENERATING == 1 ]]; then
		if [[ -d ${dotfiles}/external/zsh/zgen ]]; then
			echo zgen ${@}
			zgen ${@}
		else
			echo zgen not installed. Run zshrc-getzgen to install.
		fi
	fi
}
