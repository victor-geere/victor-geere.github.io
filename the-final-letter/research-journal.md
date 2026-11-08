# Research journal — Euler–Maclaurin Lean layer and Objective III status

> **Continued in [`research-journal-002.md`](research-journal-002.md).**
> That file is the live journal: current state, exact next steps, pre-computed
> constants, and the traps already paid for. This file is the history up to
> entry I.282 and need not be read in order to continue the work.

**Started:** 25 October 2026
**Goal:** update proof layer C, `STATUS.md`, and all `the-final-letter/`
documentation to include the Euler–Maclaurin Lean layer; create a new
`topics/` dossier under the programme standard; update the root documents and
`topics/index.html`; then use `status.html` §§5–7 as the live research plan.

## 0. Starting state (audited before any edit)

The Euler–Maclaurin file
`topics/partial-sum-plus-tail/lean/EulerMaclaurin.lean` is a 1,611-line Lean
development. Its recorded build is `[check] OK EulerMaclaurin.lean (41s)` in
`topics/partial-sum-plus-tail/lean/BUILD.log`, with no `sorry`, `axiom` or
`admit` in the proof body. The declarations run from `periodicBernoulli` to:

- `finite_eulerMaclaurin` — the finite Euler–Maclaurin identity for a smooth
  function, all `K`;
- `finite_eulerMaclaurin_hurwitz` — the same for the Hurwitz term;
- `hasSum_periodicBernoulli_fourier` and
  `iSup_norm_periodicBernoulli_odd_le_zeta` — Fourier inversion and the
  Bernoulli sup bound;
- `differentiableAt_hurwitzZetaNP`, the iterated-derivative formula, tail
  integrability and decay;
- `norm_integral_periodicBernoulli_mul_odd_le` — the integral form of S2;
- `hurwitzZetaNP_eq_eulerMaclaurin` — S1, for `K ≥ 1`;
- `hurwitzZetaNP_eulerMaclaurin_with_bound` — S1 and the explicit S2 tail
  bound together, for `K ≥ 1`.

The documentation is split between two states. `index.html` proof ledger C,
`categories/05-proofs/lean.md`, the topic's theorem ledger says S1–S2 are Lean
theorems; `STATUS.md`, the topic README opening, `categories/05-proofs/proofs.md`,
the abstract, and several category pages still say they are only written
proofs. `topics/partial-sum-plus-tail/lean/README.md` says both in the same
section. This conflict is the first thing to remove.

The one claim that remains true everywhere is the wall-facing one: **no theorem
about either wall consumes a certified enclosure as a hypothesis**. The
Euler–Maclaurin layer makes the evaluator's analytic decomposition
unconditional, but it does not make the evaluator a bridge.

## 1. Research plan (written before starting the edits)

### Phase A — canonical fact and consistency audit

1. Treat `EulerMaclaurin.lean` and `BUILD.log` as canonical, not the prose.
2. Record the exact theorem names and the `K ≥ 1` hypothesis.
3. Define the new proof-ledger group **C8** and theorem rows **T36–T43**
   (see §2).
4. Update the Lean file's own header comment so it no longer says the finite
   induction, Fourier inversion and analytic continuation are unformalised.

### Phase B — proof layer C and status

1. Rewrite `categories/05-proofs/proofs.md` §C: add C8, T36–T43, and make the
   status paragraph say S1–S2 are Lean-proved for `K ≥ 1`.
2. Rewrite `categories/05-proofs/lean.md`, `STATUS.md`, and the root status
   summary.
3. Keep R13 but re-scope it: the analytic content is proved; what remains is
   wiring S1–S2 into the general certificate replay for arbitrary `s`.
4. Keep R14 (use as hypothesis) and R15 (width) open. Do not promote them.

### Phase C — all documentation

Update every page that states the old boundary, in this order:

1. root master files: `README.md`, `ABSTRACT.md`, `STATUS.md`,
   `GAP-LEDGER.md`, `EVIDENCE.md`, `TABLE-OF-CONTENTS.md`, `comments.md`;
2. numbered sections: `00-provenance/scope.md`, `01-description`,
   `02-abstract`, `04-conjectures`, `05-proofs`, `06-findings`,
   `07-significance`, `08-novelty`, `09-further-research`,
   `11-bridges`, `12-final-note`;
3. the Objective III dossier: `topics/partial-sum-plus-tail/README.md`,
   `index.html`, `lean/README.md`;
4. the canonical single-page `index.html`, fixing every sentence that still
   says S1–S2 are not Lean-formalised;
5. `topics/README.md`, `topics/STATUS.md`, `topics/index.html`,
   `topics/tools/build_topic_index.py`.

No new claim is added: S1–S2 are Lean theorems for `K ≥ 1`; the evaluator is
still not consumed by a wall theorem.

### Phase D — new topic dossier

Create `topics/euler-maclaurin/` following `topics/PROGRAMME-STANDARD.md`:

```
topics/euler-maclaurin/
  README.md
  index.html
  python/__init__.py
  python/programme.py
  tests/test_programme.py
  lean/README.md
  lean/Topic.lean
  lean/check.sh
```

`lean/Topic.lean` is a checked mirror of the canonical Euler–Maclaurin layer
(source: `topics/partial-sum-plus-tail/lean/EulerMaclaurin.lean`). A Python
test verifies the mirror byte-for-byte, so the dossier cannot silently drift
from the file it documents. The dossier's ledger has T36–T43 only; the
authoritative full ledger remains proof layer C and the partial-sum-plus-tail
page.

The Python layer is a small exact-rational companion:

- exact Bernoulli numbers and periodic Bernoulli values;
- a finite Euler–Maclaurin identity for polynomials, checked over `Q`;
- the S2 tail-radius formula as a documented floating-point computation with
  stated tolerance.

The dossier is **structural pass** only after `audit_topics.py`, the Python
tests, and the Lean build pass.

### Phase E — topics indexes

1. Add `euler-maclaurin` to the rating table in
   `topics/tools/build_topic_index.py`.
2. Add the row to `topics/README.md` and `topics/STATUS.md`.
3. Regenerate `topics/index.html` with the builder.
4. Update `TABLE-OF-CONTENTS.md` and `EVIDENCE.md` counts.

### Phase F — attack `status.html` §§5–7

Use the status page as the live plan:

- **§5 outstanding:** mark the S1–S2 formalisation item resolved; keep
  R14, R15, derivative/contour, arbitrary-`s` replay, and all wall items open.
  Add the new Euler–Maclaurin dossier as evidence.
- **§6 bridges:** update B11 from "written proof / not formalised" to
  "Euler–Maclaurin Lean-proved; still not a bridge; R14/R15 open". Keep the
  bridge requirements exactly the same: global positivity, DH-failure,
  pointwise correctness, OP-19 coupling.
- **§7 roadmap:** mark P0 resolved, P1 partly done (analytic theorem proved;
  wiring open), keep P2–P6. Add the concrete next theorem: a general replay
  whose only inputs are Lean theorems.
- Update the source-status caveat to say the conflict is resolved, not that it
  remains. Do not claim any wall theorem uses an enclosure.

### Phase G — verification

1. `grep` for the stale strings: `not Lean-formalised`, `written proof but`,
   `S1–S2` where it implies unproved, `only Euler–Maclaurin`.
2. Run `python3 -m pytest` for the new dossier.
3. Run `topics/euler-maclaurin/lean/check.sh`.
4. Run `topics/tools/audit_topics.py`.
5. Regenerate/check `topics/index.html`.
6. Re-read the changed pages for status consistency.

## 2. How the pieces fit together

The canonical chain is:

```
EulerMaclaurin.lean  (S1/S2, K ≥ 1)
        │
        ├── proof ledger C, group C8, T36–T43
        │        │
        │        ├── STATUS.md / README / ABSTRACT / GAP-LEDGER
        │        ├── categories/00–12
        │        └── index.html
        │
        ├── topics/partial-sum-plus-tail (canonical dossier)
        │        └── topics/euler-maclaurin (new, focused dossier)
        │                 └── topics/index.html / STATUS.md
        │
        └── status.html §§4–7 (live research plan:
              application to the walls, outstanding, bridges, roadmap)
```

The **new layer does not change the wall map**. It changes one status line:
the evaluator's analytic decomposition is no longer a source claim. Therefore:

- proof C gains C8 and T36–T43;
- the evaluator's status changes from "conditional on S1–S2" to
  "S1–S2 proved; general replay wiring open";
- R13 changes from "formalise Euler–Maclaurin" to "wire the proved general
  theorem into a replay for arbitrary `s`";
- R14 and R15 remain open, and the no-wall-theorem-consumes-an-enclosure
  sentence remains true;
- the new topic dossier is an annex to Objective III, not a new bridge.

## 3. Progress log

### 2026-10-25 — plan written

Audited the Lean file, build log, proof ledger C, STATUS.md, and the topic
pages. The conflict is confirmed and bounded. The plan above is the working
order. No documentation edits have been made yet.

### 2026-10-25 — Phase A/B: canonical facts and proof ledger C

- Read the final declarations of `EulerMaclaurin.lean`. The canonical theorem
  names and hypotheses are: `finite_eulerMaclaurin`,
  `finite_eulerMaclaurin_hurwitz`, `hasSum_periodicBernoulli_fourier`,
  `iSup_norm_periodicBernoulli_odd_le_zeta`,
  `differentiableAt_hurwitzZetaNP`, `iteratedDeriv_hurwitzTerm_eqOn`,
  `integrableOn_iteratedDeriv_hurwitzTerm`,
  `norm_integral_periodicBernoulli_mul_odd_le`,
  `hurwitzZetaNP_eq_eulerMaclaurin` and
  `hurwitzZetaNP_eulerMaclaurin_with_bound`, the last two for `K ≥ 1`.
- Defined proof-ledger group **C8** and theorem rows **T36–T43**. Updated
  `categories/05-proofs/proofs.md` (table, S1/S2 table, status paragraph,
  §E), `categories/05-proofs/lean.md`, and the topic README/lean README.
- The proof ledger no longer says S1–S2 are unformalised. The status sentence
  is now: the analytic content is proved; what remains is the replay wiring,
  R14 (use as a hypothesis) and R15 (width).
- Kept the wall-facing sentence true: no theorem about either wall consumes a
  certified enclosure.

### 2026-10-25 — Phase C: all documentation

Updated the root master files (`README.md`, `ABSTRACT.md`, `STATUS.md`,
`GAP-LEDGER.md`, `comments.md`), the numbered sections
`01`, `02`, `04`, `05`, `06`, `07`, `08`, `09`, `11`, `12`, and the canonical
single-page `index.html`. Every stale “written proof but not Lean-formalised”
string in the curated tree was removed and replaced with the `K ≥ 1` status.
The abstract, significance, novelty and final-note paragraphs now state the
Euler–Maclaurin layer as proved and keep R13–R15 open.

### 2026-10-25 — Phase D: `topics/euler-maclaurin`

Created the annex under the programme standard:

```
topics/euler-maclaurin/
  README.md
  index.html
  python/__init__.py
  python/programme.py
  tests/test_programme.py
  lean/README.md
  lean/Topic.lean       (byte-for-byte mirror of EulerMaclaurin.lean)
  lean/check.sh
```

The ledger has T36–T43 only. The Python layer checks exact Bernoulli numbers,
the finite Euler–Maclaurin identity over `Q` for polynomial `f`, and the S2
tail-radius shape. `tests/test_programme.py` enforces the byte-for-byte mirror
so the dossier cannot drift. Verification: 18 pytest tests pass; the mirrored
Lean file builds `[check] OK Topic.lean (73s)`; `audit_topics.py` passes
46/46.

### 2026-10-25 — Phase E: topic indexes

- Added `euler-maclaurin` to `topics/tools/build_topic_index.py` and
  regenerated `topics/index.html` (46 topics).
- Added row 46 to `topics/README.md` and the status table to
  `topics/STATUS.md`; recounted as 419 ledger theorems, 376 computations,
  424 tests, 46/46 Lean builds.
- Updated `TABLE-OF-CONTENTS.md` (46 topics, new dossier, status page).

### 2026-10-25 — Phase F: `status.html` §§5–7

Created `the-final-letter/status.html` as the live status document. The
structure is:

- §4 — how the third objective applies to the first two walls, including the
  general theorem template, the Riemann-side and parity-side uses, and the
  three candidate enclosure-as-hypothesis theorems.
- §5 — outstanding: resolved S1–S2/S3–S5/transcendentals; R13/R14/R15;
  research items (Weil positivity, OP-19, (M), F.4, Hilbert–Pólya,
  `Λ=0`, Jensen/Li, slow passage, straightening); formalisation debt.
- §6 — bridge ledger and per-bridge requirements, with Weil positivity broken
  into five concrete requirements and the common “arithmetic positivity”
  requirement stated once.
- §7 — roadmap P0–P8, with the concrete next theorem
  `zeta_replay_mem`.

The central logical point is stated explicitly: an enclosure proves a box
membership; a wall statement is universal/asymptotic; the evaluator can
discharge a finite premise but cannot supply the transfer principle. That is
why B11 is not a bridge and R14 is still open.

### 2026-10-25 — Phase G: verification

- `python3 -m pytest -q` in `topics/euler-maclaurin`: 18 passed.
- `topics/euler-maclaurin/lean/check.sh`: `[check] OK Topic.lean`.
- `topics/tools/audit_topics.py`: 46/46 structural pass.
- `topics/tools/build_topic_index.py`: regenerated 46-topic index.
- Grep sweep for stale strings in the curated tree; the remaining matches are
  in `archive/` and `rh/` snapshots, which are read-only evidence and are not
  part of the letter's status claims.
- `tools/check-links.py`: 18,436 internal links, 0 external, 0 broken in
  curated documents.
- `tools/run-tests.sh`: 424 passed across 46 suites.
- Fixed the topic audit and index builder to ignore hidden directories such as
  `.pytest_cache`; a test run no longer makes the structural audit fail.

### Open after this round

The journal's next round should start at P1 (replay wiring) and P3 (use as a
hypothesis). P5–P7 are research walls and should not be promoted to
engineering tasks. The status page is the live plan; update it when a roadmap
item moves.



### 2026-10-25 — P1 specification added

Wrote `topics/euler-maclaurin/notes/replay-wiring.md`, the concrete interface
for the next theorem `zeta_replay_mem`. It records:

- the two possible designs (opaque bounded atoms vs absorbing the integral into
  the remainder), and recommends the atom design because it mirrors
  `ReplayAtoms.lean`;
- the W1–W5 lemma decomposition, with statuses: W1 domain bridge partly
  available, W2 integral atom new, W3 Bernoulli atoms routine, W4 tail radius
  available in substance, W5 general `Expr` emission is the real engineering;
- the honest boundary: P1 closes R13 but not R14; P3 still needs a theorem whose
  premise is an enclosure;
- the first P3 candidate (`zero_isolated_of_box`) and the acceptance criteria
  for P1.

This does not change any status claim. It turns §7.1 from a slogan into a
checkable work item. The note is linked from `status.html` §7.1, the dossier
README and the dossier index.

### Verification this round

- `python3 -m pytest -q` in `topics/euler-maclaurin`: 18 passed.
- `python3 -m pytest -q` in `topics/partial-sum-plus-tail`: 14 passed.
- `topics/tools/audit_topics.py`: 46/46.
- `tools/check-links.py`: 0 broken curated links.
- Stale-string sweep over the curated tree: no matches for the old
  “not Lean-formalised” wording outside the journal's historical log.

### 2026-10-25 — Phase H: attacking P1–P4

This round attacked §7 of `status.html` in dependency order. P1 and P2 moved;
P3 and P4 were re-scoped against what P1 actually delivers.

**P1 — rectangle enclosure (partial).** New Lean file
`topics/partial-sum-plus-tail/lean/ReplayGeneral.lean`, no `sorry`/`axiom`:

- W1: `zeta_eq_hurwitzZetaNP_one` — at `a = 1` the non-periodic Hurwitz zeta
  is `riemannZeta`, for `s ≠ 0`.
- W2: `norm_integral_le_radius` — the integral is bounded by the rational
  `integralRadius S M = (M+1)^(1-⌊Re lo⌋)/(Re lo−1)`.
- W3: `norm_cpow_neg_le_radius`, `norm_cpow_neg_sub_le`,
  `norm_iteratedDeriv_le`, `norm_bernoulli_le` — power, derivative and
  Bernoulli atoms get rational radii. The power bound is the crude
  `‖b^{−s}‖ ≤ b^{−⌊Re lo⌋}`; no complex `exp`/`cos` certificate is needed for
  an existence enclosure.
- W4: `riemannZeta_nat_re_le_two` (`ζ(2K+1) ≤ 2`), `norm_tail_le` — the S2
  tail is bounded uniformly on the rectangle using `π ≥ 3`.
- W5: `zeta_mem_box`, assembled as a sum of five balls, and
  `zeta_two_mem_box` at `s = 2`, `M = 3`, `K = 2`.

The theorem covers every `s` with `Re s > 1`, every `M ≥ 1` and `K ≥ 1`, with
no atom hypothesis. It is deliberately crude: it is an existence enclosure,
not a narrow one. What it does not do: the eta reduction to `0 < Re s ≤ 1`,
and a single symbolic `Expr` whose `wf` is checked.

**A distinction the round exposed.** `Replay.lean`/`ReplayAtoms.lean` prove
`cert.eval σ ∈ cert.box`; they do not prove `cert.eval σ = ζ(2)` — the tail
atom is `0`, and the outer inflation absorbs the tail analytically. The
missing certificate-value-to-ζ link is precisely what S1/S2 supplies, and
`zeta_mem_box` now supplies it uniformly for `Re s > 1`. That is why P1 is
partial rather than done.

**P2 — width (done as a format).** New Lean files `Width.lean`,
`WidthCheck.lean`:

- `Cx.width` (coordinate width), `Expr.wfWidth A w e` (well-formedness and
  `e.box.width ≤ w`), and `Expr.wfWidth_sound`.
- The ζ(2) replay is accepted at target `10⁻⁴` with every atom discharged
  (`cert_wfWidth`, `cert_mem_width`). The actual width is about `1.5·10⁻⁵`.

**P3 — template only.** `EnclosureHypothesis.lean` records
`ne_zero_of_mem_of_not_mem_zero`. It is not promoted to a P3 instance: the
premise must be a critical-strip enclosure, which P1 does not yet reach, and
no trivial ζ(2) nonvanishing claim is passed off as the finite-window theorem.

**P4 — untouched.** The finite-window explicit formula remains research and is
downstream of the P3 enclosure. `status.html` §7.3 states the dependency.

**Documentation.** Updated `status.html` §§1, 3.2, 5.1–5.4, 6.2, 7, 8.1, 8.3;
the dossier `README.md`, `lean/README.md`, `BUILD.log` and
`notes/replay-wiring.md`; proof ledger C (new groups C8a/C8b, T44–T51);
`STATUS.md`, `ABSTRACT.md`, the abstract and novelty sections, and
`categories/09-further-research/further-research.md` R13–R15.

### Verification this round

- `topics/partial-sum-plus-tail/lean/check.sh`: all 12 files `[check] OK`,
  including the four new ones; no `sorry`/`axiom`/`admit`.
- `python3 -m pytest -q` in `topics/euler-maclaurin`: 18 passed.
- `python3 -m pytest -q` in `topics/partial-sum-plus-tail`: 14 passed.
- `topics/tools/audit_topics.py`: structural audit.
- `tools/check-links.py`: no broken curated links (run after the docs edits).

### 2026-10-25 — Phase I: opening P3, P4, P5

A new goal targets P3–P5 under `topics/PROGRAMME-STANDARD.md`. This round
opened P3 with a new dossier, `topics/finite-window-zeros/`.

**Why the grouped eta series.** For `Re s > 0`,

```
η(s) = Σ_{m≥0} ((2m+1)^(-s) - (2m+2)^(-s)),      (1 - 2^(1-s)) ζ(s) = η(s).
```

The pairing is absolutely convergent for `Re s > 0` and gives a tail bound
`|pair_m| ≤ |s| (2m+1)^(-σ-1)`. A certified rectangle for `η` and a positive
lower bound for `|1 - 2^(1-s)|` therefore enclose `ζ` on a critical-strip
window; a box excluding zero certifies nonvanishing there. This is the P3
mechanism.

**Lean core (T1–T4).** `topics/finite-window-zeros/lean/Topic.lean`:

- `altPartial_two_mul`: finite regrouping of the alternating sum into pairs;
- `norm_pairTerm_le`: the mean-value pair estimate `‖pair_m‖ ≤ ‖s‖(2m+1)^(-σ-1)`;
- `summable_pairMajorant`, `summable_pairMajorant'`: the comparison sequence is
  summable for `p > 1`;
- `summable_pairTerm`: the grouped eta series is summable for `Re s > 0`.

No `sorry`, no `axiom`, `[check] OK`.

**Python layer.** `programme.py` computes `mpmath.iv` boxes for the grouped eta
series, the factor `1 - 2^(1-s)`, the explicit pair tail, and the quotient
`η/f` inflated by `tail/|f|`. The point certificate at `s = 1/2 + 5i`
(`M = 2000`) contains `ζ(s)` and excludes zero; at `s = 2` it contains `π²/6`.
Nine tests pass. This is a computation, not a kernel-checked theorem.

**What P3 still needs.** The Lean analytic continuation of
`(1-2^(1-s))ζ = η` from `Re s > 1` to `Re s > 0`; the Lean tail comparison; and
the Lean enclosure certificate. Until those exist, P3 stays open. The round did
not promote the point certificate or any ζ(2) nonvanishing claim to P3.

**P4/P5.** Untouched this round. P4 is downstream of the P3 enclosure. P5's
finite shadow belongs with `topics/prime-spectrum-tensor`, not here.

### Verification this round

- `python3 -m pytest -q` in `topics/finite-window-zeros`: 9 passed.
- `topics/finite-window-zeros/lean/check.sh`: `[check] OK Topic.lean`.
- `topics/tools/audit_topics.py`: 47/47.
- `topics/tools/build_topic_index.py`: 47 topics.
- Full test/link sweep to follow.

### 2026-10-25 — Phase I.2: the eta identity for the critical strip

The P3 dossier's analytic core is now Lean-proved in
`topics/finite-window-zeros/lean/Topic.lean`:

- `differentiableOn_etaGrouped` / `differentiableAt_etaGrouped`: the grouped eta
  series is differentiable on every bounded rectangle in `Re s > 0`, via
  `Complex.differentiableOn_tsum_of_summable_norm` and the pair estimate.
- `etaGrouped_eq_one_sub_two_cpow_mul_zeta`: the identity
  `(1-2^{1-s})ζ(s)=η(s)` for `Re s > 1`, by splitting `ζ` into odd/even terms.
- `..._of_im_pos`, `..._of_im_neg`: the identity on the two open quadrants
  `Re s > 0`, `± Im s > 0`, by the analytic identity theorem on convex sets.
- `..._of_re_pos`: the identity for every `0 < Re s`, `s ≠ 1`, by continuity
  from `Im s = 1/(n+1) → 0`.
- `zeta_ne_zero_of_eta_ne_zero`, `zeta_ne_zero_of_eta_mem`: nonvanishing of the
  eta value (or of an enclosing set excluding zero) transfers to `ζ`.

This is the analytic step P3 needed. The remaining numerical premise is a Lean
enclosure certificate for `etaGrouped` on a critical-strip rectangle; the Python
`mpmath.iv` point certificate at `1/2 + 5i` already shows the target is
comfortable. The point `s = 1` is excluded: the product has removable value
`log 2`, while `riemannZeta 1` is a junk value.

**Verification.** `[check] OK Topic.lean`; 9 Python tests; no `sorry`/`axiom`.

### 2026-10-25 — Phase I.3: the tail bound

Added the decreasing-sum/integral tail comparison to the P3 Lean core:

- `integrableOn_pairMajorant`, `integral_Ioi_pairMajorant`: the majorant
  `x ↦ (2x+c)^{-p}` is integrable on `Ioi 0` and integrates to
  `c^{1-p}/(2(p-1))` for `p > 1`, `c > 0`, via the explicit antiderivative.
- `tsum_pairMajorant_add_le`: the tail comparison
  `Σ_{m≥0}(2(m+M)+1)^{-p} ≤ (2M+1)^{-p} + (2M+1)^{1-p}/(2(p-1))`.
- `norm_tsum_pairTerm_tail_le`: after `M` pairs,
  `‖Σ_{m≥0} pairTerm s (m+M)‖ ≤ ‖s‖[(2M+1)^{-σ-1} + (2M+1)^{-σ}/(2σ)]`,
  `σ = Re s`.

With T5–T11, the analytic and analytic-tail parts of P3 are Lean-proved. The
remaining premise is the finite rational partial-sum enclosure and its replay.
The dossier now has 11 Lean theorems and 9 Python tests.

### 2026-10-25 — Phase I.4: the verified complex-power atom

Added `topics/partial-sum-plus-tail/lean/CpowBox.lean` (T52):

- `cpowExponent N b S = (-s)·log b`, built from `logIv` and the rectangle
  operations.
- `cpowBox N k n m b S`: `exp` of the real part (`expIvGeneral`), `cos`/`sin`
  of the imaginary part after a `2π` reduction (`cosBox`, `sinBox`,
  `reduce2pi`), and the product rectangle.
- `cpowBox_mem`: if `b ≥ 1`, `s ∈ S`, and the four rational side conditions on
  the log/exp/trig enclosures hold, then `b^{-s}` lies in the box.
- A concrete `3^{-(1/2+5i)}` instance: the four side conditions are discharged
  by `native_decide`.

This is the atom the P3 finite enclosure needs. The remaining engineering is the
pair/sum fold and a generated parameter list for a critical-strip point. The
file is added to the partial-sum-plus-tail build and ledger (T52).

### 2026-10-25 — Phase I.5: P3, first instance

`topics/finite-window-zeros/lean/Cert.lean` now proves

```lean
theorem zeta_half_plus_five_ne_zero :
    riemannZeta ((1 / 2 : ℂ) + 5 * Complex.I) ≠ 0
```

with no atom hypothesis. The proof:

1. `params 100` lists 100 `(2m+1, 2m+2)` pairs with uniform log/exp/trig
   parameters (`N=10`, `k=10`, `kI=32`, `n=12`).
2. `sumBox_mem` folds the verified `cpowBox` atoms into a box for the finite
   eta partial sum; `allOK` discharges the per-atom side conditions by
   `native_decide`.
3. `sumValue_params` identifies the folded value with the `Finset` partial sum.
4. `norm_tsum_pairTerm_tail_le` bounds the tail by `1`, so the final box is
   `sumBox + ball 1`.
5. `containsZero` is a rational test; `native_decide` proves zero is outside.
6. `zeta_ne_zero_of_eta_mem` transfers nonvanishing of `η` to `ζ`.

This is P3's acceptance: one theorem whose numerical premise is discharged by a
Lean certificate. It is a **pointwise finite-window theorem**, not a zero count
and not a statement about RH. The P3 row in `status.html` moves to done with that
qualification; R14 records its first instance but remains open for a
wall-facing theorem.

`Cert.lean` imports `CpowBox` from the sibling `partial-sum-plus-tail` topic via
`LEAN_EXTRA_PATH`; the rest of the dossier is self-contained. Build:
`[check] OK Topic.lean`, `[check] OK Cert.lean` (85s, dominated by
`native_decide`).

### 2026-10-25 — Phase I.6: P5 finite certificates; segment attempt

Two rational finite certificates were added to `prime-spectrum-tensor` (T8–T9):

- `G3_posSemidef`: `G3 = L3ᴴ L3` entrywise, hence `G3` is positive semidefinite. This is
  the finite form of a positive Gram matrix and the certificate shape a P5 finite shadow
  would use.
- `GDH_not_posSemidef`: the sign-flipped matrix `GDH = [[1,2],[2,1]]` has form value
  `-2` at the rational vector `(1,-1)`. This is a DH-shaped finite negative witness, not
  the actual DH arithmetic input.

A segment extension of the P3 certificate was attempted by replacing the point rectangle
`S0` with `[1/2,1/2] × [5, 5.00001]`. The generic fold and tail bound compile, but the
folded box did not exclude zero at the tested width, so the segment theorem was not
added. The point theorem `zeta_half_plus_five_ne_zero` is unchanged and remains the P3
instance. Subdividing the segment, or tightening the per-term box, is the next step.

### 2026-10-25 — Phase I.7: P4 opened

New dossier `topics/finite-explicit-formula` with the fixed tent test function
`f(x)=max(0,1-|x|)` and its cubic B-spline autocorrelation `g`.

Lean (`Topic.lean`, 3 theorems):

- `tent_nonneg`;
- `tentAutocorr_nonneg`;
- `tentAutocorr_even`.

Python (`programme.py`, 8 tests):

- exact rational values of `g` at `0, 1/2, 1, 3/2, 2`;
- a 40-digit `mpmath.iv` enclosure of the finite prime side for support `2`
  (prime powers `2,3,4,5,7`), a negative interval of width `< 10^-30`.

The analytic explicit formula, the archimedean term, certified zeros and the
tail are **not** formalised; they are recorded as source claims/open tasks. P4
is marked partial, not done. The next mathematical input is a certified zero
with its real part, which the present P3 apparatus does not provide.

### 2026-10-25 — Phase I.8: strict positivity of the P4 test autocorrelation

Added `tentAutocorr_pos`: `0 < g(x)` for every `|x| < 2`. The proof splits at
`|x| ≤ 1`, rewrites the cubic in `u = |x|`, and uses the factorisations
`6g = 1 + 3(1-u) + 3(1-u)^2 u` and `g = -(u-2)^3/6`. This is the finite cone-positivity
fact for the fixed test function; it does not prove the explicit formula.

### 2026-10-25 — Phase I.9: a Lean-certified prime term (P4)

Added `topics/finite-explicit-formula/lean/PrimeSide.lean`, which imports the
shared rational-interval layer and proves:

- `term2Box_mem`: the `n=2` prime term lies in its rational box;
- `term2_negative`: the box's upper endpoint is `< 0` (`native_decide`);
- `term2Value_negative`: hence the `n=2` term is strictly negative.

The enclosure uses `logIv` for `log 2`, the rational bound
`1/√2 ∈ [707/1000, 708/1000]`, and interval evaluation of
`x³/2 - x² + 2/3`. The full five-term prime side remains the Python
`mpmath.iv` computation; the Lean certificate is the format the remaining terms
will use.

### 2026-10-25 — Phase I.10: full finite prime side, Lean-certified (P4)

`PrimeSide.lean` now certifies all five contributing prime powers
`n = 2,3,4,5,7`:

- `sqrtInvBox_mem2/3/4/5/7`: rational enclosures of `1/√n`;
- `g1Box_mem`, `g2Box_mem`: interval evaluation of the two cubic branches;
- `termBox_mem`: the generic `-2(log p/√n)g(log n)` term;
- `primeSideBox_mem`: the five-term sum lies in its rational box;
- `primeSide_negative`: the box's upper endpoint is `< 0` by `native_decide`;
- `primeSideValue_negative`: the full finite prime side is negative.

This upgrades the P4 prime side from a Python-only computation (C2) to an
independent Lean interval certificate (T6). The analytic explicit formula, the
archimedean term, certified zeros and the tail remain open.

### 2026-10-25 — Phase I.11: generic finite P5 certificate lemmas

Added to `prime-spectrum-tensor` (T10–T11):

- `posSemidef_of_cholesky`: any rational matrix `Lᴴ L` is positive semidefinite;
- `not_posSemidef_of_neg`: a rational vector with negative form value refutes
  positive semidefiniteness.

These are the reusable finite certificate format behind `G3_posSemidef` and
`GDH_not_posSemidef`. They do not touch the infinite Weil current.

### 2026-10-25 — Phase I.12: P3 thin segment certified

`topics/finite-window-zeros/lean/Seg.lean` proves

```lean
theorem zeta_ne_zero_segment {s : ℂ} (hs : Cx.mem s Sseg) :
    riemannZeta s ≠ 0
```

for `Sseg = {1/2 + it : t ∈ [5, 5.000003]}`. The same 100-pair certificate is
used on the thin rectangle; at this width the folded box still excludes zero.
This upgrades P3 from a point to a genuine critical-line segment (T13). Wider
segments need subdivision; the rectangle width is the limiting factor.

### 2026-10-25 — Phase I.13: widening the certified segment

The thin segment was widened from `t ∈ [5, 5.000001]` to
`t ∈ [5, 5.000003]`. Widths `4·10^-6` and `3.5·10^-6` fail the box-excludes-zero
test; `3·10^-6` passes. This is the current width limit of the single-rectangle
certificate; further widening needs subdivision.

### 2026-10-25 — Phase I.14: continuity of the P4 test function

Added `tent_continuous : Continuous tent`, by
`continuous_const.max (continuous_const.sub continuous_abs)`. Also ran the
complete topic test suite: all 48 topic suites pass. The tentative
`integral_tent_sq` identity was not completed and is not claimed.

### 2026-10-25 — Phase I.15: the autocorrelation integral at zero (P4)

Added `integral_tent_sq`:

```lean
theorem integral_tent_sq : ∫ x in (-1:ℝ)..1, tent x ^ 2 = 2 / 3
```

The proof splits at `0`, replaces `tent` by `1+x` and `1-x`, substitutes
`u = x+1` and `u = 1-x`, and uses the FTC for `x^3/3`. This matches
`tentAutocorr 0 = 2/3`, the first point of the convolution identity
`g = f * f`; the full identity is still open.

### 2026-10-25 — Phase I.16: tent normalization

Added `integral_tent : ∫_{-1}^1 tent = 1`, by splitting at zero, substituting
`u = 1+x` and `u = 1-x`, and the FTC for `u^2/2`. Together with
`integral_tent_sq` this gives the two elementary moments used by the
autocorrelation/convolution analysis.

