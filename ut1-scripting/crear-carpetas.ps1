# Ruta de la carpeta Documentos del usuario actual
$documentos = [Environment]::GetFolderPath("MyDocuments")

# Ruta completa para la carpeta Logs
$carpetaLogs = Join-Path -Path $documentos -ChildPath "Logs"

# Crear la carpeta Logs si no existe
if (-not (Test-Path -Path $carpetaLogs)) {
    New-Item -Path $carpetaLogs -ItemType Directory | Out-Null
    Write-Host "Carpeta 'Logs' creada en $carpetaLogs"
} else {
    Write-Host "La carpeta 'Logs' ya existe en $carpetaLogs"
}

# Crear 10 ficheros vacíos log1.txt ... log10.txt
for ($i = 1; $i -le 10; $i++) {
    $rutaArchivo = Join-Path -Path $carpetaLogs -ChildPath "log$i.txt"
    # Crear archivo vacío o sobrescribir si existe
    New-Item -Path $rutaArchivo -ItemType File -Force | Out-Null
    Write-Host "Archivo creado: log$i.txt"
}
