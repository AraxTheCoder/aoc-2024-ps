function Check-Producable($patterns, $design){
    if($design.Length -le 0){
        return 1
    }

    if($script:cache.Contains($design)){
        return $script:cache[$design]
    }

    $script:cache[$design] = 0
    
    foreach($pattern in $patterns){
        if($design.StartsWith($pattern)){
            $script:cache[$design] += (Check-Producable $patterns ($design.Substring($pattern.Length)))
        }
    }
    # Write-Host $design, $script:cache[$design]

    return $script:cache[$design]
}

# $input = Get-Content "input-test.txt"
$input = Get-Content "input.txt"
$patterns = ($input[0] -split ", ")
$designs = $input[2..$input.Length]
$producable = 0
$ways = 0
$script:cache = @{}

foreach($design in $designs){
    $p = Check-Producable $patterns $design
    # Write-Host $p
    if($p -ne 0){
        $producable++
        $ways += $p
    }
}

Write-Host $producable
Write-Host $ways
# Check-Producable $patterns "gbbr"