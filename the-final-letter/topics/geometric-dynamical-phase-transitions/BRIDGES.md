# Gap bridges for the geometric DQPT programme

This file records what has actually been bridged between the open gaps of `publication.html` and the reference bundle. It separates three outcomes:

- **Closed** — an exact statement is now proved in Lean and checked in Python.
- **Reduced** — the gap is now a precise lemma or conditional input, not an unspecified obstruction.
- **Open / obstructed** — the gap remains open, or a proposed route is ruled out for a stated representation.

Nothing here proves the Riemann hypothesis. The conversion `supp μ = supp ν ⇔ RH` remains an equivalence, and the equality side remains open.

## Gap map

| # | Gap | Before | Bridge result | Status after |
|---|---|---|---|---|
| B1 | Last-chord product and unique self-dual abscissa | Algebra stated in `truths.md` 11.1–11.2 and 14.4, not in the topic Lean core | `lastChordAbs_mul_twin`: the product is exactly `(N−1)²/(4N²)`; `lastChordAbs_twin_eq_iff`: the two twin sizes agree iff `σ = 1/2` | **Closed** |
| B2 | Clock zeros of `1 − N^(1−s)` | Lemma F.8 uses them analytically; the algebraic classification was not formalised | `clock_zero_iff`: `N^(1−s)=1` iff `s = 1 − 2πik/log N`, `k ∈ ℤ` | **Closed** (algebraic part); the displacement estimate remains a source claim |
| B3 | Prefactor lower bound `N^(1−σ) − 1 ≤ |1 − N^(1−s)|` | Used throughout the prefactor test; not formalised | `prefactor_lower_bound`: reverse triangle inequality for the complex power | **Closed** |
| B4 | Corrected local diagonal of Lemma 6.3 | The withdrawn working notes used `∫(1−Rφ)(−φ) = −1/2`; the canonical value is `−1 + R∫φ²` | `local_diagonal_identity` proves the algebraic identity for continuous `φ`; `local_diagonal_normalized` gives `−1 + R∫φ²` when `∫φ=1` | **Closed (negative result)**: the `−1/2` route is formally excluded |
| B5 | Register-only ferromagnetic representation (F.4) | Remark F.12 says the register weights are negative at multiples of `N` | Python and Lean ledger record `c_N = 1−N < 0`; the register basis cannot be made ferromagnetic by reweighting | **Obstructed for register-only representations**; the interacting transfer-operator form of F.4 remains open |
| B6 | Heat-flowed register (Remark F.13(c)) | Listed as a tractable item, not implemented | `heat_flowed_polygon` implements `Σ c_m exp(τ(log m)²)m^(−s)`; at `τ=0` it reduces exactly to the polygon | **Computation-level bridge**; the zero-vs-τ tabulation is not a theorem |
| B7 | O1/O2: RH and `supp μ = supp ν` | Open equivalence | Exact last-chord dichotomy reduces the arithmetic side to: an off-line zero forces one twin to 0 and the other to ∞, while the product stays `1/4` | **Reduced, still open** |
| B8 | O3: hypothesis (M) | Open | No new input; the Davenport–Heilbronn sharpness remains the litmus | **Open** |
| B9 | O4: uniform slow passage and isolation | Conditional on Lindelöf/random-matrix input beyond `ε > 13/194` | Reduced to the explicit inputs `|ζ'(ρ)| ≤ N^ε` and a pair-correlation/isolation bound; the prefactor clause is now formalised (B3) | **Reduced, still open** |
| B10 | Formalisation gap: Euler–Maclaurin, Rouché, tightness, measure limits, conversion | Not formalised | The exact algebraic skeleton (filter, last chord, clock zeros, prefactor, local diagonal) is now formalised; the analytic estimates are not | **Partially bridged** |
| B11 | O3 algebraic separator: Davenport–Heilbronn word | Used as the litmus; coefficient algebra not formalised | `dhCoeff_odd`, `dhCoeff_mean_zero`, `dhCoeff_five`: the period-five word `(1,ξ,−ξ,−1,0)` is odd, mean-zero, and vanishes on the class `5` | **Reduced algebraically**; non-vanishing in `σ>1` remains the analytic (M) input |
| B12 | Complex last-chord product | Only the absolute size was formalised | `lastChord_mul_twin_complex`: `H_N(s)H_N(1−s)=(N−1)²/(4N²)` for complex `s` | **Closed** |
| B13 | Asymptotic last-chord dichotomy | Algebraic product only; no limit theorem | `lastChordAbs_half_tendsto`, `lastChordAbs_tendsto_zero_of_half_lt`, `lastChordAbs_tendsto_atTop_of_lt_half`, `lastChordAbs_dichotomy`: `L_N(1/2)→1/2`, `σ>1/2⇒L_N(σ)→0`, `σ<1/2⇒L_N(σ)→∞`, and the twins are opposite | **Proved** |
| B14 | Quantitative ratio | Only the qualitative dichotomy | `lastChordAbs_ratio`: `L_N(σ)/N^(1-2σ)=1/2-1/(2N)` exactly | **Closed** |
| B15 | Register transfer operator (F.4) | Register weights known negative, but no transfer-matrix statement | Exact bond-dimension-2 register matrix product; top-right is the polygon; coupling at `m=N` is `(1-N)N^{-s}<0` for every real `s`; hence the register chain is not ferromagnetic | **Decisive no-go** for the register-only representation; interacting F.4 remains open |
| B16 | Heat-flow derivative | Only the `τ=0` identity was implemented | `heat_flow_derivative`: `∂_τ P_τ(s)|_{τ=0}=Σ c_m(log m)²m^{-s}`, verified against sympy differentiation | **Computation-level bridge** |
| B17 | O3 Davenport–Heilbronn bounds | Only odd/mean-zero/a5 were formalised | `dhXi_pos`, `dhXi_lt_one`, `dhCoeff_two_abs_ne_one`: `0<ξ<1`, so `|a₂|≠1`; the DFT eigenvector is checked to 40 digits | **Reduced algebraically** |
| B18 | F.4 upper-triangular class | Register no-go only | `UpperTriNN.prod_b_nonneg`: nonnegative upper-triangular products have nonnegative top-right; `etaAtNegOne_two` and `upperTriNN_cannot_represent_eta_two`: the `N=2` polygon at `s=−1` is `−2`, so this class cannot represent it | **Decisive no-go for the class** |
| B19 | O4 Bourgain threshold | Threshold used but not formalised | `bourgain_threshold_iff`, `bourgain_threshold_pos`, `bourgain_threshold_lt_sixth`, `bourgain_exponent_lt_target`: `(1/2−ε)·13/84<ε ⇔ 13/194<ε` | **Closed** |
| B20 | F.4 general nonnegative matrix class | Only the upper-triangular class was obstructed | `matProd_nonneg`, `contraction_nonneg`, `no_nonneg_matrix_product_rep_of_neg`, `etaTwoNegOne_eq`, `no_nonneg_matrix_product_rep_eta_two`: no nonnegative matrix product of any finite bond dimension can represent `η_2(−1)=−2` | **Decisive no-go for the class**; interacting non-nonnegative tensors remain open |
| B21 | Signed/complex interacting representation | The nonnegative route is obstructed; signed representation not constructed | `matProdC_map_conj`, `signedGauge_mul_inv`, `signedGauge_inv_mul`, `signedGauge_nonTriangular`, `signedGauge_nonTriangular_ne_zero`: a constant-gauge signed matrix product exists, is genuinely non-upper-triangular, and preserves the contraction | **Constructed**; no Lee–Yang positivity follows |
| B22 | Lee–Yang positivity | Cited as the missing mechanism | `ising2_lee_yang`: every zero of the two-spin ferromagnetic Ising partition function lies on the unit circle for `K>0` | **Closed in the finite model**; polygon version open |
| B23 | O1/O2 ledger | Informal equivalence | `O1`, `O2`, `ConversionData`, `O2_iff_O1`: the abstract conversion is formalised | **Reduced**; support equality open |
| B24 | O4 ledger | Threshold arithmetic | `O4_iff_bourgain`: `O4 ε ↔ (1/2−ε)·13/84<ε` | **Formalised** |
| B25 | Partial-sum + tail transport | Route C logic lived in `~/workspace/rh` (`Rh45/Routes.lean`, `Generic.lean`) | `tsum_eq_finite_add_tail`, `truncation_residual_le_tail_norm`, `truncation_residual_le_finset_tail_norm`, `truncation_residual_le_three_tails` | **Harvested and proved** |
| B26 | Polygon Lee–Yang positivity | Only the finite Ising model was proved; polygon zeros unexamined | `eta2_zero`, `eta2_zero_off_critical`: exact zero at `s=0`; interval Krawczyk certificate of a zero with `Re≈0.57802`, strictly inside the strip and off the critical line | **No-go for critical-line confinement**; full Lee–Yang circle theorem still open |

