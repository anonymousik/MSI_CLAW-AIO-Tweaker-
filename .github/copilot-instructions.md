# 🤖 Copilot Instructions for MSI Claw AIO Tweaker

This document serves as the **Single Source of Truth** for the AI Coding Agent working on the MSI Claw AIO Tweaker. It enforces strict safety protocols for Windows System modifications and hardware interactions tailored to the Intel Core Ultra architecture.

## 1. 🧭 Project Context & Hardware Architecture

- **Target Device:** MSI Claw A1M (Intel Core Ultra 5/7 155H).
- **OS Environment:** Windows 11 Home/Pro (23H2+).
- **Core Tech Stack:**
  - **Primary:** PowerShell 7.x / Batch Scripts (or C# .NET 8 if GUI-based).
  - **Hardware Interface:** WMI (Windows Management Instrumentation), Intel XeSS, Registry (RegEdit).
  - **Critical Dependency:** MSI Center M Service (matches TDP/Fan profiles).

**⚠️ ARCHITECTURE WARNING:**
This device uses **Intel Arc Graphics**. Do NOT suggest AMD Adrenalin or NVIDIA Control Panel tweaks. All GPU optimizations must target Intel Command Center or Registry keys for `Intel(R) Arc(TM) Graphics`.

## 2. 🏗️ Build, Run & Validation Protocol (ZERO TRUST)

**Agent Directive:** You are operating with Administrator privileges. Every change implies a potential system break. Follow this strictly:

### 🛠 Environment Setup & Safety
1. **Execution Policy:**
   Always assume the user needs to unblock scripts.
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

 * Safety Net (MANDATORY):
   Before applying ANY registry tweak or service change, generate a Restore Point command:
   Checkpoint-Computer -Description "Pre-Tweak-Backup" -RestorePointType "MODIFY_SETTINGS"

🚀 Execution
 * Run Script:
   If .ps1: .\start.ps1 or .\tweaker.ps1 (Verify filename in root).
   If .exe: Run as Administrator.
 * Debug Mode:
   Use -Verbose or -Debug flags when suggesting PowerShell commands to trace errors.
🧪 Validation Steps
 * Registry Verification:
   Do not just write a key; verify it sticks.
   Get-ItemProperty -Path "HKLM:\..." -Name "TargetKey"

 * Service State Check:
   Ensure critical services (e.g., Audio, Touchscreen) are not accidentally disabled.
3. 🗺️ Project Layout (Heuristic Map)
Agent: Scan the root directory to confirm, but assume this structure:
 * /Scripts or /Modules: Core logic for debloating, TDP control, or visual tweaks.
 * /Backup: Default folder for storing original registry states.
 * /Resources: External tools (e.g., monitor utilities, driver cleaners).
 * README.md: Contains the changelog and warning disclaimers.
4. 🛡️ Coding Standards & Safety Constraints
🔒 Security & Stability (Hard Rules)
 * Zero Hallucination on Hardware:
   * NEVER invent WMI classes for MSI Fan Control. Use known classes like root\WMI or root\CIMV2.
   * If unsure about a TDP value (PL1/PL2), strictly output a warning: "Requires validation on physical hardware."
 * Registry Hygiene:
   * Always use Test-Path before checking registry keys.
   * When removing keys, use -ErrorAction SilentlyContinue.
⚡ Optimization Targets (MSI Claw Specific)
 * Intel Arc Priority: Focus on ReBar (Resizable BAR) and Shared Memory tweaks.
 * Debloat: Target standard Windows bloatware but preserve MSI Center M and Thunderbolt Control Center.
 * Power Plan: Prefer modifying the "Ultimate Performance" GUID scheme over balancing plans.
5. 🚫 Known Issues & "Gotchas"
 * MSI Center M Conflict: Tweaking TDP via script while MSI Center M is set to "AI Engine" or "User Scenario" will cause immediate override. Advise user to set MSI Center to "Manual" or kill the service process first.
 * Intel Drivers: Intel drivers reset certain registry keys after updates. Scripts should include a "Re-apply" logic.
 * Sleep Mode (S3/S0): MSI Claw struggles with Modern Standby (S0). Prefer Hibernate (S4) tweaks over Sleep tweaks to avoid battery drain.
<!-- end list -->

---

### 🛡️ AUDYT BEZPIECZEŃSTWA (Security Audit)

1.  **Ochrona przed "Brickowaniem":**
    * W sekcji **2. Build...** wymusiłem użycie `Checkpoint-Computer`. To kluczowe zabezpieczenie. Jeśli agent wygeneruje kod usuwający kluczowe pliki systemowe, użytkownik ma punkt przywracania.
2.  **Zgodność sprzętowa:**
    * Explicitne ostrzeżenie "Do NOT suggest AMD/NVIDIA tweaks". Agenty często trenowane są na Steam Decku (AMD Van Gogh) i mogą błędnie proponować ustawienia dla sterowników AMD, co na Intel Arc spowoduje błędy.
3.  **Ochrona procesu MSI Center M:**
    * Sekcja **5. Known Issues** adresuje największą bolączkę MSI Claw – walkę o kontrolę nad hardwarem między skryptem a oficjalnym softem MSI.

