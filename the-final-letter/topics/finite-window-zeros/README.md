# Finite-window zeros — P3 attack


**Current state and next steps:** see [HANDOFF.md](HANDOFF.md).
**Status: P3 has a point and a thin segment.** The finite algebra, the pair estimate,
the identity `(1-2^{1-s})ζ(s) = η(s)` for every `0 < Re s`, `s ≠ 1`, the tail
bound and the verified complex-power atom are Lean-proved. `Cert.lean` assembles
a 100-pair certificate and proves

```lean
theorem zeta_half_plus_five_ne_zero :
    riemannZeta ((1 / 2 : ℂ) + 5 * Complex.I) ≠ 0
```

with no atom hypothesis. `Seg.lean` also proves the thin segment

```lean
theorem zeta_ne_zero_segment {s : ℂ} (hs : Cx.mem s Sseg) :
    riemannZeta s ≠ 0
```

for `Sseg = {1/2 + it : t ∈ [5, 5.000003]}`. These are finite-window
zero-free statements, not a zero count and not a statement about RH. Wider
segments and P4 remain open.
**Source:** P3/R14 of [`status.html`](../../status.html) §7; the eta/zeta identity
is the standard alternating-series identity, recorded as a source theorem in
[`topics/partial-sum-plus-tail/lean/SourceClaims.lean`](../partial-sum-plus-tail/lean/SourceClaims.lean)
for `Re s > 1`.
**Inventory:** [Scraps](../../scraps.html) item 47 · [Topic index](../README.md).

## What this dossier is

P3 asks for *one* theorem whose numerical premise is discharged by a Lean
certificate. The chosen finite-window object is a segment of the critical line,
reached through the grouped alternating (eta) series

\[
\eta(s)=\sum_{n\ge1}(-1)^{n-1}n^{-s}
      =\sum_{m\ge0}\bigl((2m+1)^{-s}-(2m+2)^{-s}\bigr).
\]

The pairing is absolutely convergent for `Re s > 0`, and the classical identity

\[
(1-2^{1-s})\,\zeta(s)=\eta(s)
\tag{E}
\]

holds for `Re s > 0`. If a certified rectangle for `η` and a certified lower
bound for `|1-2^{1-s}|` are available, then `ζ` is enclosed on the same window,
and a box that excludes zero certifies nonvanishing there. No claim about RH is
made or implied: this is a finite-window statement.

The dossier separates three layers:

1. **Finite algebra and the pair estimate** — Lean-proved here.
2. **Analytic continuation of (E) to `Re s > 0`** — standard, not yet in Lean.
3. **The Lean enclosure certificate** — the missing numerical premise.

## Objects and notation

| Object | Definition | Where |
|---|---|---|
| `altPartial s N` | `Σ_{n<N} (-1)^n / (n+1)^s` | `lean/Topic.lean` |
| `pairTerm s m` | `(2m+1)^{-s} - (2m+2)^{-s}` | `lean/Topic.lean` |
| `pairPartial s M` | `Σ_{m<M} pairTerm s m` | `lean/Topic.lean` |
| `pair_tail_bound` | `\|s\|[(2M+1)^{-p} + (2M+1)^{1-p}/(2(p-1))]`, `p = σ+1` | `python/programme.py` |
| `eta_enclosure` | interval box for `η` on a rectangle plus the tail radius | `python/programme.py` |
| `factor_enclosure` | interval box for `1 - 2^{1-s}` | `python/programme.py` |
| `zeta_enclosure` | `η`-box divided by the factor, inflated by `tail/|f|` | `python/programme.py` |

## Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean)
with no `sorry`, `axiom` or `admit`. Every row marked **Computation** is tested
in [`tests/test_programme.py`](tests/test_programme.py). Nothing here asserts RH.

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | Finite regrouping: the alternating partial sum over `2M` terms equals the sum of the `M` adjacent odd/even pairs. | `FiniteWindowZeros.altPartial_two_mul` |
| T2 | Theorem | Pair estimate: for `Re s ≥ σ > 0`, `‖pairTerm s m‖ ≤ ‖s‖(2m+1)^{-σ-1}` (mean-value bound on `[2m+1,2m+2]`). | `FiniteWindowZeros.norm_pairTerm_le` |
| T3 | Theorem | The majorant `m ↦ (2m+1)^{-p}` is summable for `p > 1`; consequence for `p = σ+1`. | `summable_pairMajorant`, `summable_pairMajorant'` |
| T4 | Theorem | The grouped eta series is summable for `Re s > 0`. | `FiniteWindowZeros.summable_pairTerm` |
| T5 | Theorem | **Eta identity on `Re s > 1`:** `(1-2^{1-s})ζ(s) = η(s)`, by splitting `ζ` into odd and even terms. | `etaGrouped_eq_one_sub_two_cpow_mul_zeta` |
| T6 | Theorem | The identity on the upper quadrant `Re s > 0`, `Im s > 0`, by the identity theorem (both sides analytic, agreement on `Re s > 1`). | `etaGrouped_eq_one_sub_two_cpow_mul_zeta_of_im_pos` |
| T7 | Theorem | The same on the lower quadrant `Re s > 0`, `Im s < 0`. | `etaGrouped_eq_one_sub_two_cpow_mul_zeta_of_im_neg` |
| T8 | Theorem | **Eta identity for every `0 < Re s`, `s ≠ 1`**, by continuity on the real axis. | `etaGrouped_eq_one_sub_two_cpow_mul_zeta_of_re_pos` |
| T9 | Theorem | **Transfer:** if `etaGrouped s ≠ 0` on `0 < Re s`, `s ≠ 1`, then `ζ(s) ≠ 0`; set/box version for an enclosure excluding zero. | `zeta_ne_zero_of_eta_ne_zero`, `zeta_ne_zero_of_eta_mem` |
| T10 | Theorem | **Tail comparison:** `Σ_{m≥0}(2(m+M)+1)^{-p} ≤ (2M+1)^{-p} + (2M+1)^{1-p}/(2(p-1))` for `p > 1`, by the decreasing-sum/integral comparison. | `tsum_pairMajorant_add_le` |
| T11 | Theorem | **Norm tail bound:** the grouped eta tail after `M` pairs is at most `‖s‖[(2M+1)^{-σ-1} + (2M+1)^{-σ}/(2σ)]`, `σ = Re s`. | `norm_tsum_pairTerm_tail_le` |
| T12 | Theorem | **P3 instance:** `ζ(1/2 + 5i) ≠ 0`, certified by a 100-pair rational enclosure of `η`, the Lean tail bound, and the box-excludes-zero test. No atom hypothesis. | `zeta_half_plus_five_ne_zero` (`Cert.lean`) |
| T13 | Theorem | **P3 thin segment:** `ζ(1/2+it) ≠ 0` for every `t ∈ [5, 5.000003]`, by the same certificate on the rectangle. | `zeta_ne_zero_segment` (`Seg.lean`) |
| T14 | Theorem | **Complex mean value inequality:** if `‖f′‖ ≤ C` on the segment `[x,y]`, then `‖f(y)-f(x)‖ ≤ C‖y-x‖`. | `norm_sub_le_of_deriv_bound` (`Krawczyk.lean`) |
| T15 | Theorem | **Newton-map Lipschitz bound:** if `‖1 - Y f′‖ ≤ q` on `[x,y]`, then `‖(x-Yf x)-(y-Yf y)‖ ≤ q‖x-y‖`. | `norm_newton_sub_le` (`Krawczyk.lean`) |
| T16 | Theorem | **Newton map preserves the ball:** under `‖Y f(x₀)‖ + q r ≤ r`, the map `z ↦ z-Yf(z)` sends `closedBall x₀ r` into itself. | `newton_mapsTo_closedBall` (`Krawczyk.lean`) |
| T17 | Theorem | **Krawczyk zero existence:** if the Newton map sends the closed ball into itself and is a `q`-contraction (`q<1`), then `f` has a zero in the ball. | `exists_zero_of_krawczyk` (`Krawczyk.lean`) |
| T18 | Theorem | **First Euler–Maclaurin brick:** `∫₀¹ B₁(x) dx = 0` for the first Bernoulli polynomial. | `integral_bernoulli_one` (`EulerMaclaurin.lean`) |
| T19 | Theorem | **General Bernoulli integral:** `∫₀¹ B_n(x) dx = 0` for every `n ≥ 1`. | `integral_bernoulli` (`EulerMaclaurin.lean`) |
| T20 | Theorem | **Periodic Bernoulli integral:** for every `n ≥ 1` and every integer `k`, `∫_k^{k+1} B_n({x}) dx = 0`. | `integral_periodicBernoulli` (`EulerMaclaurin.lean`) |
| T21 | Theorem | **Periodic Bernoulli continuity away from integers:** `B_n({x})` is continuous at every non-integer `x`. | `continuousAt_periodicBernoulli_of_not_int` (`EulerMaclaurin.lean`) |
| T22 | Theorem | **Periodic Bernoulli continuity at integers:** for `n ≥ 2`, `B_n({x})` is continuous at every integer `m`. | `continuousAt_periodicBernoulli_int` (`EulerMaclaurin.lean`) |
| T23 | Theorem | **One-step summation by parts:** `∫₀¹ f B_n = B_{n+1}(0)/(n+1)(f(1)-f(0)) - 1/(n+1)∫₀¹ f′ B_{n+1}` for `f ∈ C¹`. | `sum_by_parts_zero_one` (`EulerMaclaurin.lean`) |
| T24 | Theorem | **Base Euler–Maclaurin identity:** `∫₀¹ (x−1/2) f′ = (f(1)+f(0))/2 − ∫₀¹ f`. | `integral_B1_mul_deriv` (`EulerMaclaurin.lean`) |
| T25 | Theorem | **Interval Euler–Maclaurin identity:** `∫_k^{k+1} (x−k−1/2)f′ = (f(k+1)+f(k))/2 − ∫_k^{k+1} f` for every integer `k`. | `integral_B1_mul_deriv_int` (`EulerMaclaurin.lean`) |
| T26 | Theorem | **Finite Euler–Maclaurin summation:** `Σ_{k<n} f(k) = ∫_0^n f + Σ_{k<n} ∫_k^{k+1}(x−k−1/2)f′ − (f(n)−f(0))/2`, for `f ∈ C¹` with continuous `f′`. | `sum_range_euler_maclaurin` (`EulerMaclaurin.lean`) |
| T27 | Theorem | **Two-step Bernoulli expansion:** iterating T23 once gives the `B_n`, `B_{n+1}`, `B_{n+2}` correction on `[0,1]`. | `sum_by_parts_two_step` (`EulerMaclaurin.lean`) |
| T28 | Theorem | **Three-step Bernoulli expansion:** iterating T23 twice gives the `B_n` through `B_{n+3}` correction on `[0,1]`. | `sum_by_parts_three_step` (`EulerMaclaurin.lean`) |
| T29 | Theorem | **General Euler–Maclaurin expansion:** for any `K`, `∫₀¹ g₀ B_n` equals the recursive `K`-correction expansion, by induction using T23. | `integral_eq_emExpansion` (`EulerMaclaurin.lean`) |
| T30 | Theorem | **Derivative of the shifted power:** `d/dx (x+1)^{-σ} = −σ(x+1)^{-σ−1}` for `x ≥ 0`. | `hasDerivAt_one_add_rpow` (`EulerMaclaurin.lean`) |
| T31 | Theorem | **Complex power derivative:** `d/dx (x^{-s}) = −s x^{-s−1}` for `x > 0`, `s : ℂ`. | `hasDerivAt_cpow_neg` (`EulerMaclaurin.lean`) |
| T32 | Theorem | **Complex one-step summation by parts:** the T23 identity for `f : ℝ → ℂ`. | `sum_by_parts_zero_one_complex` (`EulerMaclaurin.lean`) |
| T33 | Theorem | **Complex general Euler–Maclaurin expansion:** for any `K`, `∫₀¹ g₀ B_n = emExpansionC n K g` for `ℂ`-valued `g`. | `integral_eq_emExpansionC` (`EulerMaclaurin.lean`) |
| T34 | Theorem | **Pochhammer recurrence for `emG`:** `D_{j+1}(−s) = D_j(−s)·(−s−j)`. | `emG_succ` (`EulerMaclaurin.lean`) |
| T35 | Theorem | **Derivative of the `emG` sequence:** `d/dx emG(s,j) = emG(s,j+1)` on `x ≥ 0`. | `hasDerivAt_emG` (`EulerMaclaurin.lean`) |
| T36 | Theorem | **Complex EM for the `emG` tower:** `∫₀¹ emG(s,0)·B_n = emExpansionC n K (emG s)` for every `K`. | `integral_emG_eq_emExpansionC` (`EulerMaclaurin.lean`) |
| T37 | Theorem | **Complex EM for `(x+1)^{-s}`:** `∫₀¹ (x+1)^{-s} B_n = emExpansionC n K (emG s)`. | `integral_cpow_eq_emExpansionC` (`EulerMaclaurin.lean`) |
| T38 | Theorem | **Complex translation of `ContinuousOn`:** `f ∈ C(uIcc k (k+1))` implies `t ↦ f(t+k)` is `C(uIcc 0 1)`. | `continuousOn_comp_add_int_complex` (`EulerMaclaurin.lean`) |
| T39 | Theorem | **Complex translation of `IntervalIntegrable`:** `f` integrable on `[k,k+1]` implies `t ↦ f(t+k)` integrable on `[0,1]`. | `intervalIntegrable_comp_add_int_complex` (`EulerMaclaurin.lean`) |
| T40 | Theorem | **Complex base identity:** `∫₀¹ (x−1/2)f′ = (f(1)+f(0))/2 − ∫₀¹ f` for `ℂ`-valued `f`. | `integral_B1_mul_deriv_complex` (`EulerMaclaurin.lean`) |
| T41 | Theorem | **Complex interval identity:** the same identity on `[k,k+1]`. | `integral_B1_mul_deriv_int_complex` (`EulerMaclaurin.lean`) |
| T42 | Theorem | **Complex finite EM summation:** the finite sum formula for `ℂ`-valued `f`. | `sum_range_euler_maclaurin_complex` (`EulerMaclaurin.lean`) |
| T43 | Theorem | **Complex finite EM on `[0,∞)`:** T42 with differentiability only for `x ≥ 0`. | `sum_range_euler_maclaurin_complex_nonneg` (`EulerMaclaurin.lean`) |
| T44 | Theorem | **EM for `(k+1)^{-s}`:** the first-order finite formula for the shifted power. | `sum_shifted_cpow_euler_maclaurin` (`EulerMaclaurin.lean`) |
| T45 | Theorem | **Norm of `x^{-s}`:** `‖x^{-s}‖ = x^{-Re s}` for `x > 0`. | `norm_cpow_neg_ofReal` (`EulerMaclaurin.lean`) |
| T46 | Theorem | **Pointwise correction bound:** `‖(x−k−1/2)(−s(x+1)^{-s−1})‖ ≤ ‖s‖/2·(k+1)^{-Re s−1}`. | `norm_correction_integrand_le` (`EulerMaclaurin.lean`) |
| T47 | Theorem | **Integral correction bound:** the same bound after integrating over `[k,k+1]`. | `norm_integral_correction_le` (`EulerMaclaurin.lean`) |
| T48 | Theorem | **Summed correction bound:** the sum of T47. | `norm_sum_correction_le` (`EulerMaclaurin.lean`) |
| T49 | Theorem | **Crude weight bound:** `Σ(k+1)^{-σ−1} ≤ n`. | `sum_shifted_rpow_le` (`EulerMaclaurin.lean`) |
| T50 | Theorem | **Finite value enclosure:** remainder `≤ n‖s‖/2`. | `finite_sum_enclosure` (`EulerMaclaurin.lean`) |
| T51 | Theorem | **Monotonicity of the weight:** `x ↦ (x+1)^{-σ−1}` is antitone. | `antitoneOn_shifted_rpow` (`EulerMaclaurin.lean`) |
| T52 | Theorem | **Tail integral bound:** `∫_a^b x^{-σ−1} ≤ 1/σ`. | `integral_rpow_neg_le_inv` (`EulerMaclaurin.lean`) |
| T53 | Theorem | **Sharp weight bound:** `Σ(k+1)^{-σ−1} ≤ 1 + 1/σ`. | `sum_shifted_rpow_le_inv` (`EulerMaclaurin.lean`) |
| T54 | Theorem | **Uniform correction bound:** `≤ ‖s‖/2·(1+1/σ)`, independent of `n`. | `norm_sum_correction_le_uniform` (`EulerMaclaurin.lean`) |
| T55 | Theorem | **Uniform finite value enclosure:** uniform remainder. | `finite_sum_enclosure_uniform` (`EulerMaclaurin.lean`) |
| T56 | Theorem | **Bound on `B₂`:** `|B₂(x)| ≤ 1/6` on `[0,1]`. | `abs_BR_two_le` (`EulerMaclaurin.lean`) |
| T57 | Theorem | **Second-order interval identity:** `∫_k^{k+1} B₁({x})f′ = (1/12)(f′(k+1)−f′(k)) − (1/2)∫ B₂({x})f″`. | `integral_B1_mul_deriv_int_one` (`EulerMaclaurin.lean`) |
| T58 | Theorem | **Telescoping sum:** `Σ_{k<n}(g(k+1)−g(k)) = g(n)−g(0)`. | `sum_range_sub_complex` (`EulerMaclaurin.lean`) |
| T59 | Theorem | **Natural-index second-order identity:** T57 with `k : ℕ`. | `integral_B1_mul_deriv_nat` (`EulerMaclaurin.lean`) |
| T60 | Theorem | **`emG` telescoping:** `Σ_{k<n}(emG(s,1,k+1)−emG(s,1,k)) = emG(s,1,n)−emG(s,1,0)`. | `sum_range_emG_one_sub` (`EulerMaclaurin.lean`) |
| T61 | Theorem | **Summed second-order correction:** `Σ_k ∫B₁({x})f′ = (1/12)(f′(n)−f′(0)) − (1/2)Σ_k∫B₂({x})f″`. | `sum_correction_second_order` (`EulerMaclaurin.lean`) |
| T62 | Theorem | **Second-order finite EM formula:** the finite sum with the `B₁` and `B₂` corrections. | `sum_second_order` (`EulerMaclaurin.lean`) |
| T63 | Theorem | **Norm of `emG(s,2)`:** `‖emG(s,2,x)‖ = ‖s‖‖s+1‖(x+1)^{-Re s−2}`. | `norm_emG_two` (`EulerMaclaurin.lean`) |
| T64 | Theorem | **Pointwise `B₂` integrand bound:** `‖emG(s,2,x)B₂({x})‖ ≤ (1/6)‖s‖‖s+1‖(k+1)^{-Re s−2}`. | `norm_B2_correction_integrand_le` (`EulerMaclaurin.lean`) |
| T65 | Theorem | **Integral `B₂` bound:** the same bound after integrating over `[k,k+1]`. | `norm_integral_B2_correction_le` (`EulerMaclaurin.lean`) |
| T66 | Theorem | **Summed `B₂` bound:** the sum of T65. | `norm_sum_B2_correction_le` (`EulerMaclaurin.lean`) |
| T67 | Theorem | **`B₂` weight bound:** `Σ(k+1)^{-σ−2} ≤ 1 + 1/(σ+1)`. | `sum_B2_weights_le` (`EulerMaclaurin.lean`) |
| T68 | Theorem | **Second-order finite value enclosure:** remainder `≤ (1/12)‖s‖‖s+1‖(1+1/(σ+1))`. | `finite_sum_enclosure_second_order` (`EulerMaclaurin.lean`) |
| T69 | Theorem | **Exact shifted-power integral:** `∫₀^n (x+1)^{-s} = ((n+1)^{1-s}−1)/(1−s)` for `s≠1`. | `integral_cpow_shift` (`EulerMaclaurin.lean`) |
| T70 | Theorem | **Vanishing tail weight:** for `σ > 1`, `((n+1))^{1−σ} → 0`. | `tendsto_shifted_rpow_zero` (`EulerMaclaurin.lean`) |
| T71 | Theorem | **Summable `B₂` weights:** for `σ > −1`, `Σ(n+1)^{-σ−2}` converges. | `summable_shifted_rpow` (`EulerMaclaurin.lean`) |
| T72 | Theorem | **Summable `B₂` correction:** the `B₂` integral series converges absolutely for `σ > −1`. | `summable_B2_correction` (`EulerMaclaurin.lean`) |
| T73 | Theorem | **Convergent `B₂` partial sums:** `Σ_{k<n}∫B₂f″ → ∑'` for `σ > −1`. | `tendsto_sum_B2_correction` (`EulerMaclaurin.lean`) |
| T74 | Theorem | **Complex tail limit:** `(n+1)^{1-s} → 0` for `Re s > 1`. | `tendsto_cpow_shift_zero` (`EulerMaclaurin.lean`) |
| T75 | Theorem | **Integral limit:** `∫₀^n (x+1)^{-s} → 1/(s−1)` for `Re s > 1`. | `tendsto_integral_cpow_shift` (`EulerMaclaurin.lean`) |
| T76 | Theorem | **Inverse-square decay:** `(n+1)^{-2} → 0`. | `tendsto_shifted_rpow_neg_two` (`EulerMaclaurin.lean`) |
| T77 | Theorem | **Norm of `emG(s,1)`:** `‖emG(s,1,x)‖ = ‖s‖(x+1)^{-Re s−1}`. | `norm_emG_one` (`EulerMaclaurin.lean`) |
| T78 | Theorem | **`f′` tends to zero:** `emG(s,1,n) → 0` for `Re s > 1`. | `tendsto_emG_one_zero` (`EulerMaclaurin.lean`) |
| T79 | Theorem | **Weight limit:** `(n+1)^{-s} → 0` for `Re s > 1`. | `tendsto_cpow_neg_zero` (`EulerMaclaurin.lean`) |
| T80 | Theorem | **Finite-sum limit:** for `Re s > 1`, `Σ_{k<n}(k+1)^{-s}` tends to the second-order Euler–Maclaurin expression. | `tendsto_sum_shifted_cpow` (`EulerMaclaurin.lean`) |
| T81 | Theorem | **Second-order continuation of `ζ`:** for `Re s > 1`, `ζ(s)` equals the second-order Euler–Maclaurin expression. | `zeta_eq_second_order` (`EulerMaclaurin.lean`) |
| T82 | Theorem | **Shifted `emG` recurrence:** `emGShift(s,N,j+1) = emGShift(s,N,j)·(−s−j)`. | `emGShift_succ` (`EulerMaclaurin.lean`) |
| T83 | Theorem | **Shifted `emG` derivative:** `d/dx emGShift(s,N,j) = emGShift(s,N,j+1)`. | `hasDerivAt_emGShift` (`EulerMaclaurin.lean`) |
| T84 | Theorem | **First-order tail formula:** the EM formula for `Σ_{k<n}(k+N+1)^{-s}`. | `sum_tail_first_order` (`EulerMaclaurin.lean`) |
| T85 | Theorem | **Shifted first-derivative norm:** `‖emGShift(s,N,1,x)‖ = ‖s‖(x+N+1)^{-Re s−1}`. | `norm_emGShift_one` (`EulerMaclaurin.lean`) |
| T86 | Theorem | **Shifted correction bound:** `‖(x−k−1/2)emGShift(s,N,1,x)‖ ≤ ‖s‖/2·(k+N+1)^{-Re s−1}`. | `norm_tail_correction_integrand_le` (`EulerMaclaurin.lean`) |
| T87 | Theorem | **Shifted integral bound:** the same bound after integrating over `[k,k+1]`. | `norm_integral_tail_correction_le` (`EulerMaclaurin.lean`) |
| T88 | Theorem | **Shifted summed bound:** the sum of T87. | `norm_sum_tail_correction_le` (`EulerMaclaurin.lean`) |
| T89 | Theorem | **Shifted weight bound:** `Σ(k+N+1)^{-σ−1} ≤ 1+1/σ`. | `sum_tail_weights_le` (`EulerMaclaurin.lean`) |
| T90 | Theorem | **Tail integral:** `∫_{Ioi c} x^{-s} = c^{1-s}/(s−1)` for `Re s > 1`. | `integral_Ioi_cpow_neg` (`EulerMaclaurin.lean`) |
| T91 | Theorem | **Shifted tail integral limit:** `∫₀^n (x+N+1)^{-s} → (N+1)^{1-s}/(s−1)` for `Re s > 1`. | `tendsto_integral_tail_cpow` (`EulerMaclaurin.lean`) |
| T92 | Theorem | **Summable tail weights:** for `σ > 0`, `Σ(k+N+1)^{-σ−1}` converges. | `summable_tail_rpow` (`EulerMaclaurin.lean`) |
| T93 | Theorem | **Summable tail correction:** the shifted correction series converges absolutely for `σ > 0`. | `summable_tail_correction` (`EulerMaclaurin.lean`) |
| T94 | Theorem | **Shifted weight limit:** `emGShift(s,N,0,n) → 0` for `Re s > 1`. | `tendsto_emGShift_zero` (`EulerMaclaurin.lean`) |
| T95 | Theorem | **Convergent shifted correction:** `Σ_{k<n}∫(x−k−1/2)emGShift(s,N,1,x) → ∑'`. | `tendsto_sum_tail_correction` (`EulerMaclaurin.lean`) |
| T96 | Theorem | **Fixed-`N` tail limit:** for `Re s > 1`, `Σ_{k<n}emGShift(s,N,0,k)` converges to the fixed-`N` expression. | `tendsto_sum_tail` (`EulerMaclaurin.lean`) |
| T97 | Theorem | **Fixed-`N` Euler–Maclaurin for `ζ`:** for `Re s > 1`, `ζ(s)` equals the finite prefix plus the fixed-`N` tail expression. | `zeta_eq_fixed_N` (`EulerMaclaurin.lean`) |
| T98 | Theorem | **Entire finite prefix:** `s ↦ Σ_{n<N}(n+1)^{-s}` is differentiable on `ℂ`. | `differentiable_fixed_prefix` (`EulerMaclaurin.lean`) |
| T99 | Theorem | **Integrand analyticity:** for `x ≥ 0`, `s ↦ emGShift(s,N,1,x)` is entire. | `differentiable_emGShift_one` (`EulerMaclaurin.lean`) |
| T100 | Theorem | **Derivative in `s`:** explicit `∂_s emGShift(s,N,1,x)`. | `hasDerivAt_emGShift_one` (`EulerMaclaurin.lean`) |
| T101 | Theorem | **Pole-term analyticity:** `s ↦ (N+1)^{1-s}/(s−1)` is differentiable away from `s = 1`. | `differentiableAt_pole_term` (`EulerMaclaurin.lean`) |
| T102 | Theorem | **Integrand continuity in `x`:** `x ↦ emGShift(s,N,1,x)` is continuous on `[0,∞)`. | `continuousOn_emGShift_one` (`EulerMaclaurin.lean`) |
| T103 | Theorem | **Interval integrability:** `x ↦ emGShift(s,N,1,x)` is interval-integrable on `[k,k+1]`. | `intervalIntegrable_emGShift_one` (`EulerMaclaurin.lean`) |
| T104 | Theorem | **Integrand measurability:** the correction integrand is AE-strongly-measurable on `(k,k+1]`. | `aestronglyMeasurable_correction_integrand` (`EulerMaclaurin.lean`) |
| T105 | Theorem | **`s`-derivative continuity:** `x ↦ ∂_s emGShift(s,N,1,x)` is continuous on `(k,k+1]`. | `continuousOn_sDeriv_emGShift` (`EulerMaclaurin.lean`) |
| T106 | Theorem | **`s`-derivative measurability:** the same function is AE-strongly-measurable on `(k,k+1]`. | `aestronglyMeasurable_sDeriv_emGShift` (`EulerMaclaurin.lean`) |
| T107 | Theorem | **Log majorant integrability:** `x ↦ 1 + |log(x+N+1)|` is interval-integrable. | `intervalIntegrable_log_bound` (`EulerMaclaurin.lean`) |
| T108 | Theorem | **Joint continuity:** `(s,x) ↦ ∂_s emGShift(s,N,1,x)` is continuous on `closedBall(0,R) × [k,k+1]`. | `continuousOn_sDeriv_pair` (`EulerMaclaurin.lean`) |
| T109 | Theorem | **Uniform derivative bound:** exists `C` with `‖∂_s emGShift(s,N,1,x)‖ ≤ C` on `‖s‖ ≤ R`, `x ∈ [k,k+1]`. | `exists_sDeriv_bound` (`EulerMaclaurin.lean`) |
| T110 | Theorem | **Correction interval integrability:** `x ↦ (x−k−1/2)emGShift(s,N,1,x)` is interval-integrable. | `intervalIntegrable_correction` (`EulerMaclaurin.lean`) |
| T111 | Theorem | **Parametric differentiability:** `s ↦ ∫_k^{k+1}(x−k−1/2)emGShift(s,N,1,x)` is differentiable at every `s₀`. | `differentiableAt_correction_integral` (`EulerMaclaurin.lean`) |
| T112 | Theorem | **Uniform strip bound:** `‖∫‖ ≤ (R/2)(k+N+1)^{-ρ−1}` on `Re s ≥ ρ`, `‖s‖ ≤ R`. | `norm_correction_le_on` (`EulerMaclaurin.lean`) |
| T113 | Theorem | **Local analyticity of the correction series:** differentiable on a ball intersected with `Re s > ρ`. | `differentiableOn_tsum_correction` (`EulerMaclaurin.lean`) |
| T114 | Theorem | **Global analyticity of the correction series:** differentiable on `{Re s > 0}`. | `differentiableOn_correction` (`EulerMaclaurin.lean`) |
| T115 | Theorem | **Entire zero-level tower:** `s ↦ emGShift(s,N,0,x)` is entire for `x ≥ 0`. | `differentiable_emGShift_zero` (`EulerMaclaurin.lean`) |
| T116 | Definition | **Fixed-`N` expression:** `zetaEM N s = Σ_{n<N}(n+1)^{-s} + (N+1)^{1-s}/(s−1) + C_N(s) + emGShift(s,N,0,0)/2`. | `zetaEM` (`EulerMaclaurin.lean`) |
| T117 | Theorem | **Analyticity of `zetaEM`:** differentiable on `{Re s > 0} \ {1}`. | `differentiableOn_zetaEM` (`EulerMaclaurin.lean`) |
| T118 | Theorem | **Agreement on `Re s > 1`:** `ζ(s) = zetaEM N s` for `Re s > 1`. | `zeta_eq_zetaEM_of_one_lt` (`EulerMaclaurin.lean`) |
| T119 | Theorem | **Continuation into the critical strip:** for `Re s > 0` and `1 < Im s < 20`, `ζ(s) = zetaEM N s`. | `zeta_eq_zetaEM_of_im` (`EulerMaclaurin.lean`) |
| T120 | Theorem | **Bernoulli evaluation:** `(BR n)(0) = bernoulli n` as a real number. | `BR_eval_zero` (`EulerMaclaurin.lean`) |
| T121 | Theorem | **Bernoulli polynomial identification:** `(BR n)(x) = bernoulliFun n x`. | `BR_eval_eq_bernoulliFun` (`EulerMaclaurin.lean`) |
| T122 | Theorem | **Uniform Bernoulli bound:** `bernoulliFun k` is bounded on `[0,1]`. | `exists_bernoulliFun_bound` (`EulerMaclaurin.lean`) |
| T123 | Theorem | **Fourier character norm:** `‖fourier n x‖ = 1`. | `norm_fourier_unit` (`EulerMaclaurin.lean`) |
| T124 | Theorem | **Fourier term norm:** `‖(1/n^k) fourier n x‖ = 1/|n|^k`. | `norm_fourier_term` (`EulerMaclaurin.lean`) |
| T125 | Theorem | **`ℤ`-sum decomposition:** `Σ_{n:ℤ}1/|n|^k = 2Σ_{n≥1}1/n^k`. | `tsum_int_inv_abs_pow` (`EulerMaclaurin.lean`) |
| T126 | Theorem | **Inverse-power sum is `Re ζ(k)`:** `Σ_{n≥1}1/n^k = Re ζ(k)`. | `zeta_nat_eq_tsum_inv_pow` (`EulerMaclaurin.lean`) |
| T127 | Theorem | **Fourier series norm bound:** `‖Σ_{n:ℤ}1/n^k fourier n x‖ ≤ 2 Re ζ(k)`. | `norm_fourier_series_le` (`EulerMaclaurin.lean`) |
| T128 | Theorem | **Periodic Bernoulli bound:** `|B_k(x)| ≤ k!/(2π)^k · 2 Re ζ(k)`. | `abs_bernoulliFun_le` (`EulerMaclaurin.lean`) |
| T129 | Theorem | **Periodic bound at any real:** `|B_k({x})| ≤ k!/(2π)^k · 2 Re ζ(k)`. | `abs_bernoulliFun_fract_le` (`EulerMaclaurin.lean`) |
| T130 | Theorem | **Norm of `emGShift`:** `‖emGShift(s,N,j,x)‖ = ‖(s)_j‖(x+N+1)^{-Re s−j}`. | `norm_emGShift` (`EulerMaclaurin.lean`) |
| T131 | Theorem | **Nonnegativity:** `0 ≤ Re ζ(n)` for natural `n ≥ 2`. | `zeta_re_nonneg` (`EulerMaclaurin.lean`) |
| T132 | Theorem | **Pointwise Bernoulli–tower bound.** | `norm_bernoulli_mul_emGShift_le` (`EulerMaclaurin.lean`) |
| T133 | Theorem | **Integral Bernoulli–tower bound.** | `norm_integral_bernoulli_mul_emGShift_le` (`EulerMaclaurin.lean`) |
| T134 | Theorem | **Summed Bernoulli–tower bound.** | `norm_sum_bernoulli_mul_emGShift_le` (`EulerMaclaurin.lean`) |
| T135 | Theorem | **General tail weight bound:** `Σ(k+N+1)^{-σ−j} ≤ 1+1/(σ+j−1)`. | `sum_tail_rpow_le_inv_general` (`EulerMaclaurin.lean`) |
| T136 | Theorem | **Coarse general remainder bound:** the `j`-th Bernoulli sum is bounded by `C_j‖(s)_j‖(1+1/(σ+j−1))`. | `norm_general_correction_le` (`EulerMaclaurin.lean`) |
| T137 | Theorem | **Shifted antitonicity:** `x ↦ (x+N+1)^{-σ}` is antitone on `[0,∞)`. | `antitoneOn_shifted_rpow_shift` (`EulerMaclaurin.lean`) |
| T138 | Theorem | **Shifted continuity:** `x ↦ (x+N+1)^{-σ}` is continuous on `[0,∞)`. | `continuousOn_shifted_rpow` (`EulerMaclaurin.lean`) |
| T139 | Theorem | **Real tail integral:** `∫_{Ioi c} x^{-σ} = c^{1−σ}/(σ−1)` for `σ > 1`. | `integral_Ioi_rpow_neg` (`EulerMaclaurin.lean`) |
| T140 | Theorem | **Shifted integrability:** `x ↦ (x+N+1)^{-σ}` is integrable on `(0,∞)`. | `integrableOn_shift_rpow` (`EulerMaclaurin.lean`) |
| T141 | Theorem | **Shifted tail integral:** `∫_{Ioi 0}(x+N+1)^{-σ} = (N+1)^{1−σ}/(σ−1)`. | `integral_Ioi_shift_rpow` (`EulerMaclaurin.lean`) |
| T142 | Theorem | **Sharp tail bound:** `Σ_k(k+N+1)^{-σ} ≤ (N+1)^{-σ} + (N+1)^{1−σ}/(σ−1)`. | `tsum_shift_rpow_le` (`EulerMaclaurin.lean`) |
| T143 | Theorem | **Sharp general remainder:** the `j`-th Bernoulli sum is bounded by `C_j‖(s)_j‖((N+1)^{-σ−j}+(N+1)^{1−σ−j}/(σ+j−1))`. | `norm_general_correction_le_sharp` (`EulerMaclaurin.lean`) |
| T144 | Theorem | **Sharp `B₂` series bound:** the infinite `B₂` correction series obeys the sharp `N`-decay. | `norm_tsum_correction_le_sharp` (`EulerMaclaurin.lean`) |
| T145 | Theorem | **First-order correction bound:** the `(x−k−1/2)f′` series is bounded by `(‖s‖/2)((N+1)^{-σ−1}+(N+1)^{-σ}/σ)`. | `norm_tsum_correction_first_le` (`EulerMaclaurin.lean`) |
| T146 | Theorem | **Certified `ζ` value enclosure:** `ζ` differs from the explicit base by the T145 bound on the first-zero strip. | `norm_zeta_sub_base_le` (`EulerMaclaurin.lean`) |
| T147 | Theorem | **Boundary derivative:** explicit `∂_s emGShift(s,N,0,x)`. | `hasDerivAt_emGShift_zero` (`EulerMaclaurin.lean`) |
| T148 | Theorem | **Krawczyk for `ζ`:** the abstract Krawczyk criterion instantiated with `f = ζ`, `f′ = deriv ζ`. | `zeta_zero_of_krawczyk` (`Krawczyk.lean`) |
| T149 | Definition | **Explicit base:** `zetaBase N s = prefix + pole + boundary`. | `zetaBase` (`EulerMaclaurin.lean`) |
| T150 | Theorem | **Base decomposition:** `zetaEM = zetaBase + correction series`. | `zetaEM_eq_base_add` (`EulerMaclaurin.lean`) |
| T151 | Theorem | **Base analyticity:** `zetaBase` differentiable on `{Re s > 0} \ {1}`. | `differentiableOn_zetaBase` (`EulerMaclaurin.lean`) |
| T152 | Theorem | **Error against `zetaBase`:** the T146 bound rewritten as `‖ζ − zetaBase‖`. | `norm_zeta_sub_zetaBase_le` (`EulerMaclaurin.lean`) |
| T153 | Theorem | **Cauchy derivative estimate:** `‖deriv f c‖ ≤ 2M/R` from a uniform bound on a ball. | `norm_deriv_le_of_norm_le_on_ball` (`EulerMaclaurin.lean`) |
| T154 | Theorem | **Conditional `ζ′` enclosure:** `‖deriv ζ s₀‖ ≤ ‖deriv zetaBase s₀‖ + 2M/R` from an error bound `M` on a ball. | `norm_deriv_zeta_le_of_bound` (`EulerMaclaurin.lean`) |
| T155 | Theorem | **Uniform error bound:** a closed ball inside the strip has a uniform bound `M` for `‖ζ − zetaBase‖`. | `exists_error_bound_ball` (`EulerMaclaurin.lean`) |
| T156 | Theorem | **General uniform error bound:** same, with an explicit outer ball radius `R₁`. | `exists_error_bound_ball'` (`EulerMaclaurin.lean`) |
| T157 | Theorem | **First-zero ball bound:** `∃ M` bounding `‖ζ − zetaBase‖` on `closedBall(1/2+14i, 1/8)`. | `exists_error_bound_first_zero` (`EulerMaclaurin.lean`) |
| T158 | Theorem | **Concrete `ζ′` bound:** `∃ M` with `‖deriv ζ(s₀)‖ ≤ ‖deriv zetaBase s₀‖ + 16M` at `s₀ = 1/2+14i`. | `deriv_zeta_bound_first_zero` (`EulerMaclaurin.lean`) |
| T159 | Definition/Theorem | **Bernoulli coefficients:** `emCoef j = B_{2j}/(2j)!`, with `emCoef 1 = 1/12`. | `emCoef`, `emCoef_one` (`EulerMaclaurin.lean`) |
| T160 | Theorem | **Second Bernoulli coefficient:** `emCoef 2 = −1/720`. | `emCoef_two` (`EulerMaclaurin.lean`) |
| T161 | Definition | **General-`K` expression:** `zetaEMGen K N s = zetaBase N s + Σ_{j<K} (−emCoef(j+1)) emGShift(s,N,2j+1,0)`. | `zetaEMGen` (`EulerMaclaurin.lean`) |
| T162 | Theorem | **`K = 1` value:** `zetaEMGen 1 = zetaBase + (1/12)s(N+1)^{-s-1}`. | `zetaEMGen_one` (`EulerMaclaurin.lean`) |
| T163 | Theorem | **`K = 0` base case:** `zetaEMGen 0 = zetaBase`. | `zetaEMGen_zero` (`EulerMaclaurin.lean`) |
| T164 | Theorem | **General-`K` recurrence:** `zetaEMGen (K+1) = zetaEMGen K − emCoef(K+1)·emGShift(s,N,2K+1,0)`. | `zetaEMGen_succ` (`EulerMaclaurin.lean`) |
| T165 | Theorem | **Shifted telescoping:** `Σ(emGShift(k+1)−emGShift(k)) = emGShift(n)−emGShift(0)`. | `sum_range_emGShift_one_sub` (`EulerMaclaurin.lean`) |
| T166 | Theorem | **Shifted correction identity:** the second-order `B₂` correction for `emGShift`. | `sum_correction_second_order_shift` (`EulerMaclaurin.lean`) |
| T167 | Theorem | **Shifted second-order EM formula:** the `emGShift` analogue of T62. | `sum_second_order_shift` (`EulerMaclaurin.lean`) |
| T168 | Theorem | **Shifted first tower limit:** `emGShift(s,N,1,n) → 0` for `Re s > 1`. | `tendsto_emGShift_one_zero` (`EulerMaclaurin.lean`) |
| T169 | Theorem | **Boundary coefficient:** `c₁(0−emGShift(s,N,1,0)) = (1/12)s(N+1)^{-s-1}`. | `c1_emGShift_one_zero` (`EulerMaclaurin.lean`) |
| T170 | Theorem | **`K=1` difference form:** `zetaEMGen 1 − zetaBase = (1/12)s(N+1)^{-s-1}`. | `zetaEMGen_one_sub_base` (`EulerMaclaurin.lean`) |
| T171 | Theorem | **Shifted `B₂` summability.** | `summable_B2_shift` (`EulerMaclaurin.lean`) |
| T172 | Theorem | **Shifted `B₂` convergence:** partial sums tend to the `tsum`. | `tendsto_sum_B2_shift` (`EulerMaclaurin.lean`) |
| T173 | Theorem | **Correction-series bridge:** the first-order correction `tsum` equals the `1/12` boundary term minus half the `B₂` `tsum`. | `tsum_correction_first_eq` (`EulerMaclaurin.lean`) |
| T174 | Theorem | **`zetaEM` bridge:** `zetaEM = zetaEMGen 1 − (1/2)Σ'∫B₂emGShift(s,N,2)`. | `zetaEM_eq_gen_one` (`EulerMaclaurin.lean`) |
| T175 | Definition | **General-`K` remainder:** `zetaEMRemainder K N s = zetaEM N s − zetaEMGen K N s`. | `zetaEMRemainder` (`EulerMaclaurin.lean`) |
| T176 | Theorem | **`K=0` remainder:** equals the first-order correction series. | `zetaEMRemainder_zero` (`EulerMaclaurin.lean`) |
| T177 | Theorem | **`K=1` remainder:** equals `−(1/2)Σ'∫B₂emGShift(s,N,2)`. | `zetaEMRemainder_one` (`EulerMaclaurin.lean`) |
| T178 | Theorem | **Remainder recurrence:** `R(K+1) = R(K) + emCoef(K+1)·emGShift(s,N,2K+1,0)`. | `zetaEMRemainder_succ` (`EulerMaclaurin.lean`) |
| T179 | Theorem | **`B₃(0) = 0`.** | `BR_eval_zero_three` (`EulerMaclaurin.lean`) |
| T180 | Theorem | **`B₄(0) = −1/30`.** | `BR_eval_zero_four` (`EulerMaclaurin.lean`) |
| T181 | Theorem | **`B₃(1) = 0`.** | `BR_eval_one_three` (`EulerMaclaurin.lean`) |
| T182 | Theorem | **Derivative of `B₃`:** `d/dx B₃(x) = 3 B₂(x)`. | `hasDerivAt_BR_three` (`EulerMaclaurin.lean`) |
| T183 | Theorem | **Derivative of shifted `B₃`:** `d/dx B₃(x−k) = 3 B₂(x−k)`. | `hasDerivAt_BR_three_shift` (`EulerMaclaurin.lean`) |
| T184 | Theorem | **`B₂` integration by parts:** `∫B₂f = −(1/3)∫B₃f′` on `[k,k+1]`. | `integral_B2_mul_eq` (`EulerMaclaurin.lean`) |
| T185 | Theorem | **Derivative of shifted `B₄`:** `d/dx B₄(x−k) = 4B₃(x−k)`. | `hasDerivAt_BR_four_shift` (`EulerMaclaurin.lean`) |
| T186 | Theorem | **`B₄(1) = −1/30`.** | `BR_eval_one_four` (`EulerMaclaurin.lean`) |
| T187 | Theorem | **`B₃` integration by parts:** `∫B₃f′ = (B₄(0)/4)(f′(k+1)−f′(k)) − (1/4)∫B₄f″`. | `integral_B3_mul_deriv_eq` (`EulerMaclaurin.lean`) |
| T188 | Theorem | **General Bernoulli endpoint equality:** for `n ≠ 1`, `B_n(1) = B_n(0)`. | `BR_eval_one_eq_eval_zero_of_ne_one` (`EulerMaclaurin.lean`) |
| T189 | Theorem | **General shifted Bernoulli derivative:** `d/dx B_{n+1}(x−k) = (n+1)B_n(x−k)`. | `hasDerivAt_BR_succ_shift` (`EulerMaclaurin.lean`) |
| T190 | Theorem | **General Bernoulli integration by parts:** `∫B_nf = (B_{n+1}(0)/(n+1))(f(k+1)−f(k)) − (1/(n+1))∫B_{n+1}f′`. | `integral_BR_mul_eq` (`EulerMaclaurin.lean`) |
| T191 | Theorem | **Summed general IBP:** `Σ_{k<m}∫B_nf = (B_{n+1}(0)/(n+1))(f(m)−f(0)) − (1/(n+1))Σ_{k<m}∫B_{n+1}f′`. | `sum_integral_BR_mul_eq` (`EulerMaclaurin.lean`) |
| T192 | Theorem | **`emGShift` continuity:** `ContinuousOn (emGShift(s,N,j)) (uIcc k (k+1))`. | `continuousOn_emGShift` (`EulerMaclaurin.lean`) |
| T193 | Theorem | **`emGShift` interval integrability.** | `intervalIntegrable_emGShift` (`EulerMaclaurin.lean`) |
| T194 | Theorem | **K=2 finite identity:** `Σ∫B₂ emGShift(2) = (1/360)(emGShift(3,m)−emGShift(3,0)) + (1/12)Σ∫B₄ emGShift(4)`. | `sum_B2_eq_sum_B4` (`EulerMaclaurin.lean`) |
| T195 | Theorem | **General tower limit:** `emGShift(s,N,j,n) → 0` for `Re s > 1`, any `j`. | `tendsto_emGShift_zero_general` (`EulerMaclaurin.lean`) |
| T196 | Theorem | **`B₄` summability.** | `summable_B4_shift` (`EulerMaclaurin.lean`) |
| T197 | Theorem | **`B₄` convergence:** partial sums tend to the `tsum`. | `tendsto_sum_B4_shift` (`EulerMaclaurin.lean`) |
| T198 | Theorem | **`B₂` to `B₄` series:** `Σ'∫B₂emGShift(2) = (1/360)(−emGShift(3,0)) + (1/12)Σ'∫B₄emGShift(4)`. | `tsum_B2_eq_B4` (`EulerMaclaurin.lean`) |
| T199 | Theorem | **`K=1` remainder closed form:** `R₁ = (1/720)emGShift(3,0) − (1/24)Σ'∫B₄emGShift(4)`. | `zetaEMRemainder_one_eq` (`EulerMaclaurin.lean`) |
| T200 | Theorem | **`K=2` remainder:** `R₂ = −(1/24)Σ'∫B₄emGShift(4)`. | `zetaEMRemainder_two_eq` (`EulerMaclaurin.lean`) |
| T201 | Theorem | **Odd Bernoulli endpoint zero:** for odd `n > 1`, `B_n(0) = 0`. | `BR_eval_zero_odd` (`EulerMaclaurin.lean`) |
| T202 | Theorem | **Third Bernoulli coefficient:** `emCoef 3 = 1/30240`. | `emCoef_three` (`EulerMaclaurin.lean`) |
| T203 | Theorem | **Multiplied IBP:** `(n+1)∫B_nf = B_{n+1}(0)(f(k+1)−f(k)) − ∫B_{n+1}f′`. | `integral_BR_mul_eq_mul` (`EulerMaclaurin.lean`) |
| T204 | Theorem | **Summed multiplied IBP:** `(n+1)Σ∫B_nf = B_{n+1}(0)(f(m)−f(0)) − Σ∫B_{n+1}f′`. | `sum_integral_BR_mul_eq_mul` (`EulerMaclaurin.lean`) |
| T205 | Theorem | **Division-free recurrence:** `((2K+1)(2K+2))S₂ₖ = −B_{2K+2}(0)(g(m)−g(0)) + S₂ₖ₊₂`. | `sum_B_even_eq_mul` (`EulerMaclaurin.lean`) |
| T206 | Theorem | **General `B_n` summability.** | `summable_Bn_shift` (`EulerMaclaurin.lean`) |
| T207 | Theorem | **General `B_n` convergence:** partial sums tend to the `tsum`. | `tendsto_sum_Bn_shift` (`EulerMaclaurin.lean`) |
| T208 | Theorem | **`tsum` recurrence:** `S_{2K+2} = (2K+1)(2K+2)S_{2K} − B_{2K+2}(0)emGShift(s,N,2K+1,0)`. | `tsum_B_even_succ` (`EulerMaclaurin.lean`) |
| T209 | Theorem | **Factorial base case:** `R₁ = −(1/2!)S₂`. | `zetaEMRemainder_one_factorial` (`EulerMaclaurin.lean`) |
| T210 | Theorem | **Even-step recurrence:** `R_{k+1} = R_k + emCoef(k+1)emGShift(s,N,2k+1,0)`. | `zetaEMRemainder_succ_even` (`EulerMaclaurin.lean`) |
| T211 | Definition/Theorem | **`S_even` abbreviation:** `S_even k = Σ'∫B_{2k}emGShift(2k)`, with `S_even(k+1) = ((2k+1)(2k+2))S_even k − B_{2k+2}(0)emGShift(2k+1,0)`. | `S_even`, `S_even_succ` (`EulerMaclaurin.lean`) |
| T212 | Theorem | **Factorial remainder formula:** `R_K = −(1/(2K)!)S_even K`. | `zetaEMRemainder_eq_factorial` (`EulerMaclaurin.lean`) |
| T213 | Theorem | **Sharp `S_even` bound:** `‖S_even K‖ ≤ (2K)!/(2π)^{2K}·2Re ζ(2K)·‖(s)_{2K}‖·((N+1)^{-σ-2K}+(N+1)^{1-σ-2K}/(σ+2K-1))`. | `norm_S_even_le` (`EulerMaclaurin.lean`) |
| T214 | Theorem | **Sharp remainder bound:** `‖R_K‖ ≤ (2Re ζ(2K)/(2π)^{2K})·‖(s)_{2K}‖·((N+1)^{-σ-2K}+(N+1)^{1-σ-2K}/(σ+2K-1))`. | `norm_zetaEMRemainder_le` (`EulerMaclaurin.lean`) |
| T215 | Definition/Theorem | **Rational interval layer:** `RatInterval` with `contains`, `exact`, `neg`, `add`, `sub`, `mulNonneg`, `scaleNonneg`, and containment lemmas. | `RatInterval` (`Interval.lean`) |
| T216 | Theorem | **Interval powers and reciprocals:** `powNat` and `invPos` with containment lemmas. | `RatInterval.powNat`, `RatInterval.invPos` (`Interval.lean`) |
| T217 | Theorem | **Interval division:** `divPos` with containment lemma. | `RatInterval.divPos` (`Interval.lean`) |
| T218 | Theorem | **Negative integer interval power:** `zpowNeg` with containment lemma. | `RatInterval.zpowNeg` (`Interval.lean`) |
| T219 | Theorem | **Rational square-root bounds:** `lo² ≤ a ≤ hi²` gives `lo ≤ √a ≤ hi`. | `sqrt_rat_bounds` (`Interval.lean`) |
| T220 | Theorem | **Rational `π` enclosure:** `piInterval` contains `π` to 20 decimal places. | `piInterval`, `piInterval_contains` (`Interval.lean`) |
| T221 | Theorem | **Complex containment:** `containsComplex` and `containsComplex_ofReal`. | `containsComplex`, `containsComplex_ofReal` (`Interval.lean`) |
| T222 | Theorem | **`ζ(2)` enclosure:** `zeta2Interval` contains `Re ζ(2)`. | `zeta2Interval`, `zeta2Interval_contains` (`Interval.lean`) |
| T223 | Theorem | **`ζ(4)` enclosure:** `zeta4Interval` contains `Re ζ(4) = π⁴/90`. | `zeta4Interval`, `zeta4Interval_contains` (`Interval.lean`) |
| T224 | Theorem | **`ζ(6)` enclosure:** `zeta6Interval` contains `Re ζ(6) = π⁶/945`. | `zeta6Interval`, `zeta6Interval_contains` (`Interval.lean`) |
| T225 | Theorem | **Square-root interval constructor:** `sqrtInterval a lo hi` with containment of `√a`. | `sqrtInterval`, `sqrtInterval_contains` (`Interval.lean`) |
| T226 | Theorem | **`(2π)^{-2}` enclosure:** `invTwoPiSqInterval` contains `(2π)^{-2} = 1/(4π²)`. | `invTwoPiSqInterval`, `invTwoPiSqInterval_contains` (`Interval.lean`) |
| T227 | Theorem | **`(2π)^{-4}` enclosure:** `invTwoPiFourthInterval` contains `(2π)^{-4}`. | `invTwoPiFourthInterval`, `invTwoPiFourthInterval_contains` (`Interval.lean`) |
| T228 | Theorem | **`rpow`/`sqrt` bridge:** `x^(1/2) = √x`. | `rpow_half_eq_sqrt` (`Interval.lean`) |
| T229 | Theorem | **`√201` enclosure:** rational interval for `(201)^{-1/2}`-type factors. | `sqrt201Interval`, `sqrt201Interval_contains` (`Interval.lean`) |
| T230 | Theorem | **Concrete Krawczyk target:** existence of a zero in `closedBall(1/2+14i, 1/4)` from `q=1/4` contraction hypotheses. | `zeta_zero_quarter_ball` (`Krawczyk.lean`) |
| T231 | Theorem | **`h1` discharged:** `closedBall(1/2+14i, 1/4)` avoids `1`. | `quarter_ball_ne_one` (`Krawczyk.lean`) |
| T232 | Definition/Theorem | **Rational `Y`:** `Yk = 1.2436403768 − 0.3397942771 i`, with `‖Yk‖ ≤ 2`. | `Yk`, `norm_Yk_le_two` (`Krawczyk.lean`) |
| T233 | Theorem | **`hmap` reduction:** `‖ζ(1/2+14i)‖ ≤ 1/16` implies the Krawczyk map condition. | `hmap_of_zeta_bound` (`Krawczyk.lean`) |
| T234 | Theorem | **Complex interval layer:** `ComplexInterval` with `contains`, `add`, `neg`, `sub` and containment lemmas. | `ComplexInterval` (`Interval.lean`) |
| T235 | Theorem | **Coarse interval multiplication:** `mulCoarse` with absolute-endpoint bounds. | `RatInterval.mulCoarse`, `mulCoarse_contains` (`Interval.lean`) |
| T236 | Theorem | **Complex interval multiplication:** `ComplexInterval.mul` with containment. | `ComplexInterval.mul`, `mul_contains` (`Interval.lean`) |
| T237 | Theorem | **Nonnegative square enclosure:** `sqNonneg` contains `x²`. | `RatInterval.sqNonneg`, `sqNonneg_contains` (`Interval.lean`) |
| T238 | Theorem | **Reciprocal avoiding zero:** `invAvoid` with containment of `x⁻¹`. | `RatInterval.invAvoid`, `invAvoid_contains` (`Interval.lean`) |
| T239 | Theorem | **Complex conjugation:** `ComplexInterval.conj` with containment. | `ComplexInterval.conj`, `conj_contains` (`Interval.lean`) |
| T240 | Theorem | **Coarse `|z|²` upper enclosure:** `normSqUpper` contains `Complex.normSq z`. | `ComplexInterval.normSqUpper`, `normSqUpper_contains` (`Interval.lean`) |
| T241 | Theorem | **Absolute lower bound:** `absLower ≤ |x|` on an interval avoiding zero. | `RatInterval.absLower`, `absLower_le_abs` (`Interval.lean`) |
| T242 | Theorem | **`|z|²` lower bound:** `normSqLower ≤ Complex.normSq z`. | `ComplexInterval.normSqLower`, `normSqLower_le` (`Interval.lean`) |
| T243 | Theorem | **Real-to-complex embedding:** `ofReal` contains `(x : ℂ)`. | `ComplexInterval.ofReal`, `ofReal_contains` (`Interval.lean`) |
| T244 | Theorem | **Complex inverse:** `ComplexInterval.inv` contains `z⁻¹`. | `ComplexInterval.inv`, `inv_contains` (`Interval.lean`) |
| T245 | Theorem | **`|cos x| ≤ 1`.** | `abs_cos_le_one` (`Interval.lean`) |
| T246 | Theorem | **`|sin x| ≤ 1`.** | `abs_sin_le_one` (`Interval.lean`) |
| T247 | Theorem | **`exp` monotonicity.** | `exp_le_exp` (`Interval.lean`) |
| T248 | Theorem | **`log` monotonicity.** | `log_le_log` (`Interval.lean`) |
| T249 | Theorem | **Tighter `Y` bound:** `‖Yk‖ ≤ 3/2`, and `hmap` reduced to `‖ζ(1/2+14i)‖ ≤ 1/8`. | `norm_Yk_le_three_halves`, `hmap_of_zeta_bound` (`Krawczyk.lean`) |
| T250 | Theorem | **`1/2+14i` eta box assembly:** `S14`, `s14`, and the conditional box membership for `Σ_{m<M} pairTerm`. | `S14`, `etaPartial_mem_box` (`ZetaBox14.lean`) |
| T251 | Theorem | **High-precision 14i parameters:** `params14` with `N=12`, `k=12`, `kI=128`, `n=16`, and `allOK (params14 100) S14`. | `params14`, `allOK_100` (`ZetaBox14.lean`) |
| T252 | Theorem | **`params14` fold value:** `sumValue (params14 M) = Σ pairTerm`. | `sumValue_params14` (`ZetaBox14.lean`) |
| T253 | Theorem | **`params14` box membership:** conditional eta partial-sum box at `1/2+14i`. | `etaPartial_mem_box14` (`ZetaBox14.lean`) |
| T254 | Theorem | **Concrete `M=100` box:** eta partial sum at `1/2+14i` lies in `sumBox (params14 100) S14`. | `etaPartial_100_mem14` (`ZetaBox14.lean`) |
| T255 | Theorem | **`M=1000` checker pass** at `1/2+14i`. | `allOK_1000` (`ZetaBox14.lean`) |
| T256 | Theorem | **`M=10000` checker pass** at `1/2+14i`. | `allOK_10000` (`ZetaBox14.lean`) |
| T257 | Theorem | **`M=100000` checker pass** at `1/2+14i`. | `allOK_100000` (`ZetaBox14.lean`) |
| T258 | Theorem | **Fast parameters:** `paramsFast` with `N=10,k=10,kI=256,n=12`, and `allOK (paramsFast 10000) S14`. | `paramsFast`, `allOK_fast_10000` (`ZetaBox14.lean`) |
| T259 | Theorem | **Million-term check:** `allOK (paramsFast 1000000) S14 = true` (standalone build, ≈639 s). | `allOK_fast_1000000` (`BigCheck.lean`) |
| T260 | Theorem | **`‖s14‖ ≤ 15`.** | `norm_s14_le_fifteen` (`ZetaBox14.lean`) |
| T261 | Theorem | **Tail bound at `1/2+14i`:** `‖Σ' pairTerm s14 (m+1000000)‖ ≤ 1/64`. | `tail_s14_1e6` (`ZetaBox14.lean`) |
| T262 | Theorem | **Box absolute-endpoint bound:** `|x| ≤ maxAbsIv I` for `x ∈ I`. | `abs_le_maxAbsIv` (`BoxNorm.lean`) |
| T263 | Theorem | **Box norm bound:** `‖z‖ ≤ R` for `z` in a box whose corner norm-square is ≤ `R²`. | `norm_le_of_mem_box` (`BoxNorm.lean`) |
| T264 | Theorem | **Grid floor:** `gridDown g q ≤ q`. | `gridDown_le` (`Interval.lean`) |
| T265 | Theorem | **Grid ceiling:** `q ≤ gridUp g q`. | `le_gridUp` (`Interval.lean`) |
| T266 | Theorem | **Snapped interval:** `snap g I` contains every point of `I`. | `snap`, `snap_contains` (`Interval.lean`) |
| T267 | Theorem | **Snapped addition:** `addSnap g I J` contains `x+y`. | `addSnap`, `addSnap_contains` (`Interval.lean`) |
| T268 | Theorem | **Snapped real box:** `snapIv` preserves `memR`. | `snapIv`, `snapIv_mem` (`FixedBox.lean`) |
| T269 | Theorem | **Snapped complex box:** `snapCx` preserves `Cx.mem`. | `snapCx`, `snapCx_mem` (`FixedBox.lean`) |
| T270 | Theorem | **Snapped fold:** `foldSnap` contains `sumValue` of the pair list. | `foldSnap`, `foldSnap_mem` (`FixedBox.lean`) |
| T271 | Theorem | **Integer grid floor:** `gridDownInt g q ≤ q`. | `gridDownInt_le` (`Interval.lean`) |
| T272 | Theorem | **Integer grid ceiling:** `q ≤ gridUpInt g q`. | `le_gridUpInt` (`Interval.lean`) |
| T273 | Theorem | **Integer snapped interval:** `snapInt` contains every point. | `snapInt`, `snapInt_contains` (`Interval.lean`) |
| T274 | Theorem | **Integer snapped real box:** `snapIvInt` preserves `memR`. | `snapIvInt`, `snapIvInt_mem` (`FixedBox.lean`) |
| T275 | Theorem | **Integer snapped complex box:** `snapCxInt` preserves `Cx.mem`. | `snapCxInt`, `snapCxInt_mem` (`FixedBox.lean`) |
| T276 | Theorem | **Integer snapped fold:** `foldSnapInt` contains `sumValue`. | `foldSnapInt`, `foldSnapInt_mem` (`FixedBox.lean`) |
| T277 | Theorem | **Block parameters:** `sumValue (paramsBlock off M) = Σ_{i<M} pairTerm (off+i)`. | `paramsBlock`, `sumValue_paramsBlock` (`ZetaBox14.lean`) |
| T278 | Theorem | **Block split:** `paramsFast (off+M) = paramsFast off ++ paramsBlock off M`. | `paramsFast_eq_append` (`ZetaBox14.lean`) |
| T279 | Theorem | **Block checker:** `allOK (paramsFast N)` implies `allOK (paramsBlock off M)` when `off+M ≤ N`. | `allOK_paramsBlock` (`ZetaBox14.lean`) |
| T280 | Theorem | **Block box membership:** the block partial sum lies in `sumBox (paramsBlock off M)`. | `blockBox_mem` (`ZetaBox14.lean`) |
| T281 | Theorem | **Snapped block fold:** `foldBlocks` with membership from paired values. | `foldBlocks`, `foldBlocks_mem` (`FixedBox.lean`) |
| T282 | Theorem | **Block sum identity:** `Σ_{j<B}Σ_{i<M} pairTerm s (j*M+i) = Σ_{m<B*M} pairTerm s m`. | `sum_blocks_eq` (`ZetaBox14.lean`) |
| T283 | Theorem | **List-range sum bridge:** `(List.map f (range B)).sum = Σ_{j<B} f j`. | `list_sum_range` (`FixedBox.lean`) |
| T284 | Theorem | **Block values as a Finset sum.** | `blockVals_sum_finset` (`FixedBox.lean`) |
| T285 | Theorem | **Block values total:** `(blockVals B M s).sum = Σ_{m<B*M} pairTerm s m`. | `blockVals_sum` (`FixedBox.lean`) |
| T286 | Theorem | **Pair fold:** `foldPairs` contains the sum of paired values. | `foldPairs`, `foldPairs_mem` (`FixedBox.lean`) |
| T287 | Theorem | **Block pairs membership:** every block value lies in its block box. | `blockPairs`, `blockPairs_mem` (`FixedBox.lean`) |
| T288 | Theorem | **Block fold membership:** the million-term block sum lies in `foldPairs`. | `blockFold_mem` (`FixedBox.lean`) |
| T289 | Theorem | **Million-term block instance:** `B=M=1000` at `1/2+14i`. | `blockFold_1e6` (`BlockCert.lean`) |
| T290 | Theorem | **One-fold difference identity:** `altSum (delta a) N = 2 altSum a N - a 0 + (-1)^N a N`. | `altSum_delta` (`EtaEM.lean`) |
| T291 | Theorem | **One-fold Euler summation by parts.** | `altSum_eq` (`EtaEM.lean`) |
| T292 | Theorem | **Iterated Euler transformation with boundary terms.** | `altSum_euler` (`EtaEM.lean`) |
| T293 | Theorem | **Bernoulli tower vanishes for `Re s > 0`:** `emGShift s N j n → 0` as `n → ∞` whenever `0 < Re s`. | `tendsto_emGShift_zero_general_of_re_pos` (`EMCritical.lean`) |
| T294 | Theorem | **First Bernoulli tower vanishes for `Re s > 0`.** | `tendsto_emGShift_one_zero_of_re_pos` (`EMCritical.lean`) |
| T295 | Theorem | **Finite `B₁`/`B₂` bridge:** `Σ_{k<n} ∫ (x-k-½)·emG₁ = ½·B₂(0)·(emG₁ n - emG₁ 0) - ½ Σ_{k<n} ∫ B₂(x-k)·emG₂`, for every `s` and `n`. | `sum_correction_eq_B2` (`EMCritical.lean`) |
| T296 | Theorem | **`B₂` series identity at `Re s > 0`:** the first-order correction series equals the `B₂` boundary minus half the `B₂` series (previously only for `Re s > 1`). | `tsum_correction_first_eq_of_re_pos` (`EMCritical.lean`) |
| T297 | Theorem | **`K = 1` Euler–Maclaurin at `Re s > 0`:** `zetaEM N s = zetaEMGen 1 N s - ½·Σ' B₂ series`. | `zetaEM_eq_gen_one_of_re_pos` (`EMCritical.lean`) |
| T298 | Theorem | **`K = 1` remainder at `Re s > 0`:** `zetaEMRemainder 1 N s = -½·Σ' B₂ series`. | `zetaEMRemainder_one_of_re_pos` (`EMCritical.lean`) |
| T299 | Theorem | **`B₂` constant:** `2·Re ζ(2)/(2π)² = 1/12`. | `emConst_two` (`EMCritical.lean`) |
| T300 | Theorem | **`B₂` remainder bound on the critical line:** `‖zetaEMRemainder 1 N s‖ ≤ (1/12)·‖(s)₂‖·((N+1)^(-σ-2) + (N+1)^(1-σ-2)/(σ+1))` for `0 < Re s`. | `norm_zetaEMRemainder_one_le_of_re_pos` (`EMCritical.lean`) |
| T301 | Theorem | **`K = 1` remainder, factorial form, at `Re s > 0`.** | `zetaEMRemainder_one_factorial_of_re_pos` (`EMCritical.lean`) |
| T302 | Theorem | **`B_{2K} → B_{2K+2}` telescoping series identity at `Re s > 0`.** | `tsum_B_even_succ_of_re_pos` (`EMCritical.lean`) |
| T303 | Theorem | **Even Bernoulli series recurrence at `Re s > 0`.** | `S_even_succ_of_re_pos` (`EMCritical.lean`) |
| T304 | Theorem | **`zetaEMRemainder K N s = -(1/(2K)!)·S_even K N s` at `Re s > 0`** (previously only `Re s > 1`). | `zetaEMRemainder_eq_factorial_of_re_pos` (`EMCritical.lean`) |
| T305 | Theorem | **General-`K` Euler–Maclaurin remainder bound on the critical line:** `‖zetaEMRemainder K N s‖ ≤ (2·Re ζ(2K)/(2π)^{2K})·‖(s)_{2K}‖·((N+1)^(-σ-2K) + (N+1)^(1-σ-2K)/(σ+2K-1))` for `0 < Re s`. | `norm_zetaEMRemainder_le_of_re_pos` (`EMCritical.lean`) |
| T306 | Theorem | **Point box:** `ptBox q r` contains every `z` with `re = q`, `im = r`; used for rational scalars. | `ptBox, mem_ptBox` (`EMBox14.lean`) |
| T307 | Theorem | **Exact pole factor at a point box:** `1/(s14-1) = (-2-56i)/785`, since `|s14-1|² = 785/4`. No interval division is needed. | `inv_s14_sub_one` (`EMBox14.lean`) |
| T308 | Theorem | **Pole box membership:** `s14-1` lies in `S2box`. | `mem_S2box` (`EMBox14.lean`) |
| T309 | Theorem | **Base-sum fold:** `csPow M` contains `Σ_{n<M} (n+1)^{-s14}`. | `csPow, csPow_mem` (`EMBox14.lean`) |
| T310 | Theorem | **Base-sum checker:** `sumOK M = true` gives all `CpowConditions`. | `sumOK, sumOK_conditions` (`EMBox14.lean`) |
| T311 | Theorem | **Corner norm of the box:** `‖corner(Bzeta)‖ ≤ 11/100`, by `native_decide`. | `corner_Bzeta` (`EMBox14.lean`) |
| T312 | Theorem | **Pochhammer norm bounds:** `‖(s)₃‖ ≤ 4320` and `‖(s)₄‖ ≤ 65000` at `s14`, by triangle inequality. | `norm_descPochhammer_three_le, norm_descPochhammer_four_le` (`EMBox14.lean`) |
| T313 | Theorem | **`K=2` remainder at `1/2+14i`:** `‖zetaEMRemainder 2 20 s14‖ ≤ 1/250`. | `norm_remainder_two_le` (`EMBox14.lean`) |
| T314 | Theorem | **`B₄` boundary term:** `‖-(emCoef 2)·emGShift s14 20 3 0‖ ≤ 1/1000`. | `norm_b4term_le` (`EMBox14.lean`) |
| T315 | Theorem | **Expansion of `zetaEMGen 1 20 s14`** into its four explicit pieces. | `zetaEMGen_one_expand` (`EMBox14.lean`) |
| T316 | Theorem | **`cpow` shifts:** `21^{1-s} = 21^{-s}·21` and `21^{-(s+1)} = 21^{-s}·21⁻¹` via `Complex.cpow_add`. | `cpow_21_one_sub, cpow_21_neg_succ` (`EMBox14.lean`) |
| T317 | Theorem | **Rational scalar:** `21/(s-1) + 1/2 + s/252 = 177437/395640 - (20383/14130)i` at `s14`. | `scalar_eq` (`EMBox14.lean`) |
| T318 | Theorem | **Three-term collapse:** the three `(N+1)`-terms equal `21^{-s14}` times the rational scalar. | `three_terms_eq` (`EMBox14.lean`) |
| T319 | Theorem | **Box membership:** `zetaEMGen 1 20 s14` lies in the folded box `Bzeta`. | `mem_Bzeta` (`EMBox14.lean`) |
| T320 | Theorem | **Step 3:** `‖ζ(1/2+14i)‖ ≤ 1/8`. | `zeta_norm_le_eighth` (`EMBox14.lean`) |
| T321 | Theorem | **Krawczyk map condition:** `‖Yk·ζ(1/2+14i)‖ + (1/4)² ≤ 1/4`; `hmap` is discharged. | `hmap_zeta` (`EMBox14.lean`) |
| T322 | Theorem | **Sharp step-3 bound:** `‖ζ(1/2+14i)‖ ≤ 23/200 = 0.115` (the triangle chain, kept sharp for the `1/5` radius). | `zeta_norm_le_115` (`EMBox14.lean`) |
| T323 | Theorem | **Sharpened `Yk` bound:** `‖Yk‖ ≤ 1.29` (the 10-digit rational is accurate to `3·10⁻⁵`). | `norm_Yk_le` (`EMBox14.lean`) |
| T324 | Theorem | **Map condition at radius `1/5`:** `‖Yk·ζ(s0)‖ + (1/4)·(1/5) ≤ 1/5`; a zero in the `1/5`-ball is stronger than in the `1/4`-ball. | `hmap_zeta_fifth` (`EMBox14.lean`) |
| T325 | Theorem | **The `1/5`-ball avoids `1`.** | `fifth_ball_ne_one` (`EMBox14.lean`) |
| T326 | Theorem | **Krawczyk target at radius `1/5`:** reduces to `hC` alone; `hmap` and the `z ≠ 1` condition are discharged. | `zeta_zero_fifth_ball` (`EMBox14.lean`) |
| T327 | Theorem | **`Yk ≠ 0`** (`|Re Yk| = 1.24`). | `Yk_ne_zero` (`EMBox14.lean`) |
| T328 | Theorem | **`hC` from two numerical inputs:** a `10⁻³` point enclosure of `ζ′(s14)` and a `47/250`-Lipschitz bound on `ζ′` give `hC`; `10⁻³ + 1.29·(47/250) = 0.24352 ≤ 1/4`. | `hC_of_bounds` (`EMBox14.lean`) |
| T329 | Theorem | **Final zero theorem, conditional on two explicit numerical inputs:** `∃ z ∈ ball(s14, 1/5), ζ z = 0`. All other Krawczyk hypotheses are discharged. | `zeta_zero_14_of_bounds` (`EMBox14.lean`) |
| T330 | Theorem | **`d/dz b^z = b^z·log b`** for `b ≠ 0`, built from `Complex.cpow_def` (Mathlib has no such lemma). | `hasDerivAt_cpow_exp` (`EMDeriv.lean`) |
| T331 | Theorem | **`d/dz b^(-z) = -(b^(-z)·log b)`** for `b ≠ 0`; the derivative of each `n^{-s}` term. | `hasDerivAt_cpow_neg` (`EMDeriv.lean`) |
| T332 | Theorem | **Base sum differentiated:** `d/ds Σ_{n<N} (n+1)^{-s} = -Σ (n+1)^{-s} log (n+1)`. | `hasDerivAt_sum_cpow` (`EMDeriv.lean`) |
| T333 | Theorem | **`d/dz 21^(1-z) = -log21·21^(1-s)`.** | `hasDerivAt_pow21_one_sub` (`EMDeriv.lean`) |
| T334 | Theorem | **`d/dz 21^(-z) = -log21·21^(-s)`.** | `hasDerivAt_pow21_neg` (`EMDeriv.lean`) |
| T335 | Theorem | **Pole term differentiated:** `d/dz [21^(1-z)/(z-1)] = 21^(1-s)·(-log21/(s-1) - 1/(s-1)²)`. | `hasDerivAt_pole` (`EMDeriv.lean`) |
| T336 | Theorem | **`deriv` bridge:** `deriv ζ s14 = deriv (zetaEM 20) s14`, from local equality of `ζ` and `zetaEM 20`. | `deriv_zeta_eq_deriv_zetaEM` (`EMDeriv.lean`) |
| T337 | Theorem | **Shifted power derivative:** `d/dz b^(-(z+c)) = -log b · b^(-(z+c))`, needed for the `B₂` term `s·21^(-(s+1))`. | `hasDerivAt_cpow_neg_shift` (`EMDeriv.lean`) |
| T338 | Theorem | **Explicit Euler–Maclaurin expression as a function of `s`:** `zetaEMGen 1 20 s = Σ(n+1)^(-s) + 21^(1-s)/(s-1) + 21^(-s)/2 + (1/12)s·21^(-(s+1))`. | `zetaEMGen_one_fun` (`EMDeriv.lean`) |
| T339 | Theorem | **`zetaEMGen 1 20` differentiated:** `d/ds = -Σ(n+1)^(-s)log(n+1) + 21^(1-s)(-log21/(s-1) - 1/(s-1)²) - log21·21^(-s)/2 + (1/12)(21^(-(s+1)) - s·log21·21^(-(s+1)))`. | `hasDerivAt_zetaEMGen_one` (`EMDeriv.lean`) |
| T340 | Theorem | **`log` box membership:** `⟨logIvRat N b, 0⟩` contains `↑(Real.log b)`. | `mem_logBox` (`EMDeriv.lean`) |
| T341 | Theorem | **Derivative-sum fold:** `dsPow M` contains `Σ_{n<M} (n+1)^(-s14)·log(n+1)`; the `ζ′` enclosure (defined as `Vbox`, corner `≤ 4/5`) is built on it. | `dsPow_mem` (`EMDeriv.lean`) |
| T342 | Theorem | **Fold `21^(1-s)`:** `21^(1-s) = 21·21^(-s)`, via `Complex.cpow_add`. | `pow21_one_sub` (`EMDeriv.lean`) |
| T343 | Theorem | **Fold `21^(-(s+1))`:** `21^(-(s+1)) = 21^(-s)/21`. | `pow21_neg_succ` (`EMDeriv.lean`) |
| T344 | Theorem | **`s14 ≠ 1`.** | `s14_ne_one` (`EMDeriv.lean`) |
| T345 | Theorem | **`A1` identity:** `21·(-1/(s14-1)) - 1/2 - s14/252 = A1c = -177437/395640 + (20383/14130)i`. | `A1_eq` (`EMDeriv.lean`) |
| T346 | Theorem | **`A0` identity:** `21·(-1/(s14-1)²) + 1/252 = A0c = 17190769/155288700 - (4704/616225)i`. | `A0_eq` (`EMDeriv.lean`) |
| T347 | Theorem | **`ζ′` scalar factored:** the `21`-part of T339 at `s14` is `log21·A1c + A0c`. | `scalar_eq_deriv` (`EMDeriv.lean`) |
| T348 | Theorem | **`log` bridge:** `↑(Real.log b) = Complex.log ↑b`, linking `dsPow_mem`'s `Real.log` to T339's `Complex.log`. | `ofReal_log_natCast` (`EMDeriv.lean`) |
| C1 | Computation | Regrouping agrees exactly at `s = 2, 3, 3/2, 2+i/3` to `< 10^{-30}`. | `test_finite_regrouping_is_exact` |
| C2 | Computation | The pair estimate holds on a grid (`σ = 1/2, 1, 2`; `m = 0, 1, 10, 100`) to `< 10^{-25}`. | `test_pair_estimate_holds` |
| C3 | Computation | The tail bound is positive and decreases with `M`. | `test_tail_bound_positive_and_decreasing` |
| C4 | Computation | The point enclosure at `s = 1/2 + 5i` (`M = 2000`) contains `ζ(s)` and excludes zero. | `test_point_enclosure_excludes_zero` |
| C5 | Computation | The enclosure at `s = 2` (`M = 3000`) contains `π²/6`. | `test_enclosure_at_two_contains_pi_squared_over_six` |
| C6 | Computation | Edge cases: factor zero at `s = 1`, zero tail for `|s| = 0`, bad `M`, `σ ≤ 0`, `Box` distance/width. | `test_factor_contains_zero_at_one`, `test_tail_bound_edge_cases`, `test_invalid_inputs`, `test_box_distance_and_width` |

