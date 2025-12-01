$personas = @()
$personas += "Luis"
$personas += "Pedro"
$personas += "Maria"

Write-Host "Elementos agregados al array:`n $personas`n"

Write-Host "Acceso por índices positivos:"
Write-Host "  [0] = $($personas[0])"
Write-Host "  [1] = $($personas[1])"
Write-Host "  [2] = $($personas[2])`n"

Write-Host "Acceso por índices negativos:"
Write-Host "  [-1] = $($personas[-1])"
Write-Host "  [-2] = $($personas[-2])"
Write-Host "  [-3] = $($personas[-3])`n"

Write-Host "Último elemento (método índice negativo): $($personas[-1])"
Write-Host "Último elemento (método Count-1): $($personas[$personas.Count - 1])`n"

$numero = ,1
Write-Host "Array con un solo número: $numero"
Write-Host "Tipo del objeto: $($numero.GetType().Name)`n"

$docs = [Environment]::GetFolderPath("MyDocuments")
$scriptsPath = Join-Path $docs "Scripts"

Write-Host "Ruta de Documentos: $docs"
Write-Host "Ruta de Scripts: $scriptsPath`n"

if (Test-Path $scriptsPath) {
    $archivos = Get-ChildItem -Path $scriptsPath -File
    Write-Host "Archivos encontrados en Scripts:"
    $archivos
    Write-Host "`nCantidad de archivos: $($archivos.Count)"
}
else {
    Write-Host "La carpeta Scripts no existe en Documentos."
}
