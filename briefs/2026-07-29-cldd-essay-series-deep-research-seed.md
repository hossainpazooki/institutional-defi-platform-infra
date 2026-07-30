# Deep-research seed prompt — CLDD essay series positioning

Paste-ready. Written 2026-07-29 for the "Graded World" series (essays 2–6).
The research agent has no repo access; the prompt is self-contained.

---

I am writing a technical essay series on Medium/Towards AI, following up a published
piece about a "closed-loop harness" for probability-of-default (PD) estimation: a
fitted structural causal model (SCM) of a borrower population serves as a synthetic
world with planted ground truth, so causal estimators (naive conditioning,
g-computation, IPW reweighting) can be *graded* on counterfactual accuracy and
declined-cohort calibration instead of trusted. Selection bias enters through an
unobserved confounder; labels accrue only for funded loans (the selective-labels
problem). The series covers: (2) a published figure that failed to replicate under a
seed-disjoint rerun, and the CI gate that now recomputes every published number from
committed artifacts; (3) profit metrics — literature EMPC (Verbraken et al.) vs a
harness-derived EMP with planted default timing, which disagree in direction; (4) SCM
construction and do-operator surgery with a marginals-only fidelity gate; (5) selective
labels / reject inference and why richer features cannot fix confounded selection;
(6) a pre-registered interventional test (Holm-corrected confirmatory family) of the
claim that two failure modes share one cause.

Research these five areas and report per-area:

1. **Selective labels & reject inference.** Canonical and recent work (Lakkaraju et
   al. selective labels; reject-inference literature in credit scoring; IPW/doubly-
   robust corrections under MNAR selection). What is the current consensus on when
   reject inference is identified at all? Who has said "more features don't fix
   unobserved confounding" precisely, and how?
2. **Profit-driven credit scoring.** EMP/EMPC lineage (Verbraken, Bravo, Baesens,
   Óskarsdóttir), the default h(λ) prior (p0=0.55, p1=0.10, ROI=0.2644), and any
   published criticism of those convenience parameters. Has anyone measured the gap
   between assumed and realized loss-given-default priors on a specific loan
   structure?
3. **Synthetic/SCM-based benchmarking of causal estimators.** Simulation-grounded
   evaluation (e.g., Credence, RealCause, ACIC challenges), fidelity validation of
   synthetic worlds, and known criticisms ("synthetic worlds prove what you built
   in"). How do others defend or bound the marginals-only fidelity limitation?
4. **Replication, seeds, and error bars in ML.** Seed-sensitivity findings (Henderson
   et al. deep RL; rliable/Agarwal et al.), figure/claim drift between papers and
   code, pre-registration in ML (venues, registered reports), and any prior art on
   CI gates that recompute published numbers from artifacts ("doc-number gates",
   numerical claims testing).
5. **Positioning.** What exists on Medium/Towards AI or practitioner blogs on these
   topics in the last ~2 years? Where are the gaps this series can own? Which model-
   risk-management framings (SR 11-7, TRIM/ECB expectations) make this material
   legible to regulated-lending readers?

Output format: per area — annotated bibliography (title, venue, year, link, one-line
relevance), 3–5 claims worth citing or explicitly contradicting, terminology I should
adopt or avoid, and the single strongest attack an expert reviewer would mount against
my series' framing in that area. End with a cross-area summary: the three biggest
risks of the series overclaiming, and the three strongest under-exploited hooks.
