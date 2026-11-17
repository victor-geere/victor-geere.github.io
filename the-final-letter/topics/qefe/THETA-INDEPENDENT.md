# Theta-independent `L`-series: what is missing

## Current route

T24 proves the functional equation of `completedLFunction χ₄` from Mathlib's
`IsPrimitive.completedLFunction_one_sub`. Mathlib's completed Dirichlet
`L`-function is defined through the Hurwitz-zeta development:

```
completedLFunction χ s  ≺  completedHurwitzZetaEven/Odd
```

So the dependency cone of T24 contains the Hurwitz route.

## What `zeta-from-theta` supplies

The `zeta-from-theta` dossier defines, in Lean,

```
ψ(t) = (θ(t) − 1)/2,      Λ_θ(s) = ∫_0^∞ t^(s/2−1) ψ(t) dt,
```

proves the theta functional equation with an audited dependency cone free of
Mathlib's `*_one_sub` theorems, defines `zetaTheta = Λ_θ / Γℝ`, and identifies it
with `riemannZeta`. It is an FE-independent development of `ζ`, not of a general
Dirichlet `L`-series.

## The gap for P1

To replace T24 by a theta-independent proof for `χ₄`, one needs a *twisted*
theta with an odd character, not the classical Riemann theta. The precise
object is

```
θ_χ(τ) = Σ_{n∈Z} χ₄(n) n e^(-π n² τ).
```

The factor `n` is essential: the naive theta `Σ χ₄(n)e^(-πn²τ)` vanishes
identically because `χ₄` is odd. For `Re s > 1`, the Mellin transform at
`(s+1)/2` is

```
∫_0^∞ τ^((s+1)/2−1) θ_χ(τ) dτ
  = Γ((s+1)/2) π^(-(s+1)/2) β(s).
```

The modular transformation of `θ_χ` has weight `3/2` and a character root
number. The available route is the shifted Poisson summation already in
Mathlib:

```
F(a,b) = Σ_{n∈Z} e^(−πa n² + 2πbn),
Complex.tsum_exp_neg_quadratic :
  F(a,b) = a^(-1/2) Σ_{n∈Z} e^(−(π/a)(n+Ib)²).
```

Since `χ₄(n) = sin(πn/2) = (e^(πin/2) − e^(−πin/2))/(2i)`, the twisted theta
is a linear combination of `∂F/∂b` at `b = ±i/4`. The Gauss sum computed in
T38–T39 is the root-number factor. The missing formal step is differentiating
the shifted Poisson identity in `b` and evaluating at `b = ±i/4`.

A crucial simplification: Mathlib already contains the weight-`3/2`
transformation for the derivative Jacobi theta,

```
jacobiTheta₂'_functional_equation' :
  jacobiTheta₂' z τ =
    (-2π) / (-Iτ)^(3/2) * jacobiTheta₂'' z (-1/τ),
```

together with the full odd Hurwitz-zeta Mellin development
(`HurwitzZetaOdd.lean`). So the Poisson summation and Gauss-sum step does not
need to be reproved. What remains is the algebraic identification of
`twistedTheta4` and the characteristic thetas with `jacobiTheta₂'` at
`z = ±1/4` (for the scalar) and `z = ∓ i c/4` (for the vector).

A crucial correction: differentiating the shifted Poisson identity at
`b = ±i/4` does **not** close on `twistedTheta4(c)` itself. It produces the characteristic thetas

```
Σ_{n∈Z} (n ∓ 1/4) e^(−πc(n ∓ 1/4)²).
```

Thus the modular transformation closes on a **two-component vector** of
characteristic thetas, not on the scalar `twistedTheta4`. The scalar
weight-`3/2` transformation assumed in the original target is therefore not the
correct statement; the FE for `β` needs the vector (or an equivalent
Hurwitz/characteristic theta pair). This is a precise obstruction, not a proof
of the scalar transformation.

Concretely:

1. define `θ_χ(τ)=Σ_{n∈Z} χ₄(n)n e^(−πn²τ)` and prove its convergence and
   weight-`3/2` modular transformation with the character root number;
2. prove the Mellin transform
   `∫ τ^((s+1)/2−1)θ_χ(τ)dτ = Γ((s+1)/2)π^(-(s+1)/2)β(s)`,
   including the Gauss-sum/root-number factor;
3. combine with the completed `ζ` factor (or the `ℤ²` theta of T9/T28) and the
   duplication identity to obtain P1 without `completedLFunction`;
4. audit the dependency cone to ensure neither `completedLFunction` nor the
   Hurwitz development occurs.

Step 2 is the missing analytic input. The natural name is:

> **LatticeThetaMellinChi4** — the Mellin transform of the square-lattice theta,
> identified with `4π^(−s)Γ(s)ζ(s)β(s)`, with a proof whose dependency cone does
> not contain `completedLFunction` or Hurwitz zeta.

Without it, P1 is a paper theorem plus rational certificates (C2), and T24 is a
correct but Hurwitz-dependent Lean theorem.

## Status

The rank-one and cubic rank-`n` theta modularities are proved (T8 and T28), the
integer character `χ₄` is formalised (T29–T30, T33), and the twisted theta is
defined and proved summable for `τ > 0` (T31–T37). Target 2 is **closed** by the
characteristic-theta vector route (T75–T95) and the completed-`L` bridge
(T96–T116); P1 is T118–T120.

