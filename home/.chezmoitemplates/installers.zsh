{{- /* Usage:
...
*/ -}}
{{- if not (hasKey . "ctx") -}}{{ fail "must past context ton installers.zsh under ctx key" }}{{- end -}}

{{- if and (hasKey . "brew") .brew -}}{{ "" }}
brew bundle --no-lock --file=/dev/stdin <<EOF
{{ range .brew -}}
brew {{ . | quote }}
{{ end -}}
EOF
{{ end -}}

{{- if and (hasKey . "brewCask") .brewCask -}}{{ "" }}
echo brew bundle --no-lock --file=/dev/stdin <<EOF
{{ range .brewCask -}}
cask {{ . | quote }}
{{ end -}}
EOF
{{ end -}}

{{- if and (hasKey . "yum") .yum -}}{{ "" }}
sudo yum install -y {{ range .yum }}{{ . }} {{ end }}
{{ end -}}

{{- if and (hasKey . "cargo") .cargo -}}{{ "" }}
{{- $has := includeTemplate "has" (list .ctx "rustToolchainStable" "rustToolchainNightly") | fromToml -}}
{{- if not (or $has.rustToolchainStable $has.rustToolchainNightly) -}}{{- fail "Cargo installs require rust toolchain" -}}{{- end -}}
source ~/.cargo/env
{{ range .cargo -}}
cargo install --locked {{ . | quote }}
{{ end -}}
{{ end -}}

{{- if and (hasKey . "custom") .custom -}}{{ "" }}
{{ range .custom -}}

{{- if eq . "helixEditor" -}}
{{- $helixVersion := (gitHubLatestRelease "helix-editor/helix").TagName -}}{{ "" }} 
(cd ~/.local/share
if [[ ! -d helix ]]; then
	git clone https://github.com/helix-editor/helix
	(cd helix
	git reset --hard {{ $helixVersion }}
	cargo install --path helix-term --locked
	mkdir -p ~/.config/helix
	ln -Ts $PWD/runtime ~/.config/helix/runtime
	)
fi)
{{ end -}}


{{ end -}}
{{ end -}}{{- /* End of Custom Installers */ -}}
