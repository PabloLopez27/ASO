$edad = Read-Host "Introduce tu edad"


$edad = [int]$edad


if ($edad -lt 18) {
    Write-Host "Menor de edad"
} else {
    Write-Host "Mayor de edad"
}