### 2026-10-25 — Phase I.17: numerical moment checks for P4

Added two 40-digit quadrature tests: `∫_{-1}^1 f = 1` and `∫_{-1}^1 f² = 2/3`,
matching the Lean theorems `integral_tent` and `integral_tent_sq`. These are
numerical checks (C3), not certificates. The autocorrelation integral
`∫_{-2}^2 g = 1` was not completed and is not claimed.

### 2026-10-25 — Phase I.18: numerical convolution checks (P4)

Added two 40-digit quadrature checks (C4–C5):

- `g(x) ≈ ∫ f(t)f(t-x)dt` at `x = 0, 1/2, 1, 3/2`;
- `∫_{-2}^{2} g = 1`.

These are numerical evidence for the convolution identity and the
autocorrelation normalisation, not certificates. The Lean proof of the full
identity remains open.

### 2026-10-25 — Phase I.19: the first autocorrelation integral (P4)

Added `integral_g01 : ∫_0^1 g = 11/24`. The proof rewrites `g` to the cubic
`x^3/2 - x^2 + 2/3` on `[0,1]`, then applies the FTC with the antiderivative
`x^4/8 - x^3/3 + 2x/3` (via `HasDerivAt`). The second piece
`∫_1^2 g = 1/24` was attempted but not completed.

### 2026-10-25 — Phase I.20: autocorrelation boundary values

Added `tentAutocorr_one : g(1) = 1/6` and `tentAutocorr_two : g(2) = 0`,
the matching and outer boundary values of the two cubic branches. The second
autocorrelation integral `∫_1^2 g = 1/24` was attempted but not completed.

### 2026-10-25 — Phase I.21: second autocorrelation piece

Added `integral_g12 : ∫_1^2 g = 1/24`, using the antiderivative
`F2(y) = -y^4/24 + y^3/3 - y^2 + 4y/3` and the FTC. The endpoint `x=1` is
handled by the matching branch value. Together with `integral_g01` this gives
the full `∫_0^2 g = 1/2`; the symmetric `∫_{-2}^2 g = 1` still needs an
integrability/symmetry step and is not yet claimed.

### 2026-10-25 — Phase I.22: full autocorrelation normalization (P4)

Added `integral_g02 : ∫_0^2 g = 1/2` and
`integral_tentAutocorr : ∫_{-2}^2 g = 1`. The proof uses the two cubic
pieces, `ContinuousOn` on `[0,1]`/`[1,2]`, `IntervalIntegrable` under negation,
and the evenness of `g`. This gives the `ĝ(0)=1` normalization of the fixed
test function; the full convolution identity `g = f*f` is still open.

### 2026-10-25 — Phase I.23: convolution at zero

Added `autocorr_at_zero : ∫ f(t)f(t)dt = g(0)` for the tent function, by
rewriting the product to `f²` and using `integral_tent_sq`. This is the first
point of the full convolution identity `g = f*f`; the identity at `x=1` and
beyond remains open.

### 2026-10-25 — Phase I.24: tent boundary values

Added `tent_zero : f(0)=1` and `tent_one : f(1)=0`. The `x=1` convolution
point was attempted again but the `integral_congr` step still did not close;
it is not claimed.

### 2026-10-25 — Phase I.25: convolution at x=1

Added `autocorr_at_one : ∫_{-1}^1 f(t)f(t-1)dt = g(1) = 1/6`. The proof
splits at 0, shows the negative half is zero, reduces the positive half to
`∫_0^1 t(1-t)`, and evaluates it by the FTC. Together with `autocorr_at_zero`
this certifies the convolution identity at two points.

### 2026-10-25 — Phase I.26: P4 gap analysis

Recorded the exact remaining P4 inputs in the dossier and status page:
the general convolution identity, the analytic explicit formula, a rigorous
archimedean integral, and a certified zero side with real parts (plus a
zero-counting tail). The P3 apparatus gives non-vanishing/zero-free segments,
not zero isolation, so the zero side is the binding gap.

### 2026-10-25 — Phase I.27: convolution at x=3/2

Added `autocorr_at_three_halves : ∫_{-1}^1 f(t)f(t-3/2)dt = g(3/2) = 1/48`.
The support intersection is `[1/2,1]`; the negative part is zero, and the
remaining quadratic integrates by the FTC. Together with `x=0` and `x=1`,
the convolution identity is now certified at three points.

### 2026-10-25 — Phase I.28: convolution outside the support

Added `autocorr_at_five_halves` (`x=5/2`) and `autocorr_at_two` (`x=2`).
In both cases the supports are disjoint (or meet only at an endpoint), the
integrand is zero, and `g` vanishes there. The convolution identity is now
certified at `x = 0, 1, 3/2, 2, 5/2`.

### 2026-10-25 — Phase I.29: convolution identity outside the support

Added the first **general** case of the convolution identity:

```lean
theorem autocorr_outside_support {x : ℝ} (hx : 2 ≤ |x|) :
    ∫ t in (-1:ℝ)..1, tent t * tent (t - x) = tentAutocorr x
```

The proof shows the shifted support is disjoint, so the integrand vanishes
(`autocorr_eq_zero_of_two_le`), and `g(x)=0` there
(`tentAutocorr_eq_zero_of_two_le`). The remaining case is `|x| < 2`.

### 2026-10-25 — Phase I.30: convolution identity on [1,2]

Added the general theorem

```lean
theorem autocorr_between_one_two {x : ℝ} (hx1 : 1 ≤ x) (hx2 : x ≤ 2) :
    ∫ t in (-1:ℝ)..1, tent t * tent (t - x) = tentAutocorr x
```

The proof splits at `x-1`, shows the left piece is zero, reduces the right
piece to `∫_{x-1}^1 (1-t)(1-x+t)`, and applies the FTC with the parameterized
antiderivative `(1-x)t + (x/2)t² - t³/3`. Combined with T25, the convolution
identity now holds for all `x ∈ [1,2]` and all `|x| ≥ 2`.

### 2026-10-25 — Phase I.31: convolution identity on [-2,-1]

Added `autocorr_between_neg_two_neg_one`, the negative-side counterpart of
T26. The proof splits at `x+1`, shows the outer piece is zero, reduces to
`∫_{-1}^{x+1} (1+t)(1+x-t)`, and uses the FTC with
`(1+x)t + (x/2)t² - t³/3`. Combined with T25–T26, the convolution identity
now holds for every `|x| ≥ 1` and on both intervals `[1,2]` and `[-2,-1]`.
The remaining region is `|x| < 1`.

### 2026-10-25 — Phase I.32: convolution grid check

Added C6, a 40-digit quadrature check of `g(x) ≈ ∫ f(t)f(t-x)dt` on
`x ∈ {-0.9,-0.8,...,0.9}` (tolerance `1e-5`). This covers the remaining
`|x|<1` region numerically; the Lean proof for that region is still open.

### 2026-10-25 — Phase I.33: start of the full-P4 zero-isolation route

The user chose the full P4 route. A feasibility probe (`finite-window-zeros/python/zero_probe.py`)
computes the floating winding number of `η` around
`Re ∈ [0.4,0.6]`, `Im ∈ [14.0,14.3]`: it is `1`, with minimum boundary modulus `> 0.1`.

The probe also records the obstruction: the P3 grouped-eta tail bound at `σ ≈ 0.5`
is `O(|s|/√M)`, so resolving a neighbourhood of the first zero with the existing
rational enclosure would need `M ~ 10^8`. An accelerated eta representation
(Euler transform or Riemann–Siegel) is required before a Lean zero-isolation
certificate can be built.

### 2026-10-25 — Phase I.34: numerical first-zero datum

Added a 50-digit `mpmath` computation of the first zero ordinate:
`14.134725141734693790457251983562470270784257115699`. This is a numerical
datum (C8), not a certificate. The Euler-transformed eta tail remains the
obstruction to a rigorous zero isolation; the Euler remainder for complex `s`
is not yet bounded.

### 2026-10-25 — Phase I.35: Euler–Maclaurin interval zeta

Added `finite-window-zeros/python/accelerated.py` (C9). It implements the
Euler–Maclaurin continuation of `ζ` for `Re s > 0` with `N=K=20` and a
remainder bound

`|R| ≤ |(s)_{2K+1}| · 2ζ(2K+1)/(2π)^{2K+1} · N^{-σ-2K}/(σ+2K)`.

At `s = 1/2+14i` the interval width is `~5·10⁻³⁰`, and the box contains the
`mpmath.zeta` value. This removes the P3 tail obstruction for function values.
A certified winding/zero isolation from these boxes is the next step; the
current winding routine is still numerically coarse and is not claimed.

### 2026-10-25 — Phase I.36: EM enclosure validated; winding obstruction isolated

The Euler–Maclaurin enclosure is validated at heights 14, 20 and 30 (boxes
contain `mpmath.zeta`; widths `< 10^-12`). The remaining obstruction is not the
value enclosure but the **argument/derivative** bound: the interval image of a
short boundary segment is about an order of magnitude wider than the true image
variation, so the crude argument-box winding accumulates to `~18·2π` instead
of pinning `2π`. A certified zero isolation now needs either a tighter
derivative/argument enclosure or a formal argument-principle/Krawczyk step.

### 2026-10-25 — Phase I.37: Cauchy derivative bound

Added `zeta_deriv_bound`, a rigorous `|ζ′| ≤ M/pad` bound via Cauchy's
estimate on a padded rectangle. With `pad=0.05` it gives `|ζ′| ≤ 34`, which is
far too coarse for a Krawczyk contraction (the true derivative is order one).
The derivative must instead be enclosed by differentiating the
Euler–Maclaurin formula term-by-term.

### 2026-10-25 — Phase I.38: numerical Krawczyk zero isolation

Added the analytic derivative of the Euler–Maclaurin expansion
(`zeta_em_deriv_iv`), including a remainder-derivative bound. At
`s = 1/2+14i` the derivative box has width `~10^-48` and contains the
`mpmath.diff` value.

With this derivative enclosure, one Krawczyk step on

`Re ∈ [0.499, 0.501], Im ∈ [14.1345, 14.1349]`

satisfies `K(X) ⊂ int X`. This is a numerical zero isolation. It is **not** a
Lean certificate: the Krawczyk existence theorem and the remainder bound are
not formalised. The next step is the Lean Krawczyk theorem (Banach fixed point
plus the mean value inequality) and a Lean version of the Euler–Maclaurin
derivative enclosure.

### 2026-10-25 — Phase I.39: Krawczyk robustness

The numerical Krawczyk inclusion on `Re ∈ [0.499,0.501]`,
`Im ∈ [14.1345,14.1349]` holds for
`(N,K) = (20,20),(25,25),(30,20),(20,25)`. The Lean Krawczyk theorem and the
Lean Euler–Maclaurin bounds are still open.

### 2026-10-25 — Phase I.40: Lean mean value attempt

Attempted a Lean proof of the complex mean value inequality
`‖f y - f x‖ ≤ C‖y-x‖` from a derivative bound on the segment, as the
analytic input for Krawczyk. The mixed real/complex chain rule
(`HasFDerivAt.comp_hasDerivAt` with `ℂ` as a real normed space) did not
elaborate cleanly; the file was removed rather than leaving a noncompiling
artifact. The next attempt should use
`Convex.norm_image_sub_le_of_norm_fderiv_le` with
`Complex.hasDerivAt_iff_hasFDerivAt` and `ContinuousLinearMap.toSpanSingleton`,
or a real-`HasDerivAt` formulation.

### 2026-10-25 — Phase I.41: Lean complex mean value inequality

`Krawczyk.lean` now proves

```lean
theorem norm_sub_le_of_deriv_bound {f f' : ℂ → ℂ} {x y : ℂ} {C : ℝ}
    (h : ∀ z ∈ segment ℝ x y, HasDerivAt f (f' z) z)
    (hC : ∀ z ∈ segment ℝ x y, ‖f' z‖ ≤ C) :
    ‖f y - f x‖ ≤ C * ‖y - x‖
```

using Mathlib's `Convex.norm_image_sub_le_of_norm_fderiv_le` with
`HasDerivAt.hasFDerivAt.fderiv`. This is the analytic input for the Krawczyk
contraction; the fixed-point/Krawczyk theorem itself is next.

### 2026-10-25 — Phase I.42: Newton-map Lipschitz bound

Added `norm_newton_sub_le`: if `‖1 - Y f′‖ ≤ q` on the segment `[x,y]`, then

```lean
‖(x - Y*f x) - (y - Y*f y)‖ ≤ q * ‖x - y‖.
```

This is the contraction estimate for the Newton map, obtained from T14. The
remaining Krawczyk step is the fixed-point argument (map the closed ball into
itself and apply Banach).

### 2026-10-25 — Phase I.43: Newton map preserves the closed ball

Added `newton_mapsTo_closedBall`: under the Krawczyk mapping condition
`‖Y f(x₀)‖ + q r ≤ r`, the Newton map `z ↦ z - Y f(z)` maps
`closedBall x₀ r` into itself. The proof uses the Lipschitz bound T15 and the
triangle inequality. The fixed-point/Banach step is next.

### 2026-10-25 — Phase I.44: Lean Krawczyk zero-existence theorem

`Krawczyk.lean` now proves

```lean
theorem exists_zero_of_krawczyk {f f' : ℂ → ℂ} {x0 : ℂ} {r q : ℝ} {Y : ℂ}
    (hr : 0 ≤ r) (hq0 : 0 ≤ q) (hq1 : q < 1) (hY : Y ≠ 0)
    (h : ∀ z ∈ closedBall x0 r, HasDerivAt f (f' z) z)
    (hC : ∀ z ∈ closedBall x0 r, ‖1 - Y * f' z‖ ≤ q)
    (hmap : ‖Y * f x0‖ + q * r ≤ r) :
    ∃ z ∈ closedBall x0 r, f z = 0
```

via `ContractingWith.exists_fixedPoint'` on the complete closed ball. The
remaining gap is the Lean Euler–Maclaurin enclosure of `ζ`/`ζ′` on the
first-zero rectangle, which would instantiate this theorem.

### 2026-10-25 — Phase I.45: first Euler–Maclaurin brick

Mathlib has Bernoulli polynomials but no Euler–Maclaurin summation formula.
`EulerMaclaurin.lean` starts the formalisation with

```lean
theorem integral_bernoulli_one :
    ∫ x in (0:ℝ)..1, ((Polynomial.bernoulli 1).map (algebraMap ℚ ℝ)).eval x = 0
```

i.e. `∫₀¹ B₁ = 0`. This is the first brick toward the value/derivative remainder
bounds needed to instantiate Krawczyk for ζ.

### 2026-10-25 — Phase I.46: general Bernoulli integral

Generalised the first Euler–Maclaurin brick to

```lean
theorem integral_bernoulli {n : ℕ} (hn : 1 ≤ n) :
    ∫ x in (0:ℝ)..1, (BR n).eval x = 0
```

where `BR n` is the Bernoulli polynomial mapped to `ℝ`. The proof uses the
derivative recurrence `B_{n+1}' = (n+1)B_n` and the equality
`B_{n+1}(1) = B_{n+1}(0)` for `n ≥ 1`. Next: periodic Bernoulli functions and
one-step summation by parts.

### 2026-10-25 — Phase I.47: periodic Bernoulli integral

Added the periodic Bernoulli function

```lean
def periodicBernoulli (n : ℕ) (x : ℝ) : ℝ := (BR n).eval (Int.fract x)
```

and proved

```lean
theorem integral_periodicBernoulli {n : ℕ} (hn : 1 ≤ n) (k : ℤ) :
    ∫ x in (k : ℝ)..(k + 1), periodicBernoulli n x = 0
```

using `Int.fract_add_intCast` and `integral_bernoulli`. This completes step 1
of the Lean Euler–Maclaurin roadmap. Next: one-step summation by parts.

### 2026-10-25 — Phase I.48: continuity of periodic Bernoulli off integers

Added `continuousAt_periodicBernoulli_of_not_int`: at every non-integer `x`,
`periodicBernoulli n` is continuous. This uses Mathlib's
`continuousAt_fract` and polynomial continuity. It is a prerequisite for the
summation-by-parts/integration-by-parts step.

### 2026-10-25 — Phase I.49: continuity of periodic Bernoulli at integers

Added `continuousAt_periodicBernoulli_int`: for `n ≥ 2`, `B_n({x})` is
continuous at every integer. The proof combines the left limit `B_n(1)` and
the right limit `B_n(0)` with `B_n(1)=B_n(0)` for `n ≥ 2`, using
`tendsto_fract_left'/right'` and `nhdsLT_sup_nhdsGE`.

Together with T21 this gives full continuity of `B_n({x})` for `n ≥ 2`,
opening the integration-by-parts/summation-by-parts step.

### 2026-10-25 — Phase I.50: summation-by-parts attempt

Attempted `sum_by_parts_zero_one`, the one-step identity

`∫₀¹ f B_n = B_{n+1}(0)/(n+1)(f 1 - f 0) - 1/(n+1)∫₀¹ f' B_{n+1}`.

The integration-by-parts application and the `uIcc`/`min`/`max` bookkeeping did
not close; the unfinished theorem was removed rather than left failing. T21/T22
(continuity of periodic Bernoulli) remain, so the prerequisites are in place.

### 2026-10-25 — Phase I.51: one-step summation by parts

Added `sum_by_parts_zero_one`:

```lean
∫ x in 0..1, f x * (BR n).eval x =
  (BR (n+1)).eval 0 * (1/(n+1)) * (f 1 - f 0)
    - (1/(n+1)) * ∫ x in 0..1, f' x * (BR (n+1)).eval x
```

for `f ∈ C¹`, `n ≥ 1`, using Mathlib's integration by parts and the derivative
`hasDerivAt_BR_div`. This completes step 2 of the Euler–Maclaurin roadmap.
Next: iterate the step to obtain the Euler–Maclaurin formula for `Σ n^{-s}`.

### 2026-10-25 — Phase I.52: base Euler–Maclaurin identity

Added `integral_B1_mul_deriv`:

```lean
∫ x in 0..1, (x - 1/2) * f' x = (f 1 + f 0) / 2 - ∫ x in 0..1, f x
```

for `f ∈ C¹`. This is the first correction term of Euler–Maclaurin and follows
from integration by parts with `u(x)=x-1/2`, `v=f`.

### 2026-10-25 — Phase I.53: interval Euler–Maclaurin identity

Added `integral_B1_mul_deriv_int`: for every integer `k`,

```lean
∫ x in k..k+1, (x - k - 1/2) * f' x = (f (k+1) + f k)/2 - ∫ x in k..k+1, f x
```

from the `[0,1]` base identity by translating `f` and `f'` with
`continuousOn_comp_add_int`, `intervalIntegrable_comp_add_int`, and
`integral_comp_add_right`. This is the per-interval Euler–Maclaurin identity
needed for summation over `k`.

### 2026-10-25 — Phase I.54: per-term rearrangement attempt

Attempted the corollary `point_eq_integral_add_correction`, rearranging T25 to

`f k = ∫_k^{k+1} f + ∫_k^{k+1} (x−k−1/2)f′ + (f k − f(k+1))/2`.

The rewrite crossed an integral binder and produced a mismatched integrand; the
unfinished corollary was removed. T25 remains the usable per-interval identity.

### 2026-10-25 — Phase I.55: finite Euler–Maclaurin summation

Added `sum_range_euler_maclaurin`: for `f ∈ C¹` with continuous derivative and
every `n`,

```lean
Σ_{k<n} f k =
  ∫_0^n f + Σ_{k<n} ∫_k^{k+1} (x - k - 1/2) f' x - (f n - f 0)/2.
```

Proof: induction on `n`, splitting `∫_0^{n+1}` at `n`, applying T25 on
`[n,n+1]`, and telescoping the half-sums. This is the first-order Euler–Maclaurin
summation formula with integral remainder.

### 2026-10-25 — Phase I.56: two-step Bernoulli expansion

Added `sum_by_parts_two_step`, iterating T23 once:

```lean
∫₀¹ f B_n =
  c_n (f 1 - f 0)
  - (1/(n+1)) [ c_{n+1} (f' 1 - f' 0)
      - (1/(n+2)) ∫₀¹ f'' B_{n+2} ]
```

with `c_m = B_{m+1}(0)/(m+1)`. This is the next Bernoulli correction toward the
higher-order Euler–Maclaurin formula.

### 2026-10-25 — Phase I.57: three-step Bernoulli expansion

Added `sum_by_parts_three_step`, iterating T23 twice:

```lean
∫₀¹ f B_n =
  c_n Δf - (1/(n+1)) [ c_{n+1} Δf'
    - (1/(n+2)) [ c_{n+2} Δf''
      - (1/(n+3)) ∫₀¹ f''' B_{n+3} ] ]
```

with `c_m = B_{m+1}(0)/(m+1)`. The pattern now extends mechanically; the next
step is a general induction over the number of Bernoulli corrections.

### 2026-10-25 — Phase I.58: general Euler–Maclaurin expansion

Defined `emExpansion n K g`, the recursive `K`-correction expansion using
`g 0, g 1, …, g K`, and proved

```lean
∫₀¹ g 0 · B_n = emExpansion n K g
```

by induction on `K`, using T23 at each step. This replaces the hand-unrolled
two-/three-step theorems with a single general result for any number of Bernoulli
corrections. Next: specialise `g j` to derivatives of `x^{-s}` and bound the
terminal integral.

### 2026-10-25 — Phase I.59: shifted-power derivative

Added `hasDerivAt_one_add_rpow`: for `x ≥ 0` and real `σ`,

```lean
HasDerivAt (fun y => (y + 1) ^ (-σ)) (-σ * (x + 1) ^ (-σ - 1)) x
```

from Mathlib's `Real.hasDerivAt_rpow_const` and the chain rule. This is the
first derivative brick for specialising the Euler–Maclaurin expansion to
`n^{-σ}`; the complex `n^{-s}` case will need the analogous `cpow` derivative.

### 2026-10-25 — Phase I.60: complex power derivative

Added `hasDerivAt_cpow_neg`: for `s : ℂ` and `x > 0`,

```lean
HasDerivAt (fun y : ℝ => (y : ℂ) ^ (-s)) (-s * (x : ℂ) ^ (-s - 1)) x
```

using `Complex.hasStrictDerivAt_cpow_const` on the slit plane and the scalar-tower
chain rule `HasDerivAt.scomp`. This is the complex derivative needed for the
`n^{-s}` Euler–Maclaurin specialisation.

### 2026-10-25 — Phase I.61: complex one-step summation by parts

Added `sum_by_parts_zero_one_complex`, the ℂ-valued analogue of T23:

```lean
∫₀¹ f · B_n = c_n (f 1 - f 0) - (1/(n+1)) ∫₀¹ f' · B_{n+1}
```

for `f : ℝ → ℂ`. The proof repeats the integration-by-parts argument in the
normed ring `ℂ`, using `HasDerivAt.ofReal_comp` for the Bernoulli factor.

### 2026-10-25 — Phase I.62: complex general Euler–Maclaurin expansion

Added `emExpansionC` and proved

```lean
∫₀¹ g 0 · B_n = emExpansionC n K g
```

for `g : ℕ → ℝ → ℂ`, by induction on `K` using the complex one-step identity
T32. This is the complex analogue of T29 and the form needed for `n^{-s}`.

### 2026-10-25 — Phase I.63: emG derivative sequence

Defined

```lean
emG s j x = (descPochhammer ℂ j).eval (-s) * (x+1)^(-(s+j))
```

and proved the Pochhammer recurrence `emG_succ` and the derivative recurrence

```lean
HasDerivAt (emG s j) (emG s (j+1) x) x
```

for `x ≥ 0`. This is the exact derivative sequence needed to feed the complex
Euler–Maclaurin expansion T33 with `g j = emG s j`.

### 2026-10-25 — Phase I.64: complex EM for the emG tower

Instantiated the complex general expansion T33 with the derivative tower
`g j = emG s j`, proving

```lean
∫₀¹ emG(s,0) · B_n = emExpansionC n K (emG s)
```

for every `K`. This ties the abstract complex Euler–Maclaurin expansion to the
concrete `(x+1)^{-s}` derivative sequence.

### 2026-10-25 — Phase I.65: complex power corollary

Added `integral_cpow_eq_emExpansionC`:

```lean
∫₀¹ (x+1)^{-s} · B_n = emExpansionC n K (emG s)
```

by simplifying `emG s 0 = (x+1)^{-s}` in T36. This is the direct complex
Euler–Maclaurin expansion for the power appearing in `Σ n^{-s}`.

### 2026-10-25 — Phase I.66: complex translation lemmas

Added `continuousOn_comp_add_int_complex` and
`intervalIntegrable_comp_add_int_complex`: shifting a `ℂ`-valued function by an
integer preserves continuity and interval integrability. These are the
translation tools for moving the complex Euler–Maclaurin identity from `[0,1]`
to `[k,k+1]`.

### 2026-10-25 — Phase I.67: complex base and interval identities

Added the complex base Euler–Maclaurin identity on `[0,1]` and its translated
form on `[k,k+1]`, both for `ℂ`-valued functions. These are the complex
analogues of T24/T25 and enable the complex finite-sum induction.

### 2026-10-25 — Phase I.68: complex finite Euler–Maclaurin summation

Added `sum_range_euler_maclaurin_complex`: for `ℂ`-valued `f ∈ C¹` with
continuous derivative and every `n`,

```lean
Σ_{k<n} f k = ∫₀^n f + Σ_{k<n} ∫_k^{k+1} (x-k-1/2) f' x - (f n - f 0)/2.
```

This is the complex analogue of T26 and the direct summation formula for
`n^{-s}`.

### 2026-10-25 — Phase I.69: complex finite EM on [0,∞)

Added `sum_range_euler_maclaurin_complex_nonneg`, the complex finite-sum formula
with differentiability only required on `[0,∞)`. This removes the global
differentiability obstruction and is exactly the form needed for
`f(x)=(x+1)^{-s}`.

### 2026-10-25 — Phase I.70: EM for the shifted power

Specialised the complex finite-sum formula T43 to `f(x)=(x+1)^{-s}`:

```lean
Σ_{k<n} (k+1)^{-s} =
  ∫₀^n (x+1)^{-s}
  + Σ_{k<n} ∫_k^{k+1} (x-k-1/2)·(-s(x+1)^{-s-1})
  - (n+1)^{-s}/2 + 1/2.
```

This is the concrete finite Euler–Maclaurin formula for `Σ n^{-s}`.

### 2026-10-25 — Phase I.71: norm of the complex power

Added `norm_cpow_neg_ofReal`: for `x > 0` and `s : ℂ`,

```lean
‖x^{-s}‖ = x^{-Re s}
```

from Mathlib's `Complex.norm_cpow_eq_rpow_re_of_pos`. This is the first estimate
needed for bounding the Euler–Maclaurin correction integral.

### 2026-10-25 — Phase I.72: pointwise correction bound

Added `norm_correction_integrand_le`: for `Re s ≥ −1` and `x ∈ [k,k+1]`,

```lean
‖(x−k−1/2)·(−s(x+1)^{−s−1})‖ ≤ ‖s‖/2 · (k+1)^{−Re s−1}.
```

Uses `|x−k−1/2| ≤ 1/2`, T45 for the complex power norm, and monotonicity of
`rpow` for non-positive exponents. This is the pointwise input for the integral
correction bound.

### 2026-10-25 — Phase I.73: integral correction bound

Added `norm_integral_correction_le`: for `Re s ≥ −1`,

```lean
‖∫_k^{k+1} (x−k−1/2)(−s(x+1)^{−s−1})‖
  ≤ ‖s‖/2 · (k+1)^{−Re s−1}.
```

Uses `intervalIntegral.norm_integral_le_of_norm_le_const` and the pointwise
bound T46. This is the per-interval input for the summed correction estimate.

### 2026-10-25 — Phase I.74: summed correction bound

Added `norm_sum_correction_le` and `sum_shifted_rpow_le`:

```lean
‖Σ_{k<n} ∫ correction‖ ≤ ‖s‖/2 · Σ_{k<n} (k+1)^{-Re s-1}
Σ_{k<n} (k+1)^{-Re s-1} ≤ n        (Re s ≥ 0)
```

so the first Euler–Maclaurin correction is bounded by `n‖s‖/2` on the
first-zero rectangle. This is a crude but fully formal remainder estimate.

### 2026-10-25 — Phase I.75: finite value enclosure

Combined T44 with the summed correction bound to obtain

```lean
‖Σ_{k<n} (k+1)^{-s}
  − (∫₀^n (x+1)^{-s} − ((n+1)^{-s}−1)/2)‖ ≤ n‖s‖/2
```

for `Re s ≥ 0`. This is a fully formal finite value enclosure for the
Euler–Maclaurin approximation, with a crude but explicit remainder.

### 2026-10-25 — Phase I.76: monotonicity of the weight

Added `antitoneOn_shifted_rpow`: for `σ > 0`, the function
`x ↦ (x+1)^{-σ-1}` is antitone on `[0,∞)`. This is the monotonicity input for
the sum–integral comparison that sharpens the crude weight bound `≤ n`.

### 2026-10-25 — Phase I.77: tail integral bound

Added `integral_rpow_neg_le_inv`: for `σ > 0` and `1 ≤ a ≤ b`,

```lean
∫_a^b x^{-σ-1} dx ≤ 1/σ.
```

Evaluated with `integral_rpow` and bounded via `a^{-σ} ≤ 1`. This is the
integral half of the sharp weight bound.

### 2026-10-25 — Phase I.78: sharp weight bound

Proved

```lean
Σ_{k<n} (k+1)^{-σ-1} ≤ 1 + 1/σ        (σ > 0)
```

by splitting the sum, applying the antitone sum–integral comparison T51 on
`[1,1+m]`, and bounding the integral with T52. This replaces the crude `≤ n`
weight bound by a constant independent of `n`.

### 2026-10-25 — Phase I.79: uniform correction bound

Replaced the crude `n` weight with the sharp `1 + 1/σ` bound, obtaining

```lean
‖Σ correction‖ ≤ ‖s‖/2 · (1 + 1/σ)
```

and the uniform finite value enclosure

```lean
‖Σ_{k<n}(k+1)^{-s}
  − (∫₀^n (x+1)^{-s} − ((n+1)^{-s}−1)/2)‖
  ≤ ‖s‖/2 · (1 + 1/σ)
```

for `Re s > 0`. The remainder is now independent of `n`.

### 2026-10-25 — Phase I.80: second Bernoulli polynomial bound

Added `abs_BR_two_le`: `|B₂(x)| ≤ 1/6` on `[0,1]`, using
`B₂(x) = x² − x + 1/6`. This is the coefficient bound needed for the
second-order Euler–Maclaurin remainder.

### 2026-10-25 — Phase I.81: second-order interval identity

Added `integral_B1_mul_deriv_int_one`, the `B₁`–`B₂` identity on `[k,k+1]`:

```lean
∫ B₁({x}) f′ = (1/12)(f′(k+1) − f′(k)) − (1/2)∫ B₂({x}) f″.
```

Proved by translating T32 (`n = 1`) from `[0,1]` to `[k,k+1]`. This is the
per-interval input for the second-order Euler–Maclaurin formula.

### 2026-10-25 — Phase I.82: telescoping sum

Added `sum_range_sub_complex`: `Σ_{k<n}(g(k+1)−g(k)) = g(n)−g(0)` via
`Finset.sum_range_sub`. This is the telescoping step for summing the
second-order interval identity T57.

### 2026-10-25 — Phase I.83: natural-index second-order identity

Added `integral_B1_mul_deriv_nat`, T57 with `k : ℕ`, by casting to `ℤ` and
normalizing `Nat.cast`. This is the per-term identity in the form needed for
`Finset.sum` over `range n`.

### 2026-10-25 — Phase I.84: emG telescoping

Added `sum_range_emG_one_sub`: the telescoping sum for `emG s 1` in the exact
cast form needed by the second-order correction sum. This isolates the cast
issue that blocked the previous round.

### 2026-10-25 — Phase I.85: summed second-order correction

Proved

```lean
Σ_k ∫_k^{k+1} B₁({x}) f′
  = (1/12)(f′(n) − f′(0))
    − (1/2) Σ_k ∫_k^{k+1} B₂({x}) f″
```

by applying T59 termwise, factoring the constants, and telescoping with T60.
This is the correction identity needed for the second-order finite EM formula.

### 2026-10-25 — Phase I.86: regression notice

A large edit while restoring T41 accidentally removed the T44–T56 block from
`EulerMaclaurin.lean`. The file still builds, but those theorems (finite EM
formula, norm/pointwise/integral/summed correction bounds, uniform bounds, and
the `B₂` bound) are no longer present. README/STATUS counts were reduced by 13
accordingly. T57–T61 remain. Re-adding T44–T56 is required before the
second-order formula can be assembled.

### 2026-10-25 — Phase I.87: restore T42–T44

Re-added `sum_range_euler_maclaurin_complex` (T42), its `[0,∞)` version (T43),
and `sum_shifted_cpow_euler_maclaurin` (T44). Counts raised by three. T45–T56
remain to be restored.

### 2026-10-25 — Phase I.88: restore T45–T47

Re-added the norm formula T45, the pointwise integrand bound T46, and the
integral correction bound T47. Counts raised by three. T48–T56 remain to be
restored.

### 2026-10-25 — Phase I.89: restore T48–T53

Re-added the summed correction bound, crude/sharp weight bounds, finite value
enclosure, antitone weight, and tail integral bound. Counts raised by six.
T54–T56 (uniform bounds and `B₂`) remain.

### 2026-10-25 — Phase I.90: second-order finite EM formula

Assembled T44 and T61 into

