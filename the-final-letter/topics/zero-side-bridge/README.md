# The zero-side bridge — research programme

**Status:** the contour half is Lean-checked
(`GaussianZeroSide.lean`, in the `absolute-polarized` topic); the equality with
the arithmetic side `W` is numerical to `10⁻¹⁷` (C1) and **open as a theorem**.
Three analytic obligations remain, listed in §4. This folder is the home of the
programme: it owns the numerical harness, the acceptance criteria, and the route
from the finite Gram certificates to `Σ_ρ ĝ_c(γ_ρ)`.
**Part of:** [prime-spectrum-tensor](../prime-spectrum-tensor/README.md) (source
note: [`ZERO-SIDE-BRIDGE.md`](../prime-spectrum-tensor/ZERO-SIDE-BRIDGE.md)) ·
[weil-positivity](../weil-positivity/README.md) · [topic index](../README.md).
**Lean core:** [`../absolute-polarized-hodge-index-realization/lean/GaussianZeroSide.lean`](../absolute-polarized-hodge-index-realization/lean/GaussianZeroSide.lean)
· **numerics:** [`python/programme.py`](python/programme.py) ·
**tests:** [`tests/test_programme.py`](tests/test_programme.py).

## Abstract

The finite Gaussian Weil–Gram ladder certifies that the arithmetic side of the
Weil explicit formula is positive definite on bases of up to seven points.  The
*other* side of that formula expresses the same numbers as a sum over the
non-trivial zeros: for the Gaussian bump `h_c(v) = √π σ exp(−(v−c)²/(4σ²))` whose
transform is `ĝ_c(t) = 2πσ² exp(−σ²t²) exp(−ict)`,

```
Σ_ρ ĝ_c((ρ − 1/2)/i)  =  (W(c) + W(−c))/2  =  gaussianGramEntry 0 c σ,
```

the last equality following from the symmetry of the zero set.  This programme is
the step from the left identity to a theorem.  The contour half is already
Lean-checked — the zero-side test function, its values at the pole and at
`1/2 + it`, and the rectangle contour identity for a finite zero set — and the
numerical agreement of the two sides is at `10⁻¹⁸` for the five separations of
the `5 × 5` basis (C1).  What is missing is the analytic evaluation: shifting the
contour from `Re s > 1` into the critical strip, term-by-term integration of the
von Mangoldt series against `H_c`, a polynomial growth bound for `Z'/Z` in the
strip to kill the rectangle tails, and a formal limit of the finite zero sums.
Nothing here is a proof of the Riemann hypothesis: the identity is an identity
*of the same numbers*, and it holds whether or not the zeros are on the line.

## 1. The object

For `σ = 1/20` and centres `c_i = i/5`, the Gram entry of the ladder is

```
G_ij = gaussianGramEntry c_i c_j (1/20) = (W(c_i − c_j) + W(c_j − c_i))/2,
```

with `W = poleTerm + densityTerm + primeTerm` as in
[`prime-spectrum-tensor/lean/GaussianGram.lean`](../prime-spectrum-tensor/lean/GaussianGram.lean).
The zero side is the sum of the entire test function
`H_c(s) = 2πσ² exp(σ²(s − 1/2)²) exp(−c(s − 1/2))` over the non-trivial zeros.
On the critical line `H_c(1/2 + it) = ĝ_c(t)`, which is what makes the two sides
comparable.

## 2. What is Lean-checked

| name | statement |
|---|---|
| `gaussianZeroTest_critical_line` | `H_c(1/2 + it) = 2πσ² exp(−σ²t²) exp(−ict)` |
| `gaussianZeroTest_pole_sum` | `H_c(0) + H_c(1) = 4πσ² exp(σ²/4) cosh(c/2)` — the pole term of `W` |
| `gaussian_zero_side_contour` | for a finite zero set in a rectangle, `∮ (Z'/Z)·H_c = 2πi(Σ_ρ H_c(ρ) − H_c(0) − H_c(1))` |
| `gaussianZeroTest_eq_mode_mul` | `H_{a−b}(1/2+it) = gaussianMode a σ t · conj(gaussianMode b σ t)` |
| `zeroSideGramReal_posSemidef` | the zero-side Gram matrix of a **critical-line** frequency set is positive semidefinite |

The last two are the spectral explanation of the finite certificates: the zero
side is a Gram matrix of real cosine/sine modes, so any finite set of on-line
frequencies gives a PSD matrix, and an off-line zero is exactly a term that
breaks the rank-one structure.  That is the quantitative form of the
obstruction, and it is why the finite ladder can be certified without touching
the zeros.

The file lives in the `absolute-polarized` topic because its `ExplicitFormula`
module and the `intersection-form-zeta` `Archimedean` module used by the density
layer do not coexist in one `LEAN_PATH`.  The split is a packaging artefact, not
a mathematical one; [`lean/Topic.lean`](lean/Topic.lean) re-exports the four
statements under this topic's namespace so the programme has a single entry
point.

## 3. The numerical match

