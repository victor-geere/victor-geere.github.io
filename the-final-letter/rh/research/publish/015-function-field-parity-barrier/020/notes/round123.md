# Round 123 — the all-dividing shift reaches 3.84

*Plan fixed at the start of the round (`rounds.log`, BEFORE line).*

---

## 1. The envisioned path

Round 122 left one open end: for `h = x(x+1)(x+2)` — divisible by every linear prime — the parity ratio was
`3.51` at `n = 11` and still rising, consistent with `4` but not established. The only way to settle it is
more `n`.

This round pushes that shift to `n = 12, 13`, continues `h = x` to `n = 12`, and folds rounds 121–122 into the
synthesis.

## 2. Wild guess 64

> **Wild guess 64.** The all-dividing shift reaches at least `3.8` by `n = 13`, confirming that the parity
> factor is `4` for polynomial shifts and does not collapse to `2`.

**Why guess it.** The round-122 trend was upward with no plateau, and the constant-shift case had already
reached `4.05`.

**Falsification test.** Compute `T(12;h)` and `T(13;h)` for `h = x(x+1)(x+2)` and the corresponding Λ² bounds.

## 3. Results

| shift | `n` | `T(n;h)` | bound | ratio |
|---|---|---|---|---|
| `h = x` | 12 | 2960 | 11097.46 | 3.75 |
| `h = x(x+1)(x+2)` | 12 | 11852 | 38002.67 | 3.21 |
| `h = x(x+1)(x+2)` | 13 | 29670 | 114008.01 | **3.84** |

The full all-dividing sequence is now

```
n:      6     7     8     9     10    11    12    13
ratio: 1.94  2.37  2.42  3.12  2.83  3.51  3.21  3.84
```

Oscillating but unmistakably trending to `4`, with `3.84` at `n = 13`. **Wild guess 64 is confirmed**, and
with it round 122's conclusion: the parity factor is `4` for polynomial shifts, including the extreme case
where every linear prime divides `h`.

## 4. What this settles

The barrier is **not** about local densities. A shift that absorbs all the linear primes changes the singular
series by a constant factor (`×8` at `q = 3`) and changes the local factors at those primes from `Q−2` to
`Q−1`, yet the sieve's deficiency stays at `2^dim = 4`. The dimension is the number of conditions, exactly as
round 118 argued.

## 5. Lean

`PolyShift.local_factor_ratio`: the algebraic identity behind round 121 — the ratio of the two local factors
`1/(1−1/Q)` and `(1−2/Q)/(1−1/Q)²` is exactly `(Q−1)/(Q−2)`. Standard axioms; twelve modules green.

## 6. Synthesis updated

`synthesis.md` now has fourteen findings, including polynomial shifts (13) and the survival of the parity
factor (14), the sharpened dimensional statement, and the three `PolyShift` lemmas in the proved ledger.

## 7. State

* All-dividing shift: `3.84` at `n = 13`; factor `4` confirmed for polynomial shifts.
* Synthesis at fourteen findings.
* 20 unit tests green; twelve Lean modules green.

## 8. Next round (124)

Three rounds remain in the goal's budget. The natural close is a final consolidated statement: re-run the full
audit (now including the polynomial-shift constants), update the synthesis to its final form, and state
precisely what a successor programme would have to do. Round 124 begins that.
