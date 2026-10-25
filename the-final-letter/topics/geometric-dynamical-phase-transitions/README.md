# Geometric dynamical phase transitions — research programme

**Status:** reconstructed finite formal core + exact computation layer; the analytic and spectral claims remain source claims, and the Riemann hypothesis remains open.  
**Inventory:** [Scraps](../../scraps.html) item 1 · [Topic index](../README.md).  
**Canonical source:** [`publication.html`](../../geometric-dynamical-phase-transitions/publication.html) — “Geometric Dynamical Phase Transitions and the Spectral Measure of the Riemann Zeros” (August 2026), with Addenda A–F, [`gaps.html`](../../geometric-dynamical-phase-transitions/gaps.html), [`todo.md`](../../geometric-dynamical-phase-transitions/todo.md) and the bundle [`README.md`](../../geometric-dynamical-phase-transitions/README.md).

## What the programme is

The source starts from a finite, mean-zero filter applied to the depth-one Euler sums

\[
H_x^{(s)}=\sum_{n\le x} n^{-s},
\qquad
\eta_N^{(M)}(s)=H_M^{(s)}-N^{1-s}H_{\lfloor M/N\rfloor}^{(s)} .
\]

At the **quadratic link** `M = N²` the inner length is `N`, and the two-sum definition is exactly the filter form

\[
\eta_N^{(N^2)}(s)=\sum_{m\le N^2} c_m^{(N)}m^{-s},
\qquad
c_m^{(N)}=\begin{cases}1,&N\nmid m,\\ 1-N,&N\mid m.\end{cases}
\]

The coefficients have mean zero over every complete block. The resulting **coherent polygonal path** has endpoint `η_N^(N²)(s)`. A **path-closure event** is a point at which this endpoint is unusually small relative to the prefactor `P_N(s)=N^{1-\sigma}-1`; the source separates *unrestricted* closures `𝒰_N` from the more restrictive *balanced* closures `𝒞_N`. It then builds finite tempered measures on a truncated strip `S_δ`,

\[
\mu_N^{\mathrm{pp}}=\sum_{s\in\mathcal{C}_N}(1+|s|^2)^{-1}\delta_s,
\qquad
\nu_N^{\mathrm{pp}}=\sum_{s\in\mathcal{U}_N}(1+|s|^2)^{-1}\delta_s,
\]

adds a residual density `ρ_N` of total mass `O(N^{-1})`, proves tightness, and identifies pure-point limits with zeros of the completed `ξ`-function.

The limit theorem is a **conversion**, not a proof of RH. The source's own Corollary 12.3 states that

\[
\operatorname{supp}\mu=\operatorname{supp}\nu
\quad\Longleftrightarrow\quad
\text{every non-trivial zero of }\Xi\text{ lies on }\operatorname{Re}s=\tfrac12,
\]

and the paper says in its abstract, conclusion, changelog and `gaps.html` that the left-hand side is the open statement. The Davenport–Heilbronn twist (Addendum C) is the sharpness test: the same construction reports a false Riemann hypothesis for a function with no Euler product, so the additive toolbox alone cannot prove RH. Hypothesis **(M)** (no zeros in `σ > 1`) removes the obstruction but is itself unproved.

This topic folder reconstructs the **finite coefficient and finite-measure bookkeeping** that the construction actually uses. It does not reconstruct the Euler–Maclaurin remainder, Rouché/Jensen localisation, tightness, or the conversion theorem; those are recorded below as source claims. The two working notes in the source bundle that claim a geometric proof of RH are recorded as **withdrawn/rejected**, because the canonical paper and `summary/13-working-notes/` record their local-diagonal identity as false.

## Reconstructed objects and notation

| Object | Definition | Status in this folder |
|---|---|---|
| Depth-one Euler sum | `H_x^(s) = Σ_{n≤x} n^{-s}`, empty sum `0` | Source definition; not formalised in Lean |
| Integer filter | `c_m^(N) = 1` if `N ∤ m`, `1-N` if `N ∣ m` | Lean `GeoDQPT.filterCoeff`, Python `filter_coefficient` |
| Coherent pair | `η_N^(M)(s) = H_M^(s) - N^(1-s) H_⌊M/N⌋^(s)` | Python `two_sum_coefficients` |
| Quadratic link | `M=N²`, so `⌊M/N⌋=N` | Lean `quadratic_link`, Python `quadratic_link` |
| Filter form | `η_N^(N²)(s) = Σ_{m≤N²} c_m^(N) m^{-s}` | Computational identity `two_sum_identity_holds` |
| Prefactor | `P_N(s)=N^{1-σ}-1` | Source object; not formalised |
| Path-closure families | `𝒞_N ⊆ 𝒰_N` in the truncated strip `S_δ` | Source definition; only finite atomic bookkeeping formalised |
| Tempering weight | `w(s)=(1+|s|²)^{-1}` | Lean `temperedWeight_pos`, `temperedWeight_le_one`; Python `tempered_weight`, `atomic_weight` |
| Finite atomic measure | `μ_N^pp = Σ_{s∈𝒞_N} w(s) δ_s` (and likewise `ν_N^pp`) | Lean `atomicMass`, `atomicMass_le_card` |
| Residual density | `ρ_N(σ+it)=N^{-1} min(1,|η_N^(N²)(s)|²) w(s)` | Source definition; not formalised |
| Conversion | `supp μ = supp ν ⇔ RH` | Source claim / open, not a theorem here |

