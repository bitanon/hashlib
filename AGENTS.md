# AGENTS.md

Operating manual for AI coding agents working in this repository. This file
lives at the repo root and applies to the entire repository.

`hashlib` is a pure-Dart library of cryptographic and non-cryptographic hash
functions, MACs, KDFs, OTPs, and random generators, published to pub.dev as
`package:hashlib` (github: `bitanon/hashlib`). Two product values drive every
decision here: **correctness against official test vectors** and **raw
performance**. When they conflict with elegance, they win.

It is the middle package of a three-package family by the same maintainer:

```
convertlib  →  hashlib (this repo)  →  cipherlib
```

The siblings live at `github.com/bitanon/convertlib` and
`github.com/bitanon/cipherlib`. They are often checked out next to this repo
(`../convertlib`, `../cipherlib`), but never assume: when a task needs
one, locate the checkout first, and if there is none, ask or clone.

Inter-package dependencies are **hosted on pub.dev, never path deps**. Local
edits to `convertlib` are invisible here until published *and* the caret
constraint in `pubspec.yaml` is bumped. See "Cross-repo changes" at the end.

## Six ground rules (never violate)

1. **Dart SDK floor is 2.19** (`sdk: '>=2.19.0 <4.0.0'`). No records, no
   patterns, no `switch` expressions, no `sealed`/`base`/`final class`
   modifiers, no Dart 3 anything. The local SDK is usually a much newer 3.x,
   so "it runs here" proves nothing; CI tests on 2.19.
2. **Web/JS is a first-class platform.** JavaScript has no 64-bit integers.
   Any 64-bit arithmetic must ship a `_32bit` twin selected by conditional
   import (details below). `dart test -p node` is the proof.
3. **Zero runtime dependencies except `convertlib`.** Adding any other
   runtime dependency is a maintainer decision, not yours.
4. **Everything exported is frozen API** — including `$`-prefixed members
   (`$process`, `$update`, `$finalize`) and even misspellings
   (`HashBase.stringStraem` is stable public API). Renames and signature
   changes are breaking changes that require deprecation and a version
   decision by the maintainer.
5. **Never publish.** `dart pub publish` and `git push --tags` trigger an
   irreversible pub.dev release via CI. Only the maintainer pulls that
   trigger.
6. **Never `git commit` or `git push` on your own.** Finishing a task is not
   permission to commit it, and permission granted for one change does not
   carry over to the next. Commit or push only when the maintainer's
   **immediate message** explicitly asks for it; otherwise leave the work in
   the working tree and say so.

## Map of the codebase

```
lib/hashlib.dart              Barrel → lib/src/hashlib.dart (the real aggregator)
lib/codecs.dart               Re-exports package:convertlib verbatim
lib/random.dart               Barrel → src/random.dart + src/uuid.dart
lib/src/<algo>.dart           PUBLIC WRAPPER: const instance, `<algo>sum()`
                              helpers, doc comments (e.g. sha256.dart)
lib/src/algorithms/<family>/  IMPLEMENTATION SINK: compression function,
                              round constants, finalization (e.g. sha2/sha2.dart)
lib/src/core/                 Abstractions: HashBase, HashDigestSink,
                              BlockHashBase/BlockHashSink (block_hash.dart),
                              MACHash* (mac_base.dart), KeyDerivatorBase
                              (kdf_base.dart), HashDigest (extends
                              ByteCollector from convertlib)
lib/src/random/               RNG + UUID, platform-split (generator_vm/_js)
test/<algo>_test.dart         Known-answer tests, one file per algorithm
test/compare/                 Differential tests vs crypto/pointycastle/hash
                              (all tagged vm-only)
test/core/, test/random/      Infrastructure tests
test/fixures/                 CSV/text vector fixtures (yes, "fixures")
test_integration/             Separate mini-package; consumer smoke test run
                              with `dart run main.dart` (not package:test)
benchmark/                    Per-algo benchmarks + benchmark.dart aggregator
                              that generates BENCHMARK.md
scripts/                      *.sh + *.bat twins: coverage, benchmark, globals
.github/workflows/            test.yml (CI), release.yml (tag-triggered
                              pub.dev publish), release-test.yml (big matrix)
```

Generated, gitignored, do not edit or commit: `doc/`, `coverage/`, `build/`,
`.dart_tool/`, `pubspec.lock`.

