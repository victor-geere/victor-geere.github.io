# Lean formal core — geometric dynamical phase transitions

## Build

```bash
cd the-final-letter/topics/geometric-dynamical-phase-transitions
./lean/check.sh
```

`check.sh` is a three-line wrapper around the shared
[`tools/check-lean.sh`](../../tools/check-lean.sh), which elaborates against the local
Mathlib installation at `~/lean/mathlib4`. The committed [`BUILD.log`](BUILD.log) records the
last successful check. The file imports all of Mathlib, so a cold build can take a few minutes.

## What is formalised

[`Topic.lean`](Topic.lean), [`Bridges.lean`](Bridges.lean), [`LastChord.lean`](LastChord.lean), [`TransferNoGo.lean`](TransferNoGo.lean), [`Tractable.lean`](Tractable.lean), [`MatrixNoGo.lean`](MatrixNoGo.lean), [`SignedF4.lean`](SignedF4.lean), [`LeeYang.lean`](LeeYang.lean), [`Ledger.lean`](Ledger.lean), [`PartialSumTail.lean`](PartialSumTail.lean), [`CertifiedZero.lean`](CertifiedZero.lean), and [`Computations.lean`](Computations.lean) define, in the namespace `GeoDQPT`:

| Definition | Meaning |
|---|---|
| `filterCoeff N m` | the integer filter `c_m^(N) = 1` if `N ∤ m`, `1 - N` if `N ∣ m` (Lemma 2.2); |
| `atomWeight z` | the tempered atomic weight `(1 + |z|²)^{-1}` (Definition 8.1); |
| `atomicMass S` | the total mass of one atom at each point of a finite set `S`. |

`Topic.lean` proves the following seven finite-bookkeeping facts:

| Name | Statement |
|---|---|
| `quadratic_link` | `N² / N = N` for `N ≥ 1`, i.e. the inner length at `M = N²` is the period (Definition 3.1). |
| `filterCoeff_of_not_dvd` | if `N ∤ m` then `c_m^(N) = 1`. |
| `filterCoeff_of_dvd` | if `N ∣ m` then `c_m^(N) = 1 - N`. |
| `filterCoeff_block_sum_zero` | `Σ_{m=1}^{N} c_m^(N) = 0` for `N ≥ 1`, the complete-block mean-zero property of Lemma 3.2. |
| `temperedWeight_pos` | `0 < (1 + t²)^{-1}` for every real `t` (Definition 2.4). |
| `temperedWeight_le_one` | `(1 + t²)^{-1} ≤ 1` for every real `t`. |
| `atomicMass_le_card` | the mass of a finite atomic measure is at most its number of atoms. |

`Bridges.lean` proves the exact gap-bridge lemmas:

