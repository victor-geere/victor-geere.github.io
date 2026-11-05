# W2–W4 — the remaining assembly of the O4 certificate

**Status:** route note.  **O4 is now closed** (2026-11-05): the four density
intervals of §4 are proved by the generated files
[`lean/DensityC0_0.lean`](lean/DensityC0_0.lean) … [`lean/DensityC3_8.lean`](lean/DensityC3_8.lean),
and [`lean/DensityCertificates.lean`](lean/DensityCertificates.lean) derives
`(gaussianGram4 (1/20)).PosDef`.  This file records what the O4 certificate
needed, what already existed in Lean, and the exact remaining work — it is kept
as the route record, with §4 updated to its final state.

The assembly skeleton and the reduction are in
[`lean/GaussianGram.lean`](lean/GaussianGram.lean); the exact rational transfer
certificate is in [`lean/Transfer.lean`](lean/Transfer.lean).

---

## 1. The obligation, exactly

O4 needs

```lean
theorem gaussianGram4_posDef : (gaussianGram4 (1/20)).PosDef
```

and `gaussianGram4_posDef_of_enclosure` reduces it, unconditionally, to a single
entrywise enclosure:

```lean
∀ i j, |gaussianGram4 (1/20) i j − gramCentre4 i j| ≤ ε,   4 ε < 0.0227,
```

i.e. every entry of the exact Gram matrix within `ε < 0.005675` of the rational
centre `gramCentre4`. Each entry is `(W(c) + W(−c))/2` with `W = pole + density +
prime` and `c ∈ {0, ±1/5, ±2/5, ±3/5}`.

Numerically (30 digits):

| `c` | pole | density | prime |
|---:|---:|---:|---:|
| 0 | 0.031435567627 | 0.011700390768 | −1.2e−22 |
| 1/5 | 0.031592876491 | −0.048082135113 | −2.4e−12 |
| 2/5 | 0.032066377481 | −0.024035199425 | −1.6e−5 |
| 3/5 | 0.032860809554 | −0.016840432117 | −3.65e−2 |

The pole and prime terms are elementary. The density term is the difficult one:
it is `O(0.05)` and must be **computed**, not merely bounded — a pointwise bound
`|Ω| ≤ B` gives an entry error `0.0025 · B · 35.45`, which is `0.53` at `B = 6`,
two orders of magnitude too large.

## 2. Correction: the analytic layer is *not* missing

The first revision of this note claimed that

* differentiating Mathlib's Euler limit for `Γ` (to get the `ψ` limit formula),
  and
* a rigorous interval enclosure of `Ω`

were open gaps in Mathlib and the blocker of W2. **That was wrong.** Both exist
in this repository, in Lean, with no `sorry`:

| Statement | Where |
|---|---|
| `ψ(s) = lim_n [log n − Σ_{k=0}^n 1/(s+k)]` for `Re s > 0` | `intersection-form-zeta/lean/DigammaEnclosure.lean`, `tendsto_digamma_partial` |
| `ψ(s) = log s − 1/(2s) − Σ B_{2k}/(2k s^{2k}) + R_K`, explicit bound on `R_K` | same file, `digamma_expansion`; shifted form `digamma_shifted_expansion` |
| `ψ(1/4) = −γ − π/2 − 3 log 2` | `intersection-form-zeta/lean/Enclosure.lean`, `digamma_quarter` |
| rational enclosures of `γ` (two monotone sequences) and of `log` at rational arguments | same file, `gammaLower`/`gammaUpper`, `logPointLo`/`logPointHi` |
| **pointwise rational enclosure of `Ω`**: `omegaLo t N M ≤ Ω t ≤ omegaHi t N M` for `t : ℚ`, `t ≠ 0`, with `N` shift terms and `M`-digit log bounds | `intersection-form-zeta/lean/PanelEnclosure.lean`, `omega_mem` |
| `|Ω′(t)| ≤ psiSeriesBound 1`, and generally `‖Ψ^{(k)}(t)‖ ≤ psiSeriesBound k` | `rh/research/publish/013-…/lean/Rh45/Archimedean.lean`, `abs_deriv_Omega_le`, `archimedean_deriv_bound` |
| Leibniz bound `|(φΨ)^{(n)}| ≤ Σ binom(n,k) M_k P_{n−k}` | same file, `abs_iteratedDeriv_mul_le`, `abs_iteratedDeriv_four_mul_le` |
| **Simpson panel estimate**, proved (Mathlib has no quadrature rule) | same file `simpsonSum_sub_integral_le`, `simpsonSum_mul_error_le`; also vendored as `intersection-form-zeta/lean/SimpsonPanel.lean`, `simpsonPanelEstimate` |
| polygamma series `ψ^{(k)}(z) = (−1)^{k+1} k! Σ_j (z+j)^{−k−1}`, locally uniform | `Rh45/PolygammaSeries.lean`, `digamma_polygamma_series` |
| exact rational `LDLᵀ` ⇒ `PosDef`, and the box (row-sum) transfer | `intersection-form-zeta/lean/Topic.lean`, `ldl_posDef_rat`, `posDef_of_box_rat`; self-contained in this topic as `Transfer.lean`, `posDef_of_entry_bound` |

