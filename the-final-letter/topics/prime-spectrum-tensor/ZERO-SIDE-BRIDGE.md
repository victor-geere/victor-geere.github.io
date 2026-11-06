# The zero-side bridge for the Gaussian Weil–Gram basis

**Status:** first half Lean-checked (2026-11-05), including the rank-one / finite-PSD
structure (§2.1); the prime/archimedean evaluation, the infinite-zero limit and the
off-line obstruction remain open.  This note scopes the step
from the finite Gram certificate of [`WEIL-GRAM.md`](WEIL-GRAM.md) to the
zero-side identity `⟨W, h_c⟩ = Σ_ρ ĝ_c(γ_ρ)`.  It is not a proof of RH.

## 1. The object

For `h_c(v) = √π σ exp(−(v−c)²/(4σ²))` the Fourier transform is

```
ĝ_c(t) = ∫ h_c(u) e^{−itu} du = 2πσ² exp(−σ²t²) exp(−ict).
```

The Weil value is

```
W(c) = pole(c) + density(c) + prime(c)
     = 2∫ h_c(u) cosh(u/2) du − 2Π(h_c) + (1/2π)∫ ĝ_c(t) Ω(t) dt,
```

which is exactly the `gaussianW c σ` of
[`lean/GaussianGram.lean`](lean/GaussianGram.lean).  The zero side is the sum of
`ĝ_c` over the non-trivial zeros, parametrised by `s = 1/2 + it`:

```
Σ_ρ ĝ_c((ρ − 1/2)/i).
```

Because the zero set is closed under `ρ ↦ 1 − ρ` and under conjugation, the
sum is automatically symmetrised in `c`:

```
Σ_ρ ĝ_c((ρ − 1/2)/i) = (W(c) + W(−c))/2 = gaussianGramEntry 0 c σ.
```

That symmetrisation is precisely the reason the Gram entry is defined as
`(W(c) + W(−c))/2`; the bridge therefore lands on the matrix, not on `W(c)`
alone.

## 2. The Lean-checked half

[`absolute-polarized-hodge-index-realization/lean/GaussianZeroSide.lean`](../absolute-polarized-hodge-index-realization/lean/GaussianZeroSide.lean)
defines the zero-side test function

```lean
def gaussianZeroTest (c σ : ℝ) (s : ℂ) : ℂ :=
  (2πσ² : ℂ) * exp(σ² (s − 1/2)²) * exp(−c (s − 1/2))
```

and proves:

| Name | Statement |
|---|---|
| `gaussianZeroTest_critical_line` | `H_c(1/2 + it) = 2πσ² exp(−σ²t²) exp(−ict)`, i.e. `ĝ_c(t)` on the critical line. |
| `gaussianZeroTest_pole_sum` | `H_c(0) + H_c(1) = 4πσ² exp(σ²/4) cosh(c/2)`, the pole term of `W`. |
| `gaussian_zero_side_contour` | For a finite zero set `S` in a rectangle and the usual explicit-formula hypotheses, `∮ (Z'/Z)·H_c = 2πi(Σ_{ρ∈S} H_c(ρ) − H_c(0) − H_c(1))`. |

The contour identity is a direct instantiation of
`test_function_explicit_formula` ([`ExplicitFormula.lean`](../absolute-polarized-hodge-index-realization/lean/ExplicitFormula.lean));
the only new input is that `H_c` is entire, which `fun_prop` discharges.

### 2.1 The rank-one structure and the finite PSD theorem

The same file proves that on the critical line the zero-side weight is a product
of one mode and a conjugate:

```lean
theorem gaussianZeroTest_eq_mode_mul (a b σ t : ℝ) :
    gaussianZeroTest (a - b) σ ((1 / 2 : ℂ) + (t : ℂ) * I) =
      gaussianMode a σ t * starRingEnd ℂ (gaussianMode b σ t)
```

with `gaussianMode a σ t = σ√(2π) exp(−σ²t²/2) exp(−iat)`.  Equivalently, in
real cosine/sine modes,

```
2πσ² exp(−σ²γ²) cos((a−b)γ)
  = cosMode a σ γ · cosMode b σ γ + sinMode a σ γ · sinMode b σ γ,
```

and consequently the real zero-side Gram matrix is positive semidefinite:

```lean
theorem zeroSideGramReal_posSemidef {κ ι : Type*} [Fintype κ] [Fintype ι] [DecidableEq κ]
    (a : κ → ℝ) (σ : ℝ) (γ : ι → ℝ) :
    (Matrix.of fun i j =>
      ∑ k, 2πσ² exp(−σ²(γ k)²) cos((a i − a j) γ k)).PosSemidef
```

The proof writes the matrix as `L·Lᵀ + M·Mᵀ` with `L i k = cosMode (a_i) σ (γ_k)`
and `M i k = sinMode (a_i) σ (γ_k)`.  This is the spectral explanation of the
finite certificates: the zero side is a Gram matrix of real modes, so any
finite set of **critical-line** frequencies gives a PSD matrix.  For a zero off
the line, `γ` is complex and the corresponding contribution is not rank-one
positive; isolating that term is the quantitative form of the obstruction.

