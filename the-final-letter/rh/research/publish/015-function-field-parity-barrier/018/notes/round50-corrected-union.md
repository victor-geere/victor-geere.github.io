# Round 50 — the corrected union identity; the even-slice formula from `Q`

Round 20 of the new goal.  Target A: round 19's union identity was **missing the
`p=0` case**; corrected, it holds for **every** quartic.  As a corollary, the
round-33 even-slice formula is now **derived** from the quadratic-factor image.

---

## 1. The correction

Round 19 used only `p ≠ 0` in the factorization
`(x²+px+q)(x²−px+s)`.  But `p = 0` is also allowed, giving
`(x²+q)(x²+s)` with `s+q = a₂`, `qs = b` — **provided `a₁ = 0`** (the `p=0`
case forces `a₁ = p(s−q) = 0`).  So the correct set is

```
R  =  (−Im g)  ∪  Q_{p≠0}  ∪  (a₁=0 ? { q(a₂−q) : q ∈ 𝔽_q } : ∅) .
```

Verified for **all** families:

| `q` | 11 | 13 | 29 | 37 |
|---|---|---|---|---|
| families | 121 | 169 | 841 | 1369 |
| identity | ✓ | ✓ | ✓ | ✓ |

## 2. The even-slice formula from `Q`

For `a₁ = 0` the identity gives `R = Q`, and:

| `q` | `a₂` | `\|R\|` | formula |
|---|---|---|---|
| 13 | 0 | 7 | `(q+1)/2 = 7` |
| 13 | 1,2 | 10 | `q − ⌊(q+2)/4⌋ = 10` |
| 29 | 0 | 15 | `(q+1)/2 = 15` |
| 29 | 1,2 | 22 | `q − ⌊(q+2)/4⌋ = 22` |
| 37 | 0 | 19 | `(q+1)/2 = 19` |
| 37 | 1,2 | 28 | `q − ⌊(q+2)/4⌋ = 28` |

These are exactly the round-33 formulas, now **derived** from the structure of
`Q` rather than observed.  So the even slice is the size of the quadratic-factor
image.

## 3. What the cap now is

```
cap  ⇔  max( |−Im g| , |Q| )  ≥  (q+1)/2   (with overlap corrections) .
```

For non-compositions `−Im g` dominates (V′); for compositions `Q` dominates and
is exactly computable.

---

## 4. Wild guess 20 — the `Q`-image guess

> **Wild guess 20.** The cap is a statement about the **quadratic-factor image**
> `Q`, not the value set: for compositions `R = Q` and `|Q|` is the exact
> even-slice formula; for non-compositions the value set `−Im g` already clears
> the cap.  Over `ℚ`, `Q` is the "quadratic splitting type" and `−Im g` the
> "linear splitting type"; the barrier is that a sieve sees neither image
> exactly.

**Evidence.**

* The corrected identity for all quartics (`§1`).
* The even-slice formulas derived from `Q` (`§2`).
* The composition is the only case where `−Im g` is small (round 43).

**Why it is a guess.** The two-image cap is not proved; the `ℚ` reading is an
analogy.

**What would falsify it.** A family with `max(|−Im|,|Q|) < (q+1)/2` (and small
overlap) would break it.

---

## 5. Lean — both factorization cases

`Factorization.quadratic_factor` (`p ≠ 0`) and `Factorization.even_factor`
(`p = 0`):

```
(p q s) (h1 : s+q−p²=a2) (h2 : p(s−q)=a1) (h3 : q s=b) :
  (X²+pX+q)(X²−pX+s) = X⁴ + a2X² + a1X + b
(q s) (h1 : s+q=a2) (h2 : q s=b) :
  (X²+q)(X²+s) = X⁴ + a2X² + b
```

Footprint `[propext, Classical.choice, Quot.sound]`.

---

## 6. Honest verdict

* **Target A — corrected and sharpened.** `R = −Im ∪ Q` exactly (all
  quartics); the even-slice formula is derived; the cap is a two-image
  statement.
* **Target B — unchanged.**
* **Target C — unchanged.**
* **The wild guess:** the cap is about the quadratic-factor image `Q`.

## 7. Next round

1. **Overlap bounds**: control `|−Im ∩ Q|`.
2. **The explicit constant** for (V′).
3. **Target B**: the `d=5` residual.

---

## 8. Reproduction

```
python3 checks/round50_corrected_union.py   # exit 0
python3 -m pytest -q tests/test_round50.py   # 3 passed
cd lean && ./check.sh Factorization.lean Axioms.lean  # OK
```

New files: `checks/round50_corrected_union.py`, `tests/test_round50.py`;
`lean/Factorization.lean` extended with `even_factor`.
