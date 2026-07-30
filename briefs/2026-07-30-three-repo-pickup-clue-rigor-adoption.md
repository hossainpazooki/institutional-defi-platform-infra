# Handoff — three-repo pick-up, CLUE security-scan repair + toolkit adoption

**Date:** 2026-07-30 (UTC; local evening of 2026-07-29).
**Multi-repo session** — lands in the shared briefs folder because no single
repo owns the work. CLUE's own slice already has an in-repo brief:
[`upstream-label-correction/docs/handoff/2026-07-30-security-scan-repair-and-ledger-adoption.md`](../upstream-label-correction/docs/handoff/2026-07-30-security-scan-repair-and-ledger-adoption.md)
(committed `52de35d`) — read that one for CLUE detail; this brief covers the
cross-repo state and the two repos that brief does not own.

**Newest commit per repo — pick-up measures drift from these:**

| Repo | HEAD | vs origin | Tree |
|---|---|---|---|
| `upstream-label-correction` (CLUE) | `52de35d` | 0 0 | clean |
| `correct-shaped-lies` (CSL) | `bdb182f` | 0 0 | clean |
| `passed-vs-true-demo` (PVT) | `eb2a8f4` | 0 0 | clean |

## Current state

### upstream-label-correction (CLUE) — all green, nothing open that is actionable

- **[built, verified]** Weekly `Security Scan` is **green on all four jobs**,
  confirmed by dispatching the real workflow, not by local reasoning. It had
  failed 2026-07-20 and 2026-07-27 with no code change between.
  `re-verify:` `gh run view 30507863914 --json conclusion,jobs -q '"\(.conclusion) | \(.jobs | map("\(.name)=\(.conclusion)") | join(" "))"'`
- **[built, verified]** `go-audit` repair — `x/text v0.29.0 → v0.39.0`
  (`7d6a36f`), clearing the *reachable* `GO-2026-5970`. Proven non-vacuous: the
  same probe on the pre-bump `go.mod` exits 3 naming the advisory; post-bump,
  exit 0. The `go` directive stayed `1.25.0`, so no ci.yml/Dockerfile pin ripple.
  `re-verify:` `cd intent-controller && GOTOOLCHAIN=go1.26.5 "$(go env GOPATH)/bin/govulncheck" ./...`
- **[built, verified]** `dependency-audit` repair — `pip install -U
  "setuptools>=83.0.0"` step ahead of the audit (`b0c94db`), clearing
  `PYSEC-2026-3447` without a second `--ignore-vuln`.
  `re-verify:` `grep -n -A2 'Upgrade build-backend' .github/workflows/security-scan.yml`
- **[built, verified]** Toolkit adoption, and its gate is **no longer vacuous** —
  this was the named gap at write time of the in-repo brief and it is now
  discharged: all 6 ledger files are tracked (`3f227b4`, `52de35d`), so the
  append-only leg compares against a real HEAD instead of passing on absence.
  `re-verify:` `git ls-files docs/learnings docs/handoff | wc -l` → `6`, then
  `node <toolkit>/scripts/check-learnings.mjs docs/learnings` → `learnings: clean (3 entries)`
- **[built, verified]** Local gates: `python -m pytest` 244 passed / 15 skipped;
  Go `build`/`vet`/`test` all ok.
- **[open, permanent]** Blind-test oracle (labels withheld by the challenge) and
  the GCP billing-console SKU confirmation (no billing export exists; console
  login only). Neither is a task.
- **[open, not started]** Gap #1 provenance cross-check against the official
  precisionFDA portal, and the 4 deploy secrets in `DEPLOY.md` — the latter
  aimed at a now-decommissioned project, so decide if it should exist at all.

### correct-shaped-lies (CSL) — green, one blocked item

- **[built, verified]** `pytest -q` → 67 passed, 1 skipped.
  `re-verify:` `python -m pytest -q`
- **[built, verified]** Never-fires claim holds from raw data: `honesty`,
  `complexity_budget`, `passed_too_easily`, `retry_score_anomaly` all 0/180;
  `static_safety` 60 + `cross_stage_consistency` 30 account for all catches.
  `re-verify:` `python scripts/verify_never_fires.py`