**How an algorithm is wired** (the two-layer rule): a public
`XyzHash extends BlockHashSink` sink in `lib/src/algorithms/...` implementing
`$update`/`$finalize`/`hashLength`; a wrapper in `lib/src/xyz.dart` holding a
private `_Xyz extends BlockHashBase` class with `createSink() => XyzHash()`, a
`const BlockHashBase xyz = _Xyz();` singleton, and a `xyzsum()` string helper;
an `export 'src/xyz.dart';` line in `lib/src/hashlib.dart`. Sink classes stay
public — the RNG and SHAKE generators instantiate them directly.

## Commands

Run from the repo root.

| Task                        | Command                                        |
| --------------------------- | ---------------------------------------------- |
| Install deps                | `dart pub get`                                 |
| Format (CI-gating)          | `dart format .` (check: `--output=none --set-exit-if-changed .`) |
| Analyze (CI-gating)         | `dart analyze --fatal-infos`                   |
| Tests, default              | `dart test -p vm`                              |
| One file                    | `dart test -p vm test/sha256_test.dart`        |
| By name                     | `dart test -p vm -N "pattern"`                 |
| Web/JS proof                | `dart test -p node` (chrome also configured)   |
| Consumer smoke test         | `cd test_integration && dart pub get && dart run main.dart` |
| Coverage                    | `sh scripts/coverage.sh` (needs `sh scripts/globals.sh` once) |
| Full BENCHMARK.md regen     | `sh scripts/benchmark.sh` — reference hardware only, see mistakes |
| One algorithm's benchmark   | `dart compile exe benchmark/<algo>.dart -o build/<algo> && ./build/<algo>` |
| pub.dev score check         | `dart pub global run pana --exit-code-threshold 0` |

Default to `-p vm`. Run `-p node` in addition whenever the change touches a
file with a `_32bit`/`_64bit` twin, a conditional import, `lib/src/random/`,
or anything else that could behave differently on JS. Full three-platform runs
(`dart test`) are for release verification, not iteration.

Step-by-step procedures for the recurring tasks — local CI gate
(`preflight`), adding an algorithm (`new-algorithm`), benchmarking (`bench`),
and release preparation (`release`) — live in `.claude/skills/<name>/SKILL.md`.
They auto-load as skills in Claude Code; every other agent should read the
relevant file as plain-Markdown reference documentation before performing
that task.

## Conventions

### Code

- **Copyright header** on every `lib/` and `test/` Dart file, first two lines:
  `// Copyright (c) <year>, Sudipto Chandra` /
  `// All rights reserved. Check LICENSE file for details.`
  Existing files keep their year; new files use the current year.
- **Naming**: files snake_case matching the primary type. Sinks are
  `<Algo>Hash` or `<Algo>Sink`. Wrapper classes are private (`_SHA256`).
  Presets are `<algo><size>` (`blake2b256`, `shake128_256`, `sha512t224`).
  Dots in algorithm names become `d` in class names (`SHA3d256`). Template
  methods that subclasses implement are `$`-prefixed (`$process`, `$update`,
  `$finalize`) — public but semantically internal, still frozen API.
- **Public API shape** (follow it exactly when adding algorithms):
  - crypto hash → `const` instance + `<name>sum(String, [Encoding?, bool uppercase])` returning hex;
  - non-crypto hash/checksum → also `<name>code()` returning `int`;
  - parameterized algo → const builder with `.of(...)` (see `shake128.dart`);
  - MAC → extension getter (`sha256.hmac.by(key)`, `blake2b256.mac.by(key)`);
  - KDF → extensions on the hash/MAC types (see `pbkdf2.dart`).
- **Const singletons**: wrapper classes need const constructors, all-final
  fields; `name` is a `final String` field, not a getter.
- **Typed data on hot paths**: state in `Uint32List`/`Uint64List` (free
  wraparound), reuse `BlockHashSink`'s zero-copy views `sbuffer`
  (Uint32List) and `bdata` (ByteData) instead of allocating; hoist state into
  local `int` variables inside `$update`, write back once; `>>>` plus
  `& _mask32` for 32-bit rotations; `@pragma('vm:prefer-inline')` on hot
  helpers. Allocate buffers once in the constructor; `reset()` reuses them.
- **Endianness is per-algorithm and explicit** (MD5 little-endian, SHA-2
  big-endian). Follow the spec, not the neighboring file.
- **Errors**: typed only — `ArgumentError` for bad input lengths/values,
  `StateError` for use-after-close, `UnsupportedError` for platform gaps.
  Never throw strings (`only_throw_errors` lint).
