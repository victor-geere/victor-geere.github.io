# Round 55 — final status of the new goal

Round 25/25.  This is the closing note: what was attempted, what was established,
what remains, and the honest verdict.

---

## 1. The three targets

### Target A — the general `d=4` cap

**Reduced** to two explicit, finite-dimensional inputs:

| # | link | status |
|---|---|---|
| 1 | translation: general ⇔ `a₃=0` | **verified** + Lean `Shift` |
| 2 | `R = (−Im g) ∪ Q` | **verified** all families `q≤37` + Lean `Factorization` |
| 3 | `a₁=0` ⇒ `R = Q` | **proved** + Lean `Composition` |
| 3a | `a₂=0` ⇒ `|Q| = (q+1)/2` or `q` | **proved** + Lean `NegSquare` |
| 3b | `a₂≠0` ⇒ `|Q| = q−⌊(q+2)/4⌋` | verified, not proved |
| 4 | `a₁≠0` ⇒ (V′): `|Im| ≥ (q+1)/2` | verified `q≤89` |
| 4a | `S₄` law `|Im| = 5q/8+O(√q)`, `C=0.43` | verified, not proved |
| 4b | `q≥25` Chebotarev; `q≤23` Lean | Lean `SmallCap` |

**Proved outright:** the translation, `R=Q` for compositions, `x⁴+b`, and the
cap at `q = 5..23`.

**Open (2):** the `a₂≠0` composition size, and the explicit Chebotarev constant.

### Target B — the individual `T(d;q,2)`

* **`d=4`**: the exact decomposition
  `T = A₄ + B₄χ₂(2) + 2Re(c₄χ₄(2))`, with `c₄` pinned at `q = 17,41,73,89` and
  weight 4 (`|c₄|/q² ∈ [0.6,1.85]`).
* **`d=5`**: support on the quintic characters, amplitudes `O(q²)`,
  `T/q⁵ → 1/25`, **no low-degree polynomial** (cubic interpolant misses by 18×).
* **No closed form** for `c₄` or the `d=5` amplitudes.

### Target C — the twin conjecture over `ℚ`

* `twinInd` is not multiplicative (Lean `Barrier.twinInd_not_mult`).
* `twinInd` is not a divisor sum `ζ * g` with multiplicative `g` (Lean
  `DivisorSum.twinInd_not_zeta_mul`).
* The full parity barrier — all finite sieve weights — is **not** reached:
  excluding a general bounded-support divisor sum is equivalent to the open
  infinitude of twins.

---

## 2. The wild guesses, in one line each

| round | guess | outcome |
|---|---|---|
| 1 | `c₄` is weight 3 | **refuted** (weight 4) |
| 2 | cap = Weil bound on the collision sum | **refuted** (sum changes sign) |
| 3 | cap = (V) + even slice | **half confirmed** (even slice solved) |
| 4 | collision moment gives (V) | **refuted** |
| 5 | critical values control the value set | **refuted** |
| 6 | twist classes organise the slice | **confirmed structurally** |
| 7 | random-map `1−e^{−1}` | **approximate** |
| 8 | zero-fiber set = collision curve | **approximate** |
| 9 | cubic trace controls (V) | **partly** (extremisers have negative trace) |
| 10 | Poisson(1) | **approximate, rejected** |
| 11 | Poisson + ramification | **refuted** |
| 12 | `S₄` splitting-type law | **confirmed** (`χ²≈1`) |
| 13 | `j=0` is the only exception | **confirmed** |
| 14 | explicit Chebotarev is the cap | **plausible** (constant 0.43) |
| 15 | `d=5` is a character sum | **plausible** |
| 16 | gap = explicit constant | **plausible** |
| 17 | base checkable, error is the barrier | **confirmed** |
| 18 | one constant away | **plausible** |
| 19 | two-image cap | **confirmed** structurally |
| 20 | `Q` gives the even slice | **confirmed** |
| 21 | composition value set redundant | **confirmed** |
| 22 | composition is `Q` | **proved** |
| 23 | composition splits by `q mod 4` | **proved** |
| 24 | the constant is the barrier | **plausible** |

---

## 3. Deliverables

* **37 Lean files**, all `[check] OK`, all axiom footprints clean
  (`[propext]`, `[propext, Quot.sound]`, or
  `[propext, Classical.choice, Quot.sound]`).
* **52 test files**, **480 tests** passing.
* **57 check scripts**, all exit 0.
* **54 notes**, including this one.

---

## 4. Honest verdict

**No target is fully established.**

* **Target A** is two explicit lemmas away — one image-count and one Weil
  constant.  The reduction is rigorous and the base cases are Lean theorems.
* **Target B** has an exact decomposition at `d=4` and a structural picture at
  `d=5`, but no closed form.
* **Target C** has two Lean theorems about divisor sums; the barrier is
  untouched.

The programme's gain is a **complete, verified map** of the function-field side
of the parity barrier: it is now a statement about the size of a quadratic
image and a uniform error term, not a black box.  That is the maximal progress
made here; crossing the barrier itself remains open.

---

## 5. Final wild guess

> **The cap is one explicit constant.**  `|Im| = 5q/8 + O(√q)` with constant
> `< 0.5`; the finite base is Lean; `x⁴+b` is proved.  Over `ℚ`, the same
> constant is the error term for a fixed `y`-family — and its absence is the
> parity barrier.