```lean
Σ_{k<n} (k+1)^{-s}
  = ∫₀^n (x+1)^{-s}
    + (1/12)(f′(n) − f′(0))
    − (1/2) Σ_k ∫ B₂({x}) f″
    − ((n+1)^{-s} − 1)/2.
```

This is the second-order finite Euler–Maclaurin formula, the first step
beyond the uniform first-order remainder.

### 2026-10-25 — Phase I.91: norm of emG(s,2)

Added `norm_emG_two`:

```lean
‖emG(s,2,x)‖ = ‖s‖ ‖s+1‖ (x+1)^{-Re s-2}
```

using `emG(s,2,x) = s(s+1)(x+1)^{-(s+2)}` and T45. This is the coefficient
factor in the second-order `B₂` remainder bound.

### 2026-10-25 — Phase I.92: pointwise B₂ integrand bound

Added `norm_B2_correction_integrand_le`: on `x ∈ [k,k+1]`,

```lean
‖emG(s,2,x)·B₂({x})‖ ≤ (1/6)‖s‖‖s+1‖(k+1)^{-Re s-2}.
```

Uses T56 (`|B₂| ≤ 1/6`), T63, and rpow monotonicity. This is the pointwise
input for the second-order remainder bound.

### 2026-10-25 — Phase I.93: B₂ correction bounds

Added the integral bound T65, summed bound T66, and sharp weight bound T67 for
the second-order `B₂` remainder. Together with T64 these give a fully formal
second-order correction estimate.

### 2026-10-25 — Phase I.94: second-order finite value enclosure

Combined the second-order formula T62 with the `B₂` bounds T64–T67:

```lean
‖Σ_{k<n}(k+1)^{-s}
  − (∫₀^n (x+1)^{-s} + (1/12)(f′(n)−f′(0)) − ((n+1)^{-s}−1)/2)‖
  ≤ (1/12)‖s‖‖s+1‖(1 + 1/(Re s + 1)).
```

This is the second-order finite value enclosure, valid for `Re s > −1` and
uniform in `n`.

### 2026-10-25 — Phase I.95: exact shifted-power integral

Added `integral_cpow_shift`:

```lean
∫₀^n (x+1)^{-s} = ((n+1)^{1-s} − 1)/(1−s)     (s ≠ 1)
```

via `integral_cpow` and the translation `x ↦ x+1`. This is the exact integral
needed for the `n → ∞` continuation step.

### 2026-10-25 — Phase I.96: vanishing tail weight

Added `tendsto_shifted_rpow_zero`: for `σ > 1`,

```lean
((n+1))^{1-σ} → 0
```

from `tendsto_rpow_atTop` and `inv_tendsto_atTop`. This is the first limit
needed for the `n → ∞` Euler–Maclaurin continuation.

### 2026-10-25 — Phase I.97: summability of B₂ weights

Added `summable_shifted_rpow`: for `σ > −1`, the weights `(n+1)^{-σ-2}` are
summable, via `Real.summable_nat_rpow` and a shift. This is the convergence input
for the second-order remainder limit.

### 2026-10-25 — Phase I.98: summability of the B₂ correction

Added `summable_B2_correction`: for `σ > −1`, the series
`Σ_k ∫ B₂({x}) emG(s,2,x)` converges absolutely, by comparison with T71 and the
integral bound T65. This gives the limit of the second-order remainder.

### 2026-10-25 — Phase I.99: convergent B₂ partial sums

Added `tendsto_sum_B2_correction`: the partial sums of the `B₂` correction
converge to the `tsum` for `σ > −1`, from T72. This is the final convergence
input for the `n → ∞` second-order identity.

### 2026-10-25 — Phase I.100: complex tail limit

Added `tendsto_cpow_shift_zero`: for `Re s > 1`,

```lean
((n+1) : ℂ)^{1-s} → 0
```

from T70 and the norm formula T45. This is the complex tail decay needed for the
`n → ∞` continuation.

### 2026-10-25 — Phase I.101: integral limit

Added `tendsto_integral_cpow_shift`: for `Re s > 1`,

```lean
∫₀^n (x+1)^{-s} → 1/(s−1).
```

Uses the exact formula T69 and the tail decay T74. This is the main analytic
limit for the Euler–Maclaurin continuation.

### 2026-10-25 — Phase I.102: inverse-square decay

Added `tendsto_shifted_rpow_neg_two`: `(n+1)^{-2} → 0`, from T70 with
`σ = 3`. This is the comparison weight for the `f′(n) → 0` estimate.

### 2026-10-25 — Phase I.103: f′ tends to zero

Added the norm formula T77 and the limit T78:

```lean
‖emG(s,1,x)‖ = ‖s‖(x+1)^{-Re s-1},
emG(s,1,n) → 0        (Re s > 1).
```

Uses the inverse-square decay T76 and a squeeze. This is the derivative term
in the Euler–Maclaurin continuation.

### 2026-10-25 — Phase I.104: finite-sum limit

Added the weight limit T79 and, combining T62 with T73/T75/T78/T79, the full
limit T80:

```lean
Σ_{k<n}(k+1)^{-s}
  → 1/(s−1)
    + (1/12)(−f′(0))
    − (1/2) Σ_{k≥0} ∫ B₂f″
    + 1/2
```

for `Re s > 1`. This is the second-order Euler–Maclaurin continuation of the
finite zeta sum.

### 2026-10-25 — Phase I.105: second-order continuation of ζ

Connected the finite-sum limit T80 to Mathlib's `riemannZeta`:

```lean
ζ(s) = 1/(s−1) + (1/12)(−f′(0))
        − (1/2) Σ_{k≥0} ∫ B₂f″ + 1/2
```

for `Re s > 1`, using `zeta_eq_tsum_one_div_nat_add_one_cpow` and uniqueness of
limits. This is the second-order Euler–Maclaurin continuation of ζ on the
half-plane of absolute convergence.

### 2026-10-25 — Phase I.106: shifted emG tower

Introduced `emGShift s N j x = D_j (x+N+1)^{-(s+j)}` and proved its Pochhammer
recurrence (T82) and derivative recurrence (T83). This is the derivative tower
for a zeta tail starting at `N+1`, where the EM integral converges for
`Re s > 0`.

### 2026-10-25 — Phase I.107: first-order tail formula

Instantiated the finite EM formula T43 with the shifted tower `emGShift`:

```lean
Σ_{k<n} (k+N+1)^{-s}
  = ∫₀^n (x+N+1)^{-s}
    + Σ_k ∫ (x−k−1/2) emGShift(s,N,1,x)
    − (emGShift(s,N,0,n) − emGShift(s,N,0,0))/2.
```

This is the starting point for the tail continuation on `Re s > 0`.

### 2026-10-25 — Phase I.108: shifted correction bound

Added the norm T85 and pointwise bound T86 for the shifted first derivative
`emGShift(s,N,1,x)`. These are the per-term inputs for the tail correction
estimate on `Re s > 0`.

### 2026-10-25 — Phase I.109: shifted correction estimates

Added the per-interval bound T87, its sum T88, and the uniform weight bound
T89 for the shifted tail correction. Together they give

```lean
‖Σ_k ∫ (x−k−1/2) emGShift(s,N,1,x)‖ ≤ (‖s‖/2)(1 + 1/Re s)
```

for `Re s > 0`.

### 2026-10-25 — Phase I.110: tail integral

Added `integral_Ioi_cpow_neg`: for `Re s > 1` and `c > 0`,

```lean
∫_{Ioi c} x^{-s} = c^{1-s}/(s−1).
```

Uses Mathlib's `integral_Ioi_cpow_of_lt`. This is the integral term of the
fixed-`N` Euler–Maclaurin formula.

### 2026-10-25 — Phase I.111: shifted tail integral limit

Added `tendsto_integral_tail_cpow`: for `Re s > 1`,

```lean
∫₀^n (x+N+1)^{-s} → (N+1)^{1-s}/(s−1).
```

Uses the improper integral T90 and continuity of the interval integral. This is
the integral term of the fixed-`N` formula in the convergent half-plane.

### 2026-10-25 — Phase I.112: summable tail weights

Added `summable_tail_rpow`: for `σ > 0` and any shift `N`, the weights
`(k+N+1)^{-σ-1}` are summable, via `Real.summable_nat_rpow` and a shift. This
gives convergence of the shifted correction series.

### 2026-10-25 — Phase I.113: summable tail correction

Added `summable_tail_correction`: for `Re s > 0`, the shifted correction series
`Σ_k ∫ (x−k−1/2) emGShift(s,N,1,x)` converges absolutely, by comparison with T92
and the integral bound T87.

### 2026-10-25 — Phase I.114: shifted weight limit

Added `tendsto_emGShift_zero`: `emGShift(s,N,0,n) → 0` for `Re s > 1`, by
composing T79 with the shift `n ↦ n+N`. This is the boundary term limit in the
fixed-`N` tail formula.

### 2026-10-25 — Phase I.115: shifted correction limit

Added `tendsto_sum_tail_correction`: the shifted correction partial sums converge
to their `tsum` for `Re s > 0`, from T93. This is the correction term in the
fixed-`N` tail limit.

### 2026-10-25 — Phase I.116: fixed-N tail limit

Combined T91 (integral), T95 (correction), and T94 (boundary) to obtain the
fixed-`N` tail limit for `Re s > 1`:

```lean
Σ_{k<n} emGShift(s,N,0,k)
  → (N+1)^{1-s}/(s−1)
    + Σ_k ∫ (x−k−1/2) emGShift(s,N,1,x)
    + emGShift(s,N,0,0)/2.
```

This is the tail half of the fixed-`N` Euler–Maclaurin formula.

### 2026-10-25 — Phase I.117: fixed-N Euler–Maclaurin for ζ

Proved

```lean
ζ(s) = Σ_{n<N} (n+1)^{-s}
        + (N+1)^{1-s}/(s−1)
        + Σ_k ∫ (x−k−1/2) emGShift(s,N,1,x)
        + emGShift(s,N,0,0)/2
```

for `Re s > 1`, by splitting the Dirichlet series with `sum_add_tsum_nat_add`
and using the tail limit T96.

### 2026-10-25 — Phase I.118: entire finite prefix

Added `differentiable_fixed_prefix`: the finite prefix
`s ↦ Σ_{n<N}(n+1)^{-s}` is differentiable on all of `ℂ`. This is the first
analyticity ingredient for the meromorphic continuation of the fixed-`N`
formula.

### 2026-10-25 — Phase I.119: integrand analyticity

Added `differentiable_emGShift_one`: for `x ≥ 0`, the function
`s ↦ emGShift(s,N,1,x)` is entire. This is the pointwise analyticity input for
differentiating the correction integral in `s`.

### 2026-10-25 — Phase I.120: derivative in s of the integrand

Added `hasDerivAt_emGShift_one`: the explicit `s`-derivative

```lean
∂_s emGShift(s,N,1,x)
  = (x+N+1)^{-(s+1)} · (−1 + s log(x+N+1)).
```

This is the derivative input for differentiating the correction integral in `s`.

### 2026-10-25 — Phase I.121: pole-term analyticity

Added `differentiableAt_pole_term`: the term `(N+1)^{1-s}/(s−1)` is
differentiable at every `s ≠ 1`. This is the pole part of the fixed-`N`
expression’s meromorphic continuation.

### 2026-10-25 — Phase I.122: integrand continuity and interval integrability

Added T102 and T103: `x ↦ emGShift(s,N,1,x)` is continuous on `[0,∞)` and
interval-integrable on each `[k,k+1]`. These are prerequisites for the
parametric-integral differentiation in milestone (a).

### 2026-10-25 — Phase I.123: integrand measurability

Added T104: the correction integrand is AE-strongly-measurable on `(k,k+1]`,
from continuity on the closed interval. This is a hypothesis of the
parametric-integral differentiation lemma.

### 2026-10-25 — Phase I.124: s-derivative continuity and measurability

Added T105/T106: the `s`-derivative integrand is continuous and
AE-strongly-measurable on `(k,k+1]`, using `ContinuousAt.cpow` and
`ContinuousAt.clog`.

### 2026-10-25 — Phase I.125: log majorant integrability

Added T107: `x ↦ 1 + |log(x+N+1)|` is interval-integrable on `[k,k+1]`. This
is the integrable majorant for the compact-`s` derivative bound.

### 2026-10-25 — Phase I.126: joint continuity of the derivative integrand

Added T108: `(s,x) ↦ ∂_s emGShift(s,N,1,x)` is continuous on the compact
`closedBall(0,R) × [k,k+1]`. This yields a constant majorant by compactness,
the last input for parametric differentiation.

### 2026-10-25 — Phase I.127: uniform derivative bound

Added T109: by compactness of `closedBall(0,R) × [k,k+1]` and T108, there is a
constant `C` bounding `‖∂_s emGShift(s,N,1,x)‖`. This is the majorant for
parametric differentiation.

### 2026-10-25 — Phase I.128: correction interval integrability

Added T110: the full correction integrand
`x ↦ (x−k−1/2)emGShift(s,N,1,x)` is interval-integrable on `[k,k+1]`. This is
the `hF_int` hypothesis of parametric differentiation.

### 2026-10-25 — Phase I.129: parametric differentiability of correction integrals

Completed milestone (a): each correction integral
`s ↦ ∫_k^{k+1}(x−k−1/2)emGShift(s,N,1,x)` is differentiable at every `s₀`.
Uses T99–T110 and `hasDerivAt_integral_of_dominated_loc_of_deriv_le`.

### 2026-10-25 — Phase I.130: uniform strip bound

Added T112: on `Re s ≥ ρ > 0` and `‖s‖ ≤ R`, each correction integral is bounded
by `(R/2)(k+N+1)^{-ρ-1}`. This gives the summable majorant for milestone (b).

### 2026-10-25 — Phase I.131: analyticity of the correction series

Completed milestone (b): the correction series is differentiable on
`{Re s > 0}`. Local strip differentiability (T113) via
`Complex.differentiableOn_tsum_of_summable_norm` with the T112 majorant, then
gluing (T114) via `differentiableOn_of_locally_differentiableOn`.

### 2026-10-25 — Phase I.132: entire zero-level tower

Added T115: `s ↦ emGShift(s,N,0,x) = (x+N+1)^{-s}` is entire for `x ≥ 0`.
This is the last analyticity piece of the constant boundary term in the
fixed-`N` expression.

### 2026-10-25 — Phase I.133: zetaEM and its analyticity

Defined `zetaEM N s` as the fixed-`N` expression and proved it differentiable on
the punctured half-plane `{Re s > 0} \ {1}` (T116, T117). This is the right-hand
side of the meromorphic continuation.

### 2026-10-25 — Phase I.134: agreement of zetaEM on Re > 1

Added T118: `ζ(s) = zetaEM N s` for `Re s > 1`, directly from T97 and the
definition. This is the nonempty open set on which the identity theorem can
base the continuation.

### 2026-10-25 — Phase I.135: continuation into the critical strip

Completed milestone (c): for `Re s > 0` and `1 < Im s < 20`,
`ζ(s) = zetaEM N s`. Uses the identity theorem on the convex horizontal strip
`0 < Re s`, `1 < Im s < 20`, which avoids `1` and contains both `2+14i` and the
first-zero rectangle.

### 2026-10-25 — Phase I.136: Bernoulli evaluation at zero

Added T120: `(BR n)(0) = bernoulli n` over ℝ, via `Polynomial.eval_map`,
`Polynomial.eval₂_at_apply`, and Mathlib’s `Polynomial.bernoulli_eval_zero`.
This is the first general-K coefficient link.

### 2026-10-25 — Phase I.137: Bernoulli polynomial identification

Added T121: `(BR n).eval x = bernoulliFun n x` definitionally. This connects our
real Bernoulli polynomials to Mathlib’s Fourier expansion
`hasSum_one_div_pow_mul_fourier_mul_bernoulliFun`, opening the route to the
periodic Bernoulli bound.

### 2026-10-25 — Phase I.138: uniform Bernoulli bound

Added T122: `bernoulliFun k` is bounded on `[0,1]` by compactness. This gives a
general-`K` remainder bound with an explicit constant (not yet the sharp
`2ζ(2K+1)/(2π)^{2K+1}` form).

### 2026-10-25 — Phase I.139: Fourier term norms

Added T123/T124: the Fourier character has unit norm, and each Fourier term
`1/n^k * fourier n x` has norm `1/|n|^k`. These are the termwise inputs for the
Bernoulli Fourier norm bound.

### 2026-10-25 — Phase I.140: integer inverse-power sum

Added T125: the `ℤ`-sum of `1/|n|^k` equals twice the positive sum over `ℕ`.
Uses the evenness and decomposition theorems for `tsum` over `ℤ` and `ℕ+`.

### 2026-10-25 — Phase I.141: inverse-power sum is Re ζ(k)

Added T126: `Σ_{n≥1} 1/n^k = Re ζ(k)` for `k ≥ 2`, via `Complex.ofReal_tsum` and
Mathlib's Dirichlet-series identity. This completes the identification of the
Fourier majorant with `ζ(k)`.

### 2026-10-25 — Phase I.142: Fourier series norm bound

Added T127: the Fourier series of the Bernoulli function is bounded in norm by
`2 Re ζ(k)`, using termwise norms, `norm_tsum_le_tsum_norm`, T125 and T126.

### 2026-10-25 — Phase I.143: periodic Bernoulli bound

Added T128: `|B_k(x)| ≤ k!/(2π)^k · 2 Re ζ(k)` for k ≥ 2 and x ∈ [0,1],
from the Fourier HasSum, T127, and the coefficient norm. This is the sharp
periodic Bernoulli bound needed for the general-K remainder.

### 2026-10-25 — Phase I.144: periodic Bernoulli bound at any real

Added T129: the Bernoulli bound extends to `B_k({x})` for any real `x` by
reducing to `Int.fract x ∈ [0,1)`. This is the form needed in the EM remainder
sums.

### 2026-10-25 — Phase I.145: general tower norm

Added T130: `‖emGShift(s,N,j,x)‖ = ‖(s)_j‖(x+N+1)^{-Re s-j}`. This generalizes
T85 and supplies the derivative-factor norm for the general-K remainder.

### 2026-10-25 — Phase I.146: nonnegativity of Re ζ(n)

Added T131: `0 ≤ Re ζ(n)` for natural `n ≥ 2`, from T126 and nonnegativity of
the inverse-power sum. This supplies the positivity side condition in the
general-K pointwise remainder bound.

### 2026-10-25 — Phase I.147: Bernoulli–tower remainder estimates

Added T132/T133: pointwise and integral bounds for
`B_n({x}) * emGShift(s,N,j,x)` on `[k,k+1]`, combining T129 (Bernoulli),
T130 (tower norm), and T131 (zeta nonnegativity). These are the per-interval
inputs for the general-K remainder.

### 2026-10-25 — Phase I.148: summed remainder and weight bound

Added T134 (sum of Bernoulli–tower integrals) and T135 (general tail weight
bound), completing the per-K ingredients for the general-K remainder estimate.

### 2026-10-25 — Phase I.149: coarse general remainder bound

Added T136: a uniform bound for the `j`-th Bernoulli remainder sum,
`C_j ‖(s)_j‖ (1 + 1/(σ+j-1))`. This is the first assembled general-K remainder
estimate, though still without the sharp `N^{-σ-2K}` decay.

### 2026-10-25 — Phase I.150: shifted antitonicity

Added T137: `x ↦ (x+N+1)^(-σ)` is antitone on `[0,∞)`, the monotonicity input
for the sharp sum-integral comparison.

### 2026-10-25 — Phase I.151: shifted continuity

Added T138: `x ↦ (x+N+1)^(-σ)` is continuous on `[0,∞)`, via
`ContinuousOn.rpow_const`. This discharges the integrability side goals in the
sharp sum-integral comparison.

### 2026-10-25 — Phase I.152: real tail integral

Added T139: `∫_{Ioi c} x^(-σ) = c^(1-σ)/(σ-1)` for σ > 1, from Mathlib's
`integral_Ioi_rpow_of_lt`. This is the integral value for the sharp remainder
decay.

### 2026-10-25 — Phase I.153: sharp tail bound

Fixed the two blocking issues: `restrict_map` with explicit `f`, and
`IntegrableOn` unfolding via `change`. Added T140 (shift integrability), T141
(shifted tail integral), and T142 (sharp tsum bound with N-decay). This closes
the sum-integral comparison for the general-K remainder.

### 2026-10-25 — Phase I.154: sharp general remainder

Added T143: the `j`-th Bernoulli remainder sum decays like
`C_j ‖(s)_j‖ ((N+1)^{-σ-j} + (N+1)^{1-σ-j}/(σ+j-1))`, using T142. This closes
the sharp-remainder milestone for the Bernoulli correction sum.

### 2026-10-25 — Phase I.155: infinite correction and ζ value enclosure

Added T144 (infinite B2 series sharp bound), T145 (first-order correction
bound), and T146 (certified ζ value enclosure on the first-zero strip). This
completes a Lean value enclosure of ζ at 1/2+14i, though with coarse N-decay.

### 2026-10-25 — Phase I.156: boundary derivative

Added T147: explicit `s`-derivative of the zero-level tower, the boundary-term
derivative needed for the `ζ′` enclosure.

### 2026-10-25 — Phase I.157: Krawczyk instantiated for ζ

Added T148: the abstract Krawczyk theorem specialized to `f = ζ`,
`f′ = deriv ζ`, with the derivative supplied by
`differentiableAt_riemannZeta`. This is the concrete Krawczyk assembly,
conditional on the enclosure hypotheses.

### 2026-10-25 — Phase I.158: explicit base and decomposition

Added T149 (definition of `zetaBase`), T150 (`zetaEM = zetaBase + correction`),
and T151 (analyticity of the base on the punctured half-plane). This isolates the
explicit part of the fixed-N formula from the correction series.

### 2026-10-25 — Phase I.159: error against zetaBase

Added T152: the certified ζ error bound rewritten against `zetaBase`, the form
needed for the Cauchy derivative estimate.

### 2026-10-25 — Phase I.160: Cauchy derivative estimate

Added T153: `‖deriv f c‖ ≤ 2M/R` from a uniform bound on a ball, via
`Complex.norm_deriv_le_div_of_mapsTo_ball`. This is the tool for the ζ′
enclosure.

### 2026-10-25 — Phase I.161: conditional ζ′ enclosure

Added T154: `‖deriv ζ s₀‖ ≤ ‖deriv zetaBase s₀‖ + 2M/R` from a uniform error
bound on a ball, via `HasDerivAt.add` and T153. This is the derivative
enclosure, conditional on the ball bound.

### 2026-10-25 — Phase I.162: uniform error bound on a ball

Added T155: every closed ball inside the strip has a uniform bound on
`‖ζ - zetaBase‖`, by compactness and continuity. This discharges the `M`
hypothesis of T154.

### 2026-10-25 — Phase I.163: first-zero ball bound

Added T156 (general outer-radius error bound) and T157 (concrete bound on
`closedBall(1/2+14i, 1/8)`), discharging the `M` hypothesis at the first-zero
height.

### 2026-10-25 — Phase I.164: concrete ζ′ bound

Added T158: a concrete derivative bound of ζ at 1/2+14i, obtained by feeding
the T157 error bound into T154. This completes the ζ′ enclosure (relative to
the explicit base derivative).

### 2026-10-25 — Phase I.165: Bernoulli coefficients

Added `emCoef j = B_{2j}/(2j)!` and `emCoef 1 = 1/12`, the coefficient
sequence for the general-K finite formula.

### 2026-10-25 — Phase I.166: second Bernoulli coefficient

Added T160: `emCoef 2 = -1/720`, the second coefficient of the general-K
Euler–Maclaurin expansion.

### 2026-10-25 — Phase I.167: general-K expression

Added T161 (definition of `zetaEMGen`) and T162 (its `K = 1` value with the
explicit `1/12` coefficient). This is the scaffolding for the general-K finite
formula.

### 2026-10-25 — Phase I.168: K=0 base case

Added T163: `zetaEMGen 0 = zetaBase`, the base case for the general-K induction.

### 2026-10-25 — Phase I.169: general-K recurrence

Added T164: the recurrence `zetaEMGen (K+1) = zetaEMGen K + next Bernoulli
term`, the induction step for the general-K formula.

### 2026-10-25 — Phase I.170: shifted telescoping

Added T165: telescoping for the shifted first-derivative tower, the missing
lemma for the shifted T61 port.

### 2026-10-25 — Phase I.171: shifted second-order formula

Ported T59-T62 to `emGShift`: T166 (shifted correction identity) and T167
(shifted second-order Euler–Maclaurin formula). This is the analytic input for
the general-K bridge.

### 2026-10-25 — Phase I.172: shifted first tower limit

Added T168: `emGShift(s,N,1,n) → 0` for Re s > 1, the boundary-term limit for
the bridge `zetaEM = zetaEMGen 1 + B₂ remainder`.

### 2026-10-25 — Phase I.173: boundary coefficient

Added T169: the `1/12` boundary term is exactly the first Bernoulli coefficient
applied to `-emGShift(s,N,1,0)`. This is the algebraic identification for the
bridge to `zetaEMGen 1`.

### 2026-10-25 — Phase I.174: K=1 difference form

Added T170: `zetaEMGen 1 - zetaBase = (1/12)s(N+1)^{-s-1}`, the exact
difference form matching T169 for the bridge.

### 2026-10-25 — Phase I.175: shifted B2 summability

Added T171/T172: the shifted `B₂` correction series is summable and its partial
sums converge. This supplies the missing `Tendsto` for the bridge.

### 2026-10-25 — Phase I.176: correction-series bridge

Added T173: the first-order correction `tsum` equals the `1/12` boundary term
minus half the `B₂` `tsum`, via uniqueness of limits (T96 and T167 + T171-T172).

### 2026-10-25 — Phase I.177: zetaEM bridge

Added T174: `zetaEM = zetaEMGen 1 - (1/2) B₂ remainder`, completing the bridge
from the first-order form to the general-K expression.

### 2026-10-25 — Phase I.178: general-K remainder

Added `zetaEMRemainder`, with `K=0` equal to the first-order correction series
and `K=1` equal to minus half the B₂ series. This is the induction target for
general K.

### 2026-10-25 — Phase I.179: remainder recurrence

Added T178: the algebraic recurrence of the general-K remainder, reducing the
analytic induction step to identifying each Bernoulli sum with the next term.

### 2026-10-25 — Phase I.180: Bernoulli endpoint values

Added T179/T180: `B₃(0)=0` and `B₄(0)=-1/30`, the endpoint coefficients for the
next integration-by-parts step.

### 2026-10-25 — Phase I.181: B3 endpoint at one

Added T181: `B₃(1)=0`, completing the vanishing boundary data for the B2
integration-by-parts step.

### 2026-10-25 — Phase I.182: B3 derivative

Added T182: `d/dx B₃(x) = 3 B₂(x)`, via Mathlib's
`Polynomial.hasDerivAt` and `BR_derivative 2`. This is the input for the B2
integration-by-parts identity.

### 2026-10-25 — Phase I.183: shifted B3 derivative

Added T183: the derivative of the shifted complex `B₃` polynomial, via
composition and `ofReal_comp`. This completes the input data for the B2
integration-by-parts identity.

### 2026-10-25 — Phase I.184: B2 integration by parts

Added T184: `∫ B₂({x}) f = -(1/3)∫ B₃({x}) f'` on `[k,k+1]`, via
`integral_mul_deriv_eq_deriv_mul_of_hasDerivAt` and the vanishing endpoints
T179/T181. This is the first step of the general-K induction.

### 2026-10-25 — Phase I.185: shifted B4 derivative

Added T185: `d/dx B₄(x-k) = 4 B₃(x-k)`, the derivative input for the next
integration-by-parts step.

### 2026-10-25 — Phase I.186: B4 endpoint at one

Added T186: `B₄(1) = -1/30 = B₄(0)`, completing the boundary data for the
B3-to-B4 integration by parts.

### 2026-10-25 — Phase I.187: B3 integration by parts

Added T187: the B3 weighted integration-by-parts identity, the second step of
the general-K induction.

### 2026-10-25 — Phase I.188: general Bernoulli endpoint equality

Added T188: for `n ≠ 1`, `B_n(1) = B_n(0)`, via `bernoulliFun_endpoints_eq_of_ne_one`.
This is the general boundary-vanishing input for the induction step.

### 2026-10-25 — Phase I.189: general shifted Bernoulli derivative

Added T189: `d/dx B_{n+1}(x-k) = (n+1) B_n(x-k)` for all n. This is the
derivative input for the general Bernoulli-weighted integration by parts.

### 2026-10-25 — Phase I.190: file restoration

A failed append of the general integration-by-parts theorem duplicated the
whole tail of `EulerMaclaurin.lean`. Restored the file to the T189 state and
rebuilt cleanly. No new theorem this round.

### 2026-10-25 — Phase I.190: general Bernoulli integration by parts

Added T190: the general identity
`∫ B_n f = (B_{n+1}(0)/(n+1))(f(k+1)-f(k)) - (1/(n+1))∫ B_{n+1} f'`,
via T189 and T188. This is the general step for the K-induction.

### 2026-10-25 — Phase I.191: summed general IBP

Added T191: summation of the general Bernoulli integration-by-parts identity
over `k < m`, telescoping the boundary terms. This is the step needed to
iterate the K-induction.

### 2026-10-25 — Phase I.192: emGShift regularity

Added T192/T193: continuity and interval integrability of every `emGShift`
tower, the hypotheses needed to apply T191 inside the K-induction.

### 2026-10-25 — Phase I.193: K=2 finite identity

Added T194: the finite B2-to-B4 identity obtained by applying T191 twice,
`Σ∫B₂ = (1/360)(f₃(m)-f₃(0)) + (1/12)Σ∫B₄`. This is the K=2 induction step.

### 2026-10-25 — Phase I.194: general tower limit

Added T195: `emGShift(s,N,j,n) → 0` for every j, via the norm bound and
summability of `(n+1)^{-σ-j}`. This supplies the boundary limits for all K.

### 2026-10-25 — Phase I.195: B4 summability

Added T196/T197: summability and convergence of the B4-weighted emGShift(4)
series, via T133 with n=4.

### 2026-10-25 — Phase I.196: B2 to B4 series

Added T198: the infinite B2 correction series equals the boundary term
(1/360)(-emGShift(3,0)) plus (1/12) the B4 series. This is the K=2 series
identity.

### 2026-10-25 — Phase I.197: K=1 remainder closed form

Added T199: `R₁ = (1/720)emGShift(3,0) - (1/24)Σ'∫B₄emGShift(4)`, obtained by
combining T177 and T198.

### 2026-10-25 — Phase I.198: K=2 remainder

Added T200: `R₂ = R₁ + (1/720)(s)₃(N+1)^{-s-3}`, via the remainder recurrence
T178 and `emCoef 2 = -1/720`.

### 2026-10-25 — Phase I.199: coefficient-convention correction

Corrected `zetaEMGen` to use `−emCoef(j+1)·emGShift(s,N,2j+1,0)` rather than
`emCoef(j+1)·(descPochhammer).eval s·(N+1)^…`. The old form agreed with the
true rising Pochhammer only for `j = 0,1`; for `j ≥ 2` the descending polynomial
gave the wrong sign. T162, T164, T178, T200 were updated accordingly, and the
`K=2` remainder now simplifies correctly to `R₂ = −(1/24)Σ'∫B₄ emGShift(4)`.

### 2026-10-25 — Phase I.200: odd Bernoulli endpoint

Added T201: `B_n(0)=0` for odd `n>1`, the general boundary-vanishing fact
needed in the symbolic `S_{2K}` recurrence.

### 2026-10-25 — Phase I.201: third Bernoulli coefficient

Added T202: `emCoef 3 = 1/30240`, from `B6 = 1/42` and `6! = 720`.

### 2026-10-25 — Phase I.202: multiplied IBP forms

Added T203/T204: the Bernoulli integration-by-parts identities with the
`(n+1)` factor moved to the left. These avoid all division, so the K-step
induction can be stated with multiplication only.

### 2026-10-25 — Phase I.203: division-free recurrence

Added T205: the symbolic S2K recurrence in multiplicative form, avoiding all
division and `field_simp`. This unblocks the K-fold induction.

### 2026-10-25 — Phase I.204: general Bn summability

Added T206/T207: summability and convergence of the general Bn-weighted
emGShift(n) series, via T133 with arbitrary n.

### 2026-10-25 — Phase I.205: tsum recurrence

Added T208: the infinite S2K recurrence, obtained by taking the limit of T205
with explicit function-level rewriting (avoiding the `congr'` filter
metavariable issue).

### 2026-10-25 — Phase I.206: factorial base case

Added T209: `R₁ = -(1/2!)S₂`, the base case for the factorial-form K induction.

### 2026-10-25 — Phase I.207: even-step recurrence

Added T210: the remainder recurrence with the index written `2k+1`, matching
T208 syntactically. This removes the index mismatch that blocked the factorial
induction.

### 2026-10-25 — Phase I.208: S_even abbreviation

Added `S_even` and T211: the recurrence in abbreviation form, so the factorial
induction can be stated without matching a raw tsum.

### 2026-10-25 — Phase I.209: factorial remainder formula

Added T212: the full K-fold induction `R_K = -(1/(2K)!) S_even K`, proved with
`Nat.le_induction`, T210 and T211, plus the factorial identity
`(2k+2)! = (2k)!(2k+1)(2k+2)`.

### 2026-10-25 — Phase I.210: sharp S_even bound

Added T213: the sharp norm bound on S_even, via termwise T133 bounds, tsum
comparison and the tail-rpow bound. Combined with T212 this gives the sharp
general-K remainder bound.

### 2026-10-25 — Phase I.211: sharp remainder bound

Added T214: the sharp bound on R_K, combining T212/T213 and cancelling (2K)!.

