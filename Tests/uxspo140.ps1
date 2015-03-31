cls

$currentPath = Split-Path $script:MyInvocation.MyCommand.Path

. (Join-Path $currentPath ..\src\get-script_para_incluir_zones.ps1)

$script = Get-ScriptParaIncluirZones

$script.Vsan     = "10"
$script.Hostname = "UXSPO140"
$script.Zoneset  = "ZS_P780_RFB"

$initiators = @"
a0:00:00:00:00:00:00:01
a0:00:00:00:00:00:00:02
"@

$targets = @"
b0:00:00:00:00:00:01:01;VSP1_1H
b0:00:00:00:00:00:01:02;VSP1_1R
"@

$script.SetInitiator($initiators)
$script.SetTargets($targets)

$initiators = @"
a0:00:00:00:00:00:00:03
a0:00:00:00:00:00:00:04
"@

$targets = @"
b0:00:00:00:00:00:01:01;VSP1_2H
b0:00:00:00:00:00:01:02;VSP1_2R
"@

$script.SetInitiator($initiators)
$script.SetTargets($targets)

$initiators = @"
x0:00:00:05
x0:00:00:06
"@
$targets = "k0:00:00:01;VSP1_1M"

$script.SetInitiator($initiators)
$script.SetTargets($targets)

$initiators = @"
x0:00:00:07
x0:00:00:08
"@
$script.SetInitiator($initiators)
$script.SetTargets("k0:00:00:01;VSP1_1K")

$script.SetInitiator(@"
x0:00:00:09
x0:00:00:10
"@)
$script.SetTargets("k0:00:00:01;VSP1_2M")

$script.SetInitiator(@"
x0:00:00:11
x0:00:00:12
"@)

$script.SetTargets("k0:00:00:01;VSP1_2K")

$script.RemoveZones() 

