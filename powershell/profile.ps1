$dotfiles = $env:Dotfiles
$MyDocuments = Split-Path(Split-Path $profile)

$exclude = "$($dotfiles)dotfiles\setup.ps1", "$($dotfiles)powershell\profile.ps1"
Get-ChildItem "$dotfiles\*\*.ps1" | where { $_ -and ($exclude -notcontains $_.FullName) } | Foreach-Object {
    if (Test-Path $_){ .($_) }
}

$CurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$CurrentUserIsAdmin = Test-IsAdmin

function global:prompt {    
    if ($CurrentUserIsAdmin) {
        return "$(Get-Location) #> "
    } else {
        return "$(Get-Location) $> "
    }
}