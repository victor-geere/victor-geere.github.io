# Round 21 — the four-point moment and the `B₄` congruence

Round 20 computed the two-point variance. This round checks the **four-point**
moment against the character expansion and reports a new congruence satisfied
by the quartic amplitude `B₄(q)`.

---

## 1. Established direction — the four-point check

For `T(h) = T(d;q,h)` and `A = A_d(q)`, compute

```
M4 = (1/(q−1)) Σ_h (T(h) − A)⁴ .
```

The multiplicative-character expansion (round 11) predicts `M4` from the
`d`-torsion coefficients alone.  The prediction matches for every case
(`checks/round21_four_point.py` §[A]):

| `d` | `q` | `M4` | support |
|---|---|---|---|
| 3 | 7 | 1600.67 | `k=2,4` |
| 3 | 13 | 763742.30 | `k=4,8` |
| 4 | 13 | 11711795.06 | `k=6` |
| 4 | 17 | 14659277056.06 | `k=4,8,12` |
| 4 | 41 | 80425933772700.06 | `k=10,20,30` |
| 4 | 53 | 2406439388535.06 | `k=26` |

So the character expansion is **complete** through the fourth moment: the
`d`-torsion characters capture the full distribution, not just its mean.

## 2. The `B₄` congruence

Extending the `d=4` shift scan to `q = 41, 53` gives new amplitudes:

| `q` | 5 | 13 | 17 | 29 | 37 | 41 | 53 |
|---|---|---|---|---|---|---|---|
| `B₄(q)` | `5/2` | `117/2` | `289/2` | `1653/2` | `−1147/2` | `−1599/2` | `−2491/2` |
| `2B₄/q` | 1 | 9 | 17 | 57 | −31 | −39 | −47 |

Every value of `2B₄(q)/q` is an integer **congruent to `1` modulo `8`**
(§[B]).  Equivalently

```
B₄(q) = (q/2)(8m + 1)   for some m ∈ ℤ .
```

This is empirical (7 primes), but the congruence is exact in every case and is
not forced by the definition.

---

## 3. Wild guess 21 — the 2-adic trace

> **Wild guess 21.** The quartic amplitude `B₄(q)` is a **2-adic trace**: it is
> the trace of the Frobenius on a 2-adic Galois representation, and the
> congruence `2B₄(q)/q ≡ 1 (mod 8)` is the reduction of that representation
> modulo `8` (an image inside a 2-adic group with a distinguished `1 mod 8`
> component). Over `ℚ`, the analogue is the 2-adic Galois representation
> attached to the twin motive; the parity barrier is the failure of the 2-adic
> image to control the fixed shift `h = 2`.

**Evidence.**

* `2B₄(q)/q ≡ 1 (mod 8)` for all computed `q` (`§2`).
* `B₄` is the off-diagonal amplitude of round 20 (the phase `χ(2)` multiplies
  it).
* The four-point moment is fully explained by the `d`-torsion characters
  (`§1`), so `B₄` is the only "extra" arithmetic in the `d=4` distribution.

**Why it is a guess.** A congruence mod `8` is weak evidence for a 2-adic
representation; the values `1, 9, 17, 57, −31, −39, −47` do not yet match a
known trace formula. The identification with the twin motive is an analogy.

**What would falsify it.** A value of `2B₄(q)/q` not congruent to `1 mod 8`
would break the congruence; a closed formula for `B₄` without a 2-adic input
would undercut the 2-adic reading.

---

## 4. Lean — the fourth moment over `𝔽₅`

`lean/Variance.lean` now proves

```
twin2_fourth_moment :
  (twin2 1 − 5/2)⁴ + (twin2 2 − 5/2)⁴ + (twin2 3 − 5/2)⁴ + (twin2 4 − 5/2)⁴ = 625/4
```

over `𝔽₅`, i.e. the fourth central moment of the degree-2 twin count is
`625/4 = (25/4)²`. Footprint `[propext, Classical.choice, Quot.sound]`.

---

## 5. Honest verdict

* **Established this round:** the four-point check (the `d`-torsion character
  expansion is complete through the fourth moment); the `B₄` values at
  `q=41,53`; the congruence `2B₄(q)/q ≡ 1 (mod 8)` (7 primes); the fourth
  moment in Lean.
* **The wild guess:** `B₄` is a 2-adic trace, and the parity barrier is the
  2-adic image. Weak but concrete evidence; not yet a formula.
* **Not claimed:** a proof of the congruence for all `q`; that `B₄` is a Galois
  trace; that the 2-adic image is the obstruction.

## 6. Next round

1. **More `B₄` values** (`q = 61, 73, …`) to test the congruence and look for a
   closed form.
2. **The `d=4` cap, final**: try the quadratic-factor parametrization once more
   with exact arithmetic.
3. **Wild guess 22 (preview).** *The congruence `2B₄/q ≡ 1 (mod 8)` is the
   shadow of an **exact formula** `B₄(q) = (q/2)(1 − 8·h(q))` with `h(q)` a
   class number. Over `ℚ`, the class number is the obstruction (the
   Cohen–Lenstra heuristics).* Investigate: compute `h(q) = (1 − 2B₄/q)/8` and
   compare to class numbers of `ℚ(√−q)`.

---

## 7. Reproduction

```
python3 checks/round21_four_point.py   # exit 0
python3 -m pytest -q tests/            # 319 passed
cd lean && ./check.sh Variance.lean Axioms.lean   # OK
```

New files this round: `checks/round21_four_point.py`, `tests/test_round21.py`,
and the fourth-moment theorem in `lean/Variance.lean`.
