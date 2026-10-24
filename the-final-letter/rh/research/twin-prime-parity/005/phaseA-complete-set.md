# Phase A — the complete set, and why completeness buys nothing

Script: [`phaseA_complete_set.py`](phaseA_complete_set.py) (exact `Fraction` arithmetic).

## A.1 The classification (necessary **and** sufficient)

Alphabet `w_k = 1/(k+2)`, strictly decreasing to `0`. Greedy with strictly increasing
indices: `k_1 = max(0, ⌈1/x⌉ − 2)`, and afterwards

```
k_j = max( k_{j−1} + 1 , ⌈1/r_{j−1}⌉ − 2 ) ,   r_{j−1} = x − Σ_{i<j} w_{k_i} .
```

Because the alphabet is infinite and tends to `0`, the greedy **never stops while the
residual is positive**: rationals terminate, irrationals give infinite words.

> **Theorem.** A strictly increasing word `k_1 < k_2 < …` is a greedy support **iff** for
> every `j` with `k_j > k_{j−1} + 1` (taking `k_0 = −1`):
> ```
> Σ_{i≥j} 1/(k_i + 2)  <  1/(k_j + 1) .
> ```

The condition is **not local in `k` alone** — it constrains the whole tail, because the
greedy constraint at step `j` involves the residual `Σ_{i≥j} w_{k_i}`.

**The plausible local law is false.** `k_{j+1} ≥ k_j² + 3k_j + 1` is a natural guess (it is
the Sylvester recursion in `k`-coordinates) and it is **wrong**: the greedy expansion of `1`
is `[0,1,4]` in `k`, i.e. `1 = 1/2 + 1/3 + 1/6`, and `4 < 1² + 3·1 + 1 = 5`. I asserted the
local law first and the sufficiency test returned `0/3000` — which is exactly how the error
was caught.

**Verification (both directions, exact):**

| test | count | result |
|---|---|---|
| necessity: exact expansions of rationals, denominators ≤ 80 | 19 361 terminating | **0** tail-law violations |
| sufficiency: law-satisfying words rebuilt from `x =` their exact sum | 4 000 | **4 000 / 4 000** reproduced |
| soundness: law-violating words | 10 589 | **0** realised |

## A.2 Corrections this forced

1. **The Sylvester word is not greedy.** `{2,3,7,43,1807,…}` sits exactly on the boundary:
   its tail equals the bound (`Σ_{i≥j} 1/s_i = 1/(s_j−1)` exactly, from the telescoping
   identity), so it is the **lazy/Sylvester** expansion, not the greedy one. The greedy
   expansion of `1` is `1/2 + 1/3 + 1/6`.
2. **"The Sylvester sequence is the unique infinite admissible word" is FALSE.** Two
   distinct infinite words of distinct letters sum to `1`:
   `1/2+1/3+1/7+1/43+… = 1` **and** `1/2+1/3+1/7+1/44+1/925+1/854701+… = 1` (verified: the
   residual after six terms is `1/730512944700`, and the lazy continuation closes it).
   Uniqueness holds only if admissibility *is defined* as the Sylvester recursion — a
   definition, not a theorem.
3. **The ladder targets are genuinely Sylvester-supported.** `x_m = (s_m−2)/(s_m−1)` has
   greedy support exactly `{s_0,…,s_{m−1}}`, verified exactly for `m = 2…5`
   (`41/42 → {2,3,7}`, `1805/1806 → {2,3,7,43}`, …).

## A.3 Does completeness buy anything for zero location?

**No, and this is a theorem, not an opinion.** `x ↦ A(x)` is a bijection onto admissible
words, so replacing `cos θ_n` by `Re Π_{k∈A_n} e^{iα_k}` is a **deterministic bijective
recoding** of the phase. The identity

```
Π_{k∈A_n} e^{iα_k} = e^{i Σ_{k∈A_n} α_k} = e^{iθ_n}
```

is a tautology; the sum is still over `n`, term by term identical. "Completeness" of the
support set is completeness of a coordinate change.

Worse for the hope: the supports are **not** a special sparse family. Since
`{t log n / π}` equidistributes, the supports range over essentially all greedy words. A
"complete set" at height `t` is the finite union `U_N = ⋃_{n≤N} A_n(t)` — e.g. `|U_200| = 381`
elements with max index `9.6·10⁶` at `t = 14.13` — and feeding it into the sum changes
nothing.

## A.4 What the classification does settle

- It closes `(a)` of the goal: a complete characterisation exists, is elementary, and is
  **information-free** for zeros.
- It removes two claims from the record (the local law, and uniqueness of the infinite
  word) that had been asserted in earlier write-ups.
- It gives the correct home for the Sylvester sequence: not the greedy expansion of `1`, but
  the **extremal/boundary** word and the natural support of the ladder targets.

*Status — THEOREM: the tail admissibility law (necessity and sufficiency). EXACT
NUMERICS: the three verification tables, the two words summing to `1`, the ladder-target
supports. CORRECTED: the local law `k_{j+1} ≥ k_j²+3k_j+1`; "unique infinite admissible
word". REFUTED (as a route): completeness as a zero-location tool.*
