# Security Policy

## Project Information

**Project:** MSI Claw AIO Tweaker  
**Repository:** https://anonymousik.is-a.dev/msi-claw-aio-tweaker  
**GitHub:** https://github.com/anonymousik/msi-claw-aio-tweaker  
**Maintainer:** Anonymousik (SecFERRO Division)

## 🛡️ Security Overview

MSI Claw AIO Tweaker takes security seriously. This document outlines our security policies, threat model, and vulnerability reporting procedures.

**Current Security Status**: ✅ **Hardened** (v5.0.0)

---

## 📋 Table of Contents

- [Supported Versions](#supported-versions)
- [Security Features](#security-features)
- [Threat Model](#threat-model)
- [Known Security Considerations](#known-security-considerations)
- [Reporting a Vulnerability](#reporting-a-vulnerability)
- [Security Best Practices](#security-best-practices)
- [Security Audit History](#security-audit-history)

---

## 🔄 Supported Versions

We actively maintain security updates for the following versions:

| Version | Supported          | Security Status | End of Support |
| ------- | ------------------ | --------------- | -------------- |
| 5.0.x   | ✅ Full support    | Hardened        | TBD            |
| 4.0.x   | ⚠️ Security fixes  | Vulnerable      | 2026-08-11     |
| 3.0.x   | ❌ Not supported   | Vulnerable      | 2026-02-20     |
| < 3.0   | ❌ Not supported   | Vulnerable      | EOL            |

**Recommendation**: Upgrade to v5.0.0+ immediately for security fixes.

---

## 🔐 Security Features

### Implemented in v5.0.0

#### 1. File Integrity Verification
```powershell
# All downloaded files verified with SHA256
Test-FileIntegrity -FilePath $file -ExpectedHash $hash
Get-SecureDownload -Url $url -OutputPath $path -ExpectedHash $hash
```

**Protects against:**
- Man-in-the-Middle attacks
- File tampering
- Malicious file substitution

#### 2. No Command Injection
```powershell
# ✅ Secure (v5.0.0):
$procArgs = @('/export', $regPath, $outputFile, '/y')
Start-Process -FilePath 'reg.exe' -ArgumentList $procArgs -NoNewWindow -Wait

# ❌ Vulnerable (v4.0.0):
Invoke-Expression "reg export `"$regPath`" `"$outputFile`" /y"
```

**Protects against:**
- Command injection (CVE-2021-26701 class)
- Arbitrary code execution
- Privilege escalation

#### 3. Input Sanitization
```powershell
# All user inputs sanitized
$safeInput = Read-HostSanitized -Prompt "Enter description" -AllowedChars Description
```

**Protects against:**
- SQL injection (if database added in future)
- Path traversal attacks
- Script injection

#### 4. HTTPS-Only Downloads
```powershell
# Enforces HTTPS for all downloads
if ($Url -notmatch '^https://') {
    throw "Only HTTPS URLs are allowed (security policy)"
}
```

**Protects against:**
- Man-in-the-Middle attacks
- Unencrypted data transmission
- DNS spoofing

#### 5. Digital Signature Verification (Optional)
```powershell
# Verifies Authenticode signatures on .exe/.msi/.dll files
$signature = Get-AuthenticodeSignature -FilePath $file
if ($signature.Status -ne 'Valid') {
    throw "Invalid digital signature"
}
```

**Protects against:**
- Unsigned malware
- Tampered executables
- Supply chain attacks

#### 6. Audit Logging
```powershell
# All critical operations logged
Write-AuditLog -Action "Registry modification" -Details @{
    Path = $regPath
    OldValue = $oldValue
    NewValue = $newValue
}
```

**Provides:**
- Forensic trail
- Compliance evidence
- Incident investigation data

#### 7. Least Privilege Principle
```powershell
# Only elevates when necessary
if (-not (Test-IsElevated)) {
    Invoke-PrivilegeEscalation
    exit
}
```

**Reduces:**
- Attack surface
- Privilege escalation risks
- Accidental system damage

#### 8. Secure Backup System
```powershell
# Automatic backup before all modifications
$backupId = New-SystemBackup -Description "Before optimization"
```

**Provides:**
- Rollback capability
- Recovery from errors
- Audit trail

---

## ⚠️ Threat Model

### Threat Actors

#### 1. Malicious Insider
**Capabilities**: Local admin access, code modification
**Motivation**: System damage, data theft
**Mitigations**:
- Code signing (planned)
- Audit logging
- Integrity verification

#### 2. Network Attacker
**Capabilities**: MITM position, DNS spoofing
**Motivation**: Malware distribution
**Mitigations**:
- HTTPS-only downloads
- SHA256 verification
- No plaintext credentials

#### 3. Supply Chain Attacker
**Capabilities**: Compromise dependencies
**Motivation**: Widespread malware distribution
**Mitigations**:
- Minimal dependencies
- SHA256 verification
- Digital signature checking (planned)

#### 4. Opportunistic Attacker
**Capabilities**: Exploit public vulnerabilities
**Motivation**: System compromise
**Mitigations**:
- No Invoke-Expression
- Input sanitization
- Regular security updates

### Attack Vectors

#### 1. File Download Attack (MITIGATED ✅)
**Vector**: Replace legitimate file with malware during download
**Impact**: System compromise, data theft
**Likelihood**: Medium
**Severity**: Critical

**Mitigations**:
- ✅ HTTPS-only enforcement
- ✅ SHA256 hash verification
- ✅ Digital signature checking (optional)
- ✅ Automatic file deletion on verification failure

**Residual Risk**: Low

---

#### 2. Command Injection (MITIGATED ✅)
**Vector**: Inject malicious commands via Invoke-Expression
**Impact**: Arbitrary code execution, privilege escalation
**Likelihood**: High (v4.0), None (v5.0)
**Severity**: Critical

**Mitigations**:
- ✅ Eliminated all Invoke-Expression usage
- ✅ All external commands via Start-Process
- ✅ Argument list sanitization
- ✅ Input validation

**Residual Risk**: None

**Example Exploit (v4.0 - FIXED):**
```powershell
# VULNERABLE CODE (v4.0):
$regPath = Read-Host "Enter registry path"
Invoke-Expression "reg export `"$regPath`" output.reg"

# Attack:
# User enters: HKLM\Software"; calc.exe; "
# Result: Calculator launched (proof of code execution)
```

---

#### 3. Path Traversal (PARTIALLY MITIGATED ⚠️)
**Vector**: Access files outside intended directories
**Impact**: Information disclosure, unauthorized file access
**Likelihood**: Low
**Severity**: Medium

**Mitigations**:
- ✅ Input sanitization for file paths
- ✅ Validation of path characters
- ⚠️ Not all paths fully validated

**Residual Risk**: Low

**Recommendations**:
- Implement `Resolve-Path` validation
- Restrict write operations to approved directories

---

#### 4. Denial of Service (NOT MITIGATED ❌)
**Vector**: Exhaust system resources
**Impact**: System unresponsiveness
**Likelihood**: Low
**Severity**: Low

**Mitigations**:
- ⚠️ Timeout on long operations (partial)
- ❌ No rate limiting
- ❌ No resource quotas

**Residual Risk**: Medium

**Recommendations**:
- Implement operation timeouts
- Add resource usage monitoring
- Rate limit I/O operations

---

#### 5. Privilege Escalation (MITIGATED ✅)
**Vector**: Gain admin rights without UAC prompt
**Impact**: Unauthorized system modifications
**Likelihood**: Medium
**Severity**: High

**Mitigations**:
- ✅ Explicit UAC prompt (Invoke-PrivilegeEscalation)
- ✅ No credential storage
- ✅ Audit logging of privilege changes

**Residual Risk**: Low

---

#### 6. Data Exfiltration (PARTIALLY MITIGATED ⚠️)
**Vector**: Steal sensitive system information
**Impact**: Privacy violation, reconnaissance for further attacks
**Likelihood**: Low
**Severity**: Medium

**Mitigations**:
- ✅ No network transmission of data (except updates)
- ✅ No telemetry by default
- ⚠️ Logs may contain sensitive system info

**Residual Risk**: Low

**Recommendations**:
- Implement log sanitization
- Add option to disable all logging
- Encrypt audit logs

---

### Risk Matrix

| Attack Vector | Likelihood | Severity | Risk Level | Status |
|---------------|------------|----------|------------|--------|
| File Download | Medium | Critical | **High** | ✅ Mitigated |
| Command Injection | None | Critical | **None** | ✅ Mitigated |
| Path Traversal | Low | Medium | **Low** | ⚠️ Partial |
| Denial of Service | Low | Low | **Low** | ❌ Not Mitigated |
| Privilege Escalation | Medium | High | **Medium** | ✅ Mitigated |
| Data Exfiltration | Low | Medium | **Low** | ⚠️ Partial |

**Overall Risk Level**: **Low** (v5.0.0)

---

## 🚨 Known Security Considerations

### Administrator Privileges Required
**Issue**: Script requires full Administrator privileges

**Why**: Modifies system-level settings (registry, power config, services)

**Risks**:
- If script is compromised, attacker has full system access
- User error could damage system

**Mitigations**:
- Code signing (planned) - users can verify authenticity
- Automatic backups before changes
- Audit logging of all actions
- Open source - community can review code

**Recommendation**: Only run scripts from trusted sources

---

### Registry Modifications
**Issue**: Script modifies critical registry keys

**Why**: Necessary for optimizations (HVCI, Game DVR, GPU Scheduling)

**Risks**:
- Incorrect values could cause system instability
- Malicious modifications could disable security features

**Mitigations**:
- Automatic backup before modifications
- Rollback capability (Restore-SystemBackup)
- Validation of all registry values
- Audit logging

**Recommendation**: Review changes in CHANGELOG.md before running

---

### No Code Signing (Yet)
**Issue**: Scripts are not digitally signed

**Why**: Requires paid certificate ($200-400/year)

**Risks**:
- Users cannot verify script authenticity
- Possible impersonation attacks
- Windows SmartScreen warnings

**Mitigations**:
- Open source - code can be reviewed
- SHA256 hashes published (when available)
- Official distribution only via https://anonymousik.is-a.dev/msi-claw-aio-tweaker

**Planned**: Code signing certificate in v5.1.0

**Workaround**: Users can verify file hashes against published SHA256 values

---

### PowerShell Execution Policy
**Issue**: Script requires ExecutionPolicy bypass

**Why**: PowerShell blocks unsigned scripts by default

**Risks**:
- Users may disable ExecutionPolicy globally (security risk)

**Mitigations**:
- Documentation recommends `-Scope Process` (temporary)
- Never recommends global ExecutionPolicy changes

**Best Practice**:
```powershell
# ✅ GOOD (temporary, one-time):
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# ❌ BAD (permanent, dangerous):
Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy Unrestricted
```

---

## 📝 Reporting a Vulnerability

### Reporting Process

**DO:**
1. **Email privately** (if email available) or create **private GitHub Security Advisory**
2. Include detailed description, steps to reproduce, and impact assessment
3. Allow 90 days for fix before public disclosure
4. Provide your contact info for follow-up

**DON'T:**
1. ❌ Open public GitHub issue for security vulnerabilities
2. ❌ Disclose vulnerability on social media
3. ❌ Exploit vulnerability maliciously

### What to Include

```markdown
**Vulnerability Type**: [e.g., Command Injection, XSS, etc.]

**Affected Version(s)**: [e.g., v5.0.0, v4.0.0-4.0.5]

**Severity**: [Critical / High / Medium / Low]

**Description**:
Detailed description of the vulnerability.

**Steps to Reproduce**:
1. ...
2. ...
3. ...

**Proof of Concept**:
[Code snippet or screenshots]

**Impact**:
What can an attacker achieve?

**Suggested Fix**:
[Optional] Your recommendation for fixing the issue.

**Disclosure Timeline**:
Are you planning to publicly disclose? When?
```

### Response Timeline

- **Initial Response**: Within 48 hours
- **Triage**: Within 7 days
- **Fix Development**: Within 30 days (critical), 90 days (others)
- **Release**: ASAP after fix completion
- **Public Disclosure**: After patch release + 14 days

### Coordinated Disclosure

We follow **responsible disclosure**:
1. Reporter notifies us privately
2. We acknowledge receipt within 48 hours
3. We develop and test a fix
4. We release patch
5. Reporter may publish after 90 days OR after patch release + 14 days (whichever is sooner)

### Bounty Program

**Current Status**: No formal bug bounty program

**Recognition**:
- Credit in CHANGELOG.md and SECURITY.md
- Mention in release notes
- Public thank you (with permission)

**Planned**: Bounty program when project secures funding

---

## 🔒 Security Best Practices for Users

### Before Running

1. **Verify Source**
   ```powershell
   # Only download from official repository:
   # https://anonymousik.is-a.dev/msi-claw-aio-tweaker
   ```

2. **Check File Integrity** (when hashes published)
   ```powershell
   Get-FileHash -Path "MSI_Claw_Optimizer_v5.0_BOOTSTRAP.ps1" -Algorithm SHA256
   # Compare with published hash
   ```

3. **Review Code** (if you have PowerShell knowledge)
   ```powershell
   # Read the script before running:
   Get-Content MSI_Claw_Optimizer_v5.0_BOOTSTRAP.ps1 | less
   ```

4. **Create System Restore Point**
   ```powershell
   # Manual backup:
   Checkpoint-Computer -Description "Before MSI Claw Optimization"
   ```

### While Running

1. **Use Temporary ExecutionPolicy**
   ```powershell
   # ✅ GOOD:
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

   # ❌ BAD:
   Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy Unrestricted
   ```

2. **Review Changes**
   - Read console output carefully
   - Understand what each optimization does
   - Check audit logs after execution

3. **Start with Diagnostic Mode**
   ```powershell
   # Test without making changes:
   .\MSI_Claw_Optimizer_v5.0_BOOTSTRAP.ps1 -Mode DiagnosticOnly
   ```

### After Running

1. **Review Audit Logs**
   ```powershell
   # Check what was changed:
   Get-Content "$env:LOCALAPPDATA\MSI_Claw_Optimizer\Logs\audit_*.log"
   ```

2. **Verify System Stability**
   - Restart computer
   - Test games and applications
   - Monitor for errors

3. **Keep Backups**
   ```powershell
   # Don't delete backups immediately:
   Get-ChildItem "$env:USERPROFILE\MSI_Claw_Backups"
   ```

---

## 📜 Security Audit History

### v5.0.0 Security Audit (2026-02-11)

**Audited by**: Anonymousik (SecFERRO Division)

**Scope**: Full codebase review, threat modeling, penetration testing

**Findings**:

| ID | Severity | Issue | Status |
|----|----------|-------|--------|
| SA-001 | Critical | Command injection via Invoke-Expression | ✅ Fixed |
| SA-002 | High | No file integrity verification | ✅ Fixed |
| SA-003 | High | Hardcoded URLs without fallback | ✅ Fixed |
| SA-004 | Medium | Path traversal in file operations | ⚠️ Partial |
| SA-005 | Medium | No input sanitization | ✅ Fixed |
| SA-006 | Low | Excessive administrator privileges | ℹ️ By design |
| SA-007 | Low | No rate limiting | ℹ️ Accepted risk |

**Recommendations Implemented**:
- ✅ Eliminated all Invoke-Expression usage
- ✅ Implemented SHA256 verification
- ✅ Added input sanitization
- ✅ Implemented audit logging
- ✅ Added automatic backups
- ✅ HTTPS-only enforcement

**Recommendations Pending**:
- ⏳ Code signing certificate (v5.1.0)
- ⏳ Automated security testing (v5.1.0)
- ⏳ Regular penetration testing (ongoing)

---

### v4.0.0 Security Issues (LEGACY)

**Known Vulnerabilities** (DO NOT USE v4.0.0):

| CVE ID | Severity | Issue | Affected Versions |
|--------|----------|-------|-------------------|
| N/A* | Critical | Command injection via Invoke-Expression | v4.0.0 - v4.0.5 |
| N/A* | High | No file integrity verification | v4.0.0 - v4.0.5 |
| N/A* | Medium | No input sanitization | v4.0.0 - v4.0.5 |

\* Not assigned CVE IDs (educational project, no formal CVE submission)

**Mitigation**: **Upgrade to v5.0.0 immediately**

---

## 🔐 Cryptographic Standards

### Hashing
- **Algorithm**: SHA256 (SHA-2 family)
- **Purpose**: File integrity verification
- **Collision Resistance**: 2^128 (secure)

### Future Considerations
- **Code Signing**: SHA256 with RSA (planned)
- **Backup Encryption**: AES-256 (planned for v6.0)

---

## 📞 Security Contact

**Project Maintainer**: Anonymousik (SecFERRO Division)

**Reporting Channel**: GitHub Security Advisories (preferred)
- https://anonymousik.is-a.dev/msi-claw-aio-tweaker/security/advisories

**Alternative**: GitHub Issues (for non-critical issues only)
- https://anonymousik.is-a.dev/msi-claw-aio-tweaker/issues

**Community Discussion**: Reddit r/MSIClaw

---

## 📚 Security Resources

### For Users
- [INSTALLATION.md](INSTALLATION.md) - Safe installation guide
- [QUICK_START.md](QUICK_START.md) - Secure quick start
- [CHANGELOG.md](CHANGELOG.md) - Security fixes per release

### For Developers
- [CONTRIBUTING.md](CONTRIBUTING.md) - Security coding standards
- [PowerShell Security Best Practices](https://learn.microsoft.com/en-us/powershell/scripting/learn/security-features)
- [OWASP Secure Coding Practices](https://owasp.org/www-project-secure-coding-practices-quick-reference-guide/)

---

## ⚖️ Disclaimer

MSI Claw AIO Tweaker is provided "AS IS" without warranty of any kind. Users assume all risks associated with running system optimization scripts. Always create backups before making system changes.

**Not affiliated with**: MSI, Intel, or Microsoft

---

**Last Updated**: 2026-02-11  
**Security Policy Version**: 1.0  
**Next Review**: 2026-05-11
