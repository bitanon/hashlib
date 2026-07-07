# Security policy

## Supported versions

Security fixes are published in new releases on [pub.dev](https://pub.dev/packages/hashlib). We recommend using the latest release compatible with your Dart SDK. Older major or minor lines may not receive backports; ask in a report if you need a fix on a specific version line.

## Reporting a vulnerability

**Do not** open a public issue, pull request, or discussion for undisclosed security vulnerabilities. That can put users at risk before a fix is available. Use **Report a vulnerability** (private vulnerability reporting) in the [**Security** tab](https://github.com/bitanon/hashlib/security).

## What to include

Helpful information for triage and fixes:

- A short description of the issue and the affected component (e.g. hash function, MAC, key derivation, random generator, API usage).
- The **affected version(s)** or commit, if known, and your environment (Dart SDK, platform) if relevant.
- **Steps to reproduce** or a minimal proof of concept, when it is safe to share.
- **Impact** (confidentiality, integrity, availability) and any suggested mitigation, if you have one.

## Our process

- We aim to **acknowledge** new reports within a few business days.
- We will work with you on **coordinated disclosure**: we prefer to fix the issue, ship a release, and only then publish an advisory, unless there is a strong reason to do otherwise.
- We may ask follow-up questions or for a re-test of a pre-release fix.

## Scope (in)

Reports we want to see include:

- Incorrect cryptographic behavior, side-channel or constant-time issues in the library implementation (when applicable to the Dart/VM/JS runtimes in scope of this project).
- Bugs in message authentication (e.g. HMAC, Poly1305 tag handling) or password hashing / key derivation (e.g. Argon2, bcrypt, scrypt, PBKDF2) that affect security.
- Weaknesses in the secure random number generators or UUID generation that affect unpredictability.
- **Dependency**: critical issues solely in the [`convertlib`](https://pub.dev/packages/convertlib) package should be reported to that project; you may still notify us if you believe we need a version bound or our integration is wrong.

## Scope (out of scope or lower priority)

- Theoretical issues without a plausible impact for this package’s use on supported platforms.
- Use of non-cryptographic algorithms (e.g. MD5, SHA-1, CRC, xxHash) in contexts that require cryptographic security — their documentation already warns against this.
- Vulnerabilities in your application that only misuse the public API (we may still document hardening, but the fix may be in your code).
- Automated tool output without a clear, reproducible security impact.

We appreciate responsible disclosure and will credit reporters in release notes or advisories when they wish to be named.
