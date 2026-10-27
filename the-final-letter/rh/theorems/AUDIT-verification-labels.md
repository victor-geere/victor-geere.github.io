# Audit: do the archive's verification labels hold up?

*Commissioned by the user. Read-only: nothing in the archive was modified by this audit except one
typo in a document I wrote myself. Method and limits are stated at the end — this is a **sample plus
two exhaustive mechanical sweeps**, not a proof about every one of the 1212 theorem documents.*

## Why this audit exists

Earlier in the same session I published a claim labelled EXTERNAL-with-citation that was **false**:
that `Σ λ(n)λ(n+1) = o(x)` is a theorem of Matomäki–Radziwiłł–Tao. It is not; MRT prove the
shift-*averaged* form. The label was correct in form and the citation was wrong, and **every machine
check in the repository passed** — a misattributed external theorem is invisible to formal
verification. The archive's whole value rests on its labels being true, so they were audited.

## What was checked, and how

| pass | scope | method |
|---|---|---|
| **A** Lean references | every backticked identifier in `theorems/**` and `research/**` that looks like a Lean name | indexed against 661 archive declarations and 165 893 Mathlib declarations (tactics/env vars/Python names triaged by hand) |
| **A′** evidence artifacts | every named `*.py *.log *.txt *.csv *.json *.npy *.rs *.sh` in the same 1250+ documents | existence check against the whole tree (752 references) |
| **B** labels | 40 documents sampled across four Status classes by five parallel agents, each required to quote file:line evidence | lean-proved (200 matched), paper-argument (337), numerical (261), cited (163), refuted |
| **C** spot-checks | the three most serious Pass-B findings | re-verified by me directly |

**Headline: the label system is sound, and the strongest label is the most reliable.** But there are
three systematic weaknesses, all of the same kind — a label advertising evidence that the
repository does not contain.

## Findings

### 1. Lean references: clean (exhaustive)

Every Lean identifier cited anywhere in the prose resolves to a real declaration. The three
candidates that looked dangling were triaged and are all false positives: `allzero_gap`/`allzero_ref`
are Python cross-check functions, `corrSubset_abs_sub_le` is explicitly a *planned* declaration in
`open/07-open-problems.md` ("Next step. Create rh47/lean/Rh47/Sparse.lean with …"), and
`corrSlice_sub_corr_self_eq` is described in Rh46 itself as "recorded as a comment".

### 2. Evidence artifacts: one genuine undisclosed dangling reference (exhaustive)

Of 752 named artifacts, all exist except:

* **`compute_rh17.py` — cited by 3 documents, exists nowhere** (`rh17-l2-aliasing-bound.md`,
  `rh17-t1-certified-sections.md`, `rh17-t2-exact-sections.md`), where it is credited with producing
  "54 named checks" and with the interval evaluation of every constant. `find` over the whole tree
  returns nothing; the only mentions are the documents themselves and `rh17.html:598`. **Verified by
  me.**
* `explicit_formula.log` — cited by 3 documents, also absent, **but the archive discloses this
  itself**: `checks/06-numerical-checks.md:378` reads "**`rh45/verify/explicit_formula.log` DOES NOT
  EXIST**", and `:828` "was never committed (the run was interrupted)". This is exemplary, not a
  defect.

### 3. Label classes, sampled (40 documents, 5 agents, evidence quoted)

**`PROVED (Lean …)` — 10/10 held up.** In every sampled case the named declaration exists in the
cited file and its statement matches the prose claim, several character-for-character
(`Smoothing.lean:269-272`, `Impossibility.lean:21-22`, `Tau.lean:169-195`, `Chowla.lean:427-429`).
Residual weaknesses are evidentiary, not mathematical: some ledger-restatement docs carry a
`PROVED (Lean)` label while naming no declaration (`tpp-dict-00-factor-complexity-law.md`); a cited
log refers to a path that has since moved; and `rh41`'s "31/31 pass" has a script with 31 checks but
**no stored run log**.

**`PROVED (paper argument)` — 7/10, three unsupported.**
* `tpp-rh40-round01-agentb-i-x-repair-realisable-window-starts.md` — **the most serious finding of
  the audit.** The source (`rounds/rh40/rounds/round01_agentB.md`) marks the passage `[CHARITABLE]`
  (a charitable restatement), and its own `[VERDICT]` at :80 reads "**the a_m+2 form still lacks a
  proof**" with an `[OPEN]` request at :84 for the missing injectivity proof. The theorem document
  nonetheless carries `Status: PROVED (paper argument)`. **Verified by me.**
