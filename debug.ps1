Get-ChildItem ./output -ErrorAction Ignore | Remove-Item -Recurse -Force
invoke-psake build
$manifest = Get-ChildItem ./output/*/*.psd1 -Recurse | Select-Object -First 1
Import-Module $manifest.FullName -Force