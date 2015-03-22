. (Join-Path (Split-Path $script:MyInvocation.MyCommand.Path) write-zones.ps1)

function Get-ScriptParaIncluirZone {

    $instance = New-Object PSObject

    $setInitiator = { param($initiator) $this.Initiators += $initiator }			

    $setTarget = { param($target) $this.Targets += $target }			       

    $writeScript = {

        $script:zonenames = (@())
        
        Write-Output "!"
    
        for($i = 0; $i -lt $this.Initiators.Count; $i++) {			            
            
            $initiators = $this.Initiators[$i] -split [System.Environment]::NewLine
            $targets    = $this.Targets[$i]    -split [System.Environment]::NewLine

            write-zones $initiators $targets $this.Hostname $this.Vsan
        }                

        write-zonenames $this.Zoneset $this.vsan
    }

    $clearWwpns = {
        $this.Initiators = (@())
        $this.Targets    = (@())
    }
	
    $instance | Add-Member NoteProperty Initiators (@())
    $instance | Add-Member NoteProperty Targets (@())
    $instance | Add-Member NoteProperty Vsan [System.String]::Empty
    $instance | Add-Member NoteProperty Hostname [System.String]::Empty
    $instance | Add-Member NoteProperty Zoneset [System.String]::Empty
    $instance | Add-Member ScriptMethod SetInitiator $setInitiator
    $instance | Add-Member ScriptMethod SetTarget $setTarget
    $instance | Add-Member ScriptMethod WriteScript $writeScript
    $instance | Add-Member ScriptMethod ClearWwpns $clearWwpns


    return $instance
}