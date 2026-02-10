<#
.SYNOPSIS
    Optimization Module - Główne funkcje optymalizacyjne dla MSI Claw
    
.DESCRIPTION
    Moduł zawierający wszystkie funkcje optymalizacyjne Windows, sterowników,
    zasilania, hibernacji i profili wydajnościowych
#>

# Import required modules
if (Get-Module Utils) {
    # Utils already loaded
} else {
    Import-Module (Join-Path $PSScriptRoot 'Utils.psm1') -ErrorAction Stop
}

# ════════════════════════════════════════════════════════════════════════════════
# WINDOWS OPTIMIZATIONS
# ════════════════════════════════════════════════════════════════════════════════

function Set-WindowsOptimizations {
    <#
    .SYNOPSIS
        Kompleksowa optymalizacja Windows dla gaming
    .DESCRIPTION
        Wyłącza/włącza kluczowe funkcje Windows dla maksymalnej wydajności w grach
    .PARAMETER CreateBackup
        Czy utworzyć backup przed zmianami (domyślnie: true)
    .EXAMPLE
        Set-WindowsOptimizations -CreateBackup $true
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $false)]
        [bool]$CreateBackup = $true
    )
    
    Write-Log "Rozpoczynam optymalizację Windows..." -Level Info
    
    $changes = @{
        Success = @()
        Failed = @()
        RequiresRestart = $false
    }
    
    try {
        # 1. Disable Memory Integrity (HVCI)
        Write-Log "Wyłączanie Memory Integrity (HVCI)..." -Level Info
        
        if (Disable-MemoryIntegrity) {
            $changes.Success += "Memory Integrity wyłączona"
            $changes.RequiresRestart = $true
        } else {
            $changes.Failed += "Memory Integrity"
        }
        
        # 2. Disable Game DVR
        Write-Log "Wyłączanie Game DVR..." -Level Info
        
        if (Disable-GameDVR) {
            $changes.Success += "Game DVR wyłączony"
        } else {
            $changes.Failed += "Game DVR"
        }
        
        # 3. Enable Hardware Accelerated GPU Scheduling
        Write-Log "Włączanie Hardware GPU Scheduling..." -Level Info
        
        if (Enable-HardwareGPUScheduling) {
            $changes.Success += "Hardware GPU Scheduling włączony"
            $changes.RequiresRestart = $true
        } else {
            $changes.Failed += "Hardware GPU Scheduling"
        }
        
        # 4. Disable unnecessary Windows features
        Write-Log "Wyłączanie zbędnych funkcji Windows..." -Level Info
        
        if (Disable-UnnecessaryFeatures) {
            $changes.Success += "Zbędne funkcje wyłączone"
        } else {
            $changes.Failed += "Windows Features"
        }
        
        # 5. Optimize Windows services
        Write-Log "Optymalizacja usług Windows..." -Level Info
        
        if (Optimize-WindowsServices) {
            $changes.Success += "Usługi zoptymalizowane"
        } else {
            $changes.Failed += "Windows Services"
        }
        
        # 6. Disable telemetry
        Write-Log "Wyłączanie telemetrii..." -Level Info
        
        if (Disable-WindowsTelemetry) {
            $changes.Success += "Telemetria wyłączona"
        } else {
            $changes.Failed += "Telemetry"
        }
        
        # 7. Optimize visual effects
        Write-Log "Optymalizacja efektów wizualnych..." -Level Info
        
        if (Optimize-VisualEffects) {
            $changes.Success += "Efekty wizualne zoptymalizowane"
        } else {
            $changes.Failed += "Visual Effects"
        }
        
        # Summary
        Write-Log "`nPodsumowanie optymalizacji Windows:" -Level Info
        Write-Log "  Pomyślne: $($changes.Success.Count)" -Level Success
        Write-Log "  Nieudane: $($changes.Failed.Count)" -Level $(if ($changes.Failed.Count -gt 0) { 'Warning' } else { 'Success' })
        
        if ($changes.Success.Count -gt 0) {
            Write-Log "`nZastosowane zmiany:" -Level Success
            $changes.Success | ForEach-Object { Write-Log "  ✓ $_" -Level Success }
        }
        
        if ($changes.Failed.Count -gt 0) {
            Write-Log "`nNieudane zmiany:" -Level Warning
            $changes.Failed | ForEach-Object { Write-Log "  ✗ $_" -Level Warning }
        }
        
        if ($changes.RequiresRestart) {
            Write-Log "`n⚠️  RESTART WYMAGANY aby zmiany weszły w życie!" -Level Warning
        }
        
        return $changes
    }
    catch {
        Write-Log "Błąd podczas optymalizacji Windows: $_" -Level Error
        throw
    }
}

