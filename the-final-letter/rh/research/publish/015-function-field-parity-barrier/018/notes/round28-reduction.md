# Round 28 — reducing the general cap to the `a₃ = 0` slice

Round 27 proved the even-slice cap. This round shows that the **general** cap
reduces to the `a₃ = 0` slice by a translation, and that in that slice the count
depends only on the **`j`-invariant** of the quartic.

---

## 1. Established direction — the translation reduction

For fixed `(a₃,a₂,a₁)`, the family is `{f_b = x⁴ + a₃x³ + a₂x² + a₁x + b}`.
The translation `x ↦ x − a₃/4` maps `f_b(x)` to a monic quartic with **no `x³`
term**:

```
a₂' = a₂ − 3a₃²/8 ,     a₁' = a₁ + a₃³/8 − a₂a₃/2 ,
```

and the constant term becomes `b + c` for a fixed `c`, so `b` still ranges over
`𝔽_q`.  Since translation preserves irreducibility and is a bijection on the
family,

```
I(a₃, a₂, a₁) = I(0, a₂', a₁') .
```

Verified for `q = 13`: **0 mismatches out of 2197** families
(`checks/round28_reduction.py` §[A]).  Hence

> the general cap `I ≤ (q−1)/2`  ⇔  the `a₃ = 0` cap.

This is the normal form of round 26 (`DepressedQuartic.depress`) applied at the
level of the family.

## 2. The `j`-invariant

In the `a₃ = 0` slice, the scaling `x ↦ c x` preserves the count: it maps the
family `{x⁴ + a₂x² + a₁x + b}` to `{x⁴ + (a₂/c²)x² + (a₁/c³)x + b'}`, and
`b'` ranges over `𝔽_q`.  So

```
I(a₂, a₁) = I(a₂/c², a₁/c³)   for every c ≠ 0 .
```

The invariant is

```
j = a₁² / a₂³      (a₂ ≠ 0) .
```

Verified for `q = 13`: the `q−1 = 12` nonzero `a₂` classes collapse to
**13 `j`-values**, and `I` depends only on `j` (no class with two different `I`
values) (`§[B]`).

So the `a₃ = 0` cap is a statement about a **1-parameter** family of quartic
classes — the `j`-line — plus the degenerate `a₂ = 0` families.

## 3. The `a₃ = 0` cap

| `q` | 13 | 29 | 37 | 41 |
|---|---|---|---|---|
| `max I` | 6 | 14 | 18 | 20 |
| `(q−1)/2` | 6 | 14 | 18 | 20 |
| `argmax (a₂,a₁)` | (0,0) | (0,0) | (0,0) | (0,0) |

The cap holds for all four primes, and the **extremal class is `(0,0)`**, i.e.
`x⁴ + b` — the family whose cap was proved in round 25.  For `a₂ ≠ 0` the
maximum is strictly smaller.

---

## 4. Wild guess 28 — the `j`-line guess

> **Wild guess 28.** The general cap reduces by translation to the `a₃ = 0`
> slice, where the count depends only on the `j`-invariant `a₁²/a₂³`.  The
> extremal class is `j = ∞` (`a₂ = a₁ = 0`, i.e. `x⁴ + b`), and `I` decreases
> along the `j`-line away from it.  Over `ℚ`, the `j`-line is the modular curve
> `X(1)`, and the parity barrier is the failure of the `j`-invariant to control
> the fixed-shift count: the `ℚ` quartic families are parameterised by the same
> `j`, but the two-point correlation is not a function of `j` alone.

**Evidence.**

* The translation reduction (`§1`).
* `I` depends only on `j` (`§2`).
* The extremal class is `(0,0)` (`§3`).

**Why it is a guess.** "`I` decreases along the `j`-line" is observed at four
primes, not proved; the `ℚ` identification with `X(1)` is an analogy.

**What would falsify it.** A `j`-class with `I > (q−1)/2` would break the cap; a
proof that `I` is not a function of `j` would break `§2` (already ruled out for
`q = 13`).

---

## 5. Lean — the `j`-invariant scaling identity

`lean/JInvariant.lean`:

```
j_invariant_scale (a1 a2 c : K) (hc : c ≠ 0) :
  (a1/c³)² / (a2/c²)³ = a1² / a2³
```

proved by `field_simp`.  Footprint `[propext, Classical.choice, Quot.sound]`.

---

## 6. Honest verdict

* **Established this round:** the **translation reduction** (general cap ⇔
  `a₃=0` cap), verified exactly at `q=13`; the **`j`-invariant** `a₁²/a₂³` and
  the fact that `I` depends only on it; the `a₃=0` cap at four primes with
  extremal class `(0,0)`; the `j`-invariant scaling identity in Lean.
* **The wild guess:** the cap is a statement on the `j`-line, decreasing away
  from `j = ∞`.  Coherent and now one-dimensional, but unproved.
* **Not claimed:** a proof of the `j`-line monotonicity; the general cap; any
  `ℚ` theorem.

## 7. Next round

1. **The `j`-line**: compute `I(j)` for larger `q` and look for a closed form or
   a monotonicity.
2. **The `a₂ = 0` row**: `x⁴ + a₁x`, whose count is maximal at `a₁ = 0`.
3. **Wild guess 29 (preview).** *The `j`-line count `I(j)` is a **trace of a
   Hecke operator** on the modular curve `X(1)`; the maximum at `j = ∞` is the
   cusp, and the parity barrier is the failure of the cuspidal spectrum to
   control the two-point count.* Investigate: compare `I(j)` to Hecke
   eigenvalues at level 1.

---

## 8. Reproduction

```
python3 checks/round28_reduction.py   # exit 0
python3 -m pytest -q tests/           # 377 passed
cd lean && ./check.sh JInvariant.lean Axioms.lean   # OK
```

New files this round: `checks/round28_reduction.py`, `tests/test_round28.py`,
`lean/JInvariant.lean`.