So W2 is *computable*; what is missing is the **assembly for the Gaussian
weight**, not an analytic theorem.

## 3. What is now done: the pole term

[`lean/PoleEnclosure.lean`](lean/PoleEnclosure.lean) proves, for `σ = 1/20`,

```
poleTerm c (1/20) = (π/100) · exp(1/1600) · cosh(c/2),
```

and encloses it in rational intervals of width `2·10⁻⁶`:

| `|c|` | enclosure |
|---|---|
| 0 | `[0.031434, 0.031436]` |
| 1/5 | `[0.031591, 0.031593]` |
| 2/5 | `[0.032065, 0.032067]` |
| 3/5 | `[0.032859, 0.032861]` |

(`poleTerm_mem_c0 … poleTerm_mem_c3`, plus evenness `poleTerm_neg`.) The proof
uses `Real.pi_gt_d4`/`pi_lt_d4`, `Real.exp_bound` with `n = 2` and `n = 8`,
`Complex.two_cosh` transported to `ℝ`, and exact rational arithmetic.

## 4. What remains

**State at the end of the numerical round (2026-11-05).**  All pieces are proved,
including the numerical generation:

| piece | status | file(s) |
|---|---|---|
| R1 prime term | ✅ | `PrimeEnclosure.lean` |
| R2 density — analysis | ✅ | 18 files (below) |
| R2 density — numbers | ✅ | `DensityC{0..3}_{0..8}.lean` (generated by `gen/panels.py`) |
| R3 assembly | ✅ | `Assembly.lean` + `DensityCertificates.lean` |

The numerical layer was completed with four additions to the machinery:

* `OmegaScaled.lean` — the pointwise `Ω` enclosure with a **scaled** log
  (`log q = log(q/4^j) + j log 4`), so `N = 4`, `M = 45` suffice at `t = 60`
  (the unscaled `omega_mem` needs `M ≈ 1500`);
* `LipSmall2.lean` — `|Ω′(t)| ≤ 6/t` already for `t ≥ 1` (the same sum bound at
  `a ≥ 1/2`), halving the panel count on `[1,60]`;
* `PanelDecay.lean` — the panel certificate with the **panel-local** rational
  weight bound `(1/400)/(1+a²/400)`, the node-bracket glue `panel_glue`, and
  the cumulative assembly step `panel_step`;
* `CosBound.lean` — the auxiliary sign-specific doubling lemmas
  `cos_double_mem_pos/_neg/_mixed`.

The density analysis comprises: `DensityEnclosure` (the `2·density` bridge),
`DensityPanel` (`\|Ω′\| ≤ 6/t`), `LipSmall` (`\|Ω′\| ≤ 10`), `OmegaGlobal`
(`\|Ω\| ≤ log(t+2)+24`), `OmegaContinuous` (continuity, differentiability),
`OmegaPanel` (midpoint → panel), `MidpointRule` (the quadrature rule),
`WeightBound` / `WeightDecay` / `DensityWeight` (the weight), `PanelAssembly`
(`panel_mem`), `PanelCertificate` (`panel_certificate`), `PanelSum`
(`panel_sum_error`), `GaussianTail` + `DensityTail` (the tail), `DensityAssembly`
(`density_approx_error`), `CosBound` (the cos Taylor remainder and doubling).

