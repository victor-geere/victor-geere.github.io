# Proofs

This is the proof ledger of the unified programme. It separates five things that are often conflated:

1. **Proved in the source** — a written proof in a paper or ledger.
2. **Machine-checked** — a Lean proof in the source repository.
3. **Conversion** — a proved equivalence that does not prove either side.
4. **Sharpness/litmus** — a proved negative result showing that a class of methods cannot close the wall.
5. **Certified computation** — a Lean-checked finite calculation with a replayable certificate, not an asymptotic theorem.

## A. The Riemann side

### A1. The conversion theorem

**Statement.** The following are equivalent:

1. every non-trivial zero of `Ξ` lies on the critical line;
2. every unrestricted path-closure is balanced for all sufficiently large `N`;
3. every weak-star limit of the unrestricted measures is supported on the critical line;
4. the balanced and unrestricted limiting measures coincide, with common support the non-trivial zeros.

**Status:** proved equivalence; it does not prove RH.

Source: [`summary/05`](../../summary/05-spectral-measures-and-tightness/13-corollary-12.3.md), `publication.html` Corollary 12.3.

### A2. The Davenport–Heilbronn sharpness theorem

**Statement.** At Spira’s off-line zero `ρ_DH = 0.80851718… + 85.69934849… i`, the relative test fires and the prefactor test fails, so the DH measures have different supports. The conversion returns the correct verdict where RH is false.

**Status:** proved. It shows the conversion is sharp.

Source: [`summary/06`](../../summary/06-davenport-heilbronn/09-theorem-c.9.md).

### A3. The limitative consequence

**Statement.** No theorem deducible from the additive toolbox (Euler-sum pair, Euler–Maclaurin, Jensen, Rouché, minimum principle, Riemann–von Mangoldt, classical floor) can imply RH. Any such theorem would apply verbatim to the DH twist and contradict A2.

**Status:** proved. This is the formal version of “the additive toolbox cannot prove RH.”

Source: [`summary/06`](../../summary/06-davenport-heilbronn/10-corollary-c.10.md).

### A4. The tensor refutation and repair

**Statement.** The proposed inequality `(★)` is false; the witness gives `−0.677302…`. The correct positive statement is Weil positivity for the repaired current `W`; its spectral resolution is exactly the zero measure.

**Status:** proved (Theorem B and Theorem C in `tensor.md`).

Source: [`summary/10`](../../summary/10-prime-spectrum-tensor/README.md).

### A5. The modular shadow and straightening field

**Statement.** The modular shadow is exact at positive integer weight and has no transfer to complex zeros. The straightening field’s holonomy is the zero count; under the Rouché condition (E.1), the count is computable from two finite Euler sums.

**Status:** proved, with (E.1) as an explicit hypothesis.

Source: [`summary/07`](../../summary/07-modular-shadow/README.md), [`summary/08`](../../summary/08-straightening-field/README.md).

## B. The parity side

### B1. The factor-complexity law

**Statement.** For the greedy word, with `L ≥ max(span, a_m+1)`,

```
p(L) = min(a_m+1, N−L+1) + [L ≤ N−a_m−1].
```

**Status:** proved; Lean-certified in `Rh41`.

Source: [`summary-rh/01/02`](../../summary-rh/01-ledger/02-the-greedy-digit-word-and-the-complexity-law-rh41.md).

### B2. Budgets, Brown reachability, parity lock

**Statement.** `P = 2^{−p}ζ`, `N = (1−2^{−p})ζ−1`, `P+N = ζ−1`, `P−N = 1−η`, `P > N`; Brown’s criterion; the signed support is parity-locked.

**Status:** proved; Lean at `p=2,4`.

Source: [`summary-rh/01/03`](../../summary-rh/01-ledger/03-budgets-reachability-and-the-tau-alphabet-rh42.md).

### B3. Balance and the equal split

