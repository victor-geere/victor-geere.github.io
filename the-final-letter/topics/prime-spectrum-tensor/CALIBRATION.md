# The calibration target

**Status:** benchmark document.  It introduces no new mathematics.  It fixes the
numbers that a claimed positivity bridge must reproduce, so that the finite
ladder and [`ZERO-SIDE-BRIDGE.md`](ZERO-SIDE-BRIDGE.md) can be used as a
calibration standard rather than as separate arguments.

**Parent dossier:** [`README.md`](README.md) · **Kernel:**
[`WEIL-GRAM.md`](WEIL-GRAM.md) §2 · **Zero side:**
[`ZERO-SIDE-BRIDGE.md`](ZERO-SIDE-BRIDGE.md) §3 · **Ladder:**
[`HANDOFF-M0P-NEXT.md`](HANDOFF-M0P-NEXT.md) §4.1

Reproduce the tables with `python3 lean/gen/calibrate.py` (add `--check` to
verify against the recorded values).

## 1. The object

Everything below is at `σ = 1/20` with centres `c_i = i/5` and the kernel

```
W(c) = poleTerm c σ + densityTerm c σ + primeTerm c σ
```

as defined in [`lean/GaussianGram.lean`](lean/GaussianGram.lean) and evaluated
in [`WEIL-GRAM.md`](WEIL-GRAM.md) §2.  The Gram entry is the symmetrisation

```
G_ij = (W(c_i − c_j) + W(c_j − c_i)) / 2,
```

the exact matrices are `gaussianGram4/5/6/7`, the rational centre matrices are
`gramCentre4/5/6/7`, and each rung is closed by an entrywise bound
`|G_ij − gramCentre_n i j| ≤ ε` together with a rational `LDLᵀ` of
`gramCentre_n − gramMargin_n·I`.

## 2. The certified ladder

| `n` | theorem | `ε` | `gramMargin` | budget | audit | status |
|---:|---|---:|---:|---|---|---|
| 4 | `gaussianGram4_posDef` | `12/10000` | `227/10000` | `4ε = 0.0048 < 0.0227` | clean | unconditional |
| 5 | `gaussianGram5_posDef` | `36/10000` | `1/50` | `5ε = 0.018 < 0.02` | clean | unconditional |
| 6 | `gaussianGram6_posDef` | `8/10000` | `1/70` | `6ε = 0.0048 < 0.0143` | clean | unconditional |
| 7 | `gaussianGram7_posDef` | `11/10000` | `1/100` | `7ε = 0.0077 < 0.01` | clean | unconditional |
| 8 | `gaussianGram8_posDef` | `11/10000` | `1/110` | `8ε = 0.0088 < 0.00909` | clean | unconditional |

"Clean" means `#print axioms` gives `[propext, Classical.choice, Quot.sound]` —
no `sorryAx`, no `native_decide` axioms.

The `n = 7` prime band at `c = 6/5` is proved in
[`lean/PrimeEnclosure7.lean`](lean/PrimeEnclosure7.lean) —
`primeTerm (6/5) ∈ [−0.042181, −0.042124]`, `primeTerm (−6/5) ∈ [−10⁻⁵, 0]` —
and the `n = 8` band at `c = 7/5` in
[`lean/PrimeEnclosure8.lean`](lean/PrimeEnclosure8.lean) —
`primeTerm (7/5) ∈ [−0.06192, −0.06185]` — so the ladder is unconditional at
every rung.  The `n = 8` density chain is `DensityG7` (1042 panels on
`gen/edges_1042_c75.txt`), giving a `densityTerm` half-width of `6.373·10⁻⁴` at
`c = 7/5`, i.e. tighter than the `9.653·10⁻⁴` of `c = 6/5`.

The `n = 5` budget is the loose one: it predates the compact `h³` chains and uses
`ε = 36/10000` against density bands of width `~7·10⁻³`.  The `n = 6` and `n = 7`
rungs use the certified bands of the `DensityG*` chains, which is why their `ε`
is an order of magnitude smaller.

## 3. The witness vectors

A certificate of `PosDef` is a coarse statement.  The sharp calibration is the
value of the Weil form on specific vectors: for each `n` take the unit vector

| `n` | witness `x_n` (rounded to `1/1000`, normalised) |
|---:|---|
| 4 | `(−0.298, −0.641, −0.641, −0.298)` |
| 5 | `(0.490, 0.510, 0, −0.510, −0.490)` |
| 6 | `(−0.437, −0.521, −0.193, 0.193, 0.521, 0.437)` |
| 7 | `(−0.397, −0.504, −0.296, 0, 0.296, 0.504, 0.397)` |

