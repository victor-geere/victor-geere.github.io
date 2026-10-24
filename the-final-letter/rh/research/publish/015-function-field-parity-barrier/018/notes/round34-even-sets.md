# Round 34 — even-slice sets; the collision route to (V) fails

Round 4 of the new goal.  Target A gets two structural facts and one **negative
result**: the sharp value-set bound (V) does **not** follow from the collision
moment bound.

---

## 1. The even-slice sets

For `q = 13` the `12` values `a₂ ≠ 0` give only **3 distinct** irreducible
b-sets, and for `q = 29` the `28` values give **7**:

| `q` | distinct sets | `(q−1)/4` |
|---|---|---|
| 13 | 3 | 3 |
| 29 | 7 | 7 |

So the number of distinct sets is `(q−1)/4` — the index of the fourth powers.
The sets themselves are **not** character sets (e.g. `{1,8,10}` at `q=13`).
The count is nevertheless constant, `⌊(q+2)/4⌋`, for every `a₂ ≠ 0` (round 33).

The scaling `x ↦ cx` maps the family for `a₂` to the family for `a₂/c²` and
`b ↦ b/c⁴`, so the **cardinality** is invariant while the **set** moves; the
`(q−1)/4` distinct sets are the orbits of the `b`-action by fourth powers.

## 2. Negative result — the collision route fails

Round 32 reduced (V) to the collision count `2S = #{(x,y): x≠y, g(x)=g(y)}` and
the Cauchy–Schwarz bound `|Im| ≥ q²/(q+2S)`.  The sharp `(q+1)/2` would follow
from `2S ≤ q−2`, i.e. from `Σ_s χ(D(s)) ≤ −1`.  **This is false**:

| `q` | range of `Σ_s χ(D(s))` | positive cases |
|---|---|---|
| 13 | `[−6, 6]` | 64/156 |
| 29 | `[−10, 9]` | 336/812 |

So (V) is **not** a sign statement about a single character sum; the sharp bound
needs the actual value distribution, not a moment.

## 3. Lean — scaling preserves irreducibility

`lean/Scale.lean`:

```
irreducible_scale (c : K) (hc : c ≠ 0) (f : K[X]) :
  Irreducible (f.comp (C c * X)) ↔ Irreducible f
```

This is the algebraic core of the `a₂`-independence in the even slice (the
scaling `x ↦ cx`).  Footprint `[propext, Classical.choice, Quot.sound]`.

---

## 4. Wild guess 4 — distribution, not moment

> **Wild guess 4.** (V) is not a moment bound.  The collision character sum
> changes sign, so Cauchy–Schwarz cannot reach `(q+1)/2`.  The sharp statement
> needs the **fiber distribution** of `g(x) = x⁴+a₂x²+a₁x`: `|Im(g)| = q −
> #{collision classes}`, and the collision classes are governed by the value
> set of the **cubic** `x³ + a₂x + a₁` (the derivative).  Over `ℚ`, the fiber
> distribution is exactly what a sieve cannot see — the parity barrier.

**Evidence.**

* The character sum changes sign (`§2`).
* The even-slice sets are fourth-power orbits, not character sets (`§1`).
* The derivative is a cubic, so the fiber structure is genus-1 data.

**Why it is a guess.** No formula for `|Im(g)|` is known; the `ℚ` identification
is an analogy.

**What would falsify it.** A moment bound that reaches `(q+1)/2` would undercut
the "distribution" reading.

---

## 5. Honest verdict

* **Target A — no new proof.** Two structural facts (the `(q−1)/4` sets, the
  fourth-power orbits) and the negative result that the collision moment route
  fails.  (V) remains open.
* **Target B — unchanged.**
* **Target C — unchanged.**
* **The wild guess:** (V) needs the fiber distribution (cubic derivative data),
  not a moment.

## 6. Next round

1. **The derivative cubic**: compute the value set / fiber structure of
   `x³+a₂x+a₁` and relate it to `|Im(x⁴+a₂x²+a₁x)|`.
2. **A bijection for the even slice**: use the fourth-power orbit structure.
3. **Target B**: the quartic analogue of the even-slice collapse.

---

## 7. Reproduction

```
python3 checks/round34_even_sets.py   # exit 0
python3 -m pytest -q tests/test_round34.py   # 3 passed
cd lean && ./check.sh Scale.lean Axioms.lean  # OK
```

New files: `checks/round34_even_sets.py`, `tests/test_round34.py`,
`lean/Scale.lean`.
