# Lean formal core — prime-spectrum tensor

## Build

```bash
the-final-letter/topics/prime-spectrum-tensor/lean/check.sh          # everything (~4 h)
the-final-letter/topics/prime-spectrum-tensor/lean/check.sh --quick  # hand-written core (~3.5 min)
```

`--quick` skips the 45 generated `DensityC*_*.lean` chunks (and
`DensityCertificates.lean` / `DensityCertificates5.lean` if their chunk
`.olean`s are absent); it is a no-op when
explicit files are given, and it is also accepted by the shared
`topics/tools/check-lean.sh`, so `check-all-lean.sh --quick` and
`verify-all.sh --quick` work.

The density certificates are **chunked** (45 files, nine per separation `c`,
150 panels each, since one
file with all 1305 panels needs ~25 GB of memory).  Rebuild them, resumably,
with

```bash
cd gen && python3 emit_all.py --size 150 && ./build_chunks.sh 0 1 2 3
cd gen && python3 emit_all.py --size 150 --cc 4/5 --first-index 4 --wden 200 \
  && ./build_chunks.sh 4
```

The script delegates to the shared checker and uses the local Mathlib
installation at `~/lean/mathlib4` (Lean `v4.35.0-rc2`).

It also sets

```bash
export LEAN_EXTRA_PATH="$HERE/../../intersection-form-zeta/lean"
```

so that [`DensityEnclosure.lean`](DensityEnclosure.lean) can import the shared
analysis library (`PanelEnclosure` and its import closure: `DigammaEnclosure`,
`Enclosure`, `PolygammaSeries`, `Archimedean`, `GammaProduct`, `SimpsonPanel`,
`EulerMaclaurin`).  The closure contains **no `Topic` module**, so it does not
collide with this topic's own `Topic.lean`; and its `.olean` files are built by
`../../intersection-form-zeta/lean/check.sh`.  This is the "shared module root"
option of `HANDOFF-O4.md` §8, realised through `LEAN_EXTRA_PATH` rather than by
copying 5,800 lines.

### Axiom audit

There is no `sorry`, `axiom` or `admit` in this topic (the single occurrence of
the word is in a docstring).  `#print axioms` on the chain gives only Lean's
three standard axioms:

```
gaussianGram4_posDef_of_density_enclosure_loose : [propext, Classical.choice, Quot.sound]
PrimeSpectrumTensor.gaussianGram4_posDef       : [propext, Classical.choice, Quot.sound]
gaussianGram5_posDef_of_density_enclosure_loose : [propext, Classical.choice, Quot.sound]
PrimeSpectrumTensor.gaussianGram5_posDef       : [propext, Classical.choice, Quot.sound]
PrimeSpectrumTensor.D4.density_mem_c4          : [propext, Classical.choice, Quot.sound]
PrimeSpectrumTensor.D0.density_mem_c0          : [propext, Classical.choice, Quot.sound]
PrimeSpectrumTensor.D1.density_mem_c1          : [propext, Classical.choice, Quot.sound]
PrimeSpectrumTensor.D2.density_mem_c2          : [propext, Classical.choice, Quot.sound]
PrimeSpectrumTensor.D3.density_mem_c3          : [propext, Classical.choice, Quot.sound]
gaussianGram4_posDef_of_entry_bound               : [propext, Classical.choice, Quot.sound]
gramCentre4_sub_posDef                            : [propext, Classical.choice, Quot.sound]
primeTerm_mem_small                               : [propext, Classical.choice, Quot.sound]
primeTerm_mem_four_fifths                         : [propext, Classical.choice, Quot.sound]
poleTerm_mem_c1                                   : [propext, Classical.choice, Quot.sound]
density_approx_error                              : [propext, Classical.choice, Quot.sound]
panel_certificate                                 : [propext, Classical.choice, Quot.sound]
density_tail_le                                   : [propext, Classical.choice, Quot.sound]
abs_Omega_le                                      : [propext, Classical.choice, Quot.sound]
midpoint_rule_bound                               : [propext, Classical.choice, Quot.sound]
cos_bound_small                                   : [propext, Classical.choice, Quot.sound]
deriv_Omega_abs_le_ten                            : [propext, Classical.choice, Quot.sound]
```

The committed [`BUILD.log`](BUILD.log) records the last successful run:

```
[check] OK   Assembly.lean (19s)
[check] OK   CosBound.lean (5s)
[check] OK   DensityAssembly.lean (4s)
[check] OK   DensityC0_0.lean (211s)
[check] OK   DensityC0_1.lean (226s)
… (75 files in all; `DensityC{0,1,2,3,4}_{0..8}.lean` are the
    45 chunk files, ~5–10 min each)
[check] OK   SeriesRoute.lean (5s)
[check] OK   SumApprox.lean (4s)
[check] OK   Topic.lean (5s)
[check] OK   Transfer.lean (6s)
[check] OK   WeightBound.lean (6s)
[check] OK   WeightDecay.lean (4s)
```

## What is proved

[`Topic.lean`](Topic.lean) defines the prime-current weight, a finite
truncation of `Π`, one term of Riemann's Jacobi density `Φ`, the Fourier
atom `exp(iγx)`, a finite atomic kernel, the mode sum and the finite Gram
form. It proves twelve statements, all with no `sorry`, `axiom` or
`admit`:

| Name | Statement |
|---|---|
| `primeWeight_nonneg` | `0 ≤ Λ(n)/√n` for every `n`. |
| `primeCurrent_nonneg` | A finite truncation of `Π` is non-negative on a pointwise non-negative test function. |
| `jacobiTerm_pos` | Each term of the Jacobi density is positive for `n ≥ 1` and `u ≥ 0`. |
| `atom_neg` | `atom w γ (-x) = conj (atom w γ x)`. |
| `atomForm_eq` | The one-frequency Gram form equals `w · Z · conj Z`, where `Z = Σ_j a_j e^{iγu_j}`. |
| `gramForm_eq` | The finite Gram form equals `Σ_k w_k · Z_k · conj Z_k`. |
| `gramForm_re_nonneg` | If every atomic weight is non-negative, the real part of the finite Gram form is non-negative. |
| `G3_posSemidef` | The rational Cholesky certificate `G3 = L3ᴴ L3` is positive semidefinite. |
| `GDH_not_posSemidef` | The sign-flipped DH-shaped matrix is not positive semidefinite; `(1,-1)` gives form value `-2`. |
| `posSemidef_of_cholesky` | Any rational `Lᴴ L` is positive semidefinite (T10). |
| `not_posSemidef_of_neg` | A rational vector with negative form value refutes positive semidefiniteness (T11). |
| `L4Shadow_posSemidef` | The rounded 4×4 Cholesky shadow is positive semidefinite; this certifies the shadow, not the exact Gaussian Gram matrix. |

The last five include the T8/T10/T11 finite algebra and the rational shadow
certificate.

## [`Transfer.lean`](Transfer.lean) — W1 of O4

The first closed work item of
[`../../angular-partition-method/HANDOFF-O4.md`](../../angular-partition-method/HANDOFF-O4.md).
All scalars are rational literals; there is no analysis in the file.

| Name | Statement |
|---|---|
| `posDef_of_entry_bound` | Entrywise transfer with the **correct norm**: if `C − t·I` is positive definite, `G` is symmetric, `|G i j − C i j| ≤ ε`, and `ε · dim < t`, then `G.PosDef`. This is the correction to the centre/error step of `WEIL-GRAM.md` §3.3–3.6, where an entrywise margin was used as if it were a Loewner margin. |
| `gramCentre4_factor` | `gramCentre4 − (227/10000)·I = L4 · D4 · L4ᵀ`, checked entry by entry over the rationals. |
| `gramCentre4_sub_posDef` | `(gramCentre4 − (227/10000)·I).PosDef`, by exact rational `L D Lᵀ` arithmetic. |
| `gaussianGram4_posDef_of_entry_bound` | The corollary at dimension four: an entrywise enclosure with `ε · 4 < 0.0227` implies `G.PosDef`. |

`gramCentre4` is the numerical Gaussian Gram matrix of `WEIL-GRAM.md`
(σ = 0.05, centres −0.3, −0.1, 0.1, 0.3) rounded to eight decimals. The theorem
certifies this **rational centre**, not the transcendental matrix.

## [`GaussianGram.lean`](GaussianGram.lean) — W4 assembly

Defines the exact objects (`omega`, `poleTerm`, `densityTerm`, `primeTerm`,
`gaussianGram4`) and proves only the structural part:

| Name | Statement |
|---|---|
| `gaussianGram4_symm` | The symmetrised Gram matrix is symmetric. |
| `gaussianGram4_posDef_of_enclosure` | **If** every entry is within `ε` of `gramCentre4` with `4ε < 0.0227`, **then** `(gaussianGram4 σ).PosDef`. |

The hypothesis of the last theorem is exactly the output required from W2
(the `Ω` enclosure) and W3 (the quadrature); it is **not** proved. The precise
route and the remaining work are in [`../OMEGA-ROUTE.md`](../OMEGA-ROUTE.md).

## [`PoleEnclosure.lean`](PoleEnclosure.lean) — W3, first leaf

The pole term of every Gram entry at `σ = 1/20`, enclosed in rational intervals
of width `2·10⁻⁶`. Proofs use only `Real.pi_gt_d4`/`pi_lt_d4`,
`Real.exp_bound`, and exact rational arithmetic.

| Name | Statement |
|---|---|
| `two_cosh_real` | `2 cosh x = exp x + exp(−x)` on `ℝ` (from `Complex.two_cosh`). |
| `poleTerm_eq_inv20` | `poleTerm c (1/20) = (π/100)·exp(1/1600)·cosh(c/2)`. |
| `pi_div_hundred_mem`, `exp_inv1600_mem`, `cosh_01_mem`, `cosh_02_mem`, `cosh_03_mem` | the scalar interval lemmas. |
| `poleTerm_between` | interval multiplication: an enclosure of `cosh(c/2)` gives one of `poleTerm c (1/20)`. |
| `poleTerm_mem_c0 … poleTerm_mem_c3` | `poleTerm c (1/20) ∈ [lo, hi]` for `|c| = 0, 1/5, 2/5, 3/5`. |
| `poleTerm_neg` | the pole term is even in `c`. |

## [`PrimeEnclosure.lean`](PrimeEnclosure.lean) — W3, the prime term

