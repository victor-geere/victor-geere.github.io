# Round 57 — (A1) is proved: `|Q₁ \ Q₀| = ⌊(q−1)/4⌋`

Round 2 of the aggressive goal.  **Target (A1) is now proved.**  The `a₂ ≠ 0`
composition size is `q − ⌊(q+2)/4⌋`.

---

## 1. The proof

### Step 1 — the orbit

For `u = p²` (`p ≠ 0` square), the value is `y = ((a₂+u)/2)²`.  The involution

```
σ(u) = −u − 2a₂
```

gives the same value (`(a₂+σ(u))² = (a₂+u)²`; Lean `QOrbit.sigma_y`), and its
character argument is

```
−(2a₂ + σ(u)) = u   (Lean `QOrbit.sigma_arg`),
```

so `χ(−(2a₂+σ(u))) = χ(u) = 1`.  Hence `σ(u)` **never** has `χ = −1`, and

```
|Q₁ \ Q₀|  =  |S| ,   S = { u ≠ 0 square : χ(−(2a₂+u)) = −1 } .
```

(The values `y` are in bijection with the `σ`-orbits, and each orbit carries at
most one element of `S`.)

### Step 2 — the character sum

With `N = (q−1)/2` nonzero squares and `Σ = Σ_{u∈sq*} χ(−(2a₂+u))`:

```
1_{sq*} = (1+χ(u))/2 − (1/2)·1_{u=0}
Σ = 0 + (1/2)·χ(−1)·Σ_u χ(u(2a₂+u)) − (1/2)χ(−2a₂)
  = −(χ(−1) + χ(−2a₂))/2 ,
```

using `Σ_u χ(u) = 0` and the classical `Σ_u χ(u(2a₂+u)) = −1` (complete the
square: `u²+2a₂u = (u+a₂)² − a₂²`).

### Step 3 — the count

The indicator `(1−χ)/2` counts the point `u = −2a₂` (where `χ = 0`) as `1/2`,
so subtract it:

```
|S| = (N − Σ)/2 − (1/2)·1_{χ(−2a₂)=1}
    = (q−1)/4 + (χ(−1) − 1)/4
    = ⌊(q−1)/4⌋ .
```

(In every parity case the `χ(−2a₂)` dependence cancels.)

### Conclusion

```
|Q|  =  |Q₀| + |Q₁ \ Q₀|  =  (q+1)/2 + ⌊(q−1)/4⌋  =  q − ⌊(q+2)/4⌋ .
```

**This is (A1).**

## 2. What this closes

Combined with round 52 (`R = Q` for compositions) and round 53 (`a₂=0` case),
the **whole composition case is now proved**:

```
a₁ = 0  ⇒  |R| = |Q| = q − ⌊(q+2)/4⌋   (a₂ ≠ 0) ,
                    (q+1)/2              (a₂ = 0) .
```

So the cap is reduced to **(A2) alone**: the non-composition value-set bound
`|Im| ≥ (q+1)/2`.

---

## 3. Wild guess 2 — (A2) is the same bookkeeping

> **Wild guess 2.** (A2) is provable by the **same character-sum bookkeeping**:
> the value set of a non-composition quartic is a union of splitting-type
> images, and the `S₄` error constant can be computed exactly from the cubic
> resolvent — no generic Weil bound needed.  The measured `0.43` would then be
> an exact constant, and the cap would be proved.

**Evidence.**

* The composition case fell to a two-sum computation (`§1`).
* The `S₄` law is exact in the mean (`χ² ≈ 1`).
* (V′) has a `0.1q` margin, so a modest exact bound suffices.

**Why it is a guess.** No exact splitting-type count is derived.

**What would falsify it.** A splitting-type count with a non-explicit constant.

---

## 4. Lean

* `QSize.size_identity` — the arithmetic identity.
* `QOrbit.sigma_y`, `QOrbit.sigma_arg` — the orbit involution and its character
  argument.

Footprints `[propext, Classical.choice, Quot.sound]`.

---

## 5. Honest verdict

* **(A1) — PROVED.** The `a₂≠0` composition size is established, closing the
  whole composition case.
* **(A2) — open.** The non-composition value-set bound remains.
* **(B), (C) — unchanged.**
* **The wild guess:** (A2) is the same character-sum bookkeeping.

## 6. Next round

1. **Attack (A2)** with the exact splitting-type bookkeeping.
2. **Target B**: `c₄`.
3. **Target C**: the divisor-sum extension.

---

## 7. Reproduction

```
python3 checks/round57_q1_proof.py   # exit 0
cd lean && ./check.sh QOrbit.lean QSize.lean Axioms.lean  # OK
```

New files: `checks/round57_q1_proof.py`, `lean/QOrbit.lean`.
