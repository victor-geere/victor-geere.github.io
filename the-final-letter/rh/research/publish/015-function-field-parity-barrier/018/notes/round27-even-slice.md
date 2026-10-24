# Round 27 — the even slice: the cap holds and is tight

Round 26 showed the extremal families have `a₃ = 0` and lie in the slice
`x⁴ + a₂x² + a₁x`.  This round studies the **even sub-slice** `a₁ = 0` and
finds that the cap holds for every `a₂` and is **tight**: `min |R| = (q+1)/2`.

---

## 1. Established direction — the even-slice cap

For `g = x⁴ + a₂x²` and `f_b = x⁴ + a₂x² + b`:

| `q` | 5 | 13 | 29 | 37 | 41 |
|---|---|---|---|---|---|
| `max_{a₂} I(a₂)` | 2 | 6 | 14 | 18 | 20 |
| `(q−1)/2` | 2 | 6 | 14 | 18 | 20 |
| `min_{a₂} \|R\|` | 3 | 7 | 15 | 19 | 21 |
| `(q+1)/2` | 3 | 7 | 15 | 19 | 21 |

So in the even slice:

```
I(a₂) ≤ (q−1)/2      for every a₂ ,
min_{a₂} |R(a₂)| = (q+1)/2 ,
```

and the cap is **attained**.  The `a₂ = 0` family `x⁴ + b` is the extremal one
(round 25); other `a₂` have smaller `I` and larger `|Im|`.

The value sets:

| `q` | `\|Im(x⁴)\|` | `\|Im(x⁴+x²)\|` |
|---|---|---|
| 13 | 4 | 5 |
| 29 | 8 | 11 |
| 37 | 10 | 14 |
| 41 | 11 | 16 |

The image grows with `a₂`, so the reducible set is produced by the quadratic
factors rather than by the value set alone.

## 2. The factorization

`x⁴ + a₂x² + b = (x² − y)(x² − z)` whenever `y + z = −a₂` and `yz = b`, i.e.
`y, z` are the roots of `t² + a₂ t + b`.  Proved in Lean
(`lean/EvenQuartic.lean`): the pure ring identity

```
(X² − C y)(X² − C z) = X⁴ − C(y+z) X² + C(yz)
```

and the specialization `y + z = −a`, `yz = b`.

This is the algebraic core of the even-slice analysis: the quartic factors
into two quadratics over `𝔽_q` exactly when the two roots `y, z` are both
squares (or the split is otherwise realized over `𝔽_q`).

---

## 3. Wild guess 27 — the half-dimensional symmetry

> **Wild guess 27.** The even slice `x⁴ + a₂x²` is `h(x²)` with `h(y) = y² + a₂y`,
> so its image is `h(squares)`: a **quadratic map applied to the squares**.  The
> involution `x ↦ −x` halves the dimension, and the cap `(q−1)/2` is the size
> of the quotient.  Over `ℚ`, the involution `x ↦ −x` is the "half-dimensional"
> symmetry that the parity barrier cannot exploit: it reduces the problem by a
> factor of 2 but not below the `1/2` density.

**Evidence.**

* In the even slice the cap holds and is tight (`§1`).
* The image is `h(squares)`, a quadratic map on a set of size `(q+1)/2`.
* The factorization `(x²−y)(x²−z)` is exactly the `x ↦ −x` symmetry (`§2`).

**Why it is a guess.** The general slice `a₁ ≠ 0` breaks the `x ↦ −x`
symmetry, and the cap there is not proved.  "Half-dimensional" is a metaphor.

**What would falsify it.** A general cap proof that does not use the involution
would undercut the reading.

---

## 4. Lean — the even quartic factorization

`lean/EvenQuartic.lean`:

```
even_quartic_aux (y z) : (X²−Cy)(X²−Cz) = X⁴ − C(y+z)X² + C(yz)
even_quartic_factor (h1 : y+z = −a) (h2 : yz = b) :
  (X²−Cy)(X²−Cz) = X⁴ + C a · X² + C b
```

Footprint `[propext, Classical.choice, Quot.sound]`.

---

## 5. Honest verdict

* **Established this round:** the even-slice cap `I(a₂) ≤ (q−1)/2` for
  `q = 5,13,29,37,41`; the tightness `min |R| = (q+1)/2`; the value-set table;
  the even-quartic factorization in Lean.
* **The wild guess:** the cap is the `x ↦ −x` half-dimensional quotient.
  Coherent with the even slice, not proved for `a₁ ≠ 0`.
* **Not claimed:** the general cap (all `a₁,a₂,a₃`); that the involution gives
  the `1/2` bound; any `ℚ` theorem.

## 6. Next round

1. **The odd term `a₁x`**: compute how the cap degrades as `a₁` moves away from
   0, and whether `I(a₁,a₂) ≤ (q−1)/2` for all `a₁`.
2. **The general cap**: the remaining open target.
3. **Wild guess 28 (preview).** *The odd term `a₁x` is a rank-one perturbation
   of the even part; the cap is stable under rank-one perturbations because the
   value set and the quadratic-factor set move in opposite directions. Over
   `ℚ`, the rank-one perturbation is the linear sieve term that the parity
   barrier cannot cross.* Investigate: the `a₁`-dependence of `|Im|` and `|Q|`.

---

## 7. Reproduction

```
python3 checks/round27_even_slice.py   # exit 0
python3 -m pytest -q tests/            # 373 passed
cd lean && ./check.sh EvenQuartic.lean Axioms.lean   # OK
```

New files this round: `checks/round27_even_slice.py`, `tests/test_round27.py`,
`lean/EvenQuartic.lean`.
