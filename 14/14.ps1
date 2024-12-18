function Positive-Mod($i, $n){
    return ($i % $n + $n) % $n
}

# $input = Get-Content "input-test.txt"
$input = Get-Content "input.txt"
$width = 101
$height = 103
# $width = 11
# $height = 7
$seconds = 100

$positions = @()
Write-Host ("`n" * 20)
$tl = 0
$tr = 0
$bl = 0
$br = 0
foreach($line in $input){
    $position, $velocity = $line.Split(" ")
    $x, $y = $position.Substring(2).Split(",")
    $vx, $vy = $velocity.Substring(2).Split(",")
    $x = [long]$x
    $y = [long]$y
    $vx = [long]$vx
    $vy = [long]$vy

    # Write-Host $x, $y, $vx, $vy
    $x = (Positive-Mod ($x + $seconds * $vx) $width)
    $y = (Positive-Mod ($y + $seconds * $vy) $height)
    # Write-Host $x, $y

    if($x -lt (($width - 1) / 2) -and $y -lt (($height - 1) / 2)){
        $tl++
    }

    if($x -gt (($width - 1) / 2) -and $y -lt (($height - 1) / 2)){
        $tr++
    }

    if($x -lt (($width - 1) / 2) -and $y -gt (($height - 1) / 2)){
        $bl++
    }

    if($x -gt (($width - 1) / 2) -and $y -gt (($height - 1) / 2)){
        $br++
    }
}

Write-Host $tl, $tr, $bl, $br, $($tl * $tr * $bl * $br)

# part 2: search for symmetry axis