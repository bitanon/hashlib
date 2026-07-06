---
name: new-algorithm
description: Implement a new hash/MAC/KDF algorithm in hashlib end-to-end — sink, wrapper, exports, cited test vectors, compare tests, benchmark, README row, changelog. Use when asked to add, implement, or port a hash algorithm, checksum, MAC, or KDF.
argument-hint: "<algorithm-name> [spec-url]"
---

# New algorithm: the full wiring checklist

Adding an algorithm touches 8+ files in a fixed pattern. Missing any one of
them produces a "works on my test" change that fails on web, on pub.dev
scoring, or for downstream users. Work through the phases in order and do not
report done until the final checklist is all green.

## Phase 0 — Study before writing

1. Read the spec (RFC / FIPS / reference repo). Identify: block length,
   digest length(s), word size (32 or 64 bit!), endianness, padding scheme,
   whether it takes keys/salts/seeds.
2. Locate the **official test vectors** in the spec or NIST CAVP /
   reference repo. If none exist, generate vectors with an independent
   implementation (Python `hashlib`/`pycryptodome`, or `openssl dgst`) and
   record the exact generation command in a test-file comment. Never invent
   vectors. No vectors → stop and ask the maintainer.
3. Pick the closest existing algorithm as your template and mirror it:
   - simple 32-bit, single file: `lib/src/algorithms/md5.dart` + `lib/src/md5.dart`
   - family with shared core: `lib/src/algorithms/sha2/` + `lib/src/sha256.dart`
   - **64-bit words (needs web fallback)**: `lib/src/algorithms/blake2/`
     (`blake2b.dart` dispatcher, `blake2b_64bit.dart`, `blake2b_32bit.dart`)
   - XOF / configurable output: `lib/src/shake128.dart` (const builder + `.of()`)
   - MAC: `lib/src/poly1305.dart`, `lib/src/hmac.dart` (extension getter)
   - KDF: `lib/src/pbkdf2.dart` (extensions on hash/MAC types)
   - int-returning checksum: `lib/src/xxh32.dart` (`xxh32code()`)

## Phase 1 — Implementation sink

Create `lib/src/algorithms/<family>/<name>.dart` (or flat
`lib/src/algorithms/<name>.dart` for single-file algorithms):

- Copyright header (current year):
  `// Copyright (c) 2026, Sudipto Chandra` /
  `// All rights reserved. Check LICENSE file for details.`
- `class <Name>Hash extends BlockHashSink` (or `MACSinkBase` /
  `KeyDerivatorBase`), implementing `hashLength`, `$update`, `$finalize`,
  and a `reset()` that fully restores initial state.
- Performance idioms are mandatory, not optional: state in
  `Uint32List`/`Uint64List`; reuse the inherited `buffer`/`sbuffer`/`bdata`
  views; hoist state into local `int` vars inside `$update` and write back
  once; `>>>` with `& 0xFFFFFFFF` masking for 32-bit rotations;
  `@pragma('vm:prefer-inline')` on small hot helpers; zero allocation per
  block.
- Validate constructor inputs with `ArgumentError` (exact lengths, ranges),
  mirroring Blake2b's checks.

**If the algorithm uses 64-bit words**, write THREE files:
`<name>_64bit.dart` (native ints, VM), `<name>_32bit.dart` (lo/hi 32-bit
pairs, JS-safe), and the dispatcher `<name>.dart` containing only:

```dart
export '<name>_64bit.dart' if (dart.library.js) '<name>_32bit.dart';
```

Both variants must produce byte-identical output; Phase 3 proves it.

## Phase 2 — Public wrapper + exports

Create `lib/src/<name>.dart`:

