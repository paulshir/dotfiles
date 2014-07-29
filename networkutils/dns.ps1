Function Set-DnsServersGoogle {
    [CmdletBinding()]
    Param()

    $servers = "8.8.8.8", "8.8.4.4"

    Set-DnsServers -dns $servers
}

Function Set-DnsServersAuto {
    [CmdletBinding()]
    Param()
    
    Set-DnsServers -a    
}