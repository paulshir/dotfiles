{{- $ctx := first . -}}
{{- $installer := index . 1 -}}
{{- $installerArgs := index . 2 -}}
{{- $packages := index . 3 -}}

{{- if not $packages -}}{{ "" }}
# No-op, no packages

{{- else if eq $installer "system" -}}{{ "" }}
# No-op for packages {{ $packages | join ", " }}

{{- else if eq $installer "brew" -}}{{ "" }}
brew bundle --file=/dev/stdin <<EOF
{{ range $packages -}}
brew {{ . | quote }}
{{ end -}}
EOF


{{- else if eq $installer "brewCask" -}}{{ "" }}
brew bundle --file=/dev/stdin <<EOF
{{ range $packages -}}
cask {{ . | quote }}
{{ end -}}
EOF


{{- else if eq $installer "yum" -}}{{ "" }}
sudo yum install -y {{ range $packages }}{{ . }} {{ end }}


{{- else if eq $installer "cargo" -}}{{ "" }}
source ~/.cargo/env
{{ range $packages -}}
cargo install --locked {{ . | quote }}
{{ end -}}


{{- else if eq $installer "mise" -}}{{ "" }}
{{ range $packages -}}
mise install {{ . | quote }}
{{ end -}}

{{- else if hasPrefix "custom" $installer -}}{{ "" }}
{{ $script := trimPrefix "custom:" $installer }}
echo {{ $ctx.chezmoi.sourceDir }}/scripts/installers/{{ $script }} {{ $packages | join " " }}

{{- else -}}
{{- print "No installer found for " $installer | fail -}}
{{- end -}}