- **[built, this session]** The two loose assessment docs are now committed
  (`bdb182f`) — previously they existed in no commit anywhere.
  `re-verify:` `git log --oneline -1 -- docs/clue-risk-assessment.md`
- **[planned, blocked]** The DSPy/MIPROv2 model-driven adversary run — still the
  single open item, still blocked on the same three things: `dspy` is not
  installed, no LM API key is in the environment, and the model/budget choice
  has not been made.
  `re-verify:` `python -c "import dspy"` → `ModuleNotFoundError`

### passed-vs-true-demo (PVT) — **two reds, both introduced tonight, both benign in production**

- **[RED, by design]** `npm run ingest` now **fails**: both siblings moved past
  their pins tonight. This is the pin-drift invariant firing exactly as
  intended, not a defect.
  `re-verify:` `npm run ingest` → `csl HEAD (bdb182f) has drifted from the pinned sha (1d4c8e7)`
- **The drift is data-safe, and this is established, not assumed.** All six
  ingested artifacts hash-match their `PINNED_HASH` values under
  `canonicalBytes` semantics, with a negative control proving the check can tell
  sameness from difference. Both sibling commits touched only docs
  (`bdb182f`: 2 new files; CLUE `a777cca..52de35d`: ledger + brief + go.mod).
  **Do not cite the csl `commitSha` as the warrant here** — `results/` is
  gitignored, so a sha-range diff over those paths is empty whether or not they
  changed. The hashes are the warrant.
  `re-verify:` recompute sha256 over `canonicalBytes` for the six paths in
  `PINNED_HASH` (`scripts/ingest.ts:55-62`) and compare.
- **[RED, real defect]** The learnings ledger gate fails. Isolated to one line
  in `docs/learnings/2026-07-24-pin-cannot-cover-untracked-artifacts.md`:
  `status: verified — defect CLOSED same day, see \`resolution:\` below`. The
  gate's regex is enum-anchored to end-of-line, so the qualifier reds it.
  Normalizing only that line makes the folder `CLEAN (3 entries)`.
  `re-verify:` `node <toolkit>/scripts/check-learnings.mjs docs/learnings`
- **[built, verified]** Everything else still holds: 48 unit tests, clean static
  export, 6/6 Playwright, and production live (`/` and `/paper` both 200, F1
  present, no editorial leakage). **Production is insulated from the ingest red**
  — `vercel.json` pins the build command to `next build`, bypassing the
  `prebuild → ingest` hook, and serves the committed `public/data/*.json`.

## Locked decisions

1. **Fix a vulnerability finding, don't suppress it — unless there is nothing to
   upgrade to.** Both repairs were version bumps. The one standing
   `--ignore-vuln` (diskcache/`CVE-2025-69872`) is justified in-workflow because
   no fixed release exists.
2. **The build-backend upgrade lives in the workflow, not `pyproject.toml`.**
   `pip-audit` audits the installed environment; a manifest pin would not change
   what it sees on the runner.
3. **`AGENTS.md` canonical, `CLAUDE.md` a stub that imports it.** Reason:
   duplicated content drifts. The harness does not load `AGENTS.md` natively, so
   the stub is required, not decorative.
4. **Ledger adoption is forward-only.** CLUE's two pre-existing briefs were not
   migrated; they stay put with their SUPERSEDED/RESOLVED banners and the index
   carries one pointer. Reason: backfilling invents anchors never captured.
5. **PVT's provenance sha is a deliberate pin, not auto-tracked HEAD** (PVT's
   own locked decision, unchanged). Reason still holds and just proved itself
   again tonight: the gate fired the moment two siblings moved, forcing a human
   re-pin decision instead of a silent re-stamp. **Do not "fix" tonight's red by
   reverting to auto-tracking.**
6. **Never cite a commit sha as evidence a CSL artifact is unchanged** — cite the
   content hash. `results/` is gitignored and has never been tracked.

## Reuse map

- **CLUE's brief and ledgers:** `upstream-label-correction/AGENTS.md` (canonical,
  with a `<!-- rigor:generated -->` fenced section — refresh inside the markers
  only), `docs/learnings/` (3 entries), `docs/handoff/`.
