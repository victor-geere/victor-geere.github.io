# Round 26 — the depressed quartic and the `q ≡ 3 (mod 4)` extremal families

Round 25 proved the cap for `x⁴ + b` when `q ≡ 1 (mod 4)`. This round tests the
"Möbius transport" guess for the general cap — it is **false** — and classifies
the `q ≡ 3 (mod 4)` extremal families.

---

## 1. Established direction — the depressed quartic

The standard normal form: after the translation `x = y − a/4`, a quartic
`x⁴ + a x³ + b x² + c x + d` becomes

```
f(y − a/4) = y⁴ + P y² + Q y + R ,
P = b − 3a²/8 ,   Q = c − ab/2 + a³/8 ,   R = d − ac/4 + a²b/16 − 3a⁴/256 .
```

Proved in Lean (`lean/DepressedQuartic.lean`, `ring`).

**The moduli count.**  After the translation the quartic has **three**
parameters `(P, Q, R)`.  The family `x⁴ + b` is the slice `P = Q = 0`,
a **codimension-2** subfamily.  So a general quartic is **not** equivalent to
`x⁴ + b`, and the round-25 preview's "Möbius transport" guess is **false**
(`checks/round26_depressed.py` §[B]).

The `p = 0` basis of the `x⁴ + b` argument (the `−s²` squares) does not
transport to a general quartic.

## 2. The `q ≡ 3 (mod 4)` extremal families

| `q` | 7 | 11 | 19 | 23 | 31 | 43 | 47 |
|---|---|---|---|---|---|---|---|
| `max I` | 3 | 5 | 9 | 9 | 11 | 15 | 17 |
| `(q−1)/2` | 3 | 5 | 9 | 11 | 15 | 21 | 23 |
| `(a₁,a₂,a₃)` | (1,0,0) | (2,1,0) | (4,0,0) | (3,5,0) | (7,1,0) | (1,0,0) | (17,5,0) |

Every extremal family has **`a₃ = 0`** and `a₁ ≠ 0`; the families are
`x⁴ + a₂x² + a₁x`.  The cap is tight for `q = 7, 11, 19` and slack for
`q = 23, 31, 43, 47`.

So the `q ≡ 3 (mod 4)` extremal families live in the `a₃ = 0` slice — the same
slice where the depressed quartic's cubic term is already absent — but they are
not `x⁴ + b`.

---

## 3. Wild guess 26 — the even-part guess

> **Wild guess 26.** The extremal families are the quartics with `a₃ = 0`, i.e.
> `x⁴ + a₂x² + a₁x`.  In this slice the quartic is the sum of an **even** part
> `x⁴ + a₂x²` and an odd linear term `a₁x`; the value set of the even part is
> controlled by the `x ↦ −x` involution, and the odd term shifts it.  The cap is
> a statement about the **even part**: the reducible set is at least the image
> of the even part, of size `(q+1)/2`.  Over `ℚ`, the analogue is the `x ↦ −x`
> involution, and the parity barrier is the failure of this involution to see
> the odd shift `a₁x`.

**Evidence.**

* Every computed `q ≡ 3 (mod 4)` extremal family has `a₃ = 0` (`§2`).
* The `q ≡ 1 (mod 4)` extremal family `x⁴ + b` is also in the `a₃ = 0` slice.
* In the `a₃ = 0` slice, `g(−x) = g(x) − 2a₁x`, so the even part controls the
  value set up to a linear shift.

**Why it is a guess.** The even part's value set is not literally of size
`(q+1)/2` (for `x⁴ + a₂x²` it is `(q+1)/2` when `a₂ = 0`, but smaller in
general). The reduction from the general quartic to `a₃ = 0` is the translation
`x ↦ x + a₃/4`, which changes the shape of the family.

**What would falsify it.** An extremal family with `a₃ ≠ 0` would break the
"even slice" reading; a proof of the cap that does not use the even part would
undercut it.

---

## 4. Lean — the depressed quartic normal form

`lean/DepressedQuartic.lean`:

```
depress (a b c d y : ℚ) :
  (y − a/4)⁴ + a(y − a/4)³ + b(y − a/4)² + c(y − a/4) + d
    = y⁴ + (b − 3a²/8)y² + (c − ab/2 + a³/8)y
        + (d − ac/4 + a²b/16 − 3a⁴/256)
```

Proved by `ring`.  Footprint `[propext]` (pure ring).

---

## 5. Honest verdict

* **Established this round:** the depressed quartic normal form in Lean; the
  **refutation** of the Möbius-transport guess by the moduli count; the
  classification of the `q ≡ 3 (mod 4)` extremal families (`a₃ = 0`,
  `a₁ ≠ 0`).
* **The wild guess:** the cap is an **even-part** statement in the `a₃ = 0`
  slice.  Coherent with the data, but the value-set bound for general `a₂` is
  not established.
* **Not claimed:** the general cap; that the even part gives `(q+1)/2` for all
  `a₂`; any `ℚ` theorem.

## 6. Next round

1. **The even-part value set**: compute `|Im(x⁴ + a₂x²)|` as a function of `a₂`
   and see whether it is always `(q+1)/2` or `(q+3)/4`.
2. **Prove the cap in the `a₃ = 0` slice** using the even part.
3. **Wild guess 27 (preview).** *The even-part value set is the image of a
   quadratic map in `x²`, so it has size `(q+1)/2` or `(q+1)/4`; the odd term
   `a₁x` cannot destroy it. Over `ℚ`, the involution `x ↦ −x` is the
   "half-dimensional" symmetry that the parity barrier cannot exploit.*
   Investigate: the value set of `x⁴ + a₂x²` for all `a₂`.

---

## 7. Reproduction

```
python3 checks/round26_depressed.py   # exit 0
python3 -m pytest -q tests/           # 364 passed
cd lean && ./check.sh DepressedQuartic.lean Axioms.lean   # OK
```

New files this round: `checks/round26_depressed.py`, `tests/test_round26.py`,
`lean/DepressedQuartic.lean`.