### 2026-10-25 — Phase I.212: rational interval layer

Added `Interval.lean` with a verified rational interval type: exact intervals,
negation, addition, subtraction, nonnegative multiplication, scalar scaling,
and containment correctness lemmas. This is the foundation for the ζ/ζ′
certificates.

### 2026-10-25 — Phase I.213: interval powers

Added `RatInterval.powNat` and `RatInterval.invPos`, with containment lemmas,
extending the verified interval layer.

### 2026-10-25 — Phase I.214: interval division

Added `RatInterval.divPos` and its containment lemma, completing the basic
arithmetic operations of the interval layer.

### 2026-10-25 — Phase I.215: negative integer powers

Added `RatInterval.zpowNeg` and its containment lemma, covering negative integer
exponents needed for `(N+1)^{-2K}`.

### 2026-10-25 — Phase I.216: rational square-root bounds

Added T219: rational square comparisons give rational bounds on a real square
root. This is the first fractional-power building block.

### 2026-10-25 — Phase I.217: rational pi enclosure

Added `piInterval`, a 20-decimal rational enclosure of π, with containment
lemma, using Mathlib's `pi_gt_d20` and `pi_lt_d20`.

### 2026-10-25 — Phase I.218: complex containment

Added `containsComplex` and `containsComplex_ofReal`, the bridge from real
interval enclosures to complex values.

### 2026-10-25 — Phase I.219: zeta two enclosure

Added `zeta2Interval`, a rational enclosure of Re ζ(2) = π²/6, built from the
π interval and interval multiplication/division.

### 2026-10-25 — Phase I.220: zeta four enclosure

Added `zeta4Interval`, a rational enclosure of Re ζ(4) = π⁴/90, via
`riemannZeta_two_mul_nat`, the π interval, and interval powers/scaling.

### 2026-10-25 — Phase I.221: zeta six enclosure

Added `zeta6Interval`, a rational enclosure of Re ζ(6) = π⁶/945.

### 2026-10-25 — Phase I.222: square-root interval

Added `sqrtInterval`, packaging rational square brackets into a verified
interval for √a. This gives the (N+1)^{-1/2} factors needed by the certificate.

### 2026-10-25 — Phase I.223: (2π)^{-2} enclosure

Added `invTwoPiSqInterval`, a rational enclosure of (2π)^{-2} = 1/(4π²), built
from the π interval by squaring, inversion and scaling.

### 2026-10-25 — Phase I.224: (2π)^{-4} enclosure

Added `invTwoPiFourthInterval`, a rational enclosure of (2π)^{-4}, by squaring
the (2π)^{-2} interval.

### 2026-10-25 — Phase I.225: sqrt201 and rpow bridge

Added the rpow/sqrt bridge and a concrete rational enclosure of √201, the
(N+1)^{-1/2} factor at N = 200.

### 2026-10-25 — Phase I.226: concrete Krawczyk target

Added `zeta_zero_quarter_ball`, the concrete radius-1/4, q=1/4 Krawczyk
instantiation at 1/2+14i. Numerically the contraction holds with
|Yζ| ≈ 0.136, q ≈ 0.23; the remaining work is to prove the disk bounds.

### 2026-10-25 — Phase I.227: h1 discharged

Added `quarter_ball_ne_one`: the Krawczyk disk of radius 1/4 around 1/2+14i
avoids 1, since its imaginary part is 14 away.

### 2026-10-25 — Phase I.228: hmap reduction

Added the rational `Yk` and `norm_Yk_le_two`, and reduced `hmap` to the single
ζ bound `‖ζ(1/2+14i)‖ ≤ 1/16`.

### 2026-10-25 — Phase I.229: complex interval layer

Added `ComplexInterval` with componentwise rational real/imaginary intervals,
plus add, neg, sub and containment lemmas. This is the base for evaluating
complex powers in the zetaEM formula.

### 2026-10-25 — Phase I.230: interval multiplication

Added `RatInterval.mulCoarse` and `ComplexInterval.mul`, with containment
lemmas. The coarse absolute-value bound avoids the four-corner case split.

### 2026-10-25 — Phase I.231: square enclosure

Added `RatInterval.sqNonneg`, a nonnegative coarse enclosure of a square, the
first piece of the modulus-squared computation for complex division.

### 2026-10-25 — Phase I.232: reciprocal avoiding zero

Added `RatInterval.invAvoid`, a verified reciprocal for intervals whose range
does not contain zero, with containment lemma.

### 2026-10-25 — Phase I.233: conjugation and norm square

Added complex interval conjugation and a coarse upper enclosure of |z|².

### 2026-10-25 — Phase I.234: absolute lower bound

Added `RatInterval.absLower` and `absLower_le_abs`, giving the lower bound on
|x| needed for modulus-square lower bounds and complex division.

### 2026-10-25 — Phase I.235: modulus-square lower bound

Added `ComplexInterval.normSqLower` and its containment lower bound, completing
the two-sided norm-square enclosure needed for complex division.

### 2026-10-25 — Phase I.236: real-to-complex embedding

Added `ComplexInterval.ofReal`, embedding a real interval as a complex interval
with zero imaginary part.

### 2026-10-25 — Phase I.237: complex inverse

Added `ComplexInterval.inv` via `1/z = conj z / |z|²`, with containment lemma.
This completes complex division.

### 2026-10-25 — Phase I.238: elementary transcendental bounds

Added cos/sin one-bounds and exp/log monotonicity, the first pieces of the
transcendental interval layer.

### 2026-10-25 — Phase I.239: tighter hmap

Sharpened `‖Yk‖ ≤ 3/2` via the exact norm squared, reducing `hmap` to the
numerically achievable bound `‖ζ(1/2+14i)‖ ≤ 1/8`.

### 2026-10-25 — Phase I.240: zeta box 14 assembly

Added `ZetaBox14.lean`: the point rectangle `S14`, the point `s14`, and the
conditional eta-partial-sum box membership, reusing `Cert.lean`'s `CpowBox`
machinery. The concrete `allOK` term-count check is the remaining input.

### 2026-10-25 — Phase I.241: high-precision 14i box

Added `params14` (N=12,k=12,kI=128,n=16), `allOK (params14 100) S14`,
`sumValue_params14`, conditional and concrete `M=100` box membership at
`1/2+14i`.

### 2026-10-25 — Phase I.242: large-term 14i certificates

`allOK_1000`, `allOK_10000`, and `allOK_100000` pass for `params14` at
`1/2+14i`; the 100000-term native evaluation takes about 100 seconds.

### 2026-10-25 — Phase I.243: fast parameter set

Added `paramsFast` (N=10,k=10,kI=256,n=12) and its 10000-term checker pass.
The million-term check exceeds the session compile budget.

### 2026-10-25 — Phase I.244: million-term certificate

`BigCheck.lean` verified `allOK (paramsFast 1000000) S14 = true` in 639 s.
This is the term count needed for an eta tail below 1/64 at 1/2+14i.

### 2026-10-25 — Phase I.245: s14 norm bound

Added `norm_s14_le_fifteen`, the first piece of the 1/64 tail bound at 1/2+14i.

### 2026-10-25 — Phase I.246: tail bound at 14i

Added `tail_s14_1e6`: the eta tail after 10^6 pairs at 1/2+14i is at most 1/64.

### 2026-10-25 — Phase I.247: box norm lemmas

Added `BoxNorm.lean`: absolute-endpoint bounds for `Iv` and a generic box-to-norm
bound, turning a corner norm-square inequality into `‖z‖ ≤ R` for every point of
the box.

### 2026-10-25 — Phase I.248: fixed-precision snapped boxes

Added grid rounding (`gridDown`, `gridUp`), snapped real intervals, snapped
complex boxes, and a snapped fold `foldSnap` with membership theorem. This
keeps denominators bounded across long interval sums.

### 2026-10-25 — Phase I.249: integer grid rounding

Added `gridDownInt`/`gridUpInt` using `Int.ediv` on `Rat.num`/`Rat.den`, with
soundness proofs, plus integer-rounded snapped boxes and fold. `native_decide`
still does not execute the fold at 1000 terms within budget.

### 2026-10-25 — Phase I.250: block parameters

Added `paramsBlock` and `sumValue_paramsBlock`, the first piece of the
block-emitter path for the million-term eta partial sum.

### 2026-10-25 — Phase I.251: block checker and snapped block fold

Added block splitting, block allOK extraction from the million-term global
check, block box membership, and a snapped fold over block boxes.

### 2026-10-25 — Phase I.252: block sum identity

Added `sum_blocks_eq`, relating the double block sum to the linear partial sum
over `B*M` terms.

### 2026-10-25 — Phase I.253: block values and pair fold

Added the list-range sum bridge, block value totals, the pair fold, and block
pair membership. This is the emitter's per-block composition layer.

### 2026-10-25 — Phase I.254: million-term block fold

Added `blockFold_mem` and the `B=M=1000` instance at 1/2+14i. Evaluation of
the folded box is impossible in `native_decide` because `sumBox` is
noncomputable, so an external certificate emitter is required.

### 2026-10-25 — Phase I.255: Euler transformation

Added `EtaEM.lean`: forward differences, the one-fold summation-by-parts
identity, and the finite iterated Euler transformation with explicit boundary
terms. This is the algebraic core of the alternating-tail acceleration.

### 2026-10-27 — Phase I.256: the `B₂` remainder on the critical line

`EulerMaclaurin.lean` proves the general-`K` Euler–Maclaurin error bound only
for `1 < Re s`, which excludes the critical line and therefore blocks the
`1/2 + 14i` Krawczyk target. The sharp `B₂` series bound already needed only
`0 < Re s`; what was gated was the *identification* of `zetaEMRemainder 1` with
that series.

Added `EMCritical.lean`, which closes the gap without touching the existing
`Re s > 1` proofs. The key observation is that `sum_tail_first_order` and
`sum_second_order_shift` have the same left-hand side (and the same
`∫ (k..k+1) emGShift` and `emGShift 0 n` terms), so subtracting them cancels
both and gives, for every `s` and `n`,

`Σ_{k<n} ∫ (x-k-½)·emG₁ = ½·B₂(0)·(emG₁ n - emG₁ 0) - ½ Σ_{k<n} ∫ B₂(x-k)·emG₂`.

Every term converges as `n → ∞` for `0 < Re s`, so the identity passes to the
limit — no divergent intermediate quantities, unlike the `Re s > 1` route,
which needs `Σ_{n<N} n^{-s}` and `∫_0^N x^{-s}`. That yields T296–T300,
culminating in the `K = 1` bound

`‖zetaEMRemainder 1 N s‖ ≤ (1/12)·‖(s)₂‖·((N+1)^(-σ-2) + (N+1)^(1-σ-2)/(σ+1))`

for `0 < Re s`, with the constant `2·Re ζ(2)/(2π)² = 1/12` proved exactly.

Numerically this is the unlock for step 3 of the handoff: at `s₀ = 1/2+14i`
and `N = 100` the bound is `≈1.5·10⁻³`, so `|ζ(s₀)| ≈ 0.1056` is pinned to
within `0.2%`, comfortably below the `1/8` required by `hmap_of_zeta_bound`.
The next step is to replace the noncomputable `zetaEMGen 1 N` by a rational
`Cx` fold over `CpowBox` atoms and evaluate it.

A separate numerical finding, recorded because it changes the plan: the handoff's
Euler-acceleration route for `η` (steps 1–2) is *not* needed. Measured at
`0.5+14i`, the iterated-difference error is `≈2^{-K}|Δ^K a₀|` (4.2·10⁻¹¹ at
`K = 50`), but it is an asymptotic, not convergent, expansion — the rigorous
bound `2^{-K}·Σ_n|Δ^K a_n|` grows like `K!`. The Euler–Maclaurin route reaches
`10⁻³⁰` at `N = K = 20` with eighteen atoms instead of a million terms.

### 2026-10-27 — Phase I.257: general-`K` remainder on the critical line

Extended `EMCritical.lean` from `K = 1` to every `K >= 1`. The `Re s > 1` chain
`tsum_B_even_succ → S_even_succ → zetaEMRemainder_eq_factorial` carried the
strong hypothesis only through `tendsto_emGShift_zero_general`, which is what
T293 relaxed; the telescoping identities themselves use only
`tendsto_sum_Bn_shift` (already `0 < Re s`) and `sum_B_even_eq_mul` (no
hypothesis at all). Seeding the induction with the relaxed `K = 1` case
therefore gives T301–T305:

`‖zetaEMRemainder K N s‖ ≤ (2 Re ζ(2K)/(2π)^{2K})·‖(s)_{2K}‖·((N+1)^(-σ-2K) + (N+1)^(1-σ-2K)/(σ+2K-1))`

for `0 < Re s`.  This is the general form the handoff asked for at `K ≈ 50` on
the eta side, now available for Euler–Maclaurin instead.

Term-count consequence: with `K = 4`, `N = 10` the bound is `~4·10⁻⁵` with
**12** `CpowBox` atoms, where `K = 1`, `N = 100` would need 101.  Since
`2 Re ζ(2K)/(2π)^{2K} = |B_{2K}|/(2K)!` is rational (`1/1209600` at `K = 4`),
the whole remainder bound is rational too, so it drops straight into a
`native_decide` certificate.

### 2026-10-27 — Phase I.258: calibrating the `zetaEMGen` box at `1/2+14i`

Added `python/emit_em.py`, an exact-rational mirror of the `CpowBox` layer for
the step-3 enclosure of `zetaEMGen 1 N (1/2+14i)`, and used it to find the
parameters.  Two constraints bite, neither of them visible from `Cert.lean`:

1. `cpowBox` requires the scaled exponent in `[-1,1]`, so
   `kI >= |Im s| log b`.  At `Im s = 14` and `b = 41` that is `>= 52`; the
   `kI = 32` of `paramsFast`/`pairParams` is admissible at height 5 only.
2. `expIBox kI n` computes `exp(i t/kI)^kI` by *sequential* interval
   multiplication, not by repeated squaring, so the box width grows like
   `2^(kI/2)` and `expRem n` must beat that.  At `kI = 64`, `n = 12` the box
   for `ζ` came out with corner norm `50.5` — a factor 500 too wide and
   entirely useless — while `n = 20` gives `0.10570`, correct to `1e-4`.

With `(N_log, k, kI, n) = (14, 16, 64, 20)` and `N = 20`, `K = 2`, the certified
remainder is `8.0·10⁻⁴`, so `|ζ(s₀)| <= 0.1065 <= 1/8` and the step-3 target is
reachable with 24 atoms rather than the 10⁶ pairs of the original plan.

The lesson worth recording: the `CpowBox` parameter regime is not portably
reusable across heights.  At height 14 the imaginary-exponent split dominates
the cost, and a naive transplant of the height-5 parameters produces a box that
silently *passes* the side conditions while being far too wide to exclude
anything.

### 2026-10-27 — Phase I.259: the Lean box does not match the mirror

Added `lean/EMBox14.lean`: point boxes, `inv_s14_sub_one` (the pole factor is
exactly `(-2-56i)/785` at a point box, so no interval division is needed), the
`csPow` fold with its soundness theorem, and the `native_decide` atom checks.
Evaluation is cheap — 26 s for the whole file.

The corner test fails.  Let `B` be the folded enclosure of `zetaEMGen 1 20`:
`|corner(B)|` exceeds 1, whereas `python/emit_em.py` predicts 0.10570 for the
same parameters.  Probing the atoms individually shows they are not grossly
wrong (`csPow 20` ≤ 3, `cpowBox 21 S14` ≤ 1, `cpowBox 21 S2box` ≤ 50 against
predicted magnitudes 0.22, 0.22, 4.58), so the disagreement is in *width*, i.e.
in the `CpowBox` internals rather than in `logIvRat`.

This is the useful kind of failure: the certificate is not wrong, it is too
loose, and the gap is localised to the `expIvGeneral`/`expRem`/`Iv.mul` layer.
Guessing parameters from a Python re-implementation was the mistake — the
mirror is close enough to choose `kI` but not close enough to predict the box
width.  The next probe should bisect `maxAbsIv (cpowBox 14 16 64 20 2 S14).re`
against the mirror's interval in a single compile.

### 2026-10-27 — Phase I.260: the wide atom is the one at `Im = 17`

Bisected the four components of the `1/2+14i` box separately at radius `1/2`.
`csPow 20`, `cpowBox 21 S14 · 1/2` and `cpowBox 21 S2box · 1/(s-1)` pass;
`cpowBox 21 S17box · ball 6` fails.  So the enclosure width is driven by the
largest imaginary exponent (`Im = 17`), not by the pole term or the base sum.

That is a sharper diagnosis than "the box is too wide": the `Im = 14` atoms are
fine and only the shifted one is not, which means the `powNat kI` width
amplification in Lean is materially worse than the Python mirror's `cx_pow`
re-implementation.  The mirror is therefore useless as a *width* predictor and
should be used only for the parameter *admissibility* question.

The intended fix sidesteps the problem rather than fighting it: the `B₄`
boundary term is numerically negligible (`<= 6·21^(-3) < 1/1000`), so it never
needed an atom.  Bounding it directly leaves 22 tight atoms.

### 2026-10-27 — Phase I.261: `expIBox` is the limiting factor at height 14

Round 6 ruled out three explanations for the loose enclosure by measurement:

* **atom layout** — rewriting `Bzeta` to use a *single* `21^{-s}` atom
  (absorbing the pole and `B₂` terms into the rational scalar
  `1/2 + s/252 + 21/(s-1) = 187517/395640 - (10303/14130)i`, via
  `Complex.cpow_add`) removes the `Im = 15`/`Im = 17` atoms but does *not*
  restore tightness;
* **Taylor order** — raising `n` 20 → 24 changes nothing;
* **log series** — raising `N_log` 14 → 20 changes nothing.

What remains is the `kI` dependence itself.  The `[-1,1]` condition forces
`kI >= 52` at `Im = 14`, and `expIBox` pays a factor of order `2^k` in width
from its `k` sequential `Cx.mul` steps.  At height 5 (`kI = 32`) this is
tolerable; at height 14 it is not.

The fix belongs in `partial-sum-plus-tail/lean/CpowBox.lean`: use repeated
squaring for `powNat kI` rather than `kI` sequential multiplications.  That
file is shared with five other certificates, so the change needs its own
regression pass.

Methodological note: two rounds were lost to trusting an exact-rational Python
re-implementation of `CpowBox` as a width predictor.  It agreed on the
`[-1,1]` admissibility constraint (pure rational arithmetic) but not on the
width, and the discrepancy was only found by bisecting the Lean values
directly.  For this layer, Lean's own `native_decide` is the faster oracle.

### 2026-10-27 — Phase I.262: correction — the box was miscalculated, not lossy

Rounds 5 and 6 recorded that `expIBox` is "too lossy at height 14" and that a
change to the shared `CpowBox.lean` was required.  **That was wrong, and the
claim is retracted.**  The actual defect was arithmetic in `EMBox14.lean`: the
pole scalar was carried over from the abandoned `N = 50` plan, so `Bzeta`
multiplied `21^{-s}` by `11/(s-1)` instead of `21/(s-1)`.  The box was centred
on the wrong point, which is why raising the Taylor order, lengthening the log
series, and removing atoms all failed to help — none of them could move the
centre.

With `21/(s-1) = -42/785 - 1176i/785` the corner test passes at `11/100` on
the first attempt, using `(20,16,48,24)` and 21 atoms.  `CpowBox.lean` needs no
change and no other topic's certificate is affected.

Methodological note, more useful than the false alarm: a box that fails a
corner test can be loose *or* mis-centred, and the two look identical from a
single failing `native_decide`.  The cheap discriminator is to check the box
centre against the true value first — one line of `mpmath` — before bisecting
the radius.  Two rounds of bisection would have been avoided by computing
`|centre - ζ(s0)|` at the start.

### 2026-10-27 — Phase I.263: exact rational budgets for the step-3 assembly

Added `tail_bounds` to `python/emit_em.py` (`python3 emit_em.py --tail`), which
computes the two tail bounds the Lean assembly needs, in exact rationals:

* `||zetaEMRemainder 2 20 s14|| <= 6500/1750329 = 3.714e-3` (budget `1/200`),
  from T305 with `2 Re ζ(4)/(2π)^4 = 1/720`, `||(s)_4|| <= 65000`,
  `21^(-9/2) <= 21^(-4)`, `21^(-7/2)/(7/2) <= 21^(-3)/3`;
* `||B₄ boundary term|| <= 2/3087 = 6.479e-4` (budget `1/1000`), from
  `||P₃|| <= 4320` and `21^(-7/2) <= 21^(-3)`.

Combined with the verified box corner `11/100` this gives
`|ζ(1/2+14i)| <= 0.114361`, comfortably under `1/8` with a `1.06·10⁻²` margin.
Fixing the exact rationals *before* writing the Lean avoids the usual failure
mode of discovering at the end that a crude bound was too weak.

### 2026-10-27 — Phase I.264: step 3 complete — `‖ζ(1/2+14i)‖ ≤ 1/8`

Closed step 3 of the handoff.  `EMBox14.lean` now proves, with no `sorry`:

```lean
theorem zeta_norm_le_eighth : ‖riemannZeta s14‖ ≤ (1 / 8 : ℝ)
theorem hmap_zeta : ‖Yk * riemannZeta s14‖ + (1/4)*(1/4) ≤ 1/4
```

The route: `ζ = zetaEM 20 s14` by `zeta_eq_zetaEM_of_im`; `zetaEM 20 =
zetaEMGen 2 + zetaEMRemainder 2` by definition; `zetaEMGen 2 = zetaEMGen 1 +
B₄` by `zetaEMGen_succ`; then `zetaEMGen 1` is enclosed in a 21-atom fold and
the two tails are bounded (T313, T314).  Total `0.114361 < 1/8`.

Three things made this cheap once the arithmetic bug was gone:

* the pole factor is **exact** at a point box (`1/(s₀-1) = (-2-56i)/785`,
  since `|s₀-1|² = 785/4`), so no interval division was needed anywhere;
* `Complex.cpow_add` collapses all three `21`-terms onto a *single* atom
  `21^{-s}`, which keeps every atom at `Im = 14` — the `Im = 15` and `Im = 17`
  atoms are measurably wider (`powNat kI` amplification grows with the scaled
  imaginary argument), so avoiding them was essential, not cosmetic;
* the leading constant `2·Re ζ(4)/(2π)^4 = |B₄|/4! = 1/720` is rational.

`hmap` is therefore discharged.  `hC` — a derivative enclosure `‖1 - Yk·ζ′‖ ≤
1/4` on the radius-1/4 disk — remains, and no zero is certified yet.

### 2026-10-27 — Phase I.265: `hC` scoping

Recorded the design constraints for step 4 in `HANDOFF.md`. The Krawczyk
contraction target `‖1 - Yk·ζ′‖ ≤ 1/4` on `‖z-s14‖ ≤ 1/4` has only a 9% margin
(sampled maximum `0.2295`), and Cauchy from a `ζ` bound is provably
inadequate: `|ζ″| ≤ 32M` with `M ≥ 0.1056` gives a bound of `≈1.1`, four times
too large. A direct `ζ′` enclosure over the disk is therefore required, which
means a derivative analogue of the T305 remainder bound — the one piece with no
existing support in `EulerMaclaurin.lean`.

### 2026-10-27 — Phase I.266: `hC` at r=1/4 is not reachable; r=1/5 is

Measured the Krawczyk requirements as a function of the ball radius.  At
`r = 1/4` the mean-value bound `|Yk|·r·sup|ζ″|` is `0.25541 > 0.25` — it fails
by 2% even with a perfect `sup|ζ″|`, and the subdivision route needs box radius
`≤ 0.02` (~150 EM boxes) because the bounding-box corners are `0.354` from
`s14` where the value is already `0.332`.

At `r = 1/5` both conditions hold: `hC ≤ 0.19561` (28% margin) and the map
condition `0.19744 ≤ 0.2` (1.3% margin, using the proved
`‖ζ(s14)‖ ≤ 0.114361` and `‖Yk‖ ≤ 1.29`).  So the certificate should be
instantiated at `r = 1/5`.

The blocker is `sup|ζ″| ≤ 0.96` over that disk: Cauchy gives `≥ 3.1` and
summing moduli of the differentiated EM terms gives `≥ 30`, so a genuine
second-derivative enclosure is required.  Interesting negative result: this is
the first place in the dossier where an *interval* bound cannot be made to work
and the order of the derivative is the binding constraint, not the height.

### 2026-10-27 — Phase I.267: the `1/5` radius is proved down to `hC` alone

At `r = 1/5` the map condition has only a 1.3% margin, so it was worth checking
in exact arithmetic rather than by `mpmath`.  `|Yk|² = 1.6621015 ≤ 1.29²` and
`1.29·(23/200) + 1/20 = 0.19835 ≤ 1/5`; both are now Lean theorems (T323,
T324), together with the sharpened `‖ζ(s14)‖ ≤ 23/200` (T322), the `z ≠ 1`
condition (T325) and the packaged target `zeta_zero_fifth_ball` (T326).

So the whole remaining obligation for a certified zero at `1/2 + 14i` is the
single derivative-enclosure hypothesis `hC`.  That is a much better position
than "steps 4 and 5 open": step 5 is now trivial plumbing, and step 4 is one
lemma.

Note on the radius: `r = 1/5` is *stronger* than `r = 1/4`, so nothing is
weakened by the change; `zeta_zero_quarter_ball` is simply superseded.

### 2026-10-27 — Phase I.268: the zero theorem is stated, conditional on two numbers

Reduced `hC` to two explicit numerical inputs and stated the final theorem
(T327–T329):

```lean
theorem zeta_zero_14_of_bounds
    (h1 : ‖1 - Yk * deriv riemannZeta s14‖ ≤ 1/1000)
    (h2 : ∀ z ∈ closedBall s14 (1/5),
            ‖deriv riemannZeta z - deriv riemannZeta s14‖ ≤ 47/250) :
    ∃ z ∈ closedBall s14 (1/5), riemannZeta z = 0
```

`hC` itself is then pure algebra: `10⁻³ + 1.29·(47/250) = 0.24352 ≤ 1/4`.

This is the interface the remaining work needs, and it shows how much slack
there is: the true point error is `~10⁻¹⁰` (six orders under the `1/1000`
budget) and the true Lipschitz constant is `0.1517` (24% under `47/250`).  So
the outstanding enclosure does not need to be sharp — it needs only to exist.
That materially lowers the risk on the last step, which in round 12 looked like
a 9%-margin problem.

`h1` and `h2` both still require a derivative Euler–Maclaurin enclosure,
specifically a bound on `deriv (deriv riemannZeta)` (for `h2`) and a point
enclosure of `ζ′` (for `h1`).  The blocker is a second-derivative analogue of
the T305 remainder bound; nothing else stands in the way.

### 2026-10-27 — Phase I.269: the second-derivative remainder is unnecessary

Rounds 12–14 identified "a second-derivative analogue of T305" as the blocker
for `hC`, and that looked like the hardest remaining piece because
`EulerMaclaurin.lean` has no machinery for differentiating the `S_even` series.

That framing was wrong.  The remainder is *numerically tiny* — `R = zetaEM 20 -
zetaEMGen 1 20` is bounded by `3.124·10⁻³` over the `0.45`-disk (T305 at
`K=2`, `N=20`, `Re s >= 0.05`) — so Cauchy's estimate on `R` itself gives
`|R'| <= M_R/(0.45-0.2) = 0.01249` with no new analysis at all.

Then `|ζ'(z) - ζ'(s14)| <= 0.2·sup|G''| + 2·0.01249` where `G = zetaEMGen 1 20`
is explicit, and the budget is `47/250 = 0.188`.  This needs
`sup|G''| <= 0.815`; the true value is `0.75863`, a 7.4% margin, and the total
MVT estimate is `0.1767`.  So `h2` is reachable.

The only genuinely new infrastructure required is a complex reciprocal on boxes
(`Cx.inv`) for the `1/(s-1)^k` factors; `Re(s-1)` is bounded away from zero so
this is straightforward, and it can live in the topic's own file rather than the
shared `IBox.lean`.

Lesson recorded: "we need a derivative of the remainder" was an assumption, not
a fact.  Cauchy on a *small* quantity is far cheaper than differentiating it.

### 2026-10-27 — Phase I.270: box enclosures cannot quantify over 2D regions

Retracted the round-15 plan for `h2` (`M_R` → `Cx.inv` → `G''` box over the
disk → MVT).  It rested on an unexamined assumption: that a `CpowBox`
enclosure over a 2D rectangle stays tight.  It does not.

Probed directly in Lean with `native_decide`: a *single* atom `20^{-S}` over
the ball's bounding rectangle `[0.3,0.7] x [13.8,14.2]` has width `>= 0.1`,
and over a rectangle of half-width `0.02` has width `>= 0.01`.  Interval
arithmetic captures no cancellation over a region — the box width of a sum is
the sum of the term widths — so `sum_{n<=20} n^{-S}` is `>= 2` wide against
`|zeta| ~ 0.1`, and with `(log n)^2` weights `G''` is far worse.

Consequence, and it is the important part: **no statement quantifying over a
2D region can be certified with this layer at all.**  That is not a matter of
effort or parameters.  `hC` is such a statement.

The correct technique is a Taylor model: a point enclosure of the coefficients
plus a crude modulus-sum bound on one high derivative, where the factor
`r^m/m!` does the work.  Measured remainder bounds on the `1/5`-ball
(`|G^{(m)}| <= sum_{n<=20} (log n)^m n^{-0.3}`):

  degree 3: 2.0e-2    degree 5: 1.9e-4    degree 6: 1.5e-5    degree 7: 1.0e-6

so the model is not the bottleneck; the true degree-7 error is `3.6e-11`.

Two useful by-products: no `Cx.inv` is needed after all (the pole factor
`(s0-1)^{-k}` is *exactly rational* at a point), and the remaining delicate
step — bounding `sup |sum a_j w^j|` over the disk by `0.188` — is a **1D**
problem on a circle, which interval arithmetic can handle (the naive modulus
sum gives `0.25`, so subdivision into arcs will be needed).

Methodological note: this is the third time in this dossier that a "mechanical"
plan turned out to rest on an untested assumption about interval arithmetic
(after the mirror-as-width-predictor error and the miscalculated pole scalar).
Probing the primitive with one `native_decide` before designing around it has
been the only reliable way to find these.

### 2026-10-27 — Phase I.271: `h2`'s risk item is closed; no circle subdivision

Round 16 flagged the disk bound `sup |sum a_j w^j| <= 0.188` as the design risk.
Prototyping with 30-digit coefficients settles it: the naive modulus sum
`sum_{k=2..8} k|c_k| r^(k-1)` equals `0.13928`, which is *exactly* the true
`sup|zeta'(z) - zeta'(s0)|` on the ball — the triangle inequality is tight
because the terms nearly align at `w = r`.  Budget is `0.188`, so 26% margin and
**no circle subdivision is needed**.

Taylor remainders (`sum_{n<=20} (log n)^m n^{-0.3}`, no cancellation needed):

  K=5: 2*2134*0.2^5/120 = 0.0114  -> total 0.1507
  K=6: 2*5782*0.2^6/720 = 0.0010  -> total 0.1403

Also located the differentiability route: `AnalyticAt.fderiv` and
`AnalyticOnNhd.iteratedFDeriv` in `Mathlib/Analysis/Calculus/FDeriv/Analytic.lean`
give that every `deriv^[k] zeta` is analytic, hence differentiable.  So the MVT
lemma already in `Krawczyk.lean` plus an induction suffices; no bespoke Taylor
theorem is required.

The design is now settled.  What remains is bulk: point enclosures of
`c_k = zeta^(k)(s14)/k!` for `k = 1..5`, differentiating `zetaEMGen 1 20`
explicitly.  In a pleasing reversal of round 15, `Cx.inv` turns out not to be
needed at all — the pole factor `(s0-1)^{-k}` is exactly rational at a point.

### 2026-10-27 — Phase I.272: `deriv` of `b^z` and `b^{-z}` (first derivative layer)

Added `EMDeriv.lean` (T330–T331), the gate for the `ζ′` enclosure:

  hasDerivAt_cpow_exp  d/dz b^z  = b^z * log b        (b != 0)
  hasDerivAt_cpow_neg  d/dz b^-z = -(b^-z * log b)

Mathlib has neither.  The proof goes through `Complex.cpow_def`, which is
*piecewise*:

  b ^ z = if b = 0 then (if z = 0 then 1 else 0) else exp (log b * z)

so the rewrite needs `if_neg hb` and then a targeted `mul_comm (log b) s` for
the argument order.  Three attempts were lost to `simp`/`rw` not matching
(`Complex.exp` vs `NormedSpace.exp`, and an untargeted `mul_comm` hitting the
wrong occurrence) before reading the actual statement of `cpow_def` settled it
in one line — the recurring lesson of this dossier: read the lemma, do not
guess its shape.

The sum lemma `d/ds sum_{n<N} (n+1)^{-s}` was attempted and deferred: `HasDerivAt.sum`
returns the sum of *functions*, so it needs `Finset.sum_apply` and
`Finset.sum_neg_distrib` to reshape both the function and the derivative value.
That belongs with the next increment.

### 2026-10-27 — Phase I.273: base sum differentiated

`hasDerivAt_sum_cpow` (T332): `d/ds Σ_{n<N} (n+1)^{-s} = -Σ (n+1)^{-s} log (n+1)`,
assembled from `hasDerivAt_cpow_neg` via `HasDerivAt.sum`.  Two reshaping steps
were needed and are worth recording: `HasDerivAt.sum` returns the derivative of
a sum of *functions* (`∑ x, fun z => ...`), so the function needs
`funext` + `Finset.sum_apply`, and the value needs `Finset.sum_neg_distrib` to
match a `-∑ ...` statement.  Stating the lemma with the value as `-∑ ...`
rather than `∑ -...` made the last step one line.