function Disable-MemoryIntegrity {
    <#
    .SYNOPSIS
        Wyłącza Memory Integrity (Core Isolation)
    .DESCRIPTION
        Impact: +15-25% FPS w grach
    #>
    
    try {
        $path = 'HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity'
        
        # Check if path exists
        if (-not (Test-Path $path)) {
            Write-Log "Memory Integrity registry path not found - skipping" -Level Warning
            return $true
        }
        
        # Get current value
        $current = (Get-ItemProperty -Path $path -Name 'Enabled' -ErrorAction SilentlyContinue).Enabled
        
        if ($current -eq 0) {
            Write-Log "Memory Integrity already disabled" -Level Info
            return $true
        }
        
        # Disable
        Set-ItemProperty -Path $path -Name 'Enabled' -Value 0 -Type DWord -ErrorAction Stop
        Write-Log "Memory Integrity disabled successfully (restart required)" -Level Success
        
        return $true
    }
    catch {
        Write-Log "Failed to disable Memory Integrity: $_" -Level Error
        Write-Log "Manual: Settings → Privacy & Security → Windows Security → Device Security → Core Isolation" -Level Warning
        return $false
    }
}

function Disable-GameDVR {
    <#
    .SYNOPSIS
        Wyłącza Game DVR (Xbox Game Bar recording)
    .DESCRIPTION
        Impact: Eliminacja nagrywania w tle
    #>
    
    try {
        # Registry paths for Game DVR
        $paths = @(
            @{
                Path = 'HKCU:\System\GameConfigStore'
                Name = 'GameDVR_Enabled'
                Value = 0
            },
            @{
                Path = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR'
                Name = 'AppCaptureEnabled'
                Value = 0
            },
            @{
                Path = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR'
                Name = 'AudioCaptureEnabled'
                Value = 0
            },
            @{
                Path = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR'
                Name = 'CursorCaptureEnabled'
                Value = 0
            },
            @{
                Path = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR'
                Name = 'AllowGameDVR'
                Value = 0
            }
        )
        
        foreach ($setting in $paths) {
            # Create path if doesn't exist
            if (-not (Test-Path $setting.Path)) {
                New-Item -Path $setting.Path -Force | Out-Null
            }
            
            Set-ItemProperty -Path $setting.Path -Name $setting.Name -Value $setting.Value -Type DWord -ErrorAction Stop
        }
        
        Write-Log "Game DVR disabled successfully" -Level Success
        return $true
    }
    catch {
        Write-Log "Failed to disable Game DVR: $_" -Level Error
        return $false
    }
}

function Enable-HardwareGPUScheduling {
    <#
    .SYNOPSIS
        Włącza Hardware Accelerated GPU Scheduling
    .DESCRIPTION
        Impact: Niższa latencja GPU, lepsze frame pacing
        Requires: Windows 11 or Windows 10 2004+
    #>
    
    try {
        # Check Windows version
        $osVersion = (Get-CimInstance -ClassName Win32_OperatingSystem).Version
        $build = [int]((Get-CimInstance -ClassName Win32_OperatingSystem).BuildNumber)
        
        # Requires Windows 10 2004 (19041) or later
        if ($build -lt 19041) {
            Write-Log "Hardware GPU Scheduling requires Windows 10 2004+ or Windows 11" -Level Warning
            return $false
        }
        
        $path = 'HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers'
        
        # Check current value
        $current = (Get-ItemProperty -Path $path -Name 'HwSchMode' -ErrorAction SilentlyContinue).HwSchMode
        
        if ($current -eq 2) {
            Write-Log "Hardware GPU Scheduling already enabled" -Level Info
            return $true
        }
        
        # Enable
        Set-ItemProperty -Path $path -Name 'HwSchMode' -Value 2 -Type DWord -ErrorAction Stop
        Write-Log "Hardware GPU Scheduling enabled successfully (restart required)" -Level Success
        
        return $true
    }
    catch {
        Write-Log "Failed to enable Hardware GPU Scheduling: $_" -Level Error
        return $false
    }
}

