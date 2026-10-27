# Round 122 — the parity factor survives polynomial shifts

*Plan fixed at the start of the round (`rounds.log`, BEFORE line).*

---

## 1. The envisioned path

Round 121 opened polynomial shifts. That changes the *local* structure: at a prime `Q | h` there is one
admissible residue instead of two. Since the parity factor `2^dim` was derived from "two admissible residues per
prime" (rounds 110, 118), the natural question is whether the factor drops when `h` absorbs the small primes.

The extreme case is `h = x(x+1)(x+2)` over `𝔽₃`, divisible by **every** linear prime. If the factor were
governed by the local counts rather than by the number of conditions, it should fall from `4` to `2`.

## 2. Wild guess 63

> **Wild guess 63.** The parity factor stays `4` for polynomial shifts: the dimension is the number of
> conditions, not the local density, so absorbing primes into `h` does not cross the barrier.

**Why guess it.** The factor `2^k` is a count of conditions (`k = 2` for a pair), and the local-density change
is a constant-factor correction absorbed into the singular series.

**Falsification test.** Compute the Λ² bound for `h = x` and `h = x(x+1)(x+2)` at level `n/2` and compare with
the exact counts.

## 3. Results

| shift | n=6 | 7 | 8 | 9 | 10 | 11 |
|---|---|---|---|---|---|---|
| `h = x` | 2.42 | 3.41 | 2.97 | 3.76 | 3.41 | **4.05** |
| `h = x(x+1)(x+2)` | 1.94 | 2.37 | 2.42 | 3.12 | 2.83 | **3.51** |

For `h = x` the ratio reaches `4.05` at `n = 11` — the constant-shift value. For the all-dividing shift it is
still rising at `3.51`; the approach is slower (its singular series is about eight times larger, so the finite-
`n` correction is relatively larger), but there is no sign of settling at `2`.

**Wild guess 63 is supported but not closed.** The `h = x` case confirms `4`; the all-dividing case is
consistent with `4` and inconsistent with a collapse to `2`, but larger `n` would be needed to pin it.

The counts also confirm round 121's singular series: `T(11; x(x+1)(x+2)) = 4566` against
`S_h q^n/n² ≈ 3.17 · 3^{11}/121 = 4560`.

## 4. Lean

`PolyShift.ratio_gt_one`: the correction `(Q−1)/(Q−2)` exceeds one, so a polynomial shift with prime factors
*raises* the singular series — which is why these counts are larger than for constant shifts. Standard axioms.

## 5. State

* First parity-factor measurement for polynomial shifts: `4.05` for `h = x` at `n = 11`.
* The all-dividing shift sits at `3.51` and rising — consistent with `4`, not with `2`.
* 20 unit tests green; twelve Lean modules green; standard axioms throughout.

## 6. Next round (123)

Either push the all-dividing shift to `n = 12–13` (expensive but decisive), or accept the open end and fold
this into the synthesis. Round 123 will attempt the larger `n` in the background while updating the synthesis
with rounds 121–122.
