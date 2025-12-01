$numeros = 1..10

foreach ($num in $numeros) {
    $cuadrado = $num * $num
    Write-Host "El cuadrado de $num es $cuadrado"
}
