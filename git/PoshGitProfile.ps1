Import-Module posh-git

# Set up a simple prompt, adding the git prompt parts inside git repos
function Write-PromptFunc8Git {
    $realLASTEXITCODE = $LASTEXITCODE

    # Reset color, which can be messed up by Enable-GitColors
    $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

    Write-VcsStatus

    $global:LASTEXITCODE = $realLASTEXITCODE
}

Enable-GitColors

Start-SshAgent -Quiet