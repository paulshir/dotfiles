<#
.SYNOPSIS

Powershell script to manage the installation and removal of dotfiles from the system.
.DESCRIPTION

Powershell script to manage the installation and removal of dotfiles from the system.

.PARAMETER Install

This parameter is used to install or update the installation of dotfiles from the system.
.PARAMETER Uninstall

This parameter is used to uninstall the dotfiles from the system.
.PARAMETER Chocolatey

This parameter is used to install chocolatey.
.PARAMETER Help

Display Help details.
#>
[CmdletBinding(DefaultParameterSetName="Help")]
Param(
    [Parameter (Mandatory=$true, ParameterSetName="Install")]
    [Alias("i")]
    [Alias("install")]
    [switch] $Install,

    [Parameter (Mandatory=$true, ParameterSetName="Uninstall")]
    [Alias("u")]
    [Alias("uninstall")]
    [switch] $Uninstall,

    [Parameter (Mandatory=$true, ParameterSetName="Chocolatey")]
    [Alias("choc")]
    [switch] $Chocolatey,

    [Parameter (Mandatory=$false, ParameterSetName="Help")]
    [switch] $Help
)

BEGIN {
    Push-Location $PSScriptRoot
    $env:PSModulePath += ";" + (Get-Location).Path + "\..\powershell\Powershellmodules"
    Import-Module FileManagement
    Import-Module Admin
    Import-Module Environment
    $dotfiles = Resolve-Path ((Get-Location).Path + "\..\")
    $MyDocuments = Split-Path(Split-Path $profile)

    Write-Verbose "$dotfiles"
    Write-Verbose "$MyDocuments"

    # An array of all modules in the form of @(Target, Path)
    # If removing a symlink point the target to a non existing file.
    # Symlinks removed and are recreated every install.
    # This will enable to install to cleanup old symlinks that no longer exist.
    $symlinkMappings = @(
            @("$dotfiles\powershell\profile.ps1", "$MyDocuments\WindowsPowershell\profile.ps1"),
            @("$dotfiles\sublimetext3\userpreferences", "$($env:APPDATA)\Sublime Text 3\Packages\User")
        )

    function TestIsAdmin() {
        if (!(Test-IsAdmin)) {
            throw "To continue run this script as an admin"
            return
        }
    }

    function NewSymlinkWithBackup([String]$Target, [String]$Path) {
        Write-Verbose "NewSymlinkWithBackup at $Path targetting $Target"

        if (Test-Symlink $path) {
            Remove-Symlink $path
        }

        if (!(Test-Path $target)) {
            Write-Verbose "Target doesn't exist. Skipping."
            return
        }

        if (Test-Path $Path) {
            New-BackupItem $path -Delete
        }

        $pathDir = Split-Path -Parent $Path
        if (!(Test-Path $pathDir)) {
            mkdir -Force $pathDir | Out-Null
        }

        New-Symlink $Target $Path | Out-Null
    }

    function RemoveSymlinkWithBackup([String]$Path) {
        if (Test-Symlink $Path) {
            Remove-Symlink $Path
        }

        try { Restore-BackupItem $Path -Delete } catch [Exception] {}
    }
}

PROCESS {
    if ($Install) {

        # Test is admin and set dotilfes env variable
        TestIsAdmin
        Set-EnvironmentVariable "DOTFILES" $dotfiles -User

        Get-ChildItem "$dotfiles\*\PowershellModules" | 
            where { $_.PSIsContainer } | 
            foreach { Add-VariableToEnvironmentVariable PSModulePath "$_\" -User }

        $symlinkMappings | foreach { NewSymlinkWithBackup $_[0] $_[1] }

        # Script run successfully
        Write-Output "Script Run Successfully. Please restart powershell for changes to take effect"

    } elseif ($Uninstall) {

        # Test is admin and remove the dotfiles env variable
        TestIsAdmin
        Remove-EnvironmentVariable "DOTFILES" -User

        Get-ChildItem "$dotfiles\*\PowershellModules" | 
            where { $_.PSIsContainer } | 
            foreach { Remove-VariableFromEnvironmentVariable PSModulePath "$_\" -User }

        $symlinkMappings | foreach { RemoveSymlinkWithBackup $_[1] }

        # Script run successfully
        Write-Output "Script Run Successfully. Please restart powershell for changes to take effect"
    } elseif ($Chocolatey) {
        Write-Verbose "Installing Chocolatey"
        iex ((new-object net.webclient).DownloadString("http://bit.ly/psChocInstall"))
    } else {
        Get-Help $MyInvocation.MyCommand.Path
    }
}

END {
    Pop-Location
}