* `rh17-l2-aliasing-bound.md` — the "every constant evaluated as an interval" clause rests on the
  absent `compute_rh17.py`; nothing in the archive reproduces the `4.2×10⁻¹⁸` figure.
* `rh33-modulated-crystal-loss-exact.md` — "verified to machine zero" with no rh33 script or log
  anywhere; the status line's numerical half is assertion only.

**`VERIFIED (numerical)` — 4/10, six problematic.** The dominant pattern is the `rh*.html` prose
series (`rh15`, `rh27b`, `rh36`, xihorn's horn-helix): the numbers exist only as prose in the cited
HTML page, and the page's claimed "N named checks plus the inline assertion suite" is **not in the
repository** — no `.py`, `.rs` or `.log` computes them. Two are outright mismatches:
* `tpp-rh40-readme-m9-single-one-word-solved.md` — credits `verify/probes.py` with the single-one
  law; the string `min(L` does not occur in that script, and the labelled exhaustive sweep
  (239 599/239 599 over `a < 60, N < 120`) has no enumerator anywhere. **Verified by me.**
* `handoff-greedy-squaring-law.md` — the census figure 128 541 453 is attributed to
  `x = (π−3)/π`, but the archive's own enumerator (`verify/round7_AN_census.py:38`) and census
  journal attribute it to `x = π−3`, and no script or log records the figure.

**`CITED (literature)` — sampled OK.** Citations name specific sources, often with arXiv IDs; the
GPY citation was fetched and matches. Minor: some give only "classical (Hadamard)" with no page.

## Systemic conclusions

1. **The grading works.** Lean-proved is reliable (10/10); the weaker labels are the ones that fail,
   and they fail *as labelled* — what breaks is the parenthetical, not the grade.
2. **The failure mode is uniform:** a label advertises a specific evidence artifact (a script, a
   named-check suite, an exhaustive sweep) that is not in the repository. It is the same failure I
   committed with the MRT citation — **claiming a source that does not say what is claimed** — one
   level down.
3. **The `rh*.html` series is the weak stratum**, because its checks were run interactively and never
   committed, and the HTML asserts them in prose that later documents treat as evidence.
4. **Six of ten sampled numerical labels and three of ten paper-argument labels are affected.** If
   that rate holds across the 598 documents in those two classes, the affected population is in the
   low hundreds — the audit's most important quantitative statement, and the reason to sample further
   rather than generalise from 40.

## Recommended repairs, in order

1. **Demote `tpp-rh40-round01-agentb-i-x-repair-realisable-window-starts.md`** from PROVED to
   `OPEN` (source: `round01_agentB.md:80`), or attach the missing injectivity proof.
2. **Resolve `compute_rh17.py`**: commit the script, or demote the three documents' interval-evaluation
   clauses to "asserted by the source, not reproducible here".
3. **Add a `VERIFIED (numerical, evidence absent)` grade** and re-label the `rh*.html`-derived
   documents that have no committed script or log. The archive already uses this honesty elsewhere
   (`06-numerical-checks.md` disclosing the missing `explicit_formula.log` is a model to copy).
4. **Fix two small errors found in passing.**  (a) `theorems/tpp-checks-06-not-multiplicative-no-euler-product.md`
   Notes item 1 says `f(1) = +1` for `f(n) = λ(n)λ(n+2)`; it is `−1`, and this is
   **machine-checked** in this repository already — `ConeLean.chowlaAF_one : chowlaAF 1 = -1`
   (`lean/ConeLean/ParityObstruction.lean`).  The document's theorem is unaffected; a valid coprime
   witness exists.  (b) `theorems/lean-rh41-digitword-c1-bound-a0-necessary.md`'s Source line cites
   lines 619–621 while the declaration occupies 620–622 (619 is the docstring) — **verified by me**.
5. **Repeat Pass B on a larger sample** with a proper stratified draw, since 40 documents cannot
   support a rate estimate. This is cheap and I would run it as the next step.

## Limits of this audit

Passes A and A′ are exhaustive over the prose of `theorems/**` and `research/**`. Pass B is a
**sample of 40 from 1212 documents** (five agents, each instructed to quote file:line and to answer
UNVERIFIED rather than speculate); three of its most serious findings were re-verified by me
directly, and the rest are the agents' evidence, quoted but not independently re-checked. Nothing
here says any *mathematical* result is wrong — only that some labels advertise support the
repository cannot produce. The `refuted` class was sampled by an agent but its output was truncated
in transit and is **not** reported here.