The prime term at `σ = 1/20`, enclosed in rational intervals. The summand is
dominated by `(√π/20)·n⁻¹³` for `n ≥ 3`, the tail is below `2.51·10⁻⁷`, and the
`n = 2` term is evaluated with `log 2`, `√2`, `√π` and `exp` bounds.

| Name | Statement |
|---|---|
| `gaussianBump_inv20`, `primeSummand`, `primeTerm_eq_inv20` | the bump, the summand, the definition at `σ = 1/20`. |
| `exp_decay_le` | `exp(−100(x−c)²) ≤ exp(−14x)` for `x ≥ 1`, `c ≤ 3/5`. |
| `primeSummand_le` | `primeSummand c n ≤ (√π/20)·n⁻¹³` for `n ≥ 3`. |
| `sum_tail_le`, `sum_tail_le_rat` | `Σ_{n≥3} primeSummand c n ≤ (√π/20)·3⁻¹¹/2 ≤ 2.51·10⁻⁷`. |
| `prime_sum_split` | `Σ_n primeSummand c n = primeSummand c 2 + Σ_n primeSummand c (n+3)`. |
| `primeTerm_mem_small` | `c ≤ 2/5` ⟹ `−2.2·10⁻⁵ ≤ primeTerm c (1/20) ≤ 0`. |
| `primeTerm_mem_three_fifths` | `−0.036490 ≤ primeTerm (3/5) (1/20) ≤ −0.03646`. |

The density term is enclosed by the generated certificates
[`DensityC0_0.lean`](DensityC0_0.lean) … [`DensityC3_8.lean`](DensityC3_8.lean); see
[`DensityCertificates.lean`](DensityCertificates.lean) below and R2 of
[`../OMEGA-ROUTE.md`](../OMEGA-ROUTE.md) §4.

## [`Assembly.lean`](Assembly.lean) — R3, the assembly

The three terms combined. `gaussianGram4_apply` splits each entry as
`pole + density + (prime c + prime −c)/2`; `densityTerm_neg` records the
evenness of the density term.

| Name | Statement |
|---|---|
| `gaussianGram4_apply` | one entry as `poleTerm c + densityTerm c + (primeTerm c + primeTerm (−c))/2`. |
| `gaussianGram4_posDef_of_density_enclosure` | **Given the density term in four explicit rational intervals, `(gaussianGram4 (1/20)).PosDef`.** |

The four intervals are `±10⁻³` bands around the numerically computed density
values:

| `c` | interval for `densityTerm c (1/20)` |
|---|---|
| 0 | `[0.0107, 0.0127]` |
| 1/5 | `[−0.0491, −0.0471]` |
| 2/5 | `[−0.0251, −0.0231]` |
| 3/5 | `[−0.0179, −0.0159]` |

These are loose by design: the transfer tolerates an entry error of `0.005675`,
and the pole and prime enclosures are tighter than `2.2·10⁻⁵`. So **O4 is now
reduced to those four interval memberships** — one concrete numerical statement
about one explicit integral, and nothing else.

## [`SeriesRoute.lean`](SeriesRoute.lean) — the truncation bound of the series route

The elementary half of R2's series route (see
[`../OMEGA-ROUTE.md`](../OMEGA-ROUTE.md) §4). If
`Ω(t) = ψ(1/4) − log π + Σ_k u_k(t)` with
`u_k(t) = 1/(k+1/4) − (k+1/4)/((k+1/4)² + t²/4)`, then truncating at `k = N`
costs at most

| Name | Statement |
|---|---|
| `omegaTerm` | the `k`-th series term `u_k(t)`. |
| `omegaTerm_nonneg` | `0 ≤ u_k(t)`. |
| `omegaTerm_le` | `u_k(t) ≤ t²/(4 (k+1/4)³)`. |
| `inv_cube_le` | `1/a³ ≤ 1/a² − 1/(a+1)²` for `a ≥ 2`. |
| `sum_telescope` | the finite telescoping sum. |
| `sum_omegaTerm_tail_le` | **`Σ_{k≥N} u_k(t) ≤ (t²/4)/(N+1/4)²` for `N ≥ 2`.** |

The `t²` factor is what makes the truncation usable: after the Gaussian weight
the induced entry error is `√π/(8σN²) ≈ 1.1/N²`, i.e. `1.1·10⁻⁴` at `N = 100`.

The *identity* `Ω(t) = ψ(1/4) − log π + Σ_k u_k(t)` is **not** proved: it is
the Euler-limit formula for `ψ`, R2's analytic half.

## [`DensityPanel.lean`](DensityPanel.lean) — the `t`-dependent derivative bound

The panel budget of R2 needs `|Ω′|` to decay in `t`; the library's global
`psiSeriesBound 1 ≈ 8.6` is far too coarse for panels at large `t`.

| Name | Statement |
|---|---|
| `deriv_Omega_abs_le_tsum` | `|Ω′(t)| ≤ ½ Σ_j ((j+1/4)² + t²/4)⁻¹` (from the polygamma series and the chain rule). |
| `sum_range_head_le` | the `K` terms below `K` cost `K/a²`. |
| `tail_step`, `sum_range_tail_le` | the telescoping tail `Σ_{j<m} 1/(j+K)² ≤ 1/(K−1)`. |
| `tsum_shifted_inv_le` | **`Σ_j ((j+1/4)² + a²)⁻¹ ≤ 6/a` for `a ≥ 2`** (split at `⌈a⌉+1`, no integrals, no `π`). |
| **`deriv_Omega_abs_le`** | **`|Ω′(t)| ≤ 6/t` for `t ≥ 4`.** |

