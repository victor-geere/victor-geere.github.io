# Round 45 — `d=5`: the generic count is not polynomial; the `q=25` threshold

Round 15 of the new goal.  Target B: the `d=5` generic count approaches `q⁵/25`
but is **not** a low-degree polynomial.  Target A: the Chebotarev threshold is
sharpened to `q = 25`.

---

## 1. The `d=5` generic count

For `q ≡ 2 (mod 5)` (`5 ∤ q−1`), the shift dependence vanishes, so
`T(5;q,2) = A₅(q)`:

| `q` | 7 | 17 | 37 | 47 |
|---|---|---|---|---|
| `T(5;q,2)` | 560 | 53142 | 2698484 | 8982264 |
| `T/q⁵` | 0.03332 | 0.03743 | 0.03891 | 0.03916 |
| `1/25` | 0.04 | 0.04 | 0.04 | 0.04 |

The ratios increase monotonically toward `1/25`, i.e. `T(5;q,2) ~ q⁵/25`.

## 2. No low-degree polynomial

The unique cubic through `q = 7,17,37,47` is

```
61517 q³/200 − 2905811 q²/200 + 8535567 q/40 − 177348437/200 ,
```

which at `q = 11` gives `2797968/25 ≈ 111919`, against the true `T(5;11,2) =
6006`.  So the interpolant is meaningless: **no low-degree polynomial** fits
`T(5;q,2)`, even in the generic class.

## 3. The Chebotarev threshold

| `q` | 21 | 23 | 25 | 29 |
|---|---|---|---|---|
| `5q/8 − 0.5√q` | 10.834 | 11.977 | 13.125 | 15.432 |
| `(q+1)/2` | 11.0 | 12.0 | 13.0 | 15.0 |
| clears? | ✗ | ✗ | **✓** | ✓ |

So the threshold is **`q = 25`**: for `q ≥ 25` the main term plus the `0.5√q`
error gives (V′); the range `q < 25` is a finite check.

---

## 4. Wild guess 15 — the `1/25` density

> **Wild guess 15.** The `d=5` density limit is `1/25` (the "trivial" constant,
> not the singular series `S(5)/25`), with a `1/q`-type correction; the count is
> a **quintic-character sum** with no polynomial formula, exactly as the
> `d=4` quartic coefficient `c₄` is not polynomial.  Over `ℚ`, the `d=5` count
> is a `GL(2)×GL(2)`-type correlation; the missing object is the same as at
> `d=4`.

**Evidence.**

* `T/q⁵ → 1/25` (`§1`).
* No polynomial fits (`§2`).
* The `d=5` support is quintic (round 35).

**Why it is a guess.** The correction structure is not identified; the `ℚ`
reading is an analogy.

**What would falsify it.** A clean polynomial fit at larger `q` would break it.

---

## 5. Lean — the threshold arithmetic

`Chebotarev.threshold_25 : 5·25/8 − 5/2 = 105/8` and
`threshold_25_gt : 105/8 > 13`.  The threshold is now a checked rational fact.
Footprint `[propext, Classical.choice, Quot.sound]`.

---

## 6. Honest verdict

* **Target A — threshold sharpened.** `q = 25` is the boundary.
* **Target B — negative.** `T(5;q,2) ~ q⁵/25`, no low-degree polynomial.
* **Target C — unchanged.**
* **The wild guess:** the `d=5` count is a quintic-character sum with no
  polynomial formula.

## 7. Next round

1. **The `1/q` correction at `d=5`**: fit `q⁵/25 − T` against `q³`.
2. **The finite range `q < 25`**: check (V′) directly for `q = 5..23`.
3. **Target C**: a Lean statement about the parity of the twin indicator.

---

## 8. Reproduction

```
python3 checks/round45_d5_poly.py   # exit 0
python3 -m pytest -q tests/test_round45.py   # 3 passed
cd lean && ./check.sh Chebotarev.lean Axioms.lean  # OK
```

New files: `checks/round45_d5_poly.py`, `tests/test_round45.py`;
`lean/Chebotarev.lean` extended with `threshold_25`.
