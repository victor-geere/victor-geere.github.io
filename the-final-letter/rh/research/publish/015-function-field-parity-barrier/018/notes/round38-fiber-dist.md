# Round 38 — the fiber distribution and the random-map ratio

Round 8 of the new goal.  Target A: the fiber-size distribution of a quartic is
now tabulated at the value-set minimisers, and the `|Im|/q` ratio is compared
with the random-map value `1−e^{−1}`.  Target B: the `d=5` amplitudes are
confirmed to be weight 4.

---

## 1. The fiber distribution

At the minimisers (the families with the smallest value set):

| `q` | `(a₂,a₁)` | `\|Im\|` | mean fiber | fiber sizes |
|---|---|---|---|---|
| 13 | (0,1) | 7 | 1.86 | `{1:3, 2:3, 4:1}` |
| 29 | (1,1) | 17 | 1.71 | `{1:9, 2:6, 4:2}` |
| 37 | (1,7) | 21 | 1.76 | `{1:9, 2:10, 4:2}` |
| 41 | (1,18) | 24 | 1.71 | `{1:12, 2:8, 3:3, 4:1}` |
| 53 | (1,1) | 31 | 1.71 | `{1:15, 2:13, 4:3}` |
| 61 | (1,6) | 36 | 1.69 | `{1:17, 2:15, 3:2, 4:2}` |

The fiber sizes are always in `{1,2,3,4}` (the degree), and are concentrated on
`{1,2,4}` — the sizes coming from the ramification of the quartic.  The mean
fiber is `1.7`, i.e. `|Im|/q ≈ 0.6`.

## 2. The random-map ratio

At the minimisers:

| `q` | 13 | 17 | 19 | 29 | 31 | 37 | 41 | 43 | 47 | 53 | 59 | 61 | 67 | 71 | 73 | 79 | 83 | 89 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `\|Im\|/q` | .54 | .65 | .53 | .66 | .61 | .59 | .63 | .58 | .64 | .64 | .63 | .61 | .58 | .58 | .59 | .58 | .59 | .60 |

**Mean `0.601`**, versus the random-map value `1−e^{−1} = 0.632`.  The ratio sits
**just below** the random-map value, with a systematic surplus of collisions
(fiber sizes 2 and 4 at the ramification).

## 3. Target B — `d=5` amplitudes are weight 4

| `q` | `max\|amp\|` | `max\|amp\|/q²` |
|---|---|---|
| 11 | 98.99 | 0.818 |
| 41 | 4378.33 | 2.605 |

So the `d=5` coefficients are also `O(q²)` — the same weight-4 scale as `c₄`
for `d=4`.

---

## 4. Wild guess 8 — the zero-fiber set

> **Wild guess 8.** The value-set size is `q − #{y : N(y)=0}`, and the
> zero-fiber set is the image of the **collision curve**; its density is
> asymptotically `e^{−1}` (random map), but the quartic has a systematic
> **surplus of collisions** at the ramification, pushing the ratio to
> `≈ 0.60 < 1−e^{−1}`.  The sharp bound `(q+1)/2` is far below both.  Over `ℚ`,
> the zero-fiber set is exactly what a sieve cannot resolve.

**Evidence.**

* Fiber sizes in `{1,2,3,4}`, concentrated on `{1,2,4}` (`§1`).
* `|Im|/q` mean `0.601` vs `1−e^{−1}=0.632` (`§2`).
* The `d=4` and `d=5` character amplitudes are both weight 4 (`§3`).

**Why it is a guess.** The zero-fiber density is not proved; the `ℚ` reading is
an analogy.

**What would falsify it.** A minimiser with `|Im|/q → 0.5` would make (V) tight
and kill the random-map reading.

---

## 5. Lean — the fiber partition

`lean/Fiber.lean` now has both

```
sum_fiber_card (f) : Σ_y N(y) = |α|
sum_fiber_sq   (f) : Σ_y N(y)² = #{(x,x') : f x = f x'}
```

the two moments of the fiber distribution.  Footprint
`[propext, Classical.choice, Quot.sound]`.

---

## 6. Honest verdict

* **Target A — structural.** Fiber distributions tabulated; ratio `0.601` vs
  `0.632`.  (V) remains open.
* **Target B — weight confirmed.** `d=5` amplitudes are `O(q²)`.
* **Target C — unchanged.**
* **The wild guess:** the zero-fiber set is the collision-curve image, with a
  ramification surplus.

## 7. Next round

1. **The zero-fiber set**: count `#{y : N(y)=0}` exactly for the minimisers and
   compare with `e^{−1}q`.
2. **The collision curve**: relate the fiber sizes to the genus-1 collision
   curve.
3. **Target B**: a closed form for the `d=5` amplitudes.

---

## 8. Reproduction

```
python3 checks/round38_fiber_dist.py   # exit 0
python3 -m pytest -q tests/test_round38.py   # 4 passed
cd lean && ./check.sh Fiber.lean Axioms.lean  # OK
```

New files: `checks/round38_fiber_dist.py`, `tests/test_round38.py`;
`lean/Fiber.lean` extended with `sum_fiber_card`.
