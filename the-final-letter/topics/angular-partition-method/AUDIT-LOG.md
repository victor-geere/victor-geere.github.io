# Audit and change log

This is the durable log for changes to the O6 exactness audit and for the
O7 continuation work it covers. It records what changed, which audit rows were
affected, and the verification performed. It is not a theorem ledger.

## 2026-11-03 — O6 audit created

- Added [`EXACTNESS-AUDIT.md`](EXACTNESS-AUDIT.md) with the decision rule,
  classification legend and matrix.
- Added [`python/audit.py`](python/audit.py) as the machine-readable matrix.
- Added [`tests/test_audit.py`](tests/test_audit.py) to validate identifiers,
  classes, summaries and the presence of every row in the markdown table.
- Initial audit: **18 objects** (A1–A18).
- Classification summary at that point: E1 = 6, E2 = 7, E3 = 2, X = 1,
  F = 1, O = 1.
- Marked O6 closed in README and index.html.

## 2026-11-03 — O7 continuation integrated

- `lean/Continuation.lean` (added by the O7 session) extends the annular/Mellin
  method beyond the critical strip:
  - T53–T55: sharp first-order bound, convergence/holomorphy on `−1 < Re s`,
    and the extended identity on `−1 < Re s` away from `0,1`;
  - T56–T57: the completed annular part equals `Λ₀`, and the completed
    functional equation is an integral identity;
  - T58–T63: the second Bernoulli subtraction reaches `−3 < Re s`, with the
    `−1/(12(s+1))` pole term explicit and the `s = −1` pole cancelled.
- Audit extended with four rows:
  - **A19** once-subtracted annular continuation — **E3**;
  - **A20** completed annular part / functional equation — **E3**;
  - **A21** second Bernoulli subtraction on `−3 < Re s` — **E3**;
  - **A22** general `k`-th Bernoulli subtraction / full-plane finite part —
    **O**.
- Updated audit summary: **22 objects**; E1 = 6, E2 = 7, E3 = 5, X = 1,
  F = 1, O = 2.
- Updated README/index:
  - O6 row now says 22 objects (A1–A22);
  - O7 marked **Closed** for the doubled/tripled-strip continuation and the
    FE integral identity;
  - new **O8** records the still-open general `k`-th Bernoulli subtraction and
    full-plane finite part;
  - A22 points to O8.
- Updated tests to expect 22 audit rows and the new class counts.

## Verification

```bash
python3 -m pytest tests -q
# 20 passed

./lean/check.sh
# all eight Lean files green
```

No `sorry`, `admit` or `axiom` is present in the Lean files.

**No RH proof yet.** O7 is a continuation of the finite-part annular identity,
not a proof of the Riemann hypothesis.

## 2026-11-03 — Lean code aligned with audit evidence

The audit identified four rows whose evidence was text-only or incomplete.
All four were formalised in `lean/Topic.lean`:

- **A4** normalized halving-sector total:
  `half_turn_sector_hasSum`, `half_turn_sector_tsum` (T64);
- **A6** exact divergence of reciprocal weights:
  `not_summable_inv_nat_succ` (T65);
- **A16** infinite complex geometric series:
  `geometric_hasSum_complex`, `geometric_tsum_complex` (T66);
- **A18** layer-cake representation:
  `layer_cake` (T67).

No audit classification changed, so the summary remains 22 objects:
E1 = 6, E2 = 7, E3 = 5, X = 1, F = 1, O = 2.

The theorem ledger now runs to T67. The Lean build and pytest suite were
re-run after the change.

## 2026-11-03 — O5 Bost–Connes closure

Added `lean/BostConnes.lean` and extended the audit:

- **A23** single-prime Bost–Connes angular series — **E1**;
- **A24** all-prime Bost–Connes Euler product — **E2**;
- **A25** prime-log commensurability obstruction — **X**.

New theorems T68–T72:

- `bostConnes_single_prime_angular`, `bostConnes_single_prime_tsum`;
- `bostConnes_all_primes_product`, `bostConnes_all_primes_tprod`;
- `log_primes_not_commensurable`.

O5 is marked **closed** for the exact convergence-domain angular sums and the
commensurability obstruction. The audit summary is now **25 objects**:
E1 = 7, E2 = 8, E3 = 5, X = 2, F = 1, O = 2. O8 remains open.

