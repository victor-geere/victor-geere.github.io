# `gen/` — the density certificate generator

`panels.py` emits a Lean file that produces

```lean
IntersectionForm.density (1/20) c ∈ Set.Icc LO HI
```

with explicit rationals `LO, HI`, for one value of `c`.

Two generations of certificate are in the repository:

| generation | files | partition | use |
|---|---|---|---|
| **compact** | `DensityG0_0 … DensityG5_4` | 779 panels to `T = 80`, second-order `h³` rule, `|Ω′| ≤ 5/(2t)` | current |
| **shared Ω** | `DensitySO_0 … DensitySO_11` | same partition | the `om<p>` brackets, once |
| **superseded** | `DensityE0_0 … DensityE5_11` | same partition, `6/t` | removed 2026-11-16 (recoverable from git history) |
| **legacy** | `DensityC0_0 … DensityC4_8` | 1305 panels, graded uniform | removed 2026-11-15 (~19 GB of `.olean`; recoverable from git history) |

The compact generation is what the closed rungs now rest on.  It differs from
the legacy one in four ways, each of which addresses a measured cost:

1. **`native_decide` for the `Ω` bracket.**  The rational bracket
   `qlo ≤ omegaLoS … ∧ omegaHiS … ≤ qhi` is decided natively instead of by
   `norm_num` over a 45-term rational series.  This was ~75% of the `.olean`
   of each chunk: 12.9 MB → 3.9 MB for six panels.  `native_decide` is a
   *decision procedure*, not an escape hatch — a bracket tightened by `10⁻⁶`
   is rejected (checked).
2. **An error-equalising partition.**  The panel error is
   `E(h,a) ≈ |Ω(a)|h³/(4·wden) + (10⁻⁴ + lip·h/2)·h·sw`, so the optimal `h(a)`
   solves a Lagrange problem; `optimise.py` solves it and `build_edges_opt.py`
   emits an edge list on a `1/1000` grid.  `predict.py` reproduces the
   certified half-width of every committed chain to ten digits, which is how a
   partition is chosen before any Lean is emitted.
3. **Rounded cumulative partial sums.**  The exact rational partial sums have
   denominators that grow with the panel count, and `norm_num` on those
   literals dominated both build time and `.olean` size.  `panels.py --sum-dec`
   rounds `T` and `S` to 12 decimals at each panel and absorbs the rounding via
   `PanelDecay.abs_sub_le_three`.  Cost: `10⁻¹²` per panel, `≈ 2·10⁻⁹` per chain.
4. **Smaller chunks (160 panels).**  Unchanged in spirit from the legacy 150.

## Usage

```bash
cd the-final-letter/topics/prime-spectrum-tensor/lean/gen

# 1. choose a partition and check the predicted width
python3 build_edges_opt.py --lam 1e-6 --t1 80 --out edges_779.txt
python3 predict.py --c 0 --edges edges_779.txt --order 2
python3 predict.py --c 4/5 --edges edges_779.txt --order 2

# 2. emit + build one chain (resumable, sequential within a chain)
OMEGA_NS=SO OMEGA_IMPORT=DensitySO_11 CHUNK=160 \
  bash build_compact.sh 0 0 "$(pwd)/edges_779.txt" 400 --order 2 --tail-dec 7
OMEGA_NS=SO OMEGA_IMPORT=DensitySO_11 CHUNK=160 \
  bash build_compact.sh 1 1/5 "$(pwd)/edges_779.txt" 400 --order 2 --tail-dec 7
OMEGA_NS=SO OMEGA_IMPORT=DensitySO_11 CHUNK=160 \
  bash build_compact.sh 4 4/5 "$(pwd)/edges_779.txt" 200 --order 2 --tail-dec 7
OMEGA_NS=SO OMEGA_IMPORT=DensitySO_11 CHUNK=160 \
  bash build_compact.sh 5 1 "$(pwd)/edges_779.txt" 200 --one --order 2 --tail-dec 7

# 3. read the certified bands back out and check the 6×6 entry budget
python3 extract_bands.py
```

`build_compact.sh` takes `OMEGA_NS=SO` (emit `--share-omega SO`) and
`OMEGA_IMPORT=DensitySO_11` (import the shared module); forgetting the first is
how a chain ends up carrying its own `native_decide` brackets.  Chain `i` lives
in namespace `PrimeSpectrumTensor.E<i>`, writes
`Density<TAG><i>_<j>.lean` (namespace `PrimeSpectrumTensor.<TAG><i>`) and its last chunk
emits `density_mem_c<i>`.  `TAG` defaults to `F` (the `5/(2t)` generation).  Measured
on the reference machine (16 GB, 8 cores): ~1 min per 160-panel `Ω` chunk, and
2–6 min per density chunk with three chains in parallel.  Three in parallel is
the practical limit — a fourth drives the machine into swap and everything
slows down.  Sizes: shared `Ω` module 1.4 GB; a chain 1.1 GB at `c = 0` and
2.2–2.3 GB for the cosine chains (`cos(c·m)` is a second node bracket).  The
whole certificate layer is 14 GB.

