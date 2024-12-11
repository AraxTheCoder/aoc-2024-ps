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

function blink-recursiv{
    param(
        [long] $number,
        [int] $times
    )

    if (-not $script:cache) {
        $script:cache = @{}
    }

    $cacheKey = "$number|$times"
    if ($script:cache.ContainsKey($cacheKey)) {
        return $script:cache[$cacheKey]
    }

    # Write-Host $number
    if($times -eq 0){
        return 1
    }

    if($number -eq 0){
        $result = (blink-recursiv ($number + 1) ($times - 1))
    }elseif((($number.ToString()).Length % 2) -eq 0){
        $numberString = $number.ToString()
        $middle = $numberString.Length / 2
        $result = (blink-recursiv ([long]$numberString.Substring(0, $middle)) ($times - 1)) + (blink-recursiv ([long]$numberString.Substring($middle)) ($times - 1))
    }else{
        $result = (blink-recursiv ($number * 2024) ($times - 1))
    }

    $script:cache[$cacheKey] = $result
    return $result
}

function a{
    # $numbers = (Get-Content "input-test.txt").split(" ")
    $numbers = (Get-Content "input.txt").split(" ")

    for($blinking = 0; $blinking -lt 25; $blinking++){
        $numbers = blink $numbers
        Write-Host ($numbers).Length
    }
}

function b{
    # $numbers = (Get-Content "input-test.txt").split(" ")
    $numbers = (Get-Content "input.txt").split(" ")

    $stonesAmount = 0
    foreach($number in $numbers){
        $stonesAmount += (blink-recursiv $number 75)
        Write-Host $stonesAmount
    }
    Write-Host $stonesAmount
}

# a
b