## [`LipSmall.lean`](LipSmall.lean) — the global Lipschitz bound

`deriv_Omega_abs_le` covers only `t ≥ 4`; the panels below that need a constant.

| Name | Statement |
|---|---|
| `sum_telescope_inv` | `Σ_{i<m} (1/(i+1) − 1/(i+2)) = 1 − 1/(m+1)`. |
| **`tsum_inv_shift_add_sq_le`** | **`Σ_j ((j+1/4)² + a²)⁻¹ ≤ 18`** (telescoping comparison: `j=0` gives `16`, `j ≥ 1` gives `≤ 2/(j(j+1))` whose total is `2`). |
| **`deriv_Omega_abs_le_ten`** | **`|Ω′(t)| ≤ 10` for *all* `t`.** |

This is the `lip` input of the panel estimate: with it, the intra-panel variation
of `Ω` costs `(b−a)²σ²·lip(a)/4 ≈ 9·10⁻⁴` over `[1,40]` at panel width `0.1`.

## [`MidpointRule.lean`](MidpointRule.lean) — a quadrature rule

Mathlib contains no quadrature rule at all, so R2's panel estimate needs one.
This file proves the **midpoint rule with a second-derivative remainder**:

| Name | Statement |
|---|---|
| **`midpoint_rule_bound`** | `\|(∫ x in a..b, f x) − (b−a)·f((a+b)/2)\| ≤ B·(b−a)³/4` whenever `\|f″\| ≤ B` on `[a,b]` and `f` is continuous. |

The classical constant is `1/24`; `1/4` is deliberately loose and still
negligible for the density panels (`B ≈ 10⁻³`, `h ≈ 0.05` give `≈ 3·10⁻⁸` per
panel).  The proof writes `φ = (f − f(m)) − f′(m)(·−m)`, observes
`φ(m) = φ′(m) = 0`, applies `Convex.norm_image_sub_le_of_norm_deriv_le` twice to
get `|φ(x)| ≤ C|x−m|` with `C = B(b−a)/2`, and uses `∫_a^b (x−m) = 0` (from the
antiderivative `(x−m)²/2`) to remove the linear term.

## [`WeightBound.lean`](WeightBound.lean) — the panel weight and its derivatives

The weight `w(t) = σ²exp(−σ²t²)cos(ct)` at `σ = 1/20`, with explicit first and
second derivatives:

| Name | Statement |
|---|---|
| `weight`, `weight1`, `weight2` | `w`, `w′`, `w″`. |
| `hasDerivAt_gauss` | `d/dt exp(−(t/20)²) = −(t/200)·exp(−(t/20)²)`. |
| `hasDerivAt_cos` | `d/dt cos(ct) = −c·sin(ct)`. |
| `hasDerivAt_weight` | `weight c` has derivative `weight1 c`. |
| `hasDerivAt_weight2` | `deriv (weight1 c) = weight2 c`. |
| **`abs_deriv2_weight_le`** | **`|w″(t)| ≤ 1/400` on `[0,60]` when `|c| ≤ 3/5`.** |

The bound: `w″ = σ²·G·[(−2σ² + 4σ⁴t² − c²)cos(ct) + 4σ²ct·sin(ct)]` with
`G = exp(−σ²t²) ≤ 1`, so `|w″| ≤ σ²(1/200 + 9/100 + 9/25 + 2·(60/200)·(3/5)) = 2.04·10⁻³ ≤ 1/100`.

## [`OmegaGlobal.lean`](OmegaGlobal.lean) — the tail bound's support lemmas

R2 truncates the density at `t = 60`; the tail needs a bound on `|Ω|` for all
large `t`.

| Name | Statement |
|---|---|
| `omegaPoint` | `1/4 + (t/2)i`. |
| `omegaPoint_re`, `omegaPoint_im` | `Re = 1/4`, `Im = t/2`. |
| `omegaPoint_norm_le` | `‖omegaPoint t‖ ≤ 1/4 + t/2` for `t ≥ 0`. |
| `quarter_le_norm_omegaPoint` | `1/4 ≤ ‖omegaPoint t‖`. |
| `Omega_eq_re_digamma` | `Ω(t) = Re ψ(omegaPoint t) − log π`. |
| `abs_six_le` | the six-term triangle inequality used by the expansion. |

| `log_four_le_two` | `log 4 ≤ 2`. |
| `omegaRem`, `omegaRem_norm_le` | the Euler–Maclaurin remainder, `‖·‖ ≤ 13`. |
| `Omega_expansion` | `Ω(t) = Re log w − log π − Re(1/2w) − Re(1/12w²) + Re(1/120w⁴) − Re R`. |
| `abs_log_omegaPoint_le` | `|Re log w| ≤ log(t+2) + 2`. |
| **`abs_Omega_le`** | **`|Ω(t)| ≤ log(t+2) + 24` for `t > 0`.** |

This is the gate to the density tail: `|∫_{60}^∞ σ²e^{−σ²t²}cos(ct)Ω| ≲ 5·10⁻⁵`.

## [`DensityWeight.lean`](DensityWeight.lean) — the weight's elementary facts

