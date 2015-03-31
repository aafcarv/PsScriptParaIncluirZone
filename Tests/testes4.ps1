. (Join-Path (Split-Path $script:MyInvocation.MyCommand.Path) ..\src\get-script_para_incluir_zones.ps1)

$o = Get-ScriptParaIncluirZones

$o.Hostname = "SERVER01"
$o.Vsan = "2"
$o.Zoneset = "ZONESET01"

$init = "00:00:00:00:01"
$tars = @"
00:00:00:00:0a;STORAGE0a
00:00:00:00:0b;STORAGE0b
"@
$o.SetInitiator($init)
$o.SetTargets($tars)


$init = @"
00:00:00:00:21
00:00:00:00:22
"@
$tars = @"
00:00:00:00:0c;STORAGE0c
00:00:00:00:0d;STORAGE0d
00:00:00:00:0e;STORAGE0e
"@
$o.SetInitiator($init)
$o.SetTargets($tars)


$init = "00:00:00:00:03"
$tars = "00:00:00:00:0f;TAPE0f"
$o.SetInitiator($init)
$o.SetTargets($tars)

$o.RemoveZones()