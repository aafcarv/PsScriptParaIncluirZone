function Get-ScriptParaIncluirZones {
    
    $instance = New-Object PSObject

    $SetInitiator = { param($initiator) $this.Initiators += $initiator }            

    $SetTarget = { param($target) $this.Targets += $target }
    
    $WriteZones = {
    
        $zoneset = (@())

        for($i = 0; $i -lt $this.Initiators.Count; $i++) {                      
            
            $initiators = $this.Initiators[$i] -split [System.Environment]::NewLine
            $targets    = $this.Targets[$i]    -split [System.Environment]::NewLine
                        
            $zoneset += Get-Zones $initiators $targets $this.Hostname
        }                
                      
        
        foreach($zones in $zoneset) {            
            
            for($i = 0; $i -lt $zones["Zonenames"].Count; $i++) {
                
                Write-Output "zone name $($zones[""Zonenames""][$i]) vsan $($this.Vsan)"                
                
                foreach($initiator in $zones["Initiators"]) { 
                    
                    Write-Output "member pwwn $initiator" 
                } 
                
                Write-Output "member pwwn $($zones[""Targets""][$i])"                
                Write-Output "!"                   
            }        
        }
                
        Write-Output "zoneset name $($this.Zoneset) vsan $($this.Vsan)"
        
        foreach($zones in $zoneset) {
            
            foreach($zonename in $zones["Zonenames"]) { 
                
                Write-Output "member $zonename" 
            }                
        }
             
    }

    $clearWwpns = {
        $this.Initiators = (@())
        $this.Targets    = (@())
    }
    
    $instance | Add-Member NoteProperty Initiators (@())
    $instance | Add-Member NoteProperty Targets (@())
    $instance | Add-Member NoteProperty Vsan $([System.String]::Empty)
    $instance | Add-Member NoteProperty Hostname $([System.String]::Empty)
    $instance | Add-Member NoteProperty Zoneset $([System.String]::Empty)
    $instance | Add-Member ScriptMethod SetInitiator $SetInitiator
    $instance | Add-Member ScriptMethod SetTarget $SetTarget
    $instance | Add-Member ScriptMethod WriteZones $WriteZones
    $instance | Add-Member ScriptMethod ClearWwpns $clearWwpns

    return $instance
}

function Get-Zones ([string[]] $initiators, [string[]] $targets, [string] $hostname) {
    
    $alias = Get-Alias $initiators
    $zonenames = (@())
    $wwpns = (@())

    foreach($target in $targets) {

        $temp = $target -split ";"
        $wwpns += $temp[0]        
        $zonenames += "Z_$($hostname)_$($alias)_$($temp[1])"
    }

    return @{"Zonenames"=$zonenames;"Initiators"=$initiators;"Targets"=$wwpns}
}

function Get-Alias([string[]] $initiators) {
    
    $alias = [System.String]::Empty
    $isDirty = $false
    
    foreach($initiator in $initiators) {
        
        if($isDirty) { $alias += "_" }        
        $alias += Get-Substr $initiator        
        if (-not $isDirty) { $isDirty = $true }
    }
    
    return $alias
}

function Get-Substr ([string] $substr) {

    $substr = $substr -replace ":", [System.String]::Empty
    if ($substr.Length -gt 4) { $substr = $substr.Substring($substr.Length - 4, 4) }
    
    return $substr    
}