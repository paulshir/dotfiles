Function Set-DnsServers {
    [CmdletBinding()]
    Param(
        [Parameter (Mandatory=$true, ParameterSetName="servers")]
        [Alias("dns")]
        [string[]] $DNSservers,

        [Parameter (Mandatory=$true, ParameterSetName="automatic")]
        [Alias("a")]
        [Switch] $automatic
    )   

    Import-Module CommonFunctions

    if (!(Test-IsAdmin)) {
        throw "Access Denied"
    }

    if (!$automatic -and $DNSservers.Count -ne 2) {
        throw "Incorrect number of DNS Servers. Required Number is 2"
    }

    If ($automatic) {
        $result = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "ipenabled = 'true'" | `
        Invoke-CimMethod -MethodName SetDNSServerSearchOrder
    }
    else {
        $result = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "ipenabled = 'true'" | `
        Invoke-CimMethod -MethodName SetDNSServerSearchOrder -Arguments @{DNSServerSearchOrder = $dnsservers}
    }

    if ($result.ReturnValue -eq 0) {
        Write-Host "Command Completed successfully"
    } elseif ($result.ReturnValue -eq 1) {
        Write-Host "Command Completed successfully. Restart Required"
    } else {
        Write-Error "SetDNSServerSearchOrder Failed with ReturnValue $result.ReturnValue"
    }
}