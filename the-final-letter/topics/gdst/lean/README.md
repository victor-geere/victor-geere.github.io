# Lean formal core — Greedy Dirichlet Sub-Sum Transform

## Build

```bash
the-final-letter/topics/gdst/lean/check.sh
```

The wrapper invokes the shared checker [`../../tools/check-lean.sh`](../../tools/check-lean.sh), which uses the local Mathlib installation at `~/lean/mathlib4` (Lean `v4.35.0-rc2`). The committed [`BUILD.log`](BUILD.log) records the last successful check.

## What is formalised

[`Topic.lean`](Topic.lean) defines the finite greedy recursion on the unit interval:

- `GDST.alpha n = 1/(n+2)`;
- `GDST.digit0 x`, the initial digit selected by `α 0 = 1/2`;
- `GDST.nextDigit n r`, the digit selected by `α (n+1) = 1/(n+3)`;
- `GDST.state x n = (δ n(x), r n(x))`;
- `GDST.delta x n` and `GDST.rem x n`;
- `GDST.dirichletPrefix s N`, `GDST.selectedWeight x s N` and `GDST.rejectedWeight x s N`.

It proves the following, with no `sorry`, `axiom` or `admit`:

| Name | Statement |
|---|---|
| `delta_zero_or_one` | `δ n(x) = 0 ∨ δ n(x) = 1` |
| `rem_nonneg` | `0 ≤ x → 0 ≤ r n(x)` |
| `rem_bound` | `x ≤ 1 → r n(x) ≤ 1/(n+2)` |
| `finite_identity` | `x = Σ_{k≤N} δ k(x)/(k+2) + r N(x)` |
| `rem_after_selection` | `δ (n+1)(x) = 1 → r (n+1)(x) ≤ 1/((n+2)(n+3))` |
| `selected_add_rejected` | `E_N(x,s) + Ω_N(x,s) = D_N(s)` |
| `selected_rejected_nonneg` | `0 ≤ E_N(x,s) ∧ 0 ≤ Ω_N(x,s)` |

The selected/rejected theorem is the finite, exact form of the source's split `ζ(s) − 1 = E(θ,s) + Ω(θ,s)`. It is proved by finite sum manipulation, not by any analytic identity.

## What is not formalised

The archived source claims a proof of the Riemann Hypothesis. That global argument is **not** formalised, and the Lean file deliberately does not introduce axioms to reach it. Missing pieces include:

- the limit `r N(x) → 0` and the convergence of the infinite greedy expansion;
- the angle lift `θ ↦ θ/π`, the centred digits `f n(θ)`, and the integral correlation kernel `K(n,m)`;
- positive semidefiniteness of the finite and infinite correlation matrices;
- holomorphy of `E(θ,·)` and the infinite selected/rejected identity for `Re(s) > 1`;
- the transfer operator `L_s`, its Fredholm determinant, and the similarity and trace identities AX1–AX4;
- the spectral measure `μ_σ`, the Jacobi matrix `J_σ`, the trace/zero-moment formulae, and the regularised Stieltjes transform;
- the final spectral-support argument and the RH conclusion.

Several of these are explicitly listed as axioms in the source's own Axiom Registry. AX5 (a closed form for `K(n,n)`) is retracted by the source; the Python layer reproduces its failure at `n = 0`. These items are recorded as source claims and open items in the [programme dossier](../README.md).

## Source limitation

The source is not a complete, axiom-free proof. It is a generated walk-through of an Isabelle development whose final theorem depends on an extensive axiom list. The honest reconstruction is therefore the finite greedy core above, not a formalisation of the global claim.

[Back to the programme](../README.md) · [Topic index](../../README.md)
