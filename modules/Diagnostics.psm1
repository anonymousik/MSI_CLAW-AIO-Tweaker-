<#
.SYNOPSIS
    Diagnostics Module - Auto-diagnostyka i samo-naprawa
    
.DESCRIPTION
    Moduł zawierający funkcje diagnostyczne i auto-repair dla MSI Claw Optimizer
#>

# ════════════════════════════════════════════════════════════════════════════════
# DIAGNOSTIC CHECKS
# ════════════════════════════════════════════════════════════════════════════════

function Start-SelfDiagnostics {
    <#
    .SYNOPSIS
        Przeprowadza kompleksową auto-diagnostykę systemu
    .OUTPUTS
        [hashtable] Wyniki diagnostyki z flagą IssuesFound
    #>
    
    Write-Host "`n[DIAGNOSTYKA] Rozpoczynam auto-diagnostykę systemu..." -ForegroundColor Cyan
    
    $results = @{
        Timestamp = Get-Date
        IssuesFound = $false
        Checks = @{}
        Recommendations = @()
    }
    
    # Check 1: Hardware Detection
    $results.Checks.Hardware = Test-HardwareCompatibility
    if (-not $results.Checks.Hardware.IsCompatible) {
        $results.IssuesFound = $true
        $results.Recommendations += "Urządzenie może nie być w pełni kompatybilne z optymalizacjami"
    }
    
    # Check 2: BIOS Version
    $results.Checks.BIOS = Test-BIOSVersion
    if ($results.Checks.BIOS.NeedsUpdate) {
        $results.IssuesFound = $true
        $results.Recommendations += "Zaktualizuj BIOS do wersji $($results.Checks.BIOS.RecommendedVersion)"
    }
    
    # Check 3: Drivers
    $results.Checks.Drivers = Test-DriverVersions
    if ($results.Checks.Drivers.OutdatedDrivers.Count -gt 0) {
        $results.IssuesFound = $true
        $results.Recommendations += "Zaktualizuj sterowniki: $($results.Checks.Drivers.OutdatedDrivers -join ', ')"
    }
    
    # Check 4: Windows Configuration
    $results.Checks.WindowsConfig = Test-WindowsConfiguration
    if ($results.Checks.WindowsConfig.IssuesFound) {
        $results.IssuesFound = $true
        foreach ($issue in $results.Checks.WindowsConfig.Issues) {
            $results.Recommendations += $issue
        }
    }
    
    # Check 5: Services
    $results.Checks.Services = Test-RequiredServices
    if (-not $results.Checks.Services.AllRunning) {
        $results.IssuesFound = $true
        $results.Recommendations += "Niektóre wymagane usługi nie działają"
    }
    
    # Check 6: Disk Health
    $results.Checks.DiskHealth = Test-DiskHealth
    if ($results.Checks.DiskHealth.WarningLevel -gt 0) {
        $results.IssuesFound = $true
        $results.Recommendations += $results.Checks.DiskHealth.Message
    }
    
    # Summary
    Write-Host "`n[DIAGNOSTYKA] Zakończono. Znalezione problemy: $($results.IssuesFound)" -ForegroundColor $(if ($results.IssuesFound) { 'Yellow' } else { 'Green' })
    
    if ($results.Recommendations.Count -gt 0) {
        Write-Host "`nRekomendacje:" -ForegroundColor Yellow
        $results.Recommendations | ForEach-Object { Write-Host "  • $_" -ForegroundColor Yellow }
    }
    
    return $results
}

