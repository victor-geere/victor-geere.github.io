# Theorem 4 — the tower that does converge

**Kind:** Theorem
**Status:** PROVED (paper argument)
**Area:** xi-horn
**Source:** [`xi-horn/positivity-generator.md`](../../xi-horn/positivity-generator.md) — §7 "Theorem 4 — the tower that does converge"

## Statement

> **Theorem 4.** With Φ̂ as in Theorem 1, RH holds if and only if **both**
> Hankel matrices
>
> ```
> H_N = [ m_{i+j} ]_{0≤i,j≤N}      and      H′_N = [ m_{i+j+1} ]_{0≤i,j≤N}
> ```
>
> are positive semidefinite for every N.

## Hypotheses and notation

- Φ̂ as in [Theorem 1](xihorn-positivity-generator-t1-generator-minimal.md): entire and zero-free on the closed strip
  `|Im z| ≤ ½`.
- The moments are the **window-regularised power sums of the ordinates**:
  ```
  m_n = (−1)ⁿ·E^{(2n)}(0) = Σ_ρ Φ̂(γ_ρ)²·γ_ρ^{2n}                            (11)
  ```
  E is entire of order 2 (the sum (6) has order 2), so it is determined by its
  even Taylor data at v = 0.
- Arithmetic side, from differentiating (5) term by term:
  ```
  m_n = (−1)ⁿ·2Φ̂(i/2)²·4^{−n}
        + (1/2π)∫ Φ̂(r)²·r^{2n}·ψ̃(r) dr
        − (−1)ⁿ·2 Σ_{m≥2} Λ(m)/√m · G^{(2n)}(log m)                        (12)
  ```
  with `G^{(2n)}(u) = σ√π·a^n·H_{2n}(√a·u)·e^{−au²}`, `a = 1/4σ²`, `H` the
  Hermite polynomials.

## Proof / evidence

The source's proof, verbatim:

"(⟹) Under RH the γ_ρ are real, so the moments (11) are those of the positive
measure `μ = Σ_ρ w_ρ·δ_{γ_ρ²}` on `[0,∞)`; both Hankel forms are then PSD by
inspection.

(⟸) Both PSD is Stieltjes' condition, so there is a positive measure μ on
`[0,∞)` with moments m_n. Since `Σ m_n v^{2n}/(2n)!` converges for every v, the
entire function `Ẽ(v) = ∫cos(v√t)dμ(t)` has the same Taylor series at 0 as E,
hence `Ẽ = E`. Pushing μ forward under `t ↦ √t` exhibits E as the cosine
transform of a finite positive measure on `[0,∞)`: E is positive-definite, hence
bounded, hence RH by Theorem 1. ∎"

Numerical evidence recorded in §7: the two computations (11) and (12) agree to
41 digits at σ = 0.15 —
```
   n    m_n from the primes         m_n from the zeros          rel. diff
   0    0.003169642105395524        0.003169642105395524        1.4e−41
   1    0.636646702121753           0.636646702121753           3.6e−41
   2    128.7078835784823           128.7078835784823           4.6e−41
   4    5579967.203245768           5579967.203245768           3.5e−41
   8    3.304087784336096e+16       3.304087784336096e+16       6.3e−41
  13    9.398349709353373e+29       9.398349709353373e+29       9.3e−41
```
and both towers are PSD to N = 7 (normalised by `D^{−1/2}·H·D^{−1/2}` with
`D = diag(m_{2i})`), with floors decaying at 2.3 to 2.6 decades per rung —
"Theorem 2's corollary again, in the coordinates where the tower is a moment
problem rather than a Toeplitz section."

## Dependencies and related results

- [Theorem 1](xihorn-positivity-generator-t1-generator-minimal.md) supplies the final step (E positive-definite ⟹ bounded
  ⟹ RH); [the Corollary to Theorem 2](xihorn-positivity-generator-c1-floor-blindness.md) explains the decaying floors.
- "The shift matters: `H_N` alone is Hamburger's condition and admits mass on
  `t < 0`, i.e. purely imaginary γ_ρ, i.e. a real zero of ζ in (0,1). The
  shifted tower is what excludes it."
- §7.1 places the tower between criteria the arc already runs: Li (rh10 §2),
  this tower `(n, σ)`, the Weil certificates of rh17–rh30 `(n, Δ, window)`, and
  the Jensen tower `(d, n)`: "They are one measure read three ways — as moments
  at the identity, as moments on a subgroup, and unregularised."

## Notes

- "The tower of §7 is not new either. Regularised power sums of the ordinates
  are Li's criterion with a smoothing, and the Hankel/Stieltjes route is 1894.
  Its value here is that it exhibits Weil positivity, Li positivity and the
  arc's Toeplitz certificates as three readings of one measure — an
  identification."
- The equivalence is stated for **every** N and is a countable index, not a
  finite computation: "Theorem 4 is an equivalence with a countable index."
- Precision caveat: "the moment tower wants 50 [dps], because `H_7`'s
  determinant is 3.4e−35 after normalisation."
- §7 is the file's answer to Theorem 2: "Theorem 2 kills finite families. What
  survives is a *countable exhaustion whose rungs are finite matrices*."