| Name | Statement |
|---|---|
| `abs_densityWeight_le` | `|w(t)| ≤ 1/400` (the `Sw` of the panel bound). |
| `continuous_densityWeight` | `w` is continuous. |
| `densityWeight_nonneg` | `w(t) ≥ 0` when `cos(ct) ≥ 0`. |

## [`PanelAssembly.lean`](PanelAssembly.lean) — the per-panel signed bound

The heart of the density assembly.  On a panel `[a,b]` with `qlo ≤ Ω ≤ qhi` on
the panel and `δ = max (qmid − qlo) (qhi − qmid)`:

| Name | Statement |
|---|---|
| **`panel_mem`** | **`\|∫_p w·Ω − qmid·(b−a)·w(m)\| ≤ \|qmid\|·Bw·(b−a)³/4 + δ·(b−a)·Sw`** |

The leading term `qmid·(b−a)·w(m)` is **signed** — essential, since an
absolute-value estimate of the panel integrals is `≈ 0.8` while the signed
density is `≈ 0.01`.

## [`PanelSum.lean`](PanelSum.lean) — the panel sum and the `Ioi` split

| Name | Statement |
|---|---|
| **`panel_sum_error`** | if each panel error is `≤ E p`, then `\|∫_{a 0}^{a P} w·Ω − Σ_p qmid p·(b_p−a_p)·w(m_p)\| ≤ Σ_p E p`. |
| `integral_Ioi_split` | `∫_{Ioi 0} f = (∫_0^T f) + ∫_{Ioi T} f` for `T ≥ 0`. |

`panel_sum_error` uses `intervalIntegral.sum_integral_adjacent_intervals` for the
telescoping (so nothing has to be proved about the partition) and
`Finset.abs_sum_le_sum_abs` for the error accumulation.

## [`PanelCertificate.lean`](PanelCertificate.lean) — the generator's primitive

| Name | Statement |
|---|---|
| `weight_midpoint_rule` | the midpoint rule for the weight on a panel inside `[0,60]` (`Bw = 1/100`). |
| **`panel_certificate`** | from a midpoint enclosure `Ω(m) ∈ [qmlo, qmhi]` and `\|Ω′\| ≤ lipx`, produce the full `panel_mem` conclusion with explicit `qlo, qhi, qmid` and error. |

This is the single lemma the generator must invoke per panel: everything else
(`omega_panel_enclosure`, `panel_mem`, the midpoint rule, `\|w\| ≤ 1/400`) is
discharged inside it.

## [`GaussianTail.lean`](GaussianTail.lean) — the tail integral

| Name | Statement |
|---|---|
| `tendsto_gauss_neg` | `exp(−b y²) → 0` as `y → ∞`. |
| **`integral_Ioi_gaussian_moment`** | **`∫_{Ioi T} (1/400)·x·exp(−x²/400) = exp(−T²/400)/2`.** |

From the antiderivative `−(1/2)exp(−x²/400)` via
`MeasureTheory.integral_Ioi_of_hasDerivAt_of_tendsto` (the *unprimed* version —
the primed one wants `Set.Ici`, not `Set.Ioi`) and Mathlib's
`integrable_mul_exp_neg_mul_sq` for the integrability.

## [`OmegaPanel.lean`](OmegaPanel.lean) — midpoint to panel

| Name | Statement |
|---|---|
| **`omega_panel_enclosure`** | if `\|Ω′\| ≤ lipx` on `[a,b]` and `Ω(m) ∈ [qmlo, qmhi]` at the midpoint, then `Ω t ∈ [qmlo − lipx(b−a)/2, qmhi + lipx(b−a)/2]` on the panel. |

This turns `IntersectionForm.omega_mem`'s *pointwise* rational enclosure (plus the
Lipschitz bound `lip(t) ≤ 6/t`) into the *panel* enclosure that `panel_mem`
consumes, via `Convex.norm_image_sub_le_of_norm_deriv_le`.

## [`WeightDecay.lean`](WeightDecay.lean) — the weight's decay, rationally

| Name | Statement |
|---|---|
| `exp_neg_le_inv_one_add` | `exp(−u) ≤ 1/(1+u)` for `u ≥ 0` (from `1 + u ≤ exp u`). |
| `abs_weight_le_exp` | `\|w(t)\| ≤ (1/400)exp(−t²/400)`. |
| **`abs_weight_le_div`** | **`\|w(t)\| ≤ (1/400)/(1 + a²/400)` for `t ≥ a ≥ 0`** — a *rational* panel-local `Sw`, needing no exp bound. |

This lets the generator use the weight's decay in the panel budget: the
`δ·(b−a)·Sw` term then shrinks with `a`, instead of using the global `Sw = 1/400`.

## [`DensityTail.lean`](DensityTail.lean) — the pointwise tail bound

| Name | Statement |
|---|---|
| `log_add_two_le` | `log(x+2) + 24 ≤ x` for `x ≥ 60`. |
| `exp_neg_nine_le` | `exp(−9) ≤ 1/5000`. |
| `abs_densityWeight_le_exp` | `\|w(t)\| ≤ (1/400)exp(−t²/400)`. |
| **`abs_densityWeight_mul_Omega_le`** | **`\|w(t)·Ω(t)\| ≤ (1/400)·t·exp(−t²/400)` for `t ≥ 60`.** |