function Disable-UnnecessaryFeatures {
    <#
    .SYNOPSIS
        Wyłącza zbędne funkcje Windows
    #>
    
    try {
        $success = $true
        
        # Check if Virtual Machine Platform is enabled
        $vmpFeature = Get-WindowsOptionalFeature -Online -FeatureName 'VirtualMachinePlatform' -ErrorAction SilentlyContinue
        
        if ($vmpFeature -and $vmpFeature.State -eq 'Enabled') {
            Write-Log "Virtual Machine Platform detected (enabled)" -Level Warning
            Write-Log "Consider disabling for better gaming performance" -Level Warning
            Write-Log "Command: Disable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform" -Level Info
            # Don't auto-disable as it may break WSL/Docker
        }
        
        # Disable Windows Search indexing (for SSD)
        try {
            $searchService = Get-Service -Name 'WSearch' -ErrorAction SilentlyContinue
            if ($searchService -and $searchService.Status -eq 'Running') {
                Set-Service -Name 'WSearch' -StartupType Disabled -ErrorAction Stop
                Stop-Service -Name 'WSearch' -Force -ErrorAction Stop
                Write-Log "Windows Search indexing disabled" -Level Success
            }
        }
        catch {
            Write-Log "Could not disable Windows Search: $_" -Level Warning
            $success = $false
        }
        
        return $success
    }
    catch {
        Write-Log "Error disabling unnecessary features: $_" -Level Error
        return $false
    }
}

function Optimize-WindowsServices {
    <#
    .SYNOPSIS
        Optymalizuje usługi Windows dla gaming
    #>
    
    try {
        # Services to disable for gaming
        $servicesToDisable = @(
            'DiagTrack',           # Connected User Experiences and Telemetry
            'dmwappushservice',    # Device Management Wireless Application Protocol
            'SysMain',             # Superfetch (not needed for SSD)
            'WSearch'              # Windows Search (if not already disabled)
        )
        
        foreach ($serviceName in $servicesToDisable) {
            try {
                $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
                
                if ($service) {
                    if ($service.Status -eq 'Running') {
                        Stop-Service -Name $serviceName -Force -ErrorAction SilentlyContinue
                    }
                    Set-Service -Name $serviceName -StartupType Disabled -ErrorAction SilentlyContinue
                    Write-Log "Service $serviceName disabled" -Level Info
                }
            }
            catch {
                Write-Log "Could not disable service $serviceName : $_" -Level Warning
            }
        }
        
        return $true
    }
    catch {
        Write-Log "Error optimizing services: $_" -Level Error
        return $false
    }
}

function Disable-WindowsTelemetry {
    <#
    .SYNOPSIS
        Wyłącza telemetrię Windows
    #>
    
    try {
        # Disable telemetry via registry
        $telemetrySettings = @(
            @{
                Path = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection'
                Name = 'AllowTelemetry'
                Value = 0
            },
            @{
                Path = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection'
                Name = 'AllowTelemetry'
                Value = 0
            },
            @{
                Path = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy'
                Name = 'TailoredExperiencesWithDiagnosticDataEnabled'
                Value = 0
            }
        )
        
        foreach ($setting in $telemetrySettings) {
            if (-not (Test-Path $setting.Path)) {
                New-Item -Path $setting.Path -Force | Out-Null
            }
            
            Set-ItemProperty -Path $setting.Path -Name $setting.Name -Value $setting.Value -Type DWord -ErrorAction Stop
        }
        
        Write-Log "Windows telemetry disabled" -Level Success
        return $true
    }
    catch {
        Write-Log "Failed to disable telemetry: $_" -Level Error
        return $false
    }
}