## Theorem ledger

Every row marked **Theorem** is proved in Lean with no `sorry`, `axiom` or `admit`: T1–T67 in the original core files and T68–T108 in [`lean/Computations.lean`](lean/Computations.lean), which converts the former computation ledger into theorems. The Python suite remains a regression check, not the proof of any ledger row. Source claims and open items are not theorems of this reconstruction.

The 108 rows are not 108 independent mathematical facts. A few restate an earlier result or record a guard: T36, T46 and T93 all record η₂(−1) = −2; T56 is a structure-field projection; T63 is the trivial guard `(0 : ℂ).re ≠ 1/2`. They are kept because the ledger reproduces the source's row numbering, not because each is a separate discovery.

Four numerical certificates remain at the computation layer and are listed separately below: the 40-digit Davenport–Heilbronn DFT eigenvector identity and the three Krawczyk interval certificates. They are not theorems of this reconstruction; formalising them requires a verified interval-arithmetic layer for `exp`, `log`, `cos` and `sin`. A rational interval-replay layer (`IBox`/`Expr`) exists in the sibling twin-prime-parity bundle and compiles against the same Mathlib, but its transcendental leaves are still Python-checked; porting the series enclosures from its `rativ.py` to Lean is the remaining step.

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | At the quadratic link, `⌊N²/N⌋ = N` for `N ≥ 1`. | `GeoDQPT.quadratic_link` |
| T2 | Theorem | A non-multiple of `N` has filter coefficient `1`. | `GeoDQPT.filterCoeff_of_not_dvd` |
| T3 | Theorem | A multiple of `N` has filter coefficient `1-N`. | `GeoDQPT.filterCoeff_of_dvd` |
| T4 | Theorem | `Σ_{m=1}^{N} c_m^(N) = 0` for `N ≥ 1`: the filter has mean zero over a complete block. | `GeoDQPT.filterCoeff_block_sum_zero` |
| T5 | Theorem | The tempering weight `(1+t²)^{-1}` is strictly positive for every real `t`. | `GeoDQPT.temperedWeight_pos` |
| T6 | Theorem | The tempering weight is at most `1` for every real `t`. | `GeoDQPT.temperedWeight_le_one` |
| T7 | Theorem | A finite atomic measure with one tempered atom per point has total mass at most its number of atoms. | `GeoDQPT.atomicMass_le_card` |
| T8 | Theorem | The absolute last-chord size `L(σ) = (N−1)/2 · N^(−2σ)` is positive for `N > 1`. | `GeoDQPT.lastChordAbs_pos` |
| T9 | Theorem | `L(σ)L(1−σ) = (N−1)²/(4N²)`; the twin product is independent of `σ`. | `GeoDQPT.lastChordAbs_mul_twin` |
| T10 | Theorem | For `1 < N`, `L(σ) = L(1−σ)` iff `σ = 1/2`; the self-dual abscissa is unique. | `GeoDQPT.lastChordAbs_twin_eq_iff` |
| T11 | Theorem | For `1 < N`, `N^(1−s) = 1` iff `s = 1 − 2πik/log N` for some `k ∈ ℤ`; the algebraic clock-zero classification. | `GeoDQPT.clock_zero_iff` |
| T12 | Theorem | `N^(1−σ) − 1 ≤ |1 − N^(1−σ−it)|`; the prefactor lower bound. | `GeoDQPT.prefactor_lower_bound` |
| T13 | Theorem | For continuous `f`, `∫(1−Rf)(−f) = −∫f + R∫f²`. | `GeoDQPT.local_diagonal_identity` |
| T14 | Theorem | If `∫f = 1`, the local diagonal is `−1 + R∫f²`; the `−1/2` value is not assumed. | `GeoDQPT.local_diagonal_normalized` |
| T15 | Theorem | The period-five Davenport–Heilbronn word `(1, ξ, −ξ, −1, 0)` is odd: `a_{5−r} = −a_r`. | `GeoDQPT.dhCoeff_odd` |
| T16 | Theorem | The Davenport–Heilbronn word has mean zero: `Σ a_r = 0`. | `GeoDQPT.dhCoeff_mean_zero` |
| T17 | Theorem | `a_5 = 0`: the residue class carrying the filter weight has zero coefficient. | `GeoDQPT.dhCoeff_five` |
| T18 | Theorem | For the complex last chord `H_N(s) = ½(1−N)N^(−2s)`, `H_N(s)H_N(1−s) = (N−1)²/(4N²)`. | `GeoDQPT.lastChord_mul_twin_complex` |
| T19 | Theorem | For `N ≥ 1`, `L_N(σ) = ½(1−1/N)N^(1−2σ)`. | `GeoDQPT.lastChordAbs_eq_half_mul` |
| T20 | Theorem | `L_N(1/2) → 1/2`. | `GeoDQPT.lastChordAbs_half_tendsto` |
| T21 | Theorem | If `σ > 1/2`, then `L_N(σ) → 0`. | `GeoDQPT.lastChordAbs_tendsto_zero_of_half_lt` |
| T22 | Theorem | If `σ < 1/2`, then `L_N(σ) → ∞`. | `GeoDQPT.lastChordAbs_tendsto_atTop_of_lt_half` |
| T23 | Theorem | Full dichotomy: for `σ ≠ 1/2`, one twin blows up and the other tends to `0`. | `GeoDQPT.lastChordAbs_dichotomy` |
| T24 | Theorem | Exact ratio `L_N(σ)/N^(1−2σ) = 1/2 − 1/(2N)` for `N ≥ 1`; the quantitative rate of the dichotomy. | `GeoDQPT.lastChordAbs_ratio` |
| T25 | Theorem | Every register product has top-left entry `1`. | `GeoDQPT.regProd_diag` |
| T26 | Theorem | The top-right entry of the register product is the coefficient sum. | `GeoDQPT.regProd_topright` |
| T27 | Theorem | The register coefficient at `m=N` is `1−N`. | `GeoDQPT.regCoeff_at_period` |
| T28 | Theorem | `1−N < 0` for `N > 1`. | `GeoDQPT.regCoeff_at_period_neg` |
| T29 | Theorem | The register coupling at `m=N` is negative for every real `s`. | `GeoDQPT.regMat_coupling_neg` |
| T30 | Theorem | The register chain is not ferromagnetic: not all its couplings are nonnegative. | `GeoDQPT.register_not_ferromagnetic` |
| T31 | Theorem | At `M=N²`, the top-right entry is the polygon sum. | `GeoDQPT.regProd_topright_polygon` |
| T32 | Theorem | `0 < ξ` for the Davenport–Heilbronn constant. | `GeoDQPT.dhXi_pos` |
| T33 | Theorem | `ξ < 1`. | `GeoDQPT.dhXi_lt_one` |
| T34 | Theorem | `|a₂| = |ξ| ≠ 1`; the word is not a single unit-modulus character. | `GeoDQPT.dhCoeff_two_abs_ne_one` |
| T35 | Theorem | Every upper-triangular nonnegative transfer product has nonnegative top-right entry. | `GeoDQPT.UpperTriNN.prod_b_nonneg` |
| T36 | Theorem | The `N=2` polygon at `s=−1` is exactly `−2`. | `GeoDQPT.etaAtNegOne_two` |
| T37 | Theorem | No upper-triangular nonnegative product can represent a negative value. | `GeoDQPT.no_upperTriNN_rep_of_neg` |
| T38 | Theorem | The upper-triangular nonnegative class cannot represent the `N=2` polygon at `s=−1`. | `GeoDQPT.upperTriNN_cannot_represent_eta_two` |
| T39 | Theorem | `(1/2−ε)·13/84 < ε` iff `13/194 < ε`; the exact Bourgain threshold. | `GeoDQPT.bourgain_threshold_iff` |
| T40 | Theorem | `0 < 13/194`. | `GeoDQPT.bourgain_threshold_pos` |
| T41 | Theorem | `13/194 < 1/6`. | `GeoDQPT.bourgain_threshold_lt_sixth` |
| T42 | Theorem | Above the threshold, the Bourgain exponent beats the target. | `GeoDQPT.bourgain_exponent_lt_target` |
| T43 | Theorem | A product of entrywise nonnegative matrices is entrywise nonnegative. | `GeoDQPT.matProd_nonneg` |
| T44 | Theorem | A nonnegative matrix product contracted with nonnegative boundary vectors is nonnegative. | `GeoDQPT.contraction_nonneg` |
| T45 | Theorem | No nonnegative matrix-product contraction can represent a negative value. | `GeoDQPT.no_nonneg_matrix_product_rep_of_neg` |
| T46 | Theorem | The `N=2` polygon at `s=−1` is `−2`. | `GeoDQPT.etaTwoNegOne_eq` |
| T47 | Theorem | No nonnegative matrix product of any finite bond dimension can represent the `N=2` polygon at `s=−1`. | `GeoDQPT.no_nonneg_matrix_product_rep_eta_two` |
| T48 | Theorem | Constant-gauge invariance of the matrix product: `matProd (map (S⁻¹ A S)) = S⁻¹ matProd S`. | `GeoDQPT.matProdC_map_conj` |
| T49 | Theorem | The signed gauge `S = [[1,1],[1,2]]` has `S·S⁻¹ = 1`. | `GeoDQPT.signedGauge_mul_inv` |
| T50 | Theorem | `S⁻¹·S = 1`. | `GeoDQPT.signedGauge_inv_mul` |
| T51 | Theorem | The gauged first matrix is non-upper-triangular: its lower-left entry is `−1`. | `GeoDQPT.signedGauge_nonTriangular` |
| T52 | Theorem | That lower-left entry is nonzero. | `GeoDQPT.signedGauge_nonTriangular_ne_zero` |
| T53 | Theorem | A real quadratic `a z² + b z + a` with `0 < b < 2a` has no real roots. | `GeoDQPT.quadratic_no_real_root` |
| T54 | Theorem | A non-real root of that quadratic has squared modulus `1`. | `GeoDQPT.quadratic_root_normSq_one` |
| T55 | Theorem | Finite Lee–Yang circle theorem: every zero of the two-spin Ising partition function `e^K z² + 2z + e^K` lies on the unit circle for `K > 0`. | `GeoDQPT.ising2_lee_yang` |
| T56 | Theorem | Under the conversion data, O2 (`supp μ = supp ν`) is equivalent to O1 (all zeros on the critical line). | `GeoDQPT.O2_iff_O1` |
| T57 | Theorem | O4 is equivalent to the Bourgain exponent inequality. | `GeoDQPT.O4_iff_bourgain` |
| T58 | Theorem | A finite partial sum plus the shifted tail is the total sum. | `GeoDQPT.tsum_eq_finite_add_tail` |
| T59 | Theorem | The truncation residual is bounded by the norm of the tail. | `GeoDQPT.truncation_residual_le_tail_norm` |
| T60 | Theorem | The arbitrary finite-family tail bound. | `GeoDQPT.truncation_residual_le_finset_tail_norm` |
| T61 | Theorem | The three-tail Route C residual bound. | `GeoDQPT.truncation_residual_le_three_tails` |
| T62 | Theorem | The `N=2` polygon has an exact zero at `s=0`. | `GeoDQPT.eta2_zero` |
| T63 | Theorem | That exact zero is not on the critical line. | `GeoDQPT.eta2_zero_off_critical` |
| T64 | Theorem | Route A: a sign change plus strictly positive derivative gives a unique simple zero. | `GeoDQPT.exists_unique_root_of_sign_change` |
| T65 | Theorem | Route B: certified zeros contained in a window, with the window count no larger, exhaust the window. | `GeoDQPT.turing_reduction` |
| T66 | Theorem | Packaged form: every zero in the window is certified. | `GeoDQPT.all_zeros_are_certified` |
| T67 | Theorem | `IsolationCertificate` exhausts the window; the O4 isolation wrapper. | `GeoDQPT.IsolationCertificate.exhausts` |
| T68 | Theorem | The two coefficient cases of Lemma 2.2 hold on the grid `N ∈ {2,3,4,5,7,12}`, `1 ≤ m ≤ 4N`. | `GeoDQPT.comp_filterCoeff_cases` |
| T69 | Theorem | The complete-block sum is zero for every `2 ≤ N ≤ 60`. | `GeoDQPT.comp_complete_block_sum` |
| T70 | Theorem | The quadratic link gives inner length `N` for `2 ≤ N ≤ 300`. | `GeoDQPT.comp_quadratic_link` |
| T71 | Theorem | At every `m ≤ M` the depth-one pair has exactly the filter coefficient; the recorded grid is a special case. | `GeoDQPT.comp_twoSum_identity` |
| T72 | Theorem | The tempering weight lies in `(0,1]` on the rational test set. | `GeoDQPT.comp_temperedWeight_testset` |
| T73 | Theorem | `w(3+4i)=1/26`; the recorded six-atom mass is at most its atom count. | `GeoDQPT.comp_atomicWeight_3_4, comp_atomicMass_testset` |
| T74 | Theorem | The empty atomic measure has mass `0`; the boundary coefficients are `1` and `−1`; the periods `0,1` lie outside the domain `2 ≤ N`. | `GeoDQPT.comp_empty_atomicMass, comp_filterCoeff_edges, comp_invalid_period` |
| T75 | Theorem | Twin product, unique self-dual abscissa `σ=1/2`, and the nonzero twin difference at `σ=1/3`, on the recorded range. | `GeoDQPT.comp_lastChord_product, comp_lastChord_self_dual, comp_lastChord_twin_difference` |
| T76 | Theorem | Every clock point `s = 1 − 2πik/log N` is an exact zero of `1 − N^{1−s}`; the recorded grid is a special case. | `GeoDQPT.comp_clock_zeros` |
| T77 | Theorem | The prefactor lower bound holds on the recorded `(N,σ,t)` grid. | `GeoDQPT.comp_prefactor_grid` |
| T78 | Theorem | The normalized quartic has local diagonal `−1+3R/5`; `u²` is unnormalized because `∫u²=2/3`. | `GeoDQPT.comp_local_diagonal_quartic, comp_local_diagonal_unnormalized` |
| T79 | Theorem | The register weight at `m=N` is `1−N<0`; the heat flow reduces to the polygon at `τ=0`. | `GeoDQPT.comp_register_weight, comp_heatFlow_zero` |
| T80 | Theorem | The period-five Davenport–Heilbronn word is odd, mean-zero and has `a_5=0`. | `GeoDQPT.comp_dh_word` |
| T81 | Theorem | The complex twin product holds, including at `s=1/3+2i`. | `GeoDQPT.comp_complex_last_chord, comp_complex_last_chord_point` |
| T82 | Theorem | At `N=10^10`: `L(1/4)>100`, `|L(1/2)−1/2|<10^-5`, `L(3/4)<10^-5`; the twins behave oppositely. | `GeoDQPT.comp_lastChord_half_value, comp_lastChord_left_value, comp_lastChord_right_value, comp_lastChord_twins` |
| T83 | Theorem | The exact ratio holds on `N∈{2,3,5}` and `σ∈{1/3,1/2,2/3}`. | `GeoDQPT.comp_lastChord_ratio` |
| T84 | Theorem | The register product's top-right entry is the polygon sum at `M=N²` for `N∈{2,3,4,5}`. | `GeoDQPT.comp_register_product` |
| T85 | Theorem | `c_N=1−N<0` on `N∈{2,…,10}`. | `GeoDQPT.comp_register_coeff` |
| T86 | Theorem | The coupling at `m=N` is negative. | `GeoDQPT.comp_register_coupling` |
| T87 | Theorem | The register chain is not ferromagnetic. | `GeoDQPT.comp_register_not_ferro` |
| T88 | Theorem | The register matrix is upper triangular with unit diagonal for `N>1`. | `GeoDQPT.comp_register_matrix` |
| T89 | Theorem | The heat-flow derivative at `τ=0` is `Σ c_m(log m)²m^{−s}`. | `GeoDQPT.comp_heatFlow_deriv` |
| T90 | Theorem | `0<ξ<1`. | `GeoDQPT.comp_dh_xi_bounds` |
| T91 | Theorem | The Bourgain threshold equivalence holds on the sample set. | `GeoDQPT.comp_bourgain_samples` |
| T92 | Theorem | Below `13/194` the Bourgain exponent does not beat the target. | `GeoDQPT.comp_bourgain_below` |
| T93 | Theorem | The `N=2` polygon at `s=−1` is `−2`. | `GeoDQPT.comp_eta_two` |
| T94 | Theorem | A concrete nonnegative matrix product stays entrywise nonnegative. | `GeoDQPT.comp_matProd_nonneg` |
| T95 | Theorem | A concrete nonnegative contraction is nonnegative. | `GeoDQPT.comp_contraction_nonneg` |
| T96 | Theorem | No nonnegative contraction can represent `−2`. | `GeoDQPT.comp_no_rep_minus_two` |
| T97 | Theorem | A matrix with a negative entry, and a boundary vector with a negative entry, fail the guards. | `GeoDQPT.comp_invalid_entries, comp_invalid_boundary` |
| T98 | Theorem | The signed gauge and its inverse compose to the identity. | `GeoDQPT.comp_gauge_inverse` |
| T99 | Theorem | The gauged first matrix has lower-left entry `−1`. | `GeoDQPT.comp_gauge_non_triangular` |
| T100 | Theorem | A constant gauge preserves the contraction under the `Sᵀ`/`S⁻¹` boundary transforms. | `GeoDQPT.comp_gauge_contraction` |
| T101 | Theorem | The gauged signed contraction reproduces the polygon top-right value. | `GeoDQPT.comp_signed_representation` |
| T102 | Theorem | Every zero of the two-spin partition function lies on the unit circle. | `GeoDQPT.comp_ising_lee_yang` |
| T103 | Theorem | A non-real root is accompanied by its conjugate; two distinct roots multiply to `1`. | `GeoDQPT.comp_ising_conjugate, comp_ising_product` |
| T104 | Theorem | There are no real roots for positive coupling. | `GeoDQPT.comp_ising_no_real` |
| T105 | Theorem | The finite partial sum plus the shifted tail is the total in the geometric model. | `GeoDQPT.comp_geom_partial_add_tail` |
| T106 | Theorem | The truncation residual equals the tail. | `GeoDQPT.comp_geom_residual` |
| T107 | Theorem | The residual is bounded by the tail norm. | `GeoDQPT.comp_geom_residual_bound` |
| T108 | Theorem | The three-tail Route C bound holds on the recorded real and complex data. | `GeoDQPT.comp_three_tail_real, comp_three_tail_complex` |

