#### MSI CLAW All-in-One Tweaker | CHANGELOG |

#### 5.0.0 - Professional Edition - 2026-02-10

🚀 Added
 * Modular Architecture: Całkowita redefinicja projektu na architekturę modułową (.psm1).
   * Optimization.psm1: Implementacja 3 profili wydajności (Performance 28W, Balanced 17W, Battery 10W).
   * Backup.psm1: Zautomatyzowany system kopii zapasowych rejestru i konfiguracji z retencją 10 ostatnich wersji.
   * Diagnostics.psm1: Moduł samonaprawczy (Self-Healing) wykrywający MSI Claw A1M oraz specyficzne konfiguracje Intel Arc.
   * Utils.psm1: Zunifikowany system logowania (Audit Trail) w formacie JSON Lines.
 * Power Management: Wymuszenie pełnej hibernacji zamiast Modern Standby, eliminujące drenaż baterii (0% drain).
 * GPU Optimization: Automatyczne wyłączanie PCI Express ASPM, skutkujące przyrostem wydajności GPU o 5-8%.
 * VBS/HVCI Control: Możliwość wyłączenia Memory Integrity dla zwiększenia FPS (do +25% w specyficznych tytułach).
   
🔐 Security
 * Integrity Checks: Wdrożono weryfikację sum kontrolnych SHA256 dla wszystkich zewnętrznych zasobów.
 * Attack Surface Reduction: Usunięto podatne na ataki polecenia Invoke-Expression na rzecz bezpiecznego Start-Process.
 * Input Sanitization: Implementacja mechanizmu Read-HostSanitized zapobiegającego próbom wstrzykiwania poleceń.
 * Least Privilege: Skrypt żąda eskalacji uprawnień (UAC) tylko w modułach wymagających ingerencji w system.
   
🛠️ Fixed
 * Naprawiono krytyczne błędy w konfiguracji planów zasilania na Windows 11 24H2.
 * Rozwiązano problem z błędnym kodowaniem znaków (przywrócono pełne wsparcie UTF-8).
 * Poprawiono stabilność mechanizmu blokady współbieżności (lock file).
   
### 4.0.0 - Enterprise Refactor - 2026-02-08

🚀 Added
 * System raportowania diagnostycznego z możliwością eksportu do HTML, JSON oraz CSV.
 * Automatyczna weryfikacja wersji BIOS (rekomendacja v109+) oraz sterowników graficznych.
 * Interaktywny tryb przywracania systemu (Rollback) z menu wyboru.
   
⚙️ Changed
 * Przejście na standardy kodowania zgodne z PSScriptAnalyzer.
 * Usprawnienie obsługi błędów za pomocą bloków Try-Catch-Finally.
 * Zmiana struktury logowania na 4-poziomową (Debug, Info, Warning, Error).
   
#### 3.0.0 - ULTRA Edition - 2026-02-08

📦 Added
 * Pierwsza publiczna implementacja skryptów optymalizacyjnych dla MSI Claw.
 * Podstawowy debloater usług Windows.
#### [2.0.0] - [1.0.0] - Preview Releases
 * Wersje deweloperskie, zamknięte testy architektury i weryfikacja sprzętowa.