function Test-HardwareCompatibility {
    <#
    .SYNOPSIS
        Sprawdza kompatybilność sprzętu
    #>
    
    Write-Host "  [✓] Sprawdzanie sprzętu..." -ForegroundColor Gray
    
    try {
        $cpu = Get-CimInstance -ClassName Win32_Processor -ErrorAction Stop
        $gpu = Get-CimInstance -ClassName Win32_VideoController -ErrorAction Stop | Where-Object { $_.Name -notmatch 'Basic|Microsoft' } | Select-Object -First 1
        $manufacturer = (Get-CimInstance -ClassName Win32_ComputerSystem -ErrorAction Stop).Manufacturer
        
        $result = @{
            CPU = $cpu.Name
            GPU = $gpu.Name
            Manufacturer = $manufacturer
            IsCompatible = $false
            CompatibilityLevel = 'Unknown'
        }
        
        # MSI Claw detection
        if ($manufacturer -match 'MSI|Micro-Star') {
            if ($cpu.Name -match 'Core Ultra.*(135H|155H)' -and $gpu.Name -match 'Intel.*Arc') {
                $result.IsCompatible = $true
                $result.CompatibilityLevel = 'FullySupported'
                Write-Host "    ✓ MSI Claw A1M wykryty - Pełne wsparcie" -ForegroundColor Green
            }
            elseif ($cpu.Name -match 'Lunar Lake' -and $gpu.Name -match 'Intel.*Arc') {
                $result.IsCompatible = $true
                $result.CompatibilityLevel = 'FullySupported'
                Write-Host "    ✓ MSI Claw 8 AI+ wykryty - Pełne wsparcie" -ForegroundColor Green
            }
        }
        elseif ($gpu.Name -match 'Intel.*Arc') {
            $result.IsCompatible = $true
            $result.CompatibilityLevel = 'Partial'
            Write-Host "    ! Intel Arc wykryty - Częściowe wsparcie" -ForegroundColor Yellow
        }
        else {
            $result.IsCompatible = $false
            $result.CompatibilityLevel = 'NotSupported'
            Write-Host "    ! Niewspierane urządzenie" -ForegroundColor Red
        }
        
        return $result
    }
    catch {
        Write-Host "    ✗ Błąd sprawdzania sprzętu: $_" -ForegroundColor Red
        return @{ IsCompatible = $false; Error = $_.Exception.Message }
    }
}

function Test-BIOSVersion {
    <#
    .SYNOPSIS
        Sprawdza wersję BIOS
    #>
    
    Write-Host "  [✓] Sprawdzanie BIOS..." -ForegroundColor Gray
    
    try {
        $bios = Get-CimInstance -ClassName Win32_BIOS -ErrorAction Stop
        $biosVersion = $bios.SMBIOSBIOSVersion
        
        # Extract numeric version (e.g., "E1T41IMS.109" -> 109)
        $versionNumber = 0
        if ($biosVersion -match '\.(\d+)$') {
            $versionNumber = [int]$Matches[1]
        }
        
        $result = @{
            Version = $biosVersion
            VersionNumber = $versionNumber
            Manufacturer = $bios.Manufacturer
            ReleaseDate = $bios.ReleaseDate
            NeedsUpdate = $false
            RecommendedVersion = 109
        }
        
        if ($versionNumber -lt 106) {
            $result.NeedsUpdate = $true
            Write-Host "    ! BIOS $biosVersion - Krytyczna aktualizacja wymagana!" -ForegroundColor Red
        }
        elseif ($versionNumber -lt 109) {
            $result.NeedsUpdate = $true
            Write-Host "    ! BIOS $biosVersion - Zalecana aktualizacja do 109" -ForegroundColor Yellow
        }
        else {
            Write-Host "    ✓ BIOS $biosVersion - Aktualna wersja" -ForegroundColor Green
        }
        
        return $result
    }
    catch {
        Write-Host "    ✗ Błąd sprawdzania BIOS: $_" -ForegroundColor Red
        return @{ NeedsUpdate = $false; Error = $_.Exception.Message }
    }
}

function Test-DriverVersions {
    <#
    .SYNOPSIS
        Sprawdza wersje sterowników
    #>
    
    Write-Host "  [✓] Sprawdzanie sterowników..." -ForegroundColor Gray
    
    try {
        $gpu = Get-CimInstance -ClassName Win32_VideoController -ErrorAction Stop | Where-Object { $_.Name -match 'Intel.*Arc' }
        
        $result = @{
            OutdatedDrivers = @()
            CurrentDrivers = @{}
        }
        
        if ($gpu) {
            $driverVersion = $gpu.DriverVersion
            $result.CurrentDrivers.IntelArc = $driverVersion
            
            # Expected format: 32.0.101.6877
            if ($driverVersion -match '^(\d+)\.(\d+)\.(\d+)\.(\d+)$') {
                $major = [int]$Matches[1]
                $build = [int]$Matches[4]
                
                if ($major -lt 32 -or ($major -eq 32 -and $build -lt 6877)) {
                    $result.OutdatedDrivers += 'Intel Arc Graphics'
                    Write-Host "    ! Intel Arc $driverVersion - Zalecana aktualizacja do 32.0.101.6877+" -ForegroundColor Yellow
                }
                else {
                    Write-Host "    ✓ Intel Arc $driverVersion - Aktualna wersja" -ForegroundColor Green
                }
            }
        }
        
        return $result
    }
    catch {
        Write-Host "    ✗ Błąd sprawdzania sterowników: $_" -ForegroundColor Red
        return @{ OutdatedDrivers = @(); Error = $_.Exception.Message }
    }
}