### Remaining numerical certificates

| # | Kind | Statement | Python test |
|---|---|---|---|
| C24 | Computation | The Davenport–Heilbronn DFT eigenvector identity holds to 40 digits. | `test_dh_dft_eigenvector` |
| C45 | Computation | The Krawczyk interval operator certifies a zero of the `N=2` polygon in a small box. | `test_krawczyk_certificate` |
| C46 | Computation | The certified zero has real part in `(0.5780, 0.5781)`, strictly away from `1/2`. | `test_certified_zero_is_off_the_critical_line` |
| C47 | Computation | A second Krawczyk box certifies another zero with `Re≈0.80014`; the two real intervals are disjoint. | `test_two_certified_zeros_have_distinct_real_parts` |

The Python suite has **55 tests**; the recorded run is `55 passed`. The forty-one converted rows T68–T108 are proved in `lean/Computations.lean`; the four rows above remain the only computation-layer items.

## Gap-bridge results

The exact bridge theorems are collected in [`BRIDGES.md`](BRIDGES.md) and [`lean/Bridges.lean`](lean/Bridges.lean). They close the algebraic part of the last-chord, clock-zero, prefactor, and local-diagonal gaps; they reduce O1/O2 and O4 to precise inputs; and they record the register-only obstruction to F.4. They do **not** prove RH, (M), the Euler–Maclaurin remainder, tightness, or the conversion.

