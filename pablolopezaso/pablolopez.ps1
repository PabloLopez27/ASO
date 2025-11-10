param(
    [switch]$c,
    [string]$OutputPath = "\\ServidorAula\Comparte_aula\Practica_PS",
    [string]$LogPath = "\\ServidorAula\Comparte_aula\Practica_PS\logs",
    [string]$SessionCode = "UT1_P1_XXX"
)

# ----------------------------
# Funciones de soporte
# ----------------------------

# Función para escribir logs
function Write-Log {
    param(
        [string]$Message,
        [ValidateSet("INFO","WARN","ERROR")][string]$Level = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$timestamp] [$SessionCode] [$Level] [$env:COMPUTERNAME] $Message"
    # Asegurar que el directorio del log existe
    $logFolder = Split-Path $LogPath -Parent
    if (-not (Test-Path $logFolder)) { New-Item -Path $logFolder -ItemType Directory -Force | Out-Null }
    Add-Content -Path $LogPath -Value $line
}

# Función para test de escritura
function Test-WriteAccess {
    param([string]$Path)
    try {
        $tmpFile = Join-Path $Path "tmp_write_test.txt"
        Set-Content -Path $tmpFile -Value "test"
        Remove-Item -Path $tmpFile -Force
        return $true
    }
    catch {
        return $false
    }
}

# ----------------------------
# Comprobación de rutas
# ----------------------------
function Test-AndCreatePath {
    param([string]$Path, [string]$Fallback = [Environment]::GetFolderPath("MyDocuments"))
    if (-not (Test-Path $Path)) {
        try {
            New-Item -Path $Path -ItemType Directory -Force -ErrorAction Stop | Out-Null
            Write-Verbose "Ruta creada: $Path"
            Write-Log "Ruta creada: $Path" "INFO"
        }
        catch {
            Write-Warning "No se pudo crear '$Path'. Se usará '$Fallback'."
            Write-Log "No se pudo crear '$Path'. Se usará '$Fallback'." "WARN"
            $Path = $Fallback
            if (-not (Test-Path $Path)) { New-Item -Path $Path -ItemType Directory -Force | Out-Null }
        }
    } else {
        Write-Verbose "Ruta existente: $Path"
    }
    return $Path
}

# Comprobar rutas de salida y log
$OutputPath = Test-AndCreatePath -Path $OutputPath
$LogPath = Test-AndCreatePath -Path $LogPath

# Prueba real de escritura en OutputPath
if (-not (Test-WriteAccess -Path $OutputPath)) {
    Write-Warning "No se pudo escribir en '$OutputPath'. Se usará Documentos."
    Write-Log "No se pudo escribir en '$OutputPath'. Se usará Documentos." "WARN"
    $OutputPath = [Environment]::GetFolderPath("MyDocuments")
}

# ----------------------------
# Variables CSV y error log
# ----------------------------
$csv = Join-Path $OutputPath "$env:COMPUTERNAME-Inventory.csv"

# ----------------------------
# Recolectar datos del sistema
# ----------------------------
Write-Verbose "Obteniendo datos del sistema..."
Write-Log "Obteniendo datos del sistema..." "INFO"

$Date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$Username = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

# BIOS
$bios = Get-CimInstance Win32_BIOS
$BIOS = "$($bios.Manufacturer), $($bios.SMBIOSBIOSVersion), $($bios.Name)"
$SN = $bios.SerialNumber

