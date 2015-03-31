cls

$currentPath = Split-Path $script:MyInvocation.MyCommand.Path

. (Join-Path $currentPath ..\src\get-script_para_incluir_zones.ps1)

$script = Get-ScriptParaIncluirZones

$script.Vsan     = "101"
$script.Hostname = "SERVER001"
$script.Zoneset  = "ZONESET001"

$initiators = @"
a0:00:00:00:00:00:00:01
a0:00:00:00:00:00:00:02
"@

$targets = @"
b0:00:00:00:00:00:01:01;TAPE01
b0:00:00:00:00:00:01:02;TAPE02
b0:00:00:00:00:00:01:03;TAPE03
"@

$script.SetInitiator($initiators)
$script.SetTargets($targets)

$script.RemoveZones() | Set-Content -Path .\teste3.txt -Encoding UTF8

$script.Vsan     = "102"
$script.Hostname = "SERVER002"
$script.Zoneset  = "ZONESET002"
$script.ClearPwwns()

#$script.SetInitiatorFromFile(".\initiator.txt")
#$script.SetTargetsFromFile(".\tapes.txt")

$file = Get-Content -Path .\tapes.txt -Encoding UTF8
$file = [string]::Join([Environment]::NewLine, $file)
$script.SetTargets($file)

$file = Get-Content -Path .\initiator.txt -Encoding UTF8
$file = [string]::Join([Environment]::NewLine, $file)
$script.SetInitiator($file)
 
$script.RemoveZones() | Add-Content -Path .\teste3.txt -Encoding UTF8

$script.Vsan     = "103"
$script.Hostname = "SERVER003"
$script.Zoneset  = "ZONESET003"
$script.ClearPwwns()

$script.SetInitiatorFromFile(".\initiator2.txt")
$script.SetTargetsFromFile(".\tapes3.txt")

$script.RemoveZones() | Add-Content -Path .\teste3.txt -Encoding UTF8

Get-Content -Path .\teste3.txt -Encoding UTF8

