---
name: preflight
description: Run hashlib's CI gate locally, scoped to the current change — format, analyze, VM tests, plus node/integration/pana when the diff warrants them. Use before committing, when asked to "check", "verify", "preflight", or "is this ready", and as the final step of any code change.
argument-hint: "[quick|full]"
---

# Preflight: reproduce CI locally before it bounces

CI for this repo is strict: `dart format --set-exit-if-changed`,
`dart analyze --fatal-infos`, a 3-OS × {stable, 2.19} VM test matrix, a
consumer integration run, and (for releases) node tests + `pana` with zero
tolerance. This skill runs the equivalent locally, scaled to what actually
changed, and produces a pass/fail report.

## Step 1 — Determine scope

```sh
git status --short
git diff --name-only HEAD
```

Classify the changed files:

- **JS-sensitive** if any changed file: has a `_32bit`/`_64bit` sibling, is a
  dispatcher (contains `if (dart.library.js)`), lives in `lib/src/random/`,
  or touches `lib/src/core/` conditional exports (`hash_base*.dart`).
- **Consumer-visible** if `lib/src/hashlib.dart`, any `lib/*.dart` barrel, or
  `pubspec.yaml` changed.
- **Docs-only** if only `*.md`, `doc/`, or comments changed.

If the argument is `full`, treat everything as JS-sensitive AND
consumer-visible (this is the release-grade gate).

## Step 2 — Run the ladder (stop at first failure)

Always:

```sh
dart format --output=none --set-exit-if-changed .
dart analyze --fatal-infos
dart test -p vm
```

If `dart format` fails, run `dart format .` and re-check — formatting is the
one failure you fix automatically. Everything else you report.

Targeted first when iterating: `dart test -p vm test/<changed_algo>_test.dart`
is fine mid-task, but preflight always ends with the full VM suite —
cross-cutting tests (`test/core/`, `test/compare/`, `test/random/`) exercise
shared code paths.

If **JS-sensitive**:

```sh
dart test -p node
```

Caveat: many 64-bit vector tests are tagged `vm-only` and will be skipped on
node. If the change is inside a `_32bit` file or a dispatcher, additionally
prove equivalence explicitly: write a throwaway script in the scratchpad that
hashes a few dozen inputs of varied lengths (0, 1, blockLength−1, blockLength,
blockLength+1, 1000) and compare `dart run` output against
`dart test -p node` behavior or a node-run of the same script. Do not skip
this because the node suite was green — green-by-skip is not green.

If **consumer-visible**:

```sh
cd test_integration && dart pub get && dart run main.dart && cd ..
```

The run must complete without an exception; its output is prints, not
assertions, so scan stderr/exit code.

If `full`:

```sh
dart test            # all three platforms: vm, node, chrome
dart pub global run pana --exit-code-threshold 0
```

(If `pana` is not activated: `sh scripts/globals.sh` first.)

## Step 3 — Report

Produce a compact table: check | command | result. For any failure include
the exact failing output (trimmed to the relevant lines), the file:line it
points at, and a one-line hypothesis. Never mark the preflight passed with a
skipped rung — say which rungs ran and which were deemed out of scope and why.

## Hard rules

- Never "fix" a failure by adding `// ignore:`, skipping a test, changing an
  expected vector, or raising the SDK constraint. Report instead.
- A dirty `pubspec.yaml` version or `BENCHMARK.md` in the diff that the task
  didn't call for is itself a preflight failure — flag it.
- Preflight does not commit, tag, or push anything.