**Statement.** `P_N + M_N = Re S_N`; balance is equivalent to `Re S_N = 0`; balance is attained for every `N ≥ 2`; `S_3(t) ≠ 0` for all `t`; `S_2(π/log 2) = 0`.

**Status:** proved; Lean-certified.

Source: [`summary-rh/01/04`](../../summary-rh/01-ledger/04-partial-sums-at-re-s-0-and-the-equal-split-rh43.md).

### B4. Smoothing does not remove `√N`

**Statement.**

```
|S_N^φ(1/2+it) − ζ(1/2+it)| / √N → |M_φ(s)|,
```

with `M_φ(s)=∫₀¹ φ(u)u^{−s}du`.

**Status:** proved (paper) + verified numerically.

Source: [`summary-rh/01/05`](../../summary-rh/01-ledger/05-the-smoothing-bridge-rh044.md).

### B5. The corrected explicit formula

**Statement.** The Weil explicit formula with the archimedean term; `N(T)=θ(T)/π+1+S(T)`; finite-window certificates `T=15`, `T=33`.

**Status:** proved (paper) + verified; the `T=15/33` certificates are unconditional finite-window statements, not RH.

Source: [`summary-rh/01/06`](../../summary-rh/01-ledger/06-the-explicit-formula-and-routes-a-b-c-rh45-010.md).

### B6. Finite-prefix indeterminacy

**Statement.** For every `a ≠ 0` and every `h`, there is a function `g` that agrees with `λ` below `a`, differs from `λ`, and reproduces `corr h N` on every prefix with `N+h<a`. The slice perturbation at the flipped index is

```
corrSlice h a a − corr h a = −2λ(a)λ(a+h) − 2λ(a−h)λ(a).
```

**Status:** proved; Lean-certified.

Source: [`summary-rh/01/07`](../../summary-rh/01-ledger/07-two-point-chowla-and-the-finite-prefix-theorem-rh46.md).

### B7. Sylvester sparsity and no Euler product

**Statement.** The greedy support satisfies `m_{i+1} ≥ m_i(m_i−1)+1`, density `≈3.9·10⁻⁵`; `f(n)=λ(n)λ(n+2)` is not multiplicative; no Euler product.

**Status:** proved + verified; `shiftProd` non-multiplicativity Lean-certified.

Source: [`summary-rh/01/08`](../../summary-rh/01-ledger/08-greedy-sine-vs-the-parity-barrier-rh47.md).

### B8. One-point Chowla is PNT

**Statement.** `Σ_{n≤x}λ(n)=o(x)` is equivalent to PNT.

**Status:** theorem (classical). Correction X1.

Source: [`summary-rh/04/03`](../../summary-rh/04-programme/03-corrections-x1-x6.md).

## C. The certified evaluation layer

Objective III is the programme's positive computation layer. It is not a proof of either wall; it is the machine-checked instrument a finite-scale claim can use instead of floating point. The full 51-row theorem ledger and the 14-row computation ledger are in [`topics/partial-sum-plus-tail`](../../topics/partial-sum-plus-tail/README.md#theorem-ledger).

