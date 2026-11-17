# Lean layer — geometric zeta

`Topic.lean` (namespace `GeometricZeta`) is deliberately small: it re-exports the
two exact identities that are already in Mathlib, proves the zero-free-factor
structure, and proves the finite-product impossibility.

| item | declaration |
|---|---|
| G1 Euler product `∏_p (1 − p^{−s})^{−1} = ζ(s)` on `Re s > 1` | `eulerProduct` |
| G3 Lambert identity `Σ_k q^k/(1 − q^k) = Σ_n σ_0(n) q^n` | `lambert_identity` |
| G3 divisor-count form `Σ_n d(n) q^n` | `lambert_identity_divisors` |
| G6 a geometric factor is zero-free where defined | `geomFactor_ne_zero` |
| G6 a finite Euler product is zero-free where defined | `finiteEulerProduct_ne_zero` |
| C3 no finite Euler product equals `ζ` on `Re s > 1` | `no_finite_euler_product` |
| G7 all-bases geometric sum `1 + Σ 1/((a+1)^2−1) = 7/4` | `all_bases_sum`, `all_bases_geometric_sum` |
| G5 Dirichlet series `Σ d(n)/n^s = ζ(s)^2` | `divisor_hasSum`, `divisor_summable` |
| G5 Mellin/Lambert `∫ t^{s−1}L(e^{−t})dt = Γ(s)ζ(s)^2` | `lambert_mellin`, `lambert_mellin_divisors` |
| Pointwise AM–GM majorant `Σ e^{−km u²} ≥ (Σ e^{−k²u²/2})²` | `lambert_majorant` |
| Gaussian moment `∫_0^∞ u^{2σ−1}e^{−a u²}du = ½Γ(σ)a^{−σ}` | `gaussian_moment` |
| Identification `Σ_n d(n)q^n = Σ_{k,m} q^{km}` | `lambert_eq_double` |
| Complex-power identity `((x:ℂ)^2)^(s−1) = x^(2(s−1))` | `cpow_sq` |

The additive identity (G2), the log identity (G4), and the counting statement
(C5) are not yet formalised.  The finite-sum impossibility C2 is also still
prose; the finite-product impossibility C3 is `no_finite_euler_product`.  The
Mellin/Lambert transform G5 is now formalised as `lambert_mellin`
(with the divisor-count form `lambert_mellin_divisors`), supported by the
Dirichlet series `divisor_hasSum` and its absolute summability
`divisor_summable`.  The next targets,
in order of expected difficulty:

1. the Lambert/Mellin transform `∫ t^{s−1}L(e^{−t})dt = Γ(s)ζ(s)^2` on `Re s > 1`
   (from `lambert_identity` and Mathlib's Mellin library);
2. the log identity `log ζ(s) = Σ_p Σ_m p^{−ms}/m` (needs log of a `tprod`, or a
   direct comparison);
3. the additive non-perfect-power identity (needs the unique-base theorem:
   every `n ≥ 2` is uniquely `a^m` with `a` not a perfect power);
4. the finite-impossibility statements C2/C3.

## Build

```bash
./check.sh Topic.lean
```

`check.sh` delegates to `../../tools/check-lean.sh`, which puts this directory on
`LEAN_PATH` and builds against the local Mathlib
(`leanprover/lean4:v4.35.0-rc2`).
