# Phase-corrected series and the annular obstruction

## What is formalised

For finite data `(χ_i, m_i)` the phase-corrected series is

```
Ψ(σ,t) = Σ_i χ_i m_i^(-σ) e^(-it log m_i).
```

Lean (`QEFE.phasePsi`, T25–T26) proves:

- `Ψ(σ,-t) = conj Ψ(σ,t)` — time reversal is conjugation;
- `‖Ψ(σ,t)‖ ≤ Σ_i |χ_i| exp(-σ log m_i)` — the phase does not affect the
  decay envelope.

## What the angular partition method supplies

The angular partition dossier proves the phase-carrying tail coil: for an
absolutely summable complex series `c_n`, the complex tails `Z_n = Σ_{k≥n} c_k`
satisfy `c_n = Z_n - Z_{n+1}`, and the normalized coil `w_n = Z_n/Z_0` lies in
the unit disk with `w_n → 0`. The phase is carried exactly, with no finite
truncation. It also proves the Mellin/Laplace radial representation
`Γ(s)ζ(s) = ∫ t^(s-1)/(e^t-1) dt` and the completed zeta FE, and it continues
the annular Mellin integral to `-3 < Re s`.

## The obstruction for the infinite lattice series

The categorical series that needs the phase is the infinite lattice series

```
Ψ_L(s,t) = Σ_{λ≠0} ε_λ ‖λ‖^(-2σ) e^(-it log ‖λ‖²).
```

For `σ > 1` this is absolutely summable, and the phase coil applies directly.
For `σ ≤ 1` — in particular in the critical strip — the series is not
absolutely summable, so the coil's `Z_0` is not defined by the ordinary sum.

The angular partition method's §7.6 lists exactly what is missing:

1. a regularized annular representation whose total area is the analytic
   continuation, not the divergent sum;
2. a phase-carrying measure (vector-valued area) with a convergence theorem;
3. a Mellin/Laplace transform with the correct functional equation and growth
   bounds, exact for `Re s > 1` and meromorphic beyond.

None of these is formalised, and the angular partition dossier itself records
them as research targets, not theorems. The precise missing input is therefore:

> **RegularizedAnnularLatticeSeries** — a regularized annular measure for
> `Ψ_L(s,t)` with a phase-carrying convergence theorem and a Mellin transform
> satisfying the lattice functional equation on the critical strip.
>
> **Status: retired as a headline gap.** Under the dossier's trichotomy this is
> an alternative continuation for an object that already has one (P1). Carrying
> it as a named input inflates the apparent open surface. The precise open
> question is recorded below.

This is an obstruction, not a contradiction: the method supplies the framework
and the exact phase bookkeeping, but not the regularized measure.

## Status

Target 1 is complete at the finite level (T25–T26). The infinite
`RegularizedAnnularLatticeSeries` is retired as a headline gap. The precise
open question is:

> Does the functional equation survive the `k → ∞` limit of the `SU(2)_k`
> tower?

That is a concrete limit question about a named family, not a request for a
general regularized annular measure.
