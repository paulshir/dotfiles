Function ConvertFrom-Base64Guid
{
    [CmdletBinding()]
    Param (
        [Parameter (Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [String] $in
    )

    BEGIN {}

    PROCESS {
        $b = [System.Convert]::FromBase64String($in);
        $g = New-Object -TypeName System.Guid -ArgumentList (,$b);
        Write-Output $g
    }

    END {}
}

Function ConvertTo-Base64Guid
{
    [CmdletBinding()]
    Param (
        [Parameter (Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [System.Guid] $Guid
    )

    BEGIN {}

    PROCESS {
        Write-Output $([System.Convert]::ToBase64String($Guid.ToByteArray()));
    }

    END {}
}

Function ConvertFrom-Base64Unicode
{
    [CmdletBinding()]
    Param (
        [Parameter (Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [String] $in
    )

    BEGIN {}

    PROCESS {
        $b = [System.Convert]::FromBase64String($in)
        $str = [System.Text.Encoding]::Unicode.GetString($b)
        Write-Output $str
    }

    END {}
}

Function ConvertTo-Base64Unicode
{
    [CmdletBinding()]
    Param (
        [Parameter (Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [String] $in
    )

    BEGIN {}

    PROCESS {
        $b = [System.Text.Encoding]::Unicode.GetBytes($in)
        Write-Output $([System.Convert]::ToBase64String($b))
    }

    END {}
}