## The new Lean theorems

`lean/Bridges.lean` is checked by the same wrapper as `Topic.lean`.

| Name | Statement | Why it matters |
|---|---|---|
| `GeoDQPT.lastChordAbs_pos` | `0 < lastChordAbs N σ` for `N > 1` | The twin size is never zero; the dichotomy is meaningful. |
| `GeoDQPT.lastChordAbs_mul_twin` | `L(σ)L(1−σ) = (N−1)²/(4N²)` | The product is independent of `σ`; it tends to `1/4`. |
| `GeoDQPT.lastChordAbs_twin_eq_iff` | `L(σ) = L(1−σ) ↔ σ = 1/2` | Unique self-dual abscissa. |
| `GeoDQPT.clock_zero_iff` | `N^(1−s)=1 ↔ ∃ k:ℤ, s = 1 − 2πik/log N` | Algebraic classification behind Lemma F.8. |
| `GeoDQPT.prefactor_lower_bound` | `N^(1−σ) − 1 ≤ |1 − N^(1−σ−it)|` | The prefactor test's reverse triangle step. |
| `GeoDQPT.local_diagonal_identity` | `∫(1−Rf)(−f) = −∫f + R∫f²` for continuous `f` | Correct expansion; the `−1/2` constant is not assumed. |
| `GeoDQPT.local_diagonal_normalized` | If `∫f=1`, the integral is `−1 + R∫f²` | The corrected Lemma 6.3 form, closing the withdrawn route. |
| `GeoDQPT.dhCoeff_odd` | `a_{5−r} = −a_r` for the period-five Davenport–Heilbronn word | The oddness used in Definition C.3 / Lemma C.4. |
| `GeoDQPT.dhCoeff_mean_zero` | `Σ a_r = 0` | The mean-zero condition that makes the series entire. |
| `GeoDQPT.dhCoeff_five` | `a_5 = 0` | The class carrying the filter weight has zero coefficient; the Addendum D separation. |
| `GeoDQPT.lastChord_mul_twin_complex` | `H_N(s)H_N(1−s)=(N−1)²/(4N²)` for the complex last chord | The complex form of the last-chord product, not only its modulus. |
| `GeoDQPT.lastChordAbs_eq_half_mul` | `L_N(σ)=½(1−1/N)N^(1−2σ)` for `N≥1` | The normal form used by the limits. |
| `GeoDQPT.lastChordAbs_half_tendsto` | `L_N(1/2)→1/2` | The critical-line twin stays finite. |
| `GeoDQPT.lastChordAbs_tendsto_zero_of_half_lt` | `σ>1/2 ⇒ L_N(σ)→0` | The right-half twin collapses. |
| `GeoDQPT.lastChordAbs_tendsto_atTop_of_lt_half` | `σ<1/2 ⇒ L_N(σ)→∞` | The left-half twin blows up. |
| `GeoDQPT.lastChordAbs_dichotomy` | for `σ≠1/2`, one twin blows up and the other tends to `0` | The full two-sided dichotomy of `truths.md` 11.5. |
| `GeoDQPT.lastChordAbs_ratio` | `L_N(σ)/N^(1−2σ)=1/2−1/(2N)` exactly | The exact rate behind the dichotomy. |
| `GeoDQPT.regProd_diag` | the top-left entry of every register product is `1` | The product is upper triangular with unit diagonal. |
| `GeoDQPT.regProd_topright` | the top-right entry is the coefficient sum | The transfer product is the polygon. |
| `GeoDQPT.regCoeff_at_period` | `c_N = 1−N` | The coefficient at the period. |
| `GeoDQPT.regCoeff_at_period_neg` | `c_N < 0` for `N > 1` | Sign obstruction. |
| `GeoDQPT.regMat_coupling_neg` | the coupling at `m=N` is negative for every real `s` | No positive-temperature register chain. |
| `GeoDQPT.register_not_ferromagnetic` | not all register couplings are nonnegative | The register-only Lee–Yang route is ruled out. |
| `GeoDQPT.regProd_topright_polygon` | at `M=N²` the top-right entry is the polygon sum | The construction is exact at the quadratic link. |
| `GeoDQPT.dhXi_pos` | `0<ξ` | The DH constant is positive. |
| `GeoDQPT.dhXi_lt_one` | `ξ<1` | The DH constant is not a unit-modulus character value. |
| `GeoDQPT.dhCoeff_two_abs_ne_one` | `|a₂|≠1` | Coefficient-level non-character witness. |
| `GeoDQPT.UpperTriNN.prod_b_nonneg` | upper-triangular nonnegative products have nonnegative top-right | Class invariant. |
| `GeoDQPT.etaAtNegOne_two` | the `N=2` polygon at `s=−1` is `−2` | A concrete negative value. |
| `GeoDQPT.no_upperTriNN_rep_of_neg` | no upper-triangular nonnegative product represents a negative value | Class no-go. |
| `GeoDQPT.upperTriNN_cannot_represent_eta_two` | the class cannot represent the `N=2` polygon at `s=−1` | Decisive class no-go. |
| `GeoDQPT.bourgain_threshold_iff` | `(1/2−ε)·13/84<ε ⇔ 13/194<ε` | Exact O4 threshold. |
| `GeoDQPT.bourgain_threshold_pos` | `0<13/194` | Range check. |
| `GeoDQPT.bourgain_threshold_lt_sixth` | `13/194<1/6` | The threshold lies in the source range. |
| `GeoDQPT.bourgain_exponent_lt_target` | above the threshold, the exponent beats the target | Conditional O4 step. |
| `GeoDQPT.matProd_nonneg` | nonnegative factors give a nonnegative product | General matrix-product invariant. |
| `GeoDQPT.contraction_nonneg` | nonnegative product + nonnegative boundary vectors gives nonnegative contraction | General invariant. |
| `GeoDQPT.no_nonneg_matrix_product_rep_of_neg` | no nonnegative product contraction represents a negative value | General class no-go. |
| `GeoDQPT.etaTwoNegOne_eq` | the `N=2` polygon at `s=−1` is `−2` | Concrete negative value. |
| `GeoDQPT.no_nonneg_matrix_product_rep_eta_two` | no finite bond dimension works | Decisive F.4 class no-go. |
| `GeoDQPT.matProdC_map_conj` | constant-gauge invariance of matrix products | Signed gauge construction. |
| `GeoDQPT.signedGauge_mul_inv` | `S·S⁻¹=1` | Gauge inverse. |
| `GeoDQPT.signedGauge_inv_mul` | `S⁻¹·S=1` | Gauge inverse. |
| `GeoDQPT.signedGauge_nonTriangular` | the gauged first matrix has lower-left entry `−1` | Non-upper-triangular. |
| `GeoDQPT.signedGauge_nonTriangular_ne_zero` | that entry is nonzero | Genuine non-triangularity. |
| `GeoDQPT.quadratic_no_real_root` | the palindromic quadratic has no real roots | Lee–Yang step. |
| `GeoDQPT.quadratic_root_normSq_one` | non-real roots have squared modulus `1` | Lee–Yang step. |
| `GeoDQPT.ising2_lee_yang` | all zeros lie on the unit circle | Finite Lee–Yang theorem. |
| `GeoDQPT.O2_iff_O1` | O2 ↔ O1 under conversion data | Formal ledger reduction. |
| `GeoDQPT.O4_iff_bourgain` | O4 ↔ Bourgain exponent inequality | Formal ledger reduction. |
| `GeoDQPT.tsum_eq_finite_add_tail` | finite partial sum + shifted tail = total | Harvested Route C split. |
| `GeoDQPT.truncation_residual_le_tail_norm` | residual ≤ tail norm | Harvested residual bound. |
| `GeoDQPT.truncation_residual_le_finset_tail_norm` | arbitrary finite family of tails | Harvested `Generic.lean` form. |
| `GeoDQPT.truncation_residual_le_three_tails` | three-tail Route C bound | Harvested exact shape. |
| `GeoDQPT.eta2_zero` | the `N=2` polygon vanishes at `s=0` | Exact boundary zero. |
| `GeoDQPT.eta2_zero_off_critical` | that zero is not on the critical line | Exact no-go for global critical-line confinement. |
| `GeoDQPT.exists_unique_root_of_sign_change` | sign change + positive derivative gives a unique simple zero | Route A. |
| `GeoDQPT.turing_reduction` | certified subset + count bound exhausts the window | Route B. |
| `GeoDQPT.all_zeros_are_certified` | packaged Route B | O4 isolation step. |
| `GeoDQPT.IsolationCertificate.exhausts` | isolation certificate exhausts the window | O4 wrapper. |