`panels.py --h0/--h1` still gives a graded uniform partition, which is the
legacy shape; `emit_all.py` / `build_chunks.sh` are kept for it but the emitted
`DensityC*` files are no longer in the tree.  Do not mix partitions within one
chain: the shared `Ω` module is tied to the edge list.

## The Lipschitz constant

The panel error is linear in the bound on `|Ω′|`.  Two proofs are available:

| file | theorem | bound | note |
|---|---|---|---|
| `LipSmall2.lean` | `deriv_Omega_abs_le_six` | `6/t` | `Σ ≤ 6/a`, head/tail split |
| `LipSmall3.lean` | `deriv_Omega_abs_le_five_halves` | `5/(2t)` | `Σ ≤ 5/(2a)`, four head terms + 16-interval rational check |

`panels.py --lip-c 6` (default) or `--lip-c 5/2` selects which is used in the
emitted `hp` proofs, and `predict.py --lip-c` uses the same coefficient in the
cost model, so the partition and the emitted proof always agree.  Measured
effect on `c = 0`:

| panels | `lip = 6` | `lip = 5/2` |
|---|---:|---:|
| 1270 | — | `K = 7.13·10⁻⁴` |
| 1676 | `K = 8.52·10⁻⁴` | — |
| 1878 | `K = 7.64·10⁻⁴` | `K = 4.92·10⁻⁴` |

The gain is 1.5×, not the naive 6/2.5 = 2.4×, because the midpoint term
`|Ω|h³/(4·wden)` does not scale with the Lipschitz constant.

## Panel-rule order

`panels.py --order 2` emits the second-order `hp` proofs, takes the split point
from the last edge (`T = 80` for `edges_318.txt`) and bounds the tail by
`10^-tail-dec` via `density_tail_le_of`.  `--lip-c 5/2` picks the sharper
Lipschitz bound; `EXP_TERMS` is 14 so that the left-edge `exp(-a^2/400)`
brackets at `a ~ 80` still close.

A complete example (the committed `DensityG*` chains, 779 panels, five chunks each):

```bash
OTAG=SO9 bash build_omega.sh "$(pwd)/edges_779.txt" 20 160
TAG=G OMEGA_NS=SO9 OMEGA_IMPORT=DensitySO9_4 CHUNK=160 \
  bash build_compact.sh 0 0 "$(pwd)/edges_779.txt" 400 --lip-c 5/2 --order 2 --tail-dec 7
# ... c = 1/5, 2/5, 3/5, 4/5 (last two with wden 200), 1 (wden 200 --one)
```

`build_edges_c.py` builds a partition for the *second-order* error model at a
given `c` (the Lagrangian solution `h = (4λ/(3B(a,b,c)))^{1/3}`).  Use it for any
separation well above `c = 0`, where the `c²` growth of the second-order constant
makes a `c = 0`-optimised partition wasteful:

```bash
python3 build_edges_c.py --lam 1e-6 --c 6/5 --out edges_780_c6.txt
```

**Choose the partition for the worst separation.**  The second-order constant is
`W₂·|Ω|` with `W₂ ∝ c²`, so at 318 panels `c = 3/5` comes out five times wider
than the first-order chain.  779 panels is where every separation lands at or
below the first-order width, and `ε` improves from `15·10⁻⁴` to `8·10⁻⁴`.

`predict.py --order 2` models the *second-order* panel rule
(`PanelSecondOrder.panel_certificate_second_order`), in which the per-panel
error is `B·h³/4` with `B` a bound on `|(wΩ)″|` instead of the first-order
`h²` estimate.  `--order 1` (the default) is the committed rule.  Predicted
widths on the `c = 0` chain:

| panels | order 1 | order 2 (`|w″| ≤ 1/400`) | order 2 (decaying `|w″|`) |
|---|---:|---:|---:|
| 388 | — | — | `K = 2.34·10⁻⁴` |
| 814 | — | `K = 5.68·10⁻⁴` | `K = 1.20·10⁻⁴` |
| 1270 | `K = 7.13·10⁻⁴` | `K = 2.83·10⁻⁴` | `K = 1.08·10⁻⁴` |

The ``decaying'' column uses `WeightDeriv2.abs_deriv2_weight_le_div`; the floor
of about `10⁻⁴` is the tail bound `density_tail_le` at `T = 60`, not the
quadrature.

## What it emits

### Per node

* `exp_n<p>_mem` — `exp(−y)` with `y = m²/400`, via `(exp(−y/16))^16`, a
  10-term `Real.exp_bound` and a four-step squaring chain.  The final bracket
  is rounded outward to 15 decimals so that all downstream arithmetic stays
  small.
