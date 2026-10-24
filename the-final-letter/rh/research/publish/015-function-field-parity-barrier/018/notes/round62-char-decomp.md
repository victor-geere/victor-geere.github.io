# Round 62 — the exact `S₄` character decomposition of the value set

Round 7 of the aggressive goal.  Target (A2): the `S₄` error splits into **three
character sums**, and one of them vanishes identically.

---

## 1. The decomposition

For a quartic `g` with `S₄` monodromy, the indicator `1_{k≥1}` (the fiber is
nonempty) is a class function on `S₄`.  Decomposing it in the character basis:

```
1_{k≥1}  =  5/8·1  +  1/8·sign  +  3/8·std  −  1/8·(std⊗sign)  −  1/4·χ₂ .
```

Verified on all five classes (coefficients `(5/8, 1/8, 3/8, −1/8, −1/4)`).

Taking `Σ_y`:

```
|Im(g)|  =  5q/8  +  (1/8)S_sign  +  (3/8)S_std  −  (1/8)S_{std⊗sign}  −  (1/4)S_{χ₂}
```

where `S_χ = Σ_y χ(Frob_y)`.

## 2. The `std` sum vanishes identically

```
S_std  =  Σ_y (N(y) − 1)  =  Σ_y N(y) − q  =  q − q  =  0 .
```

So the `S₄` error is **three** character sums, not four:

```
|Im(g)|  =  5q/8  +  (1/8)S_sign  −  (1/8)S_{std⊗sign}  −  (1/4)S_{χ₂}  +  O(1) ,
```

the `O(1)` being the at most three critical values (where the quartic has a
double root and the Frobenius is ramified).

## 3. The sign sum is a **cubic** character sum

The discriminant of `g(x)−y` is a **cubic** in `y`:

```
Δ(y) = −256y³ − 128a₂²y² − (144a₂a₁² + 16a₂⁴)y − (27a₁⁴ + 4a₂³a₁²) .
```

So `S_sign = Σ_y χ₂(Δ(y))` is a cubic character sum, and by Weil

```
|S_sign|  ≤  2√q .
```

## 4. What remains for (A2)

```
|Im| − 5q/8  =  (1/8)S_sign − (1/8)S_{std⊗sign} − (1/4)S_{χ₂} + O(1) .
```

* `S_sign` is cubic: `≤ 2√q`.
* `S_{χ₂}` is the trace on the 2-dimensional representation (the resolvent
  cubic family).
* `S_{std⊗sign}` is the sign-twisted standard sum.

To get the constant `< 0.5`, one needs a bound `|S_sign − S_{std⊗sign}| + 2|S_{χ₂}| ≤ 4√q`.

---

## 5. Wild guess 6 (refined) — the three sums cancel

> **Wild guess 6.** The three sums are not independent: `S_{std⊗sign}` is the
> sign-twist of `S_sign` on the same cubic, and `S_{χ₂}` is the resolvent-cubic
> trace.  Their combination cancels to order `O(√q)` with constant `< 0.5`
> (measured `0.43`), because the cubic `Δ(y)` has **repeated roots** at the
> branch points, so the Weil bound `2√q` is not attained.  If the cancellation
> is proved, (A2) follows.

**Evidence.**

* The exact decomposition (`§1–2`).
* `S_sign` cubic, `≤ 2√q` (`§3`).
* Measured total error `0.43√q < 0.5√q`.

**Why it is a guess.** The cancellation is not proved.

**What would falsify it.** A family with error constant `≥ 0.5`.

---

## 6. Honest verdict

* **Target A — the error is three cubic/resolvent sums.** `S_std = 0`
  identically; `S_sign` cubic.
* **(A1) — proved.**
* **(B), (C) — unchanged.**
* **The wild guess:** the three sums cancel to `< 0.5√q`.

## 7. Next round

1. **Bound `S_{χ₂}`** via the resolvent cubic.
2. **Bound `S_{std⊗sign}`**.
3. **Target B**: extend `c₄`.

---

## 8. Reproduction

```
python3 checks/round62_char_decomp.py   # exit 0
python3 -m pytest -q tests/test_round62.py   # 2 passed
```

New files: `checks/round62_char_decomp.py`, `tests/test_round62.py`.
