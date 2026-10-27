# Lean formal core — harmonic–categorical Hilbert–Pólya

## Build

```bash
cd the-final-letter/topics/harmonic-categorical-hilbert-polya
./lean/check.sh
```

The wrapper calls [`../../tools/check-lean.sh`](../../tools/check-lean.sh), which uses the local Mathlib installation at `~/lean/mathlib4` (Lean `v4.35.0-rc2`). The committed [`BUILD.log`](BUILD.log) records the last successful check.

## What is formalised

`Topic.lean` works in namespace `HCHP` and defines

- `HCHP.weight σ N = ∑_{j<N} (j+1)/(j+2)^σ`, the truncated `j`-series weight;
- `HCHP.entry s N m n`, source equation (2) truncated at `N` terms, with the binomial coefficient and the real exponent `s + 1 + (n − m)`;
- `HCHP.A s N k`, the `(k+1) × (k+1)` truncation of the greedy transfer operator;
- `HCHP.disc2 a b d = (a−d)² + 4b²`, the characteristic discriminant of the real symmetric matrix `[[a,b],[b,d]]`.

It proves seven facts:

| Name | Statement |
|---|---|
| `weight_pos` | `0 < weight σ N` for `N > 0` |
| `entry_eq_zero_of_lt` | below-diagonal entries vanish: `n < m → entry s N m n = 0` |
| `A_upperTriangular` | `A s N k` is upper triangular |
| `A_diag` | every diagonal entry of `A s N k` equals `weight (s+1) N` |
| `det_A` | `det (A s N k) = (weight (s+1) N)^(k+1)` |
| `det_one_sub_A` | `det (1 − A s N k) = (1 − weight (s+1) N)^(k+1)` — the finite analogue of source Lemma 4.1 |
| `hermitian2_charpoly_splits` | the characteristic polynomial of a real symmetric `2 × 2` matrix factors over `ℝ` with roots `(a+d ± √disc2)/2`; the non-negativity of `disc2` is proved inside |

There is no `sorry`, no `axiom`, and no `admit`.

## What is not formalised

The source's global proof is **not** formalised. In particular this file does not contain:

- the infinite transfer operator `L_s` on `H²(𝔻)`, its trace-class property, or the Fredholm determinant identity of source Theorem 5.1;
- the polar decomposition `A_k(t) = U_k(t)|A_k(t)|`, the unitary factor, a continuous branch of `log U_k`, or the Hamiltonian `H_k = i d/dt log U_k(0)`;
- the eigenvalue–determinant correspondence of source Lemma 4.1 (only its finite determinant is computed);
- the uniform convergence `Δ_k → Δ` of source Proposition 6.1;
- Hurwitz’s theorem applied to the truncated zero sets, or the reality of the zeros of the limit `Δ`;
- the Riemann Hypothesis. Source Theorem 7.1 is an archived claim, not a Lean theorem.

The Lean parameter `s` is real and the `j`-series is truncated at `N`. This is deliberate: triangularity, constancy of the diagonal, and the determinant identities are algebraic and independent of the complex-analytic continuation. The Python layer checks the structural identities at the complex critical-line parameter `s = 1/2 + it` as far as `sympy` can do so exactly.

## Why the finite core is the right boundary

The archived manuscript's finite objects are its only precisely specified data: the matrix entries (2) and the determinant `Δ_k`. The infinite operator, the Fredholm determinant and the Hurwitz passage are asserted with references to companion papers that are not in the archive. Formalising the finite algebra therefore gives a genuine, checkable fragment without pretending that the global claim has been verified.

[Back to the programme](../README.md) · [Topic index](../../README.md) · [Scraps](../../../scraps.html)
