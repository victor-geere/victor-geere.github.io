# Review comments — `the-final-letter/`

**Purpose.** A pre-publication review, written to be investigated rather than
acted on. No content was corrected while writing it. Findings carry file and
line references; the main structural and thesis claims were verified directly,
the per-topic findings come from a structured audit of all 45 dossiers with
spot-checks of the strongest claims (§6). The one change made by the review
process is that verification regenerated build artefacts — see §9.

> **Post-review update (24 October 2026).** Finding S2 (the broken link base)
> and the local-evidence part of S4 have been addressed since this review:
> the evidence was imported under `summary/`, `summary-rh/`, `archive/` and
> `rh/`, links are now file-relative, and
> [`tools/check-links.py`](tools/check-links.py) enforces the guarantee. The
> findings below describe the state at review time and are kept as the record.

**Scope.** All 45 topic dossiers, the 13 numbered sections, the master
documents ([README](README.md), [STATUS](STATUS.md),
[ABSTRACT](ABSTRACT.md), [GAP-LEDGER](GAP-LEDGER.md),
[GLOSSARY](GLOSSARY.md), [TABLE-OF-CONTENTS](TABLE-OF-CONTENTS.md),
[index.html](index.html), [scraps.html](scraps.html)), the
[`lean/`](lean/README.md) layer, the [`topics/`](topics/README.md) tooling, and
the [paper bundle](geometric-dynamical-phase-transitions/README.md). Spot
checks were made against the two evidence corpora (`../summary/`,
`../summary-rh/`) and the archived sources under `../archive/`.

**Overall.** Two different objects share this folder, and they deserve
different verdicts.

The **dossier layer** — 45 reconstructed programmes, each with a ledger, a
Python layer, tests, and a Lean core — is unusually honest, genuinely
reproducible, and in places does real scholarship: it finds errors in the
archived papers rather than inheriting them. This is the part worth publishing.

The **letter** — the two-wall synthesis, the final note, and the theory that
the walls share one missing object — is well written but rests on four
load-bearing claims whose evidence is narrower than the prose suggests. Its
central new theorem, the finite-prefix no-go, is Lean-certified but much weaker
than the sentence it is used to support (§5.3).

The publication layer is not ready: the whole tree is untracked, unlinked from
the site, and 23% of its internal Markdown links are broken (§3).

---

## 1. How the review was done

| Check | Result |
|---|---|
| Topic folders | 45, all with `README.md`, `index.html`, `python/programme.py`, `tests/`, `lean/` |
| Structural audit ([`tools/audit_topics.py`](topics/tools/audit_topics.py)) | `OK: 45 topic folders pass` |
| Python suites | **406 passed** across 45 suites, no failures |
| Lean cores | **61 modules rebuilt, all `[check] OK`**, no failures; no `sorry`/`axiom`/`admit` |
| Local Markdown links | 1,687 links, **387 broken (23%)** |
| Local HTML links (`index.html`, `scraps.html`, `topics/index.html`) | all resolve except one `%20` archive path |
| Claims spot-checked against `../archive/` and `../summary*` | quotations and source attributions are mostly faithful; exceptions noted |

Not verified: the analytic proofs in the source paper (Theorems C.8, C.9,
12.1–12.6), the two evidence corpora claim by claim, external URLs, or the
correctness of the Leaned statements beyond compilation and inspection.

---

## 2. What is genuinely strong

**P1. The status vocabulary is the best idea in the folder.** Separating
*Theorem* (Lean), *Computation* (tested), *Source claim* (archived, not
adopted), and *Open* is a small invention that most of the literature would
benefit from. It is applied consistently at the dossier level and it works.

**P2. The dossiers are honest about their sources.** Of 45 topics, 11 came out
*solid* and 30 *minor-issues* under a standard that would break most
reconstruction projects; only 4 have substantive problems. Dossiers repeatedly
refuse the upgrade: `nested-spheres-continuous-cone` records the archived
`c₁ = ½ρ²` claim as false; `prime-spectrum-tensor` keeps the refuted `(★)`
separate from Theorems A–C; `self-adjoint-ccm` refuses the source's
self-adjointness claims. That is the intended behaviour, and it is real.

**P3. The errata are genuine scholarship.** Several dossiers find real errors
in the archived papers and say so precisely: the EML recurrence in
[`eml-universal-operator`](topics/eml-universal-operator/README.md), the
off-diagonal kernel in
[`ghd-correlation-kernel`](topics/ghd-correlation-kernel/README.md), the
half-angle/step confusion in [`harmonic-sine`](topics/harmonic-sine/README.md),
the sign error in
[`factorisation-theta`](topics/factorisation-theta/README.md), the torsion
error in [`riemann-helix`](topics/riemann-helix/README.md). The *audit* is the
contribution here, not the reconstruction.

**P4. The Lean work is real, if narrow.** 61 modules compile against Mathlib
with no placeholders. `ReplayAtoms.cert_mem_closed` genuinely discharges the
ζ(2) atoms; `Transcend.lean` genuinely encloses π, log, exp, sin, cos. The
`FinalLetter` build is clean. The narrowness is discussed in §5.6, but the
work itself is competent and reproducible.

**P5. Provenance is mostly accurate.** Quotations checked against
`../archive/` matched, including awkward ones: the AX5 retraction in GDST, the
"currently ill-defined" line in the dyadic-sheaf essay, the source's own
"does not claim a proof" in GDST-twin, the "Incomplete proof" tag in the HST
landing page. This is the opposite of the usual recycled-claims failure mode.

**P6. The tooling is a good skeleton.** `audit_topics.py`, `run-tests.sh`,
`check-all-lean.sh`, `build_topic_index.py`, and `verify-all.sh` are exactly the
right shape; they just need two more checks (§8).

