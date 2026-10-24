# The twin-prime parity programme — executive summary

*One page. Written at round 125 of phase 020.*

---

## What was investigated

Whether the twin prime problem's **parity barrier** can be measured — and crossed — in the polynomial model
`𝔽_q[x]`, where "primes" are monic irreducibles (qrimes) and "twin primes" are pairs `(f, f+2)`.

## What was found

1. **The barrier is real and dimensional.** The zeta determines only linear statistics, so it cannot see the
   twin count (018). The best square-weight sieve is exactly `2^dim` times the truth: `2` for qrimes, `4` for
   twins (020). It is the *number of conditions* that costs, not the local densities — verified by polynomial
   shifts that absorb every small prime and still give `4`.
2. **Every standard mechanism was measured.** `Λ²`: factor `4`. Bilinear pair weight: indefinite, no bound.
   Degree windows: no `L^{−1/2}` cancellation. Large sieve: slack of order `n`. There is no standard route left
   untested in this model.
3. **The counting framework is exact.** The twin count has an exact coprime-pair expansion with an explicit
   boundary stratum; the degree grading makes the Legendre sieve exact at `y = n/2`. Both are Lean-certified.
4. **The main term is right.** `T(n) = S(q)q^n/n² + E(n)` with `|E|/q^{n/2} ∈ [0.008, 0.30]` for `n ≤ 14` at
   `q = 3` (`T(13) = 3747`, `T(14) = 9510`). The fixed-`q` asymptotic is *conjectural* in the literature; the
   programme supplies the numerics any proof must match.
5. **The 019 identity is now sharp.** The twisted-Parseval identity holds exactly at `q ≡ 1 (mod 8)` and fails
   otherwise; the corrected `χ₂(2c)` form holds at all 80 primes tested. Proving it remains open.

## The one conclusion

**The barrier is not a missing estimate; it is a missing object.** Over `𝔽_q[x]` the crossing mechanism is
two-dimensional equidistribution of `(f, f+2)` — supplied by the Frobenius. Over `ℤ` the corresponding demand
is a **grading substitute**: a canonical, error-controlled truncation of the Möbius sum. Every standard `ℤ`
method is blocked exactly there.

## What is proved, and what is measured

* **Proved** (Lean 4, standard axioms, 13 modules across phases 019–020): the separation witness, the parity
  theorem, the grading lemma, the boundary `0/1` lemma, the local-factor family `2^k`, the local-factor
  dichotomy, the shift law's two halves, the window algebra, the `(Q−1)/(Q−2)` correction.
* **Measured** (exact finite computation, 35 audited claims): the factor `4`, the error ratios, the orbit
  counts, the large-sieve slack, the polynomial-shift series.
* **Not proved**: the fixed-`q` twin asymptotic, its polynomial-shift version, the 019 identity.

## Where everything is

```

├── PROGRAMME-SYNTHESIS.md   cross-phase synthesis (018/019/020)
├── 018/                     source programme: 106 notes, 45 Lean modules, 111 checks
├── 019/                     the χ₂(2c) test: exact, 80 primes, Lean splitting step
├── 020/                     phase 020: 18 rounds, 13 Lean modules, 20 tests, 35-claim audit
├── rounds.log               one line before and after every round
└── objectives.json          objective and round ledger
```

## Verification in one command

```
cd 020
python3 checks/audit.py && python3 -m unittest discover -s tests && cd lean && ./check.sh *.lean
```

## What to do next

Formalise the 2D-equidistribution input (the mechanism that actually proves the function-field statement);
attack the fixed-`q` asymptotic; search for a grading substitute over `ℤ`. The sieve direction is closed.
