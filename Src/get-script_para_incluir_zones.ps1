function Get-ScriptParaIncluirZones {

    $instance = New-Object PSObject

    $SetInitiator = { param($initiator) $this.Initiators += $initiator }

    $SetTarget = { param($target)  $this.Targets += $target }
    
    $setTargetsFromFile = {
    param ($path)
        $lines = Get-Content -Path $path
        $this.Targets += [string]::Join([Environment]::NewLine, $lines)
    }
    
    $setInitiatorFromFile = {
    param ($path)
        $lines = Get-Content -Path $path
        $this.Initiators += [string]::Join([Environment]::NewLine, $lines)
    }
    
    $removeZones = {
        $zonesets = (@())
        
        for($i = 0; $i -lt $this.Initiators.Count; $i++) {        
            $initiators = $this.Initiators[$i] -split [Environment]::NewLine
            $targets = $this.Targets[$i] -split [Environment]::NewLine            
            $zonesets += Get-Zoneset $initiators $targets $this.Hostname
        }
        
        Write-Output "!"
        Write-Output "zoneset clone $($this.Zoneset) Backup_$($this.zoneset) vsan $($this.Vsan)"
        Write-Output "!"
        Write-Output "zone commit vsan $($this.Vsan)"
        Write-Output "!"
        
        Write-Output "!"
        Write-Output "! 1 Remove os zones membros do zoneset"
        Write-Output "!"
        
        Write-Output "zoneset name $($this.Zoneset) vsan $($this.Vsan)"
        
        foreach($zoneset in $zonesets) {
            foreach($zone in $zoneset["Zones"]) {
                Write-Output "no member $($zone[""Zonename""])"
            }
        }                
            
        Write-Output "!"
        Write-Output "! 2 Remove os membros de cada zone"
        Write-Output "!"
            
        foreach($zoneset in $zonesets) {                        
            foreach($zone in $zoneset["Zones"]) {
                Write-Output "zone name $($zone[""Zonename""]) vsan $($this.Vsan)"
                foreach($initiator in $zoneset["Initiators"]) {
                    Write-Output "no member pwwn $initiator" 
                }                
                Write-Output "no member pwwn $($zone[""Target""])"
                Write-Output "!"
            }
        }
        
        Write-Output "! 3 Remove os zones"
        Write-Output "!"

        Write-Output "zoneset name $($this.Zoneset) vsan $($this.Vsan)"            
            
        foreach($zoneset in $zonesets) {                                    
            foreach($zone in $zoneset["Zones"]) {            
                Write-Output "no zone name $($zone[""Zonename""]) vsan $($this.Vsan)"                
            }                        
        }        
        
        Write-Output "!"
        Write-Output "zoneset activate name $($this.Zoneset) vsan $($this.Vsan)"
        Write-Output "!"
        Write-Output "zone commit vsan $($this.Vsan)"
        Write-Output "!"        
    }    

    $writeZones = {

        $zonesets = (@())

        for($i = 0; $i -lt $this.Initiators.Count; $i++) {

            $initiators = $this.Initiators[$i] -split [Environment]::NewLine
            $targets = $this.Targets[$i] -split [Environment]::NewLine

            $zonesets += Get-Zoneset $initiators $targets $this.Hostname
        }

        Write-Output "!"
        Write-Output "zoneset clone $($this.Zoneset) Backup_$($this.zoneset) vsan $($this.Vsan)"
        Write-Output "!"
        Write-Output "zone commit vsan $($this.Vsan)"
        Write-Output "!"

        foreach($zoneset in $zonesets) {

            foreach($zone in $zoneset["Zones"]) {

                Write-Output "zone name $($zone[""Zonename""]) vsan $($this.Vsan)"
                
                foreach($initiator in $zoneset["Initiators"]) {
                    
                    Write-Output "member pwwn $initiator" 
                }
                
                Write-Output "member pwwn $($zone[""Target""])"
                Write-Output "!"
            }
        }

        Write-Output "zoneset name $($this.Zoneset) vsan $($this.Vsan)"

        foreach($zoneset in $zonesets) {

            foreach($zone in $zoneset["Zones"]) {

                Write-Output "member $($zone[""Zonename""])"
            }
        }

        Write-Output "!"
        Write-Output "zoneset activate name $($this.Zoneset) vsan $($this.Vsan)"
        Write-Output "!"
        Write-Output "zone commit vsan $($this.Vsan)"
        Write-Output "!"

    }

    $clearPwwns = {
        $this.Initiators = (@())
        $this.Targets    = (@())
    }

    $instance | Add-Member NoteProperty Initiators (@())
    $instance | Add-Member NoteProperty Targets (@())
    $instance | Add-Member NoteProperty Vsan $([string]::Empty)
    $instance | Add-Member NoteProperty Hostname $([string]::Empty)
    $instance | Add-Member NoteProperty Zoneset $([string]::Empty)
    $instance | Add-Member ScriptMethod SetInitiator $setInitiator
    $instance | Add-Member ScriptMethod SetTargets $setTarget
    $instance | Add-Member ScriptMethod WriteZones $writeZones
    $instance | Add-Member ScriptMethod RemoveZones $removeZones
    $instance | Add-Member ScriptMethod ClearPwwns $clearPwwns
    $instance | Add-Member ScriptMethod SetInitiatorFromFile $setInitiatorFromFile
    $instance | Add-Member ScriptMethod SetTargetsFromFile $setTargetsFromFile    

    return $instance
}

function Get-Zoneset ([string[]] $initiators, [string[]] $targets, [string] $hostname) {

    $zones = (@())
    $alias = Get-AliasInit $initiators

    foreach($target in $targets) {

        $temp = $target -split ";"
        $zonename = "Z_$($hostname)_$($alias)_$($temp[1])"

        $zones += @{"Zonename"=$zonename;"Target"=$temp[0]}
    }

    return @{"Zones"=$zones;"Initiators"=$initiators}
}

function Get-AliasInit ([string[]] $initiators) {

    $alias = [string]::Empty
    $isDirty = $false

    foreach($initiator in $initiators) {

        if($isDirty) { $alias += "_" }
        $alias += Get-Substr $initiator
        if (-not $isDirty) { $isDirty = $true }
    }

    return $alias
}

function Get-Substr ([string] $substr) {

    $substr = $substr -replace ":", [string]::Empty
    if ($substr.Length -gt 4) { $substr = $substr.Substring($substr.Length - 4, 4) }

    return $substr
}