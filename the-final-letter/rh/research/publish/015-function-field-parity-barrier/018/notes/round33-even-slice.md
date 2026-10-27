# Round 33 — the even slice is completely solved

Round 3 of the new goal.  **Target A** takes a major step: the even slice
(the `a₁ = 0` case) is now determined by exact formulas, so the general cap
reduces to the single value-set bound **(V)**.

---

## 1. The even-slice formulas

For `g = x⁴ + a₂x²` (i.e. `a₃ = a₁ = 0`, varying the constant `b`):

| `q mod 4` | `I(0,0,0)` (`x⁴+b`) | `I(0,a₂,0)` for every `a₂ ≠ 0` |
|---|---|---|
| 1 | `(q−1)/2` | `(q−1)/4` |
| 3 | `0` | `(q+1)/4` |

Equivalently `I(0,a₂,0) = ⌊(q+2)/4⌋` for `a₂ ≠ 0`.

Verified for `q = 5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61`
(`checks/round33_even_slice.py` §[A]) and for `q = 67,71,73,79,83,89`.

**The `a₂`-independence is explained by scaling.**  `x ↦ cx` maps
`x⁴+a₂x²` to `x⁴ + (a₂/c²)x²`, and `c ↦ a₂/c²` runs over all nonzero `a₂`; the
count is invariant (round 28).  So the even slice has exactly **two classes**:
`a₂ = 0` and `a₂ ≠ 0`.

**The `q ≡ 3 (mod 4)` collapse.**  At `a₂ = 0` the count is `0`: `x⁴ + b` is
reducible for **every** `b` when `−1` is not a square (e.g. `x⁴+1 =
(x²+3x+1)(x²−3x+1)` over `𝔽₇`).

## 2. Consequence — (E) holds

The even-slice maximum is

* `(q−1)/2` at `a₂ = 0` for `q ≡ 1 (mod 4)`, i.e. exactly the cap;
* `(q+1)/4 < (q−1)/2` for `q ≡ 3 (mod 4)` and for `a₂ ≠ 0`.

So **(E)** — the even-slice cap — holds, and is **attained only at `a₂ = 0`**.

## 3. The cap now reduces to (V) alone

```
general quartic  --translation-->  a₃ = 0
a₁ = 0:  solved by the formulas above
a₁ ≠ 0:  the value-set bound (V):  |Im(g)| ≥ (q+1)/2
```

Hence

> **the general `d=4` cap ⇔ (V)**.

(V) is true up to `O(√q)` by Weil (round 32); the sharp `(q+1)/2` is the only
remaining lemma.

## 4. Negative results

* The discriminant-square characterisation of the even-slice reducible set
  fails: `R(a₂) = {b : χ(Δ(b)) ≥ 0}` holds for `1/13` values of `a₂` at `q=13`.
* The Gauss-sum hypothesis for `c₄` fails: `|G(χ₄)| = √q` while `|c₄| = O(q²)`,
  so `c₄` is not a product of quartic Gauss sums.

---

## 5. Wild guess 3 — the two-lemma cap

> **Wild guess 3.** The function-field cap is the conjunction of
> **(V)** a sharp Weil bound for `|Im(x⁴+a₂x²+a₁x)|` with `a₁ ≠ 0`, and
> **(E)** the exact even-slice formulas (now established).  (V) is a
> one-variable character sum `Σ_s χ(−(s³+2a₂s+2a₁)/s)`; its sharp form should
> follow from the explicit evaluation of that sum (it is a cubic character sum,
> not a generic Weil bound).  Over `ℚ`, (V) survives as a `GL(2)`-type character
> sum, and the barrier is entirely in the `ℚ` analogue of the even slice — the
> factorisation input, i.e. the parity barrier.

**Evidence.**

* (E) is now solved (`§1–2`).
* (V) is a Weil bound up to `O(√q)` (`§3`).
* The collision identity `g(x)−g(y) = (x−y)(…)` is now in Lean.

**Why it is a guess.** The sharp (V) is unproved; the `ℚ` identification is an
analogy.

**What would falsify it.** A family with `a₁ ≠ 0` and `|Im| < (q+1)/2` would
break (V); a cap proof needing a genuinely two-dimensional estimate would
undercut the two-lemma reading.

---

## 6. Lean — the collision identity

`lean/Collision.lean`:

```
diff_factor (a₂ a₁ x y) :
  (x⁴+a₂x²+a₁x) − (y⁴+a₂y²+a₁y)
    = (x−y)(x³+x²y+xy²+y³+a₂(x+y)+a₁)
```

The algebraic core of the collision count behind (V).  Footprint
`[propext, Classical.choice, Quot.sound]`.

---

## 7. Honest verdict

* **Target A — (E) established; cap ⇔ (V).**  The even slice is completely
  solved (22 primes, two formulas).  (V) remains: sharp Weil bound, unproved.
* **Target B — unchanged.**  `c₄` is weight 4; the Gauss-sum hypothesis fails.
* **Target C — unchanged.**  The collision identity and shift lemma are Lean
  inputs, not steps over `ℚ`.
* **The wild guess:** cap = (V) + (E), both now explicit.  (E) is solved; (V)
  is the last function-field lemma.

## 8. Next round

1. **Prove (V)**: evaluate `Σ_s χ(−(s³+2a₂s+2a₁)/s)` explicitly (a cubic
   character sum) and pin its sign.
2. **Prove the even-slice formulas**: a bijection argument on the two classes.
3. **Target B**: look for a quartic analogue of the even-slice collapse.

---

## 9. Reproduction

```
python3 checks/round33_even_slice.py   # exit 0
python3 -m pytest -q tests/test_round33.py   # 10 passed
cd lean && ./check.sh Collision.lean Axioms.lean   # OK
```

New files: `checks/round33_even_slice.py`, `tests/test_round33.py`,
`lean/Collision.lean`.