## 2026-11-03 — finite Gram positivity formalised

Added `lean/Gram.lean` with T73–T76:

- `gramQuad_eq_norm_sq` — the Gram quadratic form is a squared norm;
- `gramQuad_nonneg` — finite Gram positivity;
- `gramMatrix_posSemidef` — every finite Gram matrix is PSD;
- `gramMatrix_quadForm_nonneg` — matrix quadratic form nonnegativity.

This is the finite algebraic shadow suggested by the Gram matrix in
`absolute-polarized-hodge-index-realization`. It applies to annular/sector
indicator vectors but does **not** prove the analytic Weil positivity
statement. O4 therefore remains open; its row now points to the finite shadow
T73–T76 while retaining the analytic gap.

## 2026-11-03 — continuous Hurwitz-zeta coil formalised

Added `lean/ContinuousCoil.lean` with T77–T80:

- `hasSum_shiftedZetaKernel` — the shifted geometric kernel;
- `hasSum_mellin_shiftedZetaKernel` — the shifted Mellin series;
- `mellin_shiftedZetaKernel_eq` — the Hurwitz-zeta integral representation;
- `continuousCoil_eq_integral` — the continuous coil as a normalized integral.

This formalises the section-2 integral representation and the replacement of
the discrete annular coil by a continuous spiral for `x > 0`, `Re s > 1`.
Analytic continuation beyond `Re s > 1` remains outside the statement.

## 2026-11-03 — T81: continuous integral closed form formalised

Added to `lean/ContinuousCoil.lean` and re-checked T80:

- `continuousIntegralCoil` — the power-law coil `x^(1−σ)/(σ−1)`;
- `integral_Ioi_rpow_neg_eq_inv_sub_one` — **T81**:
  `∫_1^∞ x^(−σ) dx = 1/(σ−1)` for `σ > 1`;
- `integral_Ioi_rpow_neg_eq_continuousIntegralCoil` — the coil is the tail
  integral `∫_x^∞ t^(−σ) dt = x^(1−σ)/(σ−1)` for `x > 0`;
- `hasDerivAt_continuousIntegralCoil` — `−Z_c′(x) = x^(−σ)`, so the term is
  the negative derivative of the tail.

`continuousCoil_eq_integral` (T80) recompiled unchanged. This closes the
text-proof gap of §5.7 for the real integral and coil statements; the complex
self-similarity ratio of §5.7 was not yet formalised at that point (see the T82
entry below).

## 2026-11-04 — T82: complex coil self-similarity formalised

Added to `lean/ContinuousCoil.lean`:

- `continuousComplexCoil` — the complex power-law coil
  `Z_c(x) = x^(1−s)/(s−1)`;
- `cpow_selfSimilar_factor` — for `s = σ + it`, `t ≠ 0`,
  `(e^(2π/|t|))^(1−s) = e^(−2π(σ−1)/|t|)`: the imaginary part of the exponent
  is an integer multiple of `2π` and contributes `1`;
- `continuousComplexCoil_selfSimilar` — **T82**:
  `Z_c(e^(2π/|t|)x) = e^(−2π(σ−1)/|t|)Z_c(x)` for `x > 0`, `σ > 1`, `t ≠ 0`.

The proof uses `Complex.mul_cpow_ofReal_nonneg`, `Complex.cpow_def_of_ne_zero`,
`Complex.log_mul_ofReal`, `Complex.exp_add` and `Complex.exp_mul_I`; no branch
cut is crossed. §5.7 is now Lean-checked for all three statements (integral,
coil derivative, self-similarity).

## 2026-11-04 — Bost–Connes continuation beyond the convergence domain (T83–T85)

Added to `lean/BostConnes.lean`:

- `bostConnesSinglePrime` — the continued single-prime sum `1/(1−p^(−s))`;
- `meromorphicOn_bostConnesSinglePrime`,
  `differentiableAt_bostConnesSinglePrime`,
  `bostConnes_single_prime_continuation` — **T83**: the closed form is
  meromorphic on `ℂ`, holomorphic where `p^(−s) ≠ 1`, and agrees with the
  angular series on `Re s > 0`;
- `bostConnesSinglePrime_pole_iff` — **T84**: the poles are exactly
  `s log p = 2πik`, `k ∈ ℤ` (stated in multiplied form);
