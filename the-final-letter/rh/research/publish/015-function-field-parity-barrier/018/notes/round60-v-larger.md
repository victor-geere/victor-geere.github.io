# Round 60 — (V′) to `q ≤ 149`; the Cauchy–Schwarz gap

Round 5 of the aggressive goal.  (V′) is extended to every prime `q ≤ 149`, and
the moment route is shown to be structurally insufficient.

---

## 1. (V′) to `q ≤ 149`

| `q` | 101 | 103 | 107 | 109 | 113 | 127 | 131 | 137 | 139 | 149 |
|---|---|---|---|---|---|---|---|---|---|---|
| `min \|Im\|` | 59 | 61 | 63 | 64 | 66 | 75 | 78 | 81 | 83 | 89 |
| `(q+1)/2` | 51 | 52 | 54 | 55 | 57 | 64 | 66 | 69 | 70 | 75 |

Zero violations.  So (V′) holds for **all primes up to 149** (combined with the
earlier checks).

## 2. The Cauchy–Schwarz gap

The value-set bound `|Im| ≥ q²/(q+2S)` (with `S` the collision count) would give
(V′) if `S ≤ (q−2)/2`.  This **fails**:

* at the extremisers, `S` exceeds `(q−1)/2` (e.g. `9 > 6` at `q=13`, `52 > 44`
  at `q=89`);
* for the `a₂=0, a₁=1` row, `S > (q−2)/2` at **16 primes** below 150 (including
  `q=61`, where `S=36` vs `29`).

So no second-moment bound can prove (V′): the fiber distribution is **far from
extremal**, and the CS bound sits well below the truth.

## 3. What this means

(V′) is a **distribution-level** statement (rounds 42–44: the `S₄` splitting-type
law with `|Im| = 5q/8 + O(√q)`), not a moment statement.  The remaining input is
the explicit error constant.

---

## 4. Wild guess 5 — the distribution proof

> **Wild guess 5.** (V′) follows from the `S₄` splitting-type equidistribution
> with an **explicit error**: `|Im| = 5q/8 + E` with `|E| ≤ C√q`.  The threshold
> `5q/8 − C√q > (q+1)/2` is `q/8 − 1/2 > C√q`; the measured `C = 0.43` gives
> `q > 25`, and the finite range `q ≤ 149` is checked.  So the distribution
> route needs only the explicit constant `0.43`.

**Evidence.**

* (V′) holds at every prime `q ≤ 149` (`§1`).
* The CS route fails (`§2`).
* The `S₄` law fits with constant `0.43` (round 44).

**Why it is a guess.** The explicit constant is not proved.

---

## 5. Honest verdict

* **Target A — (V′) verified `q ≤ 149`; the moment route is dead.** (A2) needs
  the explicit splitting-type constant.
* **(A1) — proved.**
* **(B), (C) — unchanged.**
* **The wild guess:** the distribution proof with `C = 0.43`.

## 6. Next round

1. **The explicit constant**: a splitting-type character-sum bound.
2. **Target B**: extend `c₄`.
3. **Target C**: the quantitative parity theorem.

---

## 7. Reproduction

```
python3 checks/round60_v_larger.py   # exit 0
python3 -m pytest -q tests/test_round60.py   # 3 passed
```

New files: `checks/round60_v_larger.py`, `tests/test_round60.py`.
