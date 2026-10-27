# Round 36 — the twist-class structure of the quartic slice

Round 6 of the new goal.  Target A gains a **positive structural result**: the
`a₂ = 0` row is a function of the **cube class** of `a₁`, completing the
twist-class picture of the whole `a₃ = 0` slice.

---

## 1. The `a₂ = 0` row: cube classes

For `g(x) = x⁴ + a₁x`, the scaling `x ↦ cx` gives

```
g(cx) = c·g(x)      when c³ = 1
```

(Lean: `CubeSym.cube_scaling`).  So the value set of `g` is a union of
cube-class cosets, and the count depends only on the **cube class** of `a₁`.
Verified for `q = 7,13,19,31,37,43`:

| `q` | class 0 | class 1 | class 2 |
|---|---|---|---|
| 7 | 3 | 0 | 3 |
| 13 | 6 | 0 | 3 |
| 19 | 3 | 3 | 9 |
| 31 | 6 | 9 | 9 |
| 37 | 12 | 6 | 9 |
| 43 | 15 | 9 | 9 |

(Class `0` is the cubes.)  The count is constant on each class, as the symmetry
requires.

## 2. The twist-class picture

Putting the rounds together, the `a₃ = 0` slice is organised by twist classes:

| row | invariant | counting classes |
|---|---|---|
| `a₁ = 0` (even slice) | square class of `a₂` | `a₂ = 0`, `a₂ ≠ 0` |
| `a₂ = 0` | cube class of `a₁` | `gcd(3,q−1)` classes |
| general (`a₁a₂ ≠ 0`) | `j = a₁²/a₂³` | `q−1` classes |

So the cap is a statement **per twist class**, and the extremal class is always
the degenerate one (`a₁ = a₂ = 0`, i.e. `x⁴+b`).

## 3. The critical-value guess is refuted

The number of critical **values** does not determine `|Im|` either:

| `q` | `cv=0` | `cv=1` | `cv=2` | `cv=3` |
|---|---|---|---|---|
| 13 | [7,10] | [8,10] | [9,9] | [8,10] |
| 29 | [17,20] | [17,20] | [19,19] | [18,20] |

The ranges overlap exactly as for the critical points (round 35).

---

## 4. Wild guess 6 — the twist-class guess

> **Wild guess 6.** The whole `d=4` cap is a statement **per twist class**: the
> even slice (square class), the `a₂=0` row (cube class), and the general slice
> (the `j`-invariant).  The extremal class is always the degenerate
> `a₁ = a₂ = 0`.  Over `ℚ`, the twist classes are the Galois cohomology classes
> `H¹(ℚ, μ₄)`; the barrier is that the cohomology class of the fixed shift
> `h=2` is non-trivial, so the class-by-class bound does not assemble.

**Evidence.**

* The even slice is a square-class function (round 33).
* The `a₂ = 0` row is a cube-class function (`§1`).
* The general slice is a `j`-function (round 28).

**Why it is a guess.** The class-by-class cap is not proved; the `ℚ`
identification is an analogy.

**What would falsify it.** A twist class with `I > (q−1)/2` would break the
picture; a cap proof not using twist classes would undercut it.

---

## 5. Lean — the cube symmetry

`lean/CubeSym.lean`:

```
cube_scaling (c a₁ x : R) (hc : c³ = 1) :
  (cx)⁴ + a₁(cx) = c·(x⁴ + a₁x)
```

The algebraic core of the cube-class dependence.  Footprint
`[propext, Classical.choice, Quot.sound]`.

---

## 6. Honest verdict

* **Target A — structural progress.** The `a₂=0` row is a cube-class function;
  the twist-class picture is complete.  The class-by-class cap is not proved.
* **Target B — unchanged.** `d=5` quintic support (round 35).
* **Target C — unchanged.**
* **The wild guess:** twist classes; over `ℚ` the cohomology class of the fixed
  shift is non-trivial.

## 7. Next round

1. **Prove the class-by-class cap** for the `a₂=0` row (cube classes) — the
   cleanest remaining case.
2. **The general `j`-class**: an exact formula for `I(j)`.
3. **Target B**: the `d=5` coefficients.

---

## 8. Reproduction

```
python3 checks/round36_twist_class.py   # exit 0
python3 -m pytest -q tests/test_round36.py   # 4 passed
cd lean && ./check.sh CubeSym.lean Axioms.lean   # OK
```

New files: `checks/round36_twist_class.py`, `tests/test_round36.py`,
`lean/CubeSym.lean`.
