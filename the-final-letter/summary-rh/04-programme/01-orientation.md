# Programme orientation

> Source: [`research/twin-prime-parity/README.md`](../../rh/research/twin-prime-parity/README.md).

## The one-paragraph summary

The *greedy harmonic sine* (rh41/rh42) is a rich object: a proved factor-complexity
law, a parity-locked signed support, zeta-valued budgets with sharp completeness
thresholds, and an exact reachability theory.  The *parity obstruction* (rh46) is a
statement about a multiplicative function: `λ(n) = (−1)^{Ω(n)}`, with
`Σ_{n≤x}λ(n)λ(n+2) = o(x)` **open**.  The programme's own results show the two do not
meet: the greedy support carries no `λ`-parity signal above a size-matched control;
the ζ budgets separate *index* parity, which is invisible to the correlation; the
correlation has no Euler product; and the greedy support is **Sylvester-sparse**
(`m_{i+1} ≥ m_i(m_i−1)+1`), so it cannot be the positive-density witness that `o(x)`
would require.  What a successful attack needs is a *sign-blind rule with a
positive-density multiplicative coupling to `Ω`* — which is exactly what is missing.

## Status of the programme, by round

| round | object | outcome | Lean |
|---|---|---|---|
| rh40 | the factor-complexity law `p(L)` of the greedy word | K1 plateau + C1 regime (computed) | — |
| rh41 | the same law, closed | Theorems 1–12 | **certified** (7 modules, 144 declarations) |
| rh42 | the signed Tau alphabet, budgets, reachability, helix | budgets, Brown's criterion, thresholds `p*, q`, parity lock | **certified** |
| rh43 | partial sums at `Re(S) = 0`; the equal split | balance ⟺ `Re S_N(t)=0`; attainable `N≥2`; linear divergence | **certified** (38 theorems) |
| rh044 | smoothing | **smoothing does not remove `√N`**; functional equation needed | **certified** |
| rh45 | the explicit formula, used explicitly | correct Weil form (with the archimedean term); zeros via the formula | **certified** |
| rh46 | two-point Chowla `Σλ(n)λ(n+2)` | **OPEN**; finite-prefix indeterminacy proved; no Euler product | **certified** (42 theorems; no unproved statement — OP-11 closed) |
| rh47 | greedy sine vs parity | the Sylvester-sparsity theorem; bridges B1–B3 refuted; barrier stated | **certified** — `lean/Rh47/Sparse.lean` proves the corrected sparse bound (OP-12) |
