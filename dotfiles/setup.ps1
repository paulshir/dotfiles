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
    [Alias("in")]
    [switch] $Install,

    [Parameter (Mandatory=$true, ParameterSetName="Uninstall")]
    [Alias("un")]
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

    function TestIsAdmin() {
        if (!(Test-IsAdmin)) {
            throw "To continue run this script as an admin"
            return
        }
    }

    function NewSymlinkWithBackup([String]$Path, [String]$Target) {
        if (Test-Symlink $path) {
            Remove-Symlink $path
        }

        if (Test-Path $Path) {
            New-BackupItem $path -Delete
        }

        $pathDir = Split-Path -Parent $Path
        if (!(Test-Path $pathDir)) {
            mkdir -Force $pathDir | Out-Null
        }

        New-Symlink $Path $Target | Out-Null
    }

    function RemoveSymlinkWithBackup([String]$Path) {
        if (Test-Symlink $Path) {
            Remove-Symlink $Path
        }

        try { Restore-BackupItem $Path -Delete } catch [Exception] {}

    }

    function AddPowershell() {
        # Add Powershell Modules
        Write-Verbose "Adding Powershell Modules"
        $powershellModules = Resolve-Path "$dotfiles\powershell\PowershellModules"

        Add-VariableToEnvironmentVariable PSModulePath "$powershellModules\" -User

        # Make Symlink to $Profile
        $profilePath = Resolve-NonExistentPath "$MyDocuments\WindowsPowershell\profile.ps1"
        $profileTarget = Resolve-Path "$dotfiles\powershell\profile.ps1"
        NewSymlinkWithBackup $profilePath $profileTarget
    }

    function RemovePowershell() {
        # Remove Powershell Modules
        Write-Verbose "Removing Powershell Modules"
        $powershellModules = Resolve-Path "$dotfiles\powershell\PowershellModules"

        Remove-VariableFromEnvironmentVariable PSModulePath "$powershellModules\" -User

        # Remove Symlink to $Profile
        $profilePath = Resolve-NonExistentPath "$MyDocuments\WindowsPowershell\profile.ps1"
        RemoveSymlinkWithBackup $profilePath
    }

    function AddGit() {
    }

    function RemoveGit() {
    }

    function AddNetworkUtils() {
        Write-Verbose "Adding NetworkUtils Module"
        $networkUtilsModule = Resolve-Path "$dotfiles\networkutils\PowershellModules"
        Add-VariableToEnvironmentVariable PSModulePath "$networkUtilsModule\" -User
    }

    function RemoveNetworkUtils() {
        Write-Verbose "Removing NetworkUtils Module"
        $networkUtilsModule = Resolve-Path "$dotfiles\networkutils\PowershellModules"
        Remove-VariableFromEnvironmentVariable PSModulePath "$networkUtilsModule\" -User
    }

    function AddSublimeText3() {
        Write-Verbose "Adding Sublimetext3"
        $sublimePreferencesPath = Resolve-NonExistentPath "$($env:APPDATA)\Sublime Text 3\Packages\User"
        $sublimePreferencesTarget = Resolve-Path "$dotfiles\sublimetext3\userpreferences"

        NewSymlinkWithBackup $sublimePreferencesPath $sublimePreferencesTarget
    }

    function RemoveSublimeText3() {
        Write-Verbose "Removing Sublimetext3"
        $sublimePreferencesPath = Resolve-NonExistentPath "$($env:APPDATA)\Sublime Text 3\Packages\User"

        RemoveSymlinkWithBackup $sublimePreferencesPath
    }

    function AddTfs() {
        Write-Verbose "Adding Tfs Module"
        $tfsModule = Resolve-Path "$dotfiles\tfs\PowershellModules"
        Add-VariableToEnvironmentVariable PSModulePath "$tfsModule\" -User
    }

    function RemoveTfs() {
        Write-Verbose "Removing Tfs Module"
        $tfsModule = Resolve-Path "$dotfiles\tfs\PowershellModules"
        Remove-VariableFromEnvironmentVariable PSModulePath "$tfsModule\" -User
    }
}

PROCESS {
    if ($Install) {

        # Test is admin and set dotilfes env variable
        TestIsAdmin
        Set-EnvironmentVariable "DOTFILES" $dotfiles -User

        # Install the dotfiles for the different components
        if (Test-Path "$dotfiles\powershell") { AddPowershell }
        if (Test-Path "$dotfiles\git") { AddGit }
        if (Test-Path "$dotfiles\networkutils") { AddNetworkUtils }
        if (Test-Path "$dotfiles\sublimetext3") { AddSublimeText3 }
        if (Test-Path "$dotfiles\tfs") { AddTfs }

        # Script run successfully
        Write-Output "Script Run Successfully. Please restart powershell for changes to take effect"

    } elseif ($Uninstall) {

        # Test is admin and remove the dotfiles env variable
        TestIsAdmin
        Remove-EnvironmentVariable "DOTFILES" -User

        # Remove the dotfiles for the different components
        if (Test-Path "$dotfiles\powershell\Modules") { RemovePowershell }
        if (Test-Path "$dotfiles\git") { RemoveGit }
        if (Test-Path "$dotfiles\networkutils") { RemoveNetworkUtils }
        if (Test-Path "$dotfiles\sublimetext3") { RemoveSublimeText3 }
        if (Test-Path "$dotfiles\tfs") { RemoveTfs }

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
