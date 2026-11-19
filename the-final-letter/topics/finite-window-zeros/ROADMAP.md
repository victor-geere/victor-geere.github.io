# Finite-window zeros — roadmap

**Status:** active finite-window programme. P3 has a point certificate, a thin
segment and a second on-line simple zero. The next work is to widen the verified
window, make the enclosure reusable, and connect it to the truncated explicit
formula (P4). No RH or GRH statement is in scope.

**Baseline ledger:** 616 theorem rows · 14 computations · 20 pytest tests.
**Lean tree:** 694 theorem/lemma declarations across 27 files; 20 files in the
default build; `BigCheck.lean` separate.
**Lean:** default `./lean/check.sh` green; `BigCheck.lean` is a separate,
long-running check and is not part of the default build.
**Companion:** [HANDOFF.md](HANDOFF.md) records the detailed Krawczyk and
Euler–Maclaurin history.

## 1. What is already done

| Result | Lean theorem / file | Status |
|---|---|---|
| `ζ(1/2+5i) ≠ 0` | `zeta_half_plus_five_ne_zero` (`Cert.lean`) | proved |
| Thin zero-free segment `t ∈ [5, 5.000003]` on `Re = 1/2` | `zeta_ne_zero_segment` (`Seg.lean`) | proved |
| `(1−2^{1−s})ζ(s)=η(s)` for `0 < Re s`, `s ≠ 1` | T5–T8 | proved |
| Pair-tail estimate | T10–T11 | proved |
| Euler–Maclaurin on the critical line, every `K` | T293–T305 (`EMCritical.lean`) | proved |
| Point enclosure `‖ζ(s14)‖ ≤ 1/8` | T320/T321, sharpened T322 (`EMBox14.lean`) | proved |
| Krawczyk `hC` at `r = 1/5` | T391 (`h1_deriv`), T485 (`h2_deriv`) | proved |
| Zero at `1/2+14i`, on line and simple | `zeta_zero_14_on_line_simple` (`EMOnLine.lean`) | proved |

The old route through the iterated Euler transformation is **superseded**: it is
asymptotic on the critical line and its rigorous remainder grows like `K!`. The
Euler–Maclaurin `B₂` route is the live one.

## 2. What is not done

The point certificate does not by itself give a **segment**. The thin segment at
height 5 uses the older 100-pair certificate; the height-14 point uses the
21-atom Euler–Maclaurin enclosure. The reusable rectangle certificate, the wider
critical-line window, and the P4 consumer are still missing.

## 3. Milestones

### M0 — Reconcile the ledger and the default build — **done**

**Goal.** Make the README ledger, `HANDOFF.md`, `STATUS.md` and the Lean file map
agree on theorem counts and build membership.

**Acceptance.**
- `./lean/check.sh` green.
- `BigCheck.lean` explicitly outside the default build.
- Ledger counts match the README table and `STATUS.md`.

**Status.** Done: `HANDOFF.md`, README, ROADMAP and `STATUS.md` now use the same
row/test/declaration definitions; the default build has 18 files and `BigCheck`
is explicitly separate.

**Risk.** Low.

### M1 — A reusable rectangle enclosure — **done**

**Goal.** Turn the point enclosure at `s14` into a parameterised rational box
certificate: for a rectangle `R`, emit `Cx` boxes for `etaGrouped` (or
`zetaEMGen`) and prove that a point in `R` cannot be a zero.

**Status.** Done. `rectBox`, `mem_rectBox` and the set-level transfer
`zeta_ne_zero_on_rect_of_eta_mem` are proved (T495–T496), and the height-5
segment argument is extracted as the `params`-generic certificate
`zeta_ne_zero_on_rect_of_params` (T497). Any future window can reuse T497.

**Lean targets.**
- `etaGrouped_mem_box` / `zetaEMGen_mem_box` for a rectangular parameter set.
- `eta_ne_zero_of_box` using (E) and a certified lower bound for
  `|1−2^{1−s}|`.
- A width-aware checker, reusing
  [`partial-sum-plus-tail/lean/Width.lean`](../partial-sum-plus-tail/lean/Width.lean).

**Acceptance.** A theorem that takes a rational rectangle, a verified box and a
verified `1−2^{1−s}` bound, and returns `ζ s ≠ 0` for every `s` in the rectangle,
with no `sorry`.

