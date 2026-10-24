# Round 32 — reducing the cap to a value-set bound; `c₄` is weight 4

Round 2 of the new goal.  Target A gets a clean **two-lemma reduction**; Target B
gets a correction (the quartic amplitude is weight 4, not 3).

---

## 1. Target A — the reduction

The general cap reduces in two steps:

```
general quartic  --translation x ↦ x − a₃/4-->  a₃ = 0
a₃ = 0, a₁ ≠ 0:   |Im(g)| ≥ (q+1)/2   ⇒   cap from the value set alone
a₃ = 0, a₁ = 0:   the even slice (round 27)
```

The first step is rigorous (round 28) and its algebraic core is now in Lean:
`Shift.irreducible_shift : Irreducible (f.comp (X + C t)) ↔ Irreducible f`.

So the general cap is **equivalent** to the two "slice" lemmas:

* **(V)** `|Im(x⁴ + a₂x² + a₁x)| ≥ (q+1)/2` for `a₁ ≠ 0`;
* **(E)** the even-slice cap `I(a₂) ≤ (q−1)/2` at `a₁ = 0`.

**(V) is new this round.**  Verified at eight primes, with no violations
(`checks/round32_cap_reduction.py` §[B]):

| `q` | 13 | 29 | 37 | 41 | 47 | 53 | 59 | 61 |
|---|---|---|---|---|---|---|---|---|
| `min \|Im\|` (a₁≠0) | 7 | 17 | 21 | 24 | 27 | 31 | 34 | 36 |
| `(q+1)/2` | 7 | 15 | 19 | 21 | 24 | 27 | 30 | 31 |

At `q=13` the bound is attained (`a₂=0, a₁=1`, i.e. `x⁴+x`).

## 2. Why (V) is a Weil bound

For `g(x) = x⁴ + a₂x² + a₁x`, the collision equation `g(x) = g(y)` (`x ≠ y`)
becomes, with `s = x+y`, `p = xy`,

```
s³ − 2ps + a₂s + a₁ = 0   ⇒   p = (s³ + a₂s + a₁)/(2s) ,
```

and `(x,y)` exist in `𝔽_q` iff the discriminant

```
D(s) = s² − 4p = −(s³ + 2a₂s + 2a₁)/s
```

is a square.  So the number of collisions is

```
2C = #{s ≠ 0 : χ(D(s)) = 1} ,
```

and by the Weil bound for the rational character sum
`Σ_s χ(D(s)) = O(√q)`,

```
2C = (q−1)/2 + O(√q) ,     Σ_y N(y)² = q + 2C = 2q + O(√q) .
```

Hence `|Im(g)| ≥ q² / Σ_y N(y)² = q/2 + O(√q)`.

So (V) is true **up to `O(√q)`** by Weil; the sharp `(q+1)/2` is the statement
that the `O(√q)` term has the right sign (and is bounded by `1/2`).

## 3. Target B — the quartic amplitude is weight 4

`c₄(89) = 890 + 14596i`, so

```
|c₄(89)| / 89² ≈ 1.846 .
```

Together with `q = 17, 41, 73` (`|c₄|/q² = 0.60, 1.00, 0.74`), the quartic
amplitude is `O(q²)` — a **weight-4** trace, not weight 3.  This corrects
round 1's estimate (which had used `q^{3/2}` as the comparison scale).

---

## 4. Wild guess 2 — the Weil-bound guess

> **Wild guess 2.** The cap is the conjunction of two one-variable statements:
> **(V)** is a Weil bound `|Im| = q/2 + O(√q)` whose sharp form is `(q+1)/2`,
> and **(E)** is the square structure of the even slice.  The general cap is
> therefore a **one-variable** (Weil) input plus a **factorisation** input, not a
> genuinely two-dimensional estimate.  Over `ℚ`, (V) becomes a bound on
> `Σ_p χ(D(p))` for a cubic `D` — a `GL(2)`-type character sum that *is*
> available; the missing piece is (E), the factorisation input, which over `ℚ`
> is the parity barrier.

**Evidence.**

* The reduction and the value-set table (`§1`).
* The collision-count computation giving `q/2 + O(√q)` (`§2`).
* The even-slice cap (round 27).

**Why it is a guess.** The sharp `(q+1)/2` is not proved; the `ℚ` identification
of (E) with the parity barrier is an analogy.

**What would falsify it.** A family with `a₁ ≠ 0` and `|Im| < (q+1)/2` would
break (V); a cap proof that needs a genuinely two-dimensional estimate would
undercut the "one-variable + factorisation" reading.

---

## 5. Lean — the shift invariance

`lean/Shift.lean`:

```
irreducible_shift (t : R) (f : R[X]) :
  Irreducible (f.comp (X + C t)) ↔ Irreducible f
```

The algebra automorphism `algEquivAevalXAddC t` preserves irreducibility; this
is the algebraic core of the translation reduction.  Footprint
`[propext, Classical.choice, Quot.sound]`.

---

## 6. Honest verdict

* **Target A — reduced.** The cap ⇔ (V) ∧ (E).  (V) holds at 8 primes and is a
  Weil bound up to `O(√q)`; (E) is round 27.  Neither (V) sharp nor (E) is
  proved.
* **Target B — corrected.** `c₄` is `O(q²)` (weight 4); `c₄(89)` pinned.  No
  closed form.
* **Target C — unchanged.** `Shift.irreducible_shift` is a Lean input to the
  reduction, not a step on `ℚ`.
* **The wild guess:** the cap is a one-variable Weil bound plus a factorisation
  input.  Coherent, unproved.

## 7. Next round

1. **Prove (V)**: sharpen the Weil bound to `|Im| ≥ (q+1)/2` (the sign of the
   `O(√q)` term).
2. **Prove (E)**: the even-slice cap for general `a₂`.
3. **Target B**: equation for `c₄` — is it a product of Gauss sums?  Test
   `c₄ = q·G(χ₄)²/...` against the four computed values.

---

## 8. Reproduction

```
python3 checks/round32_cap_reduction.py   # exit 0
python3 -m pytest -q tests/test_round32.py   # 4 passed
cd lean && ./check.sh Shift.lean Axioms.lean # OK
```

New files: `checks/round32_cap_reduction.py`, `tests/test_round32.py`,
`lean/Shift.lean`.
