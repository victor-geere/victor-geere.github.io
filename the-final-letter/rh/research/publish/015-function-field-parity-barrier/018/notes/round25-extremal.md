# Round 25 — the extremal family `x⁴ + b`

Round 24 pinned the orbit count. This round **proves** that the `d=4` cap is
achieved by the single family `x⁴ + b` when `q ≡ 1 (mod 4)`, and extends the
cap verification to `q = 43`.

---

## 1. Established direction — the extremal family

For `q ≡ 1 (mod 4)`, `−1` is a square.  Consider `f_b = x⁴ + b`.

**Root condition.**  `f_b` has a root iff `b = −x⁴`.  Since `−1` is a square,
`−x⁴` is a square.  So the root set is contained in the squares.

**Quadratic-factor condition.**  `f_b = (x² + px + s)(x² − px + t)` gives

* `p = 0`: `s + t = 0`, `st = b`, so `b = −s²` (a square);
* `p ≠ 0`: `t = s`, `2s = p²`, so `b = s² = p⁴/4` (also a square).

So `Q ⊆ squares`.

**Conversely**, `−s²` as `s` ranges over `𝔽_q` covers **all** squares (again
because `−1` is a square).  So `Q ⊇ squares`.

Hence the reducible set is exactly the squares:

```
R(x⁴ + b) = {squares} ,      |R| = (q+1)/2 ,      I = (q−1)/2 .
```

Verified exactly for `q = 5, 13, 29, 37, 41` (`checks/round25_extremal.py`
§[A]): the reducible set equals the squares and `x⁴ + b` is the extremal
family in every case.

**Lean.**  The algebraic core `x⁴ − s² = (x² + s)(x² − s)` is
`ExtremalQuartic.factor_x4` (`ring`).

For `q ≡ 3 (mod 4)` the extremal family is different (e.g. `x⁴ + x` at `q = 7`,
`x⁴ + x² + 2x` at `q = 11`), and the square argument fails because `−1` is not
a square.

## 2. The cap for `q ≤ 43`

| `q` | 5 | 7 | 11 | 13 | 17 | 19 | 23 | 29 | 31 | 37 | 41 | 43 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `max I` | 2 | 3 | 5 | 6 | 8 | 9 | 9 | 14 | 11 | 18 | 20 | 15 |
| `(q−1)/2` | 2 | 3 | 5 | 6 | 8 | 9 | 11 | 14 | 15 | 18 | 20 | 21 |

The cap `I ≤ (q−1)/2` holds for all twelve primes, tight for eight of them and
slack for `q = 23, 31, 43`.

---

## 3. Wild guess 25 — the 2-torsion of a Hurwitz space

> **Wild guess 25.** The extremal family `x⁴ + b` is the `𝔽_q`-points of a
> **Hurwitz space of covers** `C → ℙ¹`: the squares are the branch points, and
> the generic orbit count `4k(k+1)²` (round 24) is its degree.  In the
> `q ≡ 1 (mod 4)` class the extra fourth-power characters are the **2-torsion**
> of the Jacobian of that Hurwitz space.  Over `ℚ`, the 2-torsion of the
> Hurwitz space is the obstruction: the parity barrier is the failure of the
> 2-torsion to be visible at a fixed shift.

**Evidence.**

* The extremal family is exactly `x⁴ + b` with reducible set = squares (`§1`).
* The generic orbit count is the polynomial `4k(k+1)²` (round 24), a "degree".
* The `q ≡ 1 (mod 4)` extra characters are the fourth-power (2-torsion) data.

**Why it is a guess.** No Hurwitz space is constructed; "2-torsion" is a
metaphor for the fourth-power characters.  The `ℚ` identification is an analogy.

**What would falsify it.** A proof of the general cap (`§2` for all families)
that does not use a Hurwitz-space structure would undercut the reading; a
counterexample to the cap would falsify the whole picture.

---

## 4. Lean — the factorization identity

`lean/ExtremalQuartic.lean`:

```
factor_x4 {R} [CommRing R] (s : R) :
  (X^4 - C s ^ 2 : R[X]) = (X^2 + C s) * (X^2 - C s)
```

This is the `p = 0` branch of the quadratic-factor condition.  Footprint
`[propext]` (pure `ring`).

---

## 5. Honest verdict

* **Established this round:** the **proof** that `x⁴ + b` has reducible set
  exactly the squares for `q ≡ 1 (mod 4)`, achieving the cap; the cap verified
  for `q ≤ 43` (twelve primes); the factorization identity in Lean.
* **The wild guess:** the Hurwitz-space / 2-torsion reading.  Coherent with the
  extremal family, but no Hurwitz space is constructed.
* **Not claimed:** the general cap (all families); that a Hurwitz space exists;
  any `ℚ` theorem.

## 6. Next round

1. **The general cap**: prove `|Im(g) ∪ Q(g)| ≥ (q+1)/2` for every quartic `g`,
   perhaps by reducing to the `x⁴ + b` case via a change of variable.
2. **The `q ≡ 3 (mod 4)` extremal families**: identify their structure (they
   look like `x⁴ + a₁x + a₂x²`).
3. **Wild guess 26 (preview).** *Every quartic `g` is `x⁴ + b` after a
   **Möbius change of variable** and a completion of the square; the general cap
   follows from the `x⁴ + b` case by transport of the square structure.*
   Investigate: classify quartics by their `j`-invariant / Möbius class.

---

## 7. Reproduction

```
python3 checks/round25_extremal.py   # exit 0
python3 -m pytest -q tests/          # 358 passed
cd lean && ./check.sh ExtremalQuartic.lean Axioms.lean   # OK
```

New files this round: `checks/round25_extremal.py`, `tests/test_round25.py`,
`lean/ExtremalQuartic.lean`.
