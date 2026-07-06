---
name: bench
description: Measure hashlib performance properly — per-algorithm before/after comparison for optimization work, compiled-exe runs, correct interpretation. Use when optimizing, when asked "is this faster", to compare against crypto/pointycastle/hash, or before/after any change to a hot path ($update, $process, sink internals).
argument-hint: "<algorithm> [baseline-git-ref]"
---

# Bench: trustworthy before/after numbers

Performance is a headline feature of this package (BENCHMARK.md is marketing).
But JIT warmup, machine load, and cross-machine variance produce lying
numbers. This skill produces numbers you can actually compare — and keeps
you from committing misleading ones.

## The measurement rules

- **Compile to exe** — the official script benchmarks AOT-compiled code, and
  JIT numbers differ wildly. Never compare a JIT run against an exe run.
- **Same machine, same session** for before vs after. Numbers from different
  machines (or laptop battery vs powered) are not comparable.
- **Three runs, take the median** of the hashlib line. Single runs swing.
- **Correctness before speed**: `dart test -p vm test/<algo>_test.dart` must
  pass before any number counts. An optimization that changes output is a bug.

## Procedure

### 1. Baseline (pre-change)

If the working tree already contains the optimization, get the baseline from
git — default `HEAD`, or the ref given in the arguments:

```sh
git stash push -m bench-baseline        # only if working tree is dirty
dart compile exe benchmark/<algo>.dart -o build/bench_before
git stash pop                           # restore the change
```

(For comparing two committed refs use a worktree instead:
`git worktree add /tmp/hashlib-base <ref>` … compile there … then
`git worktree remove /tmp/hashlib-base`.)

### 2. Candidate (post-change)

```sh
mkdir -p build
dart compile exe benchmark/<algo>.dart -o build/bench_after
```

### 3. Run both, interleaved, 3× each

```sh
for i in 1 2 3; do ./build/bench_before; ./build/bench_after; done
```

Each `benchmark/<algo>.dart` has a standalone `main()` that prints all three
standard conditions (5MB×10, 1KB×5000, 10B×100000) with `[best]` markers and
`Nx fast`/`Nx slow` annotations relative to hashlib. If no per-algorithm file
exists for the code you changed, check which algorithms flow through the
touched code path (e.g. `BlockHashSink.$process` affects everything) and
benchmark 2–3 representative ones: one 32-bit (sha256), one 64-bit twin
(sha512 or blake2b), one small-input-sensitive (md5 at 10B).

### 4. Report

A table per condition: `condition | before | after | delta%`, using the
median hashlib rate. State machine + `dart --version`. Verdict rules:

- delta within ±3%: call it noise, not a win.
- regression > 3% on any condition: flag it prominently; an optimization
  that speeds up 5MB but slows 10B inputs is a trade-off the maintainer
  decides, not you.
- Also glance at the competitor lines: if hashlib lost a `[best]` marker it
  previously held, say so.

### 5. Web numbers (only when relevant)

If the change touched a `_32bit` file, the VM benchmark says nothing about
it — the `_32bit` code never runs on the VM. Compile to JS and run on node:

```sh
dart compile js benchmark/<algo>.dart -o build/bench.js -O2
node build/bench.js
```

Compare before/after the same way. (Competitor packages may not support
node; ignore their lines if they crash.)

## Hard rules

- **Never commit BENCHMARK.md from this skill.** The committed file is
  regenerated wholesale by `sh scripts/benchmark.sh` on the maintainer's
  reference machine only, and only when the maintainer asks. If your diff
  contains BENCHMARK.md changes, revert them.
- `build/` is gitignored — leave artifacts there, never commit them.
- Report a failed optimization honestly and recommend reverting it; "it
  should be faster in theory" does not survive contact with the median.
