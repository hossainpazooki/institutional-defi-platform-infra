# Design — "The Graded World" essay series (CLDD follow-ups)

*2026-07-29. Status: **APPROVED design** (all sections signed off in-session).
Location: `briefs/` (dev-root workspace, not the public cldd repo — approved §3.2:
editorial strategy and drafts stay out of the shipped tree). Companion:
`2026-07-29-cldd-essay-series-deep-research-seed.md` (paste-ready deep-research seed).*

## Goals (operator-selected)

Portfolio (rigor as the brand) + teaching (one component per essay) + adoption
(runnable `pip install` close). Research-log cadence explicitly excluded — the
editorial plan sets the map, not the repo. Format: mixed by topic weight.

## §1 Series map and per-essay contract [APPROVED]

Working series identity: **"The Graded World"** — kicker line on each piece
(name may be revisited before essay 2 publishes; not load-bearing).

| # | Title (working) | Weight | Dependency |
|---|---|---|---|
| 1 | *(published)* When You Can't Measure What Matters | long | — |
| 2 | The Median That Didn't Replicate | short ~1,500–1,800 w | material exists now |
| 3 | What a Loan Decision Is Actually Worth (EMP) | long | exists now |
| 4 | Building a World You're Allowed to Grade Against (SCM) | long | exists now |
| 5 | Estimating Default When the Labels Are Censored (PD) | long | coincidence-strength wording now; upgrades if v4 has run by drafting |
| 6 | We Pre-Registered a Refutation of Our Own Headline | long | blocked on v4 execution + skeptic pass |

**Per-essay contract (all five hold for every piece):**
1. Standalone-readable; ≤1 paragraph series context, linking back to essay 1.
2. One component taught to judge-an-implementation depth.
3. Headline = a finding that survived adversarial verification; the essay states HOW
   it was attacked.
4. Every quoted figure recomputable from a committed artifact at publish time
   (repo state moves — e.g. suite count went 208→209 on 2026-07-29 — so figures are
   re-derived at drafting, never carried forward from this design).
5. Ends with runnable code against the published PyPI package.

**Ordering rationale:** essay 2 is timely (spaced rerun 5 days old) and pairs with
the essay-1 annotation. EMP promoted to #3 on operator challenge: strongest existing
finding (convenience prior overstates this loan's ROI 3×; EMPC vs EMP_h move in
opposite directions across severity) and the best practitioner/adoption hook.
SCM/PD later, buying time for v4 to run before essay 5. Accepted cost:
world-before-estimators teaching order broken; the standalone-context paragraph
absorbs it.

**v4 verb discipline:** the v4 pre-registration is citable *as pre-registration*
from essay 2 onward. v4 RESULTS appear in no essay until `surface_stats.py` exits 0
and the independent skeptic pass clears (v4 spec §8/§9). The v4 spec file
(`closed-loop-default-detection/docs/superpowers/specs/2026-07-29-cldd-v4-option-a-surface-design.md`)
was pasted by the operator, **not independently verified in this session** — verify
it exists and matches before essay-5/6 planning depends on it.

**Series-wide out of scope:** v4 results until they exist; real-portfolio claims
(essay-1 scope caveats hold everywhere); any figure not registered against an
artifact.

## §2 Essay 2 — "The Median That Didn't Replicate" [APPROVED]

Short piece, ~1,500–1,800 words.

- **Cold open (~150 w).** Essay 1 published "the SCM world's median frontier is
  0.2"; five days later the project's own verification discipline refuted it.
  Correction narrated beats correction buried.
- **The evidence under the sentence (~300 w).** The median rested on a 25-seed sweep
  with overlapping seeds across cells (10 colliding pairs per generator), found by
  the harness's own audit, not externally. Teaching beat #1: seed-disjointness,
  per-run seed-consumption spans, how overlap correlates cells treated as
  independent.
- **The rerun: one claim survives, one doesn't (~500 w).** Spaced set {1000+16i}.
  Counterfactual leg REPLICATES: +0.0129, 22/25 positive, p = 1.6e-06 vs published
  1.5e-07 (design variability, not decay); this leg consumes only {s, s+1000} so it
  never had collisions — true replication, while the frontier rerun is a repair.
  Frontier median does NOT replicate: 0.2 → 0.4. Key move — refuse the reverse
  error: original SCM split {0.2: 14, 0.4: 11}, spaced {0.2: 10, 0.4: 15}; a
  near-even two-point distribution whose median is an unstable summary. The honest
  claim was and remains the 0.2–0.4 range. Essay 1's own phrase — "a figure
  published without an error bar" — applied to its own median.
- **The gate (~350 w).** Teaching beat #2: `check_doc_numbers.py` recomputes every
  README figure from committed artifacts at quoted precision, fail-closed, in CI;
  its maiden run caught three real drifts (a tolerance claim, a stale test count, a
  version string). Figures are claims with a registry; an unregistered figure is
  ungated by construction.
- **Close (~250 w).** The essay-1 update note ships WITH this essay and links here.
  Forward pointer (pre-registration verbs only): the frontier was silently
  conditioned on a second axis — unobserved confounder strength — and the
  interventional test of that axis is already pre-registered (four confirmatory
  hypotheses, Holm-corrected, falsification statement written before the data).
  Runnable close: `run_spaced_sweeps.py`, `paired_significance.py --sweep-csv`,
  `check_doc_numbers.py`.

Numbers above were recomputed in-session from the raw committed CSVs
(`frontier_sweep.csv`, `frontier_sweep_spaced.csv`); re-derive again at drafting per
contract item 4.

## §3 Publication mechanics [APPROVED]

1. **Annotation and essay 2 ship together.** The Medium update note on essay 1 gains
   a "full story: [essay 2 link]" line — the correction becomes a launch. Draft
   annotation text (final wording is the operator's):
   > *Update (July 2026): A follow-up rerun on 25 fresh, seed-disjoint draws — after
   > the original sweep was found to have overlapping seeds across cells — puts the
   > SCM median frontier at 0.4 (15/25), not 0.2. The two designs together say
   > something sharper than either median: the frontier distribution splits nearly
   > evenly between 0.2 and 0.4, so the median itself is draw-dependent. The
   > operating-frontier range of 0.2–0.4 stands unchanged; the point estimate inside
   > it should not be trusted. Both sweeps are committed in the repo. This is the
   > harness's verification loop doing after publication exactly what this essay
   > argues it must do. Full story: [essay 2].*
2. **Drafts live in `~/dev/briefs/`** (or a private drafts folder), never in the
   cldd tree.
3. **Pre-publish figure gate, manual.** Each essay gets a figure-registry file in
   `briefs/` (figure → artifact → recompute command); every quoted number is
   re-derived against current committed artifacts before publish. Deliberately NOT
   wired into the repo's CI gate — drafts are outside the repo.
4. **Venue: Towards AI** (continuity with essay 1; operator may reconsider
   cross-posting later — not blocking).
5. **Cadence is editorial:** essay 2 next; essay 3 after the deep-research results
   land; no fixed schedule.

## Next actions

1. **Operator:** review this spec file; then the writing-plans step produces the
   essay-2 implementation plan (draft structure → figure registry → draft → skeptic
   pass on the draft's claims → publish checklist with annotation).
2. **Operator, external:** run the deep-research seed; results feed essays 3–5
   positioning.
3. **Next session pickup:** verify the v4 spec file exists before any essay-5/6 work.