# Sistema y CPU
$sys = Get-CimInstance Win32_ComputerSystem
$Model = $sys.Model
$ChassisTypes = (Get-CimInstance Win32_SystemEnclosure).ChassisTypes
$CPU = (Get-CimInstance Win32_Processor).Name
$RAM = [math]::Round((Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB,2)

# Disco
$Storage = [math]::Round((Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='$env:SystemDrive'").Size / 1GB,2)

# GPU
$GPUs = Get-CimInstance Win32_VideoController | Select-Object -ExpandProperty Description
$GPU0 = $GPUs[0]
$GPU1 = $GPUs[1]

# OS y uptime
$OS = Get-CimInstance Win32_OperatingSystem
$OSBuild = (Get-Item "HKLM:SOFTWARE\Microsoft\Windows NT\CurrentVersion").GetValue('ReleaseID')
$uptime = (Get-Date) - $OS.LastBootUpTime
$uptimeReadable = "{0} days, {1} hours, {2} minutes" -f $uptime.Days,$uptime.Hours,$uptime.Minutes

# IP y MAC
$defaultRoute = Get-NetRoute -DestinationPrefix "0.0.0.0/0" | Sort-Object Metric | Select-Object -First 1
$interfaceIndex = $defaultRoute.InterfaceIndex
$interfaceIP = (Get-NetIPAddress -InterfaceIndex $interfaceIndex | Where-Object { $_.AddressFamily -eq "IPv4" }).IPAddress
$interfaceMAC = (Get-NetAdapter -InterfaceIndex $interfaceIndex).MacAddress

# Monitores (evitar errores si no hay datos)
function Get-Monitors {
    $Monitors = Get-CimInstance -Namespace root\wmi -Class WMIMonitorID -ErrorAction SilentlyContinue
    if ($Monitors) {
        $data = @()
        foreach ($m in $Monitors) {
            $man = ([System.Text.Encoding]::ASCII.GetString($m.ManufacturerName)).Trim([char]0)
            $name = ([System.Text.Encoding]::ASCII.GetString($m.UserFriendlyName)).Trim([char]0)
            $sn = ([System.Text.Encoding]::ASCII.GetString($m.SerialNumberID)).Trim([char]0)
            $data += [PSCustomObject]@{Name=$name; Manufacturer=$man; Serial=$sn}
        }
        return $data
    } else { return @() }
}
$monitors = Get-Monitors

# Installed apps (opcional)
$checkInstalledApps = 0
if ($checkInstalledApps -eq 1) {
    $installedApps = Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" -ErrorAction SilentlyContinue |
                     Select-Object -ExpandProperty DisplayName
    $appsList = ($installedApps | Where-Object { $_ -ne $null }) -join "`n "
} else { $appsList = "N/A" }

# ----------------------------
# Exportar CSV
# ----------------------------
Write-Verbose "Exportando CSV..."
Write-Log "Exportando CSV..." "INFO"

$info = [PSCustomObject]@{
    "Date Collected" = $Date
    "Hostname"       = $env:COMPUTERNAME
    "IP Address"     = $interfaceIP
    "MAC Address"    = $interfaceMAC
    "User"           = $Username
    "Type"           = ($ChassisTypes | ForEach-Object { switch ($_){ 3{"Desktop"} 9{"Laptop"} default{"Other"} } }) -join ', '
    "Serial Number/Service Tag" = $SN
    "Model"          = $Model
    "BIOS"           = $BIOS
    "CPU"            = $CPU
    "RAM (GB)"       = $RAM
    "Storage (GB)"   = $Storage
    "GPU 0"          = $GPU0
    "GPU 1"          = $GPU1
    "OS"             = $OS.Caption
    "OS Version"     = $OS.BuildNumber
    "OS Build"       = $OSBuild
    "Up time"        = $uptimeReadable
    "Installed Apps" = $appsList
    "Monitors"       = ($monitors | ForEach-Object { "$($_.Manufacturer) $($_.Name) SN:$($_.Serial)" }) -join " | "
}

# Crear CSV si no existe
if (-not (Test-Path $csv)) { New-Item -ItemType File -Path $csv -Force | Out-Null }

try {
    $info | Export-Csv -Path $csv -NoTypeInformation -Force
    Write-Host "Inventario generado correctamente en $csv"
    Write-Log "Inventario generado correctamente en $csv" "INFO"
}
catch {
    Write-Warning "No se pudo exportar CSV. Se revisará log."
    Write-Log "No se pudo exportar CSV. Error: $_" "ERROR"
}
