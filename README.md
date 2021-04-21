# An answer to [IronScripter.us/a-powershell-ip-challenge/](https://ironscripter.us/a-powershell-ip-challenge/)

## The Challenge

The Chairman has returned with a new challenge that will test not only your PowerShell skills but your networking knowledge as well. The challenge has been graded for Intermediate and Advanced levels, but don’t let that stop you.

Depending on how you approach the challenge, you may find it easier to break it down into discrete parts.

Using PowerShell, write a function, or set of functions, that will test if an IPv4 address like 172.16.2.33/16 belongs to the 172.16.0.0 network. You should test your code with addresses that go beyond the /16 or /24 network boundaries. Or you might come at this from another angle. What is the subnet mask for an address like 172.16.10.20/17? And what network does that represent?

You will have to decide how to accept parameter values for the IP Address, subnet and/or subnet mask. Advanced users should include Verbose output showing the process. Advanced users should also provide 2 parameter sets. One to display a boolean value if the address belongs to the subnet and another to provide detailed information.

The Chairman looks forward to reading your comments with links to your solutions.

## The Solution

This solution is presented in the form of a module complete with Pester tests and a psake build script. To run the tests, execute `Invoke-psake test` from the root of the project.

## How to Build / Test

The following modules should be installed prior to attempting to build, test, or use this module...

1. Pester
2. PSScriptAnalyzer
3. psake

You may run .\setup.ps1 to prepare your system with these modules

Once ready, you may invoke the psake build script using `Invoke-psake build` or `Invoke-psake test`. Executing the Pester tests will run the Test-IPAddress function through several tests to check that it correctly returns the expected data.

When the module is built, you will find a portable version of it with an updated manifest & version in the ./output folder. For development purposes I prefer to setup debug.ps1 to be executed when I hit F5 in VSCode. This way the module gets built and imported each time and it makes for rapid testing.

## Usage

Test-IPAddress can be used to test if a CIDR formatted address is valid, and to get detailed information about the address including network and broadcast addresses, first and last host address, and total host addresses available.

Test-IPAddress can also be used to simply test if a given CIDR address's network address matches the network address parameter provided.

```powershell
Test-IPAddress -Address 172.16.129.101/23
<#
IPAddress               : 172.16.129.101
SubnetMask              : 255.255.254.0
NetworkAddress          : 172.16.128.0
BroadcastAddress        : 172.16.129.255
FirstHostAddress        : 172.16.128.1
LastHostAddress         : 172.16.129.254
MaximumHosts            : 510
IsNetworkAddressCorrect : True
#>

Test-IPAddress -Address 172.16.129.101/23 -NetworkAddress 172.16.128.0
<#
True
#>

Test-IPAddress -Address 172.16.129.101/23 -NetworkAddress 10.0.0.0
<#
False
#>
```

## Known issues

- The Test-IPAddress function cannot take IPv6 addresses yet
