<#
.SYNOPSIS
    Backup Module - Configuration Backup & Restore System
    
.DESCRIPTION
    Moduł zawierający system backupów i restore dla MSI Claw Optimizer v5.0
    
    Bazowane na v4.0 Professional Edition z poprawkami bezpieczeństwa:
    - No Invoke-Expression (używa reg.exe przez Start-Process)
    - Proper error handling
    - Compression support
    - Metadata tracking
#>

# ════════════════════════════════════════════════════════════════════════════════
# BACKUP CONFIGURATION
# ════════════════════════════════════════════════════════════════════════════════

function New-SystemBackup {
    <#
    .SYNOPSIS
        Tworzy kompleksowy backup konfiguracji systemu
    .PARAMETER Description
        Opis backupu
    .PARAMETER IncludeDrivers
        Czy dołączyć listę sterowników
    .PARAMETER Compress
        Czy skompresować backup do ZIP
    .OUTPUTS
        [string] ID utworzonego backupu
    #>
    param(
        [Parameter(Mandatory = $false)]
        [string]$Description = "Manual backup",
        
        [Parameter(Mandatory = $false)]
        [switch]$IncludeDrivers,
        
        [Parameter(Mandatory = $false)]
        [switch]$Compress = $true
    )
    
    Write-Host "`n[BACKUP] Tworzenie backupu konfiguracji..." -ForegroundColor Cyan
    
    # Generuj ID backupu (timestamp-based)
    $backupId = "Backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    
    # Ścieżka backupu
    $backupRoot = Join-Path $env:USERPROFILE 'MSI_Claw_Backups'
    if (-not (Test-Path $backupRoot)) {
        New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
    }
    
    $backupPath = Join-Path $backupRoot $backupId
    New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
    
    try {
        # Metadata
        $metadata = @{
            BackupId = $backupId
            Timestamp = (Get-Date).ToString('o')
            Description = $Description
            User = "$env:USERDOMAIN\$env:USERNAME"
            Computer = $env:COMPUTERNAME
            ScriptVersion = '5.0.0'
            Items = @()
        }
        
        # 1. Backup rejestru
        Write-Host "  [1/5] Backup rejestru..." -ForegroundColor Gray
        
        $regBackupPath = Join-Path $backupPath "Registry"
        New-Item -ItemType Directory -Path $regBackupPath -Force | Out-Null
        
        # Kluczowe ścieżki rejestru do backupu
        $regPaths = @(
            @{ Name = "DeviceGuard"; Path = "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" },
            @{ Name = "GraphicsDrivers"; Path = "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" },
            @{ Name = "Power"; Path = "HKLM\SYSTEM\CurrentControlSet\Control\Power" },
            @{ Name = "GameConfigStore"; Path = "HKCU\System\GameConfigStore" },
            @{ Name = "DataCollection"; Path = "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" },
            @{ Name = "VisualEffects"; Path = "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" }
        )
        
        foreach ($regItem in $regPaths) {
            try {
                $outputFile = Join-Path $regBackupPath "$($regItem.Name).reg"
                
                # Użyj Start-Process zamiast Invoke-Expression
                $procArgs = @('export', $regItem.Path, $outputFile, '/y')
                $process = Start-Process -FilePath 'reg.exe' -ArgumentList $procArgs -NoNewWindow -Wait -PassThru
                
                if ($process.ExitCode -eq 0) {
                    Write-Host "    ✓ $($regItem.Name)" -ForegroundColor Green
                    $metadata.Items += "Registry: $($regItem.Name)"
                }
                else {
                    Write-Host "    ! $($regItem.Name) - nie istnieje lub błąd" -ForegroundColor Yellow
                }
            }
            catch {
                Write-Host "    ✗ Błąd backupu $($regItem.Name): $_" -ForegroundColor Red
            }
        }
        
        # 2. Backup konfiguracji zasilania
        Write-Host "  [2/5] Backup konfiguracji zasilania..." -ForegroundColor Gray
        
        try {
            $powerPath = Join-Path $backupPath "PowerConfiguration.txt"
            
            # Pobierz pełną konfigurację zasilania
            $powerConfig = powercfg /query SCHEME_CURRENT 2>&1
            $powerConfig | Out-File -FilePath $powerPath -Encoding UTF8
            
            Write-Host "    ✓ Konfiguracja zasilania" -ForegroundColor Green
            $metadata.Items += "Power Configuration"
        }
        catch {
            Write-Host "    ✗ Błąd backupu zasilania: $_" -ForegroundColor Red
        }
        
        # 3. Backup informacji o usługach
        Write-Host "  [3/5] Backup stanu usług..." -ForegroundColor Gray
        
        try {
            $servicesPath = Join-Path $backupPath "Services.txt"
            
            # Lista kluczowych usług
            $services = @('WSearch', 'SysMain', 'Winmgmt', 'Power', 'PlugPlay')
            $serviceInfo = foreach ($svc in $services) {
                try {
                    Get-Service -Name $svc -ErrorAction SilentlyContinue | 
                        Select-Object Name, DisplayName, Status, StartType
                }
                catch {
                    # Service nie istnieje
                }
            }
            
            $serviceInfo | Out-File -FilePath $servicesPath -Encoding UTF8
            
            Write-Host "    ✓ Stan usług systemowych" -ForegroundColor Green
            $metadata.Items += "Services Status"
        }
        catch {
            Write-Host "    ✗ Błąd backupu usług: $_" -ForegroundColor Red
        }
        
        # 4. Backup informacji o systemie
        Write-Host "  [4/5] Backup informacji o systemie..." -ForegroundColor Gray
        
        try {
            $sysInfoPath = Join-Path $backupPath "SystemInfo.txt"
            
            $sysInfo = @"
System Information Backup
Generated: $(Get-Date)

=== Operating System ===
$(systeminfo | Select-String "OS Name", "OS Version", "System Type")

=== BIOS ===
$((Get-CimInstance -ClassName Win32_BIOS | Select-Object Manufacturer, SMBIOSBIOSVersion, ReleaseDate | Format-List | Out-String).Trim())

=== CPU ===
$((Get-CimInstance -ClassName Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors | Format-List | Out-String).Trim())

=== GPU ===
$((Get-CimInstance -ClassName Win32_VideoController | Select-Object Name, DriverVersion, DriverDate | Format-List | Out-String).Trim())

=== Memory ===
Total RAM: $([math]::Round((Get-CimInstance -ClassName Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)) GB
"@
            
            $sysInfo | Out-File -FilePath $sysInfoPath -Encoding UTF8
            
            Write-Host "    ✓ Informacje systemowe" -ForegroundColor Green
            $metadata.Items += "System Information"
        }
        catch {
            Write-Host "    ✗ Błąd backupu informacji systemowych: $_" -ForegroundColor Red
        }
        
        # 5. Backup listy sterowników (opcjonalne)
        if ($IncludeDrivers) {
            Write-Host "  [5/5] Backup listy sterowników..." -ForegroundColor Gray
            
            try {
                $driversPath = Join-Path $backupPath "Drivers.txt"
                
                Get-CimInstance -ClassName Win32_PnPSignedDriver |
                    Select-Object DeviceName, DriverVersion, DriverDate, Manufacturer |
                    Out-File -FilePath $driversPath -Encoding UTF8
                
                Write-Host "    ✓ Lista sterowników" -ForegroundColor Green
                $metadata.Items += "Drivers List"
            }
            catch {
                Write-Host "    ✗ Błąd backupu sterowników: $_" -ForegroundColor Red
            }
        }
        else {
            Write-Host "  [5/5] Pomijanie listy sterowników..." -ForegroundColor Gray
        }
        
        # 6. Zapisz metadane
        Write-Host "  Zapisywanie metadanych..." -ForegroundColor Gray
        
        $metadataPath = Join-Path $backupPath "metadata.json"
        $metadata | ConvertTo-Json -Depth 10 | Out-File -FilePath $metadataPath -Encoding UTF8
        
        # 7. Kompresja (jeśli włączona)
        if ($Compress) {
            Write-Host "  Kompresja backupu..." -ForegroundColor Gray
            
            try {
                $zipPath = "$backupPath.zip"
                Compress-Archive -Path $backupPath -DestinationPath $zipPath -Force
                Remove-Item -Path $backupPath -Recurse -Force
                
                Write-Host "    ✓ Backup skompresowany" -ForegroundColor Green
            }
            catch {
                Write-Host "    ! Nie udało się skompresować (backup pozostawiony nieskompresowany)" -ForegroundColor Yellow
            }
        }
        
        Write-Host "`n[BACKUP] Backup utworzony: $backupId" -ForegroundColor Green
        Write-Host "  Lokalizacja: $backupRoot\$backupId" -ForegroundColor Cyan
        Write-Host "  Elementy: $($metadata.Items.Count)" -ForegroundColor Cyan
        
        # Usuń stare backupy (zachowaj max 10)
        Remove-OldBackups -BackupRoot $backupRoot -MaxBackups 10
        
        return $backupId
    }
    catch {
        Write-Host "`n[BŁĄD] Nie udało się utworzyć backupu: $_" -ForegroundColor Red
        
        # Cleanup na błąd
        if (Test-Path $backupPath) {
            Remove-Item -Path $backupPath -Recurse -Force -ErrorAction SilentlyContinue
        }
        
        throw
    }
}

# ════════════════════════════════════════════════════════════════════════════════
# RESTORE FUNCTIONALITY
# ════════════════════════════════════════════════════════════════════════════════

function Restore-SystemBackup {
    <#
    .SYNOPSIS
        Przywraca konfigurację z backupu
    .PARAMETER BackupId
        ID backupu do przywrócenia (opcjonalne - jeśli nie podano, pokaże listę)
    .PARAMETER Force
        Pomija potwierdzenie
    .OUTPUTS
        [bool] Czy restore się powiódł
    #>
    param(
        [Parameter(Mandatory = $false)]
        [string]$BackupId,
        
        [Parameter(Mandatory = $false)]
        [switch]$Force
    )
    
    $backupRoot = Join-Path $env:USERPROFILE 'MSI_Claw_Backups'
    
    if (-not (Test-Path $backupRoot)) {
        Write-Host "`n[BŁĄD] Brak dostępnych backupów" -ForegroundColor Red
        return $false
    }
    
    try {
        # Jeśli nie podano ID, pokaż listę
        if (-not $BackupId) {
            $backups = Get-BackupList -BackupRoot $backupRoot
            
            if ($backups.Count -eq 0) {
                Write-Host "`n[BŁĄD] Brak dostępnych backupów" -ForegroundColor Red
                return $false
            }
            
            Write-Host "`n════════════════════════════════════════════════════════════════════" -ForegroundColor Yellow
            Write-Host "  DOSTĘPNE BACKUPY" -ForegroundColor Yellow
            Write-Host "════════════════════════════════════════════════════════════════════" -ForegroundColor Yellow
            Write-Host ""
            
            for ($i = 0; $i -lt $backups.Count; $i++) {
                Write-Host "[$($i+1)] $($backups[$i].Name)" -ForegroundColor Cyan
                Write-Host "    Data: $($backups[$i].Timestamp)" -ForegroundColor Gray
                Write-Host "    Opis: $($backups[$i].Description)" -ForegroundColor Gray
                Write-Host "    Elementy: $($backups[$i].Items.Count)" -ForegroundColor Gray
                Write-Host ""
            }
            
            $selection = Read-Host "Wybierz backup do przywrócenia (1-$($backups.Count)) lub 0 aby anulować"
            
            if ($selection -eq '0' -or [int]$selection -lt 1 -or [int]$selection -gt $backups.Count) {
                Write-Host "Operacja anulowana" -ForegroundColor Yellow
                return $false
            }
            
            $BackupId = $backups[[int]$selection - 1].BackupId
        }
        
        # Znajdź backup
        $backupPath = Join-Path $backupRoot $BackupId
        $zipPath = "$backupPath.zip"
        
        # Sprawdź czy istnieje
        if (Test-Path $zipPath) {
            Write-Host "`n[RESTORE] Rozpakowywanie backupu..." -ForegroundColor Cyan
            Expand-Archive -Path $zipPath -DestinationPath $backupPath -Force
        }
        elseif (-not (Test-Path $backupPath)) {
            throw "Backup nie istnieje: $BackupId"
        }
        
        # Wczytaj metadane
        $metadataPath = Join-Path $backupPath "metadata.json"
        if (-not (Test-Path $metadataPath)) {
            throw "Brak metadanych backupu"
        }
        
        $metadata = Get-Content $metadataPath | ConvertFrom-Json
        
        Write-Host "`n════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
        Write-Host "  PRZYWRACANIE BACKUPU" -ForegroundColor Cyan
        Write-Host "════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
        Write-Host "  ID: $BackupId" -ForegroundColor White
        Write-Host "  Data: $($metadata.Timestamp)" -ForegroundColor White
        Write-Host "  Opis: $($metadata.Description)" -ForegroundColor White
        Write-Host "════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
        Write-Host ""
        
        # Potwierdzenie
        if (-not $Force) {
            Write-Host "⚠ To nadpisze obecną konfigurację!" -ForegroundColor Yellow
            $confirm = Read-Host "Czy na pewno chcesz kontynuować? (T/N)"
            
            if ($confirm -ne 'T' -and $confirm -ne 't') {
                Write-Host "Operacja anulowana" -ForegroundColor Yellow
                return $false
            }
        }
        
        # Przywróć rejestr
        Write-Host "`n[RESTORE] Przywracanie rejestru..." -ForegroundColor Cyan
        
        $regBackupPath = Join-Path $backupPath "Registry"
        if (Test-Path $regBackupPath) {
            $regFiles = Get-ChildItem -Path $regBackupPath -Filter "*.reg"
            
            foreach ($regFile in $regFiles) {
                try {
                    Write-Host "  Importowanie: $($regFile.BaseName)..." -ForegroundColor Gray
                    
                    # Użyj Start-Process zamiast Invoke-Expression
                    $procArgs = @('import', $regFile.FullName)
                    $process = Start-Process -FilePath 'reg.exe' -ArgumentList $procArgs -NoNewWindow -Wait -PassThru
                    
                    if ($process.ExitCode -eq 0) {
                        Write-Host "    ✓ $($regFile.BaseName)" -ForegroundColor Green
                    }
                    else {
                        Write-Host "    ✗ Błąd importu $($regFile.BaseName)" -ForegroundColor Red
                    }
                }
                catch {
                    Write-Host "    ✗ Błąd: $_" -ForegroundColor Red
                }
            }
        }
        
        Write-Host "`n[RESTORE] Backup przywrócony pomyślnie!" -ForegroundColor Green
        Write-Host "⚠ RESTART SYSTEMU WYMAGANY aby zmiany weszły w życie!" -ForegroundColor Yellow
        
        # Zapytaj o restart
        Write-Host ""
        $restart = Read-Host "Czy chcesz uruchomić ponownie komputer teraz? (T/N)"
        
        if ($restart -eq 'T' -or $restart -eq 't') {
            Write-Host "Restartowanie systemu..." -ForegroundColor Yellow
            Start-Sleep -Seconds 3
            Restart-Computer -Force
        }
        
        return $true
    }
    catch {
        Write-Host "`n[BŁĄD] Nie udało się przywrócić backupu: $_" -ForegroundColor Red
        return $false
    }
    finally {
        # Cleanup rozpakowanego backupu jeśli był ZIP
        if ((Test-Path $zipPath) -and (Test-Path $backupPath)) {
            Remove-Item -Path $backupPath -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

# ════════════════════════════════════════════════════════════════════════════════
# BACKUP MANAGEMENT
# ════════════════════════════════════════════════════════════════════════════════

function Get-BackupList {
    <#
    .SYNOPSIS
        Pobiera listę dostępnych backupów
    .PARAMETER BackupRoot
        Ścieżka katalogu z backupami
    .OUTPUTS
        [array] Lista backupów z metadanymi
    #>
    param(
        [Parameter(Mandatory = $false)]
        [string]$BackupRoot = (Join-Path $env:USERPROFILE 'MSI_Claw_Backups')
    )
    
    if (-not (Test-Path $BackupRoot)) {
        return @()
    }
    
    $backups = @()
    
    # Szukaj katalogów i ZIPów
    $items = Get-ChildItem -Path $BackupRoot | Where-Object { 
        $_.PSIsContainer -or ($_.Extension -eq '.zip' -and $_.BaseName -match '^Backup_\d{8}_\d{6}$')
    }
    
    foreach ($item in $items) {
        try {
            $backupId = if ($item.PSIsContainer) { $item.Name } else { $item.BaseName }
            $metadataPath = if ($item.PSIsContainer) {
                Join-Path $item.FullName "metadata.json"
            }
            else {
                # Rozpakuj tymczasowo tylko metadata
                $tempPath = Join-Path $env:TEMP "temp_metadata_$backupId"
                Expand-Archive -Path $item.FullName -DestinationPath $tempPath -Force
                $metaPath = Join-Path $tempPath "metadata.json"
                
                if (Test-Path $metaPath) {
                    $metadata = Get-Content $metaPath | ConvertFrom-Json
                    Remove-Item -Path $tempPath -Recurse -Force
                    
                    $backups += $metadata
                }
                
                continue
            }
            
            if (Test-Path $metadataPath) {
                $metadata = Get-Content $metadataPath | ConvertFrom-Json
                $backups += $metadata
            }
        }
        catch {
            # Pomiń nieprawidłowe backupy
        }
    }
    
    return $backups | Sort-Object Timestamp -Descending
}

function Remove-OldBackups {
    <#
    .SYNOPSIS
        Usuwa stare backupy zachowując tylko najnowsze
    .PARAMETER BackupRoot
        Ścieżka katalogu z backupami
    .PARAMETER MaxBackups
        Maksymalna liczba backupów do zachowania
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$BackupRoot,
        
        [Parameter(Mandatory = $false)]
        [int]$MaxBackups = 10
    )
    
    if (-not (Test-Path $BackupRoot)) {
        return
    }
    
    try {
        $backups = Get-ChildItem -Path $BackupRoot | Where-Object {
            $_.PSIsContainer -or ($_.Extension -eq '.zip')
        } | Sort-Object CreationTime -Descending
        
        if ($backups.Count -gt $MaxBackups) {
            $toRemove = $backups | Select-Object -Skip $MaxBackups
            
            Write-Host "  Usuwanie $($toRemove.Count) starych backupów..." -ForegroundColor Gray
            
            foreach ($backup in $toRemove) {
                Remove-Item -Path $backup.FullName -Recurse -Force
                Write-Host "    ✓ Usunięto: $($backup.Name)" -ForegroundColor DarkGray
            }
        }
    }
    catch {
        Write-Host "    ! Nie udało się wyczyścić starych backupów: $_" -ForegroundColor Yellow
    }
}

function Export-BackupReport {
    <#
    .SYNOPSIS
        Eksportuje raport wszystkich backupów do pliku
    .PARAMETER OutputPath
        Ścieżka do pliku wyjściowego (opcjonalne)
    .OUTPUTS
        [string] Ścieżka do wygenerowanego raportu
    #>
    param(
        [Parameter(Mandatory = $false)]
        [string]$OutputPath
    )
    
    $backupRoot = Join-Path $env:USERPROFILE 'MSI_Claw_Backups'
    
    if (-not $OutputPath) {
        $OutputPath = Join-Path $backupRoot "Backup_Report_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
    }
    
    $backups = Get-BackupList -BackupRoot $backupRoot
    
    $report = @"
MSI Claw Optimizer - Backup Report
Generated: $(Get-Date)

Total Backups: $($backups.Count)
Location: $backupRoot

════════════════════════════════════════════════════════════════════

"@
    
    foreach ($backup in $backups) {
        $report += @"
Backup ID: $($backup.BackupId)
Timestamp: $($backup.Timestamp)
Description: $($backup.Description)
User: $($backup.User)
Computer: $($backup.Computer)
Script Version: $($backup.ScriptVersion)
Items Backed Up:
$($backup.Items | ForEach-Object { "  - $_" } | Out-String)
────────────────────────────────────────────────────────────────────

"@
    }
    
    $report | Out-File -FilePath $OutputPath -Encoding UTF8
    
    Write-Host "`n[RAPORT] Raport backupów wygenerowany:" -ForegroundColor Green
    Write-Host "  $OutputPath" -ForegroundColor Cyan
    
    return $OutputPath
}

# Export functions
Export-ModuleMember -Function @(
    'New-SystemBackup',
    'Restore-SystemBackup',
    'Get-BackupList',
    'Remove-OldBackups',
    'Export-BackupReport'
)
