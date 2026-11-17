# Handoff — the M0′ ladder is closed to n = 6

**Status:** the 4×4, 5×5 and 6×6 Gaussian Weil–Gram rungs are **closed in Lean
with no hypotheses**. `#print axioms` is clean for all three (see
[`lean/Audit.lean`](lean/Audit.lean)). There is no claim about the infinite Weil
cone and no claim about RH.

**Related:** [topic README](README.md) · [`WEIL-GRAM.md`](WEIL-GRAM.md) ·
[`WEIL-POSITIVITY.md`](WEIL-POSITIVITY.md) · [`MARGIN-SCALING.md`](MARGIN-SCALING.md) ·
[`OMEGA-ROUTE.md`](OMEGA-ROUTE.md) · [`HANDOFF-M0P-5X5.md`](HANDOFF-M0P-5X5.md) ·
[`HANDOFF-M0P-6X6.md`](HANDOFF-M0P-6X6.md) ·
[`../../bridge-to-weil-positivity.md`](../../bridge-to-weil-positivity.md).

---

## 0. What M0′ is

For the Gaussian test basis

```text
φ_a(u) = exp(−(u−a)²/(2σ²)),      σ = 1/20,
```

the Weil quadratic form is `Q(f) = W(f * f̌)`, and the Gram matrix is

```text
G_{ab} = (W(a−b) + W(b−a))/2,
W(c)   = pole(c) + density(c) + prime(c).
```

`GaussianGram6.lean` shows `G` is positive definite from an entrywise bound
against a rational centre matrix:

```text
|G_ij − gramCentre6_ij| ≤ ε      and      6ε < 1/70      ⇒    G.PosDef.
```

The whole 6×6 problem is therefore: get every entry within `ε < 1/420 ≈
2.381·10⁻³` of its rational centre. The pole and prime terms were already
enclosed to `10⁻⁶` and `4·10⁻⁴`. Everything else is the density term.

---

## 1. What closed

| Rung | Theorem | Entry budget | Density bands from |
|---|---|---|---|
| 4×4 | `gaussianGram4_posDef` | `ε = 0.004` (`4ε = 0.016 < 0.0227`) | `DensityF0 … F3` |
| 5×5 | `gaussianGram5_posDef` | `ε = 0.0036` (`5ε = 0.018 < 1/50`) | `DensityF0 … F4` |
| 6×6 | `gaussianGram6_posDef` | `ε = 0.0015`, `6ε = 0.009 < 1/70` | `DensityF0 … F5` |

The vector-level forms are `gaussianGram6_quadraticForm_nonneg` (6×6) and the
lower-rung analogues. `lean/Closure6.lean` is the new closing step.

### 1.1 The six density bands

| `c` | certified `densityTerm c (1/20)` | interval used | entry error |
|---|---|---|---:|
| `0` | `[0.01071248, 0.01267937]` | `[0.010712, 0.012680]` | `1.010·10⁻³` |
| `1/5` | `[-0.04906938, -0.04710250]` | `[-0.049070, -0.047102]` | `1.010·10⁻³` |
| `2/5` | `[-0.02502135, -0.02305446]` | `[-0.025022, -0.023054]` | `1.001·10⁻³` |
| `3/5` | `[-0.01782558, -0.01585867]` | `[-0.017826, -0.015858]` | `1.002·10⁻³` |
| `4/5` | `[-0.01443704, -0.01210459]` | `[-0.014438, -0.012104]` | `1.361·10⁻³` |
| `1` | `[-0.01222353, -0.00989108]` | `[-0.012224, -0.009891]` | `1.249·10⁻³` |

`entry error` is the density half-width plus the pole band plus the prime band,
with the centre matrix rounded to eight decimals. The worst value `1.361·10⁻³`
sits below `ε = 1.5·10⁻³`, which sits well below `1/420`.  These bands are the
same 1878-panel partition rebuilt with `--lip-c 5/2` (§4.2); the previous `6/t`
chains gave `1.545–1.913·10⁻³`.

