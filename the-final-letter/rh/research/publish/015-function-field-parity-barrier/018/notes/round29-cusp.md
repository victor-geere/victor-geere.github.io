# Round 29 — the cusp doubling

Round 28 reduced the general cap to the `j`-line. This round finds the
**normalisation** of the `j`-line count and shows the cap is a **cusp
phenomenon**: the generic density is `1/4`, and only the degenerate class
`x⁴ + b` reaches `1/2`.

---

## 1. Established direction — the `j`-line normalisation

For `a₂ ≠ 0` the count depends only on `j = a₁²/a₂³`.  Averaging over the
`j`-values:

| `q` | 13 | 29 | 37 | 41 |
|---|---|---|---|---|
| mean of `I(j)` | 3.23 | 7.24 | 9.24 | 10.24 |
| `(q−1)/4` | 3.00 | 7.00 | 9.00 | 10.00 |
| range of `I` | [1,5] | [4,11] | [6,14] | [5,14] |
| range of `I − (q−1)/4` | [−2,2] | [−3,4] | [−3,5] | [−5,4] |

So

```
I(j) = (q−1)/4 + O(1)     on the j-line ,
```

with the fluctuation of size at most `5` — far below the Weil range `2√q`
(e.g. `12.8` at `q=41`).  The generic quartic class has **density `1/4`**.

## 2. The cusp `a₂ = 0`

The degenerate row `a₂ = 0` is `x⁴ + a₁x + b`:

| `q` | `I(0,0)` | `(q−1)/2` | max over `a₁ ≠ 0` |
|---|---|---|---|
| 13 | 6 | 6 | 6 |
| 29 | 14 | 14 | 7 |
| 37 | 18 | 18 | 12 |

At `a₁ = 0` the family is `x⁴ + b`, and the density **doubles** to `(q−1)/2`;
for `a₁ ≠ 0` it drops back towards `(q−1)/4`.

## 3. The cap is a cusp phenomenon

The cap is attained at `(a₂,a₁) = (0,0)` for `q = 29, 37, 41`, and at a few
extra `(0, a₁)` pairs for `q = 13`:

| `q` | 13 | 29 | 37 | 41 |
|---|---|---|---|---|
| cap `(q−1)/2` | 6 | 14 | 18 | 20 |
| attained at | `(0,0),(0,1),(0,5),(0,8),(0,12)` | `(0,0)` | `(0,0)` | `(0,0)` |

So the `1/2` bound is **not** a generic feature of quartics: it is the
degenerate class `x⁴ + b` (where the value set collapses to the fourth powers
and the reducible set is exactly the squares).

---

## 4. Wild guess 29 — the cusp-doubling guess

> **Wild guess 29.** The `j`-line count is `I(j) = (q−1)/4 + O(1)`: a
> **one-quarter density** with bounded fluctuation.  At the cusp `a₂ = a₁ = 0`
> the density **doubles** to `(q−1)/2`, saturating the cap.  The half-density
> cap is a **cusp phenomenon**: the generic quartic class has density `1/4`, and
> only the degenerate `x⁴ + b` reaches `1/2`.  Over `ℚ`, the cusp is the
> "generic" case and the doubling is the parity barrier: the fixed shift sees
> the cusp, the average sees `1/4`.

**Evidence.**

* The normalisation `I(j) = (q−1)/4 + O(1)` (`§1`).
* The cusp doubling (`§2`).
* The cap attained only at the cusp (`§3`).

**Why it is a guess.** The `O(1)` fluctuation is observed, not bounded by a
Weil-type theorem; "the cusp is the generic case over `ℚ`" is an analogy.

**What would falsify it.** A `j ≠ ∞` class with `I > (q−1)/2` would break the
cap; a proof that the fluctuation is not bounded would undercut the
normalisation.

---

## 5. Lean — a concrete reducible member at the cusp

`lean/Doubling.lean`:

```
x4_add_one_eval : ∀ x : 𝔽₅, x^4 + 1 = (x^2 + 2)(x^2 + 3)
```

At the cusp `x⁴ + b`, the member `b = 1` is the product of two quadratics.  A
concrete witness of the `b=1` reducibility in the extremal family.  Footprint
`[propext, Classical.choice, Quot.sound]`.

---

## 6. Honest verdict

* **Established this round:** the `j`-line normalisation
  `I(j) = (q−1)/4 + O(1)` (fluctuation ≤ 5 for `q ≤ 41`); the cusp doubling
  `I(0,0) = (q−1)/2`; the cap attained (essentially) only at the cusp; the
  `x⁴+1` factorisation in Lean.
* **The wild guess:** the cap is a cusp phenomenon, with generic density `1/4`
  doubling to `1/2` at `x⁴ + b`.  Strongly supported by the data, but the
  `O(1)` bound is unproved.
* **Not claimed:** a proof of the `O(1)` fluctuation; that the cusp is the only
  cap-attaining class; any `ℚ` theorem.

## 7. Next round

1. **Prove the `j`-line normalisation** `I(j) = (q−1)/4 + O(1)`, perhaps via
  the elliptic-curve trace with `j`-invariant `j`.
2. **The cusp doubling**: prove `I(0,0) = (q−1)/2` for all `q ≡ 1 (mod 4)`
  (round 25 did this) and understand the `q ≡ 3 (mod 4)` case.
3. **Wild guess 30 (preview).** *The `j`-line fluctuation is `−a_j/2` where
  `a_j` is the trace of the elliptic curve with `j`-invariant `j`; the cusp
  doubling is the extra `(q−1)/4` from the degenerate value set. Over `ℚ`, the
  trace is the `a_p` and the barrier is the failure of `a_p` to control the
  fixed shift.* Investigate: fit `I(j)` against `−a_j/2`.

---

## 8. Reproduction

```
python3 checks/round29_cusp.py   # exit 0
python3 -m pytest -q tests/      # 382 passed
cd lean && ./check.sh Doubling.lean Axioms.lean   # OK
```

New files this round: `checks/round29_cusp.py`, `tests/test_round29.py`,
`lean/Doubling.lean`.
