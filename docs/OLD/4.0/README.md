# MSI Claw Optimizer v4.0 PROFESSIONAL EDITION

```
███╗   ███╗███████╗██╗     ██████╗██╗      █████╗ ██╗    ██╗
████╗ ████║██╔════╝██║    ██╔════╝██║     ██╔══██╗██║    ██║
██╔████╔██║███████╗██║    ██║     ██║     ███████║██║ █╗ ██║
██║╚██╔╝██║╚════██║██║    ██║     ██║     ██╔══██║██║███╗██║
██║ ╚═╝ ██║███████║██║    ╚██████╗███████╗██║  ██║╚███╔███╔╝
╚═╝     ╚═╝╚══════╝╚═╝     ╚═════╝╚══════╝╚═╝  ╚═╝ ╚══╝╚══╝
            OPTIMIZER v4.0 - PROFESSIONAL EDITION
```

**Zaawansowany framework do kompleksowej optymalizacji MSI Claw Handheld Gaming PC**

---

## 📋 Spis Treści

- [O Projekcie](#-o-projekcie)
- [Funkcjonalności](#-funkcjonalności)
- [Wymagania Systemowe](#-wymagania-systemowe)
- [Instalacja](#-instalacja)
- [Użytkowanie](#-użytkowanie)
- [Bezpieczeństwo](#-bezpieczeństwo)
- [Dokumentacja](#-dokumentacja)
- [FAQ](#-faq)
- [Wsparcie](#-wsparcie)
- [Autorzy](#-autorzy)
- [Licencja](#-licencja)

---

## 🎯 O Projekcie

MSI Claw Optimizer v4.0 Professional Edition to kompletny framework do optymalizacji urządzeń MSI Claw. Projekt został stworzony przez **Nieznany Nikomu Anonymousik** pod patronem **SecFERRO DIVISION**, aby zapewnić użytkownikom MSI Claw najlepszą możliwą wydajność i czas pracy na baterii.

### Wersja

- **Wersja:** 4.0.0 Professional Edition
- **Data wydania:** 2026-02-08
- **Typ:** Production Ready
- **Status:** Stable

### Dlaczego ten projekt?

MSI Claw to potężne urządzenie handheld, ale wymaga odpowiedniej konfiguracji aby działać optymalnie. Ten skrypt:

✅ **Automatyzuje** wszystkie znane optymalizacje  
✅ **Naprawia** typowe problemy (bateria, hibernacja, FPS)  
✅ **Tworzy** profile wydajnościowe dostosowane do różnych gier  
✅ **Zabezpiecza** poprzez automatyczne backupy przed każdą zmianą  
✅ **Raportuje** szczegółową diagnostykę systemu  

---

## ⚡ Funkcjonalności

### Diagnostyka i Monitorowanie

- **Kompleksowa diagnostyka sprzętu**
  - Procesor (Intel Core Ultra 5/7)
  - Karta graficzna (Intel Arc Graphics)
  - BIOS/UEFI
  - Bateria i stan zdrowia
  - Pamięć RAM
  - System operacyjny

- **Monitorowanie w czasie rzeczywistym**
  - Temperatury
  - Wykorzystanie zasobów
  - Stan baterii
  - Wydajność

- **Raportowanie**
  - Eksport do HTML
  - Eksport do JSON
  - Eksport do CSV
  - Eksport do TXT

### Optymalizacje

- **Hibernacja i bateria**
  - Automatyczna konfiguracja hibernacji
  - Naprawa problemów z Sleep
  - Optymalizacja czasu baterii
  - Wyłączanie Wake Timers

- **Windows 11 Gaming**
  - Wyłączanie Memory Integrity
  - Konfiguracja VMP
  - Wyłączanie Game DVR
  - Optymalizacja PCI Express
  - Konfiguracja GPU Scheduling
  - Wyłączanie niepotrzebnych usług
  - Optymalizacja efektów wizualnych

- **Profile wydajnościowe**
  - AAA Max Performance
  - AAA Balanced
  - Competitive High FPS
  - Sports 60 FPS
  - Strategy Long Session
  - Indie Ultra Long
  - Emulation Balanced
  - Desktop Power Saver

### Bezpieczeństwo

- **Automatyczne backupy**
  - Backup przed każdą zmianą
  - Kompresja backupów
  - Zarządzanie historią backupów
  - Metadane backupów

- **Rollback**
  - Przywracanie poprzedniej konfiguracji
  - Lista dostępnych backupów
  - Rollback z historii

- **Logowanie**
  - Szczegółowe logi wszystkich operacji
  - 4 poziomy logowania (Debug, Info, Warning, Error)
  - Integracja z Windows Event Log
  - Automatyczne czyszczenie starych logów

### Troubleshooting

Interaktywne rozwiązywanie problemów:
- Szybkie rozładowywanie baterii
- Problemy ze Sleep/Hibernacją
- Niska wydajność w grach
- Przegrzewanie
- Problemy z ładowaniem
- Kontrolery po wznowieniu
- Problemy z dźwiękiem
- Problemy z wyświetlaczem
- Problemy z WiFi/Bluetooth

---

## 💻 Wymagania Systemowe

### Sprzęt

- **MSI Claw A1M** (Intel Core Ultra 5 135H lub Ultra 7 155H)
- **MSI Claw 8 AI+** (Intel Lunar Lake)
- Intel Arc Graphics
- Minimum 16GB RAM (zalecane)

### Oprogramowanie

- **Windows 11** (22H2, 23H2, 24H2) - zalecane
- **Windows 10** (20H1 lub nowszy) - ograniczone wsparcie
- **PowerShell 5.1** lub nowszy
- Uprawnienia **Administratora**

### Zalecane

- Punkt przywracania systemu
- Pełny backup systemu
- Aktualne sterowniki Intel Arc

---

## 📥 Instalacja

### Krok 1: Pobierz Skrypt

```powershell
# Sklonuj repozytorium lub pobierz ZIP
git clone https://Anonymousik.is-a.dev/MSI-Claw-Optimizer.git
cd MSI-Claw-Optimizer
```

### Krok 2: Przygotuj System

1. **Utwórz punkt przywracania systemu:**
   - Wyszukaj "Utwórz punkt przywracania" w Windows
   - Kliknij "Utwórz..."
   - Nadaj nazwę np. "Przed MSI Claw Optimizer"

2. **Zaktualizuj Windows:**
   - Sprawdź Windows Update
   - Zainstaluj wszystkie dostępne aktualizacje

3. **Zaktualizuj sterowniki:**
   - Pobierz najnowsze sterowniki Intel Arc
   - Zaktualizuj BIOS MSI Claw (opcjonalnie, ale zalecane)

### Krok 3: Uruchom Skrypt

#### Metoda 1: Kliknięcie prawym przyciskiem (zalecane)

1. Kliknij prawym przyciskiem myszy na plik `.ps1`
2. Wybierz **"Uruchom z PowerShell"** lub **"Uruchom jako administrator"**

#### Metoda 2: PowerShell

```powershell
# Otwórz PowerShell jako administrator
# Przejdź do katalogu ze skryptem
cd C:\Ścieżka\Do\MSI-Claw-Optimizer

# Uruchom skrypt
.\MSI_Claw_Optimizer_v4_PROFESSIONAL_EDITION.ps1
```

#### Metoda 3: Z parametrami

```powershell
# Tryb automatyczny z debugowaniem
.\MSI_Claw_Optimizer_v4_PROFESSIONAL_EDITION.ps1 -Mode Automatic -LogLevel Debug

# Tylko diagnostyka z raportem
.\MSI_Claw_Optimizer_v4_PROFESSIONAL_EDITION.ps1 -Mode DiagnosticOnly -GenerateReport

# Bez backupu (NIE ZALECANE)
.\MSI_Claw_Optimizer_v4_PROFESSIONAL_EDITION.ps1 -SkipBackup
```

---

## 🚀 Użytkowanie

### Pierwsze uruchomienie

1. **Uruchom pełną diagnostykę** (Opcja 1)
   - Sprawdź aktualny stan systemu
   - Zanotuj wyniki

2. **Przejrzyj raport** (Opcja 3)
   - Wygeneruj raport HTML
   - Sprawdź czy wszystko jest OK

3. **Uruchom pełną optymalizację** (Opcja 11)
   - Skrypt przeprowadzi wszystkie zalecane optymalizacje
   - Restart będzie wymagany

4. **Utwórz profile gier** (Opcja 6)
   - Profile zostaną utworzone w `Documents\MSI_Claw_Profiles`
   - Użyj ich przed uruchomieniem gry

### Codzienne użytkowanie

#### Przed graniem:

1. Kliknij dwukrotnie na profil odpowiedni dla gry
   - `AAA_MaxPerformance.bat` - Cyberpunk, Starfield
   - `Sports_60FPS.bat` - FIFA, FC 25
   - `Competitive_HighFPS.bat` - Fortnite, Apex
   - `Indie_UltraLong.bat` - Stardew Valley, Hades

2. Potwierdź uprawnienia administratora

3. Uruchom grę

#### Po graniu:

- Opcjonalnie uruchom `RESET.bat` aby przywrócić domyślne ustawienia
- Lub zostaw profil aktywny - system automatycznie dostosuje częstotliwość

### Rozwiązywanie problemów

Jeśli napotkasz problem:

1. Uruchom **Interaktywne rozwiązywanie problemów** (Opcja 2)
2. Wybierz odpowiedni problem z listy
3. Postępuj zgodnie z instrukcjami

### Przywracanie konfiguracji

Jeśli coś poszło nie tak:

1. Wybierz **Przywróć konfigurację z backupu** (Opcja 8)
2. Wybierz backup z listy
3. Potwierdź przywracanie
4. Restart systemu

---

## 🔒 Bezpieczeństwo

### ⚠️ OSTRZEŻENIA

**PRZED UŻYCIEM PRZECZYTAJ UWAŻNIE:**

1. **Uprawnienia administratora**
   - Skrypt wymaga uprawnień administratora
   - Modyfikuje krytyczne ustawienia systemowe
   - NIE uruchamiaj na urządzeniach produkcyjnych bez testów

2. **Backup**
   - ZAWSZE twórz punkt przywracania systemu przed uruchomieniem
   - Zalecana pełna kopia zapasowa systemu
   - Skrypt automatycznie tworzy backupy konfiguracji

3. **Zgodność**
   - Zoptymalizowane dla MSI Claw
   - Użycie na innych urządzeniach może powodować problemy
   - Sprawdź kompatybilność przed użyciem

4. **Odpowiedzialność**
   - Użycie wyłącznie na własne ryzyko
   - Autor nie ponosi odpowiedzialności za ewentualne szkody
   - Testuj najpierw w środowisku bezpiecznym

### 🛡️ Zabezpieczenia w skrypcie

Skrypt zawiera następujące zabezpieczenia:

✅ **Automatyczne backupy** przed każdą modyfikacją  
✅ **Try-Catch-Finally** dla wszystkich krytycznych operacji  
✅ **Walidacja** danych wejściowych  
✅ **Sprawdzanie uprawnień** przed operacjami  
✅ **Rollback** w przypadku błędu  
✅ **Szczegółowe logowanie** wszystkich działań  
✅ **Potwierdzenia** przed krytycznymi zmianami  

### 📜 Zgodność z normami

Skrypt jest zgodny z:

- PowerShell Script Analyzer Best Practices
- Microsoft PowerShell Coding Guidelines
- Security Development Lifecycle (SDL)
- Principle of Least Privilege

---

## 📚 Dokumentacja

### Struktura projektu

```
MSI-Claw-Optimizer/
├── MSI_Claw_Optimizer_v4_PROFESSIONAL_EDITION.ps1  # Główny skrypt
├── README.md                                        # Ta dokumentacja
├── CHANGELOG.md                                     # Historia zmian
├── LICENSE                                          # Licencja
├── docs/                                            # Dodatkowa dokumentacja
│   ├── INSTALLATION.md                             # Szczegółowa instalacja
│   ├── TROUBLESHOOTING.md                          # Rozwiązywanie problemów
│   ├── ADVANCED.md                                 # Zaawansowane użycie
│   └── API.md                                      # Dokumentacja funkcji
└── examples/                                        # Przykłady użycia
    ├── custom-profile.bat                          # Przykład własnego profilu
    └── automation-script.ps1                       # Przykład automatyzacji
```

### Parametry skryptu

| Parametr | Typ | Domyślna | Opis |
|----------|-----|----------|------|
| `-Mode` | String | Interactive | Tryb działania (Interactive, Automatic, DiagnosticOnly, BenchmarkOnly) |
| `-LogLevel` | String | Info | Poziom logowania (Debug, Info, Warning, Error) |
| `-SkipBackup` | Switch | false | Pomiń automatyczne backupy (NIE ZALECANE) |
| `-ConfigFile` | String | null | Ścieżka do własnego pliku konfiguracji |
| `-GenerateReport` | Switch | false | Wygeneruj raport po zakończeniu |
| `-CheckForUpdates` | Switch | false | Sprawdź aktualizacje skryptu |

### Kody wyjścia

| Kod | Znaczenie |
|-----|-----------|
| 0 | Sukces |
| 1 | Brak uprawnień administratora |
| 2 | Niekompatybilny system |
| 3 | Błąd krytyczny podczas operacji |
| 4 | Użytkownik anulował operację |

---

## ❓ FAQ

### Ogólne

**Q: Czy ten skrypt jest bezpieczny?**  
A: Tak, ale zawsze zalecamy utworzenie backupu przed użyciem. Skrypt nie zawiera malware i jest open-source.

**Q: Czy mogę użyć tego skryptu na innych urządzeniach?**  
A: Skrypt jest zoptymalizowany dla MSI Claw. Użycie na innych urządzeniach może nie przynieść oczekiwanych rezultatów.

**Q: Jak często powinienem uruchamiać skrypt?**  
A: Wystarczy raz po zakupie urządzenia lub po reinstalacji Windows. Profile można używać codziennie.

### Optymalizacje

**Q: Jak bardzo poprawia się wydajność?**  
A: Zależnie od konfiguracji:
- FPS: +5-15% (po wyłączeniu Memory Integrity i optymalizacji)
- Bateria: +20-40% (z odpowiednimi profilami)
- Latency: -10-20% (HAGS + optymalizacje)

**Q: Czy zmiany są trwałe?**  
A: Tak, zmiany pozostają po restarcie. Możesz je cofnąć używając funkcji rollback.

**Q: Czy mogę przywrócić domyślne ustawienia?**  
A: Tak, użyj opcji "Przywróć z backupu" lub punkt przywracania systemu Windows.

### Profile

**Q: Jak działają profile wydajnościowe?**  
A: Profile ograniczają maksymalną częstotliwość CPU aby:
- Zmniejszyć zużycie energii
- Zwiększyć czas baterii
- Zmniejszyć przegrzewanie
- Utrzymać płynność gier

**Q: Który profil wybrać dla mojej gry?**  
A: Sprawdź `CZYTAJ_MNIE.txt` w folderze profili. Ogólne zasady:
- Gry AAA: AAA_MaxPerformance (zasilanie) lub AAA_Balanced (bateria)
- Gry sportowe: Sports_60FPS
- Gry competitive: Competitive_HighFPS
- Gry indie: Indie_UltraLong

### Problemy

**Q: Skrypt nie uruchamia się**  
A: Sprawdź czy:
1. Masz uprawnienia administratora
2. PowerShell 5.1 lub nowszy jest zainstalowany
3. Execution Policy pozwala na uruchomienie skryptów

**Q: Dostałem błąd "script is not digitally signed"**  
A: Uruchom PowerShell jako admin i wykonaj:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Q: Po optymalizacji gra działa wolniej**  
A: Spróbuj:
1. Przywróć ustawienia z backupu
2. Użyj innego profilu wydajnościowego
3. Sprawdź czy Over Boost jest włączony w MSI Center M

---

## 🆘 Wsparcie

### Zgłaszanie problemów

Jeśli napotkasz problem:

1. **Sprawdź FAQ** powyżej
2. **Przejrzyj logi** (`Opcja 9` w menu)
3. **Sprawdź GitHub Issues** - może ktoś już zgłosił ten problem
4. **Utwórz nowe issue** z:
   - Dokładnym opisem problemu
   - Krokami do reprodukcji
   - Logami (jeśli dotyczy)
   - Wersją skryptu i systemem

### Społeczność

- **GitHub:** [SecFERRO/MSI-Claw-Optimizer](https://github.com/SecFERRO/MSI-Claw-Optimizer)
- **Reddit:** r/MSIClaw
- **Discord:** MSI Claw Community

### Kontakt

Dla pilnych spraw:
- **Email:** [DO UZUPEŁNIENIA]
- **GitHub Issues:** [https://github.com/SecFERRO/MSI-Claw-Optimizer/issues](https://github.com/SecFERRO/MSI-Claw-Optimizer/issues)

---

## 👥 Autorzy

### Główny Deweloper

**Nieznany Nikomu Anonymousik**
- Role: Lead Developer, Architect
- Organization: SecFERRO DIVISION
- Contributions: Architecture, Core features, Optimization algorithms

### Patron

**SecFERRO DIVISION**
- Gaming Performance Engineering
- Research & Development
- Community Support

### Podziękowania

Specjalne podziękowania dla:
- MSI Claw Community
- Reddit r/MSIClaw contributors
- Beta testers
- Everyone who reported bugs and suggested features

---

## 📄 Licencja

Copyright © 2026 Nieznany Nikomu Anonymousik / SecFERRO DIVISION

**Educational Use Only**

Ten projekt jest udostępniony wyłącznie w celach edukacyjnych.

### Warunki użytkowania:

✅ **Wolno:**
- Używać dla celów osobistych
- Modyfikować dla własnych potrzeb
- Dzielić się linkiem do oficjalnego repozytorium

❌ **Nie wolno:**
- Używać komercyjnie bez zgody
- Usuwać informacji o autorstwie
- Dystrybuować zmodyfikowanych wersji jako własnych

### Wyłączenie odpowiedzialności

TEN SKRYPT JEST DOSTARCZANY "TAK JAK JEST", BEZ JAKICHKOLWIEK GWARANCJI, WYRAŹNYCH LUB DOROZUMIANYCH. W ŻADNYM WYPADKU AUTORZY NIE PONOSZĄ ODPOWIEDZIALNOŚCI ZA JAKIEKOLWIEK ROSZCZENIA, SZKODY LUB INNE ZOBOWIĄZANIA WYNIKAJĄCE Z UŻYCIA TEGO SKRYPTU.

---

## 🔄 Changelog

### v4.0.0 Professional Edition (2026-02-08)

#### Added
- Kompletne przepisanie architektury
- System automatycznych backupów
- Zaawansowane logowanie
- Rollback functionality
- Monitoring wydajności
- Eksport raportów (HTML/JSON/CSV)
- Walidacja sprzętu
- System powiadomień
- Compliance z PowerShell Analyzer
- Pełna dokumentacja

#### Changed
- Ulepszona struktura kodu
- Lepsza obsługa błędów
- Zoptymalizowane profile wydajnościowe
- Rozszerzone troubleshooting

#### Fixed
- Problemy z kompatybilnością Windows 11 24H2
- Błędy w konfiguracji hibernacji
- Issues z Memory Integrity
- Edge cases w backupach

### v3.0 ULTRA (poprzednia wersja)

Bazowa funkcjonalność optymalizacji

---

## 🚀 Roadmap

### v4.1 (Q2 2026)

- [ ] Auto-update functionality
- [ ] Benchmark suite
- [ ] Performance monitoring dashboard
- [ ] Cloud backup integration
- [ ] Multi-language support

### v4.5 (Q3 2026)

- [ ] GUI interface
- [ ] Scheduler for automated optimizations
- [ ] Advanced telemetry (opt-in)
- [ ] Integration with MSI Center M API

### v5.0 (Q4 2026)

- [ ] Machine learning for profile recommendations
- [ ] Community profile sharing
- [ ] Mobile companion app
- [ ] Extended hardware support

---

## 📞 Kontakt

Projekt: MSI Claw Optimizer  
Autor: Nieznany Nikomu Anonymousik  
Organizacja: SecFERRO DIVISION  

GitHub: https://github.com/SecFERRO/MSI-Claw-Optimizer  
Issues: https://github.com/SecFERRO/MSI-Claw-Optimizer/issues  

---

**Made with ❤️ for the MSI Claw Community**

*SecFERRO DIVISION - Gaming Performance Engineering*