---

## 2. Why it was blocked, and what actually fixed it

The previous revision of this file recorded the obstruction as *width*: the 1305-panel chains certify `densityTerm` to
`±2.906·10⁻³`, above `1/420`, so finer partitions were needed, and the finer
partitions did not fit on disk.

Half of that diagnosis was wrong, and the wrong half was the expensive one.

### 2.1 The width story

Widths do need to fall: `2.906·10⁻³ → 1.91·10⁻³` is a factor `1.52` in
`densityTerm`, i.e. `1.52` in the number of panels at fixed method. The
"five chains at `h0 = 1/400`, `h1 = 1/60`" plan was `≈ 3940` panels per chain.

### 2.2 The size story (the real obstruction)

A 150-panel chunk produced a **300 MB** `.olean` — about 2 MB per panel. The
`c = 1` chain alone was 5 GB; six chains at 3940 panels would have been ~48 GB.
Disk was not "tight"; it was short by an order of magnitude. Two measurements
localised the cost:

* **`om` (the `Ω` bracket) was ~75% of every chunk.** The generated proof
  `norm_num [omegaLoS, …, Finset.sum_range_succ]` evaluates a 45-term rational
  series with huge denominators, and records every rational step.
* **the cumulative partial sums had growing denominators.** `cum<p>` carries
  the exact rational `T<p> = Σ R`, whose denominator grows with `p`, so
  `norm_num` re-normalises ever-larger literals: build time and `.olean` both
  grew superlinearly in the panel index.

### 2.3 The four fixes

1. **Share the `Ω` bracket across separations.** `om<p>` depends only on the
   partition, not on `c`. A dedicated module `DensitySO_0 …` proves
   `PrimeSpectrumTensor.SO.om<p>` once; every chain references it. This removes
   ~75% of the cost *five times over*.
2. **Round the cumulative partial sums** to 12 decimals at each panel
   (`panels.py --sum-dec`), absorbing the rounding with the new
   `PanelDecay.abs_sub_le_three`. Literal size stops growing; the chain step
   becomes `linarith [h, hd, tri, hS]` instead of `convert … <;> norm_num`.
   Cost in width: `≈ 2·10⁻⁹` per chain.
3. **An error-equalising partition.** The panel error is
   `E(h,a) ≈ |Ω(a)|h³/(4·wden) + (10⁻⁴ + lip·h/2)·h·sw`; `gen/optimise.py`
   solves the Lagrange problem and `gen/build_edges_opt.py` emits the edge list.
   At the same width this is ~15% fewer panels than a graded uniform grid, and
   at `h = 1/60` uniform it is ~2.3× fewer.
4. **`predict.py` first.** `gen/predict.py` reproduces the certified half-width
   of an emitted chain to ten digits *before* any Lean is generated, so a
   partition is chosen on numerics, not by building and measuring.

Result, measured: the shared `Ω` module is 12 chunks of 160 panels, ~1 min per
chunk and 1.4 GB of `.olean`.  Each density chain is 12 chunks of 2–6 min
(three chains in parallel on a 16 GB, 8-core machine); its size is 1.3 GB at
`c = 0` and 2.3 GB for the five cosine chains, because the `cos(c·m)`
brackets are a real second node cost.  The whole certificate layer — one shared
`Ω` module plus six chains, 72 chunks — is 14 GB, against 19 GB for the five
legacy 1305-panel chains alone (one of which, `c = 1`, was ~5 GB by itself).

### 2.4 What was deliberately not done

`panels.py --omega-norm-num` can be switched off, and `native_decide` decides
each bracket ~3× faster and ~3× smaller. **This was rejected.**
`native_decide` emits one *fresh axiom per call* in this toolchain
(`#print axioms` shows `…_native.native_decide.ax_1_1`), so the 6×6 closure
would have rested on ~10⁴ trusted-compiler evaluations instead of the kernel.
The audit is the point of the exercise; the module stays `norm_num`.

