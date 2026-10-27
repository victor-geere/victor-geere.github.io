# Lean formal core — GDST twin series

## Build

```bash
cd the-final-letter/topics/gdst-twin-series
./lean/check.sh
```

The wrapper calls the shared checker at `../../tools/check-lean.sh`, which
uses the local Mathlib installation (Lean `v4.35.0-rc2` in the recorded build).
The committed [`BUILD.log`](BUILD.log) records the last successful check.

## What is proved

[`Topic.lean`](Topic.lean) works in namespace `GDSTTwin` and defines:

- `term n s = (n + 2) ^ (-s)`;
- `partialZeta s N = Σ_{n<N} term n s`;
- `selected δ s N = Σ_{n<N, δ n} term n s`;
- `rejected δ s N = Σ_{n<N, not (δ n)} term n s`;

for an arbitrary binary word `δ : ℕ → Bool`. The finite prefix has `N`
terms, indexed `0, …, N−1`.

| Name | Statement |
|---|---|
| `term_pos` | `0 < term n s` |
| `selected_nonneg` | `0 ≤ selected δ s N` |
| `rejected_nonneg` | `0 ≤ rejected δ s N` |
| `selected_add_rejected` | `selected δ s N + rejected δ s N = partialZeta s N` |
| `selected_le_partialZeta` | `selected δ s N ≤ partialZeta s N` |
| `partialZeta_zero` | `partialZeta 0 N = N` |

No `sorry`, `axiom`, or `admit` occurs.

The complement identity is the finite, word-level form of the source's
`E(θ,s) + Ω(θ,s) = ζ(s) − 1`. It is deliberately stated for an arbitrary
binary word: the identity is combinatorial, and the greedy selection rule is
implemented and tested in the Python layer rather than baked into the Lean
definition. This keeps the formal core honest and small.

## What is not formalised

- **The greedy recursion itself.** `δ` is an arbitrary `ℕ → Bool`; the
  residual recursion and its bounds are formalised in the related
  [item 9 folder](../../gdst/lean/Topic.lean), not duplicated here.
- **Convergence and holomorphy.** The source claims that `E` and `Ω` converge
  conditionally and are holomorphic on `Re s > 0`. The finite prefixes do not
  imply the limit.
- **The identification with zeta.** `Σ_{n≥0}(n+2)^(-s) = ζ(s) − 1` for
  `Re s > 0` is a source claim; no `ζ` function or convergence theorem is
  used here.
- **The RH characterisation.** The source's Theorem 1.1 (equivalence of RH
  with the non-attainment of `Re E = −1/2` off the critical line) is an
  archived claim. It is neither proved nor refuted in this file.
- **Balance angles and the analytic phase structure.** Uniqueness,
  monotonicity, distribution, vertical growth, autocorrelation, and the
  explicit formula are open items in the programme README.
- **Bounded variation and natural boundaries.** These are source claims or
  open problems, not Lean theorems here.

The programme dossier records these gaps as source claims and open items.
Nothing in this folder should be read as a proof of the Riemann hypothesis.

[Back to the programme](../README.md) · [Topic index](../../README.md)
