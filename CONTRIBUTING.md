# Contributing to MSI Claw AIO Tweaker

First off, thank you for considering contributing to MSI Claw AIO Tweaker! 🎉

It's people like you that make this tool better for the entire MSI Claw community.

---

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
  - [Reporting Bugs](#reporting-bugs)
  - [Suggesting Features](#suggesting-features)
  - [Code Contributions](#code-contributions)
  - [Documentation](#documentation)
  - [Testing](#testing)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Pull Request Process](#pull-request-process)
- [Community](#community)

---

## 📜 Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inspiring community for all.

### Our Standards

**Positive behavior includes:**
- Using welcoming and inclusive language
- Being respectful of differing viewpoints
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards other community members

**Unacceptable behavior includes:**
- Trolling, insulting/derogatory comments, and personal or political attacks
- Public or private harassment
- Publishing others' private information without permission
- Other conduct which could reasonably be considered inappropriate

### Enforcement

Instances of abusive, harassing, or otherwise unacceptable behavior may be reported to:
- **GitHub Issues**: https://anonymousik.is-a.dev/msi-claw-aio-tweaker/issues
- **Reddit**: r/MSIClaw moderation team
- **Direct Contact**: [Report via GitHub Discussions](https://anonymousik.is-a.dev/msi-claw-aio-tweaker/discussions)

---

## 🤝 How Can I Contribute?

### Reporting Bugs

**Before submitting a bug report:**
1. Check the [existing issues](https://anonymousik.is-a.dev/msi-claw-aio-tweaker/issues)
2. Check the [troubleshooting guide](INSTALLATION.md#troubleshooting)
3. Ensure you're using the latest version

**When submitting a bug report, include:**

```markdown
**System Information:**
- MSI Claw Model: [A1M 135H / A1M 155H / 8 AI+ Lunar Lake]
- Windows Version: [Windows 11 24H2]
- BIOS Version: [E1T41IMS.109]
- Intel Arc Driver: [32.0.101.6877]
- Script Version: [5.0.0]

**Description:**
A clear and concise description of the bug.

**Steps to Reproduce:**
1. Go to '...'
2. Click on '...'
3. See error

**Expected Behavior:**
What you expected to happen.

**Actual Behavior:**
What actually happened.

**Logs:**
Attach logs from:
- `%LOCALAPPDATA%\MSI_Claw_Optimizer\Logs\`
- Screenshots of error messages

**Additional Context:**
Any other information that might be helpful.
```

**Bug Report Template**: Use the [Bug Report template](https://anonymousik.is-a.dev/msi-claw-aio-tweaker/issues/new?template=bug_report.md)

---

### Suggesting Features

**Before suggesting a feature:**
1. Check if it's already in the [roadmap](README.md#roadmap)
2. Search [existing feature requests](https://anonymousik.is-a.dev/msi-claw-aio-tweaker/issues?q=is%3Aissue+label%3Aenhancement)

**When suggesting a feature, include:**

```markdown
**Problem Statement:**
Describe the problem this feature would solve.

**Proposed Solution:**
Describe your proposed solution.

**Alternatives Considered:**
What alternative solutions have you considered?

**Use Cases:**
Describe specific use cases.

**Priority:**
How important is this feature to you?
- [ ] Critical (can't use tool without it)
- [ ] High (would significantly improve experience)
- [ ] Medium (nice to have)
- [ ] Low (minor improvement)

**Affected Users:**
Who would benefit from this feature?
```

**Feature Request Template**: Use the [Feature Request template](https://anonymousik.is-a.dev/msi-claw-aio-tweaker/issues/new?template=feature_request.md)

---

### Code Contributions

We welcome code contributions! Here's how:

#### 1. Fork and Clone

```bash
# Fork the repository on GitHub
# Then clone your fork:
git clone https://anonymousik.is-a.dev/msi-claw-aio-tweaker.git
cd msi-claw-aio-tweaker

# Add upstream remote:
git remote add upstream https://anonymousik.is-a.dev/msi-claw-aio-tweaker.git
```

#### 2. Create a Branch

```bash
# Update your fork:
git checkout main
git pull upstream main

# Create a feature branch:
git checkout -b feature/your-feature-name
# OR for bug fixes:
git checkout -b fix/issue-123-description
```

**Branch naming conventions:**
- `feature/` - new features
- `fix/` - bug fixes
- `docs/` - documentation changes
- `refactor/` - code refactoring
- `test/` - test additions/improvements
- `chore/` - maintenance tasks

#### 3. Make Your Changes

Follow our [Coding Standards](#coding-standards) (see below).

#### 4. Test Your Changes

```powershell
# Run the bootstrap in diagnostic mode:
.\MSI_Claw_Optimizer_v5.0_BOOTSTRAP.ps1 -Mode DiagnosticOnly

# Test your specific changes thoroughly
# Ensure no errors in logs

# If adding new functions, add Pester tests:
Invoke-Pester -Path tests/ -Output Detailed
```

#### 5. Commit Your Changes

```bash
# Stage your changes:
git add .

# Commit with a descriptive message:
git commit -m "feat: add GPU temperature monitoring

- Implement real-time GPU temperature tracking
- Add temperature warnings at 85°C
- Display in diagnostics report

Closes #123"
```

**Commit message format:**
```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, no logic change)
- `refactor`: Code refactoring
- `test`: Adding/updating tests
- `chore`: Maintenance tasks

**Example:**
```
fix(diagnostics): correct BIOS version detection on Lunar Lake

- Updated regex pattern to match Lunar Lake BIOS format
- Added fallback for non-standard BIOS versions
- Added unit test for version parsing

Fixes #456
```

#### 6. Push and Create Pull Request

```bash
# Push to your fork:
git push origin feature/your-feature-name

# Then create a Pull Request on GitHub
```

---

### Documentation

Documentation improvements are always welcome!

**Areas needing documentation:**
- User guides and tutorials
- Code comments and docstrings
- README improvements
- FAQ additions
- Troubleshooting guides
- Translation to other languages

**Documentation standards:**
- Use clear, concise language
- Include code examples where applicable
- Add screenshots for UI-related docs
- Keep formatting consistent with existing docs
- Test all command examples before submitting

---

### Testing

Help us maintain quality by testing!

**What to test:**
- New releases (beta testing)
- Pull requests
- Different hardware configurations
- Different Windows versions
- Edge cases and error scenarios

**How to become a beta tester:**
1. Join our [Discord community](https://discord.gg/msiclaw) (if available)
2. Comment on GitHub Discussions expressing interest
3. Follow beta release announcements

**Reporting test results:**
```markdown
**Test Configuration:**
- Hardware: MSI Claw A1M 155H
- Windows: 11 24H2 Build 26100.2314
- BIOS: E1T41IMS.109
- Arc Driver: 32.0.101.6877

**Test Scenario:**
Full optimization with Balanced profile

**Results:**
- ✅ All optimizations applied successfully
- ✅ No errors in logs
- ✅ FPS improved by 25% in Cyberpunk 2077
- ✅ Battery life improved from 45min to 95min

**Issues Found:**
None

**Screenshots:**
[Attach if applicable]
```

---

## 🛠️ Development Setup

### Prerequisites

- **Windows 10 21H2+ or Windows 11 22H2+**
- **PowerShell 5.1+** (PowerShell 7+ recommended for development)
- **Git** for version control
- **Code Editor**: VS Code with PowerShell extension (recommended)

### Optional Tools

- **Pester** (PowerShell testing framework): `Install-Module -Name Pester -Force`
- **PSScriptAnalyzer** (linting): `Install-Module -Name PSScriptAnalyzer -Force`
- **platyPS** (documentation): `Install-Module -Name platyPS -Force`

### Project Structure

```
msi-claw-aio-tweaker/
├── MSI_Claw_Optimizer_v5.0_BOOTSTRAP.ps1  # Main entry point
├── install.ps1                             # Auto-installer
├── config.json                             # Configuration
├── modules/
│   ├── Diagnostics.psm1                    # Auto-diagnostics
│   ├── Utils.psm1                          # Utility functions
│   ├── Optimization.psm1                   # Optimization functions
│   └── Backup.psm1                         # Backup system
├── tests/                                  # Pester tests
│   ├── Diagnostics.Tests.ps1
│   ├── Utils.Tests.ps1
│   ├── Optimization.Tests.ps1
│   └── Backup.Tests.ps1
├── docs/                                   # Documentation
│   ├── README.md
│   ├── INSTALLATION.md
│   ├── QUICK_START.md
│   └── API.md
├── .github/
│   ├── workflows/
│   │   └── ci.yml                          # GitHub Actions CI/CD
│   └── ISSUE_TEMPLATE/
│       ├── bug_report.md
│       └── feature_request.md
├── CHANGELOG.md
├── CONTRIBUTING.md                         # This file
├── SECURITY.md
└── LICENSE
```

### Setting Up Development Environment

```powershell
# 1. Clone the repository
git clone https://anonymousik.is-a.dev/msi-claw-aio-tweaker.git
cd msi-claw-aio-tweaker

# 2. Install development dependencies
Install-Module -Name Pester -Force -SkipPublisherCheck
Install-Module -Name PSScriptAnalyzer -Force

# 3. Run linter
Invoke-ScriptAnalyzer -Path . -Recurse -ReportSummary

# 4. Run tests
Invoke-Pester -Path tests/ -Output Detailed

# 5. Open in VS Code
code .
```

### VS Code Recommended Extensions

```json
{
  "recommendations": [
    "ms-vscode.powershell",
    "streetsidesoftware.code-spell-checker",
    "editorconfig.editorconfig",
    "yzhang.markdown-all-in-one"
  ]
}
```

---

## 📐 Coding Standards

### PowerShell Style Guide

We follow the [PowerShell Practice and Style Guide](https://poshcode.gitbook.io/powershell-practice-and-style/).

#### Key Points

**1. Naming Conventions**

```powershell
# ✅ GOOD - Approved verbs, PascalCase
function Get-SystemHealth { }
function Set-PerformanceProfile { }
function Test-HardwareCompatibility { }

# ❌ BAD - Unapproved verbs, wrong case
function Fetch-SystemHealth { }
function Apply-PerformanceProfile { }
function check-hardware { }
```

**2. Parameter Naming**

```powershell
# ✅ GOOD - Clear, descriptive, PascalCase
param(
    [string]$BackupId,
    [switch]$Force,
    [int]$MaxRetries = 3
)

# ❌ BAD - Unclear, abbreviations, wrong case
param(
    [string]$bid,
    [switch]$f,
    [int]$max_retries = 3
)
```

**3. Comment-Based Help**

```powershell
function Set-PerformanceProfile {
    <#
    .SYNOPSIS
        Applies a performance profile to the system.
    
    .DESCRIPTION
        Configures Windows power settings to match the specified
        performance profile (Performance, Balanced, or Battery).
    
    .PARAMETER Profile
        The profile to apply. Valid values: Performance, Balanced, Battery.
    
    .EXAMPLE
        Set-PerformanceProfile -Profile Balanced
        
        Applies the Balanced profile (17W TDP, 90-120min battery).
    
    .OUTPUTS
        [hashtable] Results of profile application.
    
    .NOTES
        Requires Administrator privileges.
    #>
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('Performance', 'Balanced', 'Battery')]
        [string]$Profile
    )
    
    # Function implementation...
}
```

**4. Error Handling**

```powershell
# ✅ GOOD - Comprehensive try-catch with cleanup
function Get-SystemInfo {
    try {
        $data = Get-CimInstance -ClassName Win32_Processor -ErrorAction Stop
        
        return @{
            Success = $true
            Data = $data
        }
    }
    catch {
        Write-Log "Failed to get system info: $_" -Level Error
        
        return @{
            Success = $false
            Error = $_.Exception.Message
        }
    }
    finally {
        # Cleanup code
    }
}

# ❌ BAD - No error handling
function Get-SystemInfo {
    $data = Get-CimInstance -ClassName Win32_Processor
    return $data
}
```

**5. Security - No Invoke-Expression**

```powershell
# ✅ GOOD - Use Start-Process
$procArgs = @('/export', $regPath, $outputFile, '/y')
$process = Start-Process -FilePath 'reg.exe' -ArgumentList $procArgs -NoNewWindow -Wait -PassThru

# ❌ BAD - Security vulnerability!
$command = "reg export `"$regPath`" `"$outputFile`" /y"
Invoke-Expression $command
```

**6. Input Validation**

```powershell
# ✅ GOOD - Validated parameters
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('Performance', 'Balanced', 'Battery')]
    [string]$Profile,
    
    [Parameter(Mandatory = $false)]
    [ValidateRange(1, 100)]
    [int]$MaxBackups = 10
)

# ❌ BAD - No validation
param(
    [string]$Profile,
    [int]$MaxBackups
)
```

**7. Output Formatting**

```powershell
# ✅ GOOD - Structured output
Write-Host "`n[OPTIMIZATION] Starting optimization..." -ForegroundColor Cyan
Write-Host "  [1/5] Configuring hibernation..." -ForegroundColor Gray
Write-Host "    ✓ Hibernation enabled" -ForegroundColor Green
Write-Host "    ✗ Failed to disable wake timers" -ForegroundColor Red

# ❌ BAD - Inconsistent, unclear
Write-Host "starting optimization"
Write-Host "configuring hibernation"
Write-Host "done"
```

### Code Quality Metrics

**Required:**
- PSScriptAnalyzer: 0 errors, <5 warnings
- Pester tests: >80% code coverage for new functions
- Function length: <100 lines (prefer <50)
- Cyclomatic complexity: <10
- Comments: 15-25% of LOC

**Tools:**

```powershell
# Run PSScriptAnalyzer
Invoke-ScriptAnalyzer -Path .\modules\ -Recurse -ReportSummary

# Run Pester tests with coverage
Invoke-Pester -Path tests/ -CodeCoverage modules\*.psm1 -CodeCoverageOutputFile coverage.xml

# Check function complexity (manual review)
# Keep functions focused on single responsibility
```

### Security Standards

**MUST:**
- ✅ No Invoke-Expression
- ✅ All downloads: SHA256 verification
- ✅ All user inputs: sanitized
- ✅ All external commands: via Start-Process
- ✅ All sensitive operations: logged to audit trail
- ✅ All files: integrity checked before execution

**MUST NOT:**
- ❌ Hardcode credentials
- ❌ Store passwords in plain text
- ❌ Execute arbitrary code from user input
- ❌ Download files without verification
- ❌ Modify system without backup

---

## 🔄 Pull Request Process

### Before Submitting

**Checklist:**
- [ ] Code follows PowerShell style guide
- [ ] All tests pass (`Invoke-Pester`)
- [ ] PSScriptAnalyzer shows 0 errors
- [ ] Comment-based help added for new functions
- [ ] Updated CHANGELOG.md
- [ ] Updated documentation if needed
- [ ] Tested on actual MSI Claw hardware (if possible)
- [ ] No merge conflicts with `main` branch

### PR Template

```markdown
## Description
Brief description of changes.

## Type of Change
- [ ] Bug fix (non-breaking change fixing an issue)
- [ ] New feature (non-breaking change adding functionality)
- [ ] Breaking change (fix or feature causing existing functionality to change)
- [ ] Documentation update

## Related Issues
Fixes #123
Relates to #456

## Testing
Describe how you tested your changes:
- [ ] Tested on MSI Claw A1M 155H, Windows 11 24H2
- [ ] All Pester tests pass
- [ ] PSScriptAnalyzer clean
- [ ] Manual testing completed

## Screenshots (if applicable)
[Add screenshots here]

## Checklist
- [ ] My code follows the project's coding standards
- [ ] I have performed a self-review
- [ ] I have commented my code where necessary
- [ ] I have updated the documentation
- [ ] I have added tests that prove my fix/feature works
- [ ] New and existing tests pass locally
- [ ] I have updated CHANGELOG.md
```

### Review Process

1. **Automatic Checks**: GitHub Actions runs tests and linters
2. **Code Review**: Maintainers review code quality and logic
3. **Testing**: Changes tested on real hardware if applicable
4. **Approval**: Requires 1 maintainer approval
5. **Merge**: Squash and merge to `main`

### After Merge

- Your contribution will be credited in CHANGELOG.md
- You'll be added to contributors list
- Changes included in next release

---

## 👥 Community

### Where to Get Help

- **GitHub Discussions**: https://anonymousik.is-a.dev/msi-claw-aio-tweaker/discussions
- **Reddit**: r/MSIClaw
- **MSI Forum**: https://forum-en.msi.com/index.php?forums/gaming-handhelds.182/

### Communication Channels

- **Bug Reports**: GitHub Issues
- **Feature Requests**: GitHub Issues with `enhancement` label
- **General Discussion**: GitHub Discussions
- **Real-time Chat**: Reddit r/MSIClaw (no official Discord yet)

### Getting Recognition

**Contributors are recognized in:**
- CHANGELOG.md (for each release)
- README.md (contributors section)
- Release notes
- Social media shoutouts (with permission)

**Top contributors may receive:**
- Early access to beta releases
- Direct collaboration on new features
- Invitation to maintainer team

---

## 📜 License

By contributing, you agree that your contributions will be licensed under the same license as the project (Educational Use Only).

---

## 🙏 Thank You!

Your contributions make MSI Claw AIO Tweaker better for everyone in the community.

**Questions?** Open a [GitHub Discussion](https://anonymousik.is-a.dev/msi-claw-aio-tweaker/discussions)

**Project Maintainer**: Anonymousik (SecFERRO Division)

---

*Last Updated: 2026-02-11*