---

## 3. What this does and does not say

* It says: the exact `6×6` Gram matrix of six Gaussian test functions at
  `σ = 1/20`, centred at `0, 1/5, …, 1`, is positive definite, certified by
  rational intervals plus a rational `LDLᵀ` factorisation.
* It does **not** say the infinite Weil cone is positive. A finite Gram matrix
  is a shadow of that statement, and the shadow of a true statement can be
  positive without deciding the whole.
* It does **not** say anything about RH.
* A negative eigenvalue with a rigorous enclosure would refute the finite claim
  — as [`MARGIN-SCALING.md`](MARGIN-SCALING.md) shows, the fixed-spacing ladder
  gets thin fast, and `n = 9` is not far from where that could happen.

---

## 4. What is worth doing next

### 4.1 Adding a dimension: the `n = 7` rung (installed, one input open)

[`MARGIN-SCALING.md`](MARGIN-SCALING.md): at spacing `1/5`, `σ = 1/20`,
`λ_min` falls `2.271·10⁻² (n=4) → 1.671·10⁻² (n=6) → 1.244·10⁻² (n=7)
→ 9.743·10⁻³ (n=8) → 8.968·10⁻⁴ (n=9)`.

The rung is now installed end to end except for one rational band:

* **the density chain** `DensityG6` (`c = 6/5`, 780 panels, second-order rule,
  five chunks of 156, shared `DensitySO10`) is built and audit-clean, band
  `[-0.0052339, -0.0042685]` — `densityTerm` half-width `9.65·10⁻⁴`;
* **the exact matrix** `gaussianGram7`, the Toeplitz centre matrix `gramCentre7`
  (eight decimals), its rational `LDLᵀ` with margin `1/100` (min pivot
  `2.57·10⁻³`), and the entrywise transfer
  `gaussianGram7_posDef_of_entry_bound` are in
  [`lean/GaussianGram7.lean`](lean/GaussianGram7.lean);
* **the pole term at `6/5`** is enclosed (`poleTerm_mem_c6`,
  `[0.037264, 0.037267]`) in [`lean/PoleEnclosure.lean`](lean/PoleEnclosure.lean);
* **the assembly** [`lean/Assembly7.lean`](lean/Assembly7.lean) and the closure
  [`lean/Closure7.lean`](lean/Closure7.lean) reduce the whole `7 × 7` certificate
  to a single hypothesis `hq6` on the symmetrised prime band at `c = 6/5`, with
  `ε = 11/10000`, `7ε = 0.0077 < 1/100 = gramMargin7`;
* **the prime enclosure at `c = 6/5`** is now proved in
  [`lean/PrimeEnclosure7.lean`](lean/PrimeEnclosure7.lean) (19 theorems, no
  `sorry`): `primeTerm (6/5) ∈ [−0.042181, −0.042124]` and
  `primeTerm (−6/5) ∈ [−10⁻⁵, 0]`, giving
  `primeTerm_sym_mem_six_fifths : (primeTerm (6/5) + primeTerm (−6/5))/2 ∈
  [−0.0211, −0.02103]` — exactly `hq6`.  So `gaussianGram7_posDef` is
  **unconditional**.

With that, `Closure7` drops its hypothesis and `gaussianGram7_posDef` becomes
unconditional, at `ε = 11/10000` and margin `1/100`.

For `n = 8` the same lesson applied with less slack: `λ_min(8) = 9.743·10⁻³`,
so `8ε < 1/110 = 9.09·10⁻³` needs `ε < 1.136·10⁻³`, which the present
`ε = 1.1·10⁻³` meets with 3% to spare — and the `c = 7/5` chain was indeed built
on its own `c`-optimised partition (`gen/edges_1042_c75.txt`, 1042 panels),
coming out at `6.373·10⁻⁴`, i.e. *tighter* than the `c = 6/5` chain.  The `c²`
growth of the second-order constant means `n = 9` will
need a different strategy (per-`c` partitions of increasing fineness, or a
tighter weight bound) rather than a uniform ladder.

