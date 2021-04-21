Describe 'IP Challenge Tests' {
    It 'Correctly determines network address for 192.168.1.165/23 is ''192.168.0.0''' {
        $result = Test-IPAddress -Address 192.168.1.165/23
        $result.NetworkAddress | Should -Be '192.168.0.0'
    }

    It 'Correctly determines broadcast address for 192.168.1.165/23 is ''192.168.1.255''' {
        $result = Test-IPAddress -Address 192.168.1.165/23
        $result.BroadcastAddress | Should -Be '192.168.1.255'
    }

    It 'Correctly determines subnet mask for 192.168.1.165/23 is ''255.255.254.0''' {
        $result = Test-IPAddress -Address 192.168.1.165/23
        $result.SubnetMask | Should -Be '255.255.254.0'
    }

    It 'Correctly determines first host address for 192.168.1.165/23 is ''192.168.0.1''' {
        $result = Test-IPAddress -Address 192.168.1.165/23
        $result.FirstHostAddress | Should -Be '192.168.0.1'
    }

    It 'Correctly determines last host address for 192.168.1.165/23 is ''192.168.1.254''' {
        $result = Test-IPAddress -Address 192.168.1.165/23
        $result.LastHostAddress | Should -Be '192.168.1.254'
    }

    It 'Correctly confirms 10.125.254.165/27 is in network 10.125.254.160' {
        $result = Test-IPAddress -Address 10.125.254.165/27 -NetworkAddress 10.125.254.160 -InformationLevel Quiet
        $result | Should -Be $true
    }

    It 'Correctly confirms 10.125.254.165/27 is NOT in network 10.125.254.128' {
        $result = Test-IPAddress -Address 192.168.1.165/23 -NetworkAddress 10.125.254.128 -InformationLevel Quiet
        $result | Should -Be $false
    }
}