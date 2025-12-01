$numero = Read-Host "Introduce un número"

$numero = [int]$numero

if ($numero % 2 -eq 0) {
    Write-Host "El número $numero es PAR."
} else {
    Write-Host "El número $numero es IMPAR."
}