## The new Python checks

`python/bridges.py` and `tests/test_bridges.py` implement and test:

- `last_chord_abs`, `last_chord_product`, `last_chord_twin_difference`;
- `self_dual_abscissa` (exactly `1/2` for tested `N`);
- `clock_zero`, `clock_zero_residual`, `clock_zero_is_zero`;
- `prefactor`, `prefactor_lower_bound_holds` (50-digit mpmath);
- `local_diagonal_integral`, `local_diagonal_normalized`;
- `register_coefficient_at_multiple`, `eta_coefficients`, `heat_flowed_polygon`, `heat_flow_reduces_to_polygon`.

Run:

```bash
cd the-final-letter/topics/geometric-dynamical-phase-transitions
python3 -m pytest -q tests
./lean/check.sh
```

Recorded: **55 pytest tests**, `[check] OK` for `Topic.lean`, `Bridges.lean`, `LastChord.lean`, `TransferNoGo.lean`, and `Tractable.lean`.

## Asymptotic last-chord dichotomy

The exact product was upgraded to a limit theorem. For fixed `σ`:

- `σ = 1/2`: `L_N(σ) → 1/2`;
- `σ > 1/2`: `L_N(σ) → 0` and `L_N(1−σ) → ∞`;
- `σ < 1/2`: `L_N(σ) → ∞` and `L_N(1−σ) → 0`.

