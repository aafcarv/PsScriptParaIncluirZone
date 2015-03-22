. (Join-Path (Split-Path $script:MyInvocation.MyCommand.Path) write-zonesUtils.ps1)
. (Join-Path (Split-Path $script:MyInvocation.MyCommand.Path) write-zonenames.ps1)

function Write-Zones ($initiators, $targets, $hostname, $vsan) {

    $zonename  = [System.String]::Empty
    $alias     = Get-InitAlias $initiators

    foreach($target in $targets) {

        $temp = $target -split ";"

        $zonename = "Z_$($hostname)_$($alias)_$($temp[1])"

        $script:zonenames += $zonename

        Write-Output "zone name $zonename vsan $vsan"

        foreach($initiator in $initiators) { Write-Output "member pwwn $initiator" }

        Write-Output "member pwwn $($temp[0])"
        Write-Output "!"
    }
}