| `integrableOn_gaussian_moment` | the moment integrand is `IntegrableOn (Ioi T)`. |
| **`density_tail_le`** | **`\|∫_{Ioi 60} w·Ω\| ≤ 1/10000`.** |

The comparison `|∫| ≤ ∫|·| ≤ ∫ (1/400)t·exp(−t²/400) = e^{−9}/2 < 10⁻⁴` uses
`MeasureTheory.abs_integral_le_integral_abs`, `MeasureTheory.Integrable.mono'`
and `MeasureTheory.setIntegral_mono_on` (which takes the measurability of the
set as its *third* argument).

## [`OmegaContinuous.lean`](OmegaContinuous.lean) — continuity of `Ω`

| Name | Statement |
|---|---|
| `continuous_digamma_line` | `t ↦ ψ(1/4 + (t/2)i)` is continuous (from the library's `Rh45.analyticAt_digamma_line`). |
| **`continuous_Omega`** | **`Ω` is continuous.** |
| `differentiable_digamma_line` | `t ↦ ψ(1/4 + (t/2)i)` is differentiable. |
| **`differentiable_Omega`** | **`Ω` is differentiable** (needed by `omega_panel_enclosure`). |

This supplies the measurability that the tail comparison and the panel
integrability facts need.

## [`DensityAssembly.lean`](DensityAssembly.lean) — the capstone

| Name | Statement |
|---|---|
| `continuous_densityWeight_mul_Omega` | the density integrand is continuous. |
| **`density_approx_error`** | if the panels `a 0, …, a P = 60` approximate the density integrals with errors `E p`, then `\|density(1/20,c) − Σ_p qmid p·(b_p−a_p)·w(m_p)\| ≤ Σ_p E p + 10⁻⁴`. |

## [`CosBound.lean`](CosBound.lean) — a cos Taylor remainder

Mathlib has no cos Taylor remainder; this is the one the density generator needs.

| Name | Statement |
|---|---|
| `re_cos_ofReal` | `(Complex.cos ↑x).re = Real.cos x`. |
| `re_exp_mul_I` | `(Complex.exp (↑x · i)).re = Real.cos x`. |
| **`cos_bound_small`** | **for `\|x\| ≤ 1`: `\|cos x − Re(Σ_{m<n} (x i)^m/m!)\| ≤ \|x\|ⁿ·(n+1)/(n!·n)`** |

From `Complex.exp_bound` at `x·i` (`‖x·i‖ = |x| ≤ 1`) and
`Complex.abs_re_le_norm`.  The polynomial part
`Re(Σ_{m<n} (x i)^m/m!)` is a rational expression in `x`, and larger arguments
follow by doubling:

| Name | Statement |
|---|---|
| `sq_mem_Icc` | a tight bracket for `c²` from `c ∈ [lo,hi]` (the `if` handles the sign). |
| **`cos_double_mem`** | **`cos y ∈ [lo,hi]` ⟹ `cos (2y) ∈ [2·sqLo − 1, 2·sqHi − 1]`** |

so `x = 2⁶·(x/64)` with `x/64 ≤ 0.5625 ≤ 1` needs six applications.  This completes
the cos layer for `|x| ≤ 36`.

## [`DensityDemo.lean`](DensityDemo.lean) — interface validation

| Name | Statement |
|---|---|
| `weight_eq_densityWeight` | `weight c t = IntersectionForm.densityWeight (1/20) c t`. |
| `omega_mem_thirty` | `Ω(30)` enclosed by `omega_mem 30 1 1000`. |
| **`density_one_panel`** | **`density_approx_error` instantiated on the single panel `[0,60]`**: from the panel hypothesis it yields the density enclosure. |

This confirms that the chain's hypotheses and conclusions *match*: `density_approx_error`
accepts a one-panel partition and produces the density bound.  Since the
conclusion keeps `w(30)` symbolic, **no exp or cos bound is involved** — the chain
is validated independently of the transcendental layer.

This reduces the whole density enclosure to the panel data and nothing else: the
finite part by `panel_sum_error`, the tail by `density_tail_le`, glued through
`integral_Ioi_split`.  (`intervalIntegrable_iff_integrableOn_Ioc_of_le` converts
the continuity-derived interval integrability into the `IntegrableOn (Ioc 0 60)`
that `integral_Ioi_split` wants.)  The proof uses the linearity identity
`∫_p w·Ω − qmid·∫_p w = ∫_p w·(Ω − qmid)` (with `f`, `g` passed explicitly to
`intervalIntegral.integral_sub`), the mean value bound on `Ω − qmid`, and the
midpoint rule's remainder `Bw·(b−a)³/4` as a hypothesis.

## [`DensityEnclosure.lean`](DensityEnclosure.lean) — R2's interface

The bridge to the shared analysis library.

| Name | Statement |
|---|---|
| `omega_eq_Omega` | the density of `GaussianGram.lean` equals `IntersectionForm.Omega`. |
| `density_integrand_neg` | the density integrand is even. |
| **`densityTerm_eq_two_mul_density`** | `densityTerm c σ = 2 * IntersectionForm.density σ c`. |

From here the library's `density_mem` (an interval enclosure of the half-line
density from pointwise bounds `lo ≤ Ω ≤ hi`) and `omega_mem` (a rational
enclosure of `Ω` at a rational point) apply directly.  What remains is the
panel bookkeeping: choosing `lo`, `hi` as step functions on `[0, 60]`, with
`omega_mem` at the panel midpoints and a `t`-dependent derivative bound for the
intra-panel variation.


