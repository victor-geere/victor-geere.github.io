# `gen/` — the density certificate generator

`panels.py` emits a Lean file that produces

```lean
IntersectionForm.density (1/20) c ∈ Set.Icc LO HI
```

with explicit rationals `LO, HI`, for one value of `c`.

## Usage

The committed certificates are **chunked**: each `c` is split into nine files
of 150 panels (`DensityC0_0.lean` … `DensityC0_8.lean`), because a single
file with all 1305 panels peaks at ~25 GB of memory and is killed on a 16 GB
machine.  `emit_all.py` drives the whole emission:

```bash
python3 emit_all.py --size 150      # emit the 36 chunk files
./build_chunks.sh 0 1 2 3           # compile them, skipping up-to-date chunks
```

`build_chunks.sh` is resumable: it skips any chunk whose `.olean` is newer than
its `.lean` and newer than its predecessor's `.olean`, so an interrupted build
can simply be restarted.  To check only the hand-written Lean core, use
`../check.sh --quick`, which skips the 36 generated chunks.

The chunks of one `c` share the namespace `PrimeSpectrumTensor.D<i>` and each
imports its predecessor, so the cumulative enclosure `cum{p}` continues across
files.  `DensityCertificates.lean` imports only the last chunk of each `c`
(`DensityC0_8.lean` … `DensityC3_8.lean`).

To emit a single file (small runs, or a different partition):

```bash
cd the-final-letter/topics/prime-spectrum-tensor/lean/gen
python3 panels.py --c 0   --h0 1/125 --h1 1/20 --out SingleC0.lean --name density_mem_c0 --ns D0
python3 panels.py --c 1/5 --h0 1/125 --h1 1/20 --out SingleC1.lean --name density_mem_c1 --ns D1
python3 panels.py --c 2/5 --h0 1/125 --h1 1/20 --out SingleC2.lean --name density_mem_c2 --ns D2
python3 panels.py --c 3/5 --h0 1/125 --h1 1/20 --out SingleC3.lean --name density_mem_c3 --ns D3
```

Each `c` lives in namespace `PrimeSpectrumTensor.D<i>` (the `--ns` option), so
the four can be imported together.  The defaults are exactly the parameters of
the committed certificates:
125 panels of width `1/125` on `[0,1]`, then 1180 panels of width `1/20` on
`[1,60]` (`P = 1305`).  Requires `mpmath`, used **only** to choose the
outward-rounded `Ω` brackets; every number that enters the Lean file is
recomputed exactly with `fractions.Fraction`, and the choice of bracket is
verified in Lean by `native_decide`.

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

* `om<p>_lo`, `om<p>_hi` — `qlo ≤ Ω(m) ≤ qhi` at the midpoint, by
  `IntersectionForm.omega_mem_scaled` (`OmegaScaled.lean`): the digamma
  expansion with `N = 4` shift and a **scaled** log `log q = log(q/4^j) + j log 4`,
  so `M = 45` series terms suffice even at `t = 60`.  This is the decisive
  speed-up: the unscaled `omega_mem` needs `M ≈ 1500` at `t = 60`.
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
where `T<p>, S<p>` are the exact rational partial sums computed in Python.
This replaced an earlier `PanelChain` inductive: its `norm_num` evaluation was
superlinear (a 38-panel file took six minutes), whereas the cumulative form is
linear.  (`PanelChain` is kept in `PanelDecay.lean` but is no longer emitted.)

The last step splits `density` at `60` and applies `density_tail_le`.

## Status

**Closed.**  The four chunked chains `DensityC0_0 … DensityC3_8` compile, and
[`DensityCertificates.lean`](../DensityCertificates.lean) feeds the four
resulting `densityTerm` bands to
`gaussianGram4_posDef_of_density_enclosure_loose`, proving

```lean
theorem gaussianGram4_posDef : (gaussianGram4 (1/20)).PosDef
```

The numeric budgets are: per-panel error `K = Σ E_p + 10⁻⁴ ≈ 1.45·10⁻³`,
against the `1.75·10⁻³` slack left by the transfer's `0.005675` entry budget
(the margin is `≈ 3·10⁻⁴`).  The dominant terms are the `Ω`-variation
`Σ (6/t)·h²/800 ≈ 0.012 h` on `[1,60]` and the midpoint-rule remainder
`Σ |Ω(m)|·h³/1600 ≈ 10⁻⁴`.