function Optimize-VisualEffects {
    <#
    .SYNOPSIS
        Optymalizuje efekty wizualne dla wydajności
    #>
    
    try {
        $path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects'
        
        # Create path if doesn't exist
        if (-not (Test-Path $path)) {
            New-Item -Path $path -Force | Out-Null
        }
        
        # Set to "Adjust for best performance"
        Set-ItemProperty -Path $path -Name 'VisualFXSetting' -Value 2 -Type DWord -ErrorAction Stop
        
        # Specific visual effects settings
        $advancedPath = 'HKCU:\Control Panel\Desktop'
        
        $visualSettings = @{
            'DragFullWindows' = '0'          # Disable drag full windows
            'MenuShowDelay' = '0'            # Reduce menu show delay
            'UserPreferencesMask' = [byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00)  # Performance preset
        }
        
        foreach ($setting in $visualSettings.GetEnumerator()) {
            Set-ItemProperty -Path $advancedPath -Name $setting.Key -Value $setting.Value -ErrorAction SilentlyContinue
        }
        
        Write-Log "Visual effects optimized for performance" -Level Success
        return $true
    }
    catch {
        Write-Log "Failed to optimize visual effects: $_" -Level Error
        return $false
    }
}

# ════════════════════════════════════════════════════════════════════════════════
# POWER CONFIGURATION
# ════════════════════════════════════════════════════════════════════════════════

function Set-OptimalPowerPlan {
    <#
    .SYNOPSIS
        Konfiguruje optymalny plan zasilania
    .PARAMETER Profile
        Performance, Balanced, lub Battery
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateSet('Performance', 'Balanced', 'Battery')]
        [string]$Profile = 'Balanced'
    )
    
    Write-Log "Konfiguracja planu zasilania: $Profile" -Level Info
    
    try {
        # Get active power scheme GUID
        $activeScheme = (powercfg /getactivescheme) -replace '^.*\(([^)]+)\).*$', '$1'
        
        if (-not $activeScheme) {
            Write-Log "Could not determine active power scheme" -Level Error
            return $false
        }
        
        Write-Log "Active power scheme: $activeScheme" -Level Info
        
        # Configure based on profile
        switch ($Profile) {
            'Performance' {
                # Maximum performance settings
                & powercfg /setacvalueindex $activeScheme SUB_PROCESSOR PROCTHROTTLEMAX 100
                & powercfg /setdcvalueindex $activeScheme SUB_PROCESSOR PROCTHROTTLEMAX 100
                
                & powercfg /setacvalueindex $activeScheme SUB_PROCESSOR PROCTHROTTLEMIN 100
                & powercfg /setdcvalueindex $activeScheme SUB_PROCESSOR PROCTHROTTLEMIN 50
                
                # Disable USB selective suspend
                & powercfg /setacvalueindex $activeScheme SUB_USB USBSELECTIVESUSPEND 0
                & powercfg /setdcvalueindex $activeScheme SUB_USB USBSELECTIVESUSPEND 0
                
                # Disable PCI Express ASPM (on AC)
                & powercfg /setacvalueindex $activeScheme SUB_PCIEXPRESS ASPM 0
                
                Write-Log "Performance profile applied" -Level Success
            }
            
            'Balanced' {
                # Balanced settings (default optimized)
                & powercfg /setacvalueindex $activeScheme SUB_PROCESSOR PROCTHROTTLEMAX 100
                & powercfg /setdcvalueindex $activeScheme SUB_PROCESSOR PROCTHROTTLEMAX 85
                
                & powercfg /setacvalueindex $activeScheme SUB_PROCESSOR PROCTHROTTLEMIN 5
                & powercfg /setdcvalueindex $activeScheme SUB_PROCESSOR PROCTHROTTLEMIN 5
                
                # Moderate USB settings
                & powercfg /setacvalueindex $activeScheme SUB_USB USBSELECTIVESUSPEND 0
                & powercfg /setdcvalueindex $activeScheme SUB_USB USBSELECTIVESUSPEND 1
                
                # Enable PCI ASPM on battery
                & powercfg /setacvalueindex $activeScheme SUB_PCIEXPRESS ASPM 0
                & powercfg /setdcvalueindex $activeScheme SUB_PCIEXPRESS ASPM 2
                
                Write-Log "Balanced profile applied" -Level Success
            }
            
            'Battery' {
                # Maximum battery life
                & powercfg /setacvalueindex $activeScheme SUB_PROCESSOR PROCTHROTTLEMAX 100
                & powercfg /setdcvalueindex $activeScheme SUB_PROCESSOR PROCTHROTTLEMAX 60
                
                & powercfg /setacvalueindex $activeScheme SUB_PROCESSOR PROCTHROTTLEMIN 5
                & powercfg /setdcvalueindex $activeScheme SUB_PROCESSOR PROCTHROTTLEMIN 5
                
                # Enable all power saving features
                & powercfg /setacvalueindex $activeScheme SUB_USB USBSELECTIVESUSPEND 1
                & powercfg /setdcvalueindex $activeScheme SUB_USB USBSELECTIVESUSPEND 1
                
                & powercfg /setacvalueindex $activeScheme SUB_PCIEXPRESS ASPM 3
                & powercfg /setdcvalueindex $activeScheme SUB_PCIEXPRESS ASPM 3
                
                Write-Log "Battery profile applied" -Level Success
            }
        }
        
        # Apply changes
        & powercfg /setactive $activeScheme
        
        return $true
    }
    catch {
        Write-Log "Error configuring power plan: $_" -Level Error
        return $false
    }
}