- **The three learnings entries** are the durable findings from tonight; read
  them before re-deriving: the scan is a *dated* gate; `go mod why` needs `-m`;
  `pip-audit` audits the environment, not the manifest.
- **PVT's pin plumbing:** `scripts/ingest.ts` — `PINNED_SHA` (lines 14-17),
  `PINNED_HASH` (55-62), `canonicalBytes` (41-44), `P` path map (19-26). The
  header block in `passed-vs-true-demo/CLAUDE.md` also names both pins and must
  move in the same change.
- **Go pin locations** (all three must agree on a floor bump): `go.mod`,
  `.github/workflows/ci.yml:94`, `intent-controller/Dockerfile:1` — all `1.25`.
- **Local vuln tooling:** `$(go env GOPATH)/bin/govulncheck` under
  `GOTOOLCHAIN=go1.26.5`+; local Go 1.26.0 emits 12 already-patched stdlib
  findings CI never sees.
- **Ledger form gate:** `check-learnings.mjs` in the toolkit checkout — it does
  **not** ship with any of these three repos, so a fresh clone cannot run it.

## Invariants

- **Never report a synthetic number, or CLUE's train-partition F1 0.914, as
  blind real-world performance.**
- **Every green on a scheduled security scan is dated.** It reads a moving
  advisory database; re-read the run history before repeating the claim. This
  gate has failed roughly weekly since March 2026.
- **A `go.mod` floor bump must be matched in ci.yml and the Dockerfile**, or a
  different CI job goes red.
- **Believe a Go vulnerability verdict only from a patched toolchain.**
- **Sibling repos are read-only inputs to PVT, pinned by SHA *and* content
  hash** — never modify them from PVT, and re-pin only after reviewing what
  actually changed.
- **Ledger entries are immutable.** A wrong entry is superseded by a new dated
  entry with a `kills:` reference, never edited. Indexes hold pointers only.
- **Don't append to a ledger whose gate is red** — fix the gate first, or the
  new entry inherits a red baseline.
- **Agents never write git history** — commit commands go to the operator.

## Open / next

1. **Re-pin PVT** — the deliberate review this repo's decision #5 demands is
   **already done and evidenced above** (all six hashes match; both sibling
   commits are docs-only). So this is now bookkeeping, not a judgment call:
   set `PINNED_SHA.csl` `1d4c8e7 → bdb182f` and `PINNED_SHA.clue`
   `a777cca → 52de35d` in `scripts/ingest.ts`, update the pin line in
   `passed-vs-true-demo/CLAUDE.md`, then re-run `npm run ingest && npx vitest run
   && npx next build`. Expect ingest to report F1=0.9143 unchanged and the data
   JSONs to stay byte-identical — if any JSON moves, **stop**: the hash review
   above was wrong and the drift is not data-safe.
   *Blocker:* none.
2. **Fix PVT's ledger gate.** The defect is one qualified `status:` value on a
   *committed, immutable* entry, so the fix is a decision, not an edit: either
   widen the gate's status regex to tolerate a qualifier after the enum, or
   accept an in-place correction to that line. **This is the third instance of
   the same class** — the writer emitting a dialect the kit's own gate rejects
   (2026-07-14 batch-stamping, 2026-07-22 bold field labels, now field-*value*
   strictness) — so the toolkit's own feedback ledger probably wants the verdict
   more than PVT does.
   *Blocker:* needs the operator's call on which way to fix it.
3. **Watch CLUE's next scheduled scan** (Monday 06:00 UTC). Two consecutive
   greens would be the first evidence that the *watching* works, not just the
   patching.
4. CSL's DSPy run remains the only substantive build available across the three
   repos, and it needs `pip install dspy` + an LM key + a budget decision before
   anything can start.

## What this session did not cover

- No re-audit of CLUE's 8-finding `GAP_AUDIT.md` dispositions — they were read,
  not re-refuted.
- CSL's cross-OS determinism is still reasoned, not measured on a second OS.
- The remotes were never fetched (the git guard blocks `fetch`), so all
  `0 0` ahead/behind readings are against remote-tracking refs, not the true
  remote state.