* `cos_n<p>_mem` (skipped for `c = 0`) — `cos(c·m)` by `CosBound.cos_bound_small`
  at `c·m/2^d`, where `d = ⌈log₂|c·m|⌉` is the number of doublings needed to
  bring the argument into `[−1,1]`, followed by `d` applications of the
  sign-specific doubling lemmas `cos_double_mem_pos/_neg/_mixed`
  (`CosBound.lean`).  These avoid `if`/`max` in the numeric goals.
* `w<p>_mem` — `|weight c m − w0| ≤ eps`, with `w0, eps` rational, obtained
  from the two brackets by the additive error identity
  `E·C − e₀·c₀ = (E−e₀)·C + e₀·(C−c₀)` and `|cos| ≤ 1`.

### Per panel `[a,b]`

* `om<p>` — `qlo ≤ Ω(m) ≤ qhi` at the midpoint, by
  `IntersectionForm.omega_mem_scaled` (`OmegaScaled.lean`): the digamma
  expansion with `N = 4` shift and a **scaled** log `log q = log(q/4^j) + j log 4`,
  so `M = 45` series terms suffice even at `t = 60`.  This is the decisive
  speed-up: the unscaled `omega_mem` needs `M ≈ 1500` at `t = 60`.  The
  rational bracket is closed by `native_decide` (pass `--omega-norm-num` for
  the old `norm_num` proof).
* `hp<p>` — the panel certificate `panel_certificate_decay` (`PanelDecay.lean`),
  which uses the panel-local rational weight bound `(1/400)/(1+a²/400)` of
  `WeightDecay.abs_weight_le_div`, plus `panel_glue` to fold in the node
  bracket.  The Lipschitz constant is `6/a` for `a ≥ 1`
  (`LipSmall2.deriv_Omega_abs_le_six`) and `10` on `[0,1]`
  (`LipSmall.deriv_Omega_abs_le_ten`).

### Assembly

The panels are glued **linearly** by cumulative lemmas

```lean
theorem cum<p> : |(∫ x in 0..e<p+1>, w x * Omega x) - T<p>| ≤ S<p>
```

with `cum0 := hp0` and `cum<p> := panel_step cum<p−1> hp<p>` (`PanelDecay.panel_step`),
where `T<p>, S<p>` are the rounded rational partial sums computed in Python.
The step is

```lean
have h := panel_step … cum<p−1> hp<p>     — |∫ − (T<prev> + R)| ≤ S<prev> + E
have hd : |(T<prev> + R) − T<p>| ≤ 10⁻¹²    — the rounding
have hS : S<prev> + E + 10⁻¹² ≤ S<p>
linarith [h, hd, abs_sub_le_three _ _ _, hS]
```

This replaced an earlier `PanelChain` inductive: its `norm_num` evaluation was
superlinear (a 38-panel file took six minutes), whereas the cumulative form is
linear.  (`PanelChain` is kept in `PanelDecay.lean` but is no longer emitted.)

The last step splits `density` at `60` and applies `density_tail_le`.

## Status

**Closed (4×4, 5×5, 6×6).**  The six compact chains `DensityG0 … DensityG5`
compile; [`DensityCertificates.lean`](../DensityCertificates.lean),
[`DensityCertificates5.lean`](../DensityCertificates5.lean) and
[`DensityBands6.lean`](../DensityBands6.lean) read off the `densityTerm` bands,
and

```lean
theorem gaussianGram4_posDef : (gaussianGram4 (1/20)).PosDef
theorem gaussianGram5_posDef : (gaussianGram5 (1/20)).PosDef
theorem gaussianGram6_posDef : (gaussianGram6 (1/20)).PosDef
```

all close with no hypotheses.  `./check.sh Audit.lean` prints the axiom
dependencies.

Certified half-widths of `IntersectionForm.density` (`K = Σ E_p + 10⁻⁴`), with
`|Ω′| ≤ 5/(2t)`:

| `c` | panels | `K` | entry error |
|---|---:|---:|---:|
| `0, 1/5, 2/5, 3/5` | 779 | `8.6·10⁻⁵ – 3.3·10⁻⁴` | `1.07–3.89·10⁻⁴` |
| `4/5`, `1` | 779 | `5.1·10⁻⁴`, `6.6·10⁻⁴` | `6.98·10⁻⁴`, `7.36·10⁻⁴` |

(The superseded first-order chains had `DensityTerm` half-widths of
`9.83·10⁻⁴` (`c = 0`) to `1.53·10⁻³` (`c = 4/5`) at 1878 panels, and
`ε = 15·10⁻⁴`.)
| `1` | 1878 | `5.831·10⁻⁴` | `1.25·10⁻³` |

"entry error" is `2K` plus the pole and prime bands: the `6×6` transfer uses
`ε = 1.5·10⁻³` with `6ε = 0.009 < 1/70`.  The legacy 1305-panel chains gave
`2K = 2.91·10⁻³`, which exceeded `1/420 = 2.38·10⁻³`; that — not the algebra —
is why the `6×6` rung was open.  With `5/(2t)` the same partition gives
`2K ≤ 1.17·10⁻³`, which also fits the `n = 7` budget `ε < 1.777·10⁻³`.