## Source claims and open items

| Claim | Status | Note |
| C7 | Computation | **Zero-isolation feasibility probe:** floating-point winding number `1` around `Re ∈ [0.4,0.6]`, `Im ∈ [14.0,14.3]`, min boundary modulus `> 0.1`. Not a certificate. | `python/zero_probe.py` |
| C8 | Computation | **First-zero ordinate:** 50-digit `mpmath.zeta`/`findroot` value `14.134725141734693790457251983562470270784257115699`. Numerical datum, not a certificate. | `python/zero_probe.py` |
| C9 | Computation | **Euler–Maclaurin interval zeta:** rigorous box for `ζ` on `Re > 0` with `N=K=20`; width `~5·10⁻³⁰` at `1/2+14i` and narrow enclosures at heights `14,20,30`, tested against `mpmath.zeta`. | `python/accelerated.py` |
| C10 | Computation | **Cauchy derivative bound:** `|ζ′| ≤ M/pad` on the zero rectangle; numerically `≈34` for `pad=0.05`. Too coarse for Krawczyk with the current boxes. | `python/accelerated.py` |
| C11 | Computation | **Numerical Krawczyk zero isolation:** on `Re ∈ [0.499,0.501]`, `Im ∈ [14.1345,14.1349]`, one Krawczyk step satisfies `K(X) ⊂ int X`, robust for `(N,K) = (20,20),(25,25),(30,20),(20,25)`. The Krawczyk theorem itself is not yet formalised. | `python/accelerated.py` |
|---|---|---|
| Identity (E), `(1-2^{1-s})ζ(s)=η(s)`, for `Re s > 0` | **Theorem here** (T5–T8) | Lean-proved for all `0 < Re s`, `s ≠ 1`; the point `s = 1` is excluded because `ζ` has a pole and the product has the removable value `log 2`, not `0`. |
| Pair tail comparison `Σ_{m≥M} ≤ (2M+1)^{-p} + (2M+1)^{1-p}/(2(p-1))` | Standard; used in Python | Not formalised in Lean. |
| P3: a Lean theorem with a critical-strip enclosure premise | **Open** | Requires (E) in Lean and the enclosure certificate below. |
| Zero-free **segment** of the critical line | **Open here** | The point certificate works; a segment needs a subdivision certificate and a Lean replay. Known numerically (first zero at `t ≈ 14.1347`), but not proved in this dossier. |