- **Platform splits** use conditional import/export triads only:
  `import 'x_64bit.dart' if (dart.library.js) 'x_32bit.dart';` for word size,
  `export 'stub.dart' if (dart.library.io) 'io.dart';` for dart:io. Never
  import `dart:io` directly in shared code.
- **Lints**: `analysis_options.yaml` = `package:lints/recommended` + extras
  (`always_declare_return_types`, `only_throw_errors`, `comment_references`,
  `combinators_ordering`, ...). The two commented-out rules are off for Dart
  2.19 compatibility — leave them. Doc references `[LikeThis]` must resolve.

### Tests

- One `test/<algo>_test.dart` per algorithm. Shape: top-level
  `final tests = { input: expectedHex }` map of known-answer vectors, then
  `group('<ALGO> test', ...)` with cases for the map, streams, and argument
  validation (`throwsArgumentError` loops over invalid lengths).
- **Every vector cites its source** (RFC / FIPS / NIST / reference project
  URL) in a comment. No invented vectors.
- Cross-check new crypto algorithms in `test/compare/compare_<algo>_test.dart`
  against `crypto`/`pointycastle`/`hash` over random inputs of lengths 0–99,
  when any of those packages implements it.
- Tags: `@Tags(['vm-only'])` (preceded by `// ignore: library_annotations`)
  for anything using `dart:io`, file fixtures, or heavy fuzzing; `node-only`
  for dart2js-only behavior. Large/slow vectors (million-'a') are `skip: true`.
- `allow_duplicate_test_names: false` is enforced; per-test timeout is 1m
  (override per-file where needed, see `test/random/`).

### Git, changelog, docs

- Work happens directly on `master`. A `v1` maintenance branch exists for
  Dart SDK 2.14+ backports — never touch it unless explicitly asked.
- **Commits**: imperative, capitalized, no trailing period, backticks around
  identifiers, issue refs appended as `#NN`. Examples from history:
  `Refactor \`HashDigest\` class to extend \`ByteCollector\``,
  `CRC with different polynomials #33`.
- **CHANGELOG.md**: newest at top, heading `# X.Y.Z` (H1, no "v", no date),
  `-` bullets, imperative and capitalized, identifiers/filenames in
  backticks, nested sub-bullets indented 2 spaces. Breaking changes get a
  `- [**Breaking Changes**]:` bullet with a sub-list. Only user-visible
  changes get entries. The **top section becomes the GitHub release notes
  verbatim** — write it for users.
- **README.md**: new algorithms get a row in the matching `## Features`
  table (columns `Algorithm | Available methods | Source`, where Source cites
  the spec) and, if user-facing enough, a usage line in the example blocks.
  `example/hashlib_example.dart` mirrors the README usage section — keep them
  in sync.

## Mistakes you will make here, and the rule that prevents each

1. **Writing Dart 3.** You'll reach for records, patterns, or a switch
   expression because your training says they're idiomatic.
   *Rule: SDK floor is 2.19. `dart analyze --fatal-infos` must pass — it
   enforces language version 2.19 — and you must not raise the SDK constraint
   to make an error go away.*

2. **Fixing the 64-bit file and calling it done.** SHA-512, Blake2b, Keccak,
   XXH64, XXH3, Argon2, Poly1305 all have `_64bit`/`_32bit` twins; editing
   one silently breaks the other platform, and VM tests won't catch it.
   *Rule: if the file you touched has a `_32bit` or `_64bit` sibling, make
   the equivalent change in both, then run `dart test -p vm` AND
   `dart test -p node` before claiming success. Note: their vector tests are
   tagged `vm-only`, so also sanity-check via a compare/round-trip test or a
   quick script on node. Exception: the `_32bit` files of xxh64/xxh3/xxh128
   are intentional stubs that throw `UnimplementedError` — the xxHash-64
   family is unsupported on web by design (`test/xxh_web_test.dart` locks
   this in).*

3. **"Improving" a public name.** `stringStraem` is misspelled and
   `test/fixures/` too. You'll want to fix them.
   *Rule: exported names, signatures, and `$`-methods change only through
   `@Deprecated('...')` + replacement + changelog breaking-change entry +
   explicit maintainer approval. Renames of directories/files inside `test/`
   are cheap but pointless churn — leave them.*

4. **Silencing the analyzer instead of fixing the code.**
   *Rule: no new `// ignore:` comments. The three sanctioned patterns already
   in the codebase are: `library_annotations` before `@Tags`,
   `constant_identifier_names` for consts like `hmac_sha256`, and
   `deprecated_member_use_from_same_package` inside `registry.dart`. Anything
   else means fix the underlying issue.*

