function Get-Speedtest {

    speedtest | Tee-Object -variable clir

    $list = ($clir.trim() -join "&").replace("&&","&").split("&") | select -skip 2

    $Object = New-Object PSObject
    foreach ($line in $list){
        $name = [regex]::split($line.trim(),'^([^:]+):[ ]*')[1]
        $value = [regex]::split($line,'^([^:]+):[ ]*')[2]
        $value = $value.split("(")[0]
   
        $Object | add-member Noteproperty $name $value
    
        if($line -like "*(*)"){
        
            $l = $line.split("(")[1] -replace("\)")
            if($l -like "*=*"){

            $name2 = $name + " " + $l.split("=").trim()[0]
            $value2 = $l.split("=").trim()[1]
        
            }elseif($l -like "*used:*"){

            $name2 = $name + " " + $l.split(":").trim()[0]
            $value2 = $l.split(":").trim()[1]
        
            }elseif($l -like "*ms jitter"){
        
            $name2 = "$name Jitter"
            $value2 = $l.split("j").trim()[0]
        
            }

            $Object | add-member Noteproperty $name2 $value2
        }   
    }

    return $Object
}