**P7. The writing is clear and the non-claims are explicit.** The sentence
"The map is complete; the walls are not crossed" is a good summary, and the
"What is not proved" tables are better than most published papers manage.

**P8. `index.html` works.** All 65 of its links resolve, MathJax is configured
correctly, and it is self-contained. As a single page it is the only artefact
currently fit to publish.

**P9. The bundle is self-contained.** The copy under
`geometric-dynamical-phase-transitions/` resolves internally, and the README
honestly distinguishes the canonical paper from the `maths/` notes that claim
an RH proof.

**P10. The form has value.** A letter that argues for the limits of a method
class, keeps its errata, and refuses hype is a real genre contribution even
where its theses are too strong (§5).

---

## 3. Blocking structural findings

### S1. Nothing here is published, and nothing links to it

`the-final-letter/` is **untracked in git** (`git status` shows `?? the-final-letter/`,
`?? summary/`, `?? summary-rh/`). The repository deploys from `master`, so none
of this is live. It is also **orphaned**: the root `README.md` never mentions
`the-final-letter`, and no page outside the folder links into it. The only
working entrance is [`index.html`](index.html).

This matters because the folder is written as if it were already a site. A
reader who arrives at [`README.md`](README.md) (the natural entry) finds the
first table pointing at `the-final-letter/01-description/description.md`,
which does not exist from that location.

**To investigate:** is the intended entry point the HTML single page, the
Markdown README, or a future `the-final-letter/index.md`? The answer decides
every other fix in this section.

### S2. 387 of 1,687 internal Markdown links are broken

The failure is systematic, not incidental:

| Cause | Count |
|---|---|
| Link written with a `the-final-letter/` prefix although the file is already inside `the-final-letter/` | 320 |
| `summary/...` written as if `summary/` were a child of `the-final-letter/` (it is a sibling) | 59 |
| Archive paths needing `%20`/relative correction | 8 |

The worst offenders are [`TABLE-OF-CONTENTS.md`](TABLE-OF-CONTENTS.md) (120
broken links out of its links), [`README.md`](README.md) (28), and
[`05-proofs/proofs.md`](categories/05-proofs/proofs.md) (17). `TABLE-OF-CONTENTS.md:3`
states the convention explicitly: "Links are workspace-root-relative". That
convention works in an editor rooted at the repository, and fails in every
browser, on GitHub, and on the deployed site. [`index.html`](index.html) uses
`../summary/...` and works, so the HTML and Markdown layers now disagree about
where they live.

**To investigate:** pick one base (site-root-relative), then regenerate rather
than hand-edit. A link check in `verify-all.sh` would have caught all 387.

### S3. The documentation layer is Markdown, and Markdown is served raw

GitHub Pages serves `.md` as `text/plain`. The master documents
([`STATUS.md`](STATUS.md), [`TABLE-OF-CONTENTS.md`](TABLE-OF-CONTENTS.md),
[`GAP-LEDGER.md`](GAP-LEDGER.md), [`GLOSSARY.md`](GLOSSARY.md)) are therefore
unstyled text with visible `|` table pipes, and `index.html` links to them
directly. Even after fixing paths, the reading experience is poor.

**To investigate:** either make `index.html` the canonical artefact and keep
Markdown as source, or generate HTML for every master document. Maintaining
both by hand is already failing (see S7, C8).

### S4. The evidence is not in the repository

Two evidence corpora — [`../summary/`](summary/README.md) and
[`../summary-rh/`](summary-rh/README.md) — are untracked, and much of the
provenance points outside the repo entirely: `~/workspace/rh/research/...`,
`~/lean/mathlib4`. A reader of the published site cannot check any of the
source claims; a future maintainer cannot rebuild. Only the `../archive/`
material is inside the repo. `00-provenance/scope.md` presents the corpora as
"The evidence annexes", but they are not part of the publication.

**To investigate:** decide whether the corpora ship (1.5 MB total, acceptable)
or whether the letter must be self-contained and cite only `../archive/`.

### S5. The canonical paper exists twice

`publication.html` at the repository root and
`geometric-dynamical-phase-transitions/publication.html` are byte-identical
(same MD5, same size, same timestamp). Two copies with no generator or
symlink will drift. The bundle README says it was "assembled from the
repository root", which makes the duplicate a copy by design — but nothing
records which one is canonical when they diverge.

**To investigate:** keep the root copy canonical and make the bundle a
pointer, or add a hash check to `verify-all.sh`.

### S6. Build artefacts are inside the tree and not ignored

The `.gitignore` covers `*.pyc` and `__pycache__/` but **not `*.olean`**. There
are 64 `.olean` files under `the-final-letter/` (20 MB) and 112 `.pyc` files in
the working tree, including `__pycache__` inside
`topics/eml-universal-operator/`, `topics/greedy-harmonic-hilbert-polya/`,
`topics/qefe-research-notes/` and the paper bundle. If the folder is committed
as-is, the repository gains tens of megabytes of compiled output.

**To investigate:** add `*.olean` and a `the-final-letter/**/BUILD.log` policy
to `.gitignore`, and decide whether `BUILD.log` is a checked record or a local
artefact. It is currently both — and it is quoted in READMEs (S8).

### S7. "Complete" does not mean what a reader will think

The topics index calls all 45 folders **complete**; the standard defines this
as "both commands pass and the README/index ledger agrees with the files"
([`PROGRAMME-STANDARD.md`](topics/PROGRAMME-STANDARD.md)). The audit that
enforces it checks only *file presence* and the absence of
`sorry`/`axiom`/`admit`; it does **not** check that ledger names exist in
Lean, that test numbers match, or that the HTML mirrors the README. All three
fail in practice (§6).

### S8. Hand-maintained numbers drift, and some are already wrong

Examples verified during this review:

- `topics/isabelle-afp/README.md:24` (and `index.html:133`,
  `lean/README.md:62`) says 976 AFP *entries* are directories under `thys/`;
  there are 972 directories (976 counts `ROOT`, `ROOTS`, `LICENSE`,
  `LICENSE.LGPL`).
- `topics/frozen-truths/README.md:115` quotes `[check] OK Topic.lean (7s)`
  and "7 passed in 0.90s"; the recorded build says 5s, the current suite runs
  in 0.95s.
- `topics/harmonic-categorical-hilbert-polya/README.md:124` says "about 10 s"
  for a suite that runs in ~1 s.
- `topics/greedy-harmonic-transfer-operator/README.md:100` quotes `(11s)` for
  a build log that records `(5s)`.
- `topics/geometric-dynamical-phase-transitions/README.md:286` records
  "7 passed" while the same README at `:189` and `index.html:685` record 55.
- `topics/STATUS.md:3` claims 399 ledger theorems and 372 computations; both
  are parsed from hand-written tables with inconsistent `S#` labels, so the
  source-claim column is wrong for roughly twenty dossiers (§C3).

**To investigate:** generate every count and quote from the artefacts; never
paste timings into prose. This is the cheapest fix with the largest effect on
credibility, because a reader who finds one stale number stops trusting the
ledger.

---

## 4. Status and ledger integrity

### C1. The third objective has three different statuses

| Document | What it says |
|---|---|
| [`README.md`](README.md):11 | "a concrete ζ(2) replay with every atom discharged" |
| [`STATUS.md`](STATUS.md):7 | "Euler–Maclaurin formula and **transcendental leaves source claims**" |
| [`ABSTRACT.md`](ABSTRACT.md) | transcendentals "kernel-checked in Lean (`Transcend.lean`)" |
| [`topics/partial-sum-plus-tail/README.md`](topics/partial-sum-plus-tail/README.md):206 | S6 "transcendental enclosures ... trusted leaves" |

