---
name: release
description: Prepare a hashlib release — changelog section, version bump, release-grade verification, bump commit — and hand the tag push to the maintainer. Also orchestrates the cross-repo cascade (convertlib → hashlib → cipherlib).
argument-hint: "[X.Y.Z | patch | minor | major]"
disable-model-invocation: true
---

# Release: prepare everything, push nothing

Pushing a `v*` tag to `bitanon/hashlib` triggers `release.yml`: version check
→ full test matrix + pana → `dart pub publish -f` (irreversible) → GitHub
Release with the **top CHANGELOG section as its notes**. This skill prepares a
release so that pipeline cannot fail, then stops at the tag.

## Step 0 — Sanity

```sh
git fetch origin
git status --short
git log --oneline origin/master..HEAD ; git log --oneline HEAD..origin/master
git tag --sort=-v:refname | head -3
```

- Behind origin → `git pull --ff-only` first.
- Unrelated dirty files → stop and ask what to include.
- Confirm which commits since the last tag are going into this release:
  `git log --oneline v<last>..HEAD` — this is the raw material for the
  changelog section.

## Step 1 — Pick the version

From the argument, or infer from the unreleased changes and confirm with the
maintainer: breaking exported-API change → major; new algorithm/feature →
minor; fixes, dependency bumps, internal refactors → patch. When inferring,
state the choice and the reason before proceeding.

## Step 2 — CHANGELOG.md

Add a new section at the very top, matching house style exactly:

```markdown
# X.Y.Z

- New hash algorithm: `foo` #NN
- Fix `Bar` finalization on empty input.
- Update `convertlib` dependency to A.B.C
```

Rules: H1 `# X.Y.Z` (no "v", no date); `-` bullets, imperative, capitalized;
identifiers and filenames in backticks; nested details as 2-space-indented
sub-bullets; breaking changes as `- [**Breaking Changes**]:` with a sub-list.
Write it for users — this text becomes the GitHub release notes verbatim
(the workflow extracts everything between the first and second `# ` heading).
Every user-visible commit since the last tag must be represented; internal
churn (CI tweaks, test refactors) is omitted.

## Step 3 — pubspec.yaml

- Set `version: X.Y.Z`.
- If this release exists to pick up a new `convertlib`, bump the caret
  (`convertlib: ^A.B.C`) and run `dart pub get`.

## Step 4 — Release-grade verification (all must pass)

```sh
dart format --output=none --set-exit-if-changed .
dart analyze --fatal-infos
dart test                     # all platforms: vm, node, chrome
cd test_integration && dart pub get && dart run main.dart && cd ..
dart pub global run pana --exit-code-threshold 0
dart pub publish --dry-run
```

(`pana` missing → `sh scripts/globals.sh`.) Any failure stops the release;
report it and do not proceed to Step 5. Do not shortcut `dart test` to
`-p vm` here — the release workflow runs node and beta-SDK jobs that local
VM-only runs won't predict.

## Step 5 — Triple check, then commit

The three strings that must be byte-identical, because CI hard-fails on
mismatch and the changelog job publishes the top section:

1. `pubspec.yaml` → `version: X.Y.Z`
2. `CHANGELOG.md` first heading → `# X.Y.Z`
3. The tag that will be pushed → `vX.Y.Z`

Verify mechanically:

```sh
grep '^version:' pubspec.yaml
head -1 CHANGELOG.md
```

Commit in house style — the maintainer invoking this skill is the explicit
authorization for this one bump commit (it never extends to Step 6's pushes):

```sh
git add pubspec.yaml CHANGELOG.md
git commit -m "Bump version to X.Y.Z"
```

(Include `and update convertlib dependency to A.B.C` in the message when
that applies — see `git log` for precedent.)

## Step 6 — Hand off the trigger

**Do not run these.** Print them for the maintainer:

```sh
git push origin master
git tag vX.Y.Z
git push origin vX.Y.Z     # ← this publishes to pub.dev
```

If the maintainer says push in this session, push `master` and the tag, then
watch the pipeline: `gh run watch` (or `gh run list --workflow=release.yml
--limit 1`), and report the result including the pub.dev publish step.

## Cross-repo cascade

When the change originates in `convertlib` (branch `master`) or must
reach `cipherlib` (branch `main` — and note it has its own AGENTS.md). Locate
the sibling checkout first — try `../convertlib` / `../cipherlib` relative
to this repo, else search or ask; clone from `github.com/bitanon/<name>` if
absent:

1. Release `convertlib` first (same procedure; same workflow files).
2. Wait until the new version is live:
   `curl -s https://pub.dev/api/packages/convertlib | jq -r .latest.version`
3. In hashlib: bump `convertlib: ^A.B.C`, `dart pub get`, adapt code,
   changelog entry `- Update \`convertlib\` dependency to A.B.C`,
   release hashlib.
4. In cipherlib: bump `hashlib: ^X.Y.Z`, same drill.

Never substitute a committed path `dependency_overrides` for this chain; a
temporary override is fine for local verification but must not reach a
commit — `dart pub publish --dry-run` in Step 4 would flag it anyway.