**Risk.** Medium. The `kI` side condition and interval amplification at height 14
are already calibrated in `HANDOFF.md`; the work is packaging, not new analysis.

### M2 — Wider zero-free segments on the critical line — **done**

**Goal.** Replace the single thin segment by a finite subdivision of
`t ∈ [0,10]` (or the largest safe subinterval) into rational boxes, each
certified by M1.

**Lean targets.**
- `zeta_ne_zero_segment_00_10` (or an explicit list of adjacent segments).
- A `Finset`-indexed cover theorem: if every box in a list is certified and the
  list covers the interval, the whole interval is zero-free on the line.

**Acceptance.** A kernel-checked theorem of the form
`∀ t ∈ [a,b], ζ(1/2+it) ≠ 0`, with explicit rational `a,b`, no numerical
hypothesis.

**First probe (mixed).** The height-5 box is not monotone in endpoint width:
`[5, 5.000002]` still excludes zero, but `[5, 5.000004]` and wider fail the
`containsZero` check with `params 100` and tail radius `1`. An attempt with
`params 400` failed the pair side conditions; a tighter `(14,16,64,20)` pair
configuration passed `allOK` for 100 pairs but its folded box still contained
zero. However, **adjacent** boxes of the existing width at
`[5.000003, 5.000006]` and `[5.000006, 5.000009]` both pass, so T501 now
certifies `[5, 5.000009]` (three boxes). The same tiling now extends to
`[5, 5.000018]` via T502–T506 and then to `[5, 5.000027]` via T507–T510, and now to
`[5, 5.000036]` via T511–T514 — twelve times the original length.
The next attempt should tile further adjacent boxes or recalibrate the pair
boxes.

**Risk.** Medium–high. This is the first genuinely new numerical workload. Start
with one box at a time and grow the window; do not claim `[0,10]` before the
cover is complete.

### M3 — P4 consumer — **scoped, not started**

**Goal.** Feed the M1/M2 certificate into the truncated explicit formula (P4).

**Dependency resolved (formula layer).** The analytic explicit formula is not
missing: it is Lean-proved in
[`../absolute-polarized-hodge-index-realization/lean/ExplicitFormula.lean`](../absolute-polarized-hodge-index-realization/lean/ExplicitFormula.lean)
(`test_function_explicit_formula`, `explicit_formula_h1_symmetric_divisor`), with
zero-side divisor counting and archimedean material. `P4.lean` now imports and
restates `test_function_explicit_formula` here (T523).

**Route correction.** The tent function is **not complex-analytic**, so it cannot
be inserted into `test_function_explicit_formula` as the contour test function
`h`. The correct imported layer is the real Paley–Wiener one:
`paleyWiener`, `contour_shift_paleyWiener`, `paleyWiener_autocorrelation_nonneg`
and the assembled archimedean/prime Fourier identities. `P4.lean`'s T523 is the formula-layer bridge; the tent enters through the
scaled tent `tentS` and `paleyWiener` (T524–T527), not through `h = tent`.

**Remaining M3-finite work.** The zero set can now be taken finite:
`zeroFinset R` is Mathlib's discrete-zero construction on a compact rectangle
(T529–T531), and it is empty when `completedZeta` is nonzero on a critical-strip
rectangle (T533). The remaining inputs are: the simplicity of the zeros in `R`, the
numerical Paley–Wiener zero sum over that finite set, and the archimedean/prime
specialisation for `tentS`. The direct `S = ∅` wrapper hits coercion
normalisation in the imported statement and is deferred. The prime side for the tent is
already in `finite-explicit-formula` (`PrimeSide.lean`). The universal Weil-positivity statement is RH-level and out of scope.

**Lean targets.**
- A theorem consuming a zero-free rectangle/segment as a hypothesis.
- The explicit-formula error term with the window length and the certified bound.

**Acceptance.** P4 is no longer a numerical premise: the zero-free input is a
Lean theorem, and the remaining hypothesis is only the explicit-formula
truncation.

**Risk.** High. Depends on M1 and M2; the explicit-formula layer is separate and
must not be assumed.

### M4 — Width, not only soundness — **done (concrete box)**

