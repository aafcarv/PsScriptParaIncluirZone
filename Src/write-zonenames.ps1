function Write-Zonenames ($zoneset, $vsan) {
       
    Write-Output "zoneset name $zoneset vsan $vsan"                
    foreach($zonename in $script:zonenames) { Write-Output "member $zonename" }    
    Write-Output "!"
}