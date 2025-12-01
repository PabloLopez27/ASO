$carpeta = "$env:USERPROFILE\Documents\MisFicheros"

if (-not (Test-Path $carpeta)) {
    New-Item -Path $carpeta -ItemType Directory | Out-Null
    Write-Host "Carpeta creada en: $carpeta"
} else {
    Write-Host "La carpeta ya existe: $carpeta"
}

$ficheros = @("datos.csv", "informe.docx", "Imagen.png")

foreach ($fichero in $ficheros) {
    $rutaFichero = Join-Path $carpeta $fichero
    if (-not (Test-Path $rutaFichero)) {
        New-Item -Path $rutaFichero -ItemType File | Out-Null
        Write-Host "Fichero creado: $fichero"
    } else {
        Write-Host "El fichero ya existe: $fichero"
    }
}