```dart
// Copyright (c) 2026, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/<family>/<name>.dart';
import 'package:hashlib/src/core/block_hash.dart';

/// <One-paragraph description citing the spec.>
///
/// <Design/History sentence.> Standardized in [<SPEC>][ref].
///
/// [ref]: <spec-url>
const BlockHashBase <name> = _<Name>();

class _<Name> extends BlockHashBase {
  const _<Name>();

  @override
  final String name = '<DISPLAY-NAME>';

  @override
  <Name>Hash createSink() => <Name>Hash();
}

/// Generates a <NAME> checksum in hexadecimal
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
/// - [uppercase] defines if the hexadecimal output should be in uppercase
String <name>sum(
  String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return <name>.string(input, encoding).hex(uppercase);
}
```

Conventions: wrapper class private; const constructor; `name` a final field
(display form like `'SHA-256'`, `'XXH64'`); presets named `<algo><size>`;
non-crypto hashes also get `int <name>code(...)`; doc comments must carry a
**WARNING** line if not cryptographically secure (copy md5.dart's wording).

Then register it everywhere:

1. `lib/src/hashlib.dart` — add `export 'src/<name>.dart';` in alphabetical
   order. (This is what makes it public.)
2. `lib/src/core/registry.dart` — add `_norm(<name>.name): <name>,` to
   `_buildRegistry()`, plus common aliases. (Deprecated but maintained.)
3. Re-export the sink from the wrapper if advanced users need it
   (`export 'algorithms/.../<name>.dart' show <Name>Hash;` — see blake2b.dart).

## Phase 3 — Tests

`test/<name>_test.dart`, modeled on `test/sha256_test.dart`:

- Header comment citing the vector source (RFC section / NIST CAVP file /
  reference-repo path / generation command).
- `final tests = { input: expectedHex }` covering: empty string, single
  char, short strings, and lengths at blockLength−1 / blockLength /
  blockLength+1, plus one long input.
- Groups: known cases, streaming (`<name>.bind(stream).first`), argument
  validation (`throwsArgumentError` loops over invalid key/salt/seed lengths
  0..99 where applicable), `reset()` reuse.
- If crypto / pointycastle / hash implements it:
  `test/compare/compare_<name>_test.dart` tagged
  `// ignore: library_annotations` + `@Tags(['vm-only'])`, comparing over
  random inputs of lengths 0–99 (copy `compare_md5_test.dart`).
- If 64-bit twins exist: the KAT map runs on all platforms (do NOT tag it
  vm-only unless it needs dart:io) — that is exactly what proves the _32bit
  variant. Run `dart test -p node test/<name>_test.dart` and confirm the
  tests executed rather than skipped.

## Phase 4 — Benchmark, README, CHANGELOG

- `benchmark/<name>.dart`: copy `benchmark/sha256.dart`'s shape —
  `HashlibBenchmark` + one class per competing package that implements the
  algorithm, each with the standard names (`CryptoBenchmark`,
  `PointyCastleBenchmark`, `HashBenchmark`), and a standalone `main()` over
  the three standard conditions `[5<<20,10]`, `[1<<10,5000]`, `[10,100000]`.
  Wire it into `benchmark/benchmark.dart` only if at least one comparison
  package exists. Do NOT regenerate BENCHMARK.md.
- `README.md`: add a row to the matching Features table —
  `| \`<name>\` | \`<name>sum\` | [<SPEC-NAME>](<spec-url>) |` — keeping the
  table's existing column pattern.
- `CHANGELOG.md`: bullet under the unreleased/top section in house style,
  e.g. `- New hash algorithm: \`<name>\` #<issue>` — but do NOT create a new
  `# X.Y.Z` heading or touch `pubspec.yaml` version; releases are the
  maintainer's call.

## Phase 5 — Gate

Run the `preflight` skill in `full`-enough scope: format, analyze
`--fatal-infos`, `dart test -p vm`, `dart test -p node` (mandatory when twins
exist), integration smoke test. Then report with the checklist from
AGENTS.md's "New algorithm" quality bar, each box explicitly checked, plus
which vector source each test cites. Leave everything uncommitted — the
maintainer reviews the working tree and decides when to commit (AGENTS.md
ground rule 6).
