# Research journal — Euler–Maclaurin Lean layer and Objective III status

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