### 4.2 The sharper Lipschitz constant (done)

`|Ω′| ≤ 6/t` is now `|Ω′| ≤ 5/(2t)`, proved in
[`lean/LipSmall3.lean`](lean/LipSmall3.lean) as

```lean
theorem deriv_Omega_abs_le_five_halves {t : ℝ} (ht : 1 ≤ t) :
    |deriv IntersectionForm.Omega t| ≤ 5 / (2 * t)
```

with a clean audit, from `Σ_j ((j+1/4)²+a²)⁻¹ ≤ 5/(2a)` at `a = t/2`.  The true
constant is `sup_{a≥1/2} a·Σ = 2.148…` (at `a = 1/2`), so `5/2` is within 4% of
optimal for this route; the previous `6` was losable by 2.8×.

The proof splits at `a = 4`.  Above it, the existing head/tail estimate already
gives `(a+2)/a² + 1/a ≤ 5/(2a)`.  Below it, four explicit head terms plus the
telescoping tail `Σ_{j≥4} (j+4)⁻² ≤ 1/3` leave a rational inequality, which is
checked on 16 sub-intervals (the worst has an 8% margin).

**Effect, measured with `gen/predict.py`:**

| partition | `lip` | `K` |
|---|---|---:|
| 1878 (then current) | `6` | `7.636·10⁻⁴` |
| 1878 (same midpoints) | `5/2` | `4.917·10⁻⁴` |
| 1270 | `5/2` | `7.128·10⁻⁴` |

So the constant buys either **1.55× tighter bands at the same partition** or
**1.48× fewer panels at the same width**.  The gain is below the naive `2.4×`
because the midpoint term `|Ω|h³/(4·wden)` does not scale with the Lipschitz
constant, and it dominates once `h` grows.

That rebuild has been carried out: `DensityF0 … F5` are the same 1878-panel
partition with `--lip-c 5/2` (reusing `DensitySO_11`, so no new `Ω` module),
and the `6×6` entry error is now `1.001–1.361·10⁻³` with `ε = 1.5·10⁻³`
(§1.1).  The superseded `DensityE*` chains were removed.

### 4.3 The remaining real options, in order of value per week

(1) and (2) are closed; (3) is what is left of this list.

1. ~~**A sharper Lipschitz constant for `Ω`.**~~ Done — see §4.2.
2. ~~**A second-order panel rule.**~~ Done — see §4.4. The remaining error
   after (1) was `|Ω(a)|h³/(4·wden)`, the midpoint-rule remainder, which needs
   `|(wΩ)″|`, hence `|Ω″|`. Both are now proved, and the per-panel error is
   `h³` instead of `h²` on every committed chain.
3. **A sub-cone theorem — started, see [`SUB-CONE.md`](SUB-CONE.md).** The only
   route that touches the infinite form: positivity on a structured closed
   subspace of Gaussian Hilbert space rather than on more and more basis
   elements. A genuine research step, and it has now been taken as far as the
   structure allows: the first obstruction is *proved*
   ([`lean/SubCone.lean`](lean/SubCone.lean), T24) — the pole term is exactly
   rank two, `Σ x_a x_b poleTerm(c_a−c_b) = 4πσ²e^{σ²/4}·u·v`, and unbounded in
   the separation, so no decay, Hilbert–Schmidt or diagonal-dominance argument
   can touch the Weil Gram matrix. The numerics then show why the programme
   survives anyway: the prime term cancels the pole to about one part in `10²`,
   so the entries stay `O(10⁻²)` and the residual is the zeros' contribution.
   The natural pole-free subspace is codimension two (`{u = 0} ∩ {v = 0}`), but
   annihilating the pole exactly does **not** save the margin: on the natural
   ladder `λ_min` still collapses (`1.67·10⁻²` at `n = 6` to `1.44·10⁻⁸` at
   `n = 34`, §5.1). The density form is not positive definite there in any case
   (symbol negative on `(0, 6.2898)`), and a real-frequency band-pass cannot
   control the pole at all, because the pole reads `f̂(±i/2)` (§5.2) — so the
   surviving candidate must impose both conditions. **No sub-cone theorem is
   proved**; §4–§5 of the note state the corrected target and the two
   falsifications.
   The cheap positivity oracle the argument wants — the `6×6` certificate at
   `ε = 8·10⁻⁴` with a clean audit — now exists.