This is the analytic content of the twin dichotomy in `truths.md` 11.5. It does not prove RH: it shows that an off-line zero necessarily produces one collapsing and one blowing-up twin, which is precisely why the support equality remains the open statement. The Lean proofs are in `lean/LastChord.lean`; the exact ratio is `lastChordAbs_ratio`, and the numeric classes are tested at `N=10^10`.

## Register transfer no-go

The register chain can be written exactly as a bond-dimension-2 matrix product:

\[
A_m(s)=egin{pmatrix}1 & c_m m^{-s}\ 0 & 1\end{pmatrix},
\qquad
A_1(s)\cdots A_{N^2}(s)=
egin{pmatrix}1 & \eta_N^{(N^2)}(s)\ 0 & 1\end{pmatrix}.
\]

`TransferNoGo.lean` proves the product identity and the sign obstruction. At `m=N` the coupling is

\[
c_N N^{-s}=(1-N)N^{-s}<0
\]

for every real `s` and every `N>1`. Therefore the register chain is **not ferromagnetic** in the Lee–Yang sense. This is a decisive no-go for the register-only representation of F.4; it does not rule out an interacting transfer operator with a different bond structure, which remains open. The heat-flow derivative identity `∂_τ P_τ(s)|_{τ=0}=Σ c_m(log m)²m^{-s}` is also implemented and tested.

