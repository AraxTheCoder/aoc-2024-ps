function Print-Grid($grid){
    foreach($line in $grid){
        Write-Host $line
    }
}

function Find-Robot-Position($grid){
    for($y = 0; $y -lt $grid.Length; $y++){
        for($x = 0; $x -lt $grid[0].Length; $x++){
            if($grid[$y][$x] -eq "@"){
                return $x, $y
            }
        }
    }

    return $null, $null
}

function Sum-GPS($grid){
    $res = 0
    for($y = 0; $y -lt $grid.Length; $y++){
        for($x = 0; $x -lt $grid[0].Length; $x++){
            if($grid[$y][$x] -eq "O"){
                $res += 100 * $y + $x
            }
        }
    }

    return $res
}

function Can-Go-In-Direction($grid, $x, $y, $dx, $dy){
    while($grid[$y][$x] -ne "#"){
        $x += $dx
        $y += $dy

        if($grid[$y][$x] -eq "O"){
            $neededSpace++
        }elseif($grid[$y][$x] -eq "."){
            return $true
        }
    }

    return $false
}

function Shift-To($grid, $x, $y, $dx, $dy){
    $boxes = 0
    $tmp = $grid[$y + $dy][$x + $dx]
    $grid[$y + $dy][$x + $dx] = $grid[$y][$x]
    $grid[$y][$x] = "."

    if($tmp -eq "O"){
        while($tmp -ne "."){
            $x += $dx
            $y += $dy
            $tmp = $grid[$y][$x]
        }

        $grid[$y][$x] = "O"
    }
}

$input = Get-Content "input-test-2.txt"
# $input = Get-Content "input-test.txt"
# $input = Get-Content "input.txt"
$grid = @()
$moves = @()
$parseGrid = $true

foreach($line in $input){
    if($line -eq ""){
        $parseGrid = $false
        continue
    }

    if($parseGrid -eq $true){
        $grid += (, $line.toCharArray())
    }else{
        $moves += $line.toCharArray()
    }
}

Write-Host $("`n" * 20)
$x, $y = Find-Robot-Position $grid
Write-Host $x, $y
Print-Grid $grid
Write-Host $moves

$directions = @{
    [char]'<' = -1, 0
    [char]'>' = 1, 0
    [char]'^' = 0, -1
    [char]'v' = 0, 1
}

foreach($move in $moves){
    # Write-Host $move, $x, $y
    $dx, $dy = $directions[$move]

    if((Can-Go-In-Direction $grid $x $y $dx $dy) -eq $true){
        Shift-To $grid $x $y $dx $dy
        $x += $dx
        $y += $dy
    }
    # Print-Grid $grid
}

Write-Host (Sum-GPS $grid)