5. **Breaking const-ness.** Adding a non-final field or computed getter to a
   wrapper class breaks `const sha256 = _SHA256();` and every downstream
   const expression.
   *Rule: wrapper classes stay const-constructible; new configuration goes
   into constructor parameters stored in final fields.*

6. **Testing with invented vectors.** A hash that matches its own test proves
   nothing.
   *Rule: every known-answer test cites an official source (RFC, FIPS, NIST
   CAVP, the reference implementation's repo) in a comment. If you cannot
   find official vectors, generate them with an independent implementation
   (e.g. Python's hashlib/cryptography, openssl) and record the exact command
   in the test file comment.*

7. **Editing generated output.** `doc/api/` looks like documentation;
   `coverage/` and `BENCHMARK.md` look like reports to update.
   *Rule: `doc/`, `coverage/`, `build/` are gitignored machine output —
   never edit, never commit. `BENCHMARK.md` is tracked but generated: it is
   only regenerated wholesale by `scripts/benchmark.sh` on the maintainer's
   reference machine (Apple M3 Pro). Never commit benchmark numbers from any
   other machine unless explicitly asked.*

8. **Registry drift.** Adding an algorithm but forgetting one of its
   registration points — or conversely, spending effort on the deprecated
   registry.
   *Rule: follow the new-algorithm checklist in the quality bar below, in
   order. `lib/src/core/registry.dart` is `@Deprecated` and slated for
   removal: add the entry for completeness, but never build features on it.*

9. **Assuming the sibling repos are path-linked.** You'll edit
   `convertlib` locally and expect hashlib's tests to see it.
   *Rule: they won't. Dependencies are hosted. For local experiments you may
   add a temporary `dependency_overrides:` with a path — but it must never be
   committed, and the real fix ships via the publish chain (see Cross-repo
   changes).*

10. **Skipping, deleting, or loosening a failing test to get green.**
    *Rule: a failing test is a finding, not an obstacle. Report it with
    output. Modifying expected vector values is forbidden unless you can cite
    the official source proving the old value wrong.*

11. **Forgetting the format gate.** CI fails on
    `dart format --set-exit-if-changed`; your hand-written alignment will
    bounce.
    *Rule: run `dart format .` as the last edit step, every time.*

12. **Touching CI workflows as a side effect.** `release.yml` publishes to
    pub.dev on tag push; a small "improvement" can ship a broken release
    pipeline.
    *Rule: `.github/workflows/` changes only when the task is explicitly
    about CI, and never bundled with code changes.*

13. **Printing secrets or state.** Debug `print()` of keys, seeds, or
    internal state left in library code.
    *Rule: `lib/` contains no `print` and no logging. Debug output belongs in
    tests or scratch scripts only. MAC/digest equality uses the provided
    `verify()`/`isEqual` helpers, not early-exit byte loops.*

## Quality bar per deliverable

### Any code change (base gate — all must pass before you claim done)

- [ ] `dart format --output=none --set-exit-if-changed .` exits 0
- [ ] `dart analyze --fatal-infos` exits 0 (zero infos, not just zero errors)
- [ ] `dart test -p vm` fully green
- [ ] `dart test -p node` green as well IF the change touches a 32/64-bit
      twin, a conditional import, random/, or codecs interop
- [ ] No new `// ignore:`, no new runtime deps, no SDK constraint change
- [ ] New files carry the copyright header
- [ ] Diff contains no changes to `doc/`, `coverage/`, `BENCHMARK.md`,
      `.github/workflows/`, or `pubspec.yaml` version unless that was the task

### Bug fix

- [ ] Base gate
- [ ] A regression test exists that **fails on the pre-fix code** (state in
      your summary how you verified this — e.g. stash the fix and run it)
- [ ] CHANGELOG.md entry if the bug was user-visible
- [ ] If the bug was wrong hash output: the fixed value is backed by an
      official vector, cited

### New algorithm

- [ ] Sink class in `lib/src/algorithms/<family>/`, extending the right base
      (`BlockHashSink` / `MACSinkBase` / `KeyDerivatorBase`)
- [ ] If it uses 64-bit words: `_64bit` + `_32bit` twins + dispatcher file
      with the conditional import; both implementations produce identical
      output
- [ ] Public wrapper `lib/src/<name>.dart`: const singleton(s), `<name>sum()`
      (and `<name>code()` if non-crypto), doc comment citing the spec with a
      `[ref]: url` link
- [ ] `export 'src/<name>.dart';` added to `lib/src/hashlib.dart`
- [ ] Registry entry in `lib/src/core/registry.dart` (one line, deprecated
      but maintained)
- [ ] `test/<name>_test.dart` with cited official vectors: empty input,
      short inputs, block-boundary lengths (blockLength−1, blockLength,
      blockLength+1), a long input, streaming, and argument validation
- [ ] `test/compare/compare_<name>_test.dart` if crypto/pointycastle/hash
      implements it (tagged `vm-only`)
- [ ] README feature-table row with spec citation in Source column
- [ ] `benchmark/<name>.dart` following `benchmark/_base.dart` conventions,
      wired into `benchmark/benchmark.dart` if comparable packages exist
- [ ] CHANGELOG.md entry
- [ ] Base gate, including `-p node` when there are twins

### Performance change

- [ ] Base gate, `-p vm` AND `-p node` (perf work is where web breaks hide)
- [ ] Before/after numbers from the *same machine, same power state*, using
      the single-algorithm benchmark (`benchmark/<algo>.dart`), quoted in
      your summary; a change without measured improvement is reverted
- [ ] Output identical to pre-change for the full vector suite (perf work
      must never alter results)
- [ ] BENCHMARK.md untouched unless explicitly asked

### Docs / README / example

- [ ] Code samples actually run (`dart run example/<file>.dart`)
- [ ] `dart analyze --fatal-infos` still 0 (`comment_references` checks doc
      links)
- [ ] README tables, `example/`, and doc comments say the same thing

### Release prep (only when asked — see escalation)

- [ ] pubspec `version:`, top CHANGELOG heading `# X.Y.Z`, and intended tag
      `vX.Y.Z` are the identical string (CI hard-fails on pubspec≠tag)
- [ ] CHANGELOG top section reads as release notes (it becomes them)
- [ ] Full gate: format, analyze, `dart test` (all platforms), integration
      smoke test, `pana --exit-code-threshold 0`
- [ ] Commit message `Bump version to X.Y.Z ...`
- [ ] STOP before tagging/pushing — the maintainer pushes the tag

## When uncertain: escalation rules

**Proceed without asking** (reversible, inside the task's scope):
internal refactors that keep every exported signature; adding tests and
vectors; doc-comment fixes; performance work that passes the perf quality
bar; anything already covered by an explicit instruction in this file.
"Proceed" never includes `git commit` or `git push` — those happen only when
the current message explicitly asks (ground rule 6).

**Stop and ask the maintainer first** — these are the maintainer's
decisions, not yours:

- Any change to an exported name, signature, or behavior (including
  `$`-methods and anything a downstream package could observe)
- Adding/removing/upgrading any dependency, or touching the SDK constraint
- Version bumps, CHANGELOG heading for a new version, anything release-ish
- Edits to `.github/workflows/`, `.pubignore`, `analysis_options.yaml`,
  `dart_test.yaml`
- Committing a regenerated `BENCHMARK.md`
- Anything on the `v1` branch
- A test vector that seems wrong: present the official source and the
  conflict; do not resolve it unilaterally

**Never do, even if asked-sounding** (only an explicit, unambiguous request
from the maintainer counts): `dart pub publish`, `git push --tags` or pushing
any `v*` tag, force-push, deleting tests, weakening lints, committing
`dependency_overrides`.

**When something fails and you don't know why**: reproduce it minimally,
report the exact command and output, and state your best hypothesis. Do not
paper over it (retry-until-green, skip-tag it, or widen a tolerance).

## Cross-repo changes (convertlib → hashlib → cipherlib)

When a change spans packages, the only path is the publish chain, in
dependency order. For each hop: implement + full local gate → maintainer
publishes (version bump, changelog, tag) → downstream repo bumps the caret
constraint (`convertlib: ^X.Y.Z` here; `hashlib: ^X.Y.Z` in cipherlib),
runs `dart pub get`, adapts code, gets its own changelog entry ("Update
`convertlib` dependency to X.Y.Z"), and is released in turn.

For local development ahead of a publish, a temporary path
`dependency_overrides:` is acceptable **in the working tree only** — it must
be removed before commit (CI and pana will not tolerate it).

Repo differences to remember: hashlib and convertlib use branch `master`;
cipherlib uses `main`. cipherlib has its own agent guide (`AGENTS.md`) —
follow it when working there. hashlib is the only one testing on `chrome`.
