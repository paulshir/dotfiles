$CurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$CurrentUserIsAdmin = Test-IsAdmin

function Write-PromptFunc0Location {
    Write-Host $(Get-Location) -NoNewline
}

function Write-PromptFunc9End {
    if ($CurrentUserIsAdmin) {
        Write-Host " #>" -NoNewline
    } else {
        Write-Host " $>" -NoNewline
    }
}

function global:prompt {
    Get-Command -Type Function Write-PromptFunc* | sort | foreach { & $_.Name }

    return " "
}