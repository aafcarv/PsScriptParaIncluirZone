cls

$currentPath = Split-Path $script:MyInvocation.MyCommand.Path

. (Join-Path $currentPath ..\src\get-script_para_incluir_zones.ps1)

$script = Get-ScriptParaIncluirZones

$script.Vsan     = "101"
$script.Hostname = "SERVER001"
$script.Zoneset  = "ZONESET001"

$initiators = "a0:00:00:00:00:00:00:01"

$targets = @"
b0:00:00:00:00:00:00:01;STORAGE01
b0:00:00:00:00:00:00:02;STORAGE03
"@

$script.SetInitiator($initiators)
$script.SetTarget($targets)

$initiators = "a0:00:00:00:00:00:00:02"

$targets = @"
b0:00:00:00:00:00:00:03;STORAGE02
b0:00:00:00:00:00:00:04;STORAGE04
"@

$script.SetInitiator($initiators)
$script.SetTarget($targets)

$script.WriteZones() > (Join-Path $currentPath teste.txt)

Write-Output "!"; Write-Output "!" >> (Join-Path $currentPath teste.txt)

$script.Zoneset  = "ZONESET002"
$script.Vsan = "102"
$script.Hostname = "SERVER002"
$script.ClearPwwns()

$initiators = @"
c0:00:00:00:00:00:00:01
c0:00:00:00:00:00:00:02
"@

$targets = Get-Content .\tapes.txt

$script.SetInitiator($initiators)
$script.SetTarget($targets)

Write-Output "!"; Write-Output "!" >> (Join-Path $currentPath teste.txt)

$script.WriteZones() >> (Join-Path $currentPath teste.txt)

Get-Content (Join-Path $currentPath teste.txt)