| Group | What is proved | Lean theorems | Evidence |
|---|---|---|---|
| C1 | Rational interval addition, negation, subtraction, scaling, multiplication and inflation are sound; the same six laws hold over `ℝ`; complex boxes obey the same laws. | `PartialTail.Iv.mem_add` … `mem_inflate`, `Iv.memR_*`, `PartialTail.Cx.mem_*` | T1–T13, `IBox.lean` |
| C2 | An accepted straight-line certificate encloses the value it denotes. `Expr.wf` recomputes every box; `Expr.wf_sound` is the soundness theorem. | `PartialTail.Expr.wf_sound` | T14, `Expr.lean` |
| C3 | A finite partial sum plus the shifted tail is the total; the truncation residual is bounded by the tail norm, for arbitrary finite families and for the three-tail case. | `PST.tsum_eq_finite_add_tail`, `PST.truncation_residual_le_tail_norm`, `PST.truncation_residual_le_finset_tail_norm`, `PST.truncation_residual_le_three_tails` | T15–T18, `Topic.lean` |
| C4 | The eta partial sum splits exactly into the cos series and minus the sin series. | `PST.etaTerm_re`, `PST.etaTerm_im`, `PST.etaPartial_re`, `PST.etaPartial_im` | T19–T24, `Topic.lean` |
| C5 | The concrete ζ(2) replay is accepted, and every atom is discharged, so its final box encloses the replay value with no atom hypothesis. | `PartialTail.Replay.cert_mem`, `Replay.cert_mem_closed` | T25, T32, `Replay.lean`, `ReplayAtoms.lean` |
| C6 | `π`, `exp`, `log`, `sin` and `cos` are enclosed on the required rational intervals, with concrete kernel-checked instances. | `piIv_memR`, `expIvGeneral_memR`, `logIv_memR`, `cosBox_memR`, `sinBox_memR`, `cosReduce_memR`, `sinReduce_memR`; `log_two_check`, `exp_one_check`, `sin_one_check`, `cos_one_check`, `piIv_check` | T26–T31, `Transcend.lean` |
| C7 | S3–S5: the integer zeta bound, the eta identity, and the `L`-function as a finite Hurwitz sum. | `riemannZeta_nat_re_le`, `eta_eq_one_sub_two_cpow_mul_zeta`, `LFunction_eq_hurwitz_sum` | T33–T35, `SourceClaims.lean` |
| C8 | Euler–Maclaurin: the finite identity for smooth functions and for the Hurwitz term; Fourier inversion and the Bernoulli supremum bound; differentiability and iterated derivatives of the non-periodic zeta; the integral form of the tail bound; the S1 decomposition and the explicit S2 tail bound, for `K ≥ 1`. | `finite_eulerMaclaurin`, `finite_eulerMaclaurin_hurwitz`, `hasSum_periodicBernoulli_fourier`, `iSup_norm_periodicBernoulli_odd_le_zeta`, `differentiableAt_hurwitzZetaNP`, `iteratedDeriv_hurwitzTerm_eqOn`, `integrableOn_iteratedDeriv_hurwitzTerm`, `norm_integral_periodicBernoulli_mul_odd_le`, `hurwitzZetaNP_eq_eulerMaclaurin`, `hurwitzZetaNP_eulerMaclaurin_with_bound` | T36–T43, `EulerMaclaurin.lean` |
| C8a | **P1, rectangle form:** the S1/S2 theorem is consumed by a closed rational enclosure of `ζ(s)` for every `s` with `Re s > 1`, arbitrary `M ≥ 1`, `K ≥ 1`, with no atom hypothesis; checked at ζ(2). Domain bridge, power/integral/derivative/Bernoulli/tail radii, and assembly. | `zeta_eq_hurwitzZetaNP_one`, `norm_cpow_neg_le_radius`, `norm_cpow_neg_sub_le`, `norm_integral_le_radius`, `norm_iteratedDeriv_le`, `norm_bernoulli_le`, `riemannZeta_nat_re_le_two`, `norm_tail_le`, `zeta_mem_box`, `zeta_two_mem_box` | T44–T49, `ReplayGeneral.lean` |
| C8b | **P2:** a target-width certificate format. `Cx.width`; `Expr.wfWidth` checks well-formedness and a width target; `wfWidth_sound` proves that acceptance yields a box no wider than the target; the ζ(2) replay is accepted at `10⁻⁴`. The R14 template `ne_zero_of_mem_of_not_mem_zero` is also recorded. | `Cx.width`, `Expr.wfWidth`, `Expr.wfWidth_sound`, `Replay.cert_wfWidth`, `cert_mem_width`, `ne_zero_of_mem_of_not_mem_zero` | T50–T51, `Width.lean`, `WidthCheck.lean`, `EnclosureHypothesis.lean` |