| Name | Statement |
|---|---|
| `lastChordAbs_pos` | the absolute last-chord size is positive for `N > 1`; |
| `lastChordAbs_mul_twin` | `L(σ)L(1−σ) = (N−1)²/(4N²)`; |
| `lastChordAbs_twin_eq_iff` | `L(σ) = L(1−σ)` iff `σ = 1/2`; |
| `clock_zero_iff` | `N^(1−s)=1` iff `s = 1 − 2πik/log N` for some integer `k`; |
| `prefactor_lower_bound` | `N^(1−σ) − 1 ≤ |1 − N^(1−σ−it)|`; |
| `local_diagonal_identity` | `∫(1−Rf)(−f) = −∫f + R∫f²` for continuous `f`; |
| `local_diagonal_normalized` | if `∫f=1`, the integral is `−1 + R∫f²`; |
| `dhCoeff_odd` | the period-five Davenport–Heilbronn word is odd; |
| `dhCoeff_mean_zero` | the Davenport–Heilbronn word has mean zero; |
| `dhCoeff_five` | its coefficient on the class `5` is zero; |
| `lastChord_mul_twin_complex` | `H_N(s)H_N(1−s)=(N−1)²/(4N²)` for the complex last chord; |
| `lastChordAbs_eq_half_mul` | `L_N(σ)=½(1−1/N)N^(1−2σ)`; |
| `lastChordAbs_half_tendsto` | `L_N(1/2)→1/2`; |
| `lastChordAbs_tendsto_zero_of_half_lt` | `σ>1/2 ⇒ L_N(σ)→0`; |
| `lastChordAbs_tendsto_atTop_of_lt_half` | `σ<1/2 ⇒ L_N(σ)→∞`; |
| `lastChordAbs_dichotomy` | for `σ≠1/2`, the twins are opposite; |
| `lastChordAbs_ratio` | `L_N(σ)/N^(1−2σ)=1/2−1/(2N)` exactly; |
| `regProd_diag` | every register product has top-left entry `1`; |
| `regProd_topright` | the top-right entry is the coefficient sum; |
| `regCoeff_at_period` | `c_N=1−N`; |
| `regCoeff_at_period_neg` | `c_N<0` for `N>1`; |
| `regMat_coupling_neg` | the coupling at `m=N` is negative for every real `s`; |
| `register_not_ferromagnetic` | not all register couplings are nonnegative; |
| `regProd_topright_polygon` | at `M=N²` the top-right entry is the polygon; |
| `dhXi_pos` | `0<ξ`; |
| `dhXi_lt_one` | `ξ<1`; |
| `dhCoeff_two_abs_ne_one` | `|a₂|≠1`; |
| `UpperTriNN.prod_b_nonneg` | upper-triangular nonnegative products have nonnegative top-right; |
| `etaAtNegOne_two` | the `N=2` polygon at `s=−1` is `−2`; |
| `no_upperTriNN_rep_of_neg` | no such product represents a negative value; |
| `upperTriNN_cannot_represent_eta_two` | the class cannot represent the `N=2` polygon at `s=−1`; |
| `bourgain_threshold_iff` | `(1/2−ε)·13/84<ε ⇔ 13/194<ε`; |
| `bourgain_threshold_pos` | `0<13/194`; |
| `bourgain_threshold_lt_sixth` | `13/194<1/6`; |
| `bourgain_exponent_lt_target` | above the threshold the exponent beats the target; |
| `matProd_nonneg` | a product of entrywise nonnegative matrices is entrywise nonnegative; |
| `contraction_nonneg` | a nonnegative product contracted with nonnegative vectors is nonnegative; |
| `no_nonneg_matrix_product_rep_of_neg` | no nonnegative contraction represents a negative value; |
| `etaTwoNegOne_eq` | the `N=2` polygon at `s=−1` is `−2`; |
| `no_nonneg_matrix_product_rep_eta_two` | no finite bond dimension works; |
| `matProdC_map_conj` | constant-gauge invariance of matrix products; |
| `signedGauge_mul_inv` | `S·S⁻¹=1`; |
| `signedGauge_inv_mul` | `S⁻¹·S=1`; |
| `signedGauge_nonTriangular` | the gauged first matrix has lower-left entry `−1`; |
| `signedGauge_nonTriangular_ne_zero` | that entry is nonzero; |
| `quadratic_no_real_root` | the palindromic quadratic has no real roots; |
| `quadratic_root_normSq_one` | non-real roots have squared modulus `1`; |
| `ising2_lee_yang` | every zero of the two-spin Ising partition function lies on the unit circle; |
| `O2_iff_O1` | O2 ↔ O1 under conversion data; |
| `O4_iff_bourgain` | O4 ↔ the Bourgain exponent inequality; |
| `tsum_eq_finite_add_tail` | finite partial sum + shifted tail = total; |
| `truncation_residual_le_tail_norm` | residual ≤ tail norm; |
| `truncation_residual_le_finset_tail_norm` | arbitrary finite-family tail bound; |
| `truncation_residual_le_three_tails` | three-tail Route C bound; |
| `eta2_zero` | the `N=2` polygon vanishes at `s=0`; |
| `eta2_zero_off_critical` | that zero is not on the critical line; |
| `exists_unique_root_of_sign_change` | sign change + positive derivative gives a unique simple zero; |
| `turing_reduction` | certified subset + count bound exhausts the window; |
| `all_zeros_are_certified` | packaged Route B; |
| `IsolationCertificate.exhausts` | isolation certificate exhausts the window. |

