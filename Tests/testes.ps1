$currentPath = Split-Path $script:MyInvocation.MyCommand.Path

. (Join-Path $currentPath "..\src\get-script_para_incluir_zone.ps1")

cls

$scriptParaIncluirZone = Get-ScriptParaIncluirZone

$scriptParaIncluirZone.Vsan     = "101"
$scriptParaIncluirZone.Hostname = "SERVER001"
$scriptParaIncluirZone.Zoneset  = "ZONESET001"

$initiators = "a0:00:00:00:00:00:00:01"

$targets = @"
b0:00:00:00:00:00:00:01;STORAGE01
b0:00:00:00:00:00:00:02;STORAGE03
"@

$scriptParaIncluirZone.setInitiator($initiators)
$scriptParaIncluirZone.setTarget($targets)

$targets = @"
b0:00:00:00:00:00:00:03;STORAGE02
b0:00:00:00:00:00:00:03;STORAGE04
"@

$scriptParaIncluirZone.setInitiator($initiators)
$scriptParaIncluirZone.setTarget($targets)

$scriptParaIncluirZone.WriteScript() > (Join-Path $currentPath teste.txt)


$scriptParaIncluirZone.Zoneset  = "ZONESET002"
$scriptParaIncluirZone.Vsan = "102"
$scriptParaIncluirZone.Hostname = "SERVER002"
$scriptParaIncluirZone.ClearWwpns()

$initiators = @"
c0:00:00:00:00:00:00:01
c0:00:00:00:00:00:00:02
"@

$targets = @"
d0:00:00:00:00:00:01:01;TAPE01
d0:00:00:00:00:00:01:02;TAPE02
d0:00:00:00:00:00:01:03;TAPE03
d0:00:00:00:00:00:01:04;TAPE04
d0:00:00:00:00:00:01:05;TAPE05
d0:00:00:00:00:00:01:06;TAPE06
d0:00:00:00:00:00:01:07;TAPE07
d0:00:00:00:00:00:01:08;TAPE08
d0:00:00:00:00:00:01:09;TAPE09
d0:00:00:00:00:00:01:10;TAPE10
"@

$scriptParaIncluirZone.setInitiator($initiators)
$scriptParaIncluirZone.setTarget($targets)

$scriptParaIncluirZone.WriteScript() >> (Join-Path $currentPath teste.txt)

Get-Content (Join-Path $currentPath teste.txt)

