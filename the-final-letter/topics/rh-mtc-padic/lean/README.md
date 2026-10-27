# Lean formal core — RH-MTC / p-adic MTC

## Build

```bash
cd the-final-letter/topics/rh-mtc-padic
./lean/check.sh 2>&1 | tee lean/BUILD.log
```

The wrapper calls the shared `../../tools/check-lean.sh`, which elaborates against the local Mathlib installation (`~/lean/mathlib4`, Lean `v4.35.0-rc2`). The committed `BUILD.log` records the last successful check.

## What is formalised

`Topic.lean` imports Mathlib, opens the namespace `PadicMTC`, and defines

```lean
def rtWeight (p : ℕ) (n : ℕ) : ℝ := 1 / (p : ℝ) ^ n
```

This is the source's proposed normalised local Reshetikhin–Turaev weight `w_p(n) = p^{-n}` for a length-`n` periodic orbit at the prime `p`.

Proved (no `sorry`, `axiom`, or `admit`):

| Name | Statement |
|---|---|
| `PadicMTC.rtWeight_pos` | `0 < rtWeight p n` for `0 < p` |
| `PadicMTC.rtWeight_mul` | `rtWeight p (n+m) = rtWeight p n * rtWeight p m` |
| `PadicMTC.rtWeight_strictAnti` | for `1 < p`, `n ↦ rtWeight p n` is strictly decreasing |
| `PadicMTC.rtWeight_le_one` | `rtWeight p n ≤ 1` for `1 ≤ p` |
| `PadicMTC.partial_sum_bookkeeping` | `(1 - w_p(1)) * Σ_{k<N} w_p(k) = 1 - w_p(N)` |
| `PadicMTC.hasSum_rtWeight` | `Σ_n w_p(n) = p/(p-1)` for `1 < p` |
| `PadicMTC.rtWeight_tendsto_zero` | `w_p(n) → 0` as `n → ∞` for `1 < p` |

The last two are the finite and infinite forms of the local Euler-factor bookkeeping at `s = 1`:

```
(1 - p^{-1}) * p/(p-1) = 1.
```

All proofs are elementary: positivity, monotonicity of powers, `inv_lt_inv`, `pow_le_one₀`, a geometric-series telescoping induction, and Mathlib's `hasSum_geometric_of_lt_one`.

## What is *not* formalised

- **The geometric RT invariant.** The source asserts `RT_{C_p}(β) = p^{-n}`, but it does not define the braid `β`, its framing, or its Seifert data. The Lean theorems are about the explicitly defined bookkeeping weight `rtWeight`, not about a constructed topological invariant. The gap is recorded as open item O1/O3 in the programme README.
- **The periodic-orbit count `p^n + 1`.** No tree-orbit formalism is set up, and the source's count is not derived. It remains a source claim (S2).
- **The local Fredholm determinant.** No operator on `ℓ²(V(T_p))` is defined, so `det(1 - L_{p,s}) = (1 - p^{-s})^{-1}` is not a Lean statement here. Only the `s = 1` weight series is formalised.
- **The global restricted tensor product and determinant `ζ̂(s) e^{P(s)}`.** Not formalised.
- **The functional equation, self-adjointness, entropy/Perron–Frobenius argument, and winding number.** Not formalised.
- **The Riemann hypothesis.** It is an archived claim of the source and is not proved in this file or anywhere in this reconstruction.

The archived appendix Gauss-sum identity `Σ_j d_j θ_j S_{jj'} = τ_p S_{0j'}` also fails numerically for small primes; see computation C6 and `python/programme.py::archived_gauss_sum_residual`. It is not used in the Lean development.

## Why the core is small

The source's local weight `p^{-n}` is arithmetic, and the only rigorous statements immediately available about it are the order, multiplicativity, and geometric-series facts above. The genuinely topological and operator-theoretic content of the source is not present in a form that can be formalised: the companion thesis is a `TODO` skeleton and the obstruction notes concede a mismatch in the Gauss-sum step. Building a larger Lean file would therefore require inventing the missing definitions, which would misrepresent the source. The finite MTC data (quantum dimensions, `S`-matrix, exact sine sums) are checked computationally in `python/programme.py` and `tests/test_programme.py`; formalising trigonometric finite sums and roots of unity in Lean is left as future work rather than faked with axioms.

[Back to the programme](../README.md) · [Topic index](../../README.md)