each the minimising eigenvector of the corresponding Gram matrix.

| `n` | `λ_min` (numerical) | `x_nᵀ G x_n` (numerical) | `Σ|x|` | certified halfwidth `ε·(Σ|x|)²` |
|---:|---:|---:|---:|---:|
| 4 | `0.022709743` | `0.022709744` | `1.87859` | `4.23·10⁻³` |
| 5 | `0.021423782` | `0.021423798` | `1.99960` | `1.44·10⁻²` (loose `ε`) / `3.20·10⁻³` (at `ε = 8/10000`) |
| 6 | `0.016707845` | `0.016707856` | `2.30279` | `4.24·10⁻³` |
| 7 | `0.012437471` | `0.012437486` | `2.39582` | `6.31·10⁻³` |

The halfwidth is the certified resolution: `|xᵀGx − xᵀCx| ≤ ε(Σ|x_i|)²` follows
from the entrywise bound, so the certificate pins each witness value to a window
of a few times `10⁻³` while the numerical evaluation reaches `10⁻⁸`.  A bridge
must agree with the numbers to its own precision and must not leave the windows.

`λ_min` falls `2.271·10⁻² (n=4) → 2.142·10⁻² (n=5) → 1.671·10⁻² (n=6) →
1.244·10⁻² (n=7) → 9.743·10⁻³ (n=8) → 8.968·10⁻⁴ (n=9)` — the margin law of
[`MARGIN-SCALING.md`](MARGIN-SCALING.md), and the reason the ladder cannot be
continued by scaling `ε` alone.

## 4. The zero-side match

[`ZERO-SIDE-BRIDGE.md`](ZERO-SIDE-BRIDGE.md) §3 records the numerical identity
at the five separations of the `5 × 5` basis, from the first 40 non-trivial
zeros at 30 dps:

| `c` | zero side | `gaussianGramEntry 0 c (1/20)` | difference |
|---:|---:|---:|---:|
| 0 | `0.0431359583948380559` | `0.0431359583948380597` | `−3.7·10⁻¹⁸` |
| `1/5` | `−0.0164892586236695026` | `−0.0164892586236694989` | `−3.7·10⁻¹⁸` |
| `2/5` | `0.00802312920115416105` | `0.00802312920115416469` | `−3.6·10⁻¹⁸` |
| `3/5` | `−0.00222043842501900945` | `−0.00222043842501900586` | `−3.6·10⁻¹⁸` |
| `4/5` | `0.00683902760572623431` | `0.00683902760572623786` | `−3.5·10⁻¹⁸` |

The truncation to 40 zeros is legitimate here because the test function is a
Gaussian of width `σ = 1/20`; the omitted tail is far below the displayed digits.
The trivial zeros are *not* included: they are carried by the archimedean term
(see §3 of the bridge note).

## 5. Acceptance criteria for a claimed bridge

A claimed positivity bridge — any argument that derives positivity of the Weil
form from the zero side, from a spectral model, or from an operator-theoretic
construction — should be checked against all four of:

1. **Entries.** Reproduce `gaussianGramEntry 0 (k/5) (1/20)` for `k = 0, …, 6` to
   the accuracy of §4 on the zero side and of §2 on the arithmetic side.
2. **Margins.** Reproduce `λ_min(n)` for `n = 4, …, 7` within the windows of §3,
   and the numerical values to the bridge's own precision.
3. **Witnesses.** Reproduce `x_nᵀ G x_n` for the four vectors of §3 — this is the
   sharpest finite test, because the witnesses sit at the bottom of the spectrum.
4. **Audit hygiene.** The claimed result must not introduce `sorryAx`, a fresh
   `native_decide` axiom, or an extra hypothesis: every rung of §2 is now
   unconditional, so a bridge at `n ≤ 8` may carry none.

A bridge that passes (1)–(4) but contradicts (2) fails; a bridge that matches
(2) but not (1) has not connected to the arithmetic side.

## 6. What this is not

It is not a proof of RH.  The `n = 7` rung is conditional on one rational prime
band at `c = 6/5`; the ladder does not extend by itself, because `λ_min`
collapses by a factor `10.9` at `n = 9` while `ε` can only be pushed down by
finer partitions (see §4.1 of the handoff and
[`SUB-CONE.md`](SUB-CONE.md) for why a sub-cone does not rescue it).  The
calibration target is exactly that: a fixed, audited, reproducible standard for
testing a bridge, not a step towards the infinite form.