## Tractable O3/O4/F.4 additions

- **O4:** the exact threshold `13/194` is now formalised: `(1/2−ε)·13/84<ε` iff `13/194<ε`. This is the arithmetic core of Corollary F.9; the analytic inputs (`|ζ'(ρ)|≤N^ε` and isolation) remain open.
- **O3:** the Davenport–Heilbronn constant satisfies `0<ξ<1`, so the coefficient `a₂=ξ` has modulus not equal to `1`; this is a coefficient-level non-character witness. The DFT eigenvector identity is verified to 40 digits. The analytic non-vanishing in `σ>1` remains the Saias–Weingartner input.
- **F.4:** the upper-triangular nonnegative transfer class is ruled out: every such product has nonnegative top-right, while the `N=2` polygon at `s=−1` is exactly `−2`. The interacting (non-upper-triangular) representation remains open.

## General nonnegative matrix-product no-go

The upper-triangular obstruction was upgraded to arbitrary finite bond dimension. `MatrixNoGo.lean` proves:

- a product of entrywise nonnegative matrices is entrywise nonnegative;
- contracting it with nonnegative boundary vectors is nonnegative;
- therefore no nonnegative matrix-product contraction can represent `η_2(−1)=−2`.

This rules out the **entire nonnegative transfer-matrix class**, not just upper-triangular factors, at the point where the polygon is negative. A surviving interacting representation must therefore use signed/complex tensors or a different contraction scheme; that is the remaining F.4 question.