### Open tasks, in dependency order

1. ~~Lean continuation of (E).~~ **Done** (T5–T8).
2. ~~Lean tail bound.~~ **Done** (T10–T11).
3. **Lean enclosure certificate.** Emit a rational `Cx` box for `etaGrouped` on
   a rectangle (partial sums plus tail) and discharge `etaGrouped s ≠ 0`. This
   is the remaining numerical premise for P3. Reuse the width checker from
   [`partial-sum-plus-tail/lean/Width.lean`](../partial-sum-plus-tail/lean/Width.lean).
4. **A real segment.** Subdivide `t ∈ [0,10]` into rational intervals, certify
   each box, and obtain a finite-window zero-free theorem on the critical line.
5. **P4 link.** The same certificate is the expensive input to the truncated
   explicit formula (P4).

## Python layer

[`python/programme.py`](python/programme.py) is importable without side effects.

```bash
cd the-final-letter/topics/finite-window-zeros
python3 -m pytest -q tests
```

Current result: **9 passed**. The interval computations use `mpmath.iv`
(directed rounding); tolerances in the tests are stated explicitly. The point
certificate is a computation, not a kernel-checked theorem; that is the gap to
P3.

## Lean layer

```bash
cd the-final-letter/topics/finite-window-zeros
./lean/check.sh
```

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib and proves T1–T4.
[`lean/README.md`](lean/README.md) states what is not formalised. The file has no
`sorry`, `axiom` or `admit`.

## Links

[Scraps inventory](../../scraps.html) · [Topics](../README.md) ·
[Status §7](../../status.html) · [Objective III dossier](../partial-sum-plus-tail/README.md) ·
[Proof ledger C](../../categories/05-proofs/proofs.md#c-the-certified-evaluation-layer)