**Stop-and-benchmark — done, see [`CALIBRATION.md`](CALIBRATION.md).**  A closed
ladder to `n = 6` with a clean audit is a good calibration target for any claimed
positivity bridge, and the [`ZERO-SIDE-BRIDGE.md`](ZERO-SIDE-BRIDGE.md) numerical
match now has a certificate to be compared against.  The target fixes:

* the certified ladder `n = 4, 5, 6, 7`, all unconditional, with each rung's
  `ε`, margin, budget and audit status;
* the **witness vectors** — the minimising eigenvector of each Gram matrix, a
  rational unit vector — with their numerical Rayleigh quotients and the
  certified windows `xᵀCx ± ε(Σ|x_i|)²` (`±4.2·10⁻³` at `n = 4` down to
  `±6.3·10⁻³` at `n = 7`), which is the sharpest finite test a bridge can face;
* the zero-side table of `ZERO-SIDE-BRIDGE.md` §3, to be reproduced alongside the
  arithmetic side;
* four acceptance criteria (entries, margins, witnesses, audit hygiene) and the
  statement of what the target is *not*.

It is executable: `python3 lean/gen/calibrate.py --check` reproduces the table
from the kernel and exits non-zero on a mismatch, and
`tests/test_programme.py::test_calibration_table_is_internally_consistent`
guards the budgets and halfwidths in the suite.

---


### 4.4 The second-order panel rule (done)

The `h²` term of the first-order rule was the variation of `Ω` across a panel,
bounded only through `|Ω′| ≤ lip`.  The second-order rule drops it by applying
`midpoint_rule_bound` to the *product* `w·Ω`:

* [`lean/SecondDeriv.lean`](lean/SecondDeriv.lean) proves `|Ω″(t)| ≤ 5/t²` for
  `t ≥ 1`.  The route is the same polygamma series as for `Ω′`, at `k = 2`:
  `ψ″ = −2Σ(z+j)⁻³`, so `‖ψ″‖ ≤ 2Σ‖z+j‖⁻³ ≤ (2/t)·Σ((j+1/4)²+(t/2)²)⁻¹ ≤
  20/t²`, and `(d/dt)²Ψ = (i/2)²ψ″ = −ψ″/4` gives `|Ω″| ≤ 5/t²`.  It also
  proves `deriv Ω` is differentiable (needed by the quadrature lemma).
* [`lean/WeightDeriv2.lean`](lean/WeightDeriv2.lean) proves the *panel-local,
  decaying* weight bounds
  `|w′| ≤ (1/400)(|t|/200+|c|)` and
  `|w″(t)| ≤ (1/400)e^{−a²/400}(1/200 + b²/40000 + c² + 2(b/200)|c|)`
  on `0 ≤ a ≤ t ≤ b`.  The global `|w″| ≤ 1/400` is four orders of magnitude
  too large at `t = 60`, and it dominates the second-order constant.
* [`lean/PanelSecondOrder.lean`](lean/PanelSecondOrder.lean) proves
  `(wΩ)″ = w″Ω + 2w′Ω′ + wΩ″`, the panel bound
  `|(wΩ)″| ≤ W₂·|Ω| + 2W₁L + W·|Ω″|`, and

  ```lean
  theorem panel_certificate_second_order … :
      |∫ wΩ − h·w(m)Ω(m)| ≤ B·h³/4
  ```