`Computations.lean` proves the forty-one rows T68–T108 of the programme ledger, the former
computation layer.  They are either the finite statement that the Python test checked
(`comp_filterCoeff_cases`, `comp_complete_block_sum`, `comp_lastChord_half_value`, …), a
generalisation of it (`twoSumCoeff_eq_filterCoeff`, `clockZero_isZero`, `gauge_contractionVec`),
or a structural result behind it (`comp_heatFlow_deriv`, `comp_register_matrix`,
`comp_ising_product`).  The file also proves the exact domain guards (`comp_invalid_entries`,
`comp_invalid_boundary`, `comp_invalid_period`).  Most rows state the finite or general proposition the corresponding computation
tested; a small number restate an earlier result (for example
`comp_eta_two`), and those are identified in the dossier ledger rather than
counted as independent discoveries.

No `sorry`, no `axiom`, no `admit`. There is no `rfl`-only padding: the block-sum theorem
proves a divisibility classification over a full block and evaluates the resulting finite sum;
the measure theorem proves a sum bound from the pointwise weight bound; the bridge theorems
prove genuine complex-power, product, reverse-triangle, and interval-integral identities.

The exact bridges close the algebraic part of `truths.md` 11.1–11.2, 14.4 and the corrected
Lemma 6.3. They do not close the analytic gaps.

## What is *not* formalised

The source's analytic and spectral layers are deliberately left outside this file:

- the analytic part of the clock-zero displacement in Lemma F.8 (the algebraic zero set is now `clock_zero_iff`);
- the connection of the last-chord limit theorem to the measure limit (the limit theorem is `lastChordAbs_dichotomy`; the measure layer remains unformalised);
- the infinite purification identity `Σ c_m^(N) m^{-s} = (1-N^{1-s})ζ(s)` and its meromorphic continuation (Lemma 2.2);
- the Euler–Maclaurin remainder of Theorem 4.1 and the depth-of-closure corollaries;
- the path-closure definitions, Rouché/Jensen localisation and exact zero counts (Lemmas 5.5, 9.2–9.6);
- tightness (Theorem 9.1), exclusion of spurious atoms (Theorem 10.1), residual vanishing (Theorem 11.1) and the realisation of the two limit measures (Theorems 12.1–12.2);
- the conversion of the Riemann hypothesis (Corollary 12.3) and the vanishing-aperture jet theorem (Theorem 12.6);
- the Davenport–Heilbronn transfer and sharpness (Addendum C), the straightening field (Addendum E), and all of Addendum F;
- the four remaining numerical certificates: the 40-digit Davenport–Heilbronn DFT eigenvector
  identity (C24) and the three Krawczyk interval certificates C45–C47.  A Lean proof needs
  verified interval arithmetic for `exp`, `log`, `cos` and `sin`; the Python suite checks the
  certificates but does not prove them.

Those are recorded as **Source claim** rows in the [programme README](../README.md), not as
theorems here. In particular, Corollary 12.3 is an *equivalence* between `supp μ = supp ν` and
RH; neither side is proved in this file, and the source itself says the corollary is not a proof
of RH.

## Reusable interval layer

The sibling `~/workspace/rh/research/twin-prime-parity/012` development contains
`lean/IBox.lean` (rational `Iv` intervals and complex `Cx` rectangles, with kernel-checked
`mem_add`, `mem_mul`, `mem_inflate`, …) and `lean/Expr.lean` (a straight-line certificate
language with `wf` and `wf_sound`).  Both compile unchanged against this Mathlib.  They give the
*rational* Krawczyk replay for free.

They do not close the four rows: `IBox`/`Expr` deliberately treat the transcendental leaves
(`log`, `exp`, `sin`, `cos`, and complex division) as trusted atoms, checked by
`012/rigorous/rativ.py`.  `rativ.py` (459 lines) contains the missing rigorous enclosures —
Machin `π`, `atanh`-series `log`, reduced-Taylor `exp`, and `2π`-reduced `sin`/`cos` — but in
Python.  Porting its ~200-line series-bound core to Lean, then replaying the Krawczyk boxes with
`IBox`, is the concrete route to unconditional C45–C47.  The DFT identity C24 is algebraic
(a relation in `ℚ(ζ₂₀)`), not an interval problem.

The two working notes in the source bundle (`nested_spheres_RH`, `continuous_cone_RH_solution`)
claim a geometric proof of RH. They are **not** formalised and are marked withdrawn/rejected in
the README: the canonical paper records their local-diagonal identity as false.

[Back to the programme](../README.md) · [Topic index](../../README.md)