### 2026-10-27 — Phase I.274: pole and 21-power terms differentiated

Three more derivative lemmas (T333-T335), all stated in the form the `ζ′`
assembly needs:

  hasDerivAt_pow21_one_sub   d/dz 21^(1-z) = -log21 * 21^(1-s)
  hasDerivAt_pow21_neg       d/dz 21^(-z)  = -log21 * 21^(-s)
  hasDerivAt_pole            d/dz [21^(1-z)/(z-1)]
                               = 21^(1-s) * (-log21/(s-1) - 1/(s-1)^2)

Two friction points, both instances of the same pattern as T330: after
`HasDerivAt.comp` the function is a syntactic `Function.comp`
(`(fun z => 21^z) ∘ (fun z => 1 - z)`), so it needs a `rfl` rewrite before
`convert` will see it as `fun z => 21^(1-z)`; and `HasDerivAt.inv` produces the
value `-1/(s-1)^2`, not `-(s-1)⁻¹^2`, so the hypothesis must be stated in the
form the library gives rather than the form I wanted.

Remaining for `h1`: the `B₂` term `(1/12)·s·21^(-(s+1))`, the assembly into a
box at `s14`, and the `deriv` bridge from `ζ` to `zetaEM 20`.

### 2026-10-27 — Phase I.275: the `deriv` bridge, and a good surprise

Two results.

**T336** `deriv riemannZeta s14 = deriv (zetaEM 20) s14`.  `zeta_eq_zetaEM_of_im`
is a pointwise statement, so it cannot be differentiated directly; instead prove
`riemannZeta =ᶠ[𝓝 s14] zetaEM 20` by applying the pointwise theorem throughout a
ball of radius `1/2`, then use `Filter.EventuallyEq.deriv_eq`.  The ball bounds
give `z.re > 0`, `13.5 < z.im < 14.5` from `|z - s14| < 1/2` via
`Complex.abs_re_le_norm` / `abs_im_le_norm`.

**Good surprise**: round 18 probed `derivAtom n` and asserted only `width <= 1e-3`,
which I then worried about — twenty such atoms would give `0.02`, far above
`h1`'s `7.7e-4` allowance.  Re-probing with tighter thresholds shows the actual
width is `<= 1e-9` per atom, so the sum is `~1e-8`.  The enclosure precision was
never the problem; `1e-3` was merely a loose assertion that happened to pass.

Lesson: an *existential-style* probe ("is it at most X?") only tells you the
bound you asked for.  To learn the actual magnitude, bisect the threshold until
it fails — one extra compile, and it changed the feasibility assessment from
"tight" to "unconstrained".

### 2026-10-27 — Phase I.276: derivative layer complete for the base and pole terms

`hasDerivAt_cpow_neg_shift` (T337): `d/dz b^(-(z+c)) = -log b · b^(-(z+c))`,
needed for the `B₂` boundary term `s·21^(-(s+1))` (`c = 1`).  Same
`Function.comp` friction as T333: `HasDerivAt.comp` leaves the syntactic
composite, which needs a `rfl` rewrite before `convert`.

`EMDeriv.lean` now has the full derivative toolkit for the explicit
Euler–Maclaurin expression (T330–T337): `b^z`, `b^(-z)`, the shifted
`b^(-(z+c))`, the finite base sum, `21^(1-z)`, `21^(-z)`, the pole term, and the
`deriv` bridge from `ζ` to `zetaEM 20`.

Still open for `h1`: the function identity
`zetaEMGen 1 20 s = Σ + pole + 21^(-s)/2 + (1/12)s·21^(-(s+1))` as an equality
of *functions of `s`* (only the `s14` instance exists, as T315), the assembly
into a box, and the Cauchy bound on `deriv (zetaEMRemainder 2 20)`.

### 2026-10-27 — Phase I.277: the Euler–Maclaurin expression as a function

`zetaEMGen_one_fun` (T338): T315 generalised from `s14` to a variable `s`.
Needed because a derivative is a statement about a *neighbourhood*, so the
`s14`-instance is not enough.

Two cast traps, both the `Nat.cast`-vs-`OfNat` pattern that has bitten this
dossier repeatedly: the terms render as `↑(↑20 + 1)` and `21 ^ (-(s + ↑0))`,
so the rewrite lemmas must be stated as `((↑(20:ℕ) : ℝ) + 1 : ℝ)` and
`-(s + (↑(0:ℕ) : ℂ))`, not with bare numerals.  A final `ring` turned out to be
redundant once the exponent rewrite closed the goal.

### 2026-10-27 — Phase I.278: the Euler–Maclaurin expression is fully differentiated

`hasDerivAt_zetaEMGen_one` (T339):

  d/ds zetaEMGen 1 20 s
    = -sum (n+1)^(-s) log(n+1)
      + 21^(1-s) (-log21/(s-1) - 1/(s-1)^2)
      - log21 * 21^(-s) / 2
      + (1/12) (21^(-(s+1)) - s log21 21^(-(s+1)))

assembled from T330-T338 by `HasDerivAt.add/sub/div_const/const_mul/mul`.  One
presentation note: `convert hall using 1` left only the *value* goal (the
function arguments unified definitionally), so a single `ring` closed it — but
I first tried `funext`/`ext` there, wasting two attempts.  The lesson from T333
(composites need `rfl`) does not generalise to sums: pointwise function
addition unifies syntactically, so checking which goal `convert` actually
leaves is cheaper than guessing.

`deriv (zetaEMGen 1 20) s14` is therefore now an explicit expression.  What
remains for `h1`: enclose that expression in a box at `s14` (atoms are ~1e-9
tight, so unconstrained), add the Cauchy bound on `deriv (zetaEMRemainder 2 20)`
(`<= 0.0125`), and assemble.

### 2026-10-27 — Phase I.279: `h1` needs K=3, not K=2

Checked the K-dependence of the remainder-derivative bound before building the
`h1` assembly, and the planned `K = 2` does not work.

`h1`'s budget is `0.25 - 1.29*(47/250) = 7.48e-3` (T328).  The remainder's
derivative comes from Cauchy, `|R'| <= 2 M_R / rho` with `rho = 0.45`:

  K=1: M_R = 7.64e-1  -> 1.29*|R'| = 4.38    FAIL
  K=2: M_R = 3.12e-3  -> 1.29*|R'| = 1.79e-2 FAIL (2.4x over)
  K=3: M_R = 3.97e-5  -> 1.29*|R'| = 2.28e-4 OK (33x margin)

So the assembly must use `zetaEMGen 3 20`, which adds the `B_6` boundary term
`-(1/30240)*P_5(s)*21^(-(s+5))` and its derivative; `P_5` and `P_5'` are exact
Gaussian rationals at `s14`.

Worth noting how this was nearly missed: T320–T339 were all built assuming
`K = 2` for the remainder, because `K = 2` suffices for the *value* bound
(T306).  Differentiating tightens the requirement by three orders of magnitude,
because Cauchy on `R` divides by only `rho`, not by `rho^k`.  A value certificate
and a derivative certificate need different `K`.

### 2026-10-27 — Phase I.280: the `ζ′` enclosure is defined and its corner checked

Built the enclosure of `deriv (zetaEMGen 1 20) s14` (T340-T341 plus definitions):

* `derivAtom n = cpowBox 20 16 48 24 n S14 × logIvRat 20 n`, folded by `dsPow`;
* every `21`-power in T339's expression is a *rational* multiple of the single
  atom `21^{-s14}`, so the remaining part is
  `21^{-s14} · (A0 + A1·log21)` with
  `A0 = 17190769/155288700 - (4704/616225)i`,
  `A1 = -177437/395640 + (20383/14130)i`
  (computed exactly; `A1` is the negation of the value-box scalar, a useful
  consistency check);
* `Vbox = -(dsPow 20) + cpowBox 21 S14 × scalarBox`, and its corner is verified
  `<= 4/5` by `native_decide` against the true `|ζ′(s14)| = 0.77560`.

Two design corrections this round:

1. **T328/T329's `h1` budget was too tight at `1/1000`.**  The achievable error
   is `|Yk|·(|V - ζ′| + |B₄′+B₆′+R₃′|) ≈ 1.1e-3` (V differs from ζ′ by
   `2.8e-4`, the `B`-term derivatives contribute `~3.5e-4`, `R₃′ <= 1.8e-4`).
   Loosened `h1` to `1/200`, still giving `1/200 + 1.29·(47/250) = 0.24752 <= 1/4`.
2. **The `K=3` finding from round 23 is confirmed and absorbed**: the crude
   bound route bounds `B₄′+B₆′` by moduli rather than computing `P₅, P₅′`
   symbolically, and the remainder is taken at `K=3`.

Remaining for `h1`: the *membership* proof `Cx.mem (T339 at s14) Vbox` (needs
`Complex.cpow_add` to fold the `21`-powers onto one atom, and the scalar
arithmetic), the ball for `B₄′+B₆′+R₃′`, and the final assembly.

### 2026-10-27 — Phase I.281: folding the 21-powers

T342-T343: `21^(1-s) = 21·21^(-s)` and `21^(-(s+1)) = 21^(-s)/21` via
`Complex.cpow_add`.  These are the rewrites that fold T339's three separate
`21`-powers onto the single `21^{-s}` atom, which is what makes `Vbox` a
one-atom enclosure rather than four.

Both compiled first try — the `cpow_add` statement already carries the
`x ≠ 0` hypothesis, so `by norm_num` discharges it inline and no `if_neg`
dance is needed (unlike `cpow_def`, which is piecewise).

### 2026-10-25 — research note: polar, per-half, and grouped decompositions

Question raised against `status.html` §3: can one look down the `t` axis,
separate terms by polar coordinates or by right/left half, or group every
`n`-th term, and capture Weil positivity with a partial sum plus tail per
group?

The short form (a fuller route assessment — the five mechanisms, the uniform no-go
and the finite first target — is in `topics/prime-spectrum-tensor/WEIL-POSITIVITY.md`
§2–§4):

- A decomposition of `ζ(s) = Σ n^{-s}` into groups, with a rigorous
  Euler–Maclaurin partial sum and tail per group, is admissible as a
  computational decomposition.
- It does not by itself capture `W(f,f) ≥ 0`. Weil positivity is a quadratic
  form on test functions; groupwise scalar positivity does not imply it, and
  the cross terms and tail can carry either sign.
- Polar bins are `t`-dependent and use only the additive phase `t log n`.
  They therefore apply to the Davenport–Heilbronn twist and fail the litmus.
- A right/left split is mirrored by the functional equation and does not
  remove the cancellation.
- Residue-class grouping is arithmetic and reduces to Hurwitz/Dirichlet
  `L`-values, but it is still local; DH is a combination of two `L`-functions
  mod 5, so it does not pass the litmus by itself.
- A successful version needs a sum-of-squares/positive-operator
  factorization, orthogonal blocks, operator-norm tails, and an Euler-product
  input that DH lacks. A finite Gram matrix can refute a candidate; it cannot
  prove the infinite-dimensional positivity.

No theorem is claimed. This is a research direction, recorded so it is not
mistaken for a bridge.


### 2026-10-25 — handoff: helix bookkeeping and Weil positivity

Wrote [`handoff-helix-positivity.md`](handoff-helix-positivity.md). It records
the helix properties H1–H7 (monotone phase, monotone step, unbounded winding,
decreasing radius, constant pitch, one-turn residual, summation-by-parts
bound), the reasons the helix is not positivity (projection sign, winding,
quadratic form, conditional convergence, DH litmus), and the bridge criteria
B1–B7 (sum of squares, orthogonal blocks, positive operator, positive measure,
Euler-product input, operator-norm tail, all test functions). It also lists
concrete experiments E1–E5 and the handoff checklist. No bridge is claimed.

### 2026-10-27 — self-adjoint-ccm: the CCM bridge as written is blocked

Developed the `self-adjoint-ccm` dossier toward the Weil-positivity bridge in
[`topics/self-adjoint-ccm/WEIL-BRIDGE.md`](topics/self-adjoint-ccm/WEIL-BRIDGE.md).
The bridge chain is L0 Weil's criterion, L1 a self-adjoint operator with spectrum
`{γ_n}`, L2 its spectral measure, L3 the identification with `W`, L4 positivity.
The dossier's T1–T7 only support L1's bookkeeping; L3 is the actual bridge.

Two finite obstructions:

- **Lattice spectrum.** With the blueprint's constant matching condition, `D_λ` has
  spectrum `(Θ + 2πn)/L` (periodic) or `(Θ + (2n+1)π)/L` (antiperiodic), independent
  of the prime positions. A rigid shift of a lattice cannot be the zero set.
- **Negative corner.** The formal compression has diagonal `ε μ_k + S/L`; the corner
  `Q_{−N,−N}` diverges linearly and is negative for all sufficiently large `N`. The
  compression is not PSD and cannot be the positive CCM Weil matrix. The delta part
  alone is PSD (T10), so the free diagonal is the obstruction.

Four new Lean theorems (T8–T11: Hermitian compression, diagonal formula, PSD delta
form, unitary matching product) and three computations (C9–C11: Hermiticity/negative
corner, eigenvalue scaling, equally spaced matching spectrum) are in the dossier.
Python 11 passed; Lean 28s; structural audit 48/48. The survey
[`bridge-to-weil-positivity.md`](bridge-to-weil-positivity.md) now records that B4 is
the right shape but blocked as written; the next finite step is a Weil Gram matrix on
a smooth test basis, not a spectrum comparison of `D_{λ,N}`. No theorem is claimed
and RH is not touched.

### 2026-10-27 — finite Weil Gram matrix on a Gaussian basis

Attacked the recommended finite step from the CCM bridge note: a smooth-basis
Weil Gram matrix. New note
[`topics/prime-spectrum-tensor/WEIL-GRAM.md`](topics/prime-spectrum-tensor/WEIL-GRAM.md).

The basis is `φ_a(u) = exp(-(u-a)^2/(2σ^2))`. The reflected convolution is again a
Gaussian, so every Gram entry reduces to a pole term, a one-dimensional
archimedean integral, and a finite prime sum. The bilinear form is the
symmetrisation `G_ab = (W(h_ab)+W(h_ba))/2` with `h_ab = φ_a * φ̌_b`; this is the
polarisation of `Q(f)=W(f*f̌)` and is symmetric.

The 4×4 basis `σ=0.05`, centres `-0.3,-0.1,0.1,0.3` gives
`G[0,0]=0.0431359583948`, smallest eigenvalue `2.2710e-2`, and an active prime
term `-0.0364816` at separation `c=0.6`. The numerical Cholesky factor is
positive; a rational shadow `L L^T` (denominator `10^6`) is PSD exactly by T10 and
matches `G` to `4.0e-13`. The shadow is now Lean-certified as T12
(`L4Shadow_posSemidef`). Wider bases show the predicted margin collapse:
`1.87e-5` at `σ=0.15` and `1.46e-8` at `σ=0.2`.

This is a numerical rung, not a certificate: `Ω` is quadrature, not an interval
enclosure, and the prime sum is truncated. C8 is added to the PST ledger; tests
8 passed. The next layer is the `Ω` enclosure, after which the rational shadow can
be fed to T8/T10. No RH claim.

### 2026-10-27 — first Omega interval layer

Added a rigorous pointwise enclosure of `Ω(t)=Re ψ(1/4+it/2)-log π` in
`topics/prime-spectrum-tensor/python/programme.py` (C9,
`test_omega_interval_encloses_digamma`). It uses the digamma integral
representation, outward-rounded `mpmath.iv` intervals, a midpoint rule with an
interval derivative bound, a series for `u/(e^{2πu}-1)` near zero with a
conservative remainder, and an exponential tail bound.

Containment and widths on representative points: `t=0` width `3.04e-2`, `t=0.5`
`2.86e-3`, `t=1` `3.76e-3`, `t=10` `7.08e-5`. The true digamma values lie inside.
C10 adds a crude Gaussian prime-tail bound below `1e-100` for `σ=0.05`,
`|c|≤0.6`. C11 adds a deterministic rational-node Simpson rule (n=4000, T=200)
that matches the adaptive density quadrature at c=0 and c=0.6 to <1e-8. A naive
lifting of the pointwise Ω layer to a t-interval was also tested: it gives
infinite widths on panels crossing the derivative singularities, so a t-jet or
Taylor model is required for the density quadrature. C12 adds a numerical
fourth-derivative diagnostic: the integrand's `|f⁗|` is below `1e4` at
representative points, setting a Simpson error target of about `3.6e-5` at
`n=40000`. No RH claim.


### 2026-10-27 — interval t-jet layer

Added `python/jet.py`, a univariate interval Taylor-jet algebra (`+`, `-`, `*`,
reciprocal, `log`, `exp`, `cos`, `sin`) in derivative representation. Added
`omega_t_jet(t, order)`, which composes the jet algebra with the C9 `u`-integral
to enclose `Ω` and its first `order` `t`-derivatives on a point or `t`-interval.

C13 checks the elementary jet derivatives; C14 checks that the `Ω` jet contains
the value and first four derivatives at `t=0.5`. This is the infrastructure for
the Taylor-model density quadrature; the series/tail remainders still need a
formal audit before a certificate. PST tests 14 passed.


### 2026-10-27 — certified Taylor density panels

Added `gaussian_density_panel_taylor` on top of the `Ω` t-jet. It returns an
interval value plus a Taylor-remainder bound `σ² M4 H^5/1920`, with `M4` the
interval fourth derivative on the panel. C15 verifies containment on four panels:
[0.4,0.6], [10,10.2], [0,0.2] and [0.2,0.4] at σ=0.05, c=0.6. Wide panels
crossing t=0 still lose the A/B correlation and must be scheduled narrowly.
PST tests 15 passed. The remaining work is the full panel schedule and total
remainder assembly into the Gram entries.


### 2026-10-27 — assembled certified density intervals

Added `gaussian_density_certified` and `gaussian_density_certified_multi`. C16
assembles ten Taylor panels over [−1,1] and C17 does the same for c=0 and c=0.6
while sharing the Ω jets. The full 4×4 interval-certificate script is
`python/certify_gram.py` (H=0.08, T=100, h=0.05, U=3); it adds pole and prime
intervals, forms the symmetric Gram matrix and checks diagonal dominance. The
full run was launched in the background; no certificate is claimed until it
completes.


### 2026-10-28 — full interval Gram run: first near-miss

Assembled the certified density panels into the full 4×4 Gram script
`python/certify_gram.py` and checked leading principal minors (not merely
diagonal dominance). The H=0.1, T=100 run produced positive first, second and
third minors and a fourth minor interval [-1.53e-6, 6.17e-6] straddling zero;
NOT CERTIFIED. A finer H=0.08 run was launched. Fixed an interval-endpoint bug
(`.a` on an `ivmpf` is a zero-width interval, not an mpf) that had inflated the
error bounds.


### 2026-10-28 — certified 4×4 interval Gram matrix

The full H=0.08, T=100 run (2500 certified Taylor panels) produced the interval
4×4 Gram matrix. The center/error certificate (C18) with a conservative 1e-4
margin gives t=0.0209751863 and positive rational leading minors of center−tI:
0.0221277, 2.1412e-4, 1.5982e-6, 1.1271e-8. Hence every symmetric matrix in the
widened interval box is positive definite. This is a finite computational
certificate, not a Lean theorem and not cone positivity. The 1e-4 margin covers
the provisional jet series/tail remainders; the Taylor panel remainder is
explicit. The finite Gram-matrix objective is achieved at this margin.


### 2026-10-28 — margin audit and PSD-check comparison

Replaced the blanket 1e-5 jet-series allowance with explicit Bernoulli bounds:
|s−p| <= 10u^4 and |s′−p′| <= 40u^3 on [0,0.01], transported through J and J_u
and added componentwise to the Ω jet. Added a conservative 1e-6 allowance for
the u-tail; the 1e-4 Gram-entry margin dominates both.

Compared direct interval leading minors with the center/error certificate on the
H=0.08 matrix at the 1e-4 margin. The direct fourth interval minor is
[−1.58e-6, 6.23e-6] (inconclusive); the center/error check has t=0.0209751863
and positive shifted rational minors (last 1.1271e-8), so it certifies. C19
records the comparison. PST tests 19 passed.


### 2026-10-28 — exact LDL vs leading minors

Added `exact_ldl_pivots` for rational symmetric matrices and C20: on the H=0.08
center−tI matrix, all LDL pivots are positive and equal the Sylvester ratios of
the leading principal minors. This confirms the center/error finite PSD check
against the exact rational minor test. Direct interval minors remain
inconclusive at the fourth minor (C19); the center/error plus exact LDL/minor
check is the sharper certificate.


### 2026-10-28 — end-to-end audited certificate: CERTIFIED

Reran the full interval computation with the audited jet: H=0.1, T=100, U=4,
2000 panels, explicit Bernoulli series remainder, 1e-6 derivative-tail allowance
and 1e-4 entry margin. Center/error certificate: t=0.0210956719; leading minors
0.0220072, 2.08799e-4, 1.49584e-6, 9.97517e-9; all positive; CERTIFIED (C21).
This closes the end-to-end rerun. The derivative-tail allowance is conservative
and dominated by the entry margin; a term-by-term tail proof would remove it.


### 2026-10-28 — term-by-term tail proof and final U=6 certificate

Wrote `TAIL-PROOF.md`: exact root locations for the denominator, a Cauchy bound
on a radius-1/5 disk, s(u)<=2e^{-2πu}, and the explicit integral of u³e^{-2πu}.
This proves the u-tail beyond U=6 is below 1e-5 in every Ω jet component of
order 0..4 for |t|<=100. Reran H=0.1,T=100,U=6 with the proven 1e-5 allowance
and 1e-4 margin: t=0.0211003138; shifted minors 0.0220026, 2.08595e-4,
1.49194e-6, 9.92643e-9; CERTIFIED (C22). This supersedes C21 for the tail audit.
PST tests 22 passed.


### 2026-11-06 — Weil positivity: Wave 1 reduced to infinitude alone

Continued the [Weil-positivity handoff](topics/weil-positivity/HANDOFF.md) across
the hub and its three upstream programmes. The headline is a real reduction,
not a closure: **`ZeroTailSummable` now follows from infinitude of the
nontrivial zeros alone**, and the off-line obstruction has an exact scalar
criterion. Objective O2 remains open and RH-equivalent.

**zero-infinitude (T4–T9).** Earlier revisions carried a linear log-growth
hypothesis and ordinate growth as separate inputs. Both are gone:

- `tendsto_abs_atTop_of_summable_inv_sq`: if `Σ ((|γ n|+1)^2)⁻¹` converges,
  the weight terms tend to zero, hence `|γ n| → ∞`. (The proof uses
  `Summable.tendsto_atTop_zero`, `one_div_lt_one_div`, and `sq_lt_sq₀`.)
- `zeroTailSummable_of_nontrivial_xi₀_enumeration'`: for any injective
  enumeration of nontrivial zeros and any `σ > 0`, the Gaussian zero tail is
  summable. The proof feeds `exists_bound_log_norm_xi₀` (unconditional
  order-one growth) into `xi₀_zeros_inv_sq_summable_of_log_growth`, transfers
  to the enumeration, restricts to the imaginary part via the strip bound, and
  derives ordinate growth from the resulting summability.
- `nontrivialZeros_denumerable_of_infinite` packages
  `Countable + Infinite ⇒ Nonempty Denumerable`; `exists_nontrivial_xi₀_enumeration_of_infinite`
  and `exists_enumeration_and_zeroTailSummable_of_infinite` are the
  enumeration and tail capstones. The capstone takes only
  `Infinite {z // ξ₀ z = 0 ∧ 0 < Re z}` and `σ > 0`. Finally
  `nontrivialZeros_denumerable_iff_infinite` records the exact equivalence
  `Nonempty (Denumerable S) ↔ Infinite S` for the nontrivial-zero subtype.
  Finally `zeroTailSummable_mono` records monotonicity in the width: one
  positive `σ` suffices for every larger width, and `exists_zero_abs_im_gt`
  shows infinitude forces the zeros to be unbounded in ordinate (otherwise the
  strip bound would trap them in a ball, where only finitely many live).

So the only open zero-set fact is infinitude itself. The argument-principle
route (`tendsto_digamma_nat_re_atTop`) and the finite-zero Hadamard route both
remain research-scale; neither is axiomatised.

**log-derivative-growth (T4–T7).** Proved
`integrable_abs_pow_mul_exp_neg_mul_sq` (every `|y|^k` times a Gaussian is
integrable, by restricting to `Ioi 0` and reflecting through `neg`), then
`integrable_one_add_abs_pow_mul_exp_neg_sq` from `add_pow_le`, and finally
`verticalLogDerivIntegrable_of_polynomial_bound`: a bound
`‖(Z'/Z)(x+iy)‖ ≤ M(1+|y|)^k` plus measurability already gives
`VerticalLogDerivIntegrable`. The harvested linear theorem is recovered as
`verticalLogDerivIntegrable_of_linear_bound'` (`k = 1`). This matters because
Stirling/Cauchy estimates naturally produce polynomial rather than linear
bounds. Measurability is no longer open:
`measurable_riemannZeta`, `measurable_completedZeta` and
`measurable_logDeriv_completedZeta` (using `measurable_deriv`, which holds for
an arbitrary function, plus `measurable_of_measurable_on_compl_singleton` for
`ζ`), then `aestronglyMeasurable_logDeriv_mul_gaussian`, give
`verticalLogDerivIntegrable_of_polynomial_bound'` and
`verticalLogDerivIntegrable_of_linear_bound''` with no measurability
hypothesis at all. The Cauchy step is also now formalised:
`norm_logDeriv_le_of_sphere_bound` turns a circle bound `M` at radius `R` and
a lower bound `a ≤ ‖f s‖` into `‖f'/f s‖ ≤ M/(R a)`, and
`norm_logDeriv_completedZeta_le_of_sphere` specialises it to `Z` (away from
`1` and the Gamma poles). The growth interface is also widened beyond
polynomials: `verticalLogDerivIntegrable_of_exp_bound` accepts
`‖Z'/Z‖ ≤ M exp(A y²)` provided `A < σ²`, since the Gaussian dominates it, and
`verticalLogDerivIntegrable_of_exp_bound'` removes the measurability
hypothesis. This matches the shape of the Stirling/Gamma estimates.

The **upper half of Stirling is now proved** on the right. Using
`ξ₀ = z(z−1)Z` and the unconditional order-one bound on `ξ₀`,
`exists_circle_growth_completedZeta_right` shows that on a circle of radius `R`
around `x + iy` with `1 < x − R`,
`‖Z z‖ ≤ M exp(A y²)`. The case analysis uses the real part lower bound
`x − R` on the circle (`re_ge_of_mem_sphere_sub`,
`re_ge_of_mem_closedBall_sub`). The resulting interface
`verticalLogDerivIntegrable_of_right_growth_lower` takes the upper bound
`M exp(A y²)` and an exponential lower bound
`a exp(−B|y|) ≤ ‖Z(x+iy)‖` with `A + B/2 < σ²`, and returns
`VerticalLogDerivIntegrable`. The only analytic input still missing on the
right is that lower bound; it is the shape produced by the Gamma asymptotics
(`|Γℝ(x+iy)|` decays like `e^{−π|y|/2}`).

The capstone `exists_positive_verticalLogDerivIntegrable_of_right_lower` removes
even the choice of width: from the exponential lower bound alone it produces a
`σ > 0` with `VerticalLogDerivIntegrable`, using the proved upper bound and
choosing `σ` large enough that `A + B/2 < σ²`. Thus the right-line vertical
input is now exactly the Gamma lower bound, with no other analytic or
measurability hypothesis.

The zeta half of that lower bound is also proved:
`exists_zeta_lower_bound_right` shows `‖ζ(s)‖ ≥ 1/4` for `Re s ≥ 2` from the
Dirichlet series, the first term, and the tail comparison with
`∑ 1/(n+2)² = π²/6 − 1`. What remains is the Gamma factor alone.

**zero-density-bound (T5–T9).** Added the tail-predicate algebra
(`tailEntryBound_mono`, `tailEntryBound_nonneg`,
`tailEntryBound_iff_fullBlockWithin`) and the exact 2×2 criterion:
`!![a, b; b, a]` is PSD iff `|b| ≤ a`. The forward direction uses the vectors
`(1,1)` and `(1,-1)`; the reverse writes the quadratic form as
`((a-b)/2)(x₀-x₁)² + ((a+b)/2)(x₀+x₁)²`. It also proves the counting corollary
`zero_count_le_rlog`, a Riemann–von Mangoldt-type bound
`N(r) ≤ C r log(r+2) + D` obtained from the unconditional log-growth bound,
and `tailEntryBound_iff_max_le`, the normal form in which the tail predicate is
a single bound on the maximum absolute entry. It also strengthens the
domination step: `twoByTwo_perturbed_not_posSemidef_abs` and
`not_posSemidef_of_tailBound_abs` use the exact scalar hypothesis
`S(0) − |S(c)| + 2B < 0`, matching the hub's criterion `|S(c)| ≤ S(0)` (the
harvested version only covered `S(0) − S(c) + 2B < 0`). Finally
`exists_domination_abs` shows that for *every* `B ≥ 0` a separation satisfies
`S(0) − |S(c)| + 2B < 0`, so the existence of the separation is no longer an
input. The height tail is also controlled:
`tendsto_gaussian_zero_mass_outside_radius` proves that the Gaussian mass of
the zeros with `|γ n| ≥ R` tends to `0` as `R → ∞` (split off the finitely many
early indices, then use the tail of the summable series). Thus the zero-density
side has the count, the separation, and the height tail; what remains is the
entrywise reduction of the full block to that tail mass. The zero-density
estimate `B` itself is still open. A new computation C5 checks the finite
model: the Gaussian mass of the tabulated zeros outside radius `R` decreases
with `R` and vanishes past the largest ordinate. The entrywise interface is
also in place: `abs_tsum_le_mul_tsum` bounds a zero sum by `C` times the total
mass, and `tailEntryBound_of_complex_tail` turns four such sums into
`TailEntryBound` with `B = C ∑ w`. The interface is instantiated on the
Gaussian test function itself: `exists_gaussianZeroTest_bound_strip` proves
`‖H_c(z)‖ ≤ C exp(−σ²(Im z)²)` uniformly on the critical strip,
`summable_gaussianZeroTest_of_strip` proves `∑ H_c(aₙ)` summable whenever the
Gaussian zero tail is, and `norm_gaussianZeroTailEntry_le` bounds the sum by
`C ∑ exp(−σ²(Im aₙ)²)`. What remains is the explicit-formula bookkeeping that
writes the four Gram entries as products of these sums. The high-zero tail is
also controlled quantitatively: `exists_tailEntryBound_gaussian_high` shows
that for every `ε > 0` there is a height `R` such that the Gaussian sums
restricted to `|Im aₙ| ≥ R` satisfy `TailEntryBound` with `B = C ε`. Thus the
W4 bound can be made arbitrarily small above any chosen height; only the
finitely many low zeros need separate treatment. The full block version is
also proved: `exists_tailEntryBound_gaussian_all` gives a single finite `B`
for the four zero-side sums `∑ H_{cᵢⱼ}(aₙ)`. This is the entrywise W4 bound in
the Gaussian model. The product case is also proved:
`exists_gaussianZeroTest_mul_bound_strip` gives the strip bound for
`H_{c₁}H_{c₂}`, and `exists_tailEntryBound_gaussian_gram_all` gives a finite
`B` for the four product sums `∑ H_{cᵢⱼ,1}(aₙ)H_{cᵢⱼ,2}(aₙ)`, which is closer
to the actual Gram entries. The remaining bookkeeping is to identify the
actual entries (products at shifted arguments and conjugates) with these
sums. The **actual on-line entries** are covered directly:
`exists_tailEntryBound_onLineGram` bounds the genuine cosine Gram entries
`∑ 2πσ² exp(−σ²γₙ²) cos((a−b)γₙ)` by `2πσ²` times the Gaussian zero mass, so
the on-line part of the tail satisfies W4 with no model assumption.

**Verification note.** `run-tests.sh` was failing on
`absolute-polarized-hodge-index-realization/tests/test_rescue.py::test_gram6_certificate_recorded`
because the test opened `python/gram6_certificate.json` relative to the current
working directory. The path is now resolved from `ROOT`; the full test suite
passes from `topics/`. The Lean sweep also found
`finite-window-zeros/lean/Check.lean` referring to the removed
`List.all_eq_true_iff`; the stale `#check` was dropped, and the file rechecks
green. Both are verification hygiene, not mathematical changes. After these
fixes the sweep reports 172/172 Lean files OK, and the publication hash and
link base still match.

**weil-positivity hub (T5–T9).** Lifted the criterion to the isolated block:
`OffLineBlockPSD c σ δ γ ↔ |S(c)| ≤ S(0)`, with the negations
`not_offLineBlockPSD_iff` and `not_offLineBlockPSD_of_abs_lt`. The off-line
obstruction is therefore the scalar separation
`exists c, S(0) < |S(c)|` (`exists_abs_offLineQuad_gt_of_offLine`), rather than
an opaque matrix-negativity statement. Three further theorems package it:
`all_blocks_psd_iff_scalar` (universal block positivity is equivalent to the
scalar inequality for every parameter), `no_offLine_of_all_abs_le` (the scalar
bound for all parameters implies RH), and
`exists_abs_offLineQuad_gt_of_not_RH` (failure of RH produces the obstruction
in the exact scalar form), and `exists_abs_offLineQuad_gt_any` (the off-line
contribution is unbounded in modulus, so it beats every fixed bound). The
assembly from the three inputs is still not claimed.

