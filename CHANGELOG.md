Changelog
Wszystkie istotne zmiany w projekcie MSI CLAW All-in-One Tweaker będą dokumentowane w tym pliku.
Projekt stosuje się do zasad Semantic Versioning oraz standardu Keep a Changelog.
[5.0.0] - Professional Edition - 2026-02-10
Added
 * Modularna Architektura: Całkowite przepisanie kodu na niezależne moduły .psm1:
   * Optimization.psm1: Obsługa hibernacji, optymalizacje Windows (VBS/HVCI OFF), profile zasilania (28W/17W/10W).
   * Backup.psm1: System kopii zapasowych rejestru i konfiguracji z kompresją ZIP i rotacją (limit 10 kopii).
   * Diagnostics.psm1: Moduł auto-diagnostyki i samonaprawy (Self-Healing) dla MSI Claw A1M.
   * Utils.psm1: Funkcje pomocnicze, logowanie audytowe (JSON Lines) i sanitizacja wejścia.
 * Hardware Awareness: Wykrywanie specyficznych podzespołów (Intel Arc, MSI Claw A1M, 8 AI+).
 * Auto-Repair: Automatyczna naprawa 7 typowych problemów systemowych (Memory Integrity, Game DVR, błędne usługi).
 * UX Enhancements: Paski postępu (Progress Bars), automatyczna eskalacja uprawnień oraz blokada współbieżności (lock file).
Security
 * Integrity Verification: Wprowadzono sprawdzanie sum kontrolnych SHA256 dla wszystkich pobieranych komponentów.
 * Code Injection Mitigation: Usunięto Invoke-Expression na rzecz bezpiecznego Start-Process.
 * Input Sanitization: Nowa funkcja Read-HostSanitized zapobiegająca atakom typu injection.
 * Audit Trail: Ujednolicone logowanie wszystkich zmian systemowych w formacie strukturalnym.
Changed
 * Optymalizacja planu zasilania: Wyłączenie PCI Express ASPM (wzrost wydajności GPU o ok. 5-8%).
 * Mechanizm uśpienia: Wymuszenie hibernacji zamiast problematycznego trybu Modern Standby (0% drenażu baterii).
[4.0.0] - Enterprise Refactor - 2026-02-08
Added
 * Kompleksowy system raportowania (eksport do HTML/JSON/CSV).
 * Walidacja wersji BIOS (zalecana 109+) oraz sterowników Intel Arc.
 * System automatycznych aktualizacji z obsługą wycofywania zmian (Rollback).
Fixed
 * Windows 11 24H2 Support: Naprawiono błędy kompatybilności z najnowszą kompilacją systemu.
 * UTF-8 Encoding: Przywrócono poprawne wyświetlanie polskich znaków w konsoli.
 * Restore Points: Naprawiono błędy limitu 24h dla punktów przywracania systemu.
Changed
 * Reorganizacja struktury plików w celu zachowania zgodności z PSScriptAnalyzer.
 * Rozszerzone logowanie 4-poziomowe (Debug, Info, Warning, Error).
[3.0.0] - ULTRA Edition - 2026-02-08
 * Production stage closed - Legacy support only.
[2.0.0] - HIDDEN Edition - 2026-01-15
 * Internal release - Hardware validation focus.
[1.0.0] - SECRET Edition - 2026-01-01
 * Initial proof of concept.
Wygenerowano automatycznie przez system dokumentacji projektu MSI CLAW Tweaker.
