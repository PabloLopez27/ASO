$nota = Read-Host "Introduce una nota (0-10)"

$nota = [int]$nota

if ($nota -ge 9 -and $nota -le 10) {
    Write-Host "Sobresaliente"
}
elseif ($nota -ge 7 -and $nota -le 8) {
    Write-Host "Notable"
}
elseif ($nota -ge 5 -and $nota -le 6) {
    Write-Host "Aprobado"
}
elseif ($nota -ge 0 -and $nota -le 4) {
    Write-Host "Suspenso"
}
else {
    Write-Host "La nota introducida no es válida. Debe ser entre 0 y 10."
}
