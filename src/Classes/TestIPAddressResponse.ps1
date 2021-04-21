class TestIPAddressResponse {
    [System.Net.IPAddress]$IPAddress
    [System.Net.IPAddress]$SubnetMask
    [System.Net.IPAddress]$NetworkAddress
    [System.Net.IPAddress]$BroadcastAddress
    [System.Net.IPAddress]$FirstHostAddress
    [System.Net.IPAddress]$LastHostAddress
    [int64]$MaximumHosts
    [bool]$IsNetworkAddressCorrect
}