- `bostConnes_all_primes_continuation` — **T85**: the Euler product equals
  `ζ` on `Re s > 1`, and `ζ` is differentiable away from its only pole at
  `s = 1`.

This closes the Bost–Connes continuation without the general-`k` Bernoulli
subtraction: O8 remains open as the constructive arbitrary-`k` integral
estimate, but it is not needed for these continuation values. The pole
characterisation uses `Complex.exp_eq_one_iff` and
`Complex.log` of a positive integer; no analytic continuation of the geometric
series is assumed.

## 2026-11-04 — §7.5 corrected: intrinsic monodromy versus the `w = e^(−s)` quotient

A supplied comparison table (ζ, η, harmonic/digamma, general Dirichlet, Lerch)
classified these objects as having trivial monodromy in the `s`-plane. That is
correct and does not contradict §7.5, but the section had conflated two
statements. It now distinguishes:

- **intrinsic monodromy in `s`:** trivial for ζ, η, the digamma continuation,
  and general Dirichlet; non-trivial only for Lerch (in its parameter);
- **monodromy of the `w = e^(−s)` quotient:** because ζ is not `2πi`-periodic,
  the descended function is multi-valued with infinite cyclic monodromy
  `s ↦ s + 2πi`; the universal cover (the `s`-plane) is its natural home.

The section also corrects two misstatements: `w = 0` is an isolated essential
singularity of `w ↦ ζ(−log w)`, not a natural boundary (the Dirichlet series
has radius `e^(−1)`), and ζ is not meromorphic on the Riemann sphere (it has an
essential singularity at `∞`; a function meromorphic on `ℂP¹` would be
rational). No Lean statement changes; the correction is textual and is
reflected in `README.md` §7.5 and `index.html` §7.5.

## 2026-11-04 — O8 started: kernel analyticity at zero (T86)

Added `lean/GeneralSubtraction.lean` with the analytic foundation of the
general Bernoulli subtraction:

- `generalKernelC` — the complex kernel `1/(e^z−1) − 1/z`;
- `norm_exp_sub_one_ge` — `‖z‖/2 ≤ ‖e^z−1‖` for `‖z‖ ≤ 1/2`;
- `norm_generalKernelC_le` — `‖1/(e^z−1) − 1/z‖ ≤ 2` on `0 < ‖z‖ ≤ 1/2`;
- `analyticAt_generalKernelC_zero` — **T86**: the kernel has a removable
  singularity at `0`, and its extension is analytic at `0`.

The proof uses `Complex.norm_exp_sub_one_sub_id_le` and Riemann's removable
singularity theorem (`Complex.differentiableOn_update_limUnder_of_bddAbove`).
This is the input for the Taylor-remainder induction: analyticity at `0` gives
a Taylor expansion to every order. O8 is now **Partial**: the remaining work is
the Taylor-polynomial extraction of degree `2k−1`, the uniform `O(t^(2k))`
remainder bound, and the Mellin identity for arbitrary `k`. `GeneralSubtraction.lean`
is added to `lean/check.sh`.

## 2026-11-04 — O8 continued: Taylor remainder, coefficients, subtracted-kernel bound (T87–T89)

Added to `lean/GeneralSubtraction.lean`:

- `generalKernelExt` — the analytic extension of the kernel at zero;
- `exists_taylorRemainder` — **T87**: for every `n` there is a power series
  `p` at `0` with `HasFPowerSeriesAt generalKernelExt p 0` and
  `(generalKernelExt z - p.partialSum n z) = O(‖z‖^n)`;
- `partialSum_eq_sum_coeff` — **T88**: the partial sums are the polynomials
  `Σ_{k<n} p.coeff k · z^k`;
- `zetaKernelR`, `cutoffN`, `subtractedKernel` — the real kernel, the cutoff
  `1/t + P_n(t)`, and the subtracted kernel;
- `subtractedKernel_isBigO_zero` — **T89**: the real `n`-th subtracted kernel
  is `O(t^n)` at `0`, which is the hypothesis of Mathlib's
  `mellinConvergent_of_isBigO_rpow_exp`.

Remaining for O8: local integrability of the subtracted kernel, the Mellin
convergence on `Re s > -n`, the Mellin transform of the cutoff, and the
finite-part identity. The build is green on all 12 files.

## 2026-11-04 — O8 finite-part identity on the convergence domain (T90–T91)

