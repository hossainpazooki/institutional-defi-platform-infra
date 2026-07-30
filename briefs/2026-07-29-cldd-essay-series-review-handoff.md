# Handoff — essay-series review session after deep research results land

*2026-07-29. No single repo owns this work (cldd deliberately untouched; all
artifacts in `~/dev/briefs/`). Drift anchors for pick-up: dev-root repo was at
`eb065db` at session start (read-only snapshot); cldd sat on `0bc6cd8` + pending
operator commits per its own `docs/handoff/2026-07-29-part-iii-spaced-rerun-and-doc-number-gate.md`.
**cldd is being actively worked by other sessions** — its CLAUDE.md suite count
moved 208→209 *during* this session. Re-read cldd's newest handoff before quoting
any repo number.*

## Current state

- **[built] Series design, fully approved** — `briefs/2026-07-29-cldd-essay-series-design.md`.
  Arc A revised: #2 median non-replication (short), #3 EMP, #4 SCM, #5 PD, #6 v4
  capstone; per-essay contract (5 items); §3 publication mechanics incl. the
  essay-1 Medium annotation draft (ships together with essay 2).
  *re-verify:* read the file; header says "APPROVED design", all three sections
  carry [APPROVED].
- **[built] Deep-research seed prompt** — `briefs/2026-07-29-cldd-essay-series-deep-research-seed.md`,
  five areas: selective labels/reject inference; EMP lineage + convenience-prior
  critics; SCM benchmarking prior art (Credence/RealCause/ACIC); ML
  replication/seeds/pre-registration; venue positioning incl. SR 11-7 framing.
  Output contract: annotated bib + claims to cite/contradict + strongest expert
  attack per area + 3 overclaiming risks / 3 hooks.
  *re-verify:* read the file.
- **[built] Essay-2 evidence base, recomputed from raw artifacts this session**
  (not quoted from the cldd handoff): original SCM frontier split {0.2: 14,
  0.4: 11} median 0.2; spaced {0.2: 10, 0.4: 15} median 0.4; spaced flat {0.2: 7,
  0.4: 18}. Finding: near-even two-point split — the *median* is an unstable
  summary; the honest claim is the 0.2–0.4 range (both directions of
  median-quoting are the same error).
  *re-verify:* in `~/dev/closed-loop-default-detection`, collapse
  `artifacts/frontier_sweep{,_spaced}.csv` by (generator, seed) on
  `frontier_severity`, take per-generator median + counts (python one-liner,
  csv+statistics stdlib).
- **[in-progress, operator-external] The deep-research run.** This review session
  exists to consume its results. If results are not in hand, stop — that is the
  blocker, nothing else proceeds usefully.
- **[planned] Essay-2 implementation plan** via the writing-plans skill (draft →
  figure registry in briefs/ → skeptic pass on draft claims → publish checklist
  with annotation). Design's user-review gate was passed in-session; writing-plans
  was NOT yet invoked.
- **[planned] Essay-1 Medium annotation** — decision made (annotate), draft text
  in design §3.1, final wording operator's; ships with essay 2, not before.
- **[not started] Essays 3–6.**
- **[claim carried, unverified] v4 spec file exists** at
  `closed-loop-default-detection/docs/superpowers/specs/2026-07-29-cldd-v4-option-a-surface-design.md`
  (operator pasted its content; never opened in this session).
  *re-verify:* read the file; confirm the confirmatory family is H-S1f/H-S1s/
  H-S2a/H-S2b, Holm m=4, and §8 gates results behind `surface_stats.py` exit 0.

## Locked decisions

- **Arc A order with EMP at #3** — strongest existing finding (ROI 3×
  overstatement; EMPC vs EMP_h opposite directions), best adoption hook, and
  pushing SCM/PD later buys time for v4 before essay 5. Accepted cost recorded:
  world-before-estimators teaching order broken.
- **Goals: portfolio + teaching + adoption; research-log cadence excluded** —
  operator's explicit selection; the editorial plan sets the map, not the repo.
- **Mixed format by topic weight** — short findings pieces, long teaching pieces.
- **Annotation ships WITH essay 2** — the correction becomes a launch; annotation
  gains "full story: [essay 2 link]".
- **Editorial work stays out of the public cldd tree** — drafts/strategy in
  `briefs/`; pre-publish figure gate is manual (registry file per essay), NOT
  wired into cldd CI.
- **v4 verb discipline** — pre-registration citable as pre-registration from
  essay 2 on; v4 RESULTS in no essay until `surface_stats.py` exits 0 + skeptic
  pass (v4 spec §8/§9). Essay 6 publishes on pass OR fail (spec §0 pre-commits).
- **Figures re-derive at drafting time** — repo moves under the series (already
  did mid-session); nothing is carried forward from design-time numbers.

## Reuse map

- `briefs/2026-07-29-cldd-essay-series-design.md` — the spec: map, contract,
  essay-2 outline with word budgets, annotation draft. Do not re-brainstorm.
- `briefs/2026-07-29-cldd-essay-series-deep-research-seed.md` — if the research
  needs a second pass, extend this prompt rather than writing a new one.
- Essay-1 source text: extract from
  `~/Downloads/When You Can’t Measure What Matters…Towards AI.pdf` via pypdf
  (this session's extraction was scratchpad-only and is gone).
- Memory: `graded-world-essay-series` (indexed in MEMORY.md) mirrors this state.
- cldd evidence files for essay 2: `artifacts/*_spaced.csv`,
  `scripts/check_doc_numbers.py`, `scripts/run_spaced_sweeps.py`,
  `docs/learnings/2026-07-29-seed-overlap-caveat-applied-to-only-one-sweep.md`.

## Invariants

- Every essay figure recomputes from a committed cldd artifact at publish time;
  an unregistered figure does not ship. Violation = the exact failure essay 2 is
  about.
- Implemented-vs-planned verbs everywhere: v4 is *specced/pre-registered*, not
  run; essay 5's mechanism claim stays coincidence-strength until v4 passes.
- No real-portfolio claims (essay-1 scope caveats hold series-wide).
- Never write git history — output commit commands for the operator.
- cldd repo edits are out of scope for essay work; if a session finds itself
  editing cldd for an essay, the boundary in design §3.2/3.3 is being violated.

## Open / next

1. **Gate: deep-research results in hand?** If no — stop, that's the blocker.
2. Map results onto essays 2–5: per research area, take the "strongest expert
   attack" and check essay 2's outline survives it *before* drafting; fold
   citations/terminology into the design by a dated addendum (never edit the
   approved sections silently).
3. Then invoke writing-plans for essay 2 (the design's terminal step, not yet
   done).
4. En route: verify the v4 spec file (see unverified claim above) and re-read
   cldd's newest handoff for drift (suite count already moved once).