All audit-clean (`[propext, Classical.choice, Quot.sound]`).

**Predicted effect** (`gen/predict.py --order 2`).  The model reproduces the
certified first-order widths exactly, so these are credible numbers, not yet a
built chain:

| panels | `h²` rule (`5/(2t)`) | `h³` rule, `|w″| ≤ 1/400` | `h³` rule, decaying `|w″|` |
|---|---:|---:|---:|
| 388 | — | — | `K = 2.34·10⁻⁴` |
| 617 | — | — | `K = 1.36·10⁻⁴` |
| 814 | — | `K = 5.68·10⁻⁴` | `K = 1.20·10⁻⁴` |
| 1270 | `K = 7.13·10⁻⁴` | `K = 2.83·10⁻⁴` | `K = 1.08·10⁻⁴` |

So at equal width the panel count falls from 1270 to a few hundred, and at
equal panel count the band shrinks by 2.5–6×.

The floor is the tail.  `DensityTail.lean` now also proves the tail at any
split point `T ≥ 60` — the Gaussian moment integrates exactly, so

```lean
theorem density_tail_le_of {T : ℝ} (hT : 60 ≤ T) :
    |∫ x in Set.Ioi T, w x * Ω x| ≤ Real.exp (-(T ^ 2 / 400)) / 2
```

and `density_tail_le_eighty` instantiates it at `T = 80` with the explicit
bound `10⁻⁷` (against `e^{−9}/2 ≈ 6.2·10⁻⁵` at `60`).  Moving `T` is free under
the second-order rule: the first-order weight bounds carry a `b ≤ 60`
hypothesis, while `WeightDeriv2` has none.

Combining the two:

| panels | `h²`, `T=60` (first-order) | `h³`, `T=60` | `h³`, `T=80` |
|---|---:|---:|---:|
| 267 | — | — | `K = 5.30·10⁻⁴` |
| 388 | — | `K = 2.34·10⁻⁴` | — |
| 814 | — | `K = 1.20·10⁻⁴` | `K = 1.99·10⁻⁵` |
| 1270 | `K = 7.13·10⁻⁴` | `K = 1.08·10⁻⁴` | — |

So even 267 panels beat the 1270-panel first-order certificate outright (4.8×
fewer panels, 1.3× tighter), and 814 panels give `K = 2·10⁻⁵`, 36× tighter.
These are model predictions; the emitted chains (§4.4, final table) came in
tighter than the model at the same partition.

What is left in the tail is the `|Ω| ≤ log(t+2) + 24` constant: the true
`|Ω(60)|` is about `2.2`, so a sharper large-`t` bound would divide the tail by
another ~10.  It is no longer the floor.

**The wiring is done, and a chain is built.**  `panels.py --order 2` emits the
second-order `hp` proofs (`panel_second_order_certificate` with the six panel
bounds `W, W₁, W₂, Om, L, S`, the two rational budget checks and the midpoint
rationalisations), takes the split point from the edge list, and uses
`density_tail_le_of` with `10^{−tail-dec}`; `--lip-c 5/2` selects the sharper
Lipschitz bound throughout; `EXP_TERMS` was raised to 14 because the left-edge
`exp(−a²/400)` brackets at `a ≈ 80` exceed the 10-term remainder.

The first attempt used a 318-panel partition.  `DensityG0` there was built and
audit-clean at `K = 5.803·10⁻⁴` (`densityTerm` half-width `1.161·10⁻³`), i.e.
5.9× fewer panels than the committed 1878-panel first-order chain for an 18%
wider band — the panel count, not the width, is what collapses.

**But that partition does not close the 6×6.**  The second-order
constant is `W₂·|Ω|` with

```
W₂ = (1/400)·e^{−a²/400}·(1/200 + b²/40000 + c² + 2(b/200)|c|),
```

