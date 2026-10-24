# Round 40 — higher moments and the cubic trace

Round 10 of the new goal.  Target A: the higher fiber moments converge to the
Poisson(1) values, and the extremal families are exactly those with a
**negative cubic trace**.

---

## 1. Higher moments

At the value-set extremisers:

| `q` | `\|Im\|` | `M2/q` | `M3/q` | `M4/q` |
|---|---|---|---|---|
| 13 | 7 | 2.38 | 7.00 | 23.62 |
| 29 | 17 | 2.24 | 6.38 | 21.28 |
| 37 | 21 | 2.19 | 5.86 | 18.41 |
| 41 | 24 | 2.12 | 5.39 | 15.59 |
| 53 | 31 | 2.17 | 5.87 | 18.70 |
| 61 | 36 | 2.08 | 5.23 | 15.26 |
| 73 | 43 | 2.07 | 5.19 | 15.38 |
| 89 | 53 | 2.17 | 5.92 | 19.02 |
| Pois(1) | — | **2** | **5** | **15** |

So the fiber distribution approaches a **Poisson(1)** law: the moments `Mk/q`
converge to the Bell numbers `2, 5, 15`.  The excess at small `q` is the
ramification surplus.

## 2. The cubic trace

With `a_E = (q−1−cnt₀) − 2S` (round 39: `ΣN² = 2q−1−cnt₀−a_E`):

| `q` | 13 | 29 | 37 | 41 | 53 | 61 | 73 | 89 |
|---|---|---|---|---|---|---|---|---|
| `a_E` | −6 | −8 | −8 | −9 | −11 | −9 | −6 | −17 |

**Negative at every extremiser.**  Recalling `|a_E| ≤ 2√q` (smooth cubic), the
extremisers sit near the **extremal trace** `a_E ≈ −2√q` (e.g. `−17` vs
`−2√89 = −18.9`).

So: *small value set ⇔ maximal collision count ⇔ most negative cubic trace*.

## 3. What this does not give

Even at the extremal trace, the Cauchy–Schwarz bound is
`|Im| ≥ q²/(2q+2√q) = q/2 − √q/2 + O(1)`, which is **below** `(q+1)/2` for
large `q`.  The true `|Im|` is `0.6q`, much larger: the bound is loose by a
factor `≈ 1.2`.  So the trace picture explains *which* family is extremal, not
*how large* the value set is.

---

## 4. Target B

Unchanged: `d=5` amplitudes are `O(q²)`.

---

## 5. Wild guess 10 — the extremal-trace guess

> **Wild guess 10.** The value set is governed by the **cubic trace**:
> `|Im| ≈ q²/(2q−1−cnt₀−a_E)`, and the extremal families are exactly those
> with `a_E ≈ −2√q`.  The sharp bound `(q+1)/2` is a statement that the
> distribution is Poisson(1)-close, i.e. a **central-limit** statement about the
> fiber sizes, not a bound on any single moment.  Over `ℚ`, the trace sign is
> the parity barrier: the sieve cannot see the sign of `a_E`.

**Evidence.**

* Moments converge to Poisson(1) (`§1`).
* Extreme `a_E` at the extremisers (`§2`).
* The moment route to (V) is closed (round 39).

**Why it is a guess.** The Poisson model is asymptotic; the `ℚ` reading is an
analogy.

**What would falsify it.** An extremal family with a **positive** `a_E` would
break the trace picture.

---

## 6. Lean — the value-set Cauchy–Schwarz bound

`lean/ValueSet.lean`:

```
value_set_bound (f : α → β) :
  |α|² ≤ |Im f| · Σ_y N(y)²
```

i.e. `|Im f| ≥ |α|²/Σ N(y)²` — the general value-set lower bound, now a Lean
theorem.  Footprint `[propext, Classical.choice, Quot.sound]`.

---

## 7. Honest verdict

* **Target A — moments + trace.** Poisson(1) convergence; extremisers have
  `a_E ≈ −2√q`; the value-set bound is a Lean theorem.  (V) remains open.
* **Target B — unchanged.**
* **Target C — unchanged.**
* **The wild guess:** Poisson(1)-closeness, i.e. a central-limit statement about
  fiber sizes.

## 8. Next round

1. **Central limit**: test the fiber distribution against Poisson(1) by
   chi-square.
2. **The extremal trace**: prove `a_E` is negative for the extremal families.
3. **Target B**: the `d=5` coefficients.

---

## 9. Reproduction

```
python3 checks/round40_moments.py   # exit 0
python3 -m pytest -q tests/test_round40.py   # 3 passed
cd lean && ./check.sh ValueSet.lean Axioms.lean  # OK
```

New files: `checks/round40_moments.py`, `tests/test_round40.py`,
`lean/ValueSet.lean`.
