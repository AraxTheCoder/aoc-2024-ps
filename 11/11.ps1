function blink{
    param(
        [long[]] $prevNumbers
    )

    $numbers = New-Object System.Collections.Generic.List[System.Object]

    foreach($number in $prevNumbers){
        if($number -eq 0){
            $numbers.Add(1)
        }elseif((($number.ToString()).Length % 2) -eq 0){
            $numberString = $number.ToString()
            $middle = $numberString.Length / 2
            $numbers.Add($numberString.Substring(0, $middle))
            $numbers.Add($numberString.Substring($middle)) 
        }else{
            $numbers.Add($number * 2024) 
        }
    }

    return $numbers
}

function a{
    # $numbers = (Get-Content "input-test.txt").split(" ")
    $numbers = (Get-Content "input.txt").split(" ")

    for($blinking = 0; $blinking -lt 25; $blinking++){
        $numbers = blink $numbers
        Write-Output ($numbers).Length
    }
}

a