so it grows like `c²`: at `c = 3/5` the emitted band is `5.26·10⁻³` wide, five
times the first-order chain's.  The `h³` rule is *not* uniformly better — it
wins where `h` is small, and for large `c` the panel count must be larger before
it beats `h²`.  Measured (`gen/predict.py --order 2`, `T = 80`):

| panels | `c = 0` | `c = 3/5` | `c = 1` |
|---|---:|---:|---:|
| 318 | `2.83·10⁻⁴` | `5.26·10⁻³` | — |
| 612 | `3.50·10⁻⁴` | `8.97·10⁻⁴` | `1.43·10⁻³` |
| **779** | `2.83·10⁻⁴` | `5.74·10⁻⁴` | `8.55·10⁻⁴` |

The migration therefore uses **779 panels** (`gen/edges_779.txt`), and it is
**done**.  The six chains `DensityG0 … DensityG5` (five chunks each, shared
`DensitySO9` module) are built and audit-clean, the 6×6 is re-closed against
their bands, and the `DensityF*` chains and both superseded `Omega` modules are
deleted.

| `c` | `densityTerm` band | half-width | entry deviation |
|---|---|---:|---:|
| `0` | `[0.011615, 0.011789]` | `8.63·10⁻⁵` | `1.067·10⁻⁴` |
| `1/5` | `[-0.048244, -0.047917]` | `1.63·10⁻⁴` | `1.838·10⁻⁴` |
| `2/5` | `[-0.024294, -0.023773]` | `2.61·10⁻⁴` | `2.728·10⁻⁴` |
| `3/5` | `[-0.017213, -0.016464]` | `3.74·10⁻⁴` | `3.887·10⁻⁴` |
| `4/5` | `[-0.013775, -0.012762]` | `5.06·10⁻⁴` | `6.976·10⁻⁴` |
| `1` | `[-0.011711, -0.010400]` | `6.55·10⁻⁴` | `7.356·10⁻⁴` |

`ε = 8/10000` (was `15/10000`), `6ε = 0.0048 < 1/70`, `gramMargin6` still
clears.  So the migration buys **2.4× fewer panels** (779 vs 1878, 30 chunks
vs 72, 8.0 GB vs 14.4 GB including the shared `Omega` module) **and** a 1.9× tighter entry bound — the first time
both have moved the same way.

---

## 5. Exact commands

```bash
cd the-final-letter/topics/prime-spectrum-tensor

# numerical suite (26 tests)
python3 -m pytest -q tests

# hand-written Lean core (skips the ~80 generated chunk files)
./lean/check.sh --quick

# the closures
./lean/check.sh Closure6.lean DensityCertificates.lean DensityCertificates5.lean

# the audit
./lean/check.sh Audit.lean

# regenerate one compact chain from scratch (resumable)
cd lean/gen
python3 predict.py --c 0 --edges edges_1878.txt          # first-order band, no Lean
python3 predict.py --c 0 --edges edges_1878.txt --order 2  # second-order prediction
bash build_omega.sh "$(pwd)/edges_1878.txt" 20 160       # shared Omega module
OMEGA_NS=SO OMEGA_IMPORT=DensitySO_11 bash build_compact.sh 0 0 "$(pwd)/edges_1878.txt" 400
```

---

## 6. File map

