# Theorem 3 — the lattice is not the group, and the floor's decay is forced

**Kind:** Theorem
**Status:** PROVED (paper argument, (b) via the cited Toeplitz limit theorem)
**Area:** xi-horn
**Source:** [`xi-horn/positivity-generator.md`](../../xi-horn/positivity-generator.md) — §5 "Theorem 3 — the lattice is not the group, and the floor's decay is forced"

## Statement

> **Theorem 3.** Every certificate in rh17–rh30 samples E on a lattice `Δℤ`
> rather than on ℝ. That is the whole difference between the family the arc
> computes with and the family Theorem 1 needs, and it has an exact description.
>
> Sampling (6) at `v = kΔ` gives
>
> ```
> T[i][j] = E((i−j)Δ) = ∫ cos((i−j)θ) dν_Δ(θ),   ν_Δ = Σ_ρ w_ρ·δ_{γ_ρΔ mod 2π}   (8)
> ```
>
> so `T_n` is the Toeplitz matrix of the moments of the **wrapped** measure ν_Δ.
> Two consequences.
>
> **(a) The lattice family spans a proper subspace.** The closed span of
> `{φ(· − mΔ)}` consists exactly of the *f* whose transform is `Φ̂(r)·p(r)` with
> *p* of period 2π/Δ — i.e. the functions measurable with respect to
> `r mod 2π/Δ`.
>
> **(b) The floors must decay, and that is Szegő, not ζ.** ν_Δ is purely atomic.
> By the Toeplitz limit theorem the smallest eigenvalue of the n-th section
> decreases monotonically to the essential infimum of the absolutely continuous
> part of the symbol, which for an atomic measure is 0. So
>
> ```
> λ_min(T_n) ↓ 0   for every window and every mesh, unconditionally.
> ```

## Hypotheses and notation

- E as in (5)/(6) of §2; `w_ρ = Φ̂(γ_ρ)²` the atom weights;
  `γ_ρ` the ordinates; Δ the lattice spacing; `T_n` the n-th Toeplitz section
  `T[i][j] = E((i−j)Δ)`.
- `ν_Δ = Σ_ρ w_ρ·δ_{γ_ρΔ mod 2π}` — the wrapped (aliased) measure of rh34,
  identified.
- Part (b) uses the Toeplitz limit theorem (Szegő; listed in §0 among the
  classical inputs) and the fact that ν_Δ is purely atomic.
- `N_eff` = mass / heaviest atom, rh30 §3's effective atom count.

## Proof / evidence

Part (a) is stated with its reason: the closed span of `{φ(· − mΔ)}` is exactly
the functions whose transform is `Φ̂(r)·p(r)` with p of period 2π/Δ, "i.e. the
functions measurable with respect to `r mod 2π/Δ`. Positivity there is
positivity of the aliased measure, which is implied by RH and does not imply it.
Refining Δ → 0 separates the fibres and does recover the full criterion; the
separation is the entire difficulty."

Part (b) is stated with its reason: "ν_Δ is purely atomic. By the Toeplitz limit
theorem the smallest eigenvalue of the n-th section decreases monotonically to
the essential infimum of the absolutely continuous part of the symbol, which for
an atomic measure is 0."

Supporting computations in §5:

- The aliasing is not asymptotic. At Δ = 0.5 the Nyquist ordinate
  `π/Δ = 6.2832` sits below γ₁ = 14.1347, so *every* zero is folded:
  ```
    γ₁ = 14.134725  →  θ = 0.78417726     γ₃ = 25.010858  →  θ = 6.2222435
    γ₂ = 21.022040  →  θ = 4.2278345      γ₆ = 37.586178  →  θ = 6.2267185
  ```
  γ₃ and γ₆ — 12.58 apart on the critical line — land **0.004475 radians apart**
  on the lattice circle; a Toeplitz section resolves an angular gap ε only once
  n ≳ 2π/ε, so separating them at Δ = 0.5 needs n ≈ 1,404, against the n = 1,201
  that is the arc's largest computation anywhere.
- The window ladder `λ_min(T_n)/E(0)` at Δ = 0.5, n = 2 … 12:
  ```
     n     σ = 0.15 (N_eff 2.01)   σ = 0.10 (N_eff 2.21)   σ = 0.05 (N_eff 4.53)
     2      0.297041                0.383937                0.728872
     3      0.00590312              0.113507                0.65113
     4      0.00506124              0.0958414               0.591855
     6      3.11622e−07             0.00193785              0.257978
     8      2.30911e−07             0.00061606              0.059422
    10      3.05847e−10             1.78221e−05             0.052695
    12      8.32429e−15             7.61958e−07             0.0294486
  ```
- The control of §5.1: keeping the weights and replacing ζ's ordinates
  (σ = 0.05, Δ = 0.5),
  ```
    ordinate set                       λ_min(T_n)/E(0) at n = 2, 4, 6, 8, 10, 12
    ζ's ordinates                      0.7289  0.5919  0.2580  0.05942  0.05269  0.02945
    arithmetic progression 14.13 + 6k  0.7822  0.4411  0.07627 0.01155  0.001031 0.0001991
    √-lattice  14.13·√(k+1)            0.7821  0.5286  0.3276  0.2319   0.01936  0.01158
  ```
  All three collapse; ζ's set sits "between the two synthetic ones".

## Dependencies and related results

- Toeplitz limit theorem (Szegő) — cited, not reproved.
- [Theorem 1](xihorn-positivity-generator-t1-generator-minimal.md) defines the family whose lattice sampling (8) describes;
  the aliasing identification is of rh34's "wrapped, aliased matrix".
- rh28 §6 measured the decay and could not name it; rh30 §3's collapse onto
  n/N_eff; rh27a §5 recorded "the Δ lattice alone resolves only to π/Δ = 13.1,
  which is below the first zero at 14.1347" without naming it as aliasing.
- rh19's notch is the real-axis case of the same mechanism (see
  [the §6 window condition](xihorn-positivity-generator-window-laguerre-polya.md)).

## Notes

- The source states this under the heading "Theorem 3" but **without a boxed
  statement**; the two parts and the display (8) above are quoted near-verbatim
  from §5.
- Part (b) is a statement about atomic measures, not about ζ: "rh28 §6 measured
  this decay, found it steeper than a power law, and reported it as an unwelcome
  fact about the object. It is a theorem about atomic measures. … **The fact of
  the decay is a property of atomic measures; only its rate could carry
  information about ζ, and the rate for ζ is unremarkable against controls
  chosen without thought.**"
- The collapse "tracks N_eff and nothing else"; at σ = 0.15 the section is
  essentially rank 2 and the floor falls two decades between n = 2 and n = 3.
- Part (a) is the precise sense in which "the lattice is not the group" — it is
  the gap between what the arc computes with and what Theorem 1 needs.