| Bridge | Result | Status |
|---|---|---|
| B1 last chord | product `(N−1)²/(4N²)`; unique self-dual abscissa `σ=1/2` | **closed** |
| B2 clock zeros | `N^(1−s)=1 ⇔ s = 1 − 2πik/log N` | **closed** algebraically; displacement stays source claim |
| B3 prefactor | `N^(1−σ) − 1 ≤ |1 − N^(1−σ−it)|` | **closed** |
| B4 local diagonal | `−1 + R∫f²`, not `−1/2` | **closed** negative result |
| B5 register / F.4 | `c_N = 1−N < 0`; register-only ferromagnetism is obstructed | **obstructed** for that representation |
| B6 heat flow | `τ=0` polygon identity implemented and tested | **computation-level** |
| B7 O1/O2 | last-chord dichotomy; support equality remains open | **reduced, open** |
| B8 O3 | (M) unchanged | **open** |
| B9 O4 | reduced to `|ζ'(ρ)|≤N^ε` plus isolation/pair-correlation input | **reduced, open** |
| B10 formalisation | exact algebraic skeleton formalised; analytic layer not | **partially bridged** |
| B11 O3 separator | DH word odd, mean-zero, `a_5=0`; `σ>1` non-vanishing still analytic | **reduced algebraically** |
| B12 complex last chord | `H_N(s)H_N(1−s)=(N−1)²/(4N²)` | **closed** |
| B13 asymptotic dichotomy | `L_N(1/2)→1/2`, `σ>1/2⇒L_N(σ)→0`, `σ<1/2⇒L_N(σ)⟶∞`, full twin dichotomy | **proved** |
| B14 quantitative ratio | `L_N(σ)/N^(1−2σ)=1/2−1/(2N)` exactly | **closed** |
| B15 register transfer | exact matrix product; coupling `(1−N)N^(−s)<0`; register-only Lee–Yang obstructed | **decisive no-go** |
| B16 heat-flow derivative | `∂_τ P_τ(s)|_{τ=0} = Σ c_m (log m)² m^(−s)` | **computation-level** |
| B17 O3 DH bounds | `0<ξ<1`; `|a₂|≠1`; DFT eigenvector | **reduced algebraically** |
| B18 F.4 upper-triangular class | nonnegative upper-triangular products have nonnegative top-right; `N=2,s=−1` has value `−2` | **decisive no-go for the class** |
| B19 O4 Bourgain threshold | `(1/2−ε)·13/84<ε ⇔ 13/194<ε` | **closed** |
| B20 F.4 general nonnegative matrix class | any nonnegative matrix product has nonnegative entries; contraction with nonnegative vectors cannot be `−2` | **decisive no-go for the class** |
| B21 signed interacting representation | gauge-invariant signed matrix product; non-upper-triangular; contraction preserved | **constructed**; no Lee–Yang positivity |
| B22 Lee–Yang positivity | Only cited as a mechanism | Finite Lee–Yang circle theorem for the two-spin ferromagnetic Ising model | **closed in the finite model**; polygon version open |
| B23 O1/O2 ledger | Informal equivalence | O1/O2 predicates and the abstract conversion `O2 ↔ O1` | **formalised**; equality side open |
| B24 O4 ledger | Threshold arithmetic | `O4 ε ↔ (1/2−ε)·13/84<ε` | **formalised** |
| B25 partial-sum + tail | Route C logic lived in `~/workspace/rh` | `tsum_eq_finite_add_tail`, `truncation_residual_le_tail_norm`, finite-family and three-tail forms | **harvested and proved** |
| B26 polygon Lee–Yang positivity | Only the finite Ising model was proved; polygon zeros unexamined | Exact zero at `s=0`; interval Krawczyk certificate of another zero with `Re≈0.57802` | **No-go for critical-line confinement**; full Lee–Yang circle theorem still open |
| B27 certified-zero logic (O4) | Route A/B lived in `~/workspace/rh` | `exists_unique_root_of_sign_change`, `turing_reduction`, `all_zeros_are_certified`, `IsolationCertificate.exhausts` | **Harvested and proved** |
| B28 second polygon zero | Single certified zero | Second Krawczyk box at `Re≈0.80014`; disjoint real intervals | **No single vertical line** contains both |