**Computations.** Added C4/C3/C4/C4 tests: the inverse-square weights and their
`ε`-threshold (zero-infinitude), the polynomial majorant ratio and Gaussian
moments with the recurrence `M_{k+2} = (k+1)/(2b) M_k` (log-derivative-growth),
the tail-predicate/`FullBlockWithin` agreement and the eigenvalue/scalar
criterion agreement (zero-density-bound), and the scalar-criterion check for
the Weil block including a negative obstruction margin at a failure
(weil-positivity). All four topic suites pass (6, 6, 8, 4 tests).

**Build and indexes.** The four Lean cores build with no `sorry`/`axiom`/`admit`
(`zero-infinitude` 8 s, `log-derivative-growth` 6 s, `zero-density-bound` 5 s,
`weil-positivity` 5 s). Regenerated `topics/index.html`,
`topics/index-lean.md` + 173 per-file pages, `lean-graph.html`
(2,890 proofs, up from 2,799) and `lean-conjecture-graph.html`. `STATUS.md`
now records 58 topics, 1,297 theorems, 535 computations and 839 tests, with the
four upstream rows current and the `missing-bridge` topic added concurrently.

**Honesty.** No RH claim, no unconditional Weil positivity. The vertical
input is now complete on the library contour `(−1, 2)` (T33–T36); the remaining
handoff inputs are **infinitude** and the **W4 off-line/other-zero
bookkeeping**.

**Resume (2026-11-06, later).** The handoff was resumed after the
[missing-bridge](topics/missing-bridge/README.md) review. The arithmetic side
is now the active route. missing-bridge records the exact identity
`pole(c) = P_main(c) + P_main(−c)` and the residual form
`pole − (P_c + P_{−c}) = (P_main(c) − P_c) + (P_main(−c) − P_{−c})`, both
Lean-proved (T21–T22), identified with `Re H_c(0)`, `Re H_c(1)` and
`Re (H_c(0)+H_c(1))` (T23–T25), with the full residual `K = PNT errors + arch`
formalised as T26, the Gaussian prime window and the nonnegative truncated
prime side are T27–T28, with termwise nonnegativity and monotonicity of the
truncation as T29–T30, the window symmetry `(c,u) ↦ (−c,−u)` as T31, and the
positivity of the main and pole terms as T32–T33, and the evenness of the pole
term as T34, and the Gaussian-integral evaluation of the smooth main term as
T35–T36, the pole as the sum of the two Gaussian integrals as T37, and the
evenness of the arithmetic residual kernel as T38 and the symmetry of the
arithmetic Gram matrix as T39; the identity is checked numerically by C18. Regenerated
`topics/index.html`, `topics/index-lean.md` (58 topics, 173 Lean files, 2,912
named proofs), `lean-graph.html` and `lean-conjecture-graph.html`.
`STATUS.md`: 58 topics, 1,319 theorems, 540 computations, 844 tests. O2 remains
open and RH-equivalent.


**Full verification (2026-11-06).** `tools/verify-all.sh --quick` exits 0:
the structural audit passes for all 58 topics, all Python suites pass
(844 tests), all 173 Lean files build, the 30,129-link base has 0 broken
curated links, and the two `publication.html` copies hash identically
(`ae65d8c1…`).


**Targeted verification (2026-11-06).** The five key topics build and test
individually: log-derivative-growth (6 tests), zero-infinitude (6),
zero-density-bound (8), weil-positivity (4) and missing-bridge (24); all five
Lean cores report OK. A single combined pytest invocation collides on the
repeated `test_programme` module name, so the suites are run per directory as
`run-tests.sh` does.


**Handoff sync (2026-11-06).** The missing-bridge README now records that the
full Gram criterion (T18–T20), the residual form (T26), the Gaussian-integral
evaluation of the main term (T36–T37) and the `σ = 0.05` sign tests (C16–C17)
are done. The next concrete step is recorded as the uniform smooth-window PNT
error bound, jointly with the archimedean term.


**Full verification (2026-11-06, after T21–T39).** `tools/verify-all.sh
--quick` exits 0 again: 58/58 structural audit, all Python suites (844 tests),
all 173 Lean files build, 30,168 internal links checked with 0 broken curated
links, and the `publication.html` copies still hash identically
(`ae65d8c1…`). Counts at this checkpoint: 1,319 theorems, 540 computations,
844 tests, 2,912 named proofs.


**W4 on-line kernel symmetry (2026-11-06).** Added
`onLineGramEntry_comm`: the actual on-line Gram kernel is symmetric in the two
centres. This is T26 of zero-density-bound. Counts: 1,320 theorems, 540
computations, 844 tests; Lean index 2,913 named proofs.


**Hub block evenness (2026-11-06).** Added `offLineBlock_neg` and
`offLineBlockPSD_neg` (weil-positivity T14–T15): the isolated off-line block
and its PSD predicate are even in the separation `c`. Counts: 1,322 theorems,
540 computations, 844 tests; Lean index 2,915 named proofs.


**W4 on-line Gram matrix (2026-11-06).** Added `onLineGramMatrix` and
`onLineGramMatrix_isSymm` (zero-density-bound T27): the actual on-line Gram
matrix is symmetric. Counts: 1,323 theorems, 540 computations, 844 tests; Lean
index 2,916 named proofs.


**Infinitude route recorded (2026-11-06).** The zero-infinitude README now
spells out the finite-zero contradiction route: multiplicity-aware finite
product, entire zero-free quotient, real-axis identity
`logDeriv Z = P'/P − 1/s − 1/(s−1)`, and the boundedness of `P'/P` versus the
harvested `tendsto_logDeriv_completedZeta_re_atTop`. The Lean interfaces
needed are listed alongside it.


**Infinitude route corrected (2026-11-06).** The degree-asymptotic lemmas
`Polynomial.isLittleO_atTop_of_degree_lt` are only stated over linearly ordered
fields, so they do not apply to `ℂ`. The recorded route now uses the root
partial fraction: split `P` over `ℂ` via `Polynomial.Splits.eq_prod_roots`,
then use the analytic `logDeriv_prod` to get `P'/P = ∑ 1/(s−r)` and bound each
term for large real `s`.


**Finite zero product (2026-11-06).** Started the infinitude route: added
`finiteZeroProduct`, `differentiable_finiteZeroProduct` and
`finiteZeroProduct_ne_zero` (zero-infinitude T12–T13), the multiplicity-aware
product that replaces the simple-zero canonical product. Counts: 1,325
theorems, 540 computations, 844 tests; Lean index 2,918 named proofs.


**Finite zero product divisor (2026-11-06).** Added
`meromorphicOrderAt_finiteZeroProduct_of_mem` and
`meromorphicOrderAt_finiteZeroProduct_of_not_mem` (zero-infinitude T14–T15):
the finite zero product has order exactly the prescribed multiplicity at a
zero and order zero away from the zero set. This is the divisor-match input for
the finite-zero Hadamard step. Counts: 1,327 theorems, 540 computations, 844
tests; Lean index 2,920 named proofs.


**Off-zero-set order of ξ₀ (2026-11-06).** Added
`meromorphicOrderAt_xi₀_of_not_mem` (zero-infinitude T16): away from a finite
set containing all zeros, `ξ₀` has meromorphic order zero. Together with
T12–T15 this supplies the away-from-zeros half of the finite-zero divisor
match. Counts: 1,328 theorems, 540 computations, 844 tests; Lean index 2,921
named proofs.


**Finite analytic order of ξ₀ (2026-11-06).** Added `analyticOrderAt_xi₀_ne_top`
(zero-infinitude T17): the analytic order of `ξ₀` is finite everywhere, since
`ξ₀` is not identically zero and analytic continuation rules out a vanishing
neighbourhood. Counts: 1,329 theorems, 540 computations, 844 tests; Lean index
2,922 named proofs.


**On-zero divisor match (2026-11-06).** Added `meromorphicOrderAt_xi₀_of_mem`
(zero-infinitude T18): at a zero, the meromorphic order of `ξ₀` is its
analytic multiplicity. With T16–T17 this completes the pointwise divisor match
against the finite zero product. Counts: 1,330 theorems, 540 computations, 844
tests; Lean index 2,923 named proofs.


**Finite-zero quotient (2026-11-06).** Added
`exists_entire_zeroFree_quotient_of_finite_zeros` (zero-infinitude T19): if the
zero set is finite, `ξ₀` divided by the multiplicity-aware finite product has
an entire zero-free representative. This packages the divisor match (T12–T18)
through `exists_entire_zeroFree_quotient`. Counts: 1,331 theorems, 540
computations, 844 tests; Lean index 2,924 named proofs.


**Infinitude route progress (2026-11-06).** The zero-infinitude README now
marks step 1 (finite zero product and divisor match, T12–T18) and the quotient
existence half of step 2 (T19) as Lean-proved. The remaining steps are the
identity `ξ₀ = P·Q`, the quotient growth/affine step, and the polynomial
asymptotic contradiction.


**Factorization identity (2026-11-06).** Added `finiteZeroProduct_mul_quotient_eq`
(zero-infinitude T20): the finite zero product times the entire zero-free
quotient recovers `ξ₀`. This is the `hfac` input for the affine factorization.
Counts: 1,332 theorems, 540 computations, 844 tests; Lean index 2,925 named
proofs.


**Entire-exponent factorization (2026-11-06).** Added
`exists_entire_log_factorization_of_finite_zeros` (zero-infinitude T21): if
the zero set is finite, `ξ₀ = P · exp(g)` with `g` entire. This uses T19–T20
and `exists_differentiable_cexp_univ`. The remaining step is to show `g` is
affine (quotient growth) and then derive the real-axis contradiction. Counts:
1,333 theorems, 540 computations, 844 tests; Lean index 2,926 named proofs.


**Off-line block matrix symmetry (2026-11-06).** Added `offLineBlock_isSymm`
(weil-positivity T16): the isolated off-line block is a symmetric matrix.
Counts: 1,334 theorems, 540 computations, 844 tests; Lean index 2,927 named
proofs.


**Full verification (2026-11-06, after T1–T21 of zero-infinitude).**
`tools/verify-all.sh --quick` exits 0 again: 58/58 structural audit, all Python
suites (844 tests), all 173 Lean files build, 30,213 internal links checked
with 0 broken curated links, and the `publication.html` copies still hash
identically (`ae65d8c1…`). Counts at this checkpoint: 1,334 theorems, 540
computations, 844 tests, 2,927 named proofs.


**Handoff status for zero-infinitude (2026-11-06).** The handoff status board
now records the finite-zero progress: the finite zero product, divisor match,
entire zero-free quotient and entire-exponent factorization are Lean-proved
(zero-infinitude T12–T21); the remaining step is the affine exponent (analytic
growth) followed by the real-axis contradiction.


**Conditional affine step (2026-11-06).** Added
`exists_affine_factorization_of_finite_zeros_of_growth` (zero-infinitude T22):
if the entire exponent of the finite-zero factorization has linear real
growth, the factorization is affine. This isolates the remaining analytic
input to the growth bound on the exponent. Counts: 1,335 theorems, 540
computations, 844 tests; Lean index 2,928 named proofs.


**Max-modulus route recorded (2026-11-06).** The zero-infinitude README now
records the concrete maximum-modulus plan for the remaining exponent growth
bound: for large `R`, `‖P w‖ ≥ 1` on `|w| = R`; the maximum-modulus principle
for the zero-free `Q = exp(g)` bounds `Re g` inside the disk by
`log‖ξ₀‖` on the circle; with `R = |z| + 1` this is `O(‖z‖ log‖z‖)`, hence
`O(‖z‖^{3/2})`, and `subquadratic_eq_affine_of_re_le_rpow` makes `g` affine.


## Session summary — 2026-11-06

**Log-derivative-growth — vertical input complete.** The Gamma lower bound was
proved (`Gamma_lower_reflection`, `gammaR_lower_bound`, `gammaR_lower_bound_two`)
and both vertical sides of the explicit formula are now unconditional on the
library contour `(-1, 2)`: `exists_verticalLogDerivIntegrable_two` and
`exists_verticalLogDerivIntegrable_neg_one`.

**Missing-bridge — arithmetic side formalised.** The exact pole/main
cancellation `pole = P_main(c) + P_main(−c)` (T21), its identification with
`Re H_c(0)`, `Re H_c(1)`, `Re (H_c(0)+H_c(1))` (T23–T25), the residual
`K = PNT errors + arch` (T26), the Gaussian prime window and nonnegative
monotone truncated prime side (T27–T31), positivity of the main/pole terms
(T32–T33), pole evenness (T34), the Gaussian-integral evaluation of the smooth
main term (T35–T37), and the arithmetic kernel/matrix symmetry (T38–T39).

**Zero-infinitude — finite-zero route.** The multiplicity-aware finite product
(T12–T13), its divisor (T14–T15), the off-zero-set and on-zero orders of `ξ₀`
(T16–T18), the entire zero-free quotient (T19), the factorization identity
`ξ₀ = P·Q` (T20), the entire-exponent factorization `ξ₀ = P·exp(g)` (T21), and
the conditional affine step (T22). The remaining analytic gap is the growth
bound on `g`, with a maximum-modulus route recorded in the topic README.

**Zero-density and hub.** The actual on-line Gram entries and their kernel/matrix
symmetry (T26–T27), and the hub block symmetries (T14–T16).

**Verification.** Full `verify-all.sh --quick` passed at 1,334 theorems
(30,213 links, publication hash matching); the later additions (T22 zero-
infinitude, T16 hub) were checked per topic. `STATUS.md` stands at 1,335
theorems, 540 computations, 844 tests; the Lean index at 2,928 named proofs.


**Polynomial circle bound (2026-11-06).** Added
`exists_norm_eval_ge_one_on_sphere` (zero-infinitude T23): a nonconstant complex
polynomial is at least `1` in modulus on every sufficiently large circle. This
is the circle input for the maximum-modulus bound on the exponent. Counts:
1,336 theorems, 540 computations, 844 tests; Lean index 2,929 named proofs.


**Maximum-modulus disk bound (2026-11-06).** Added
`norm_le_of_forall_sphere_norm_le` (zero-infinitude T24): an entire function
bounded on a circle is bounded by the same constant on the closed disk. This
is the maximum-modulus step of the exponent-growth route. Counts: 1,337
theorems, 540 computations, 844 tests; Lean index 2,930 named proofs.


**Quotient disk bound (2026-11-06).** Added `norm_quotient_le_on_ball`
(zero-infinitude T25): the zero-free quotient is bounded on a disk by the `ξ₀`
growth, provided the polynomial is at least `1` on the boundary circle. This
combines T23–T24 with the factorization identity. Counts: 1,338 theorems, 540
computations, 844 tests; Lean index 2,931 named proofs.


**Subquadratic-to-affine step (2026-11-06).** Added
`exists_affine_factorization_of_finite_zeros_of_subquadratic`
(zero-infinitude T26): a subquadratic `O(‖z‖^{3/2})` bound on the entire
exponent makes the finite-zero factorization affine, via
`subquadratic_eq_affine_of_re_le_rpow`. Counts: 1,339 theorems, 540
computations, 844 tests; Lean index 2,932 named proofs.


**Logarithmic subquadratic input (2026-11-06).** Added
`log_one_add_le_two_sqrt` (zero-infinitude T27): `log(1+x) ≤ 2√(1+x)` for
`x ≥ 0`. This is the logarithmic estimate that turns the `R log R` quotient
bound into `O(‖z‖^{3/2})`. Counts: 1,340 theorems, 540 computations, 844
tests; Lean index 2,933 named proofs.


**Full verification (2026-11-06, after zero-infinitude T23–T27).**
`tools/verify-all.sh --quick` exits 0: 58/58 structural audit, all Python
suites (844 tests), all 173 Lean files build, 30,231 internal links checked
with 0 broken curated links, and the `publication.html` copies hash identically
(`ae65d8c1…`). Counts at this checkpoint: 1,340 theorems, 540 computations, 844
tests, 2,933 named proofs.


**Named subquadratic input (2026-11-06).** Added
`FiniteZeroSubquadraticBound` and
`exists_affine_factorization_of_finite_zeros_of_bound` (zero-infinitude T28):
the remaining analytic input is now named, and it is proved that this input
alone makes the finite-zero factorization affine. Counts: 1,341 theorems, 540
computations, 844 tests; Lean index 2,934 named proofs.


**Remaining infininitude inequality recorded (2026-11-06).** The zero-infinitude
README now states the last real estimate explicitly:
`max R0 (r+1) · log(max R0 (r+1) + 2) ≤ C (1+r)^{3/2}`, which follows from
T27 and yields `FiniteZeroSubquadraticBound` (T28). No Lean changes this round;
counts remain 1,341 theorems, 540 computations, 844 tests, 2,934 named proofs.


**Real-power comparison (2026-11-06).** Added `one_add_le_rpow_three_halves`
(zero-infinitude T29): `1 + r ≤ (1 + r)^{3/2}` for `r ≥ 0`, a real-power
comparison used in the final subquadratic estimate. Counts: 1,342 theorems,
540 computations, 844 tests; Lean index 2,935 named proofs.


**Final `r log r` estimate (2026-11-06).** Added `rlog_bound`
(zero-infinitude T30): for `r ≥ 0`,
`max R0 (r+1) · log(max R0 (r+1) + 2) ≤ C (1+r)^{3/2}`. This is the last real
inequality of the finite-zero growth route. Counts: 1,343 theorems, 540
computations, 844 tests; Lean index 2,936 named proofs.


**Subquadratic comparison (2026-11-06).** Added `one_add_rpow_three_halves_le`
(zero-infinitude T31): `(1+r)^{3/2} ≤ 2^{3/2}(1+r^{3/2})` for `r ≥ 0`. This
converts the `(1+r)^{3/2}` estimate into the `O(‖z‖^{3/2})` form of
`FiniteZeroSubquadraticBound`. Counts: 1,344 theorems, 540 computations, 844
tests; Lean index 2,937 named proofs.


**Subquadratic bound assembled (2026-11-06).** Added
`finiteZeroSubquadraticBound_of_quotient` (zero-infinitude T32): the quotient
disk bound (T25), the real `r log r` estimate (T30) and the subquadratic
comparison (T31) assemble into `FiniteZeroSubquadraticBound g`. The remaining
infinitude step is the real-axis contradiction. Counts: 1,345 theorems, 540
computations, 844 tests; Lean index 2,938 named proofs.


**Logarithmic derivative of the finite product (2026-11-06).** Added
`logDeriv_finiteZeroProduct` (zero-infinitude T33): away from the zero set,
`logDeriv P z = ∑_{w∈S} m_w/(z−w)`. This is the partial-fraction identity
needed to bound `P'/P` in the real-axis contradiction. Counts: 1,346 theorems,
540 computations, 844 tests; Lean index 2,939 named proofs.


**Real-axis bound on `P'/P` (2026-11-06).** Added
`exists_norm_logDeriv_finiteZeroProduct_le` (zero-infinitude T34): the
logarithmic derivative of the finite zero product is bounded along the large
real axis. This is the boundedness needed to contradict the harvested
`tendsto_logDeriv_completedZeta_re_atTop`. Counts: 1,347 theorems, 540
computations, 844 tests; Lean index 2,940 named proofs.


**Log-derivative identity for the finite factorization (2026-11-06).** Added
`logDeriv_completedRiemannZeta_eq_of_finite_factorization` (zero-infinitude
T35): under the affine finite factorization,
`logDeriv Λ x = logDeriv P x + b − 1/x − 1/(x−1)`. Counts: 1,348 theorems,
540 computations, 844 tests; Lean index 2,941 named proofs.


**Real-axis route consolidated (2026-11-06).** The zero-infinitude README now
marks T33–T35 as Lean-proved: the finite-product partial fraction, the
real-axis bound on `P'/P`, and the log-derivative identity
`logDeriv Λ x = logDeriv P x + b − 1/x − 1/(x−1)`. The handoff status board
records that only the final assembly with
`tendsto_logDeriv_completedZeta_re_atTop` remains. Counts unchanged: 1,348
theorems, 540 computations, 844 tests, 2,941 named proofs.


**Completed-zeta log-derivative transfer (2026-11-06).** Added
`logDeriv_completedZeta_eq_completedRiemannZeta` (zero-infinitude T36): on
`Re s > 1`, the log-derivatives of the two completed zeta functions agree.
This is the transfer needed to apply the finite-factorization identity to the
harvested real-axis limit. Counts: 1,349 theorems, 540 computations, 844
tests; Lean index 2,942 named proofs.


**Final assembly shape recorded (2026-11-07).** The zero-infinitude README now
spells out the last proof: choose `k` with `2k+2 ≥ max M (R+1)`, transfer
`logDeriv completedZeta` to `completedRiemannZeta` (T36), apply T35 and T34 to
bound the real part, and contradict
`tendsto_logDeriv_completedZeta_re_atTop`. No Lean changes this round; counts
remain 1,349 theorems, 540 computations, 844 tests, 2,942 named proofs.


**Real-part bound under the finite factorization (2026-11-07).** Added
`re_logDeriv_completedRiemannZeta_le` (zero-infinitude T37): under the finite
affine factorization and the T34 bound, `Re logDeriv Λ s ≤ M + Re b`. This is
the final bound needed for the real-axis contradiction. Counts: 1,350
theorems, 540 computations, 844 tests; Lean index 2,943 named proofs.


**Finite-zero contradiction proved (2026-11-07).** Added
`false_of_affine_factorization` (zero-infinitude T38): finite zeros plus the
affine factorization `ξ₀ = P·exp(a+bz)` contradict the harvested real-axis
log-derivative limit. The proof assembles T34–T37 and the index choice
`s = 2k+2`. The remaining step for infinitude is to derive the affine
factorization from finite zeros (T21 + T32 + T23 + T28). Counts: 1,351
theorems, 540 computations, 844 tests; Lean index 2,944 named proofs.


**Trivial-zero obstruction found (2026-11-07).** A critical check shows that
`ξ₀` has the explicit trivial zeros `−2(n+1)` (`completedZeta_trivial_zero`
combined with `xi₀_eq_zero_iff`). Therefore the hypothesis "the full zero set
of `ξ₀` is finite" is **false**, and the finite-zero sequence T21–T38 is
conditional on that false hypothesis: T38 is a conditional contradiction, not
a proof of infinitude. The zero-infinitude README and the handoff status board
now record the correction: to prove infinitude of the nontrivial zeros, the
route must first factor out the trivial-zero family (the Gamma factor
`1/Γ(1+s/2)`) and rerun the finite-zero argument on the remaining quotient.


**Trivial-zero obstruction retracted (2026-11-07).** The previous entry
conflated two definitions: `completedZeta_trivial_zero` is about the **junk
value** of `completedZeta` at the Gamma poles, whereas `xi₀` uses the
meromorphic `completedRiemannZeta`. The functional equation
`completedRiemannZeta_one_sub` gives `Λ(−2(n+1)) = Λ(2n+3) ≠ 0`, so those
points are **not** zeros of `ξ₀`. The finite-zero route is therefore not
obstructed by trivial zeros. The remaining task is to prove that every zero of
`ξ₀` lies in `0 < Re < 1`, so that the finite nontrivial zero set is the full
zero set; the README and handoff have been corrected accordingly.


**Every ξ₀ zero lies in the critical strip (2026-11-07).** Added
`xi₀_zero_re_pos` and `xi₀_zero_re_lt_one` (zero-infinitude T39–T40): every
zero of `ξ₀` satisfies `0 < Re < 1`. The proofs use the functional equation
and ζ nonvanishing; this resolves the trivial-zero concern and validates the
finite-zero route on the full zero set. Counts: 1,353 theorems, 540
computations, 844 tests; Lean index 2,946 named proofs.


**Finite-product circle bound (2026-11-07).** Added
`exists_finiteZeroProduct_norm_ge_one` (zero-infinitude T41): the finite zero
product is at least `1` in modulus outside a large ball. This supplies the
circle hypothesis of the subquadratic assembly without a polynomial-degree
argument. Counts: 1,354 theorems, 540 computations, 844 tests; Lean index
2,947 named proofs.


## Infinitude of the nontrivial zeros — proved (2026-11-07)

The zero-infinitude programme is complete. `infinite_nontrivialZeros` (T42)
proves

`¬ Set.Finite {z : ℂ | xi₀ z = 0 ∧ 0 < z.re}`

by assembling the finite-zero machinery:

- T39–T40: every `ξ₀` zero lies in `0 < Re < 1`;
- T12–T21: finite zeros give `ξ₀ = P · exp(g)` with `P` the multiplicity-aware
  finite product;
- T41 + T32: `FiniteZeroSubquadraticBound g`;
- T28: the exponent is affine;
- T38: finite zeros plus the affine factorization contradict
  `tendsto_logDeriv_completedZeta_re_atTop`.

Consequences: `ZeroTailSummable` follows unconditionally from T5/T8, the
nontrivial zeros are denumerable and unbounded in ordinate, and Wave 1 of the
handoff is complete. Counts: 1,355 theorems, 540 computations, 844 tests; Lean
index 2,948 named proofs.


**Zero tail unconditional (2026-11-07).** Added
`exists_enumeration_and_zeroTailSummable` (zero-infinitude T43): for every
`σ > 0`, the nontrivial zeros admit an injective enumeration with summable
inverse-square tail. This is the unconditional `ZeroTailSummable` capstone,
following from T42. Counts: 1,356 theorems, 540 computations, 844 tests; Lean
index 2,949 named proofs.


**Full verification after infinitude (2026-11-07).**
`tools/verify-all.sh --quick` exits 0 after the T39–T43 additions: 58/58
structural audit, all Python suites (844 tests), all 173 Lean files build,
30,279 internal links checked with 0 broken curated links, and the
`publication.html` copies hash identically (`ae65d8c1…`). Counts at this
checkpoint: 1,356 theorems, 540 computations, 844 tests, 2,949 named proofs.


**Single-frequency on-line PSD (2026-11-07).** Added
`onLineGramMatrix_single_posSemidef` (zero-density-bound T28): the
single-frequency on-line Gram matrix `w * cos((a_i − a_j)γ)` is positive
semidefinite for `w ≥ 0`, as a sum of two rank-one PSD matrices. Counts: 1,357
theorems, 540 computations, 844 tests; Lean index 2,950 named proofs.


**Finite on-line PSD sum (2026-11-07).** Added
`onLineGramMatrix_finset_posSemidef` (zero-density-bound T29): a finite
weighted sum of single-frequency on-line Gram matrices is positive
semidefinite. This is the PSD statement for a truncated on-line Gram matrix.
Counts: 1,358 theorems, 540 computations, 844 tests; Lean index 2,951 named
proofs.


**On-line weight positivity (2026-11-07).** Added `onLineWeight_nonneg`
(zero-density-bound T30): the on-line Gaussian weights are nonnegative, the
last elementary W4 ingredient for the full on-line PSD sum. Counts: 1,359
theorems, 540 computations, 844 tests; Lean index 2,952 named proofs.


**Final verification and handoff consolidation (2026-11-07).**
`tools/verify-all.sh --quick` exits 0 again after the zero-density T28–T30
additions: 58/58 structural audit, all Python suites, all 173 Lean files,
30,288 internal links (0 broken curated), and matching `publication.html`
hashes (`ae65d8c1…`).  The handoff summary now records Wave 1 as complete with
zero-infinitude done and the remaining inputs as the full W4 bookkeeping
(`Z'/Z` and `Z` lower bound), the off-line block, and the arithmetic PNT
estimate.  Counts: 1,359 theorems, 540 computations, 844 tests, 2,952 named
proofs.


**Status polish (2026-11-07).** The topics index rows 53 and 55 now record
zero-infinitude as **done** (T42/T43) and the on-line W4 progress as
single-frequency PSD, finite weighted sums, and nonnegative weights, with the
full on-line `tsum` PSD and off-line bookkeeping still open. No theorem-count
changes this round.


**Finite-truncation on-line PSD documented (2026-11-07).** The zero-density
README now records that T28–T30 give PSD for every **finite** weighted sum of
on-line frequencies, which is exactly what the finite-`N` explicit formula
uses; the countable `tsum` limit is needed only for the limiting statement.
No theorem-count changes.


## Session close-out (2026-11-07)

**Completed since round 72.** Zero-infinitude is **done**: the finite-zero
machinery (T12–T38), the critical-strip property (T39–T40), the finite-product
circle bound (T41) and the infinitude theorem (T42) are Lean-proved, and the
zero tail is unconditional (T43). On the W4 side, the on-line Gram matrix is
now PSD for every finite weighted frequency sum (T28–T29) with nonnegative
weights (T30). Full verification passes (`verify-all --quick`, exit 0).

**Still open.** The countable on-line `tsum` PSD, the off-line/other-zero
bookkeeping, and the arithmetic-side PNT estimate. O2 remains open and
RH-equivalent; no unconditional positivity is claimed.


**Final handoff correction (2026-11-07).** The handoff risks section no longer
lists infinitude as missing; it records T42/T43 as proved and names the
off-line/other-zero bookkeeping and the countable on-line `tsum` PSD as the
remaining zero-set risks. Final audit passes 58/58 and the link check has 0
broken curated links.


**Countable on-line PSD plan recorded (2026-11-07).** The zero-density README
now states the remaining `tsum` proof explicitly: prove
`x ⬝ (M_tsum *ᵥ x) = ∑' n, x ⬝ (M_n *ᵥ x)` by `Summable.tsum_finsetSum`
over the finite index set, then apply T28 termwise and `tsum_nonneg`; the
required summability is entrywise summability of the Gaussian-weighted cosine
series.  Goal resumed with no fixed round limit.  No theorem-count changes.


**Finite on-line quadratic form nonnegative (2026-11-07).** Added
`onLineGramMatrix_finset_quadraticForm_nonneg` (zero-density-bound T31): the
quadratic form of a finite weighted on-line Gram matrix is nonnegative for
every real test vector. This is the downstream form used by the block
assembly. Counts: 1,360 theorems, 540 computations, 844 tests; Lean index
2,953 named proofs.


**On-line quadratic-form numerical companion (2026-11-07).** Added
`online_gram_quadratic_form` to the zero-density Python layer and a pytest
checking nonnegativity for several test vectors, the numerical counterpart of
T31. Counts: 1,360 theorems, 541 computations, 845 tests; Lean index 2,953
named proofs.


## Countable on-line PSD — proved (2026-11-07)

Added `posSemidef_tsum` (T32) and `onLineGramMatrix_posSemidef` (T33): a
pointwise `tsum` of positive semidefinite matrices is PSD given entrywise
summability, and the **actual on-line Gram matrix** is PSD. The proof
distributes the finite sums over the `tsum` via `Summable.tsum_finsetSum`,
applies T28 termwise and concludes with `tsum_nonneg`. The only remaining
hypothesis is entrywise summability of the Gaussian-weighted cosine series,
which follows from the Gaussian decay of the zero weights. Counts: 1,362
theorems, 541 computations, 845 tests; Lean index 2,955 named proofs.


**On-line PSD from Gaussian summability (2026-11-07).** Added
`onLineGramMatrix_posSemidef_of_exp_summable` (zero-density-bound T34): the
actual on-line Gram matrix is PSD whenever `∑ exp(−σ²γₙ²)` converges. The
proof bounds the norm of each term by the weight (`|cos| ≤ 1`) and uses
`Summable.of_norm_bounded`, discharging T33's entrywise summability
hypothesis. Counts: 1,363 theorems, 541 computations, 845 tests; Lean index
2,956 named proofs.


**Hub W4 status updated (2026-11-07).** The Weil-positivity hub README now
records that the on-line PSD side is proved locally in zero-density-bound
(T28, T29, T32, T33, T34), and that the remaining W4 input is the
off-line/other-zero bookkeeping. No theorem-count changes.


**Full verification after on-line PSD (2026-11-07).**
`tools/verify-all.sh --quick` exits 0 after T32–T34: 58/58 structural audit,
all Python suites (845 tests), all 173 Lean files, 30,301 internal links with
0 broken curated links, and matching `publication.html` hashes. The handoff
zero-density rows now record the on-line PSD chain T28–T34 as proved, with the
off-line/other-zero bookkeeping as the remaining W4 input. Counts: 1,363
theorems, 541 computations, 845 tests, 2,956 named proofs.


**Isolated off-line block criterion (2026-11-07).** Added
`offLineBlockPSD_iff_abs_le` (weil-positivity T17): the isolated off-line
block is PSD exactly when `|Re S(c)| ≤ Re S(0)`. This is the direct
block-level form of the scalar criterion, a bookkeeping lemma for the
off-line/other-zero analysis. Counts: 1,364 theorems, 541 computations, 845
tests; Lean index 2,957 named proofs.


**Off-line block eventually fails PSD (2026-11-07).** Added
`exists_offLineBlock_not_psd` (weil-positivity T18): for `σ > 0` and `δ ≠ 0`,
some separation `c` makes the isolated off-line block fail PSD. This is the
block-level form of the unbounded off-line obstruction (T13) via T17. Counts:
1,365 theorems, 541 computations, 845 tests; Lean index 2,958 named proofs.


**Bounded tail cannot rescue an off-line block (2026-11-07).** Added
`TailEntryBound`, `not_posSemidef_add_of_abs_gt` (T19) and
`exists_offLineBlock_add_tail_not_psd` (T20) in weil-positivity: if the
tail entries are bounded by `B` and `a + 4B < |b|`, then the perturbed 2×2
diagonal block is not PSD; and for any bounded tail some separation `c`
makes `OffLineBlock c σ δ γ + E` non-PSD. This is the core off-line/other-zero
bookkeeping lemma. Counts: 1,367 theorems, 541 computations, 845 tests; Lean
index 2,960 named proofs.