The two analytic inputs are now Lean theorems (C8) for `K ≥ 1`:

| # | Claim | Status |
|---|---|---|
| S1 | Euler–Maclaurin decomposition of `ζ(s,a)` into partial sum, Bernoulli corrections and tail. | Lean-proved for `K ≥ 1`: `hurwitzZetaNP_eq_eulerMaclaurin` |
| S2 | Explicit tail bound `\|R_K(s)\| ≤ \|(s)_{2K+1}\| · 2ζ(2K+1)/(2π)^{2K+1} · b^{−σ−2K}/(σ+2K)`. | Lean-proved for `K ≥ 1`: `hurwitzZetaNP_eulerMaclaurin_with_bound` |

S3–S5 are Lean theorems (C7): `riemannZeta_nat_re_le`, `eta_eq_one_sub_two_cpow_mul_zeta`, and `LFunction_eq_hurwitz_sum`. The written proof that the Lean layer follows is [`notes/euler-maclaurin-proof.md`](../../topics/partial-sum-plus-tail/notes/euler-maclaurin-proof.md).

**Status of the layer.** The rational cell, the certificate checker, the truncation transport, the eta split, the transcendental enclosures, the Euler–Maclaurin layer, a closed rectangle enclosure for `Re s > 1`, and a target-width certificate format are Lean-proved with no `sorry`, `axiom` or `admit`. The Euler–Maclaurin decomposition and the explicit tail bound are theorems for `K ≥ 1`, and C9 is their first consumption by a closed enclosure. What remains is engineering plus one analytic extension: the eta reduction to `0 < Re s ≤ 1`, a symbolic single-`Expr` emission, a symbolic width theorem, and using a certified critical-strip enclosure as a hypothesis. No theorem about either wall uses a certified enclosure as a hypothesis yet; R13–R15 in [Further research](../09-further-research/further-research.md) state what that would take.

Source: [`topics/partial-sum-plus-tail`](../../topics/partial-sum-plus-tail/README.md), `~/workspace/rh/research/twin-prime-parity/012/`.

## D. The Lean spine

The `the-final-letter/lean/` development builds against the same Lean 4 + Mathlib installation as `~/workspace/rh`:

```
cd the-final-letter/lean
./check.sh --all
# [check] OK FinalLetter/Chowla.lean
# [check] OK FinalLetter/Synthesis.lean
# [check] OK FinalLetter.lean
```

- `FinalLetter/Chowla.lean` is the vendored, `sorry`-free finite-prefix development from `rh46`.
- `FinalLetter/Synthesis.lean` defines `RiemannHypothesis`, `TwinPrimeConjecture`, `ChowlaTwoPoint`, `corrOf`, `AgreesBelow`, and proves `finite_prefix_indeterminacy`, `slice_perturbation`, `finite_prefix_witness`, `corr_abs_le`, `corr_zero`, `corrAsymptotic_zero_false`, `shiftProd_not_completely_multiplicative`, and `slice_l2_mass`.
- The open statements are `def`s, not `axiom`s. The build contains no `sorry` and no new axiom.

See [Lean formalisation](lean.md) for the theorem inventory and build instructions.

## E. What is not proved

RH, the twin-prime conjecture, Chowla for `k ≥ 2`, Sarnak, Elliott, `(M)`, OP-19, F.4, `Λ=0`, the Jensen/Li tower, and uniform slow passage. The evaluator's Euler–Maclaurin identity and explicit tail bound are Lean theorems for `K ≥ 1`, a closed rectangle enclosure for `Re s > 1` and a target-width certificate format are also proved, but the evaluator is still not consumed by a wall theorem and no symbolic width theorem is proved. The proof ledger is not a proof of the walls; it is a proof of the map.

[Back to README](README.md) · [Back to index](../../index.html)
