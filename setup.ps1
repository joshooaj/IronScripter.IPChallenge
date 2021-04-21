function Initialize-DevEnvironment {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Install-Module -Name psake, Pester, PSScriptAnalyzer -Force -Scope CurrentUser -SkipPublisherCheck
}

Initialize-DevEnvironment