`LatticeThetaMellinChi4` is **closed** as T218–T219: the `Prop` is the identity
already proved by T120 (`lambdaZ2_product`). The dependency-clean route that
avoids `completedLFunction` and Hurwitz zeta remains an optional
formalisation-independence asset, not a mathematical gap.


## Completion status

The χ₄ case is now closed at the level of the beta function. The
characteristic-theta vector is defined in Lean (`charKernel`, `thetaPlus`,
`thetaMinus`, T40), its sums are summable (T41–T44), the Jacobi prefactor
identities are Lean-proved (T50, T53), the vector modular relation is T60, and
the two Mellin HasSum identities are T61/T63. The scalar character series is
`2β(s)` (T84), the scalar Mellin transform is `Γℝ(s+1)·2β(s)` (T92), and the
completed beta functional equation is T95.

What remains open is the identification of Mathlib's
`completedLFunction chi4` with `completedBeta`, i.e. the full replacement of
T24, and the general even-lattice case, which requires `ℝⁿ` Poisson summation
(not formalised). No Lean theorem asserts the QEFE's finite FE.


## Jacobi-theta identification

Put `J(z,τ) = jacobiTheta₂ z τ` and `J'(z,τ) = jacobiTheta₂' z τ`. For
`a > 0`, the identification to prove is

```
twistedTheta4(a)
  = -(1/(4π)) [J'(1/4, ia) - J'(-1/4, ia)].
```

For the characteristic vector, with `c > 0`,

```
thetaPlus(c)
  = e^(-πc/16) [ (1/(2πi)) J'(-ic/4, ic) - (1/4) J(-ic/4, ic) ],

thetaMinus(c)
  = e^(-πc/16) [ (1/(2πi)) J'(ic/4, ic) + (1/4) J(ic/4, ic) ].
```

These identifications are Lean-proved (T47, T50, T53). Mathlib's
`jacobiTheta₂'_functional_equation'` then gives the vector modular relation
directly (T60); no new Poisson summation is needed. The Mellin step is the
termwise integration of the resulting Jacobi theta expressions (T61, T63).


## Vector modular relation

The relation

```
twistedTheta4(a)
  = (1 / (2 a^(3/2))) (thetaMinus(1/a) - thetaPlus(1/a)).
```

is Lean-proved as T60 (`twistedTheta4_vector_modular`). It follows from T47,
Mathlib's `jacobiTheta₂'_functional_equation'`, and the two prefactor
identities T50/T53.

The vector Mellin identity is T61/T63, and the completed beta FE is T95. The
dependency-cone replacement of T24 is the remaining item.


## Final Mellin status

Both characteristic-theta Mellin HasSum identities are Lean-proved:
`hasSum_mellin_thetaPlus` (T61) and `hasSum_mellin_thetaMinus` (T63).

The signed odd-series identification with β is Lean-proved
(`betaSeriesStatement`, T71). With `betaSeries s = Σ_{k≥0} (-1)^k (2k+1)^(-s)` it
gives

```
Σ_i sign(i−1/4)/|i−1/4|^s = -(4^s) betaSeries s.
```

The companion `thetaMinus` identity `Σ_i sign(i+1/4)/|i+1/4|^s = 4^s betaSeries s`
is T87; it follows from T71 and the `i ↦ -i` symmetry.

## Scalar Mellin status

The direct scalar Mellin HasSum is proved (T73):

`HasSum (Γℝ(s+1) χ₄(i) sign(i)/|i|^s) (mellin twistedTheta4 ((s+1)/2))`.

The identification of the character series with `2β(s)` is now Lean-proved
(`scalarBetaStatement`, T84). Consequently, for `Re s > 1`,

```
mellin twistedTheta4 ((s+1)/2) = Γℝ(s+1) · 2β(s)          (T92)
```

and the completed beta is the classical

```
completedBeta s = 2^(s+1) Γℝ(s+1) β(s) = (4/π)^((s+1)/2) Γ((s+1)/2) β(s).
```

## Completed beta functional equation

The completed beta functional equation is Lean-proved (T95):

```
completedBeta s = completedBeta (1−s)   (Re s > 1).
```

The proof uses T60 to rewrite `twistedTheta4` in terms of `thetaMinus` and the
Mellin change of variables T91, then T63 at the reflected argument and T87. The
two half-plane expressions for the Mellin transform are combined through the
identity `4^s = 2^s · 2^s`; no analytic continuation of a Dirichlet series is
required.

## T24 replacement

The bridge is now formalised. The χ₄ Dirichlet series is `β(s)` (T99), the
convergence-half-plane identification is T104,
`completedBeta s = 2^(s+1) completedLFunction χ₄ s` (T105), the Mellin
transform of `twistedTheta4` is entire (T106–T114), and the completed beta
functional equation extends to all `s` (T115). The bridge extends to all `s` by
analytic continuation (T116), and T24 is re-derived from it (T117):

```
completedLFunction χ₄ (1−s)
  = 4^(s−1/2) · rootNumber χ₄ · completedLFunction χ₄⁻¹ s.
```

The derivation uses only the theta route for the functional equation. The
Mellin differentiability input is proved through the θ₋/θ₊ kernel pair and the
generic Mellin differentiation theorem, not through the Hurwitz-zeta
functional equation. `#print axioms` reports only `propext`,
`Classical.choice`, `Quot.sound`.

## Remaining gap

The only remaining analytic gap in this chain is the general even-lattice
`ℝⁿ` Poisson summation, which is cited rather than formalised. The ℤ² case
(P1) is closed by T118–T120.