The file lives in the `absolute-polarized` topic because `ExplicitFormula.lean`
and its `Archimedean` module do not coexist in one `LEAN_PATH` with the
`intersection-form-zeta` `Archimedean` module used by the density layer (see
`HANDOFF-O4.md` §8).  The two halves are therefore kept in their own topics and
linked here.

## 3. The numerical bridge

The identity is not merely formal.  Summing the first 40 non-trivial zeros
(`mpmath.zetazero`, 30 dps) gives, for the five separations of the 5×5 basis,

| `c` | zero side | `gaussianGramEntry 0 c (1/20)` | difference |
|---:|---:|---:|---:|
| 0 | 0.0431359583948380559 | 0.0431359583948380597 | −3.7e−18 |
| 1/5 | −0.0164892586236695026 | −0.0164892586236694989 | −3.7e−18 |
| 2/5 | 0.00802312920115416105 | 0.00802312920115416469 | −3.6e−18 |
| 3/5 | −0.00222043842501900945 | −0.00222043842501900586 | −3.6e−18 |
| 4/5 | 0.00683902760572623431 | 0.00683902760572623786 | −3.5e−18 |

The agreement is at the quadrature precision of `weil_gaussian_cross`.  This is
the numerical statement the formal bridge should turn into a theorem; it is
recorded as C25 in [`tests/test_programme.py`](tests/test_programme.py).

The trivial zeros are **not** summed: `H_c(−2m)` grows like
`exp(σ²(2m+1/2)²)`, and in the contour formula they are carried by the
archimedean term, not by the zero set in the critical strip.  Any formalisation
must keep that bookkeeping explicit.

## 4. The remaining gap

The contour identity is half of the bridge.  To close it one must prove

```
(1/2πi) ∮ (Z'/Z)·H_c = density(c) + prime(c)          (up to the sign convention)
```

on a contour enclosing the critical strip, and then pass to the limit over
larger rectangles.  This splits into three analytic obligations, none of which
is currently in Lean:

1. **The prime/archimedean evaluation.**  On `Re s > 1` the library has the
   pointwise and integrated identity
   `Z'/Z·H·i = −(arch·H·i + L_Λ·H·i)`
   ([`ExplicitFormula.lean`](../absolute-polarized-hodge-index-realization/lean/ExplicitFormula.lean)).
   What is missing is the contour shift from `Re s > 1` to the critical strip,
   picking up the zeros and the pole at `s = 1`, and the term-by-term
   integration of the von Mangoldt series against `H_c`.  The Gaussian decay
   `exp(−σ²t²)` makes the vertical integrals absolutely convergent; the
   archimedean term is the digamma expression already enclosed by the density
   layer.  This is the M1 analytic crux in miniature.
2. **The zero-sum limit.**  `zero_sum_tail_bound`
   ([`TailBound.lean`](../absolute-polarized-hodge-index-realization/lean/TailBound.lean))
   bounds the tail by `(M/2π)(perimeter' + perimeter)`, where `M` bounds
   `‖(Z'/Z)·H_c‖` on the boundary.  On the vertical sides `|H_c|` decays like
   `exp(−σ²T²)`, so the tail vanishes provided `Z'/Z` grows slower than
   `exp(σ²T²)`.  A polynomial growth bound for `Z'/Z` in the critical strip is
   standard but not formalised here.
3. **The zero set.**  The infinite sum needs an enumeration of the non-trivial
   zeros with multiplicities.  The rectangle layer already computes divisor
   sums with multiplicity
   (`rectIntegral_logDeriv_completedZeta_eq_divisor_sum`); a limit of those
   finite divisor sums is the natural formal object, avoiding an explicit
   enumeration.

## 5. Acceptance criteria for closing the bridge

1. A Lean theorem stating
   `gaussianGramEntry a b σ = ∑' ρ, gaussianZeroTest (a−b) σ ρ` for the
   spacing-`0.2`, `σ = 1/20` basis, with the sum over the non-trivial zeros in
   the sense of §4.3.
2. The archimedean/prime identity of §4.1 proved as a separate theorem, with the
   sign convention pinned by the `c = 0` case.
3. The tail limit of §4.2, with an explicit growth bound on `Z'/Z`.
4. No `sorry`, `axiom` or `admit`; the RH statement remains untouched and open.

Until then the honest reading is: the zero-side **contour** half is
Lean-checked; the **equality with `W`** is numerical to `10⁻¹⁷` and open as a
formal theorem.

---

[Back to the programme](README.md) · [Weil–Gram rungs](WEIL-GRAM.md) ·
[Margin scaling](MARGIN-SCALING.md) ·
[O2 handoff](../angular-partition-method/HANDOFF-O2.md) ·
[Explicit formula](../absolute-polarized-hodge-index-realization/lean/ExplicitFormula.lean)
