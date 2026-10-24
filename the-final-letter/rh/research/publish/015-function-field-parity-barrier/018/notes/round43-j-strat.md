# Round 43 — the `j`-stratification: `j=0` is the only exception

Round 13 of the new goal.  Target A is now reduced to a single clean statement:
the cap holds for every **non-composition** quartic, and the composition case
(`j = 0`) is already solved.

---

## 1. The stratification

For each `j`-class at `q = 29, 37, 41`:

| `q` | `j=0` ratio | `j=0` `χ²` | `j≠0` min ratio | `j≠0` median `χ²` | `j≠0` max `χ²` |
|---|---|---|---|---|---|
| 29 | 0.379 | 17.0 | 0.586 | 1.72 | 3.89 |
| 37 | 0.378 | 22.3 | 0.568 | 1.03 | 4.16 |
| 41 | 0.390 | 22.8 | 0.585 | 1.48 | 4.44 |

**`j = 0` is the unique outlier**: ratio `≈ 0.38`, chi-square `17–23` — it does
not follow the `S₄` law.  Every `j ≠ 0` is `S₄`-like (median `χ² ≈ 1`) with
ratio `≥ 0.568 > 1/2`.

## 2. `j = 0` is exactly the composition case

`j = a₁²/a₂³`, so `j = 0 ↔ a₁ = 0` (Lean `JZero.j_zero_iff`).  And `a₁ = 0`
means

```
g(x) = x⁴ + a₂x² = h(x²) ,     h(y) = y² + a₂y ,
```

i.e. `g` is a **composition** with `x²`.  Compositions have systematically
smaller value sets (the image is `h(squares)`), which is why `j=0` is the
outlier.  That case is **solved** (round 33): `I = (q−1)/2` or `0` at `a₂=0`,
and `⌊(q+2)/4⌋` for `a₂ ≠ 0`.

## 3. (V) restated

> **(V′)** Every **non-composition** quartic `x⁴+a₂x²+a₁x` (`a₁ ≠ 0`) has
> `|Im(g)| ≥ (q+1)/2`.

By the `S₄` law (round 42), the generic value is `5/8·q`, so (V′) has an
`1/8·q` margin.  The cap now reads:

```
cap  ⇔  (V′)   [j = 0 handled separately]
```

and (V′) is a **Chebotarev equidistribution** statement for `S₄`, with a finite
list of possible exceptions that the data does not reveal.

---

## 4. Wild guess 13 — the composition exception

> **Wild guess 13.** The only exceptional quartics are the **compositions**
> (`a₁ = 0`, `j = 0`), where the image is `h(squares)`.  For every
> non-composition, `S₄` equidistribution gives `|Im|/q → 5/8`, so (V′) holds
> with margin `1/8`.  Over `ℚ`, the composition case is the "even part" (the
> `x ↦ −x` symmetry), and the barrier is that a sieve sees the composition
> structure but not the `S₄` orbits.

**Evidence.**

* `j=0` is the unique outlier (`§1`).
* `j=0 ↔ composition` (Lean, `§2`).
* The non-composition ratio `≥ 0.568 > 1/2` (`§1`).

**Why it is a guess.** Equidistribution is not proved; the `ℚ` reading is an
analogy.

**What would falsify it.** A non-composition with `|Im| < (q+1)/2` would break
(V′).

---

## 5. Lean — `j = 0` iff composition

`lean/JZero.lean`:

```
j_zero_iff (a₁ a₂ : K) (h₂ : a₂ ≠ 0) :  a₁²/a₂³ = 0  ↔  a₁ = 0
```

Footprint `[propext, Classical.choice, Quot.sound]`.

---

## 6. Honest verdict

* **Target A — one clean statement.** The cap ⇔ (V′): non-compositions have
  `|Im| ≥ (q+1)/2`, with `S₄` margin `1/8`.  `j=0` is solved.
* **Target B — unchanged.**
* **Target C — unchanged.**
* **The wild guess:** the only exception is the composition case.

## 7. Next round

1. **Prove (V′) for a subfamily**, e.g. the `a₂ = 0` row via a direct
   splitting-type count.
2. **`S₄` equidistribution**: a character-sum formulation of the splitting-type
   counts.
3. **Target B**: the `d=5` coordinates.

---

## 8. Reproduction

```
python3 checks/round43_j_strat.py   # exit 0
python3 -m pytest -q tests/test_round43.py   # 2 passed
cd lean && ./check.sh JZero.lean Axioms.lean  # OK
```

New files: `checks/round43_j_strat.py`, `tests/test_round43.py`,
`lean/JZero.lean`.
