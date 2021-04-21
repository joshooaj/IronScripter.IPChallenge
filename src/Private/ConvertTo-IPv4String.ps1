function ConvertTo-IPv4String {
    [CmdletBinding()]
    param (
        # Specifies an IPv4 address in decimal form as an int64
        [Parameter(Mandatory)]
        [int64]
        $Address
    )

    process {
        $segments = [string[]]::new(4)
        for ($i = 3; $i -gt -1; $i--) {
            $segments[$i] = ($Address -band 255).ToString()
            $Address = $Address -shr 8
        }
        $result = [string]::Join('.', $segments)
        Write-Output $result
    }
}