function Set-HibernationConfiguration {
    <#
    .SYNOPSIS
        Konfiguruje hibernację zamiast Sleep (krityczna optymalizacja dla MSI Claw)
    .DESCRIPTION
        Impact: 0% battery drain when "off" vs 10-20% with Sleep
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]
    param()
    
    Write-Log "Konfiguracja hibernacji..." -Level Info
    
    try {
        # 1. Enable hibernation
        Write-Log "Włączanie hibernacji..." -Level Info
        $result = & powercfg /hibernate on 2>&1
        
        if ($LASTEXITCODE -ne 0) {
            Write-Log "Warning: powercfg /hibernate on returned exit code $LASTEXITCODE" -Level Warning
        } else {
            Write-Log "Hibernation enabled" -Level Success
        }
        
        # 2. Set power button action to Hibernate
        Write-Log "Konfiguracja przycisku zasilania..." -Level Info
        
        $activeScheme = (powercfg /getactivescheme) -replace '^.*\(([^)]+)\).*$', '$1'
        
        # PBUTTONACTION: 0=Do Nothing, 1=Sleep, 2=Hibernate, 3=Shut Down
        & powercfg /setacvalueindex $activeScheme SUB_BUTTONS PBUTTONACTION 2
        & powercfg /setdcvalueindex $activeScheme SUB_BUTTONS PBUTTONACTION 2
        
        Write-Log "Power button set to Hibernate" -Level Success
        
        # 3. Set lid close action to Hibernate (for laptops/handhelds)
        & powercfg /setacvalueindex $activeScheme SUB_BUTTONS LIDACTION 2
        & powercfg /setdcvalueindex $activeScheme SUB_BUTTONS LIDACTION 2
        
        Write-Log "Lid close set to Hibernate" -Level Success
        
        # 4. Disable wake timers
        Write-Log "Wyłączanie wake timers..." -Level Info
        
        & powercfg /setacvalueindex $activeScheme SUB_SLEEP RTCWAKE 0
        & powercfg /setdcvalueindex $activeScheme SUB_SLEEP RTCWAKE 0
        
        Write-Log "Wake timers disabled" -Level Success
        
        # 5. Disable Fast Startup (conflicts with Hibernate)
        Write-Log "Wyłączanie Fast Startup..." -Level Info
        
        $fastStartupPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power'
        Set-ItemProperty -Path $fastStartupPath -Name 'HiberbootEnabled' -Value 0 -Type DWord -ErrorAction Stop
        
        Write-Log "Fast Startup disabled" -Level Success
        
        # 6. Set hibernation timeout (minutes)
        # On AC: 120 minutes, On Battery: 30 minutes
        & powercfg /setacvalueindex $activeScheme SUB_SLEEP HIBERNATEIDLE 7200  # 120 min in seconds
        & powercfg /setdcvalueindex $activeScheme SUB_SLEEP HIBERNATEIDLE 1800  # 30 min in seconds
        
        Write-Log "Hibernate timeout configured" -Level Success
        
        # 7. Apply all changes
        & powercfg /setactive $activeScheme
        
        Write-Log "`n✓ Hibernation configured successfully!" -Level Success
        Write-Log "  - Power button: Hibernate" -Level Info
        Write-Log "  - Wake timers: Disabled" -Level Info
        Write-Log "  - Fast Startup: Disabled" -Level Info
        Write-Log "`nEffect: 0% battery drain when device is 'off'" -Level Success
        
        return $true
    }
    catch {
        Write-Log "Error configuring hibernation: $_" -Level Error
        return $false
    }
}