Added to `lean/GeneralSubtraction.lean`:

- `cutoffMain`, `cutoffTerm`, `hasMellin_finset_sum` and
  `hasMellin_cutoffN` — **T90**: the Mellin transform of the polynomial
  cutoff `1/t + P_n(t)` on `(0,1]` is `1/(s−1) + Σ_{k<n} c_k/(s+k)` for
  `Re s > 1`;
- `zetaKernelR_eq_zetaKernel` — bridge to the dossier's zeta kernel;
- `mellin_subtractedKernel_eq` — **T91**: for `Re s > 1`,
  `mellin K_n(s) = Γ(s)ζ(s) − 1/(s−1) − Σ_{k<n} c_k/(s+k)`.

The file now imports `RegularizedIntegral` to reuse the zeta Mellin
representation. Remaining for O8: local integrability of `K_n`, the Mellin
convergence on `Re s > −n` (T89 supplies the `O(t^n)` input), and the
analytic extension of the identity from `Re s > 1` to `Re s > −n`. The build
is green on all 12 files.

## 2026-11-04 — O8 convergence on `Re s > −n` (T92–T93)

Added to `lean/GeneralSubtraction.lean`:

- `continuousOn_zetaKernelR`, `continuousOn_cutoffFormula`,
  `locallyIntegrableOn_subtractedKernel` — local integrability of the
  subtracted kernel on `(0,∞)`, splitting compact subsets at `t = 1`;
- `subtractedKernel_isBigO_atTop` — exponential decay, via
  `norm_zetaKernel_le_two_exp_neg`;
- `mellinConvergent_subtractedKernel` — **T92**: convergence on `−n < re s`,
  using T89 and Mathlib's `mellinConvergent_of_isBigO_rpow_exp`;
- `mellin_differentiableAt_subtractedKernel` — **T93**: holomorphy there.

Remaining for O8: the identity itself on `Re s > −n`. The obstruction is the
agreement of the Taylor coefficients `p.coeff k` with the residues of `Γζ` at
`−k` (the Bernoulli/zeta value relation); without it the right-hand side has
poles where the left-hand side is holomorphic, so the identity cannot extend.

## 2026-11-04 — O8: formal Bernoulli core of the residue relation

Added `lean/BernoulliZeta.lean`, the algebraic half of the missing
Bernoulli/zeta residue relation:

- `expm1DivX` — the formal series `(e^X−1)/X = Σ X^n/(n+1)!`;
- `X_mul_expm1DivX` — `X · expm1DivX = e^X − 1`;
- `bernoulliPowerSeries_mul_expm1DivX` — `B(X) · (e^X−1)/X = 1`;
- `gSeries` — the formal series `(B(X)−1)/X`;
- `X_mul_gSeries` — `X · gSeries = B(X) − 1`;
- `gSeries_coeff` — `gSeries.coeff k = bernoulli (k+1)/(k+1)!`.

This is the coefficient identity needed for the cancellation of the poles of
`Γζ` at `−k`. The remaining step is the analytic identification: the Taylor
series of `1/(e^z−1) − 1/z` at `0` equals `gSeries`. That will be proved from
the identity `z·E(z)·g(z) = 1 − E(z)` with `E(z) = (e^z−1)/z`, whose Taylor
series is `expm1DivX`. `BernoulliZeta.lean` is added to `check.sh`.

## 2026-11-04 — O8: kernel and formal identities (T95)

Added the two sides of the coefficient-comparison argument:

- `kernel_mul_identity` — `z(e^z−1)g(z) = z−(e^z−1)` for `z ≠ 0`,
  `e^z ≠ 1`;
- `X_mul_exp_sub_one_mul_gSeries` — the formal counterpart
  `X(e^X−1)(B−1)/X = X−(e^X−1)`.

These show that the Taylor series `p` of the kernel and the Bernoulli series
`gSeries` satisfy the same algebraic equation. The remaining step is the
product-of-power-series comparison. Mathlib currently has no
`HasFPowerSeriesAt.mul` (nor a product operation on `FormalMultilinearSeries`),
so that comparison needs its own construction; the analytic generating-function
route is the alternative.

## 2026-11-04 — O8: Cauchy-product brick (T96)