### R1 — the prime term (proved: `PrimeEnclosure.lean`)

`primeTerm c (1/20) = −2 Σ_n Λ(n)/√n · √π σ · exp(−(log n − c)²/(4σ²))`, with
`4σ² = 1/100`. At `σ = 1/20` the sum is carried by `n = 2`:

* `n = 2` contributes `−0.036481631…` at `c = 3/5` (the only non-negligible
  term; this is the "prime side is active" of `WEIL-GRAM.md` §0);
* `n = 3` contributes `< 2·10⁻¹²`, and the rest is far smaller, since
  `(log n − c)² ≥ (log 3 − 0.6)² > 0.248` gives `exp(−24.8)`.

Needed: rational bounds for `log 2`, `√2`, `√π`, `exp(·)` (all available:
`Real.log_two_gt_d9`, `Real.sqrt` bounds, `Real.exp_bound`), plus a tail bound.

**Done.** [`lean/PrimeEnclosure.lean`](lean/PrimeEnclosure.lean) now encloses
the prime term:

* `primeSummand_le` — `Λ(n)/√n · √π/20 · exp(−100(log n − c)²) ≤ (√π/20)·n⁻¹³`
  for `n ≥ 3`, `c ≤ 3/5`;
* `sum_tail_le_rat` — the tail is below `2.51·10⁻⁷` (via the telescoping
  domination `n⁻¹³ ≤ 3⁻¹¹·n⁻² ≤ 3⁻¹¹·(1/((n−1)n))`, summed with
  `Real.tsum_le_of_sum_range_le`);
* `prime_sum_split` — the full sum is the `n = 2` term plus the tail;
* `primeTerm_mem_small` — for `c ≤ 2/5`, `−2.2·10⁻⁵ ≤ primeTerm c (1/20) ≤ 0`;
* `primeTerm_mem_three_fifths` — `−0.036490 ≤ primeTerm (3/5) (1/20) ≤ −0.03646`
  (true value `−0.036481…`).

### R2 — the density term

```
densityTerm c (1/20) = (1/400) ∫_ℝ exp(−t²/400) cos(ct) Ω(t) dt.
```

Plan, using the existing machinery:

1. **Truncate.** `|t| > 60` contributes below `4·10⁻⁶` to the entry (Gaussian
   tail times `|Ω| ≲ 3`).
2. **Panels.** On each panel the integrand is `φ(t)·Ω(t)` with
   `φ(t) = (1/400) exp(−t²/400) cos(ct)`. Use the Simpson estimate of
   `Rh45/Archimedean.lean` with `M k` = explicit bounds on `|φ^{(k)}|` and
   `P k` = bounds on `|Ω^{(k)}|`.
3. **The obstruction, precisely.** The packaged `P k` are the *global* bounds
   `psiSeriesBound k` (t-independent, dominated by the singularity at `t = 0`;
   `psiSeriesBound 4 ≈ 1.5·10³`). With them the Simpson error is
   `(2H)⁴·T/2880·B ≈ 0.014·B` at `H = 0.1`, `T = 40`, i.e. `≈ 21` — useless.
   The fix is a **`t`-dependent** `P k`, which the polygamma series gives
   (`‖ψ^{(k)}(1/4+it/2)‖ ≤ k! 2^{−k} Σ_j ((j+1/4)² + t²/4)^{−(k+1)/2}`); only
   `k = 1` is currently packaged (`PanelEnclosure.norm_deriv_digamma_le_tsum`).
4. **Node values.** `omega_mem t N M` gives a pointwise rational enclosure at a
   rational node, with width controlled by `N` (shift, remainder `1/(81N⁵)`)
   and `M` (log digits). At `N = 4`, `M = 12` the width is `≲ 10⁻⁵` — well
   inside budget.