function Test-WindowsConfiguration {
    <#
    .SYNOPSIS
        Sprawdza konfigurację Windows
    #>
    
    Write-Host "  [✓] Sprawdzanie konfiguracji Windows..." -ForegroundColor Gray
    
    $result = @{
        IssuesFound = $false
        Issues = @()
        Config = @{}
    }
    
    try {
        # 1. Memory Integrity (Core Isolation)
        $memIntegrityPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity'
        if (Test-Path $memIntegrityPath) {
            $memIntegrity = (Get-ItemProperty -Path $memIntegrityPath -Name 'Enabled' -ErrorAction SilentlyContinue).Enabled
            $result.Config.MemoryIntegrity = $memIntegrity
            
            if ($memIntegrity -eq 1) {
                $result.IssuesFound = $true
                $result.Issues += "Memory Integrity jest włączona (spadek FPS 15-25%)"
            }
        }
        
        # 2. Virtual Machine Platform
        $vmpFeature = Get-WindowsOptionalFeature -Online -FeatureName 'VirtualMachinePlatform' -ErrorAction SilentlyContinue
        if ($vmpFeature -and $vmpFeature.State -eq 'Enabled') {
            $result.Config.VirtualMachinePlatform = $true
            $result.IssuesFound = $true
            $result.Issues += "Virtual Machine Platform jest włączona (overhead wydajnościowy)"
        }
        else {
            $result.Config.VirtualMachinePlatform = $false
        }
        
        # 3. Game DVR
        $gameDVRPath = 'HKCU:\System\GameConfigStore'
        if (Test-Path $gameDVRPath) {
            $gameDVR = (Get-ItemProperty -Path $gameDVRPath -Name 'GameDVR_Enabled' -ErrorAction SilentlyContinue).GameDVR_Enabled
            $result.Config.GameDVR = $gameDVR
            
            if ($gameDVR -eq 1) {
                $result.IssuesFound = $true
                $result.Issues += "Game DVR jest włączony"
            }
        }
        
        # 4. Hardware Accelerated GPU Scheduling
        $hwSchedulingPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers'
        $hwScheduling = (Get-ItemProperty -Path $hwSchedulingPath -Name 'HwSchMode' -ErrorAction SilentlyContinue).HwSchMode
        $result.Config.HardwareScheduling = $hwScheduling
        
        if ($hwScheduling -ne 2) {
            $result.IssuesFound = $true
            $result.Issues += "Hardware Accelerated GPU Scheduling jest wyłączony"
        }
        
        if ($result.IssuesFound) {
            Write-Host "    ! Znaleziono problemy konfiguracyjne ($($result.Issues.Count))" -ForegroundColor Yellow
        }
        else {
            Write-Host "    ✓ Konfiguracja Windows optymalna" -ForegroundColor Green
        }
        
        return $result
    }
    catch {
        Write-Host "    ✗ Błąd sprawdzania konfiguracji: $_" -ForegroundColor Red
        return @{ IssuesFound = $false; Error = $_.Exception.Message }
    }
}

function Test-RequiredServices {
    <#
    .SYNOPSIS
        Sprawdza wymagane usługi systemowe
    #>
    
    Write-Host "  [✓] Sprawdzanie usług..." -ForegroundColor Gray
    
    $requiredServices = @(
        'Winmgmt',  # WMI
        'Power',    # Power Service
        'PlugPlay'  # Plug and Play
    )
    
    $result = @{
        AllRunning = $true
        Services = @{}
    }
    
    foreach ($serviceName in $requiredServices) {
        try {
            $service = Get-Service -Name $serviceName -ErrorAction Stop
            $result.Services[$serviceName] = $service.Status
            
            if ($service.Status -ne 'Running') {
                $result.AllRunning = $false
                Write-Host "    ! Usługa $serviceName nie działa" -ForegroundColor Yellow
            }
        }
        catch {
            $result.AllRunning = $false
            $result.Services[$serviceName] = 'NotFound'
            Write-Host "    ✗ Usługa $serviceName nie znaleziona" -ForegroundColor Red
        }
    }
    
    if ($result.AllRunning) {
        Write-Host "    ✓ Wszystkie wymagane usługi działają" -ForegroundColor Green
    }
    
    return $result
}

