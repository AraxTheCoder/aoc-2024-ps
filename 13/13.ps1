class Machine{
    [long]$ax
    [long]$ay
    [long]$bx
    [long]$by
    [long]$px
    [long]$py

    Machine($ax, $ay, $bx, $by, $px, $py){
        $this.ax = $ax
        $this.ay = $ay
        $this.bx = $bx
        $this.by = $by
        $this.px = $px
        $this.py = $py
    }
}

# $input = (Get-Content "input-test.txt")
$input = (Get-Content "input.txt")
$machines = New-Object System.Collections.ArrayList
$ax, $ay, $bx, $by, $px, $py = -1

foreach($line in $input){
    $description, $rest = $line.split(": ")

    if($description -eq "Button A"){
        $dx, $dy = $rest.split(", ")

        $ax = $dx.substring(2)
        $ay = $dy.substring(2)
    }elseif($description -eq "Button B"){
        $dx, $dy = $rest.split(", ")

        $bx = $dx.substring(2)
        $by = $dy.substring(2)
    }elseif($description -eq "Prize"){
        $dx, $dy = $rest.split(", ")

        $px = $dx.substring(2)
        $py = $dy.substring(2)
    }else{
        $null = $machines.add([Machine]::new($ax, $ay, $bx, $by, $px, $py))
    }
}
$null = $machines.add([Machine]::new($ax, $ay, $bx, $by, $px, $py))

$tokens1 = 0
$tokens2 = 0
foreach($machine in $machines){
    $B1 = [math]::floor(($machine.ay * $machine.px - $machine.ax * $machine.py) / ($machine.ay * $machine.bx - $machine.ax * $machine.by))
    $A1 = [math]::floor(($machine.px - $machine.bx * $B1) / $machine.ax)
    $valid1 = ($machine.ax * $A1 + $machine.bx * $B1) -eq $machine.px -and ($machine.ay * $A1 + $machine.by * $B1) -eq $machine.py
    
    if($valid1){
        # Write-Host "A=$A", "B=$B"
        $tokens1 += $A1 * 3
        $tokens1 += $B1 * 1
    }

    $machine.px += 10000000000000
    $machine.py += 10000000000000

    $B2 = [math]::floor(($machine.ay * $machine.px - $machine.ax * $machine.py) / ($machine.ay * $machine.bx - $machine.ax * $machine.by))
    $A2 = [math]::floor(($machine.px - $machine.bx * $B2) / $machine.ax)
    $valid2 = ($machine.ax * $A2 + $machine.bx * $B2) -eq $machine.px -and ($machine.ay * $A2 + $machine.by * $B2) -eq $machine.py
    
    if($valid2){
        # Write-Host "A=$A", "B=$B"
        $tokens2 += $A2 * 3
        $tokens2 += $B2 * 1
    }
    # Write-Host ($machine.ax, $machine.ay, $machine.bx, $machine.by, $machine.px, $machine.py)
}

Write-Host $tokens1, $tokens2