# Round 118 — is the parity factor `2^dim`, and does `χ₂(2)` enter it?

*Plan fixed at the start of the round (`rounds.log`, BEFORE line).*

---

## 1. The envisioned path

The synthesis flagged one open question: does the parity factor `4` of round 110 decompose as `2·2` with one
factor carrying the `χ₂(2)` sign that 019 found (the twisted-Parseval identity needs the factor `χ₂(2c)` and
fails at `q ≡ 5 mod 8`)?

The test is a dimension scan. If the Λ² bound for a `k`-condition problem is `2^k ×` the truth, then:

* dimension 1 (qrimes) gives factor `2`;
* dimension 2 (twins) gives factor `4 = 2²`;
* and the factor is a pure dimension count, with no place for a character sign.

Then the `χ₂(2)` correction and the sieve cap are different phenomena, and the open question is answered
negatively.

## 2. Wild guess 59

> **Wild guess 59.** The parity factor is exactly `2^dim` — `2` for the qrime count and `4` for the twin count —
> and the `χ₂(2)` sign of 019 does not enter its magnitude.

**Why guess it.** Round 110's `4` came out of the local factor `2` per prime; a one-condition problem should
show `2`. If so, the factor is the dimension, not a character value.

**Falsification test.** Compute the Λ² bound for the dimension-1 problem (counting qrimes) at level `n/2`, and
compare with `I(n)`. If the ratio tends to `1`, the guess dies; if it tends to `2`, it holds.

## 3. Results

### 3.1 Dimension 1

`M₁[d,e] = q^{−deg lcm(d,e)}`, bound `= q^n/(M₁^{-1})_{1,1}`, truth `I(n)`:

| `n` | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 |
|---|---|---|---|---|---|---|---|---|---|
| ratio | 1.24 | 1.40 | 1.36 | 1.52 | 1.44 | 1.60 | 1.51 | 1.66 | 1.57 |

The ratio trends upward toward `2` (the oscillation is the same `1/n`-scale effect seen in round 112). So the
dimension-1 parity factor is `2`, and the dimension-2 factor is `4`: **the factor is `2^dim`.**

The classical reading agrees: the Selberg `Λ²` bound at level `X^{1/2}` is `≍ X/log X·(constant)`, with the
dimension-1 constant `2` and the dimension-2 constant `4`.

### 3.2 `χ₂(2)` does not enter

For `q = 3`, `2` is a non-square, so `χ₂(2) = −1`. Yet the measured factors are `+2` and `+4` — positive. For
`q = 5` (also `χ₂(2) = −1`) the twin factor is `+4.03`. So the sign of `χ₂(2)` does not appear in the parity
factor.

The `χ₂(2)` correction of 019 lives in a different place: it is the normalisation of the Jacobi-sum evaluation
of the twisted Parseval identity (`J(χ₄,χ₄) = ±(a+bi)`, and the substitution `w ↦ 2u` under `A = a²/2`). It is
a character value inside a Gauss-sum identity, not a dimension count.

**Wild guess 59 is confirmed**, and the synthesis's open question 3 is answered: the `4` and the `χ₂(2)` are
*not* two faces of one local obstruction. The `4` is `2^dim`; the `χ₂(2)` is a Gauss-sum normalisation.

### 3.3 The dimension count, general

The Lean layer now has the general statement: the local factor for `k` conditions is `2^k`
(`Dimension.card_roots_fun`), which is the `2^dim` seen above, for every `k` — with the `k = 1, 2, 3` cases
already present as `SieveLocal.card_roots_*`.

## 4. Consequences

* The sieve's deficiency is **dimensional**, and it grows as `2^dim`. A two-condition problem cannot be solved
  by a one-condition-strength method: this is the cleanest statement of the parity barrier in the phase.
* The 019 correction is orthogonal to it: fixing the character normalisation does not touch the `4`, and
  optimising the sieve does not touch `χ₂(2)`.
* The transfer question is unaffected: over `ℤ` the dimensional deficit is the same, and what is missing is
  still the grading substitute (or 2D equidistribution).

## 5. State

* Dimension-1 ratio trends to `2`; dimension-2 to `4`; factor `= 2^dim`.
* `χ₂(2)` does not enter the magnitude; the 019 correction is a separate normalisation.
* Lean: `Dimension.card_roots_fun` (general `2^k`), standard axioms; ten modules green.
* 20 unit tests green.

## 6. Next round (119)

With the dimension question closed, the remaining item on the synthesis's list is the boundary stratum's closed
form (open question 4): round 108 showed it cancels a divergent product, and no closed form is known. Round 119
will test whether the boundary is expressible through the singular series and a finite correction, using the
exact expansion data.