**Finite Gaussian model tail (2026-11-07).** Added `gaussianTailEntry`,
`gaussianTailBound`, `abs_gaussianTailEntry_le` (T21) and
`exists_offLineBlock_add_modelTail_not_psd` (T22) in weil-positivity: a finite
Gaussian model tail is entrywise bounded by its total mass, and such a tail
cannot rescue an off-line block. This is the model-level off-line/other-zero
bookkeeping. Counts: 1,369 theorems, 541 computations, 845 tests; Lean index
2,962 named proofs.


**Full verification after T17–T22 (2026-11-07).**
`tools/verify-all.sh --quick` exits 0: 58/58 structural audit, all Python
suites (845 tests), all 173 Lean files, 30,319 internal links with 0 broken
curated links, and matching `publication.html` hashes. The topics index row 56
now records the isolated block criterion, eventual off-line failure, bounded
tail and finite Gaussian model tail as Lean-proved. Counts: 1,369 theorems,
541 computations, 845 tests, 2,962 named proofs.


**Model tail mass monotonicity (2026-11-07).** Added `gaussianTailBound_nonneg`
(T23) and `gaussianTailBound_mono` (T24) in weil-positivity: the Gaussian
model tail mass is nonnegative and monotone under enlarging the zero set.
These are the bookkeeping lemmas for passing from a finite model tail to the
full other-zero tail. Counts: 1,371 theorems, 541 computations, 845 tests;
Lean index 2,964 named proofs.


**On-line PSD under the named zero-tail input (2026-11-07).** Added
`onLineGramMatrix_posSemidef_of_zeroTailSummable` (zero-density-bound T35):
the actual on-line Gram matrix is PSD under `ZeroTailSummable`, the named
zero-tail input. Since zero-infinitude T43 now proves `ZeroTailSummable`
unconditionally for the nontrivial-zero enumeration, T35 supplies the on-line
PSD without a summability side condition in that setting. Counts: 1,372
theorems, 541 computations, 845 tests; Lean index 2,965 named proofs.


**Handoff status refreshed (2026-11-07).** The handoff summary now records the
on-line PSD chain (zero-density T28–T35) and the bounded-tail/finite-model-tail
bookkeeping (weil-positivity T19–T24) as proved, with the remaining inputs the
explicit-formula tail identification, the off-line `Z` lower bound, and the
arithmetic PNT estimate. No theorem-count changes.


**Verification and log-derivative status correction (2026-11-07).**
`tools/verify-all.sh --quick` exits 0 (58/58 audit, all Python suites, 173
Lean files, 30,328 internal links, 0 broken curated, matching publication
hashes). The handoff row for log-derivative-growth now records that
`GammaRLowerBound` is **proved** (`gammaR_lower_bound`), so both vertical
lines are unconditional. Counts: 1,372 theorems, 541 computations, 845 tests,
2,965 named proofs.


**Status-board accuracy pass (2026-11-07).** The handoff status board now
records the full current state: zero-infinitude done with T42/T43, the
zero-density on-line PSD chain T28–T35, and the weil-positivity block/tail
results T17–T24. No theorem-count changes; audit 58/58 and 0 broken curated
links.


**5a theorem lists refreshed (2026-11-07).** The handoff progress table now
lists the zero-density on-line PSD chain (T28–T35) and the weil-positivity
block/tail results (T17–T24). No theorem-count changes.


## Current state (2026-11-07, round 118)

**Proved and unconditional.**
- Zero-infinitude: infinitude of the nontrivial zeros (T42) and the zero-tail
  enumeration (T43).
- Log-derivative-growth: both vertical lines, including the Gamma lower bound
  (`gammaR_lower_bound`).
- On-line W4: single-frequency PSD, finite sums, pointwise-`tsum` PSD, the
  actual on-line Gram matrix, and its PSD under `ZeroTailSummable`
  (zero-density T28–T35).
- Off-line block: exact scalar criterion (T17), eventual failure (T18),
  bounded-tail bookkeeping (T19–T20), finite Gaussian model tail (T21–T22),
  tail-mass monotonicity (T23–T24).

**Still open.**
- Identify the actual explicit-formula other-zero tail with the Gaussian model
  tail of T21–T22.
- The arithmetic-side uniform smooth-window PNT error plus archimedean bound.

O2 remains open and RH-equivalent; no unconditional positivity is claimed.


**Gaussian summability for the actual enumeration (2026-11-07).** Added
`exists_enumeration_and_gaussian_summable` (zero-infinitude T44): the T43
enumeration also makes `∑ exp(−σ²·im(aₙ)²)` summable, which is exactly the
`ZeroTailSummable` input consumed by the on-line PSD result (zero-density
T35). Counts: 1,373 theorems, 541 computations, 845 tests; Lean index 2,966
named proofs.


**Lean build sweep (2026-11-07).** `check-all-lean.sh --quick` passes: all
**173/173** Lean files build after T44. The hub C1 row now notes that the
on-line PSD is also Lean-proved (zero-density T28–T35), not only the Python
computation. Audit 58/58 and 0 broken curated links; counts unchanged at
1,373 theorems, 541 computations, 845 tests, 2,966 named proofs.


**Perturbed off-line block numerical companion (2026-11-07).** Added
`perturbed_block_psd` to the weil-positivity Python layer and a pytest for the
T19 margin: once `a + 4B < |b|`, the worst-case perturbed diagonal block fails
PSD. Counts: 1,373 theorems, 542 computations, 846 tests; Lean index 2,966
named proofs.


**Actual on-line quadratic form nonnegative (2026-11-07).** Added
`onLineGramMatrix_quadraticForm_nonneg` (zero-density-bound T36): under
`ZeroTailSummable`, the quadratic form of the actual on-line Gram matrix is
nonnegative for every real test vector. This is the form consumed by the
full-block assembly. Counts: 1,374 theorems, 542 computations, 846 tests;
Lean index 2,967 named proofs.


**Maximal-distance-zero precondition under RH (2026-11-07).** Added
`MaximalDistanceZero` and `maximalDistanceZero_of_riemannHypothesis` (T45) in
zero-infinitude: under RH every nontrivial zero has real part `1/2`, so any
zero (which exists by T42/T43) is a maximal-distance zero. This formalises the
handoff's full-block precondition as a named object and shows it is implied by
RH. Counts: 1,375 theorems, 542 computations, 846 tests; Lean index 2,968 named
proofs.


**Verification and maximal-distance risk (2026-11-07).**
`tools/verify-all.sh --quick` exits 0 (58/58 audit, all Python suites, 173
Lean files, 30,338 internal links, 0 broken curated, matching publication
hashes). The handoff risk section now names `MaximalDistanceZero` explicitly
and records T45 (RH implies the precondition). Counts: 1,375 theorems, 542
computations, 846 tests, 2,968 named proofs.


**On-line maximal witness gives RH (2026-11-07).** Added
`riemannHypothesis_of_maximalDistanceZero_witness_onLine` (T46): if the
maximal-distance zero has real part `1/2`, every nontrivial zero is on the
critical line, i.e. RH follows. Together with T45 this makes the full-block
precondition an RH-equivalent interface. Counts: 1,376 theorems, 542
computations, 846 tests; Lean index 2,969 named proofs.


**RH iff an on-line maximal witness exists (2026-11-07).** Added
`riemannHypothesis_iff_exists_onLine_maximalDistanceZero` (T47): RH is
equivalent to the existence of a nontrivial zero on the critical line whose
distance from the line bounds every other zero's distance. This closes the
full-block precondition into an exact RH-equivalent interface, building on
T45 (RH ⇒ precondition) and T46 (on-line witness ⇒ RH). Counts: 1,377
theorems, 542 computations, 846 tests; Lean index 2,970 named proofs.


**Maximal-distance precondition recorded as RH-equivalent in the handoff
(2026-11-07).** The handoff risk section and hub status row now state that the
full-block route's maximal-`|δ|` precondition is RH-equivalent (zero-infinitude
T45–T47) and therefore cannot be assumed as an independent input without
circularity. No theorem-count changes.


**Finite weighted cosine bound (2026-11-07).** Added `abs_sum_mul_cos_le`
(weil-positivity T25): a finite weighted cosine sum is bounded by the total
weight. The corresponding `tsum` version was attempted but repeatedly timed out
in elaboration, so the finite form is recorded; it is the form used by the
finite-truncation tail bookkeeping. Counts: 1,378 theorems, 542 computations,
846 tests; Lean index 2,971 named proofs.


**`tsum` weighted cosine bound (2026-11-07).** Added `abs_tsum_mul_cos_le`
(weil-positivity T26): a summable weighted cosine series is bounded by the
total weight. The earlier timeout was bypassed by proving the triangle
inequality from `Summable.tsum_le_tsum` on `f` and `-f` instead of using
`norm_tsum_le_tsum_norm`. Counts: 1,379 theorems, 542 computations, 846 tests;
Lean index 2,972 named proofs.


**Actual Gaussian tail bound (2026-11-07).** Added `actualGaussianTailEntry`
and `abs_actualGaussianTailEntry_le` (weil-positivity T27): under
`ZeroTailSummable`, the actual Gaussian–cosine tail entry is bounded by the
total Gaussian mass `2πσ² ∑ exp(−σ²γₙ²)`. This is the infinite-sum form that
connects the actual tail to the T19/T20 bookkeeping. Also repaired a duplicated
`namespace WeilPositivity` introduced earlier, so T21–T27 now sit at
`WeilPositivity.*` rather than a nested namespace. Counts: 1,380 theorems, 542
computations, 846 tests; Lean index 2,973 named proofs.


**Actual tail cannot rescue an off-line block (2026-11-07).** Added `actualTail`
and `exists_offLineBlock_add_actualTail_not_psd` (weil-positivity T28): for
`σ > 0`, `δ ≠ 0` and any `ZeroTailSummable` ordinate sequence, some separation
`c` makes `OffLineBlock c σ δ γ₀ + actualTail` non-PSD. This instantiates the
bounded-tail criterion T20 with the actual Gaussian tail bound T27. Counts:
1,381 theorems, 542 computations, 846 tests; Lean index 2,974 named proofs.


**Explicit full-block margin (2026-11-07).** Added
`not_posSemidef_fullBlock_of_margin` (weil-positivity T29): if the off-line
obstruction `Re S(c)` exceeds `Re S(0) + 4B` with `B = 2πσ²∑exp(−σ²γₙ²)`, then
`OffLineBlock + actualTail` is not PSD. This is the explicit-margin form of
the full-block bookkeeping, combining T19 and T27. Counts: 1,382 theorems, 542
computations, 846 tests; Lean index 2,975 named proofs.


**Full-block decomposition interface (2026-11-07).** Added `fullBlock`,
`exists_fullBlock_not_psd` and `not_posSemidef_of_eq_fullBlock`
(weil-positivity T30): any block decomposing as `OffLineBlock + actualTail`
fails PSD for some separation. This names the interface the explicit formula
would supply. Counts: 1,383 theorems, 542 computations, 846 tests; Lean index
2,977 named proofs.


**Placeholder audit (2026-11-07).** A strict scan of all 173 Lean files finds
**zero** real `sorry`, `admit` or `axiom` declarations; the earlier grep hits
are comments/documentation. No build artifacts are untracked. Counts unchanged
at 1,383 theorems, 542 computations, 846 tests, 2,977 named proofs.


**Handoff decomposition interface recorded (2026-11-07).** The handoff now
states the remaining explicit-formula task precisely: supply
`Full = fullBlock` (the T30 decomposition interface). The 5a list includes the
new T25–T30 lemmas. No theorem-count changes.


**Finite zero-side decomposition (2026-11-07).** Added `zeroSideSum` and
`zeroSideSum_eq_isolated_add_tail` (weil-positivity T31): the finite zero-side
sum splits exactly into an isolated part and its complement. This is the
model-level form of the explicit-formula decomposition. Counts: 1,384
theorems, 542 computations, 846 tests; Lean index 2,978 named proofs.


**Full verification through T31 (2026-11-07).** `tools/verify-all.sh --quick`
exits 0: 58/58 audit, all Python suites (846 tests), all 173 Lean files,
30,368 internal links with 0 broken curated links, and matching
`publication.html` hashes. Counts: 1,384 theorems, 542 computations, 846
tests, 2,978 named proofs.


**Multiset quadruple identity (2026-11-07).** Added `offLineQuadruple`,
`zeroSideSumM`, `zeroSideSumM_add` and `zeroSideSumM_offLineQuadruple`
(weil-positivity T32): the multiset zero-side sum of the off-line quadruple is
exactly `offLineQuad`, and it splits additively. This is the exact isolated-part
identification for the explicit-formula decomposition. Counts: 1,385 theorems,
542 computations, 846 tests; Lean index 2,980 named proofs.


**T32 recorded in the handoff (2026-11-07).** The 5a list now includes the
multiset quadruple identity and additive split (T32). Audit 58/58, weil build
OK, link check clean; counts unchanged at 1,385 theorems, 542 computations,
846 tests, 2,980 named proofs.


**2×2 block decomposition (2026-11-07).** Added `zeroSideBlockM`,
`zeroSideBlockM_add` and `zeroSideBlockM_offLineQuadruple` (weil-positivity
T33): the 2×2 block of a multiset zero-side sum splits additively, and the
quadruple block at positions `(0, c)` is exactly `OffLineBlock c σ δ γ`. This
gives the exact block-level decomposition `Full = OffLineBlock + tailBlock`.
Counts: 1,386 theorems, 542 computations, 846 tests; Lean index 2,982 named
proofs.


**Multiset full-block failure (2026-11-07).** Added
`exists_multiset_fullBlock_not_psd` (weil-positivity T34): if the
remaining-zero block is uniformly bounded by `B` at every separation, the
decomposed multiset full block fails PSD. This composes the T33 block
decomposition with the T19 perturbation margin. Counts: 1,387 theorems, 542
computations, 846 tests; Lean index 2,983 named proofs.


**Block decomposition recorded; on-line specialization deferred (2026-11-07).**
The handoff 5a list now includes the T33/T34 block decomposition and
multiset full-block failure. An attempt to prove the on-line specialization
`(gaussianZeroTest c σ (1/2+iγ)).re = 2πσ² exp(−σ²γ²) cos(cγ)` was made, but
the complex-exponential plumbing was not completed; the elementary identity is
recorded as the next concrete step. Counts unchanged at 1,387 theorems, 542
computations, 846 tests, 2,983 named proofs.


**On-line specialization of the Gaussian test (2026-11-07).** Added
`exp_add_real_mul_I` and `gaussianZeroTest_onLine_re` (weil-positivity T35):
on the critical line, `Re gaussianZeroTest c σ (1/2+iγ)` equals the Gaussian
tail weight `2πσ² e^{−σ²γ²} cos(cγ)`. This bridges the library's explicit-formula
test function to the Gaussian tail entries used in T27/T28. Counts: 1,388
theorems, 542 computations, 846 tests; Lean index 2,985 named proofs.


**On-line imaginary part (2026-11-07).** Added `gaussianZeroTest_onLine_im`
(weil-positivity T36): on the critical line,
`Im gaussianZeroTest c σ (1/2+iγ) = −2πσ² e^{−σ²γ²} sin(cγ)`. Together with
T35 this fully identifies the on-line test function with the Gaussian cosine
and sine modes. Counts: 1,389 theorems, 542 computations, 846 tests; Lean
index 2,986 named proofs.


**On-line multiset sum (2026-11-07).** Added `onLineOrds` and
`zeroSideSumM_onLineOrds` (weil-positivity T37): the multiset zero-side sum
over the on-line ordinates has real part equal to the finite Gaussian cosine
sum. This identifies the multiset tail with the Gaussian tail entries.
Counts: 1,390 theorems, 542 computations, 846 tests; Lean index 2,987 named
proofs.


**On-line multiset tail bound (2026-11-07).** Added
`abs_zeroSideBlockM_onLineOrds_le` (weil-positivity T38): the on-line multiset
tail block is entrywise bounded by the finite Gaussian tail mass `∑_{n<N} 2πσ²
e^{−σ²γs(n)²}`. This supplies the concrete `B` for T34 with
`t = onLineOrds γs N`. Counts: 1,391 theorems, 542 computations, 846 tests;
Lean index 2,988 named proofs.


**Finite on-line tail plus off-line quadruple fails PSD (2026-11-07).** Added
`exists_onLineMultiset_fullBlock_not_psd` (weil-positivity T39): for any finite
on-line ordinate multiset and any off-line quadruple, the decomposed full block
fails PSD for some separation. This composes T34 (multiset full-block failure)
with T38 (the concrete finite tail bound). Counts: 1,392 theorems, 542
computations, 846 tests; Lean index 2,989 named proofs.


**Full verification through T39 (2026-11-07).** `tools/verify-all.sh --quick`
exits 0: 58/58 audit, all Python suites (846 tests), all 173 Lean files,
30,401 internal links with 0 broken curated links, and matching
`publication.html` hashes. The handoff records the finite-tail capstone T39 and
names the explicit-formula identification as the remaining zero-side step.
Counts: 1,392 theorems, 542 computations, 846 tests, 2,989 named proofs.


**Explicit-formula entry point recorded (2026-11-07).** The handoff now names
the available library theorem `test_function_explicit_formula` (contour-integral
form) as the starting point for the remaining explicit-formula identification.
No theorem-count changes.


## Round 150 milestone — state of the reconstruction

**Zero-side programme.**
- Zero-infinitude is **done**: infinitude (T42), unconditional zero tail (T43),
  and Gaussian summability (T44).
- Log-derivative-growth is **done** on both vertical lines, including the Gamma
  lower bound.
- On-line W4 is **proved**: single-frequency PSD, finite sums, pointwise
  `tsum`, the actual on-line Gram matrix, its `ZeroTailSummable` form, and the
  actual quadratic form (zero-density T28–T36).
- Off-line block and tail bookkeeping are **proved**: exact criterion (T17),
  eventual failure (T18), bounded-tail criterion (T19–T20), finite and actual
  Gaussian tails (T21–T28), explicit full-block margin (T29), decomposition
  interface (T30), multiset decomposition (T31–T33), multiset full-block
  failure (T34), on-line specialization (T35–T36), on-line multiset sum and
  bound (T37–T38), and the finite-tail capstone (T39).
- The maximal-distance precondition is an **RH-equivalent interface**
  (zero-infinitude T45–T47).

**Remaining.**
- Identify the actual explicit-formula zero multiset, starting from the
  library's `test_function_explicit_formula`.
- The arithmetic-side uniform smooth-window PNT error plus archimedean bound.

Counts at this milestone: **1,392 theorems · 542 computations · 846 tests ·
2,989 named proofs**; 58/58 structural audit and 0 broken curated links. O2
remains open and RH-equivalent.


**Prime-window total mass (2026-11-07).** Added `integral_primeWindow`
(missing-bridge T40): the Gaussian prime window `h_c(u)` has total integral
`2πσ²`, independent of the centre `c`. The proof uses translation invariance
and `integral_gaussian`. This is a concrete arithmetic-side mass identity for
the PNT estimate. Counts: 1,393 theorems, 542 computations, 846 tests; Lean
index 2,990 named proofs.


**Crude prime-side bound (2026-11-07).** Added
`gaussianPrimeSide_le_mul_sum_vonMangoldt` (missing-bridge T41): the Gaussian
prime side is at most `√π σ` times the total von Mangoldt mass of the
truncation. This is a first quantitative interface for the arithmetic PNT
estimate. Counts: 1,394 theorems, 542 computations, 846 tests; Lean index
2,991 named proofs.


**Prime-side `log N!` bound (2026-11-07).** Added
`gaussianPrimeSide_le_mul_log_factorial` (missing-bridge T42): the Gaussian
prime side is at most `√π σ · log(N!)`. This uses `vonMangoldt_le_log` and
`sum_log_add_one_eq_log_factorial`, giving the trivial-PNT-scale bound.
Counts: 1,395 theorems, 542 computations, 846 tests; Lean index 2,992 named
proofs.


**Prime-side mass bound numerical companion (2026-11-07).** Added
`prime_side_mass_bound` to the missing-bridge Python layer and a pytest
checking `prime_side ≤ √π σ ∑ Λ` (the T41 bound) numerically. Counts: 1,395
theorems, 543 computations, 847 tests; Lean index 2,992 named proofs.


**Full verification through T42 (2026-11-07).** `tools/verify-all.sh --quick`
exits 0: 58/58 audit, all Python suites (847 tests), all 173 Lean files,
30,410 internal links with 0 broken curated links, and matching
`publication.html` hashes. The handoff programme row records the first
arithmetic estimates T40–T42. Counts: 1,395 theorems, 543 computations, 847
tests, 2,992 named proofs.


**Arithmetic-residual error interface (2026-11-07).** Added
`arithmeticResidual_abs_le` (missing-bridge T43): if the two PNT errors are
bounded by `E₁, E₂` and the archimedean term by `A`, the arithmetic residual is
bounded by `E₁ + E₂ + A`. This packages the PNT/archimedean target into a single
quantitative interface. Counts: 1,396 theorems, 543 computations, 847 tests;
Lean index 2,993 named proofs.


**Named smooth-window PNT input (2026-11-07).** Added `SmoothWindowPNTError`
and `arithmeticResidual_abs_le_of_pnt` (missing-bridge T44): under a uniform
bound `E` on the smooth-window PNT error and `A` on the archimedean term, the
arithmetic residual is bounded by `2E + A`. A check of Mathlib shows only
Chebyshev-type `ψ` bounds are available, not the PNT itself, so this input
cannot yet be discharged from the library. Counts: 1,397 theorems, 543
computations, 847 tests; Lean index 2,994 named proofs.


**On-line norm and summability (2026-11-07).** Added
`norm_gaussianZeroTest_onLine` (T40) and `summable_gaussianZeroTest_onLine`
(T41) in weil-positivity: on the critical line the norm is exactly the Gaussian
weight `2πσ² e^{−σ²γ²}`, so the on-line `gaussianZeroTest` sequence is summable
under `ZeroTailSummable`. This supplies the zero-sum convergence needed by the
explicit-formula assembly. Counts: 1,399 theorems, 543 computations, 847 tests;
Lean index 2,996 named proofs.


**Partial-sum convergence for the explicit formula (2026-11-07).** Added
`tendsto_sum_gaussianZeroTest_onLine` (weil-positivity T42): the partial sums
of the on-line `gaussianZeroTest` converge to the `tsum` under
`ZeroTailSummable`. This is exactly the `hsum` ingredient of the library's
`explicit_formula_gaussianZeroTest_arch_prime` assembly. Counts: 1,400
theorems, 543 computations, 847 tests; Lean index 2,997 named proofs.


**Explicit-formula wiring status (2026-11-07).** The handoff now records that
the `hsum` hypothesis of `explicit_formula_gaussianZeroTest_arch_prime` is
available from T40–T42 (on-line norm, summability and partial-sum limit). The
remaining formal step is the mechanical wiring of the enumeration into that
theorem. No theorem-count changes.


**The `hsum` hypothesis proved (2026-11-07).** Added
`tendsto_image_range_gaussianZeroTest` and `tendsto_sum_image_range_sub`
(weil-positivity T43): the image of the first `⌊T⌋₊` ordinates converges to the
zero-side `tsum`, with or without the pole terms. This is exactly the `hsum`
hypothesis of `explicit_formula_gaussianZeroTest_arch_prime`, so the
explicit-formula assembly can now be instantiated with the zero enumeration.
Counts: 1,401 theorems, 543 computations, 847 tests; Lean index 2,999 named
proofs.


**T43 recorded; instantiation deferred (2026-11-07).** The handoff 5a list now
includes `tendsto_image_range_gaussianZeroTest` and
`tendsto_sum_image_range_sub`. An attempt to instantiate
`explicit_formula_gaussianZeroTest_arch_prime` with this `hsum` hit a
definitional mismatch in the contour-integral hypotheses (the rectangle/interval
elaboration), so the wiring is deferred to a focused session. Counts unchanged
at 1,401 theorems, 543 computations, 847 tests, 2,999 named proofs.


**3,000 named proofs; total on-line norm mass (2026-11-07).** Added
`tsum_norm_gaussianZeroTest_onLine` (weil-positivity T44): the total on-line
norm mass is `2πσ²` times the Gaussian zero mass. This is a small mass identity
completing the on-line norm chain. The Lean index now records **3,000 named
proofs**. Counts: 1,402 theorems, 543 computations, 847 tests.


**Full verification at 3,000 proofs (2026-11-07).**
`tools/verify-all.sh --quick` exits 0 with the Lean index at **3,000 named
proofs**: 58/58 audit, all Python suites (847 tests), all 173 Lean files,
30,434 internal links with 0 broken curated links, and matching
`publication.html` hashes. Counts: 1,402 theorems, 543 computations, 847 tests.


**Ledger-count consistency fix (2026-11-07).** A column-sum check found the
STATUS header one theorem below the sum of the per-topic ledger counts. The
header is corrected from 1,402 to **1,403 ledger theorems**; the sum now matches
exactly. (The computations/tests header totals are tracked separately and were
already not simple row sums at HEAD.) Lean index remains 3,000 named proofs.


**Explicit-formula instantiation diagnosis (2026-11-07).** A second attempt to
instantiate `explicit_formula_gaussianZeroTest_arch_prime` with the T43 `hsum`
fails at the `hbottom` hypothesis even though the two printed types are
identical; a standalone `example` assigning the same hypothesis to the printed
type elaborates successfully, so the obstruction is a hidden
instance/universe mismatch in the assembled application rather than a
mathematical gap. The `hsum` itself remains proved (T43); the mechanical
wiring is recorded as an open engineering task. Counts unchanged at 1,403
theorems, 543 computations, 847 tests, 3,000 named proofs.


**Explicit-formula wiring: `simpa` resolves the hypotheses (2026-11-07).** Using
`(by simpa using hbottom)` (and similarly for the other contour hypotheses)
makes the four limit hypotheses typecheck; the remaining mismatch is in the
**conclusion**, where the theorem produces `Complex.I` and the goal displays
`I` with apparently different instance arguments, and `simpa` does not close
it. The wiring is therefore very close but blocked on a constant/instance
printing artefact. Counts unchanged at 1,403 theorems, 543 computations, 847
tests, 3,000 named proofs.


## Gaussian explicit formula from the zero enumeration (2026-11-07)

Added `explicit_formula_gaussianZeroTest_of_enumeration` (weil-positivity T45):
the Gaussian explicit formula, instantiated with the zero enumeration and the
T43 `hsum`. The theorem states

`((∑'_n gaussianZeroTest c σ (1/2+iγₙ)) − g₀ − g₁) · 2πi = i·(−ArchR − PrimeR) − i·(ArchL + PrimeL)`

conditional on the contour/rectangle-integral and four limit hypotheses. The
final obstacle was a missing `open Complex`, which had made `I` an auto-bound
variable rather than `Complex.I`.

This is the zero-side explicit-formula identification at the formal level; the
remaining inputs are the contour/limit data and the arithmetic (PNT and
archimedean) evaluation. Counts: 1,404 theorems, 543 computations, 847 tests;
Lean index 3,001 named proofs.


**Handoff updated after T45 (2026-11-07).** The zero-density row now records
the explicit-formula instantiation (T45) and names the remaining inputs: the
contour/limit data (`hcontour`, `hbottom`, `htop`, `hright`, `hleft`) and the
arithmetic PNT/archimedean evaluation. No theorem-count changes.


**Bottom-line decay target (2026-11-07).** An attempt to prove the exact
bottom-line norm
`‖gaussianZeroTest c σ (x−iT)‖ = 2πσ² e^{σ²((x−1/2)²−T²)} e^{−c(x−1/2)}`
was made; the complex-square `.re` expansion was not completed, so the scratch
was removed. The identity is recorded as the concrete next step for the
`hbottom`/`htop` vanishing estimates in T45. No theorem-count changes.


**Contour-data status (2026-11-07).** The bottom-line Gaussian norm requires the
complex square identity
`((x−iT)−1/2)² = ((x−1/2)²−T²) + (−2(x−1/2)T)i`; the `re`/`im` expansion was
again not completed (the `simp`/`ring_nf` steps did not normalise the complex
numeral `1/2`). The target identity remains recorded as the next concrete step
for `hbottom`/`htop`. No theorem-count changes.


**Bottom-line square identity (2026-11-07).** Added `bottomLine_sq`
(weil-positivity T46): `((x−iT)−1/2)² = ((x−1/2)²−T²) + (−2(x−1/2)T)i`, the
algebraic identity behind the bottom-line Gaussian decay. The proof uses
`ring_nf` followed by `Complex.I_sq`. Counts: 1,405 theorems, 543 computations,
847 tests; Lean index 3,002 named proofs.


**Bottom-line Gaussian decay (2026-11-07).** Added `norm_gaussianZeroTest_bottom`
(weil-positivity T47): on the line `x − iT`,
`‖gaussianZeroTest c σ (x−iT)‖ = 2πσ² e^{σ²((x−1/2)²−T²)} e^{−c(x−1/2)}`.
The proof uses T46 and `Complex.re_ofReal_mul`. This is the exponential decay
needed for the `hbottom`/`htop` vanishing estimates. Counts: 1,406 theorems,
543 computations, 847 tests; Lean index 3,003 named proofs.


**Full verification through T47 (2026-11-07).** `tools/verify-all.sh --quick`
exits 0: 58/58 audit, all Python suites (847 tests), all 173 Lean files,
30,443 internal links with 0 broken curated links, and matching
`publication.html` hashes. The handoff now lists the remaining analytic inputs:
horizontal-line `logDeriv` estimates, the left/right explicit-formula limits,
and the arithmetic PNT/archimedean evaluation. Counts: 1,406 theorems, 543
computations, 847 tests, 3,003 named proofs.


**Uniform bottom-line bound (2026-11-07).** Added
`norm_gaussianZeroTest_bottom_le` (weil-positivity T48): for `x ∈ [−1,2]`,
`‖gaussianZeroTest c σ (x−iT)‖ ≤ 2πσ² e^{σ²(25/4−T²)} e^{(3/2)|c|}`. The proof
combines T47 with `(x−1/2)² ≤ 25/4` and `−c(x−1/2) ≤ |c|·|x−1/2|`. This is the
uniform decay-and-bound input for the `hbottom`/`htop` vanishing estimates.
Counts: 1,407 theorems, 543 computations, 847 tests; Lean index 3,004 named
proofs.


**Named horizontal log-derivative input (2026-11-07).** Added
`HorizontalLogDerivBound` and `horizontalLogDerivBound_apply`
(weil-positivity T49): a named polynomial growth bound for `logDeriv
completedZeta` on the contour `x ∈ [−1,2]`, the missing input for the
`hbottom`/`htop` vanishing estimates. Counts: 1,408 theorems, 543 computations,
847 tests; Lean index 3,005 named proofs.


**Remaining-input consolidation (2026-11-07).** The handoff now lists the
remaining analytic inputs side by side with their named Props:
`HorizontalLogDerivBound` (weil-positivity T49) for `hbottom`/`htop`,
`SmoothWindowPNTError` (missing-bridge T44) plus the archimedean bound for the
arithmetic side, and the left/right explicit-formula limits. All formal
infrastructure around them is proved. No theorem-count changes.


**Polynomial times Gaussian decay (2026-11-07).** Added
`tendsto_abs_pow_mul_exp_neg_sq` (T50) and
`tendsto_one_add_abs_pow_mul_exp_neg_sq` (T51): `|T|^k e^{−σ²T²} → 0` and
`(1+|T|)^k e^{−σ²T²} → 0`. The proof uses
`tendsto_rpow_abs_mul_exp_neg_mul_sq_cocompact` restricted to `atTop`, and
`add_pow_le` for the `(1+|T|)^k` comparison. This is the analytic half of the
`hbottom`/`htop` vanishing estimates. Counts: 1,410 theorems, 543 computations,
847 tests; Lean index 3,007 named proofs.


**Bottom contour integral vanishes (2026-11-07).** Added
`tendsto_bottom_integral_zero` (weil-positivity T52): under
`HorizontalLogDerivBound` and `σ > 0`, the bottom edge
`∫_{−1}^{2} logDeriv Λ(x−iT)·H_c(x−iT) dx` tends to `0`. The proof combines
T48 (uniform Gaussian bound), T49 (horizontal log-derivative bound) and T51
(polynomial times Gaussian decay), via
`intervalIntegral.norm_integral_le_of_norm_le_const`. This discharges the
`hbottom` input of T45 up to T49. Counts: 1,411 theorems, 543 computations,
847 tests; Lean index 3,008 named proofs.


**Top-line norm (2026-11-07).** Added `topLine_sq` (T53) and
`norm_gaussianZeroTest_top` (T54): the top line `x+iT` has the same Gaussian
norm as the bottom line, `2πσ² e^{σ²((x−1/2)²−T²)} e^{−c(x−1/2)}`. This gives
the uniform `e^{−σ²T²}` bound on the top edge needed for `htop`. Counts: 1,413
theorems, 543 computations, 847 tests; Lean index 3,010 named proofs.


**Uniform top-line bound (2026-11-07).** Added `norm_gaussianZeroTest_top_le`
(weil-positivity T55): for `x ∈ [−1,2]`,
`‖gaussianZeroTest c σ (x+iT)‖ ≤ 2πσ² e^{σ²(25/4−T²)} e^{(3/2)|c|}`. Together
with T48 this supplies the uniform `e^{−σ²T²}` bound on both horizontal edges
of the contour. Counts: 1,414 theorems, 543 computations, 847 tests; Lean index
3,011 named proofs.


**Top contour integral vanishes (2026-11-07).** Added
`HorizontalLogDerivBoundTop` and `tendsto_top_integral_zero` (weil-positivity
T56): under the top-line `logDeriv` growth bound, the top edge
`∫_{−1}^{2} logDeriv Λ(x+iT)·H_c(x+iT) dx → 0`. This mirrors T52 and, with it,
discharges both horizontal-edge hypotheses of T45. Counts: 1,415 theorems, 543
computations, 847 tests; Lean index 3,012 named proofs.