## Source claims (not promoted to theorems)

These rows are asserted by the archived source. They are recorded with their archived status; none is a theorem of this reconstruction.

| # | Kind | Claim | Source status | Reconstruction note |
|---|---|---|---|---|
| S1 | Source claim | Full purification identity `Σ_{m≥1} c_m^(N) m^{-s} = (1-N^{1-s})ζ(s)`, with meromorphic continuation; `1-N^{1-s}` has zeros only on `Re s = 1`. | Source lemma (Lemma 2.2), proved in the source | Only the finite coefficient rule and block mean-zero are formalised. The infinite series and continuation are outside the Lean core. |
| S2 | Source claim | Filter form and mean-zero path: `η_N^(M)(s)=Σ_{m≤M} c_m^(N)m^{-s}`; the path endpoint is `η_N^(M)(s)`. | Source lemma (Lemma 3.2) | Finite coefficient identity is checked exactly by C4; the geometric path statement is not formalised. |
| S3 | Source claim | Explicit remainder `η_N^(N²)(1/2+it) = (1-N^{1/2-it})ζ(1/2+it)+O(1+|t|)`, with an absolute constant. | Source theorem (Theorem 4.1), Euler–Maclaurin proof | Not formalised. This is the analytic engine of depth-of-closure and of the exclusion of spurious atoms. |
| S4 | Source claim | Geometric DQPT criterion: every balanced closure satisfies `σ ≤ 1/2+ε/2`; critical-line zeros produce balanced closures for all large `N`. | Source theorem (Theorem 5.2) | Not formalised; depends on S3 and Rouché localisation. |
| S5 | Source claim | Tightness of `{μ_N}` and `{ν_N}` in the weak-star topology of tempered measures on `S_δ`. | Source theorem (Theorem 9.1), stated as unconditional | Not formalised. The finite atomic-mass bound T7 is only the elementary finite-`N` clause. |
| S6 | Source claim | No spurious atoms; residual continuous spectrum vanishes along convergent subsequences, so limit points are pure-point and supported on zeros of `Ξ`. | Source theorems (Theorem 10.1, Theorem 11.1) | Not formalised. |
| S7 | Source claim | Balanced and unrestricted limit measures are realised; every critical-line zero is an atom with weight `(1+|ρ|²)^{-1}`; a simple right-half zero is unrestricted but not balanced. | Source theorems (Theorems 12.1, 12.2) | Not formalised. |
| S8 | Source claim | Conversion of RH: `supp μ = supp ν` iff RH, iff every sufficiently large unrestricted closure is balanced, iff the unrestricted limits are supported on the critical line. | Source theorem (Corollary 12.3), an **equivalence**; the paper explicitly says it is **not a proof of RH** | Recorded as a source claim. The hypothesis side is open. Do not cite this folder as proving RH. |
| S9 | Source claim | With a vanishing aperture and the jet condition, every balanced atom lies on the critical line; a right-half zero remains an unrestricted atom. | Source theorem (Theorem 12.6), conditional on the aperture definition but not on an arithmetic hypothesis | Not formalised; still does not prove RH. |
| S10 | Source claim | Davenport–Heilbronn transfer and sharpness: the construction transfers verbatim; at Spira's off-line zero the relative test fires and the prefactor test fails, so `supp μ^DH ⊊ supp ν^DH`; hence no theorem from this additive toolbox alone can be RH. | Source theorems (C.7, C.8, C.9), Corollary C.10 | Not formalised. This is the source's limitative centre and the reason the conversion is not an RH proof. |
| S11 | Source claim | Saias–Weingartner dichotomy; under hypothesis **(M)** (no zeros in `σ>1`) the obstruction lapses and the conversion reads as GRH for one `L`-function. | Source theorem C.12 cited; C.14 conditional on (M) | (M) is unproved; C.14 is not RH. |
| S12 | Source claim | Straightening field: holonomy is the zero count; RH is equivalent to flatness of the field on `1/2<σ<1`; a finite-data argument principle computes zero counts under a Rouché condition. | Source theorems (E.4, E.7), Corollaries E.5, E.8 | Not formalised. The source says the barrier is unmoved: no admissible contour reaches the critical line. |
| S13 | Source claim | Nested-spheres and continuous-cone working notes claim a complete geometric proof of RH. | **Archived claim — withdrawn/rejected by the canonical paper** | Their key local-diagonal identity `∫(1-Rφ)(-φ)du = -1/2` is recorded as **false** in `summary/13-working-notes/`; the canonical Lemma 6.3 gives `-1+R∫φ²`. The claimed differential inequality is not used. These notes must not be cited as an RH proof. |
| S14 | Source claim | Numerical companion scripts (`geometric_dqpt_test.py`, `quantum_fisher_zeros_test.py`) report residual determinants, clock zeros and Fisher-zero counts. | Numerical evidence in the source bundle | Not run or replicated here; not a proof of any ledger row. |