## Signed/complex interacting representation

`SignedF4.lean` constructs the signed counterpart of the no-go. A constant gauge

\[
S=egin{pmatrix}1&1\1&2\end{pmatrix},
\qquad
S^{-1}=egin{pmatrix}2&-1\-1&1\end{pmatrix}
\]

preserves the matrix product by `matProdC_map_conj`. The gauged first matrix has lower-left entry `−1`, so it is genuinely non-upper-triangular. The contraction with transformed boundary vectors is preserved, and the Python layer verifies the polygon identity at `s=1`.

This proves that a **signed interacting representation exists**. It does **not** yield a Lee–Yang theorem: the entries are signed, and the general nonnegative matrix-product no-go shows that no nonnegative representative can exist at `η_2(−1)=−2`. The signed/complex route is therefore a representational escape, not a positivity escape.

## Finite Lee–Yang theorem and the formal ledger

`LeeYang.lean` proves the circle theorem for the two-spin ferromagnetic Ising model: for `K>0`, every zero of

\[
Z_K(z)=e^K z^2+2z+e^K
\]

satisfies `|z|=1`. The proof is elementary: the polynomial is palindromic with positive real coefficients, has no real roots, and a non-real root and its conjugate multiply to `1`. This is a concrete instance of the Lee–Yang positivity mechanism—but for the Ising model, not for the polygon.

`Ledger.lean` formalises the source-claims table S1–S14 and the open/conjecture ledger O1–O4 as `LedgerEntry` data, with precise predicates `O1`, `O2`, `O3`, `O4`, the abstract conversion structure, and the O4 threshold equivalence. The ledger records statuses; it does not prove O1/O2 or (M).

## Harvested partial-sum + tail proof

The Route C truncation logic in `~/workspace/rh` was harvested into `PartialSumTail.lean`:

- `tsum_eq_finite_add_tail`: a finite partial sum plus the shifted tail is the total;
- `truncation_residual_le_tail_norm`: the residual is bounded by the tail norm;
- `truncation_residual_le_finset_tail_norm`: the arbitrary finite-family form from `Generic.lean`;
- `truncation_residual_le_three_tails`: the exact three-tail shape from `Rh45/Routes.lean`.