The density term is enclosed by the generated certificates below; see
[`../OMEGA-ROUTE.md`](../OMEGA-ROUTE.md) §4.

## [`OmegaScaled.lean`](OmegaScaled.lean) — a cheap pointwise `Ω` enclosure

`IntersectionForm.omega_mem` computes `log (panelQ t N)` with the atanh series
directly: at `t = 60` the ratio is `≈ 0.998`, needing `M ≈ 1500` terms — far too
slow to `native_decide` on every panel.  The scaled identity
`log q = log(q/4^j) + j log 4` brings the argument into `[1,4)`, where the ratio
is at most `3/5`.

| Name | Statement |
|---|---|
| `log4Lo`, `log4Hi`, `log4_mem` | rational enclosure of `log 4`. |
| `panel_log_re_mem_scaled` | `log (panelQ t N)` from the scaled series and `j log 4`. |
| `omegaLoS`, `omegaHiS` | the scaled endpoints. |
| **`omega_mem_scaled`** | **`omegaLoS t N M j ≤ Ω t ≤ omegaHiS t N M j`** for `N ≥ 1`, `t ≠ 0`, `4^j ≤ panelQ t N`. |

With `N = 4`, `M = 45` the bracket width is below `2·10⁻⁵` for every `t ≤ 60`.

## [`LipSmall2.lean`](LipSmall2.lean) — the `t ≥ 1` Lipschitz bound

The same telescoping sum bound as `DensityPanel.tsum_shifted_inv_le`, but
valid from `a ≥ 1/2`: `(a+2)/a² + 1/a = (2a+2)/a² ≤ 6/a` iff `a ≥ 1/2`.

| Name | Statement |
|---|---|
| `tsum_shifted_inv_le_six` | `Σ_j ((j+1/4)²+a²)⁻¹ ≤ 6/a` for `a ≥ 1/2`. |
| **`deriv_Omega_abs_le_six`** | **`|Ω′(t)| ≤ 6/t` for `t ≥ 1`.** |

Only `[0,1]` needs the global constant `10` then, which halves the panel count
on `[1,60]`.

## [`PanelDecay.lean`](PanelDecay.lean) — decaying certificate, glue and steps

| Name | Statement |
|---|---|
| **`panel_certificate_decay`** | `panel_certificate` with the panel-local `Sw = (1/400)/(1+a²/400)` of `WeightDecay.abs_weight_le_div`. |
| **`panel_glue`** | folds a node bracket `|w(m) − w₀| ≤ eps` into the panel bound: `|∫ − qmid·h·w₀| ≤ E1 + |qmid|·h·eps`. |
| **`panel_step`** | extends `|∫_a^b − T| ≤ S` by `|∫_b^c − R| ≤ E` to `|∫_a^c − (T+R)| ≤ S+E`. |
| `PanelChain`, `PanelChain.total`, `PanelChain.bound` | the earlier structural-recursion assembly (kept, no longer emitted: its `norm_num` evaluation is superlinear in the number of panels). |

## `DensityC{0,1,2,3,4}_{0..8}.lean` — the generated certificates

Each file (17–27 MB, `1305` panels) proves

```lean
theorem density_mem_c<i> : IntersectionForm.density (1/20) c ∈ Set.Icc LO HI
```

with explicit rational `LO, HI` of total width `≈ 2.9·10⁻³`
(per-panel error `Σ E_p + 10⁻⁴ ≈ 1.45·10⁻³`).  The fifth column,
`DensityC4_*` (`c = 4/5`), uses the parallel panel certificate with the
second-derivative constant `1/200`; its width is `≈ 3.2·10⁻³`.  It is emitted by
[`gen/panels.py`](gen/panels.py); see [`gen/README.md`](gen/README.md) for the
design.  The partition is 125 panels of width `1/125` on `[0,1]`, then 1180 of
width `1/20` on `[1,60]`.

## [`DensityCertificates.lean`](DensityCertificates.lean) — R2 closed

| Name | Statement |
|---|---|
| `densityTerm_mem_c0 … c3` | the four `densityTerm` bands of `Assembly.gaussianGram4_posDef_of_density_enclosure_loose`. |
| **`gaussianGram4_posDef`** | **`(gaussianGram4 (1/20)).PosDef`** — the exact `4×4` Gaussian Weil Gram matrix is positive definite. |

## [`GaussianGram5.lean`](GaussianGram5.lean) — the 5×5 transfer (M0′)

The five centres `−0.4, −0.2, 0, 0.2, 0.4`, the exact matrix `gaussianGram5`,
the rational centre `gramCentre5`, the margin `1/50`, and the exact factorisation

```lean
gramCentre5 − (1/50)·I = L5 · D5 · L5ᵀ
```

with the five positive pivots `0.023136, 0.011384, 0.010162, 0.010162, 0.004865`.
The transfer wrapper is `gaussianGram5_posDef_of_entry_bound`; `ε · 5 < 1/50`
is the dimension-correct norm condition.

## [`DensityCertificates5.lean`](DensityCertificates5.lean) — M0′ closed

