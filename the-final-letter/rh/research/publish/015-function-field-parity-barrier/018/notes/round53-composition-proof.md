# Round 53 — the `(a₁,a₂) = (0,0)` composition is proved

Round 23 of the new goal.  Target A: the case `x⁴ + b` (`a₁ = a₂ = 0`) is now
**proved**, via the square structure of `Q`.

---

## 1. The proof

For `a₂ = 0`:

```
Q  =  Q₀ ∪ Q₁ ,    Q₀ = {−q² : q} = −squares ,
                   Q₁ = {p⁴/4 : p ≠ 0}  ⊆  squares .
```

**Case `q ≡ 1 (mod 4)`.**  `−1` is a square (Euler's criterion), so
`−squares = squares`.  Hence `Q = squares` and

```
|Q| = (q+1)/2 ,   I = (q−1)/2 .
```

**Case `q ≡ 3 (mod 4)`.**  `−1` is a nonsquare, so `−squares = nonsquares`, and
`Q₁ ⊆ squares` with `|Q₁| = |squares| = (q+1)/2` (the fourth powers equal the
squares when `gcd(4,q−1) = 2`).  Hence `Q₁ = squares` and

```
Q = nonsquares ∪ squares = 𝔽_q ,   |Q| = q ,   I = 0 .
```

These are exactly the round-33 formulas for `a₂ = 0`.

## 2. The group-theoretic inputs

* `−1` is a square **iff** `p ≡ 1 (mod 4)` (`ZMod.exists_sq_eq_neg_one_iff`,
  Lean `NegSquare.neg_sq_mem_sq`).
* `Q₁ ⊆ squares` always (fourth powers over a square are squares).
* `|Q₁| = (q+1)/2` when `q ≡ 3 (mod 4)`.

## 3. What remains

| case | status |
|---|---|
| `a₁ = a₂ = 0` | **proved** (this round) |
| `a₁ = 0, a₂ ≠ 0` | `|Q| = q − ⌊(q+2)/4⌋`, verified not proved |
| `a₁ ≠ 0` | (V′) — explicit Chebotarev constant |

---

## 4. Wild guess 23 — the composition splits by `q mod 4`

> **Wild guess 23.** The composition case splits cleanly by `q mod 4`: for
> `q ≡ 1 (mod 4)` the reducible set is the squares, for `q ≡ 3 (mod 4)` it is
> everything.  The `a₂ ≠ 0` case is the same argument with the quadratic image
> `(a₂+p²)/2` replacing `p²`, and the intersection `Q₀ ∩ Q₁` controls the
> `q − ⌊(q+2)/4⌋` count.  Over `ℚ`, the `q mod 4` split is the sign of `−1`,
> i.e. the quadratic character of `−1` — the simplest parity input.

**Evidence.**

* The two-case proof (`§1`).
* `|Q|` matching round 33 (`§1`).
* `−Im ⊆ Q` proved (round 22).

**Why it is a guess.** The `a₂ ≠ 0` intersection is not analysed.

**What would falsify it.** An `a₂ ≠ 0` composition with `|Q|` off the formula.

---

## 5. Lean — `−1` square implies `−x²` square

`NegSquare.neg_sq_mem_sq`:

```
(p % 4 = 1) → IsSquare ((-1 : ZMod p) * x²)
```

using `ZMod.exists_sq_eq_neg_one_iff` and `IsSquare.mul`.  Footprint
`[propext, Classical.choice, Quot.sound]`.

---

## 6. Honest verdict

* **Target A — `x⁴+b` proved.** The `(0,0)` composition is fully settled; the
  `a₂≠0` composition and (V′) remain.
* **Target B — unchanged.**
* **Target C — unchanged.**
* **The wild guess:** the composition splits by `q mod 4`, the sign of `−1`.

## 7. Next round (synthesis)

1. **Synthesis**: the full cap chain, every link marked proved/verified.
2. **`a₂ ≠ 0` composition**: the intersection `Q₀ ∩ Q₁`.
3. **Closing note** on the three targets.

---

## 8. Reproduction

```
python3 checks/round53_composition_proof.py   # exit 0
python3 -m pytest -q tests/test_round53.py   # 4 passed
cd lean && ./check.sh NegSquare.lean Axioms.lean  # OK
```

New files: `checks/round53_composition_proof.py`, `tests/test_round53.py`,
`lean/NegSquare.lean`.
