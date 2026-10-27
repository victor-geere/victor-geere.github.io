# 008 — Attempting an automorphic/spectral input for the twin-prime parity problem

Attack on dictionary `03` §5.4, route 3, for the shift-2 Liouville correlation
`S(x) = Σ_{n≤x} λ(n)λ(n+2)`.

**Read in this order.** [`notes/automorphic-spectral-attempt.md`](notes/008/automorphic-spectral-attempt.md)
→ `handoff.md` → `index.html` →
`lean/README.md`.

## Verdict (the honest headline)

**The attempt does not break the parity barrier over ℚ — and it says exactly why.**
The automorphic/spectral input is *not hypothetical*: over `𝔽_q[T]` it is realised
and parity **is** broken, by geometric methods (Sawin–Shusterman, arXiv:1808.04001,
arXiv:2008.09905). Over ℚ it fails because

* `L(s,λ) = ζ(2s)/ζ(s)` is a ratio of `ζ`: there is **no automorphic/sheaf object**
  with Hecke eigenvalues `λ`, hence no monodromy and no spectral bilinear input; and
* the only parity-breaking signs any `L`-function detects over ℚ are **Dirichlet
  characters**, which are periodic mod `q` and therefore **parity-blind**
  (dictionary Theorem 2.2).

So route 3 **reduces to routes 1–2** (Type-II/bilinear, or equidistribution to
large moduli) over ℚ.

## What is new and machine-checked

The open core of the correlation is a **quadratic-polynomial** sum:

```
S_2(x) = S_1(⌊x/2⌋) + C(⌊(x+1)/2⌋) ,       C(K) = Σ_{k≤K} λ(4k² − 1)
```

proved in Lean (`Op58.Sh2_split`, `Op58.Ccore_eq_poly`; 0 `sorry`, 0 `axiom`,
footprint `propext, Classical.choice, Quot.sound`) and verified numerically with
discrepancy exactly 0. This removes the "no Euler product" obstruction as an
excuse: the problem becomes `Σ μ/λ` over a quadratic polynomial, the canonical
target of spectral methods.

## Evidence

* Weil/Deligne square-root cancellation over `𝔽_p` (Kloosterman `≤ 2√p`, Gauss
  `= √p`) verified exactly — the engine of the function-field proof.
* `𝔽_q[T]`: Chowla correlation cancels and twin irreducibles exist at the
  Bateman–Horn scale — **theorems** there, **open** over ℚ.
* Level of distribution of `λ` over ℚ crosses over at `q ≈ √x` (empirical
  `θ = 1/2`); the twin-prime sieve needs `θ > 1/2`.
* `C(K) = Σ λ(4k²−1)` cancels like `√K` empirically; `C(K)=o(K)` is open.

Nothing here bears on the Riemann Hypothesis. Finite computations prove nothing
about asymptotics (dictionary F4).