## Open / conjecture ledger

| # | Kind | Statement | Status and note |
|---|---|---|---|
| O1 | Open / conjecture | The Riemann hypothesis: every non-trivial zero of `Ξ` lies on `Re s = 1/2`. | Open. The source converts RH into an equality of supports; it does not prove it. |
| O2 | Open / conjecture | `supp μ = supp ν`, equivalently the unrestricted limit has no right-half atoms. | Open; equivalent to O1 by Corollary 12.3. This is the precise remaining obstruction named in `summary/05`. |
| O3 | Open / conjecture | Hypothesis **(M)**: the relevant periodic Dirichlet series has no zeros in `σ > 1`. | Open. Adjoining (M) removes the Davenport–Heilbronn obstruction but does not reach `σ = 1/2`; see Remark C.15. |
| O4 | Open / conjecture | Uniform slow passage and isolation for the full range `ε ≤ 13/194`. | Conjectural/conditional: the source invokes Lindelöf-type and random-matrix input; only `ε > 13/194` is unconditional (Corollary F.9). |

## Open items and known gaps

**Bridge status (see [`BRIDGES.md`](BRIDGES.md)).** The last-chord product, the unique self-dual abscissa, the clock-zero classification, the prefactor lower bound, and the corrected local diagonal are now proved. O1/O2 are reduced to the last-chord dichotomy but remain open; O3 is unchanged; O4 is reduced to the explicit inputs `|ζ'(ρ)|≤N^ε` and an isolation/pair-correlation bound; the register-only ferromagnetic route to F.4 is obstructed by `c_N=1−N<0`. The analytic formalisation gap is only partially bridged.