function Test-DiskHealth {
    <#
    .SYNOPSIS
        Sprawdza stan dysku
    #>
    
    Write-Host "  [✓] Sprawdzanie dysku..." -ForegroundColor Gray
    
    $result = @{
        WarningLevel = 0
        Message = ''
        Details = @{}
    }
    
    try {
        $systemDrive = $env:SystemDrive.TrimEnd(':')
        $drive = Get-PSDrive -Name $systemDrive -ErrorAction Stop
        
        $freeSpaceGB = [math]::Round($drive.Free / 1GB, 2)
        $totalSpaceGB = [math]::Round(($drive.Used + $drive.Free) / 1GB, 2)
        $freePercent = [math]::Round(($drive.Free / ($drive.Used + $drive.Free)) * 100, 1)
        
        $result.Details.FreeSpaceGB = $freeSpaceGB
        $result.Details.TotalSpaceGB = $totalSpaceGB
        $result.Details.FreePercent = $freePercent
        
        if ($freePercent -lt 10) {
            $result.WarningLevel = 2
            $result.Message = "Krytycznie mało miejsca na dysku: ${freeSpaceGB}GB (${freePercent}%)"
            Write-Host "    ! $($result.Message)" -ForegroundColor Red
        }
        elseif ($freePercent -lt 20) {
            $result.WarningLevel = 1
            $result.Message = "Mało miejsca na dysku: ${freeSpaceGB}GB (${freePercent}%)"
            Write-Host "    ! $($result.Message)" -ForegroundColor Yellow
        }
        else {
            Write-Host "    ✓ Wolne miejsce: ${freeSpaceGB}GB (${freePercent}%)" -ForegroundColor Green
        }
        
        return $result
    }
    catch {
        Write-Host "    ✗ Błąd sprawdzania dysku: $_" -ForegroundColor Red
        return @{ WarningLevel = 0; Error = $_.Exception.Message }
    }
}

# ════════════════════════════════════════════════════════════════════════════════
# AUTO-REPAIR FUNCTIONS
# ════════════════════════════════════════════════════════════════════════════════

function Repair-CommonIssues {
    <#
    .SYNOPSIS
        Automatycznie naprawia wykryte problemy
    #>
    param(
        [Parameter(Mandatory = $true)]
        [hashtable]$DiagnosticResults
    )
    
    Write-Host "`n[AUTO-NAPRAWA] Rozpoczynam naprawę wykrytych problemów..." -ForegroundColor Cyan
    
    $repairResults = @{
        Success = @()
        Failed = @()
    }
    
    # Repair 1: Windows Configuration Issues
    if ($DiagnosticResults.Checks.WindowsConfig.IssuesFound) {
        Write-Host "`n  Naprawa konfiguracji Windows..." -ForegroundColor Yellow
        
        $config = $DiagnosticResults.Checks.WindowsConfig.Config
        
        # Disable Memory Integrity
        if ($config.MemoryIntegrity -eq 1) {
            if (Repair-MemoryIntegrity) {
                $repairResults.Success += "Memory Integrity wyłączona"
            }
            else {
                $repairResults.Failed += "Memory Integrity - wymaga ręcznej interwencji"
            }
        }
        
        # Disable Game DVR
        if ($config.GameDVR -eq 1) {
            if (Repair-GameDVR) {
                $repairResults.Success += "Game DVR wyłączony"
            }
            else {
                $repairResults.Failed += "Game DVR"
            }
        }
        
        # Enable Hardware Scheduling
        if ($config.HardwareScheduling -ne 2) {
            if (Repair-HardwareScheduling) {
                $repairResults.Success += "Hardware Accelerated GPU Scheduling włączony"
            }
            else {
                $repairResults.Failed += "Hardware Scheduling"
            }
        }
    }
    
    # Repair 2: Services
    if (-not $DiagnosticResults.Checks.Services.AllRunning) {
        Write-Host "`n  Naprawa usług systemowych..." -ForegroundColor Yellow
        
        foreach ($serviceName in $DiagnosticResults.Checks.Services.Services.Keys) {
            $status = $DiagnosticResults.Checks.Services.Services[$serviceName]
            
            if ($status -ne 'Running') {
                if (Repair-Service -ServiceName $serviceName) {
                    $repairResults.Success += "Usługa $serviceName uruchomiona"
                }
                else {
                    $repairResults.Failed += "Usługa $serviceName"
                }
            }
        }
    }
    
    # Summary
    Write-Host "`n[AUTO-NAPRAWA] Zakończono:" -ForegroundColor Cyan
    Write-Host "  Naprawione: $($repairResults.Success.Count)" -ForegroundColor Green
    Write-Host "  Nieudane: $($repairResults.Failed.Count)" -ForegroundColor $(if ($repairResults.Failed.Count -gt 0) { 'Red' } else { 'Green' })
    
    if ($repairResults.Success.Count -gt 0) {
        Write-Host "`nPomyślnie naprawione:" -ForegroundColor Green
        $repairResults.Success | ForEach-Object { Write-Host "  ✓ $_" -ForegroundColor Green }
    }
    
    if ($repairResults.Failed.Count -gt 0) {
        Write-Host "`nWymaga ręcznej interwencji:" -ForegroundColor Yellow
        $repairResults.Failed | ForEach-Object { Write-Host "  ! $_" -ForegroundColor Yellow }
    }
    
    return $repairResults
}