Added `hasSum_mul_range` to `BernoulliZeta.lean`: for absolutely summable scalar
series `a,b` with sums `A,B`, the range convolution
`Σ_{k≤n} a k * b (n−k)` has sum `A·B`. This is the `HasSum` form of Mathlib's
`tsum_mul_tsum_eq_tsum_sum_range_of_summable_norm`, and it is the product brick
needed to compare the Taylor series `p` with `(B−1)/X`.

Remaining for O8: use this brick with the kernel identity
`z(e^z−1)g(z) = z−(e^z−1)` to prove the coefficient equality
`p.coeff k = gSeries.coeff k`, then extend the finite-part identity to
`Re s > −n`.

## 2026-11-04 — O8: product of scalar power series (T97)

Added `hasFPowerSeriesAt_mul_ofScalars` to `BernoulliZeta.lean`: if `f,g` have
scalar power series `a,b` at `0`, then `f*g` has the Cauchy-product series.
This is the `HasFPowerSeriesAt.mul` that Mathlib lacks, built from T96 and the
`HasFPowerSeriesAt`-as-HasSum characterisation.

Remaining for O8: apply T97 to `e^z−1` and the kernel, identify the product
series with `1−(e^X−1)/X`, compare coefficients with `(B−1)/X`, and extend the
finite-part identity to `Re s > −n`.

## 2026-11-04 — O4: finite zero sum and explicit tail bound (local library)

The finite zero sum is now connected to the pole terms and given an explicit
tail bound, using the local Hermetic Lean library (`index-lean.md`):

- `AbsoluteHodgeExplicitFormula.test_function_explicit_formula`
  (`absolute-polarized-hodge-index-realization/lean/ExplicitFormula.lean`):
  `∮ (Z'/Z)·h = 2πi·(∑_{ρ∈S} h(ρ) − h(0) − h(1))` for a finite zero set `S`
  in a rectangle, simple and exhaustive there. The `−h(0)−h(1)` are the same
  pole residues as T51–T52.
- `AbsoluteHodgeRectangle.norm_rectIntegral_le` and
  `AbsoluteHodgeExplicitFormula.zero_sum_tail_bound` (new
  `absolute-polarized-hodge-index-realization/lean/TailBound.lean`): for two
  rectangles with zero sets `S` and `S'` (nested when read as a tail) and
  `‖(Z'/Z)·h‖ ≤ M` on both boundaries,
  `‖∑_{S'} h(ρ) − ∑_S h(ρ)‖ ≤ (M/2π)·(perimeter' + perimeter)`.

Caveat: the tail theorem is conditional on the two explicit-formula
identities and on a boundary supremum `M`. It is not yet instantiated with a
specific certified zero set, because that needs the exhaustive-zero hypothesis
("no other zeros in the rectangle"); the finite-window certificates provide
individual zeros and non-vanishing segments, not counts.

O4 is therefore **Partial**: the finite zero sum, the pole terms and the tail
bound are Lean-proved; the analytic Gram/positivity theorem remains open.

## 2026-11-04 — O4 goal started: local-library bridge documented

Added §7.9 to `README.md` and `index.html`, wiring the local Hermetic Lean
library into the O4 dossier:

- finite zero side: `test_function_explicit_formula` (local library);
- truncation error: `zero_sum_tail_bound` (local library);
- finite Gram route (M0′): the rational shadow certificate in
  `prime-spectrum-tensor`, which certifies the rounded matrix only.

The missing input for the exact finite certificate is a rigorous enclosure of
the archimedean integral `Ω(t) = Re ψ(1/4 + it/2) − log π` and the prime tail,
plus a transfer from the shadow matrix to the exact transcendental matrix.
O4 remains Partial; the goal is active.

## 2026-11-04 — O4 handoff written (Option B)

Added [`HANDOFF-O4.md`](HANDOFF-O4.md), scoping the remaining finite Gram
certificate as its own goal: the rational centre/error transfer (W1), the
digamma/Ω interval bounds (W2), rigorous quadrature and prime tails (W3), the
exact Gram matrix and `PosDef` assembly (W4), and the ledger update (W5).

The handoff records the existing Lean lemmas, the Python C9–C22 interval
certificate, the exact rational data (`t = 0.0209751863`, positive leading
minors of `centre − t·I`), and the key audit item that an entrywise error bound
does not by itself give the Loewner bound `G ⪰ centre − tI`. Linked from
§7.9 and the O4 ledger row.
