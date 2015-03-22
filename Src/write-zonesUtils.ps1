function Get-Substr([string] $pwwn) {
    
    $substr = $pwwn -replace ":", [System.String]::Empty
        
    if ($substr.Length -gt 4) { $substr = $substr.Substring($substr.Length - 4, 4) }
    
    return $substr
}

function Get-InitAlias([string[]] $initiators) {

    $alias = ""
    $isDirty = $false    
    
    foreach($initiator in $initiators) {
        
        if ($isDirty) { $alias += "_"  }
        
        $alias += Get-Substr $initiator
        
        if (-not $isDirty) { $isDirty = $true }                    
    }
    
    return $alias
}