| File | Role |
|---|---|
| [`lean/Topic.lean`](lean/Topic.lean) | base definitions, finite algebra |
| [`lean/Transfer.lean`](lean/Transfer.lean) | entrywise-to-`PosDef`, rational `LDLᵀ` |
| [`lean/GaussianGram.lean`](lean/GaussianGram.lean) | `poleTerm`, `densityTerm`, `primeTerm`, 4×4 assembly |
| [`lean/GaussianGram5.lean`](lean/GaussianGram5.lean) | 5×5 transfer |
| [`lean/GaussianGram6.lean`](lean/GaussianGram6.lean) | 6×6 transfer, `gramCentre6`, margin `1/70` |
| [`lean/Assembly6.lean`](lean/Assembly6.lean) | 6×6 assembly at `ε = 2·10⁻³` |
| [`lean/DensityBands6.lean`](lean/DensityBands6.lean) | the six certified `densityTerm` bands |
| [`lean/Closure6.lean`](lean/Closure6.lean) | `gaussianGram6_posDef`, unconditional |
| [`lean/Audit.lean`](lean/Audit.lean) | `#print axioms` for the three rungs |
| [`lean/PanelDecay.lean`](lean/PanelDecay.lean) | panel certificate, `panel_step`, `abs_sub_le_three` |
| [`lean/DensitySO_0 …`](lean/) | shared, chain-independent `Ω` brackets |
| [`lean/DensityF0_0 … F5_11`](lean/) | the six compact density chains (`|Ω′| ≤ 5/(2t)`) |
| [`lean/LipSmall3.lean`](lean/LipSmall3.lean) | the `5/(2t)` Lipschitz bound (T18) |
| [`lean/SecondDeriv.lean`](lean/SecondDeriv.lean) | `|Ω″| ≤ 5/t²` (T19) |
| [`lean/WeightDeriv2.lean`](lean/WeightDeriv2.lean) | panel-local decaying `|w′|, |w″|` bounds |
| [`lean/PanelSecondOrder.lean`](lean/PanelSecondOrder.lean) | the `h³` panel certificate (T20) |
| [`lean/SubCone.lean`](lean/SubCone.lean) | the pole rank-two identity and unboundedness (T24) |
| [`SUB-CONE.md`](SUB-CONE.md) | the sub-cone analysis (§4.3(3)) |
| [`CALIBRATION.md`](CALIBRATION.md) | the benchmark target for a positivity bridge |
| [`../zero-side-bridge/`](../zero-side-bridge/README.md) | the programme home for the zero-side bridge (§4 of `ZERO-SIDE-BRIDGE.md`) |
| `lean/DensityC0_0 … C4_8` | legacy 1305-panel chains — removed 2026-11-15 (recoverable from git history) |
| [`lean/gen/README.md`](lean/gen/README.md) | generator guide, cost model, reproductions |
| [`HANDOFF-M0P-6X6.md`](HANDOFF-M0P-6X6.md) | the route record up to this closure |
| [`MARGIN-SCALING.md`](MARGIN-SCALING.md) | why the fixed-spacing ladder stalls |
| [`OMEGA-ROUTE.md`](OMEGA-ROUTE.md) | the `Ω`/density assembly route |

---

## 7. What not to claim

- Do not call the 6×6 a proof of Weil positivity, of a sub-cone theorem, or of RH.
- Do not describe the numerical eigenvalues as the certificate; the certificate
  is the rational bands plus the transfer.
- Do not reintroduce `native_decide` into the certificate path without saying
  that it adds a trusted-compiler axiom per call.
- Do not quote a wider entry budget than the bands support: `ε = 2·10⁻³` is the
  `6×6` figure, and `6ε < 1/70` is checked, not asserted.

The ladder now closes at `n = 8` as well: `gaussianGram8_posDef` in
[`lean/Closure8.lean`](lean/Closure8.lean), margin `1/110`, `ε = 11/10000`,
`8ε = 0.0088 < 0.00909 = 1/110 < λ_min(gramCentre8) = 0.009743`.  The only new
separation is `c = 7/5`, certified by the 1042-panel chain `DensityG7`
(`densityTerm` half-width `6.373·10⁻⁴`) and the prime band
`primeTerm (7/5) ∈ [−0.06192, −0.06185]` of
[`lean/PrimeEnclosure8.lean`](lean/PrimeEnclosure8.lean).  `n = 9` would need
`ε < 9.96·10⁻⁵` against `λ_min = 8.968·10⁻⁴` and roughly ten times the panel
count; it does not fit on a 16 GB machine.
