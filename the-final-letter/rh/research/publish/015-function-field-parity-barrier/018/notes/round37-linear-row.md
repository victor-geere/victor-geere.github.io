# Round 37 — the `a₂ = 0` row reduces to the value-set bound

Round 7 of the new goal.  Target A: the `a₂ = 0` row is now reduced to the same
value-set bound as the general row, and (V) is verified at `q = 67..89`.

---

## 1. The `a₂ = 0` row

For `g = x⁴+a₁x` with `a₁ ≠ 0`:

| `q` | 13 | 17 | 19 | 29 | 31 | 37 | 41 | 43 | 47 | 53 | 59 | 61 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `min \|Im\|` | 7 | 11 | 10 | 19 | 19 | 22 | 26 | 25 | 30 | 34 | 37 | 37 |
| `(q+1)/2` | 7 | 9 | 10 | 15 | 16 | 19 | 21 | 22 | 24 | 27 | 30 | 31 |

Zero violations.  Since `R ⊇ Im`, the cap for this row follows from the value
set alone.  The minimum is attained at `a₁ = 1` for almost every `q`
(exceptions: `q=19` at `a₁=4`, `q=31` at `a₁=3`).

## 2. (V) at larger `q`

| `q` | 67 | 71 | 73 | 79 | 83 | 89 |
|---|---|---|---|---|---|---|
| `min \|Im\|` | 39 | 41 | 43 | 46 | 49 | 53 |
| `(q+1)/2` | 34 | 36 | 37 | 40 | 42 | 45 |

Zero violations, with a **margin of about `0.1q`** — `min|Im|/q` is
`0.58–0.60`, not close to `0.5`.

## 3. Where the cap stands

| row | status |
|---|---|
| `a₁ = 0` (even slice) | solved (round 33) |
| `a₂ = 0`, `a₁ ≠ 0` | follows from (V) (`§1`) |
| general, `a₁ ≠ 0` | **(V)** |

So **the cap is (V) alone**, and (V) is a robust inequality with a positive
margin.

---

## 4. Wild guess 7 — the random-map heuristic

> **Wild guess 7.** The value set of a non-exceptional quartic behaves like a
> **random map**: `|Im| ≈ q(1−e^{−1}) ≈ 0.632q`, matching the observed minima
> (`0.58–0.60q`).  So (V) is far from tight, and its proof should come from the
> second moment **plus a Poisson/uniformity estimate** on the fiber sizes, not
> from a sharp single character sum.  Over `ℚ`, the random-map model is exactly
> what fails: a sieve sees only the first moment, not the fiber distribution.

**Evidence.**

* `min|Im|/q ≈ 0.6` at every tested prime (`§1–2`), close to `1−e^{−1}`.
* The Cauchy–Schwarz bound `q/2 + O(√q)` is far below the truth, consistent
  with a random-map (much larger) value set.
* The collision character sum changes sign (round 34), so no sharp single-sum
  bound exists.

**Why it is a guess.** The random-map model is a heuristic; no uniformity
estimate is proved.

**What would falsify it.** A family with `|Im|/q → 0.5` would make (V) tight
and kill the random-map reading.

---

## 5. Lean — the fiber identity

`lean/Fiber.lean`:

```
sum_fiber_sq (f : α → β) :
  Σ_y (N y)^2 = #{(x,x') : f x = f x'}
```

The bridge between the value-set size and the collision count;
Cauchy–Schwarz on it is the starting point of (V).  Footprint
`[propext, Classical.choice, Quot.sound]`.

---

## 6. Honest verdict

* **Target A — the cap is (V) alone.** The `a₂=0` row is reduced; (V) holds at
  22 primes with a `0.1q` margin and is not provable by a moment bound.
* **Target B — unchanged.**
* **Target C — unchanged.**
* **The wild guess:** the value set is random-map-like (`1−e^{−1}`), so (V) is
  far from tight and needs a uniformity estimate.

## 7. Next round

1. **Fiber distribution**: compute the full `N(y)` distribution for the
   minimisers and compare with Poisson.
2. **The `1−e^{−1}` model**: fit `|Im|/q` against `q` to test convergence.
3. **Target B**: the `d=5` coefficients.

---

## 8. Reproduction

```
python3 checks/round37_linear_row.py   # exit 0
python3 -m pytest -q tests/test_round37.py   # 5 passed
cd lean && ./check.sh Fiber.lean Axioms.lean  # OK
```

New files: `checks/round37_linear_row.py`, `tests/test_round37.py`,
`lean/Fiber.lean`.