**Goal.** Prove a symbolic width theorem for `zetaBox`/`Bzeta` so certificates
can be emitted at a requested tolerance instead of hand-tuned.

**Progress.** The segment width is now symbolic: `width_segBox`, `width_S1`,
`width_S11` and `width_segment` are proved (T519–T521), and the actual folded
zeta enclosure satisfies `Bzeta.width ≤ 1/2` (T522). The concrete M4 target is met. A general symbolic width theorem for the
`Expr`/`zetaBox` layer remains an extension.

**Lean targets.**
- `Expr.wfWidth`-style theorem for the rectangle enclosure.
- A worked `ζ(2)` or `ζ(s14)` width target.

**Acceptance.** A width theorem with an explicit rational bound, checked.

**Risk.** Medium. The existing rectangle enclosure is deliberately crude; this
may require sharper `CpowBox` parameters.

### M5 — Derivatives for `L'/L`

**Goal.** Enclose derivatives, not just values, so the explicit formula can use
`L'/L` on a rectangle.

**Lean targets.**
- Differentiated tail atoms and a `div` soundness lemma.
- A certified derivative box on the M1 rectangle.

**Acceptance.** `|L'/L|` bounded on the rectangle by a rational constant.

**Risk.** High. Deferred until M3 is understood.

## 4. Order of work

1. **M0** — reconcile counts and build membership.
2. **M1** — reusable rectangle enclosure.
3. **M2** — wider critical-line segment.
4. **M4** — width theorem (can run in parallel with M2 once M1 is stable).
5. **M3** — P4 consumer.
6. **M5** — derivative enclosure.

## 5. Non-goals and honesty rules

- Do not claim a zero count, a zero-free region off the critical line, or RH.
- Do not upgrade a numerical Krawczyk probe to a theorem without the Lean
  enclosure and replay.
- Do not put `BigCheck.lean` back into the default build.
- A segment theorem must name its exact rational endpoints and cover.
- If a milestone stalls, record the precise missing lemma or numeric bound in
  `HANDOFF.md` and this roadmap rather than widening the claim.

## 6. Acceptance for the whole roadmap

The roadmap is complete when:

1. M0–M2 are green in the default build — **done**;
2. a kernel-checked zero-free segment wider than `[5, 5.000003]` is stated with
   explicit endpoints — **done** (`[5, 5.000036]`, T514);
3. either M3 or M4 is complete, with the other precisely scoped — **M4 done**
   (`Bzeta.width ≤ 1/2`, T522); M3 is scoped to the missing analytic explicit
   formula in `../finite-explicit-formula`;
4. `README.md`, `index.html`, `HANDOFF.md`, `STATUS.md` and this roadmap agree —
   **done**;
5. both verification commands pass — **done**.

## Critical defect (2026-11-18)

The imported contour explicit-formula theorem is **vacuous at the origin**:

```lean
example : completedZeta 0 = 0 := by simp [completedZeta]
example : (0 : ℂ) * (-1) * completedZeta 0 = 0 := by simp
```

`test_function_explicit_formula` and `contour_shift_paleyWiener` require

```lean
hF_ne : ∀ z ∈ U, z ∉ S → z * (z - 1) * completedZeta z ≠ 0
```

while their hypotheses also require the contour rectangle `[-1,2] × [-T,T] ⊆ U`,
which contains `0`. Since `0 * (-1) * Z 0 = 0`, `hF_ne` is impossible. The
theorems are therefore formally true but **have no instances**.

Consequently T534 (`p4_paleyWiener_empty`), T536 (`p4_tent_empty`) and T539
(`p4_tent_window`) are **vacuous consumers**. They must not be counted as an
M3-finite implementation until the upstream hypothesis is repaired (e.g. by
excluding `0` and `1` from `hF_ne` and reproving differentiability at the
poles).

M3-finite was blocked on this upstream defect. The repair module now provides
`Fext`, the corrected test-function explicit formula
(`test_function_explicit_formula_repair`), the corrected contour shift
(`contour_shift_paleyWiener_repair`), and the non-vacuous finite-window consumer
`p4_paleyWiener_empty_repair` (T543) and the corrected tent consumer
`p4_tent_empty_repair` (T544), with the corrected assembled window
`p4_tent_window_repair` (T546), and the general finite-zero tent formula
`p4_tent_finite` (T547).
