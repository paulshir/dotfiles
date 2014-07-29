$dotfiles = $env:Dotfiles
$MyDocuments = Split-Path(Split-Path $profile)

$exclude = "$($dotfiles)dotfiles\setup.ps1", "$($dotfiles)powershell\profile.ps1"
Get-ChildItem "$dotfiles\*\*.ps1" | where { $_ -and ($exclude -notcontains $_.FullName) } | Foreach-Object {
    if (Test-Path $_){ .($_) }
}

$CurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$CurrentUserIsAdmin = Test-IsAdmin

# function prompt
# {
#     $host.ui.rawui.WindowTitle = "Files: " + (get-childitem).count + " Process: " + (get-process).count
#     if ($CurrentUserIsAdmin) {
#         Write-Host ("$($CurrentUser.Name) " + $(get-location) +">") -nonewline -foregroundcolor Red 
#     } else {
#         Write-Host ("$($CurrentUser.Name) " + $(get-location) +">") -nonewline -foregroundcolor Green 
#     }
#     return " "
# }

Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

Import-Module "$dotfiles\git\PowershellModules\posh-git"

function global:prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    # Reset color, which can be messed up by Enable-GitColors
    $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

    Write-Host($pwd.ProviderPath) -nonewline

    Write-VcsStatus

    $global:LASTEXITCODE = $realLASTEXITCODE
    
    if ($CurrentUserIsAdmin) {
        return " #> "
    } else {
        return " $> "
    }
}

Enable-GitColors

Pop-Location

Start-SshAgent -Quiet