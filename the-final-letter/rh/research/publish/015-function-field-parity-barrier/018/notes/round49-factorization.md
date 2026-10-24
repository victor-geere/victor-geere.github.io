# Round 49 — the reducible set is an explicit union

Round 19 of the new goal.  Target A: the reducible set `R` of a quartic is now
an **explicit union** of two concretely described sets, verified exhaustively.

---

## 1. The identity

For `f_b = x⁴+a₂x²+a₁x+b`,

```
R  =  (−Im g)  ∪  Q ,        g(x) = x⁴+a₂x²+a₁x ,
Q  =  { ((a₂+p²)² − (a₁/p)²)/4  :  p ∈ 𝔽_q^* } .
```

Verified for **every family** at `q = 11, 13, 29` (`110/110`, `156/156`,
`812/812`):

| `q` | families | identity |
|---|---|---|
| 11 | 110 | ✓ |
| 13 | 156 | ✓ |
| 29 | 812 | ✓ |

(The earlier failure was an encoding bug: the family index is `a₁ + a₂q`, not
`a₂q²`.  With the correct encoding the identity is exact.)

**Derivation.** Factor `(x²+px+q)(x²−px+s)`:
`s+q−p² = a₂`, `p(s−q) = a₁`, `qs = b`.  For `p ≠ 0` this gives
`s,q = (a₂+p² ± a₁/p)/2` and `b = qs = ((a₂+p²)²−(a₁/p)²)/4`; for `p=0` one
needs `a₁=0`, the even slice.  Root case: `b = −g(x)`.

## 2. The resolvent criterion fails

The quartic `f_b` is reducible **iff** its resolvent cubic
`z³−a₂z²+4bz−4a₂b−a₁²` has a root — **false**:

| `q` | (1,1) | (0,1) |
|---|---|---|
| 13 | 6/13 | 4/13 |
| 29 | 10/29 | 12/29 |

The Ferrari square conditions matter, so `Q` is genuinely smaller than the
resolvent-root set.

## 3. What this gives

The cap is now the **explicit** statement

```
|(−Im g) ∪ Q|  ≥  (q+1)/2 .
```

For a non-composition (`a₁ ≠ 0`), `Im g` alone exceeds `(q+1)/2` by (V′); `Q` is
only needed for the composition case `j=0`, which is solved (round 33).  So the
identity is a **structural** sharpening, not a new reduction.

---

## 4. Wild guess 19 — the two-image cap

> **Wild guess 19.** The cap is a statement about two explicit images: the
> value-set image `−Im g` and the quadratic-factor image `Q`.  For
> non-compositions `−Im g` alone suffices (V′); for the composition `j=0`, `Q`
> supplies exactly the missing half.  Over `ℚ`, the two images are the "linear"
> and "quadratic" splitting types, and the barrier is that a sieve sees neither
> image exactly.

**Evidence.**

* The exact union identity (`§1`).
* `Q` is the image of the rational map `p ↦ ((a₂+p²)²−(a₁/p)²)/4`.
* The composition case is the only one where `Im` is small (round 43).

**Why it is a guess.** The union bound is not proved; the `ℚ` reading is an
analogy.

**What would falsify it.** A family with `|−Im ∪ Q| < (q+1)/2` would break the
cap.

---

## 5. Lean — the quadratic factorization

`Factorization.quadratic_factor`:

```
(p q s) (h1 : s+q−p² = a2) (h2 : p(s−q) = a1) (h3 : q s = b) :
  (X²+pX+q)(X²−pX+s) = X⁴ + a2X² + a1X + b
```

The algebraic core of the identity.  Footprint
`[propext, Classical.choice, Quot.sound]`.

---

## 6. Honest verdict

* **Target A — structural sharpening.** `R = −Im ∪ Q` exactly; the cap is a
  two-image statement; (V′) still the operative lemma.
* **Target B — unchanged.**
* **Target C — unchanged.**
* **The wild guess:** two images (linear + quadratic splitting types).

## 7. Next round

1. **Size of `Q`**: compute `|Q|` and its overlap with `−Im` for the
   compositions.
2. **The explicit constant** for (V′).
3. **Target B**: the `d=5` residual.

---

## 8. Reproduction

```
python3 checks/round49_factorization.py   # exit 0
python3 -m pytest -q tests/test_round49.py   # 2 passed
cd lean && ./check.sh Factorization.lean Axioms.lean  # OK
```

New files: `checks/round49_factorization.py`, `tests/test_round49.py`,
`lean/Factorization.lean`.
