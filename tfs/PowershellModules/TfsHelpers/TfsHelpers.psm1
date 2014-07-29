Function New-TfsWorkspace {
    [CmdletBinding()]
    Param(
        [parameter (Mandatory=$true)]
        [alias("tfs")]
        [string] $tfsPath,

        [parameter (Mandatory=$true)]
        [alias("workspace")]
        [string] $workspaceName,

        [parameter (Mandatory=$false)]
        [alias("c")]
        [int] $count = 1,

        [parameter (Mandatory=$false)]
        [switch] $get
    )

    # Check if the folder exists
    if (!(Test-Path $workspaceName)) {
        Write-Verbose "Localpath: $workspaceName not found. Creating Directory"
        New-Item -Name $workspaceName -ItemType directory
    }

    $dir = Get-Item $workspaceName
    Push-Location $dir
    $RootName = $dir.Name

    # In the event someone passes a path instead of name
    Write-Verbose "Workspace Name: $RootName"

    # Get the Max Folder number within the localpath
    $max = 0
    $folders = Get-ChildItem . | Where-Object {$_.PSIsContainer}
    foreach ($folder in $folders) {
        $int = $folder.Name -as [int]

        if ($int -and $int -gt $max) {
            $max = $int
        }
    }

    $firstFolder = $max + 1
    $lastFolder = $max + $count
    $folderRange = $firstFolder..$lastFolder
    Write-Verbose "First Folder number: $firstFolder"
    Write-Verbose "Last Folder number: $lastFolder"

    foreach ($folder in $folderRange) {
        New-Item -Name $folder -ItemType directory
        Push-Location $folder

        $wrkspc = "$RootName" + "_" + "$folder"
        Write-Verbose "Creating Workspace: $wrkspc"
        tf workspace /new $wrkspc /noprompt
        tf workfold /map `"$tfsPath`" .

        Pop-Location
    }

    if ($get) {
        foreach ($folder in $folderRange) {
            Push-Location $folder
            $wrkspc = "$RootName" + "_" + "$folder"
            Write-Verbose "Getting Latest for Workspace $wrkspc"
            tf get
            Pop-Location
        }
    }

    Pop-Location
}


export-modulemember *-*
#New-TfsWorkspace "$" .\CatCompT -Verbose
