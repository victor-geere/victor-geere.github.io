# The `ℤ²` completed `L`-series

This note proves the self-duality used as P1 in the QEFE dossier. The proof is
classical; the point is to record every step. It is now formalised in Lean as
T118–T120.

## The series

For `Re s > 1`, let

```
Λ_ℤ²(s) = π^(-s) Γ(s) Σ_{(m,n) ≠ (0,0)} (m² + n²)^(-s).
```

The number of representations of `n` as a sum of two squares is
`r₂(n) = 4 Σ_{d|n} χ₄(d)`, where `χ₄` is the primitive odd character modulo `4`.
Hence

```
Σ_{(m,n) ≠ (0,0)} (m² + n²)^(-s)
  = Σ_{n≥1} r₂(n) n^(-s)
  = 4 ζ(s) β(s),
β(s) = Σ_{k≥0} (-1)^k (2k+1)^(-s).
```

## The two completed functions

Put

```
Z(s) = π^(-s/2) Γ(s/2) ζ(s),
B(s) = (4/π)^((s+1)/2) Γ((s+1)/2) β(s).
```

Both are standard completed `L`-functions. The functional equation of `ζ` gives
`Z(s) = Z(1-s)`. The functional equation of the primitive odd character `χ₄`
gives `B(s) = B(1-s)` (root number `1`).

## The product

Legendre duplication is

```
Γ(s) = 2^(s-1) π^(-1/2) Γ(s/2) Γ((s+1)/2).
```

Therefore

```
Z(s) B(s)
  = π^(-s/2) (4/π)^((s+1)/2) Γ(s/2) Γ((s+1)/2) ζ(s) β(s)
  = π^(-s/2) 2^(s+1) π^(-(s+1)/2) Γ(s/2) Γ((s+1)/2) ζ(s) β(s)
  = 2^(s+1) π^(-s-1/2) · 2^(1-s) π^(1/2) Γ(s) ζ(s) β(s)
  = 4 π^(-s) Γ(s) ζ(s) β(s)
  = Λ_ℤ²(s).
```

Since `Z` and `B` are each invariant under `s ↦ 1-s`, their product is too:

```
Λ_ℤ²(s) = Z(s) B(s) = Z(1-s) B(1-s) = Λ_ℤ²(1-s).
```

This is C2. The numerical check is `test_z2_epstein_functional_equation`.

## Lean formalisation

The product route is formalised in [`lean/Topic.lean`](lean/Topic.lean):

```lean
def LambdaZ2 (s : ℂ) : ℂ := completedRiemannZeta s * completedBeta s
```

- **T118** `gammaR_duplication` is Legendre duplication in the form
  `2^(s+1) Γℝ(s) Γℝ(s+1) = 4 π^(−s) Γ(s)`.
- **T119** `lambdaZ2_self_dual : LambdaZ2 s = LambdaZ2 (1−s)` follows from
  Mathlib's `completedRiemannZeta_one_sub` and the all-`s` completed beta
  functional equation T115.
- **T120** `lambdaZ2_product`, for `Re s > 1`, identifies `LambdaZ2 s` with
  `4 π^(−s) Γ(s) ζ(s) β(s)`.

The dependency cone of T119–T120 contains the zeta and beta functional
equations and Legendre duplication; it does not use the Hurwitz-zeta
functional equation.

## Epstein/lattice reduction

The remaining identification is with the lattice series
`Σ_{(m,n)≠(0,0)}(m²+n²)^(−s) = Σ_{n≥1} r₂(n)n^(−s)`. Lean now defines

```lean
def r2 (n : ℕ) : ℕ            -- ordered integer pairs with x²+y² = n
def divisorSumChi4 (n : ℕ) : ℤ -- Σ_{d|n} χ₄(d)
def TwoSquaresFormula : Prop   -- r2 n = 4 Σ_{d|n} χ₄(d), n ≥ 1
```

- **T121** `LSeries_divisorSumChi4` proves
  `LSeries (fun n => divisorSumChi4 n) s = ζ(s)β(s)` for `Re s > 1`.
- **T122** `epstein_series_eq_four_zeta_beta` proves
  `LSeries (fun n => r2 n) s = 4ζ(s)β(s)` **conditional on** `TwoSquaresFormula`.

The only missing arithmetic input is therefore the pointwise two-squares
count `r₂(n) = 4Σ_{d|n}χ₄(d)`.

## References

The two functional equations and the duplication formula are standard; see
[`REFERENCES.md`](REFERENCES.md), §3 and §6. The character identity for `r₂` is
the classical two-squares theorem (Gauss; see Iwaniec–Kowalski, Ch. 3).

