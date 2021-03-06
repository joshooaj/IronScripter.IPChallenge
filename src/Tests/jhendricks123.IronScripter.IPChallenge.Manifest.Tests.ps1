Describe 'Module Manifest Tests' {
    BeforeAll {
        $ModuleManifestName = 'jhendricks123.IronScripter.IPChallenge.psd1'
        $script:ModuleManifestPath = "$PSScriptRoot\..\$ModuleManifestName"
    }

    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $script:ModuleManifestPath | Should -Not -BeNullOrEmpty
        $? | Should -Be $true
    }
}