1. **The Riemann hypothesis.** The source's Corollary 12.3 converts RH into the equality `supp μ = supp ν`; it does not prove that equality. The conversion theorem and RH are deliberately left as source claims/open in this reconstruction. No row of this dossier asserts RH.
2. **Off-line atoms of `ν`.** The remaining obstruction is the absence of right-half atoms of the unrestricted limit. This is the open statement named in `summary/05-spectral-measures-and-tightness/`.
3. **Hypothesis (M).** Non-vanishing in `σ>1` is not proved for the relevant periodic Dirichlet series. Even if adjoined, (M) removes the Davenport–Heilbronn obstruction but does not reach `σ=1/2`; the gap is the whole critical strip (Remark C.15).
4. **Uniform slow passage and isolation.** Corollary F.9 is unconditional only for `ε>13/194`; the remaining range needs Lindelöf-type input, and the isolation clause needs random-matrix/conjectural information about `ζ'(ρ)`. The source labels this conjectural (Open item F.4).
5. **Formalisation gap.** The Lean core deliberately stops at finite coefficient and measure bookkeeping. The Euler–Maclaurin remainder, Rouché/Jensen localisation, tightness, the measure limits and the conversion are not formalised. A full formalisation would be a major analytic project, not an extension of this file.
6. **Withdrawn working notes.** The nested-spheres and continuous-cone notes in the source bundle claim RH via a local differential inequality; that route is rejected because its local diagonal is wrong. This is a closed negative item, not an open conjecture.
7. **Numerical evidence is not proof.** The source's finite numerical certificates (Section 13, Addendum F) are not replicated here and would not upgrade any Source claim row.