| Name | Statement |
|---|---|
| `densityTerm_mem_c4` | the `c = 4/5` density band `[−16443, −10097]/10⁶`. |
| `gaussianGram5_apply` | splits one 5×5 entry into pole + density + symmetrised prime. |
| `gaussianGram5_posDef_of_density_enclosure_loose` | the five density bands imply `(gaussianGram5 (1/20)).PosDef`, with entry budget `ε = 0.0036` (`5ε = 0.018 < 0.02`). |
| **`gaussianGram5_posDef`** | **`(gaussianGram5 (1/20)).PosDef`** — the exact `5×5` Gaussian Weil Gram matrix is positive definite. |

## [`FirstRung.lean`](FirstRung.lean) — the single Gaussian

| Name | Statement |
|---|---|
| `gaussianW_zero_mem` | `gaussianW 0 (1/20) ∈ [0.0396, 0.0467]`. |
| **`gaussianW_zero_pos`** | `0 < gaussianW 0 (1/20)`: the first rung of the Weil ladder, with explicit margin. |
| `gaussianGramEntry_zero_zero` | `gaussianGramEntry 0 0 σ = gaussianW 0 σ`. |
| `gaussianGram4_zero_zero` | the `(0,0)` entry of the 4×4 matrix is that value. |

This is the single-test-function statement recommended in
[`../WEIL-POSITIVITY.md`](../WEIL-POSITIVITY.md) §6; it is a finite theorem,
not cone positivity.

## [`ZeroSidePole.lean`](ZeroSidePole.lean) — the first bridge identity

| Name | Statement |
|---|---|
| `zeroSideGaussian` | `H_c(s) = 2πσ² exp(σ²(s−1/2)²) exp(−c(s−1/2))`, the zero-side Gaussian. |
| `zeroSideGaussian_zero`, `zeroSideGaussian_one` | its two pole values. |
| **`poleTerm_eq_zeroSideGaussian_pole`** | `poleTerm c σ = H_c(0) + H_c(1)`. |
| `poleTerm_eq_zeroSideGaussian_pole_re` | the real form used by the Gram entry. |

This is the first formal link from the finite Gram certificate to the
explicit-formula side.  The archimedean and prime terms, the infinite zero sum
and the off-line obstruction are not proved here; see
[`../ZERO-SIDE-BRIDGE.md`](../ZERO-SIDE-BRIDGE.md) and the O2 row of the
[angular-partition dossier](../../angular-partition-method/README.md) §10.

## Reusable analytic infrastructure elsewhere in the repository

W2 is *not* blocked on Mathlib: the `ψ` Euler-limit formula, the pointwise
rational enclosure of `Ω`, the polygamma series, Taylor bounds for `exp`, and a
proved Simpson panel estimate all exist in Lean in
[`../../intersection-form-zeta/lean/`](../../intersection-form-zeta/lean/)
(`DigammaEnclosure.lean`, `Enclosure.lean`, `PanelEnclosure.lean`,
`SimpsonPanel.lean`) and
[`../../../rh/research/publish/013-twin-prime-parity-explicit-function/lean/Rh45/`](../../../rh/research/publish/013-twin-prime-parity-explicit-function/lean/Rh45/).
The table in [`../OMEGA-ROUTE.md`](../OMEGA-ROUTE.md) §2 lists the exact
declarations. The remaining work is the generated assembly for the Gaussian
weight; see that note's §4. The first seven are the finite spectral core of `tensor.md`
Theorem C(2): on a finite set of real frequencies, a positive combination of
Fourier atoms is of positive type. The first three are the elementary positivity
facts behind Definition 3.1 and the positivity of `Φ`.

## What is not formalised

The source `tensor.html` is a speculative programme, not a proved
theorem. The companion `tensor.md` refutes its defining inequality
`(⋆)` and identifies the repair. This Lean file deliberately formalises
only the finite, elementary lemmas; the analytic statements are recorded
as source claims or open items in the [programme dossier](../README.md).

Not formalised here:

- the infinite prime current and its absolute convergence on the Weil
  cone (only finite truncations are treated);
- the infinite Jacobi series and the identity `Φ̂ = ½ Ξ_cos`;
- Lemma 2.1 (the square `ĝ = |f̂|²`), Lemma 2.2 (the archimedean
  transform), Lemma 2.3 (the prime current as a contour integral) and
  Lemma 2.4 (the explicit formula);
- Theorem A (the exact signed spectral resolution of `P = Π + Θ`);
- Theorem B (the numerical refutation of `(⋆)` with the witness `f₀`);
- Theorem C (the identity with Weil's current and the equivalence of its
  positivity with RH);
- Bochner's theorem on the cone, and any statement about zeros of `ζ`;
- the Riemann hypothesis, which is never asserted or assumed;
- ~~the exact Gaussian Gram certificate of O4 (`gaussianGram4_posDef`)~~: this
  is now proved in [`DensityCertificates.lean`](DensityCertificates.lean)
  (it certifies the `4×4` matrix, not the infinite Weil cone);
- ~~the 5×5 rung M0′ (`gaussianGram5_posDef`)~~: now proved in
  [`DensityCertificates5.lean`](DensityCertificates5.lean).

The numerical content of Theorem B is checked separately in
[`../tests/test_programme.py`](../tests/test_programme.py), not in Lean.
It is a computation, not a formal theorem.

[Back to the programme](../README.md) · [Topic index](../../README.md)