`python/programme.py` reproduces the table of
[`ZERO-SIDE-BRIDGE.md`](../prime-spectrum-tensor/ZERO-SIDE-BRIDGE.md) §3 from the
first 40 non-trivial zeros at 30 dps:

| `c` | zero side | arithmetic side | difference |
|---:|---:|---:|---:|
| `0` | `0.0431359583948380559` | `0.0431359583948380597` | `−3.7·10⁻¹⁸` |
| `1/5` | `−0.0164892586236695026` | `−0.0164892586236694989` | `−3.7·10⁻¹⁸` |
| `2/5` | `0.00802312920115416105` | `0.00802312920115416469` | `−3.6·10⁻¹⁸` |
| `3/5` | `−0.00222043842501900945` | `−0.00222043842501900586` | `−3.6·10⁻¹⁸` |
| `4/5` | `0.00683902760572623431` | `0.00683902760572623786` | `−3.5·10⁻¹⁸` |

The truncation to 40 zeros is legitimate for a Gaussian of width `σ = 1/20`; the
omitted tail is many orders below the displayed digits.  The trivial zeros are
**not** summed — they are carried by the archimedean term, and any
formalisation must keep that bookkeeping explicit.

## 4. The three open obligations

To close the bridge one must prove

```
(1/2πi) ∮ (Z'/Z)·H_c = density(c) + prime(c)     (sign convention pinned by c = 0)
```

on a contour enclosing the critical strip, then pass to the limit.  The work
splits into:

1. **The prime/archimedean evaluation.**  On `Re s > 1` the library already has
   `Z'/Z·H·i = −(arch·H·i + L_Λ·H·i)`.  Missing: the shift into the strip (picking
   up the zeros and the pole at `s = 1`) and the term-by-term integration of the
   von Mangoldt series against `H_c`.  The Gaussian decay makes the vertical
   integrals absolutely convergent; the archimedean term is the digamma
   expression the density layer already encloses.
2. **The zero-sum limit.**  `zero_sum_tail_bound` bounds the rectangle tail by
   `(M/2π)(perimeter' + perimeter)`.  On the vertical sides `|H_c|` decays like
   `exp(−σ²T²)`, so the tail vanishes against any polynomial growth of `Z'/Z` in
   the strip — a standard bound that is not yet formalised.
3. **The zero set.**  The infinite sum needs an enumeration with multiplicities.
   The natural formal object is a limit of the rectangle divisor sums
   (`rectIntegral_logDeriv_completedZeta_eq_divisor_sum`), avoiding an explicit
   enumeration.

## 5. Acceptance criteria

A closure of this programme must produce, with no `sorry`, `axiom` or `admit`:

1. `gaussianGramEntry a b (1/20) = ∑' ρ, gaussianZeroTest (a − b) (1/20) ρ` for
   the spacing-`1/5` basis, the sum over non-trivial zeros in the sense of §4.3;
2. the archimedean/prime identity of §4.1 as a separate theorem, with the sign
   convention pinned at `c = 0`;
3. the tail limit of §4.2 with an explicit growth bound on `Z'/Z`;
4. the RH statement untouched and open.

Until then the honest reading stands: the contour half is Lean-checked, the
equality with `W` is numerical to `10⁻¹⁷`, and the bridge is open.

## 6. Ledger

| # | kind | statement | where |
|---|---|---|---|
| T1 | Theorem | `H_c(1/2+it) = ĝ_c(t)`: the zero-side test function restricts to the Fourier transform on the critical line | `gaussianZeroTest_critical_line` |
| T2 | Theorem | `H_c(0) + H_c(1) = 4πσ²e^{σ²/4}cosh(c/2)`: the pole sum reproduces the pole term of `W` | `gaussianZeroTest_pole_sum` |
| T3 | Theorem | rectangle contour identity `∮ (Z'/Z)H_c = 2πi(Σ_ρ H_c(ρ) − H_c(0) − H_c(1))` for a finite zero set | `gaussian_zero_side_contour` |
| T4 | Theorem | the zero-side Gram matrix of on-line frequencies is positive semidefinite — the rank-one structure | `zeroSideGramReal_posSemidef` |
| C1 | Computation | the zero side (first 40 zeros, 30 dps) matches `gaussianGramEntry` at the five separations to `3.7·10⁻¹⁸` | `python/programme.py`, `tests/test_programme.py` |
| C2 | Computation | the pole sum `4πσ²e^{σ²/4}cosh(c/2)` reproduces the closed form of `poleTerm` to `10⁻²⁰` | `tests/test_programme.py` |

## 7. What this is not

It is not a proof of the Riemann hypothesis, and it is not a proof of Weil
positivity.  The identity it targets holds regardless of where the zeros are; the
obstruction to positivity sits in the *sign* structure of the zero side, which is
where [`prime-spectrum-tensor/SUB-CONE.md`](../prime-spectrum-tensor/SUB-CONE.md)
records the three excluded sub-cones.  This programme is the formal route to the
identity, and the calibration target of
[`prime-spectrum-tensor/CALIBRATION.md`](../prime-spectrum-tensor/CALIBRATION.md)
is what a completed bridge must reproduce.