## Python layer

[`python/programme.py`](python/programme.py) implements the exact finite layer with sympy only:

- `filter_coefficient(N, m)` and `filter_coefficients(N, M)`;
- `complete_block_sum(N)`;
- `quadratic_link(N)`;
- `two_sum_coefficients(N, M)`, `filter_coefficients_dict(N, M)` and `two_sum_identity_holds(N, M)`;
- `tempered_weight(t)`, `atomic_weight(z)`, `atomic_mass(points)` and `atomic_mass_bound_holds(points)`;
- bridge functions in `python/bridges.py`: `last_chord_abs`, `last_chord_product`, `self_dual_abscissa`, `clock_zero`, `clock_zero_is_zero`, `prefactor_lower_bound_holds`, `local_diagonal_integral`, `local_diagonal_normalized`, `register_coefficient_at_multiple`, `heat_flowed_polygon` and `heat_flow_reduces_to_polygon`.

The functions validate their domains (`N ≥ 2`, `M ≥ 1`), raise on invalid input, and use exact integers/rationals throughout. There is no numerical tolerance and no import-time side effect.

```bash
cd the-final-letter/topics/geometric-dynamical-phase-transitions
python3 -m pytest -q tests
```

Recorded result: **55 passed** (well under 20 seconds).

Example:

```python
import sympy as sp
from python.programme import filter_coefficients, two_sum_coefficients, atomic_mass
filter_coefficients(3, 6)                    # [1, 1, -2, 1, 1, -2]
two_sum_coefficients(3, 9)[9]                # -2
atomic_mass([sp.Integer(0), sp.Integer(1), sp.I])  # 2
```

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib, opens the namespace `GeoDQPT`, and proves T1–T7. It defines `filterCoeff`, `atomWeight` and `atomicMass`; it uses only elementary integer, order and finite-sum facts. [`lean/Bridges.lean`](lean/Bridges.lean) proves T8–T18: the last-chord product and self-dual abscissa, the clock-zero classification, the prefactor lower bound, the corrected local diagonal, and the Davenport–Heilbronn word algebra. [`lean/LastChord.lean`](lean/LastChord.lean) proves T19–T24: the asymptotic last-chord dichotomy and its exact rate. There is no `sorry`, `axiom` or `admit` in either file.

```bash
cd the-final-letter/topics/geometric-dynamical-phase-transitions
./lean/check.sh
```

The wrapper is the required [`lean/check.sh`](lean/check.sh); it calls the shared [`tools/check-lean.sh`](../tools/check-lean.sh). The recorded build is [`lean/BUILD.log`](lean/BUILD.log) — `[check] OK Topic.lean`.

See [`lean/README.md`](lean/README.md) for the precise boundary of what is and is not formalised.

## Provenance and links

- Canonical paper: [`publication.html`](../../geometric-dynamical-phase-transitions/publication.html).
- Bundle overview: [`the-final-letter/geometric-dynamical-phase-transitions/README.md`](../../geometric-dynamical-phase-transitions/README.md).
- Gap inventory: [`gaps.html`](../../geometric-dynamical-phase-transitions/gaps.html) · strengthening checklist [`todo.md`](../../geometric-dynamical-phase-transitions/todo.md).
- Gap bridges: [`BRIDGES.md`](BRIDGES.md) · [`lean/Bridges.lean`](lean/Bridges.lean) · [`lean/LastChord.lean`](lean/LastChord.lean) · [`lean/TransferNoGo.lean`](lean/TransferNoGo.lean) · [`lean/Tractable.lean`](lean/Tractable.lean) · [`lean/MatrixNoGo.lean`](lean/MatrixNoGo.lean) · [`lean/SignedF4.lean`](lean/SignedF4.lean) · [`lean/LeeYang.lean`](lean/LeeYang.lean) · [`lean/Ledger.lean`](lean/Ledger.lean) · [`lean/PartialSumTail.lean`](lean/PartialSumTail.lean) · [`lean/CertifiedZero.lean`](lean/CertifiedZero.lean) · [`python/bridges.py`](python/bridges.py) · [`python/transfer_nogo.py`](python/transfer_nogo.py) · [`python/tractable.py`](python/tractable.py) · [`python/matrix_nogo.py`](python/matrix_nogo.py) · [`python/signed_f4.py`](python/signed_f4.py) · [`python/lee_yang.py`](python/lee_yang.py) · [`python/partial_sum_tail.py`](python/partial_sum_tail.py) · [`python/polygon_zero.py`](python/polygon_zero.py).
- Summary sections used for the status audit: [`summary/05-spectral-measures-and-tightness`](../../summary/05-spectral-measures-and-tightness/README.md), [`summary/06-davenport-heilbronn`](../../summary/06-davenport-heilbronn/README.md), [`summary/13-working-notes`](../../summary/13-working-notes/README.md).
- Inventory: [`scraps.html`](../../scraps.html) item 1.
- All topics: [`topics/README.md`](../README.md).
- Formalisation standard: [`PROGRAMME-STANDARD.md`](../PROGRAMME-STANDARD.md).

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