**The truncation bound is now Lean-proved.** [`lean/SeriesRoute.lean`](lean/SeriesRoute.lean)
proves `sum_omegaTerm_tail_le`: for `N ≥ 2`,
`Σ_{k≥N} u_k(t) ≤ (t²/4)/(N+1/4)²`, by the domination `u_k ≤ t²/(4a_k³)` and
the telescoping `1/a³ ≤ 1/a² − 1/(a+1)²` (`a ≥ 2`). After the Gaussian weight
this is an entry error of `√π/(8σN²) ≈ 1.1/N²`, i.e. `1.1·10⁻⁴` at `N = 100`.
So the series route's *error bookkeeping* is Lean-checked; what remains is the
identity `Ω = ψ(1/4) − log π + Σ u_k` and the quadrature.
5. **Cost.** With a `t`-dependent fourth-derivative bound, roughly 100–300
   panels suffice; that is 200–600 `omega_mem` evaluations, each a rational
   expression of ~30 terms. This is a *generated* file (as the Rust certificate
   of `intersection-form-zeta` already is), not hand-written proof.

### R3 — assembly (done)

[`lean/Assembly.lean`](lean/Assembly.lean) closes R3:

* `gaussianGram4_apply` splits each entry into `pole + density + (prime c + prime −c)/2`;
* `densityTerm_neg` records that the density term is even in `c`;
* `gaussianGram4_posDef_of_density_enclosure` proves

  ```
  density ∈ [0.0107, 0.0127]   at c = 0
  density ∈ [−0.0491, −0.0471] at c = 1/5
  density ∈ [−0.0251, −0.0231] at c = 2/5
  density ∈ [−0.0179, −0.0159] at c = 3/5
  ─────────────────────────────────────────────
  (gaussianGram4 (1/20)).PosDef
  ```

  with no other hypothesis. The bands are `±10⁻³`, chosen so that the entry
  error is `≤ 0.0012` against the transfer's `0.005675` budget; the pole and
  prime enclosures are tighter than `2.2·10⁻⁵`.

**So O4 was exactly R2**: the four interval memberships above.  They are now
proved, and `gaussianGram4_posDef` is a theorem of `DensityCertificates.lean`.
Nothing in the finite certificate is open.

### R2 — the interface to the shared library

[`lean/DensityEnclosure.lean`](lean/DensityEnclosure.lean) bridges the two
dossiers:

* `omega_eq_Omega` — the two `Ω`'s agree;
* `densityTerm_eq_two_mul_density` — `densityTerm c σ = 2 * IntersectionForm.density σ c`
  (the integrand is even, so the full-line integral is twice the half-line one).

The topic's `lean/check.sh` now sets `LEAN_EXTRA_PATH` to
`../../intersection-form-zeta/lean`, so `PanelEnclosure` and its import closure
(`DigammaEnclosure`, `Enclosure`, `PolygammaSeries`, `Archimedean`,
`GammaProduct`, `SimpsonPanel`, `EulerMaclaurin`) are available without copying
5,800 lines.  The closure contains no `Topic` module, so there is no collision
with this topic's `Topic.lean`.

With the bridge in place, R2 was:

1. choose step functions `lo ≤ Ω ≤ hi` on `[0, 60]` — `omega_mem` at panel
   midpoints, widened by a `t`-dependent derivative bound;
2. apply `IntersectionForm.density_mem` (which needs the three integrability
   side conditions) to enclose the half-line density;
3. double it (`densityTerm_eq_two_mul_density`) and feed the four intervals to
   `gaussianGram4_posDef_of_density_enclosure`.

**Done.**  The generator emits, per panel, `omega_mem_scaled` brackets at the
midpoint, the node value of `w`, the `panel_certificate_decay` instantiation and
the node-bracket glue.  The panels are glued by the cumulative lemmas
`cum0, cum1, …` (`PanelDecay.panel_step`), and the final `density` enclosure is
`cum1304` plus the `t > 60` tail.  The resulting bands are `≈ 1.45·10⁻³` wide,
inside the `1.75·10⁻³` slack of the transfer.

### R2 — API notes for the midpoint rule

The panel estimate needs the midpoint rule `|∫_a^b f − (b−a)f(m)| ≤ B(b−a)³/4`
for `|f″| ≤ B`; Mathlib has no quadrature rule, so it must be proved.  The
following exact signatures were verified this round (Lean `v4.35.0-rc2`) and are
what the proof will use:

* `Convex.norm_image_sub_le_of_norm_deriv_le` :
  `(∀ x ∈ s, DifferentiableAt 𝕜 f x) → (∀ x ∈ s, ‖deriv f x‖ ≤ C) → Convex ℝ s →
   x ∈ s → y ∈ s → ‖f y − f x‖ ≤ C * ‖y − x‖` — gives `|f′(x) − f′(m)| ≤ B|x−m|`
  (applied to `deriv f`) and `|φ(x) − φ(m)| ≤ C|x−m|` (applied to `φ`).
* `HasDerivAt.sub_const (c) (h) : HasDerivAt (fun x => f x − c) f' x` — the
  derivative of `φ` is `deriv f y − deriv f m`.
* `intervalIntegral.integral_eq_sub_of_hasDerivAt` :
  `(∀ x ∈ uIcc a b, HasDerivAt f (f' x) x) → IntervalIntegrable f' volume a b →
   ∫ x in a..b, f' x = f b − f a` — used to prove `∫_a^b (x − m) = 0` via the
  antiderivative `(x−m)²/2`.
* `intervalIntegral.integral_mono_on (hab) (hf) (hg) (h)` and
  `abs_integral_le_integral_abs hab` — monotonicity and the triangle inequality.
* `intervalIntegral.integral_const_mul`, `intervalIntegral.integral_const`
  (`∫ x in a..b, c = (b−a) • c`).
* `intervalIntegral.integral_id` **does not exist** in this version; use
  `integral_eq_sub_of_hasDerivAt` instead.
* `IntervalIntegrable` side conditions are not discharged by `by fun_prop`;
  use `(continuous_id.sub continuous_const).intervalIntegrable a b`.

### R2 — the midpoint rule (proved)

[`lean/MidpointRule.lean`](lean/MidpointRule.lean) proves `midpoint_rule_bound`:

```
|(∫ x in a..b, f x) − (b−a)·f((a+b)/2)| ≤ B·(b−a)³/4      (|f″| ≤ B on [a,b]).
```

Mathlib has no quadrature rule; this is the first in the dossier.  The constant
`1/4` (classical `1/24`) is negligible for the density panels.  The three
Lean-plumbing obstacles recorded earlier were resolved by passing `f` and `g` to
`intervalIntegral.integral_sub` **explicitly**, so that the rewrite pattern has
the same function shapes as the goal.

### R2 — the final budget (as of round 32)

Three improvements have widened the numerical budget considerably:

| lever | before | now |
|---|---|---|
| density bands accepted by the assembly | `±10⁻³` | **`±3.5·10⁻³`** (`gaussianGram4_posDef_of_density_enclosure_loose`) |
| weight curvature `Bw` | `1/100` | **`1/400`** (`abs_deriv2_weight_le`; true value `2.04·10⁻³`) |
| panel weight bound `Sw` | global `1/400` | **`(1/400)/(1+a²/400)`**, rational, panel-local (`abs_weight_le_div`) |

The error decomposition per panel (all available in Lean):

```
E p = |qmid p| · Bw · h³/4                    -- weight quadrature   (MidpointRule)
    + max(qmid−qlo, qhi−qmid) · h · Sw_p      -- Ω variation + enclosure
Sw_p = (1/400)/(1+a_p²/400)                   -- rational, decays like 1/a²
δ_p  ≈ lip(a_p)·h/2,  lip(a) = 6/a (a ≥ 4),  10 (a < 4)
```

with total `Σ_p E p + 10⁻⁴ ≤ 3.5·10⁻³` required.  A **graded** partition is
optimal: fine near `t = 0` (where `|Ω′| ≤ 10` and `Sw` is largest), coarse at
large `t` (where `Sw_p ≈ 1/(400)·400/a² = 1/a²` and the weight is tiny).  A few
hundred panels suffice.

**The one missing piece of machinery** is the evaluation of
`w(m) = (1/400)exp(−m²/400)cos(cm)` at the nodes:

* `exp`: `Real.exp_bound` needs `|x| ≤ 1`; with `y = m²/400 ≤ 9` use
  `exp(−y) = exp(−y/16)¹⁶` (four squarings, `y/16 ≤ 0.5625 ≤ 1`).