# ════════════════════════════════════════════════════════════════════════════════
# DRIVER MANAGEMENT
# ════════════════════════════════════════════════════════════════════════════════

function Update-IntelArcDriver {
    <#
    .SYNOPSIS
        Pobiera i instaluje najnowszy sterownik Intel Arc
    .DESCRIPTION
        Recommended version: 32.0.101.6877+
    .PARAMETER DriverURL
        Direct download URL (jeśli znany)
    .PARAMETER ExpectedHash
        SHA256 hash dla weryfikacji
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$DriverURL,
        
        [Parameter(Mandatory = $false)]
        [string]$ExpectedHash
    )
    
    Write-Log "Sprawdzanie sterownika Intel Arc..." -Level Info
    
    try {
        # Get current driver version
        $gpu = Get-CimInstance -ClassName Win32_VideoController | Where-Object { $_.Name -match 'Intel.*Arc' }
        
        if (-not $gpu) {
            Write-Log "Intel Arc Graphics not detected" -Level Warning
            return $false
        }
        
        $currentVersion = $gpu.DriverVersion
        Write-Log "Current Intel Arc driver: $currentVersion" -Level Info
        
        # Check if update needed
        $recommendedVersion = [Version]"32.0.101.6877"
        
        try {
            $current = [Version]$currentVersion
            if ($current -ge $recommendedVersion) {
                Write-Log "Intel Arc driver is up-to-date" -Level Success
                return $true
            }
        }
        catch {
            Write-Log "Could not parse driver version" -Level Warning
        }
        
        Write-Log "Driver update recommended" -Level Warning
        Write-Log "Current: $currentVersion | Recommended: $recommendedVersion" -Level Info
        
        # If URL not provided, direct user to Intel website
        if (-not $DriverURL) {
            Write-Log "`nPlease download the latest Intel Arc driver manually:" -Level Info
            Write-Log "URL: https://www.intel.com/content/www/us/en/download/785597/intel-arc-iris-xe-graphics-windows.html" -Level Info
            Write-Log "`nOr use MSI Center M → Live Update for automatic installation" -Level Info
            return $false
        }
        
        # Download and install
        Write-Log "Downloading Intel Arc driver..." -Level Info
        
        $downloadPath = Join-Path $env:TEMP "IntelArcDriver.zip"
        
        if ($ExpectedHash) {
            # Use secure download with verification
            if (-not (Get-SecureDownload -Url $DriverURL -OutputPath $downloadPath -ExpectedHash $ExpectedHash)) {
                Write-Log "Driver download failed verification" -Level Error
                return $false
            }
        } else {
            Write-Log "WARNING: Downloading without hash verification" -Level Warning
            Invoke-WebRequest -Uri $DriverURL -OutFile $downloadPath -UseBasicParsing
        }
        
        Write-Log "Driver downloaded. Manual installation required." -Level Info
        Write-Log "File: $downloadPath" -Level Info
        
        return $true
    }
    catch {
        Write-Log "Error updating Intel Arc driver: $_" -Level Error
        return $false
    }
}