function Repair-MemoryIntegrity {
    <#
    .SYNOPSIS
        Wyłącza Memory Integrity (wymaga restartu)
    #>
    
    try {
        $path = 'HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity'
        Set-ItemProperty -Path $path -Name 'Enabled' -Value 0 -Type DWord -ErrorAction Stop
        Write-Host "    ✓ Memory Integrity wyłączona (wymaga restartu)" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "    ✗ Błąd wyłączania Memory Integrity: $_" -ForegroundColor Red
        Write-Host "      Wyłącz ręcznie w: Settings → Privacy & Security → Windows Security → Device Security → Core Isolation" -ForegroundColor Yellow
        return $false
    }
}

function Repair-GameDVR {
    <#
    .SYNOPSIS
        Wyłącza Game DVR
    #>
    
    try {
        $path = 'HKCU:\System\GameConfigStore'
        Set-ItemProperty -Path $path -Name 'GameDVR_Enabled' -Value 0 -Type DWord -ErrorAction Stop
        Write-Host "    ✓ Game DVR wyłączony" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "    ✗ Błąd wyłączania Game DVR: $_" -ForegroundColor Red
        return $false
    }
}

function Repair-HardwareScheduling {
    <#
    .SYNOPSIS
        Włącza Hardware Accelerated GPU Scheduling
    #>
    
    try {
        # Check Windows version (Windows 11+ only)
        $osVersion = (Get-CimInstance -ClassName Win32_OperatingSystem).Version
        if ($osVersion -ge '10.0.22000') {
            $path = 'HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers'
            Set-ItemProperty -Path $path -Name 'HwSchMode' -Value 2 -Type DWord -ErrorAction Stop
            Write-Host "    ✓ Hardware Scheduling włączony (wymaga restartu)" -ForegroundColor Green
            return $true
        }
        else {
            Write-Host "    ! Hardware Scheduling wymaga Windows 11" -ForegroundColor Yellow
            return $false
        }
    }
    catch {
        Write-Host "    ✗ Błąd włączania Hardware Scheduling: $_" -ForegroundColor Red
        return $false
    }
}

function Repair-Service {
    <#
    .SYNOPSIS
        Próbuje uruchomić usługę
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$ServiceName
    )
    
    try {
        $service = Get-Service -Name $ServiceName -ErrorAction Stop
        
        if ($service.Status -ne 'Running') {
            Start-Service -Name $ServiceName -ErrorAction Stop
            Write-Host "    ✓ Usługa $ServiceName uruchomiona" -ForegroundColor Green
            return $true
        }
        
        return $true
    }
    catch {
        Write-Host "    ✗ Nie udało się uruchomić usługi $ServiceName: $_" -ForegroundColor Red
        return $false
    }
}

# Export functions
Export-ModuleMember -Function @(
    'Start-SelfDiagnostics',
    'Test-HardwareCompatibility',
    'Test-BIOSVersion',
    'Test-DriverVersions',
    'Test-WindowsConfiguration',
    'Test-RequiredServices',
    'Test-DiskHealth',
    'Repair-CommonIssues'
)