## Goal re-oriented to O4 (2026-11-07)

The isolated-block implication is **not** the bridge: `not_offLineBlockPSD_of_offLine`
makes the hypothesis `∀ c σ δ γ, δ ≠ 0 → OffLineBlockPSD c σ δ γ` false, so
`no_offLine_of_all_blocks_psd` is vacuous.  The meaningful object is
`FiniteWeilPositivity` for the full zero-side Gram matrix.  Missing-bridge T20
proves the easy direction `RH → FiniteWeilPositivity`; the hard direction
`FiniteWeilPositivity → RH` is **O4**, now the active goal.

Reduction recorded for O4: a single off-line zero `ρ = 1/2 + δ + iγ`
(`δ ≠ 0`, `0 < ρ.re < 1`) should make the 2×2 block on the family `![0, c]`
non-PSD by the scalar criterion, because `Re gaussianZeroTest c σ ρ` grows
exponentially in `c` while `Re gaussianZeroTest 0 σ ρ` is fixed.  The next
formal targets are the single-zero real-part formula and
`∃ c, Re H_0(ρ) < |Re H_c(ρ)|`.


**Single off-line zero real part (2026-11-07).** Added
`gaussianZeroTest_re_offLine` (missing-bridge T45): for `ρ = 1/2 + δ + iγ`,
`Re H_c(ρ) = 2πσ² e^{σ²(δ²−γ²)} e^{−cδ} cos(2σ²δγ − cγ)`. This is the first
formal step of the O4 reduction: it exposes the exponential growth in `c` for
`δ ≠ 0`. Counts: 1,416 theorems, 543 computations, 847 tests; Lean index 3,014
named proofs.


**Off-line zero growth (2026-11-07).** Added
`exists_gaussianZeroTest_re_gt_offLine` (missing-bridge T46): for `δ ≠ 0`, some
separation `c` makes `|Re H_c(ρ)| > Re H_0(ρ)`. The proof chooses `c` along
`cos(2σ²δγ − cγ) = 1` with `e^{−cδ}` arbitrarily large (the `γ = 0` case is
direct). This is the second O4 step: it makes the singleton 2×2 Gram block fail
the scalar PSD criterion. Counts: 1,417 theorems, 543 computations, 847 tests;
Lean index 3,015 named proofs.


**O4 plan corrected to the quadruple (2026-11-07).** The singleton `{ρ}` gives
an **asymmetric** 2×2 matrix (`Re H_{−c}(ρ) ≠ Re H_c(ρ)` in general), so the
singleton route does not directly give a PSD obstruction.  The correct finite
object is the conjugation- and functional-equation-closed quadruple
`S = {ρ, 1−ρ, conj ρ, 1−conj ρ}`.  On `S` the Gram sum is `offLineQuad`, which
is even in `c` (`offLineQuad_neg_c`), so the 2×2 block is exactly
`OffLineBlock c σ δ γ`; T18 then gives a separation where it is non-PSD.
Remaining formal steps: (i) the four points are zeros
(`completedZeta_zero_conj`, `completedZeta_one_sub`); (ii)
`finiteWeilGramReal ![0,c] σ S = OffLineBlock c σ δ γ`; (iii) conclude
`¬ FiniteWeilPositivity`.


**Quadruple injectivity blocker (2026-11-07).** The Gram–quadruple identity needs
injectivity of the four-point map `Fin 4 → ℂ` (the points are distinct when
`δ ≠ 0` and `γ ≠ 0`).  A brute-force `fin_cases`/`linarith` attempt did not
close the real-component cases, so the scratch was removed; the identity and its
injectivity lemma are recorded as the immediate next formal targets.  Counts
unchanged at 1,417 theorems, 543 computations, 847 tests, 3,015 named proofs.


**Singleton Gram asymmetry (2026-11-07).** Added `exists_gaussianZeroTest_re_ne_neg`
(missing-bridge T47): for `δ ≠ 0`, `γ ≠ 0`, some `c` makes
`Re H_{−c}(ρ) ≠ Re H_c(ρ)`.  This is the cleaner O4 route: the singleton
2×2 Gram matrix `!![Re H_0, Re H_{−c}; Re H_c, Re H_0]` is then **not
Hermitian**, hence not PSD, with no quadruple injectivity needed.  The `γ = 0`
degenerate case remains to be added.  Counts: 1,418 theorems, 543 computations,
847 tests; Lean index 3,016 named proofs.


## O4 milestone: hard direction for non-real zeros (2026-11-07)

Added three missing-bridge theorems completing the singleton route:
`finiteWeilGramReal_singleton` (T48), `not_posSemidef_singleton_of_ne` (T49) and
**`not_finiteWeilPositivity_of_offLine_im_ne_zero` (T50)**.  T50 proves: any
nontrivial zero with `0 < re < 1`, `re ≠ 1/2` and `im ≠ 0` makes
`FiniteWeilPositivity` fail.  The proof applies `FiniteWeilPositivity` to
`S = {ρ}` and the family `![0,c]`; T47 gives `Re H_{−c}(ρ) ≠ Re H_c(ρ)`, so the
2×2 block is not Hermitian (T49), contradicting PSD.

Together with the easy direction T20 (`RH → FiniteWeilPositivity`), O4 is now
proved **for zeros with nonzero imaginary part**.  The remaining case is a real
off-line zero (`im = 0`), where the singleton block is symmetric; that case
needs a separate argument (Λ has no real zeros in `(0,1)`).  Counts: 1,421
theorems, 543 computations, 847 tests; Lean index 3,019 named proofs.


**Real-line formula and real-zero plan (2026-11-07).** Added
`gaussianZeroTest_re_ofReal` (missing-bridge T51):
`Re H_c(ρ) = 2πσ² e^{σ²(ρ−1/2)²} e^{−c(ρ−1/2)}` for real `ρ`.  For the remaining
real off-line zero case, the plan is now concrete: on the pair
`S = {ρ, 1−ρ}` (both zeros by the functional equation) the Gram matrix is
`2A !![1, cosh(cδ); cosh(cδ), 1]` with `δ = ρ−1/2`, which is non-PSD for any
`cδ ≠ 0`; the `twoByTwo_not_posSemidef` criterion applies directly, with no
asymmetry needed.  Counts: 1,422 theorems, 543 computations, 847 tests; Lean
index 3,020 named proofs.


**Real-line formula at `1−ρ` (2026-11-07).** Added
`gaussianZeroTest_re_one_sub_ofReal` (missing-bridge T52): for real `ρ`,
`Re H_c(1−ρ) = 2πσ² e^{σ²(ρ−1/2)²} e^{c(ρ−1/2)}`.  This is the second entry
needed for the pair `{ρ, 1−ρ}` Gram matrix; the remaining step is the matrix
identity and the `cosh` non-PSD conclusion.  Counts: 1,423 theorems, 543
computations, 847 tests; Lean index 3,021 named proofs.


## O4 proved: `FiniteWeilPositivity ↔ RH` (2026-11-07)

The hard direction of the classical Weil criterion is now Lean-proved:
**`finiteWeilPositivity_implies_RH`** (missing-bridge T57).  Together with the
easy direction T20 this formalises `RH ↔ FiniteWeilPositivity` for the finite
zero-side Gram matrix.

The final steps were:
- **T53** `finiteWeilGramReal_pair`: on the pair `{ρ, 1−ρ}` the Gram matrix is
  the `cosh` block `2A !![1, cosh δ; cosh δ, 1]`.
- **T54** `not_posSemidef_real_pair`: that block is non-PSD for `δ ≠ 0`.
- **T55** `not_finiteWeilPositivity_of_real_offLine`: a real off-line zero
  refutes `FiniteWeilPositivity`.
- **T56** `not_finiteWeilPositivity_of_offLine`: combines T50 (`im ≠ 0`) and T55
  (`im = 0`).
- **T57** `finiteWeilPositivity_implies_RH`: the capstone.

**RH is not claimed.**  The equivalence reduces RH to `FiniteWeilPositivity`,
which remains open on the arithmetic side.  Counts: 1,428 theorems, 543
computations, 847 tests; Lean index 3,027 named proofs.


## O4 audit (2026-11-08)

Audited T57 and its dependency chain against the intended classical statement.
Findings:

- **Statement match:** `finiteWeilPositivity_implies_RH` has the exact shape
  `FiniteWeilPositivity → RiemannHypothesis`; no extra hypotheses, no `sorry`,
  no `axiom` in `missing-bridge/lean/Topic.lean`.
- **Scope caveat:** `FiniteWeilPositivity` is the finite, zero-side,
  **Gaussian-window** criterion — all finite nontrivial-zero sets and real
  Gaussian families, but no arbitrary test functions and no archimedean/prime
  terms.  T57 is the hard direction for this restricted family (a strengthening
  of the full implication); the full arbitrary-test-function and infinite/cone
  versions remain outside the formalisation.
- **Real-zero case (T53–T55):** the pair `{ρ, 1−ρ}` with `0 < ρ < 1`,
  `ρ ≠ 1/2`; `completedZeta_one_sub` hypotheses (`ρ ≠ 0`, `ρ ≠ 1`, `Γℝ ρ ≠ 0`,
  `Γℝ (1−ρ) ≠ 0`) all follow from `0 < ρ < 1`.  Clean.
- **Non-real case (T50):** singleton `{ρ}` plus the T47 asymmetry gives a
  non-Hermitian block.  Sound.
- **Remaining open direction:** prove `FiniteWeilPositivity` (equivalently RH)
  on the arithmetic side.

The audit is recorded in the missing-bridge README (“O4 audit”) and in the
weil-positivity HANDOFF.


## Arithmetic-side programme: interface and route analysis (2026-11-08)

Added the arithmetic-side interface (missing-bridge T58):
`weilQuadraticForm a σ S x = star x ⬝ᵥ (finiteWeilGramReal a σ S *ᵥ x)`, and
proved `finiteWeilPositivity_iff_quadraticForm`: `FiniteWeilPositivity` is
exactly the statement that every finite zero-side Gram matrix is Hermitian and
has nonnegative quadratic form for every `x`.  This is the shape the explicit
formula must match.

Route analysis for proving `FiniteWeilPositivity` (equivalently RH):

1. **Full-matrix explicit formula.**  T45 (weil-positivity) is a scalar identity
   for one separation `c` with conditional contour/limit data.  The quadratic
   form needs the matrix version for all `c = aᵢ − aⱼ`; the contour identity
   `hcontour` and the horizontal vanishing (T49/T52/T56 inputs) are not proved.
2. **Arithmetic quadratic form.**  The prime side is
   `∑ₙ Λ(n) n^{−1/2} exp(−(log n − c)²/(4σ²))`.  As a function of `c` this is a
   **shifted** Gaussian; the matrix `g(aᵢ−aⱼ)` is not Hermitian for `log n ≠ 0`.
   Entrywise PSD is therefore the wrong target; the correct object is the
   quadratic form of the full (zero-side symmetrised) functional, which is the
   classical Weil positivity statement and is RH-strength.
3. **PNT input.**  `SmoothWindowPNTError` (T44) is a PNT-strength hypothesis;
   Mathlib has only Chebyshev-type `ψ` bounds, no PNT.
4. **Archimedean positivity.**  The `weilOmega`/digamma inequalities that make
   the archimedean contribution nonnegative are not developed.
5. **Horizontal `logDeriv` bounds.**  `HorizontalLogDerivBound` (weil-positivity
   T49) is a named input, needed for `hbottom`/`htop`.

**Feasibility verdict.**  No unconditional proof of `FiniteWeilPositivity` is
available from the current library; the obstruction is the PNT/archimedean
analysis together with the full-matrix explicit formula, and the statement is
RH-equivalent.  T58 is the precise interface the arithmetic side must satisfy.
Counts: 1,429 theorems, 543 computations, 847 tests; Lean index 3,028 named
proofs.


**Matrix assembly (2026-11-08).** Added `scalarZeroSide` plus
`weilQuadraticForm_eq_sum_scalar` (T59) and
`weilQuadraticForm_eq_arithmetic` (T60).  T59 expands the Weil quadratic form
as the finite bilinear combination of the scalar zero-side sums; T60 shows that,
**given the scalar explicit formula** `scalarZeroSide σ S c = g c`, the quadratic
form equals the arithmetic quadratic form `∑ᵢ∑ⱼ xᵢxⱼ g(aᵢ−aⱼ)`.  This isolates
the two remaining obligations precisely: (i) the unconditional scalar explicit
formula (T45 is conditional), and (ii) nonnegativity of the arithmetic quadratic
form.  Counts: 1,431 theorems, 543 computations, 847 tests; Lean index 3,030
named proofs.


**Gaussian rectangle identity and the simplicity blocker (2026-11-08).** Added
`gaussianRectangleIdentity` (missing-bridge T61): the library's
`test_function_explicit_formula` specialised to `h = gaussianZeroTest c σ`.  It
gives exactly the `hcontour` hypothesis of T45 from the standard explicit-formula
data.  Checking the signature exposed a **precise blocking condition** for the
arithmetic-side programme: the formula requires

`hF_simple : ∀ ρ ∈ S, deriv (s(s−1)Λ(s)) ρ ≠ 0`,

i.e. **simplicity of the zeros in `S`**, which is not known and is itself an
open conjecture.  It also requires `hF_ne` (that `S` is exactly the zero set in
the rectangle).  Therefore an unconditional arithmetic-side proof of
`FiniteWeilPositivity` via this formula is blocked not only by PNT and the
archimedean inequalities but also by zero simplicity.  Counts: 1,432 theorems,
543 computations, 847 tests; Lean index 3,031 named proofs.


**Hermitian half of the arithmetic matrix (2026-11-08).** Added
`arithmeticResidual_symm` (T62) and `arithmeticResidual_even` (T63): with the
prime sides evaluated symmetrically at `c` and `−c`, the residual
`poleTerm c σ − (P c + P(−c)) + arch` is even in `c`.  Consequently the
arithmetic Gram matrix `g(aᵢ−aⱼ)` is **Hermitian** — one of the two conditions
in T58 is therefore structural, and the only remaining half is nonnegativity of
the arithmetic quadratic form.  Counts: 1,434 theorems, 543 computations,
847 tests; Lean index 3,033 named proofs.


**Scalar consequence and the multiplicity obstruction (2026-11-08).** Added
`finiteWeilPositivity_scalar_nonneg` (T64): `FiniteWeilPositivity` implies the
scalar Weil inequality `0 ≤ ∑_{ρ∈S} Re H_0(ρ)` for every finite nontrivial-zero
set.  While checking whether the divisor-weighted explicit formula could remove
the `hF_simple` hypothesis, a structural obstruction was identified: the
divisor formula (`rectIntegral_logDeriv_completedZeta_eq_divisor_sum_derived`,
`explicit_formula_h1_symmetric_divisor`) counts zeros **with multiplicity**
(`m w = divisor …`), whereas `FiniteWeilPositivity` sums over a **Finset** of
distinct zeros.  The residue of `Λ'/Λ` at a multiple zero is the multiplicity,
so the divisor formula gives `∑ m_ρ h(ρ)`, not `∑ h(ρ)`.  Removing `hF_simple`
therefore requires either zero simplicity or a multiplicity-aware restatement
of `FiniteWeilPositivity`; this is now recorded as a precise blocker rather than
assumed away.  Counts: 1,435 theorems, 543 computations, 847 tests; Lean index
3,034 named proofs.


**Remaining-inputs ledger (2026-11-08).** The arithmetic-side reduction is now
complete and mechanical, and the open content is exactly four inputs, recorded
in the missing-bridge README and the weil-positivity handoff:

1. zero simplicity (`hF_simple`), with the multiplicity obstruction: the
   divisor formula counts `m_ρ` while `FiniteWeilPositivity` sums distinct zeros;
2. `SmoothWindowPNTError` (PNT-strength, absent from Mathlib);
3. the archimedean `weilOmega` digamma positivity;
4. `HorizontalLogDerivBound` and the `hbottom`/`htop`/`hright`/`hleft` limits.

The reduction chain is T20/T57 (`RH ↔ FiniteWeilPositivity`), T58 (quadratic-form
interface), T59–T60 (matrix assembly), T61 (Gaussian rectangle identity),
T62–T63 (Hermitian half) and T64 (scalar necessary condition).  No claim of RH
or unconditional positivity.


**Exact 2×2 PSD criterion (2026-11-08).** Added `twoByTwo_posSemidef_iff`
(missing-bridge T65): `!![a,b;b,a]` is PSD iff `0 ≤ a` and `|b| ≤ a`.  This
complements the library's sufficient non-PSD lemma and gives the exact pair
conditions that the arithmetic-side quadratic form must meet.  Counts: 1,436
theorems, 543 computations, 847 tests; Lean index 3,035 named proofs.


**General 2×2 criterion and singleton characterisation (2026-11-08).** Added
`twoByTwo_general_posSemidef_iff` (T66): `!![a,b;c,a]` is PSD iff `b = c`,
`0 ≤ a` and `|b| ≤ a`.  Applied to the singleton zero block, this gives
`singleton_block_posSemidef_iff` (T67), which shows precisely why an off-line
zero fails: the two off-diagonal entries differ (T47), so the block is not
Hermitian.  Counts: 1,438 theorems, 543 computations, 847 tests; Lean index
3,037 named proofs.


**Singleton criterion forced by `FiniteWeilPositivity` (2026-11-08).** Added
`finiteWeilPositivity_singleton` (missing-bridge T68): at every nontrivial zero,
`FiniteWeilPositivity` forces the exact singleton 2×2 conditions, in particular
`Re H_{−c}(ρ) = Re H_c(ρ)` for all `c`.  This is a complete Lean statement of
the zero-side obstruction and closes the pairwise structural thread of the
programme.  Counts: 1,439 theorems, 543 computations, 847 tests; Lean index
3,038 named proofs.


**Zero-set-specified Gaussian rectangle identity (2026-11-08).** Added
`gaussianRectangleIdentity_of_allZeros` (missing-bridge T69): the same rectangle
identity with the opaque `hF_ne` replaced by the intended condition that `S`
contains every zero of `s(s−1)Λ(s)` in `U` (plus `hZ_zero`, so `S` consists of
zeros).  This makes the hypothesis set match the mathematics; `hF_simple`
remains the irreducible simplicity input.  Counts: 1,440 theorems, 543
computations, 847 tests; Lean index 3,039 named proofs.


**Full verification at T69 and an archimedean correction (2026-11-08).**
`tools/verify-all.sh --quick` exits 0 on the T69 tree: 58/58 audit, all Python
suites (847 tests), all 173 Lean files, **30,550** internal links with 0 broken
curated links, and matching `publication.html` hashes
(`ae65d8c1…`).  Separately, the ledger’s third arithmetic-side input was
corrected: the archimedean factor is **not** pointwise nonnegative —
`weilOmega 0 = Re ψ(1/4) − log π ≈ −5.372` numerically — so the arithmetic-side
positivity is a genuine cancellation, and the required input is the full
arithmetic quadratic-form inequality, not a separate archimedean positivity
lemma.  Counts: 1,440 theorems, 543 computations, 847 tests; Lean index 3,039
named proofs.


**Arithmetic Gram matrix is Hermitian (2026-11-08).** Added
`arithmeticResidual_isHermitian` (missing-bridge T70): because the symmetrised
residual is even (T63), the arithmetic Gram matrix `g(aᵢ−aⱼ)` is a genuine
Hermitian matrix.  This completes the Hermitian half of the T58 interface for
the arithmetic side; the remaining half is nonnegativity.  Counts: 1,441
theorems, 543 computations, 847 tests; Lean index 3,040 named proofs.


## Arithmetic-side programme blocked at the research boundary (2026-11-08)

The formal reduction is complete: `RH ↔ FiniteWeilPositivity` (T20/T57), the
quadratic-form interface (T58), matrix assembly (T59–T60), the Gaussian
rectangle identity (T61, T69), the Hermitian arithmetic matrix (T62–T63, T70),
the exact 2×2 criteria (T65–T67), the singleton characterisation (T68) and the
scalar necessary condition (T64) are all Lean-proved.

The same four concrete conditions have blocked the remaining step across rounds
6–12:

1. **zero simplicity** (`hF_simple`), an open conjecture, combined with the
   multiplicity obstruction (the divisor formula counts `m_ρ`; the Finset sums
   distinct zeros);
2. **`SmoothWindowPNTError`** — PNT-strength, absent from Mathlib;
3. **nonnegativity of the full arithmetic quadratic form** — a genuine
   cancellation, since the archimedean factor is negative at 0
   (`Re ψ(1/4) − log π ≈ −5.372`);
4. **the contour limits** (`HorizontalLogDerivBound`, `hbottom`/`htop`,
   `hright`/`hleft`).

No further formal step is available without at least one of these, and
discharging all of them is RH-strength.  The programme is recorded as blocked
at this boundary rather than advanced by interfaces.


## Arithmetic quadratic-form programme: pole-cancelled decomposition (2026-11-08)

Resumed with the objective the user selected: the genuine arithmetic
quadratic-form inequality.  Added `arithmeticQuadraticForm` and
`arithmeticQuadraticForm_eq_pnt_add_arch` (missing-bridge T71): the arithmetic
Weil quadratic form splits **exactly** into

`Q_PNT(c) + Q_PNT(−c) + Q_arch`,

where each `Q_PNT` is the quadratic form of the PNT error
`primeMainTerm(·) − P(·)` and `Q_arch` is the archimedean quadratic form.  The
pole term cancels by `poleTerm_eq_primeMainTerm_add`.  This is the classical
starting point: the remaining work is to control `Q_PNT` and `Q_arch` and show
their sum is nonnegative.  No claim of RH or unconditional positivity.
Counts: 1,442 theorems, 543 computations, 847 tests; Lean index 3,041 named
proofs.


**PNT-error quadratic-form bound (2026-11-08).** Added `abs_pntQuadraticForm_le`
(missing-bridge T72): under `SmoothWindowPNTError E` and `E ≥ 0`, the quadratic
form of the Gaussian-window PNT error is bounded by `E·(∑ᵢ|xᵢ|)²`.  This is the
first quantitative control in the classical positivity route: together with T71
it shows the arithmetic quadratic form is `Q_arch + O(E)`, so the remaining
content is the archimedean quadratic form and the PNT-error size.  No claim of
RH or unconditional positivity.  Counts: 1,443 theorems, 543 computations,
847 tests; Lean index 3,042 named proofs.


**Classical positivity reduction (2026-11-08).** Added the function-valued
residual/quadratic form (T73), the two-PNT-form identity (T74) and the
conditional nonnegativity theorem (T75):

- `arithmeticResidualFun σ P arch c = poleTerm c σ − (P c + P(−c)) + arch c`
  (the archimedean term now depends on the separation, as it must);
- `Q_arith = 2·Q_PNT + Q_arch` (the two PNT-error forms coincide by index swap);
- if `Q_arch ≥ 2E(∑|xᵢ|)²` and `SmoothWindowPNTError E` holds with `E ≥ 0`,
  then `Q_arith ≥ 0`.

This is the classical positivity shape: the archimedean form must dominate
twice the PNT-error bound.  The remaining content is exactly that dominance
(`Q_arch` vs `2E‖x‖₁²`).  Counts: 1,446 theorems, 543 computations, 847 tests;
Lean index 3,045 named proofs.


**Arithmetic matrix PSD under archimedean dominance (2026-11-08).** Added
`arithmeticResidualFun_even` (T76), `arithmeticQuadraticFormFun_eq_dotProduct`
(T77) and **`arithmeticMatrix_posSemidef_of_dominates` (T78)**: with an even
archimedean kernel and the dominance hypothesis
`Q_arch ≥ 2E(∑|xᵢ|)²`, the arithmetic Gram matrix is PSD.  This assembles the
Hermitian and quadratic-form halves and isolates the last quantitative input:
the archimedean dominance inequality.  Counts: 1,449 theorems, 543 computations,
847 tests; Lean index 3,048 named proofs.


**Capstone reduction (2026-11-08).** Added `finiteWeilPositivity_of_arithmetic`
(missing-bridge T79): `FiniteWeilPositivity` follows from (i) the scalar
explicit-formula identity `scalarZeroSide σ S c = g σ c` and (ii) PSD of the
arithmetic Gram matrix `g σ (aᵢ − aⱼ)`.  Combined with T78 (PSD under
archimedean dominance), the entire arithmetic-side programme now reduces to a
single inequality: `Q_arch ≥ 2E(∑|xᵢ|)²`.  No claim of RH or unconditional
positivity.  Counts: 1,450 theorems, 543 computations, 847 tests; Lean index
3,049 named proofs.


**Concrete archimedean kernels are even (2026-11-08).** Imported
`Archimedean` into missing-bridge and added `weilOmega_real_even` (T80) and
`archSymbol_real_even` (T81): the library's concrete archimedean kernels are
even on the real axis, supplying the `harch` hypothesis of the PSD assembly
(T78).  The last open inequality remains the archimedean dominance
`Q_arch ≥ 2E‖x‖₁²`.  Counts: 1,452 theorems, 543 computations, 847 tests; Lean
index 3,051 named proofs.


## End-to-end conditional chain to RH (2026-11-08)

Added `finiteWeilPositivity_of_pnt_archimedean` (T82) and
`riemannHypothesis_of_pnt_archimedean` (T83).  The complete conditional chain is
now formalised:

**even archimedean kernel + `SmoothWindowPNTError E` + archimedean dominance
`Q_arch ≥ 2E(∑|xᵢ|)²` + the scalar explicit formula ⇒ `FiniteWeilPositivity`
⇒ RH.**

**This is not an unconditional proof of RH.**  Each of the four inputs is open:
the archimedean dominance is the classical hard inequality, the PNT bound is
PNT-strength, and the scalar explicit formula requires zero simplicity (or a
multiplicity-aware restatement).  The value of the chain is that the entire
arithmetic-side argument is now a single Lean theorem with the four inputs
visible as hypotheses.  Counts: 1,454 theorems, 543 computations, 847 tests;
Lean index 3,053 named proofs.


**Full verification at T83 (2026-11-08).** `tools/verify-all.sh --quick` exits 0
on the T83 tree: 58/58 audit, all Python suites (847 tests), all 173 Lean files,
**30,592** internal links with 0 broken curated links, and matching
`publication.html` hashes (`ae65d8c1…`).

**Final blocking condition of the arithmetic quadratic-form programme.**  The
entire formal reduction is complete and verified: T71–T75 (pole-cancelled
decomposition, PNT bound, conditional nonnegativity), T76–T78 (Hermitian
arithmetic matrix, PSD under archimedean dominance), T79 (capstone from the
arithmetic identity + arithmetic PSD), T80–T81 (concrete archimedean kernels
even), T82–T83 (end-to-end conditional derivation of `FiniteWeilPositivity` and
RH from four inputs).  The single remaining inequality is the **archimedean
dominance** `Q_arch(x) ≥ 2E(∑|xᵢ|)²`; the other three inputs are the
PNT-strength `SmoothWindowPNTError E` and the scalar explicit formula (zero
simplicity / multiplicity).  Proving the dominance is RH-strength and no
further formal step is available from the current library.


## The concrete Gaussian archimedean kernel found (2026-11-08)

The archimedean quadratic-form object for the Gaussian family **exists** in the
repository: `prime-spectrum-tensor/lean/GaussianGram.lean` defines

`omega t = Re ψ(1/4 + it/2) − log π`,
`densityTerm c σ = σ² ∫ exp(−σ²t²) cos(ct) Ω(t) dt`,
`gaussianGramEntry a b σ = (W(a−b) + W(b−a))/2`, `W = pole + density + prime`.

Added the formal bridge in missing-bridge (T84–T86):
`gaussianGramEntry c 0 σ = arithmeticResidualFun σ (fun x => −primeTerm x σ / 2)
(fun x => densityTerm x σ) c`, with evenness of `densityTerm` and the
`prime-spectrum-tensor` pole term.  So the abstract `arch` of T73–T83 is
exactly `densityTerm · σ`, and the concrete kernel is a Gaussian-weighted cosine
transform of the archimedean density.

The `prime-spectrum-tensor` topic already proves the **4×4** positivity
certificate `gaussianGram4_posDef` (via interval enclosures of Ω and quadrature;
see its `OMEGA-ROUTE.md`, which records the certificate as done).  That is a
finite instance of the Gram positivity, not the general archimedean dominance
for all families.

**Remaining:** the general dominance `Q_arch(x) ≥ 2E(∑|xᵢ|)²` for all finite
families, with `Q_arch` built from `densityTerm`.  The 4×4 certificate shows the
quantity is computable and positive in that case; the general inequality is
still RH-strength.  Counts: 1,457 theorems, 543 computations, 847 tests; Lean
index 3,056 named proofs.


**Correction: the archimedean-dominance condition is the wrong final input
(2026-11-08).**  The bridge T84–T86 identifies the concrete archimedean kernel:
`arch = densityTerm · σ`, where
`densityTerm c σ = σ² ∫ e^{−σ²t²} cos(ct) Ω(t) dt` and `Ω(t) = Re ψ(1/4+it/2) − log π`.
This is a Gaussian-weighted cosine transform, so for a singleton family
(`a = 0`, `x = 1`) the archimedean quadratic form is `densityTerm 0 σ`, which is
**negative** (Ω(0) = −γ − log π ≈ −1.72).  Therefore the sufficient condition of
T75/T78/T82/T83, `Q_arch ≥ 2E(∑|xᵢ|)²`, is **false for the concrete kernel** and
cannot be the classical final inequality.

The correct zero-side structure is the full three-term Gram form
`Q_zero = Q_pole + Q_prime + Q_density` (matching `gaussianW = pole + density +
prime`), where the pole term `4πσ²e^{σ²/4}cosh(c/2)` is positive and the density
and prime terms are negative for the relevant separations.  Positivity is a
genuine cancellation, not an archimedean-vs-PNT domination.  The existing
`prime-spectrum-tensor` 4×4 certificate `gaussianGram4_posDef` is a verified
instance of this full cancellation.  The programme should therefore target the
full Gaussian Gram positivity (the `prime-spectrum-tensor`/`WEIL-GRAM` route),
not the T75 dominance condition.


## Goal re-oriented to the full Gaussian Gram positivity (2026-11-08)

The goal objective is updated: target the full Gaussian Gram positivity on the
`prime-spectrum-tensor` / `WEIL-GRAM.md` route, not the (false) archimedean
dominance.  Added `gaussianGram4_eq_arithmetic` (missing-bridge T87): the exact
`gaussianGram4 σ` is the arithmetic residual matrix on the `centre4`
separations, with `P = −primeTerm/2` and `arch = densityTerm`.

The existing `prime-spectrum-tensor` theorem `gaussianGram4_posDef`
(`DensityCertificates.lean`) is the proven 4×4 instance of that matrix.  Because
`DensityCertificates` pulls in modules outside missing-bridge's import path, the
4×4 positivity is recorded as a cross-topic certificate rather than imported;
the identification T87 is the formal link.

**Next:** generalise the enclosure certificate beyond the four centres, or prove
the analytic three-term inequality `Q_pole + Q_prime + Q_density ≥ 0` it
instantiates.  Counts: 1,458 theorems, 543 computations, 847 tests; Lean index
3,057 named proofs.


**Signs and three-term split of the Gaussian Gram entry (2026-11-08).** Added
`primeTerm_nonpos` (T88), `poleTerm_ps_pos` (T89) and
`gaussianGramEntry_three_term` (T90): the Gaussian Gram entry is
`pole + density + (prime(c) + prime(−c))/2`, with the pole term **positive** and
the prime term **non-positive** for `σ ≥ 0`.  The density term is the one with
variable sign (negative near `c = 0`), so the positivity of the entry is a
genuine three-term cancellation — exactly the structure the
`prime-spectrum-tensor` 4×4 certificate verifies.  Counts: 1,461 theorems, 543
computations, 847 tests; Lean index 3,060 named proofs.


**Three-matrix decomposition of the Gaussian Gram matrix (2026-11-08).**
Added `gaussianGram4_eq_pole_add_density_add_prime` (T91): the exact 4×4 Gaussian
Gram matrix is the sum of the pole, density and prime matrices; and
`gaussianGram4_isHermitian` (T92), its Hermitian property in the arithmetic
framework (using the even density T84).  The positivity is now visibly a
three-term matrix cancellation, matching the `prime-spectrum-tensor` route.
Counts: 1,463 theorems, 543 computations, 847 tests; Lean index 3,062 named
proofs.


**Certified 4×4 instance integrated (2026-11-08).**  Extended missing-bridge's
Lean path to `intersection-form-zeta/lean` and imported `DensityCertificates`.
Added `gaussianGram4_posSemidef` (T93) and `centre4Arithmetic_posSemidef` (T94):
the exact arithmetic residual matrix on the four centres at `σ = 1/20` is
positive semidefinite, via the `prime-spectrum-tensor` enclosure certificate and
the identification T87.  This is a fully Lean-checked instance of the full
three-term Gaussian Gram positivity (pole + density + prime), integrated into
the general framework.  Counts: 1,465 theorems, 543 computations, 847 tests;
Lean index 3,064 named proofs.


**5×5 rung integrated (2026-11-08).**  Imported `DensityCertificates5` and added
`gaussianGram5_eq_arithmetic` (T95), `gaussianGram5_posSemidef` (T96) and
`centre5Arithmetic_posSemidef` (T97): the exact arithmetic residual matrix on the
five centres `−2/5,−1/5,0,1/5,2/5` at `σ = 1/20` is positive semidefinite, via
the `prime-spectrum-tensor` 5×5 certificate.  The full three-term Gaussian Gram
positivity is now Lean-checked on both the 4- and 5-centre families.
Counts: 1,468 theorems, 543 computations, 847 tests; Lean index 3,067 named
proofs.
