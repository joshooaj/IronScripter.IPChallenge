function Test-IPAddress {
    [CmdletBinding()]
    [OutputType([TestIPAddressResponse])]
    param (
        # Specifies the address to test in CIDR notation
        [Parameter(Position = 1, Mandatory, ParameterSetName = 'Basic')]
        [Parameter(Position = 1, Mandatory, ParameterSetName = 'Advanced')]
        [string]
        $Address,

        # Specifies the Network Address to test the Address against. If the Address's Network Address does not match,
        # the function returns $false
        [Parameter(Position = 2, Mandatory, ParameterSetName = 'Advanced')]
        [ValidateScript({
            $netAddress = $null
            if ([System.Net.IPAddress]::TryParse($_, [ref]$netAddress) -and $netAddress.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork) {
                $true
            }
            else {
                throw "'$_' is not a valid IPv4 network address"
            }
        })]
        [string]
        $NetworkAddress,

        # Parameter help description
        [Parameter(Position = 3, ParameterSetName = 'Basic')]
        [Parameter(Position = 3, ParameterSetName = 'Advanced')]
        [ValidateSet('Detailed', 'Quiet')]
        [string]
        $InformationLevel = 'Detailed'
    )

    process {
        if ($Address -notmatch '(?<address>[0-9a-f:\.]{1,39})/(?<mask>\d{1,3})') {
            throw [System.IO.InvalidDataException]::new("'$Address' is not formatted in CIDR notation")
        }
        $ipAddress = $null
        if (-not [System.Net.IPAddress]::TryParse($Matches.address, [ref]$ipAddress)) {
            throw [System.IO.InvalidDataException]::new("'$($Matches.address)' is not a valid IPAddress")
        }
        if ($ipAddress.AddressFamily -ne [System.Net.Sockets.AddressFamily]::InterNetwork -and $ipAddress.AddressFamily -ne [System.Net.Sockets.AddressFamily]::InterNetworkV6) {
            throw [System.IO.InvalidDataException]::new("'$($Matches.address)' has an AddressFamily of type '$($ipAddress.AddressFamily)' where InterNetwork or InterNetworkV6 was expected.")
        }

        switch ($ipAddress.AddressFamily) {
            ([System.Net.Sockets.AddressFamily]::InterNetwork) {
                $mask = [byte]$Matches.mask
                Write-Verbose "Parsed subnet mask as $mask in CIDR notation"
                if ($mask -lt 0 -or $mask -gt 32) {
                    throw [System.IO.InvalidDataException]::new("'$mask' is not a valid $($ipAddress.AddressFamily) subnet mask")
                }

                Write-Verbose "Creating decimal representation subnet mask from the value $mask in preparation for bitwise operations"
                $subnet = [int64]0
                for ($i = 0; $i -lt 32; $i++) {
                    if ($i -lt $mask) {
                        $subnet = $subnet -bor 1
                    }
                    else {
                        $subnet = $subnet -bor 0
                    }
                    if ($i -lt 31) {
                        $subnet = $subnet -shl 1
                    }
                }
                Write-Verbose "The decimal value of the subnet mask is $subnet"

                Write-Verbose "Converting $ipAddress to decimal value in preparation for bitwise operations"
                $hostAddress = [int64]0
                $addressBytes = $ipAddress.GetAddressBytes()
                for ($i = 0; $i -lt $addressBytes.Count; $i++) {
                    $hostAddress = $hostAddress -bor $addressBytes[$i]
                    if ($i -lt $addressBytes.Count - 1) {
                        $hostAddress = $hostAddress -shl 8
                    }
                }
                Write-Verbose "The decimal value of the IPAddress is $hostAddress"

                Write-Verbose "Calculating the NetworkAddress value by performing a binary and operation on the IPAddress and the SubnetMask"
                [int64]$netAddress = $hostAddress -band $subnet
                Write-Verbose "Calculating the BroadcastAddress value by performing a binary exclusive or on the NetworkAddress and an inverted SubnetMask"
                [int64]$broadcast = $netAddress -bxor ($subnet -bxor 4294967295)

                $result = [TestIPAddressResponse]@{
                    IPAddress = [System.Net.IPAddress]::parse((ConvertTo-IPv4String -Address $hostAddress))
                    SubnetMask = [System.Net.IPAddress]::parse((ConvertTo-IPv4String -Address $subnet))
                    NetworkAddress = [System.Net.IPAddress]::parse((ConvertTo-IPv4String -Address $netAddress))
                    BroadcastAddress = [System.Net.IPAddress]::parse((ConvertTo-IPv4String -Address $broadcast))
                    FirstHostAddress = [System.Net.IPAddress]::parse((ConvertTo-IPv4String -Address ($netAddress + 1)))
                    LastHostAddress =  [System.Net.IPAddress]::parse((ConvertTo-IPv4String -Address ($broadcast - 1)))
                    MaximumHosts = $broadcast - $netAddress - 1
                    IsNetworkAddressCorrect = $true
                }
                if ($PSCmdlet.ParameterSetName -eq 'Advanced') {
                    $result.IsNetworkAddressCorrect = $result.NetworkAddress -eq $NetworkAddress
                }

                if ($InformationLevel -eq 'Detailed') {
                    Write-Output $result
                }
                else {
                    Write-Output $result.IsNetworkAddressCorrect
                }

            }
            default {
                throw "IPv6 is not implemented"
            }
        }

    }
}