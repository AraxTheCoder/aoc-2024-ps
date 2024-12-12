$global:neighborsDirections = @(@(1, 0), @(-1, 0), @(0, 1), @(0, -1))
$global:cornerDirections = @(-1, 1)

function getSymbol{
    param(
        [int] $x,
        [int] $y,
        $grid
    )

    if($x -lt 0 -or $x -ge $grid[0].Length -or $y -lt 0 -or $y -ge $grid.Length){
        return $null
    }

    return $grid[$y][$x];
}

function formChunk($x, $y, $grid, $id, $symbol, $regions){
    # param(
    #     [int] $x,
    #     [int] $y,
    #     $grid,
    #     [int] $id,
    #     [string] $symbol,
    #     [Object[,]] $regions
    # )

    $area = 0
    $perimeter = 0
    $side = 0

    if((getSymbol -x $x -y $y -grid $grid) -ne $symbol){
        return 0, $area, $perimeter, $side
    }

    if($regions[$y, $x] -eq $id){
        return 1, $area, $perimeter, $side
    }elseif($null -ne $regions[$y, $x]){
        return 0, $area, $perimeter, $side
    }

    $regions[$y, $x] = $id
    $area += 1

    $borders = 0
    foreach($direction in $global:neighborsDirections){
        $dx = $direction[0]
        $dy = $direction[1]

        # $n, $ar, $per, $sid = (formChunk -x ($x + $dx) -y ($y + $dy) -grid $grid -id $id -symbol $symbol -regions $regions)
        $n, $ar, $per, $sid = (formChunk ($x + $dx) ($y + $dy) $grid $id $symbol $regions)
        $borders += $n
        $area += $ar
        $perimeter += $per
        $side += $sid
    }

    # $global:neighborsDirections | ForEach-Object -Parallel {
    #     $dx = $_[0]
    #     $dy = $_[1]

    #     # $n, $ar, $per, $sid = (formChunk -x ($x + $dx) -y ($y + $dy) -grid $grid -id $id -symbol $symbol -regions $regions)
    #     $n, $ar, $per, $sid = (formChunk ($x + $dx) ($y + $dy) $grid $id $symbol $regions)
    #     $borders += $n
    #     $area += $ar
    #     $perimeter += $per
    #     $side += $sid
    # }

    $perimeter += (4 - $borders)

    $side += (insideCorners -x $x -y $y -grid $grid)
    $side += (outsideCorners -x $x -y $y -grid $grid)

    return 1, $area, $perimeter, $side
}

function outsideCorners{
    param(
        [int] $x,
        [int] $y,
        $grid
    )
    $symbol = $grid[$y][$x]
    $res = 0

    foreach($dx in $global:cornerDirections){
        foreach($dy in $global:cornerDirections){
            $s1 = (getSymbol -x $x -y ($y + $dy) -grid $grid)
            $s2 = (getSymbol -x ($x + $dx) -y $y -grid $grid)

            if($s1 -ne $symbol -and $s2 -ne $symbol){
                $res += 1
            }
        }
    }

    return $res
}

function insideCorners{
    param(
        [int] $x,
        [int] $y,
        $grid
    )
    $symbol = $grid[$y][$x]
    $res = 0

    foreach($dx in $global:cornerDirections){
        foreach($dy in $global:cornerDirections){
            $s1 = (getSymbol -x $x -y ($y + $dy) -grid $grid)
            $s2 = (getSymbol -x ($x + $dx) -y $y -grid $grid)
            $s3 = (getSymbol -x ($x + $dx) -y ($y + $dy) -grid $grid)

            if($s1 -eq $symbol -and $s2 -eq $symbol -and $s3 -ne $symbol){
                $res += 1
            }
        }
    }

    return $res
}

$grid = (Get-Content "input.txt") | ForEach-Object { ,$_.toCharArray() }
# $grid = (Get-Content "input-test.txt") | ForEach-Object { ,$_.toCharArray() }

$regions = (New-Object 'object[,]' $grid.Length,$grid[0].Length)

$id = 0
$result1 = 0
$result2 = 0

for($y = 0; $y -lt $grid.Length; $y++){
    for($x = 0; $x -lt $grid[0].Length; $x++){
        $unused, $area, $perimeter, $sides = formChunk $x $y $grid $id ($grid[$y][$x]) $regions
        # $unused, $area, $perimeter, $sides = formChunk -x $x -y $y -grid $grid -id $id -symbol ($grid[$y][$x]) -region $regions
        $id++
        $result1 += $area * $perimeter
        $result2 += $area * $sides
    }
}

Write-Host $result1
Write-Host $result2