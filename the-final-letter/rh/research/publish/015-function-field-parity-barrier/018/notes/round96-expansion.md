# Round 96 — Target B: the exact Gauss-sum expansion of `B̂(c)`

Round 40 of the aggressive goal.  The proof route to `m = (a²+1)/2` begins with
an **exact expansion** of the Fourier transform of `B(a₂)`.

---

## 1. The expansion

With `1_{χ₂=−1} = (1−χ₂)/2` (which takes the value `1/2` at `0`, not `0`), the
product `(1−χ₂(b))(1−χ₂(a₂²−4b))/4` differs from the indicator of `B(a₂)` only
at the **boundary** `b = 0` and `a₂²−4b = 0`.  Hence

```
B̂(c)  =  (1/4)[ T1 − T2 − T3 + T4 ]  −  (1/4)·boundary ,
```

where

```
T1 = Σ_b ζ^{cb} = 0  (c ≠ 0) ,
T2 = Σ_b χ₂(b) ζ^{cb}            = χ₂(c)·G ,
T3 = Σ_b χ₂(a₂²−4b) ζ^{cb}       = χ₂(−c)·G·ζ^{c a₂²/4} ,
T4 = Σ_b χ₂(b)χ₂(a₂²−4b) ζ^{cb}  = ζ^{c a₂²/4}·H(a₂,c) ,
```

with `G = G(χ₂) = √q` and `H(a₂,c) = Σ_u χ₂(u)χ₂(a₂²−u)ζ^{−cu/4}`.

**Verified exactly** for all `a₂` and `c = 1,3` at `q = 17`.

## 2. Why the boundary matters

The boundary correction is `−1/4` per `b ∈ {0, a₂²/4}`, i.e. `O(1)` per `a₂`.
Without it the expansion is off by exactly `1/4` at `a₂ = 0` — the discrepancy
found in the first attempt.

## 3. What remains

`S_c = Σ_{a₂}|B̂(c)|²`.  The dominant terms are `|T2|² = |T3|² = q` and the cross
term `2Re(T2 conj(T3))`, whose `a₂`-sum is a **quadratic Gauss sum**:

```
Σ_{a₂} ζ^{−c a₂²/4}  =  χ₂(−c)·G .
```

The `T4` term and the boundary corrections are `O(1)` per `a₂`.

---

## 4. Wild guess 37 — the leading terms give `m`

> **Wild guess 37.** The `a₂`-sum of the cross terms evaluates, via the
> quadratic Gauss sum, to `χ₂(−c)·q·G = χ₂(−c) q√q`; combined with the `T4`
> term (which contributes `−q√q·(a²+1)/2` after the Jacobi-sum evaluation), the
> coefficient of `√q` in `S_c` is `m = (a²+1)/2`.

**Evidence.** The exact expansion (§1) and the classical Jacobi sum
`J(χ₄,χ₄) = ±(a+bi)` (round 39).

## 5. Honest verdict

* **Target B — the exact expansion is in place.**  The proof of `m`'s formula now
  reduces to evaluating the `a₂`-sum of the cross terms.
* **(A) — cap assembled.**
* **(C) — parity theorem complete for the divisor-sum class.**

## 6. Next round

1. **The `a₂`-sum of the cross terms.**
2. **A final synthesis.**

---

## 7. Reproduction

```
python3 checks/round96_expansion.py   # exit 0
python3 -m pytest -q tests/test_round96.py   # 1 passed
```

New files: `checks/round96_expansion.py`, `tests/test_round96.py`.