* `cos`: Mathlib has **no Taylor remainder for `cos`** (only `cos_le_one_sub_mul_cos_sq`
  for `|x| ≤ π`, `one_sub_sq_div_two_le_cos`, and `abs_cos_sub_cos_le`).  A bound
  must be built: reduce `cm ∈ [0,36]` modulo `π/2` using a rational enclosure of
  `π` (`Real.pi_gt_d20` and `Real.pi_lt_d20`, both present in `Mathlib/Analysis/Real/Pi/Bounds.lean`), then apply a
  Taylor remainder on `[0, π/2]`.

### R2 — measured parameters (feasibility)

`omegaLo t N M`/`omegaHi t N M` are **rational**, so their widths can be measured
by `#eval` and their inclusions verified by `native_decide`.  Measurements:

| `N` | `M` | `t` | width |
|---:|---:|---:|---:|
| 4 | 12 | 1 | 0.0133 |
| 6 | 16 | 1 | 0.0584 |
| 1 | 20 | 1 | 0.0081 |
| 1 | 100 | 20 | 0.0106 |
| 1 | 200 | 40 | 0.0422 |
| 1 | 300 | 40 | 0.0165 |

Two facts drive the choice of parameters.

* The width is dominated by the **shift remainder** `2·omegaRem N = 2/(81(N+1/4)⁵)`,
  so `N = 1` (width `8.1·10⁻³`) is the right regime; `N = 4` costs only `2.4·10⁻⁵`
  but makes `panelQ = (N+1/4)² + t²/4` large, and the internal `log` series
  converges like `((q−1)/(q+1))^{2M}` — so larger `N` needs *much* larger `M`.
* At `N = 1` the `M` needed for `t = 40` is about `300`; at `t ≤ 20`, `M = 100`
  suffices.

* **The `t`-dependent derivative bound is now Lean-proved**
  ([`lean/DensityPanel.lean`](lean/DensityPanel.lean)):
  `deriv_Omega_abs_le : |Ω′(t)| ≤ 6/t` for `t ≥ 4`, from the polygamma series
  and the elementary sum bound `Σ_j ((j+1/4)²+a²)⁻¹ ≤ 6/a` (`a ≥ 2`), which is
  proved by splitting at `⌈a⌉+1` and telescoping — no integrals, no `π`.

The R3 assembly tolerates an entry error of `0.005675`; the density term may
therefore be off by `±0.004`.  A panel of width `h` contributes
`width_panel × ∫_panel |w|` to the density error, and `∫ |w| ≈ σ² h`, so 400
panels of width `0.1` on `[0, 40]` with average width `0.015` give

`0.015 × 0.0025 × 35 ≈ 1.3·10⁻³`,

comfortably inside budget.  The intra-panel variation of `Ω` contributes
`(b−a)² σ² lip(a)/4` per panel with `lip(a) ≈ 4/a`, i.e. `≈ 9·10⁻⁴` total at
`h = 0.1`.

## 5. Scope

The certificate is for the single `4×4` matrix. It is not the infinite Weil
cone, it does not use the Euler product beyond the finite prime sum, and it says
nothing about the Riemann hypothesis. A positive enclosure is a ledger
computation; a negative one would refute the finite claim and would have to be
recorded as such.

## 6. Correction log

* **2026-11-04 (first revision).** Claimed that the `ψ` Euler-limit derivative
  ("B1") and the `Ω` enclosure ("B2") were open Mathlib gaps, and that a
  verified `exp`/`cos` interval library had to be built. Both claims were
  false: the limit formula, the `Ω` pointwise enclosure, the polygamma series,
  the Taylor bounds for `exp`, and a proved Simpson panel estimate all exist in
  this repository. The real remaining work is the generated assembly of §4, and
  the single genuine sub-obstruction is the `t`-dependent higher-derivative
  bound of R2 item 3.

---

[Back to the programme](README.md) · [Handoff](../angular-partition-method/HANDOFF-O4.md) ·
[Weil–Gram certificate](WEIL-GRAM.md) · [Lean index](../index-lean.md)