The statement is generic over `ℝ` and `ℂ` via `RCLike`, so it applies to both real truncations and complex Dirichlet sums. The Python layer checks the identity and both bounds on geometric and complex models.

## Polygon Lee–Yang obstruction

`LeeYang.lean` proves the finite two-spin Ising circle theorem, but the polygon does not inherit it. The exact zero `η₂(0)=0` is already off the critical line. More strongly, `polygon_zero.py` uses a Krawczyk interval operator to certify a zero of

\[
\eta_2(s)=1-2^{-s}+3^{-s}-4^{-s}
\]

in the box with `Re(s) ∈ [0.578020... , 0.578020...]` and `Im(s) ≈ 18.645458`. The real part is strictly inside `(0,1)` and strictly away from `1/2`.

So polygon zeros are **not confined to the critical line**. The finite Lee–Yang theorem is a mechanism for a different model; it does not transfer to the polygon. A genuine polygon Lee–Yang theorem would need a different variable/contraction in which the zeros become a circle, and that remains open.

## Harvested Route A/B and a second polygon zero

`CertifiedZero.lean` ports the certified-zero logic from `~/workspace/rh`:

- Route A: a sign change plus a strictly positive derivative gives a unique simple zero;
- Route B: a certified subset plus a window count bound exhausts the window;
- `IsolationCertificate.exhausts`: the finite O4 isolation wrapper.

`polygon_zero.py` now certifies **two** zeros of the `N=2` polygon, with real parts around `0.57802` and `0.80014`. The real intervals are disjoint, so the polygon zeros are not confined to any single vertical line—not merely not confined to the critical line.

## What would close the remaining gaps

### O1/O2 — RH and support equality

The exact last-chord theorem says an off-line zero has one twin tending to `0` and the other to `∞`, while the product stays `1/4`. To close O2 one would need a pointwise argument that the unrestricted measure cannot charge the right-half twin. The source's Marty-speed/north-pole chart removes the left half-strip; the right half-strip is the wall. This is RH in the measure language, not a missing algebraic lemma.

### O3 — hypothesis (M)

(M) says the relevant periodic Dirichlet series has no zeros in `σ > 1`. The construction transfers to Davenport–Heilbronn and returns a false RH there, so any proof of O2 must consume a multiplicative/positivity input. The coefficient algebra of the Davenport–Heilbronn word is now formalised (odd, mean-zero, `a_5=0`), which pins down the algebraic separator; the analytic non-vanishing statement in `σ>1` is still not proved.

### O4 — uniform slow passage and isolation

The remaining analytic inputs are explicit:

1. `|ζ'(ρ)| ≤ N^ε` on the tightness window (Hughes–Keating–O'Connell predicts this; Lindelöf suffices);
2. a pair-correlation/isolation bound controlling zeros within `N^{−κ}` of each other.

The prefactor clause is now formalised (B3). These two inputs are still source claims.

### F.4 — Lee–Yang for the polygon

The register weights are negative at multiples of `N` (`c_N = 1−N`). `TransferNoGo.lean` upgrades this to a transfer-matrix no-go: the natural bond-dimension-2 register product has a negative coupling at `m=N` for every real `s`, so the register-only ferromagnetic representation is impossible. The upper-triangular nonnegative class is also ruled out: every such product has nonnegative top-right, while the `N=2` polygon at `s=−1` is exactly `−2`.

**Precise specification of the remaining interacting problem.** The general nonnegative matrix-product class is now ruled out by `MatrixNoGo.lean`. A surviving interacting representation would need:

1. a finite spin chain or tensor network with bond dimension `D ≥ 3`;
2. transfer tensors whose contraction equals `η_N^(N²)(s)` at the quadratic link;
3. nonnegative Boltzmann weights/couplings on the relevant real-temperature range (not merely nonnegative off-diagonal entries);
4. a structure that is **not** upper-triangular and not a register reweighting, since both are now obstructed;
5. signed/complex tensors, since the nonnegative class cannot produce `η_2(−1)=−2`.

The tractable search problem is: for `N = 2, 3`, decide whether such a `D = 3` or `D = 4` tensor network exists, or prove that every positive contraction fails to reproduce the negative value `η_N(−1)`. This is recorded as open; no such representation is constructed here.


## Reference material used

| Source | What it supplied | How it is used |
|---|---|---|
| `truths.md` §§11–14 | last-chord definition, twin product, dichotomy, self-dual abscissa | B1, B7 |
| `truths.md` §2.3 | prefactor lower bound | B3 |
| `summary/13-working-notes/` | corrected local diagonal and the withdrawn `−1/2` route | B4 |
| `summary/09-quantum-placements/05-open-item-f.4.md` | Lee–Yang item and the register-weight boundary | B5 |
| `gaps.html#tractable` and `todo.md` | items (a)–(d), F.4, O4 | B5, B6, B9 |
| `tensor.html` and `summary/10-prime-spectrum-tensor/` | Weil-current positivity and the arithmetic-positivity reading of (M) | Not used as a proof; it is RH-equivalent |
| `archive/maths/rh/research/harmonic-sine-transform/` | transfer-operator and Fredholm-determinant proposals | Not used; their global determinant identities are source claims |

The search did not produce a theorem that closes O1/O2 or (M). It did produce the exact algebraic material above and the Davenport–Heilbronn coefficient algebra.


## Avenue exhaustion ledger

| Avenue | Outcome | Exhausted? |
|---|---|---|
| Exact finite algebra (filter, last chord, clock zeros, prefactor, local diagonal, DH word) | Closed in Lean and sympy | **Yes** |
| Last-chord asymptotics | Closed: full dichotomy and exact rate | **Yes** |
| Register transfer matrix | Constructed; sign obstruction proved | **Yes** |
| Nonnegative matrix-product class | General no-go for any finite bond dimension at `η₂(−1)=−2` | **Yes** |
| Signed gauge representation | Constructed; non-upper-triangular; no positivity | **Yes** |
| Finite Lee–Yang theorem | Proved for the two-spin ferromagnetic Ising model | **Yes for the finite model**; polygon version open |
| Partial-sum + tail transport | Harvested from `~/workspace/rh` and proved for `ℝ`/`ℂ` | **Yes** |
| O3 coefficient separator | Bounds and non-character witness proved; DFT checked | **Tractable part exhausted**; analytic `σ>1` input open |
| O4 threshold | Exact `13/194` equivalence proved | **Tractable part exhausted**; `|ζ'|≤N^ε` and isolation open |
| O1/O2 and RH | Reduced to `O2 ↔ O1`; equality side open | **Not exhausted** — this is RH |
| Hypothesis (M) | Reduced to the Saias–Weingartner input; no proof | **Not exhausted** — analytic arithmetic input |
| Polygon Lee–Yang positivity | Finite Ising theorem proved; exact and certified polygon zeros off the critical line | **No-go for critical-line confinement**; a different-variable Lee–Yang theorem remains open |
| Interacting signed/complex F.4 | Signed representation exists; positive interacting representation unknown | **Not exhausted** — remaining open search |

The tractable algebraic, asymptotic, transfer, ledger, and finite-model avenues are exhausted. The remaining four items are open problems, not missing bookkeeping: O1/O2 is RH in measure language, (M) is the arithmetic positivity input, the polygon Lee–Yang theorem is the missing positivity, and the interacting F.4 search is the constructive version of that positivity.


## Honesty statement

The new results are exact algebraic and geometric lemmas. They do not prove RH, (M), the Euler–Maclaurin remainder, tightness, the measure limits, or the conversion. The open ledger in `README.md` remains authoritative; the rows above only refine it.

[Back to the programme](README.md) · [Lean core](lean/README.md) · [Topic index](../README.md)
