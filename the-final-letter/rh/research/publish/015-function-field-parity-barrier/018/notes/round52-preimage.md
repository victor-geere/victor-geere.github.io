# Round 52 — the composition containment is proved

Round 22 of the new goal.  Target A: the containment `−Im ⊆ Q` for compositions
is now **proved**, by an explicit preimage.  Hence `R = Q` for every composition.

---

## 1. The proof

For `g(x) = x⁴+a₂x²` and every `x`,

```
−g(x)  =  −x⁴ − a₂x²  =  (x²+a₂)·(a₂ − (x²+a₂))  =  q(a₂−q)   with  q = x²+a₂ .
```

So every negated value `−g(x)` is a `p=0` quadratic-factor value, i.e.

```
−Im(g)  ⊆  Q₀  ⊆  Q .
```

The identity is a two-line `ring` computation (Lean
`Composition.neg_image_mem_Q`), verified numerically at `q = 7,13,29,37`.

## 2. Consequence — `R = Q` for compositions

Round 20: `R = (−Im) ∪ Q`.  Round 22: `−Im ⊆ Q`.  Therefore, for `a₁ = 0`,

```
R  =  Q .
```

So the composition case is **structurally solved**: the reducible set is exactly
the quadratic-factor image.

## 3. What remains for the composition

Only the **size** of `Q`:

```
|Q|  =  q − ⌊(q+2)/4⌋   (a₂ ≠ 0) ,      |Q| = (q+1)/2   (a₂ = 0) ,
```

verified (round 33/50) but not proved.  The structure of `Q` is now explicit:
`Q = Q₀ ∪ Q₁` with `Q₀ = {q(a₂−q)}` (fibers ≤ 2, Lean `QuadFiber`) and
`Q₁ = {((a₂+p²)²)/4 : p ≠ 0}`.

---

## 4. Wild guess 22 — the composition is `Q`

> **Wild guess 22.** The composition case is **fully structural**: `R = Q` with
> the explicit preimage `q = x²+a₂`, and `|Q|` is the size of a union of two
> quadratic images.  The cap for compositions is therefore a pure image-counting
> statement, with no value-set input.  Over `ℚ`, the composition's parity is the
> quadratic splitting type, and the barrier is the **size** of `Q`, i.e. the
> intersection `Q₀ ∩ Q₁`.

**Evidence.**

* The proof `−g(x) = (x²+a₂)(a₂−(x²+a₂))` (`§1`).
* `R = Q` for all compositions (`§2`).
* `Q₀` has fibers ≤ 2 (round 21).

**Why it is a guess.** `|Q|` is not proved; the `ℚ` reading is an analogy.

**What would falsify it.** A composition with `R ≠ Q` (impossible by `§2`), or a
`|Q|` differing from the formula.

---

## 5. Lean — the preimage identity

`Composition.neg_image_mem_Q`:

```
−(x⁴ + a₂x²) = (x²+a₂)·(a₂ − (x²+a₂))
```

Footprint `[propext, Classical.choice, Quot.sound]`.

---

## 6. Honest verdict

* **Target A — composition proved structurally.** `R = Q`; only `|Q|` remains.
* **Target B — unchanged.**
* **Target C — unchanged.**
* **The wild guess:** the composition is `Q`, and the cap is image counting.

## 7. Next round (synthesis)

1. **Synthesis**: assemble the full cap chain with every proved/verified link.
2. **`|Q|`**: attempt the size formula.
3. **Closing note** on the three targets.

---

## 8. Reproduction

```
python3 checks/round52_preimage.py   # exit 0
python3 -m pytest -q tests/test_round52.py   # 3 passed
cd lean && ./check.sh Composition.lean Axioms.lean  # OK
```

New files: `checks/round52_preimage.py`, `tests/test_round52.py`,
`lean/Composition.lean`.
