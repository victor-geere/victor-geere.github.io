# Round 51 — for compositions the value set is redundant

Round 21 of the new goal.  Target A: for a composition (`a₁ = 0`) the value set
is **contained** in the quadratic-factor set, so `R = Q` and the even slice is
purely a statement about `Q`.

---

## 1. The containment

For `a₁ = 0`:

```
−Im(x⁴+a₂x²)  ⊆  Q ,
```

verified for every `a₂` at `q = 7,11,13,17,19,23,29,31,37`.

**Why.**  For `a₂ = 0`, `Im = {x⁴}` (fourth powers) and `Q ⊇ {−q²}` (negated
squares); since fourth powers are squares, `−Im ⊆ −squares ⊆ Q`.  For
`a₂ ≠ 0` the same containment persists (checked).

So for the composition:

```
R  =  Q ,     |R| = |Q| = q − ⌊(q+2)/4⌋   (a₂ ≠ 0) ,
              |R| = (q+1)/2                 (a₂ = 0) .
```

## 2. Non-compositions

For `a₁ ≠ 0` the overlap is partial:

| `q` | `(a₂,a₁)` | `\|Im\|` | `\|Q\|` | overlap | union |
|---|---|---|---|---|---|
| 29 | (0,1) | 19 | 12 | 9 | 22 |
| 29 | (1,1) | 17 | 10 | 8 | 19 |
| 37 | (1,1) | 24 | 17 | 12 | 29 |

The cap comes from `−Im` alone (V′), so the overlap is not needed.

## 3. The clean picture

```
a₁ = 0 :  R = Q         (value set redundant)
a₁ ≠ 0 :  |−Im| ≥ (q+1)/2   (V′)
```

---

## 4. Wild guess 21 — the redundant value set

> **Wild guess 21.** For a composition the value set is **redundant**: every
> linear root `b = −g(x)` is also a quadratic-factor value.  So the even slice
> is entirely the quadratic splitting type, and `(V′)` — the non-composition
> value-set bound — is the *only* place the value set matters.  Over `ℚ`, the
> composition's parity is the quadratic splitting type, and the barrier is the
> non-composition value set.

**Evidence.**

* The containment `−Im ⊆ Q` (`§1`).
* `R = Q` and the exact even-slice sizes (`§1`).
* Non-compositions clear the cap by `−Im` (`§2`).

**Why it is a guess.** The containment is verified, not proved; the `ℚ` reading
is an analogy.

**What would falsify it.** A composition with `−Im ⊄ Q` at some `q`.

---

## 5. Lean — the quadratic fiber

`QuadFiber.quad_fiber`:

```
q(a₂−q) = r(a₂−r) → q ≠ r → q + r = a₂
```

The `p=0` quadratic image has fibers of size at most 2, hence image size
`(q+1)/2`.  Footprint `[propext, Classical.choice, Quot.sound]`.

---

## 6. Honest verdict

* **Target A — composition case clarified.** `R = Q`; the value set is
  redundant; (V′) is the only value-set input.
* **Target B — unchanged.**
* **Target C — unchanged.**
* **The wild guess:** the even slice is the quadratic splitting type.

## 7. Next round

1. **Prove `−Im ⊆ Q`** for compositions.
2. **The explicit constant** for (V′).
3. **Synthesis** of the whole programme.

---

## 8. Reproduction

```
python3 checks/round51_containment.py   # exit 0
python3 -m pytest -q tests/test_round51.py   # 4 passed
cd lean && ./check.sh QuadFiber.lean Axioms.lean  # OK
```

New files: `checks/round51_containment.py`, `tests/test_round51.py`,
`lean/QuadFiber.lean`.