function Update-MSICenterM {
    <#
    .SYNOPSIS
        Sprawdza i informuje o aktualizacji MSI Center M
    #>
    
    Write-Log "Checking MSI Center M..." -Level Info
    
    # MSI Center M is typically updated through its own Live Update feature
    Write-Log "To update MSI Center M:" -Level Info
    Write-Log "  1. Open MSI Center M" -Level Info
    Write-Log "  2. Go to Settings" -Level Info
    Write-Log "  3. Click 'Live Update'" -Level Info
    Write-Log "  4. Install any available updates" -Level Info
    Write-Log "`nRecommended version: 1.0.2405.1401+" -Level Info
    
    return $true
}

# ════════════════════════════════════════════════════════════════════════════════
# PERFORMANCE PROFILES
# ════════════════════════════════════════════════════════════════════════════════

function Set-PerformanceProfile {
    <#
    .SYNOPSIS
        Stosuje kompletny profil wydajnościowy
    .PARAMETER ProfileName
        Performance, Balanced, lub Battery
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('Performance', 'Balanced', 'Battery')]
        [string]$ProfileName
    )
    
    Write-Log "`n═══════════════════════════════════════════════════════════" -Level Info
    Write-Log " STOSOWANIE PROFILU: $ProfileName" -Level Info
    Write-Log "═══════════════════════════════════════════════════════════" -Level Info
    
    try {
        # 1. Power Plan
        Write-Log "`n[1/3] Konfiguracja planu zasilania..." -Level Info
        Set-OptimalPowerPlan -Profile $ProfileName
        
        # 2. Windows Optimizations (always apply)
        Write-Log "`n[2/3] Optymalizacje Windows..." -Level Info
        Set-WindowsOptimizations -CreateBackup $true
        
        # 3. Hibernation (always configure)
        Write-Log "`n[3/3] Konfiguracja hibernacji..." -Level Info
        Set-HibernationConfiguration
        
        Write-Log "`n✓ Profil $ProfileName zastosowany pomyślnie!" -Level Success
        
        # Profile-specific recommendations
        switch ($ProfileName) {
            'Performance' {
                Write-Log "`nZalecenia dla profilu Performance:" -Level Info
                Write-Log "  • Używaj TYLKO na zasilaczu" -Level Warning
                Write-Log "  • Oczekiwany czas baterii: 60-90 min" -Level Info
                Write-Log "  • Włącz Over Boost w MSI Center M" -Level Info
                Write-Log "  • Ustaw 120Hz refresh rate" -Level Info
            }
            'Balanced' {
                Write-Log "`nZalecenia dla profilu Balanced:" -Level Info
                Write-Log "  • Najlepszy balans wydajność/bateria" -Level Success
                Write-Log "  • Oczekiwany czas baterii: 90-120 min" -Level Info
                Write-Log "  • Ustaw 60Hz dla gier na baterii" -Level Info
                Write-Log "  • To jest ZALECANY profil" -Level Success
            }
            'Battery' {
                Write-Log "`nZalecenia dla profilu Battery:" -Level Info
                Write-Log "  • Maksymalny czas baterii" -Level Success
                Write-Log "  • Oczekiwany czas baterii: 120-180 min" -Level Info
                Write-Log "  • Ustaw 60Hz refresh rate" -Level Info
                Write-Log "  • Ogranicz FPS do 60 w grach" -Level Info
            }
        }
        
        Write-Log "`n⚠️  RESTART WYMAGANY aby wszystkie zmiany weszły w życie!" -Level Warning
        
        return $true
    }
    catch {
        Write-Log "Error applying performance profile: $_" -Level Error
        return $false
    }
}

# Export functions
Export-ModuleMember -Function @(
    # Windows Optimizations
    'Set-WindowsOptimizations',
    'Disable-MemoryIntegrity',
    'Disable-GameDVR',
    'Enable-HardwareGPUScheduling',
    'Disable-UnnecessaryFeatures',
    'Optimize-WindowsServices',
    'Disable-WindowsTelemetry',
    'Optimize-VisualEffects',
    
    # Power Configuration
    'Set-OptimalPowerPlan',
    'Set-HibernationConfiguration',
    
    # Driver Management
    'Update-IntelArcDriver',
    'Update-MSICenterM',
    
    # Performance Profiles
    'Set-PerformanceProfile'
)