The true position (verified) is: the transcendentals are proved in
`Transcend.lean`, the ζ(2) atoms are discharged in `ReplayAtoms.lean`, and only
S1–S2 (Euler–Maclaurin and the tail bound) are source claims. `STATUS.md` and
the S6 row are stale. This is the most consequential status error in the folder
because it either understates (STATUS) or overstates (README's "every atom
discharged") the same artefact.

### C2. The same dossier still says the wiring is future work

`topics/partial-sum-plus-tail/README.md:191` and `index.html:154` both say
"The remaining work is mechanical: replace the atom hypotheses of a concrete
`Replay` by these theorems." That contradicts `T32` and
`Replay.cert_mem_closed` twelve lines earlier in the same file.
`lean/Topic.lean:12` repeats it ("`π`, `log`, `exp`, `sin`, `cos` remain the
trusted leaves"), and `index.html:144` says "no trusted leaves" while
`index.html:165` says "trusted leaves". The dossier now contradicts itself
within one page.

This is not just a wording issue: it means the last edit (12:06 today, minutes
after [`qa.md`](topics/partial-sum-plus-tail/qa.md) was written) updated the
ledger and the open items but not the surrounding prose.

### C3. Source-claim counts in the shared ledger are unreliable

`topics/STATUS.md` reports **0** source claims for roughly twenty dossiers
that plainly list them: `dyadic-sheaf-cohomology` (7 rows),
`factorisation-theta` (8), `finance-trading` (9), `ghd-correlation-kernel` (10),
`gap-inventory-strengthening` (13), `harmonic-sine` (9),
`harmonic-sine-transform` (12), `prime-spectrum-tensor` (9), and others. The
cause is mechanical: those tables have no `S#` labels, so the parser sees
nothing; on `frozen-truths` (labelled) it correctly reports 13. A few dossiers
label their tables partially, which produces counts that are neither zero nor
right (`qefe` 4 of 9, `rh-mtc-padic` 8 of 9).

**To investigate:** standardise the ledger tables to a machine-readable form
and make `audit_topics.py` verify them.

### C4. "Proves" covers four different evidence levels

The letter says it "proves a conversion, a sharpness theorem, a finite-prefix
no-go theorem, a five-bridge refutation, and a Lean spine". In fact:

- the conversion and sharpness are **written proofs in the author's paper**,
  not machine-checked and not peer-reviewed;
- the finite-prefix theorem is **Lean-checked** (and weaker than stated, §5.3);
- the five-bridge refutation is an **argument over the author's own proposed
  routes**;
- the Lean spine is **machine-checked** but covers only the finite layer.

The topic layer gets this right with four labels; the letter gets it wrong with
one verb. The single highest-value editorial change would be a verification
column — *paper proof / Lean / numerical / source claim* — in every table in
`sections 01–12`.

### C5. The headline contradicts H6

The title is "Two walls, **one** missing input"; H6 says the missing inputs
"are not identical, but they are the same kind" and C5/C6 make the RH input a
positivity and the parity input a coupling. A subtitle that asserts one input
while a hypothesis asserts "same kind, not identical" invites the reader to
conclude more than the programme claims. `README.md:4` repeats it.

### C6. "Complete" and "45/45"

- The topics index marks all 45 folders **complete** on a structural criterion
  (§S7).
- `topics/STATUS.md:3` says "45/45 Lean builds OK": verified true today (61
  modules), but the number says nothing about the 108-row ledger of
  `geometric-dynamical-phase-transitions`, only 7 of whose theorems live in
  `lean/Topic.lean` as the standard requires.
- The audit's `OK` line is quoted as if it certified the mathematics. It does
  not.

### C7. Ledger inflation in the flagship dossier

`topics/geometric-dynamical-phase-transitions` carries a 108-row theorem
ledger across 12 Lean files, but the rows include:

- `comp_eta_two := etaAtNegOne_two` — a literal alias
  (`lean/Computations.lean:414`), while `lean/README.md:108` says "No row is an
  alias";
- three rows (T36, T46, T93) for the single fact η₂(−1) = −2, one of them a
  `norm_num` over a hardcoded numeric expression;
- T63 `eta2_zero_off_critical`: `(0:ℂ).re ≠ 1/2`;
- T56 `O2_iff_O1`: a structure field projection;
- T10/T11 stated without the `1 < N` hypothesis that the Lean theorems require
  (`lean/Bridges.lean:49,70`); at N = 1 both are false as stated.

The dossier also calls its last-chord asymptotics a "breakthrough" in prose
(`README.md:209`, `index.html:392`) and names the file `Breakthrough.lean`.
This is the one place where the "no hype" discipline visibly slips.

### C8. Test-ledger mismatches are common

Across the 45 dossiers, several have test docstrings numbered differently
from the ledger (`ghd-correlation-kernel` C7/C8 swapped; `iota-helix-function`
every test one behind; `sinc-sine-kernel-moments` C5/C6/C7 for ledger
C6/C7/C8), and several quote a test range wider than the loop (e.g.
`greedy-harmonic-sine-parity` C4 claims `h < a ≤ 15`, tests `h ∈ 1..4`;
`yakaboylu-notes` C4 claims N = 2..200, samples nine values).

**To investigate:** make the tests import the ledger, or at least make the
audit cross-check row IDs against test function names.

---

## 5. The thesis: a critical reading

This section is the part most worth arguing about. The letter's negative tone
is well earned in places, but four load-bearing claims are stated more strongly
than their evidence.

### 5.1 The conversion is a reformulation, not yet a reduction

[Corollary 12.3](summary/05-spectral-measures-and-tightness/13-corollary-12.3.md)
is a genuine equivalence: RH iff the balanced and unrestricted supports
coincide. But the "balanced" side is itself defined by the polygon construction
and by a Marty-speed/slow-passage condition, and the proof that off-line zeros
produce unbalanced closures uses the same analytic machinery as the problem.
The letter says the translation "is complete" and "removes the ambiguity about
what a proof would have to show". Complete translation is cheap; the question
is whether the translated side offers a handle that does not already presuppose
knowledge of the zeros.

> **Open question Q1.** Is there an independent, checkable criterion for
> "balanced" — e.g. a positivity or energy condition on a closure — that can be
> verified without locating the zeros? If not, the conversion is a change of
> language, and calling it "the map" is generous.

### 5.2 The DH litmus is valid but has low selectivity

The sharpness result is real: the construction transfers verbatim to the
Davenport–Heilbronn function, and at Spira's off-line zero it returns the
correct "false RH" verdict. As a **necessary condition** on bridges — "your
input must fail for DH" — it is sound.

Two cautions:

1. At full generality the condition is nearly tautological. If a proof uses
   only facts shared with a function that violates the conclusion, it cannot be
   sound. C.10 is a theorem about a *specific list of ingredients* (Euler-sum
   pair, Euler–Maclaurin/partial summation, Jensen, Rouché, minimum principle,
   Riemann–von Mangoldt, classical floor). The letter generalises this to "the
   additive toolbox", which is never defined.
2. The filter has little discriminating power in the programme's own table:
   8 of the 10 bridges in [`11-bridges/bridges.md`](categories/11-bridges/bridges.md) pass
   the litmus. A test that almost everything passes cannot be the main
   methodological contribution (N3).

> **Open question Q2.** Can "additive toolbox" be given a formal closure
> condition — a proof-theoretic class, or a set of axioms satisfied by both ζ
> and DH? Without it, C.10 is a statement about one proof, not a no-go theorem.

### 5.3 The finite-prefix theorem does not establish the sentence it supports

This is the most important finding in the review.

The Lean theorem
([`lean/FinalLetter/Synthesis.lean`](lean/FinalLetter/Synthesis.lean),
`finite_prefix_indeterminacy`) constructs `liouvilleSlice a`: the Liouville
function with the single value at `a` flipped. It agrees with λ below `a`,
differs at `a`, and reproduces `corr h N` for all `N + h < a`. The perturbation
has ℓ²-mass exactly 4 — because one ±1 value is flipped, changing it by 2.

Now consider the correlation difference for `N ≥ a + h`: only the terms
`n = a` and `n = a − h` can change. Hence

```
corrSlice h a N − corr h N  is bounded (|·| ≤ 4) for every N.
```

So the two functions have **the same asymptotic behaviour**: one is `o(N)` iff
the other is. The theorem shows that a finite prefix does not determine a
*finite-scale* correlation; it does **not** show that two functions agreeing on
a prefix can have different correlation *limits*. The Lean docstring is
careful and says exactly this ("It does not assert that the two functions have
different asymptotics"), but the prose does not:

- [`12-final-note/final-note.md`](categories/12-final-note/final-note.md):11 — "Two
  functions can agree on an arbitrarily long prefix and have different
  correlation sums. ... No finite computation can decide two-point Chowla."
  The first sentence is about finite sums; the second does not follow.
- [`06-findings/findings.md`](categories/06-findings/findings.md) F4 — "the formal
  statement of the futility of finite verification".
- [`08-novelty/novelty.md`](categories/08-novelty/novelty.md) N2 — "finite data cannot
  determine the limit of a correlation, so numerical verification is
  structurally incapable of closing the wall".

The last sentence is true for a trivial reason (a limit is not a finite object)
and is not what the theorem proves. The theorem is a precise, useful statement
that finite observations underdetermine finite correlations; it is not a no-go
for finite reasoning, and the ℓ²-mass of 4 is a measure of how *small* the
ambiguity is, not how large.

> **Open question Q3.** Can the theorem be strengthened to a genuine asymptotic
> statement within a constrained class — e.g. two completely multiplicative
> sign functions, or two functions satisfying a Chowla-type constraint, with
> different correlation limits? That would be a no-go worth the name. As it
> stands, the result is a one-index indeterminacy lemma.

This matters because the letter repeatedly calls it "the one clean new
theorem" and "the precise form" of the futility claim. The gap between the Lean
statement and the English sentence is exactly the kind of gap the dossier
layer exists to prevent.

### 5.4 "The same kind of object" is an analogy, not a finding

H6/F6 unify the two walls under "a global arithmetic positivity that the local
machinery cannot manufacture". On the RH side that is recognisable (Weil
positivity, (M)). On the parity side the missing object is a positive-density
multiplicative coupling to Ω — a parity-breaking correlation, not a positivity.
A bilinear form can be indefinite; a coupling can be signed. No definition of
"kind" is given, and the two objects are not shown to instantiate a common
structure. The honest version is: both are "global arithmetic inputs that the
surveyed local methods do not supply". That is a much weaker unification, and
it does not justify the title's "one missing input".

> **Open question Q4.** Is there a category (a class of functors, a positivity
> cone, a Selberg-class axiom) in which "Weil positivity" and "positive-density
> coupling to Ω" are two instances? If not, H6 should be labelled a heuristic.

### 5.5 "The futility is structural" is unfalsifiable as written

H8 says "the failure is not a lack of effort ... it is the structure of the
available data". This is a claim about all future methods in a class that is not
defined. It cannot be refuted by any future proof of RH, since such a proof
would merely use data outside the class. It is labelled "the programme's final
assessment", which is honest, but the final note then says "We have proved the
absence of the local key" — a much stronger sentence than H8 supports.

The defensible claim is the one the description already makes: "the methods
surveyed here cannot close the wall". The letter should say that, and stop.

### 5.6 Objective III is real work with a rhetorical, not mathematical, link to the walls

The evaluator is the most defensible artefact in the folder, and the one whose
status is most confused:

- It is **sound** (rational interval arithmetic plus a checker) but its
  enclosure **width is not certified**; `inflate` is sound for every `r ≥ 0`,
  so any box can be widened and remain accepted. The narrow widths are Python
  measurements, not theorems.
- A certificate that `0 ∈ η(1/2 + iγ₁)` is a containment, not a proof that a
  zero exists or that the value is zero; no sign change or argument-principle
  count accompanies it.
- The final ζ enclosure remains conditional on S1–S2 — that is, on
  Euler–Maclaurin and the tail bound, which is where the analytic content
  lives. The formal work covers the algebra and the transcendentals, not the
  analytic step that connects a finite computation to an infinite sum.
- The letter says the evaluator is "the computation layer the walls need", but
  the programme's own F7 says "computation is not the bottleneck", and H8 says
  more computation cannot close the walls. It is never shown what either wall
  would do with the evaluator.
- The method table claims sin/cos come from `Real.hasSum_sin`/`hasSum_cos`;
  `Transcend.lean` actually uses `expITaylor` and `Complex.exp_bound`, and
  `hasSum_sin` appears nowhere in the file. The documentation of the
  best-verified component is itself wrong.

> **Open question Q5.** What theorem about RH or twin primes uses a certified
> enclosure as a hypothesis? If none, Objective III should be presented as a
> separate deliverable (a verified numerical library), not as part of the
> two-wall argument.

### 5.7 The Lean spine certifies the easy layer

516 theorem declarations across the topic layer, 399 ledger rows, 61 modules —
and the load-bearing claims (conversion, sharpness, transport, explicit
formula) are prose. That is a legitimate choice, but the letter's phrase "a
Lean spine" suggests the spine supports the body. It supports the finite
skeleton. H7 says exactly this ("formalisation is a microscope, not a key"), so
the diagnosis is present; the rhetoric has not caught up with it.

Related: many "Theorem" rows are definitional. The standard's rule 4 forbids
vacuous or tautological theorems, and at least half a dozen dossiers violate it —
EML T1–T3 (unfoldings), dyadic T5–T6 (sum of two squares is non-negative),
gap-inventory T2/T4/T7, gdst T1 (an if-then-else returns 0 or 1), harmonic-sine
T1. Not fatal, but the count 399 should not be read as 399 mathematical facts.

### 5.8 The five-bridge refutation is self-refutation

The five bridges B1–B5 are the author's own candidate routes from the earlier
programme. Refuting them is useful and honest, but it is not a result about the
literature: no comparison is made with Selberg's sieve, the
Matomäki–Radziwiłł–Tao entropy decrement, or the known bilinear approaches to
Chowla. The section reads as "my five ideas failed", which is valuable, but
"the five-bridge refutation" sounds like a field-level no-go.

### 5.9 Eight walls dilute the word "wall"

W3 (finite prefix) is a no-go theorem rather than a wall; W8 (well-posedness) is
a definitional failure. Naming all eight "walls" makes the headline "two walls"
look arbitrary. The diagram at the end of
[`10-walls/walls.md`](categories/10-walls/walls.md) has arrows that the text immediately
disclaims as "not logical implications" — a map whose edges mean nothing is
decoration, not structure.

### 5.10 What is genuinely novel

Of the six novelty claims, three survive scrutiny: **N4** (a single barrier
ledger), **N5** (a Lean synthesis connecting the two finite cores), and **N6**
(the letter form) are defensible as new arrangements. **N1** (the two-wall
diagnosis) is a thesis, not a result. **N2** (finite-prefix as general no-go)
overstates the theorem. **N3** (DH litmus as method) is oversold by its own
selectivity data. A revised novelty section could be stronger by claiming less.

---

## 6. Topic-layer audit: summary and notable findings

Verdicts: **11 solid · 30 minor · 4 significant**. "Minor" below means the
dossier's discipline holds but something is stale, mislabelled, or a test does
not exercise its claim; it is the normal state of a hand-maintained corpus this
size. The rows below are audit leads with file references; the four
significant ones and the partial-sum/dyadic/factorisation/gdst/frozen/
test-numbering leads were re-checked directly. Rows that compare a dossier's
prose with the archived source come from the audit's reading; re-open the cited
file before acting on one.

### Significant

| Topic | Finding |
|---|---|
| [`self-adjoint-ccm`](topics/self-adjoint-ccm/README.md) | Rows 36/60 adopt "for ζ, c(p) = log p and c(p^m) = 0 for m ≥ 2, consistent with the von Mangoldt function". Λ(p^m) = log p for every m, so the second half is false; the Python asserts both (`programme.py:144` vs `:157`, tests `:80,87`). Also relabels the source's gaps (phase function 1, WKB 3a, trace 3b, spectrum 4 become 1/2/3). |
| [`theorems-paper-series`](topics/theorems-paper-series/README.md) | Erratum E3 states δ₁ = 1 exactly on [1/3, 1/2); it is also 1 on [5/6, 1] (δ₁(0.9) = 1). E5 calls a sign typo ("<" for "=") an invalid step, so the claimed gap is not a gap. The underlying refutations still stand, but the errata are wrong in their details — the worst place for an error in an audit dossier. |
| [`phase-interference`](topics/phase-interference/README.md) | `is_positive_semidefinite` tests only leading principal minors, which is not a PSD criterion; it accepts `[[0,0],[0,-1]]` (`programme.py:164–177`), so Computation C3 does not verify positivity. A one-line fix (all principal minors, or eigenvalues) but the claim is currently unbacked. |
| [`geometric-dynamical-phase-transitions`](topics/geometric-dynamical-phase-transitions/README.md) | The 108-row ledger: alias row, three rows for one numeric fact, a 0 ≠ 1/2 row, a field projection; T10/T11 missing the `1 < N` hypothesis (`lean/Bridges.lean:49,70`); stale 7/55 test counts; "breakthrough" prose. The underlying Lean does compile. |

### Minor but load-bearing

| Topic | Finding |
|---|---|
| [`partial-sum-plus-tail`](topics/partial-sum-plus-tail/README.md) | Self-contradictions on atom discharge (§C2); sin/cos method misattributed (§5.6); S6 row stale. The mathematics is the best-verified in the folder. |
| [`dyadic-sheaf-cohomology`](topics/dyadic-sheaf-cohomology/README.md) | `energy_symm` is proved in Lean but absent from the ledger; `lean/README.md:56` says it is not; sum-of-two-squares tests are tautological. |
| [`factorisation-theta`](topics/factorisation-theta/README.md) | In Lean, `divisorDetector k 0 = 0` by totalised division, so T2 holds at x = 0 for the wrong reason; the Python rejects x = 0. Two different objects called Θ_N. |
| [`gdst`](topics/gdst/README.md) | T5 is stated unconditionally but requires `x ≤ 1` (`lean/Topic.lean:164`); at x = 10 the bound fails. |
| [`adelic-transfer-operator`](topics/adelic-transfer-operator/README.md) | C4's "sum of d_a²" is a shortcut returning p/2 by construction; C2 for p ≥ 7 rests on a hardcoded cosine table; two Lean docstrings attribute invented identities to the source. |
| [`frozen-truths`](topics/frozen-truths/README.md) | "none promoted to a theorem" contradicts T1–T5, which are source entries 11.1/2.8/11.2/1.14/12.3; eight of the 90 entries appear in no row; stale build log. |
| [`gap-inventory-strengthening`](topics/gap-inventory-strengthening/README.md) | Its 13-row source-claim table has no `S#` labels, so the shared ledger reports 0; the same bookkeeping defect as C3, not a mathematical one. |
| [`harmonic-sine-transform`](topics/harmonic-sine-transform/README.md) | Child lengths are reversed relative to the algorithm; source theorem numbers 2.2/2.3 do not exist (the paper numbers by section). |
| [`harmonic-sine`](topics/harmonic-sine/README.md) | The errata catch the half-angle error but miss a second step-size clash in the same source (π/(n+1) vs π/(n+2)); the "12-point grid" is 13 points. |
| [`harmonic-sine-eta`](topics/harmonic-sine-eta/README.md) | A cited Lean name `sum_range_two_mul` does not exist (it is `sum_range_pair`); "every N ≥ 2" tested only to 8. |
| [`harmonic-sine-greedy-harmonic-essays`](topics/harmonic-sine-greedy-harmonic-essays/README.md) | Claims the inventory calls item 38 "duplicates items 15 and 17"; the item is tagged *archived claim / superseded*, not duplicate, and the quoted phrase does not appear. A 10⁻¹² tolerance is really π/301 + 10⁻¹², and all targets terminate exactly. |
| [`greedy-harmonic-decomposition`](topics/greedy-harmonic-decomposition/README.md) | C1's recursion can never fire (thresholds equal α_n by monotonicity), so it compares α_n with itself; the source status "open/exploratory" is actually superseded by the source's Theorem 4.3. |
| [`harmonic-geometric-unified-theory`](topics/harmonic-geometric-unified-theory/README.md) | Its 14-row source-claim table is unlabelled, so the shared ledger reports 0 (C3); C7 checks `len == 4` and one label rather than the stated rankings. |
| [`harmonic-categorical-hilbert-polya`](topics/harmonic-categorical-hilbert-polya/README.md) | The truncation sums j = 0..N−1 while the source sums j = 1..∞, so "reproduces equation (2)" includes an extra term. |
| [`qefe`](topics/qefe/README.md) | Says §5.1's manipulation is "never supplied"; §5.2 supplies one. C5 is vacuous at the centre (Ψ(1/2) real). |
| [`research-programme-iii`](topics/research-programme-iii/README.md) | "With the standard factor 2 the values are integers" is false at k = 3, n = 1 (5 + √5). |
| [`periodic-orbits`](topics/periodic-orbits/README.md) | T7/C6 credit a "full twist writhe n(n−1)" that is defined as `n*(n−1)` in Python and proved as `0 < replicate …` in Lean; nothing constructs it. |
| [`topological-zeta`](topics/topological-zeta/README.md) | `nonunit_egyptian_sum` ignores `ms[1:]`, so the non-unit sum is never computed; C6 refutes only the Ising case, not the SU(2)₄ case that carries the "10 significant figures" claim. |
| [`yakaboylu-notes`](topics/yakaboylu-notes/README.md) | M(s) is labelled the eta factor but misses 2^s π^{s−1} sin(πs/2) Γ(1−s); at 0.3 + 2i the values differ (0.535+0.753i vs 0.570+0.776i). |
| [`eml-universal-operator`](topics/eml-universal-operator/README.md) | T1–T3 are definitional unfoldings; the "corrected recurrence" tracks the accumulated angle separately, so it recomputes an exact sine rather than propagating one, making its convergence test nearly forced. |
| [`isabelle-afp`](topics/isabelle-afp/README.md) | 976 vs 972 count, repeated in three files. |
| [`finance-trading`](topics/finance-trading/README.md) | Provenance table includes an unlinked ebook and omits two index entries; also "out of scope" in the topics README but present with a full dossier and ratings. |

Full verdict list in Appendix A. The pattern is consistent: **the ledger
discipline is strong, the bookkeeping is hand-made, and the tests often check a
reimplementation rather than the source claim.** A generated ledger plus
mutation testing would remove most of the list above.

---

## 7. Open questions for the author

1. **Q1.** Is there an independent criterion for "balanced" that does not
   already presuppose the zeros? (§5.1)
2. **Q2.** Can "the additive toolbox" be formalised, or should C.10 be stated
   as a result about the specific ingredients listed in its proof? (§5.2)
3. **Q3.** Can the finite-prefix theorem be strengthened to a genuine
   asymptotic no-go within a constrained class? (§5.3)
4. **Q4.** Is there a category in which Weil positivity and the parity coupling
   are instances of one object? (§5.4)
5. **Q5.** Which theorem uses a certified enclosure as a hypothesis? (§5.6)
6. **Q6.** What is the intended reader and entry point: the HTML page, the
   Markdown README, or both? (S1)
7. **Q7.** Are `summary/` and `summary-rh/` part of the publication or local
   evidence? (S4)
8. **Q8.** Is `BUILD.log` a checked record or a local artefact? The answer
   decides the quote-staleness problem. (S8)
9. **Q9.** Should the 45 dossiers remain in the same repository and tree as the
   letter, or become a separate annex? The folder is 27 MB once Lean has been
   built (14 MB of source), and it dominates the tree.
10. **Q10.** What is the maintenance model for 45 ledgers, 45 index pages, and
    45 build logs? Without generation, S8 and C8 will recur.
11. **Q11.** Should the editorial ratings in the topics index (novelty/value/
    tractability, 1–5) be published? They are unattributed judgements, and
    several look high for the most speculative dossiers (QEFE 5/5, topological
    zeta 5/5, self-adjoint 5/5 vs tractability 1).
12. **Q12.** Is "futility" the right frame for a body of work whose real
    achievement is an audit? The audit is more persuasive than the elegy.

---

## 8. Suggested investigation order (nothing done)

1. **Decide the publication model** (Q6) before touching any link.
2. **Fix the link base and add a link check** to
   [`tools/verify-all.sh`](topics/tools/verify-all.sh). This is mechanical and
   closes 387 findings at once.
3. **Reconcile the third-objective status** across `README`, `STATUS`,
   `ABSTRACT`, and the dossier; remove the "remaining work is mechanical"
   sentences; correct S6 and the `Topic.lean` header.
4. **Add a verification column** to the letter's tables (`paper proof`,
   `Lean`, `numerical`, `source claim`) and downgrade "proves" accordingly.
5. **Generate the counts and timings**; stop hand-maintaining them.
6. **Fix or demote the four significant dossiers** (`self-adjoint-ccm`,
   `theorems-paper-series`, `phase-interference`, `gdpt`).
7. **Rewrite the finite-prefix prose** to match the Lean theorem, or strengthen
   the theorem (Q3). This is the one place where the gap is conceptual, not
   clerical.
8. **Commit in an order that works**: `.gitignore` first, then evidence
   corpora, then the letter, then the dossier artefacts.
9. **Add a date, an author line, and a licence**; the folder has none.

---

## 9. Verification side effects (disclosed)

These are changes made by the review process, not corrections:

- Running the 45 pytest suites created `__pycache__/`, `.pyc` files, and (in 30
  places) `.pytest_cache/` directories; the pytest caches were removed again,
  the `__pycache__`/`.pyc` files remain (already covered by `.gitignore`).
- Running [`tools/check-all-lean.sh`](topics/tools/check-all-lean.sh) rebuilt
  61 Lean modules. It **regenerated every `lean/BUILD.log`** with fresh
  timings and wrote `.olean` files. The tree grew from ~14 MB to ~27 MB.
- Per-topic Lean build times in the new logs may differ from the values quoted
  in READMEs.
- A scratch directory used to organise the per-topic audit was removed.
- This file ([`comments.md`](comments.md)) is the only new document. No
  README, status file, ledger, test, or Lean source was edited.

If the directory is to be committed, add `*.olean` to `.gitignore` and decide
whether regenerated `BUILD.log` timings are wanted in the history.

---

## Appendix A — verdicts for all 45 topics

Legend: **S** solid · **m** minor issues · **!** significant issues. The
"headline" is one finding, not the whole dossier; many are otherwise strong.

| Topic | V | Headline |
|---|---|---|
| adelic-transfer-operator | m | C4 sums a shortcut, not the quantum dimensions; invented source attributions |
| dyadic-sheaf-cohomology | ! | Lean README contradicts its own file; `energy_symm` missing from ledger |
| eml-universal-operator | m | T1–T3 definitional; "corrected" recurrence recomputes an exact sine |
| factorisation-theta | m | Lean root at x = 0 via totalised division; two objects named Θ_N |
| finance-trading | m | Provenance table wrong; out-of-scope dossier included |
| frozen-truths | m | "No promotion" contradicts T1–T5; eight entries uncovered |
| gap-inventory-strengthening | m | Unlabelled source-claim table makes the shared ledger report 0 |
| gdst | m | T5 missing its `x ≤ 1` hypothesis |
| gdst-twin-series | m | Wrong item-9 cross-reference; source's own retraction not recorded |
| geometric-dynamical-phase-transitions | ! | 108-row ledger inflated; T10/T11 missing `1 < N`; stale counts |
| geometric-reformulation | m | C3 tautological; "proved" torsion is a Lean definition |
| ghd-correlation-kernel | m | C7/C8 test-number swap; source table has no labels |
| greedy-harmonic-decomposition | m | C1 recursion never fires; stale "open" status for a refuted claim |
| greedy-harmonic-hilbert-polya | m | Q at n = 0 is not the source's Q₀; n = 0 convention inconsistent |
| greedy-harmonic-sine-parity | m | S1 drops the complexity law's hypothesis; C4 range wider than test |
| greedy-harmonic-transfer-operator | m | Documented example value wrong (2/3 vs 2/9); stale build time |
| greedy-harmonic-zeta | S | Residual nit on which σ values C6 scans |
| harmonic-categorical-hilbert-polya | m | Truncation includes the j = 0 term the source omits |
| harmonic-geometric-unified-theory | m | Unlabelled source-claim table; C7 checks a list length, not rankings |
| harmonic-sine | m | Misses the source's second step-size clash; 13 points called 12 |
| harmonic-sine-eta | m | Cited Lean name does not exist; "every N" tests N ≤ 8 |
| harmonic-sine-greedy-harmonic-essays | m | Misquoted scraps entry; convergence never exercised |
| harmonic-sine-transform | m | Child lengths reversed; source theorem numbers invented |
| hst-programme | S | One unflagged source recurrence |
| iota-helix-function | m | Its own erratum mis-states the conjugate exponent; test numbering shifted |
| isabelle-afp | m | 976 entries vs 972 directories |
| nested-spheres-continuous-cone | S | Formalises radius scaling, not spheres |
| padic-stochastic-zeta | S | T3 omits the prime hypothesis |
| partial-sum-plus-tail | m | Self-contradictory atom status; sin/cos method misattributed |
| periodic-orbits | m | "Full twist writhe" is fabricated by definition |
| phase-interference | ! | PSD test accepts non-PSD matrices |
| prime-spectrum-tensor | S | Sum range differs from its docstring (harmless) |
| proof-99-global-harmonic-framework | m | T7 proves det(D²), not the source's det(1−D²) |
| qefe | m | Misdescribes §5.2; centre test vacuous |
| qefe-research-notes | S | "Silent" normalisation was announced but not carried out |
| quaternion-cosine | S | δ points target−phase, described the other way |
| research-programme-iii | m | False integer claim for the standard normalisation |
| rh-mtc-padic | S | "Theorem 4" is an unnumbered theorem |
| riemann-helix | S | C6 cross-reference typo |
| self-adjoint-ccm | ! | c(p^m) = 0 contradicts Λ(p^m) = log p; gaps relabelled |
| sinc-sine-kernel-moments | S | Test docstrings shifted one C-number |
| theorems-paper-series | ! | Errata E3 wrong; E5 calls a typo a gap |
| topological-zeta | m | Non-unit sum ignores its denominators; C6 tests the wrong completion |
| transfer-operator-proof | S | Thinnest rows are decorative |
| yakaboylu-notes | m | M(s) is not the eta factor; C4 range overstated |

---

## Appendix B — verification log

```
python3 topics/tools/audit_topics.py          # OK: 45 topic folders pass
bash    topics/tools/run-tests.sh             # 406 passed, 45 suites, exit 0
bash    topics/tools/check-all-lean.sh        # 61 x [check] OK, exit 0
python3 (link scan)                           # 1687 md links, 387 broken
python3 (html link scan)                      # index 0 broken; topics 0; scraps 1
```

Spot-checked line references used above: `STATUS.md:7`;
`README.md:11`; `partial-sum-plus-tail/README.md:186,191,206`;
`partial-sum-plus-tail/index.html:144,154,165`;
`partial-sum-plus-tail/lean/Topic.lean:12`; `lean/Transcend.lean:317,362`;
`lean/FinalLetter/Chowla.lean:337,395,413`;
`self-adjoint-ccm/README.md:36,60` and `python/programme.py:144,157`;
`phase-interference/python/programme.py:164`;
`topological-zeta/python/programme.py:74`;
`geometric-dynamical-phase-transitions/lean/Bridges.lean:49,70`;
`geometric-dynamical-phase-transitions/lean/Computations.lean:414`;
`theorems-paper-series/README.md:124`; `dyadic-sheaf-cohomology/README.md:72`;
`factorisation-theta/lean/Topic.lean:39`.

---

*Review written for investigation, not correction. If any single finding is
acted on first, make it S2 (the links) or §5.3 (the finite-prefix claim): the
first is mechanical, the second is the one place where the letter's prose and
its Lean theorem say different things.*
