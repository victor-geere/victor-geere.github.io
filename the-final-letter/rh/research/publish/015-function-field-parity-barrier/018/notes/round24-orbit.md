# Round 24 — the orbit count: exact for `q ≡ 3 (mod 4)`

Round 23 proved `q | T(4;q,h)`. This round computes the **orbit count**
`T(4;q,2)/q` exactly in the `q ≡ 3 (mod 4)` class and refutes the
Hurwitz-class-number guess by a scaling argument.

---

## 1. Established direction — the exact `q ≡ 3 (mod 4)` formula

Write `q = 4k + 3`.  The round-10 exact formula `T(4;q,2) = A_4(q)` gives

```
T(4;q,2)/q = (q³ − q² − 5q − 3)/16 .
```

The polynomial identity

```
(4k+3)³ − (4k+3)² − 5(4k+3) − 3  =  64 k (k+1)²
```

(proved in Lean, `lean/QuarticPoly.lean`) then yields

```
T(4;q,2) = 4 q k (k+1)² ,      T(4;q,2)/q = 4 k (k+1)² .
```

Verified exactly for `q = 7, 11, 19, 23, 31` (`checks/round24_orbit.py` §[A]).

**Consequence.** `4k(k+1)²` is always divisible by `8`:

* if `k` is even, `k = 2m` gives `8m(2m+1)²`;
* if `k` is odd, `(k+1)²` is divisible by `4`, giving `16k·(…)`.

Hence

```
q ≡ 3 (mod 4)  ⇒  T(4;q,2)/q ≡ 0 (mod 8) .
```

This is the first **proved** case of the round-23 orbit congruence.

## 2. The `q ≡ 1 (mod 4)` residue

For `q ≡ 1 (mod 4)` the orbit count is not polynomial (the character term
survives).  Its values mod `8` are:

| `q` | 5 | 13 | 17 | 29 | 37 | 41 | 53 | 61 | 73 |
|---|---|---|---|---|---|---|---|---|---|
| `T/q mod 8` | 4 | 6 | 0 | 2 | 4 | 2 | 0 | 2 | 6 |

All are even; the residue carries the `B₄` amplitude through the identity

```
2B₄(q)/q = (q³ − q² − 5q − 3)/8 − 2 T(4;q,2)/q .
```

## 3. The Hurwitz-class-number guess is refuted

`T(4;q,2)/q ~ q³/16` grows **cubically**, while class numbers (Hurwitz or
ordinary) are `O(√q)`.  The table makes this explicit:

| `q` | 5 | 13 | 29 | 53 | 73 |
|---|---|---|---|---|---|
| `T/q` | 4 | 118 | 1434 | 9136 | 23878 |
| `T/q³` | 0.16 | 0.70 | 1.71 | 3.25 | 4.48 |
| `h(−4q)` | 2 | 2 | 6 | 6 | 4 |

So `T(4;q,2)/q` is **not** a Hurwitz class number (`§[C]`).  The guess is
refuted by scaling, before any detailed comparison.

---

## 4. Wild guess 24 — the orbit count is a period

> **Wild guess 24.** The orbit count `T(4;q,2)/q` is a **period of the quartic
> family**: for `q ≡ 3 (mod 4)` it is the exact polynomial `4k(k+1)²`; for
> `q ≡ 1 (mod 4)` it is `(q³−q²−5q−3)/16 ± (8m+1)/2`, where the sign is `χ(2)`
> and `m` is the 2-adic amplitude.  The twin count is a **period plus a
> character term**, and the parity barrier is the fixed-shift evaluation of
> that character term.

**Evidence.**

* The exact formula `4qk(k+1)²` in the generic class (`§1`).
* The orbit count is cubic, not a class number (`§3`).
* The mod-8 residue in the `q ≡ 1 (mod 4)` class carries `B₄` (`§2`).

**Why it is a guess.** "A period" is a catch-all; no specific period integral is
identified.  The sign/phase `χ(2)` is computable in the function field but has
no `ℚ` analogue without a reciprocity law.

**What would falsify it.** A period interpretation would give a closed formula
for `B₄`; the absence of one leaves the guess open.

---

## 5. Lean — the polynomial identity

`lean/QuarticPoly.lean`:

```
poly_identity (k : ℤ) :
  (4k+3)³ − (4k+3)² − 5(4k+3) − 3 = 64 k (k+1)²
```

This is the algebraic core of the exact `q ≡ 3 (mod 4)` formula.  Footprint
`[propext, Classical.choice, Quot.sound]`.

---

## 6. Honest verdict

* **Established this round:** the exact orbit count `4k(k+1)²` for
  `q ≡ 3 (mod 4)`; the proved congruence `T/q ≡ 0 (mod 8)`; the `q ≡ 1 (mod 4)`
  residues; the **refutation** of the Hurwitz-class-number guess by scaling; the
  polynomial identity in Lean.
* **The wild guess:** the orbit count is a period plus a character term.
  Coherent with the exact formula, but no period integral is identified.
* **Not claimed:** a formula for `B₄`; that the orbit count is a period; any
  `ℚ` theorem.

## 7. Next round

1. **The `q ≡ 1 (mod 4)` orbit count**: try to split it into the `q ≡ 5 (mod 8)`
   and `q ≡ 1 (mod 8)` subclasses and find a formula for each.
2. **The `d=4` cap** (still open): one more exact-arithmetic attempt.
3. **Wild guess 25 (preview).** *The orbit count is `4k(k+1)²` because the
   translation orbits are counted by a **Hurwitz space of covers**; in the
   `q ≡ 1 (mod 4)` class the extra quartic characters are the **2-torsion** of
   the Jacobian of that Hurwitz space. Over `ℚ`, the 2-torsion is the
   obstruction.* Investigate: compute the 2-torsion of the relevant curve.

---

## 8. Reproduction

```
python3 checks/round24_orbit.py   # exit 0
python3 -m pytest -q tests/       # 345 passed
cd lean && ./check.sh QuarticPoly.lean Axioms.lean   # OK
```

New files this round: `checks/round24_orbit.py`, `tests/test_round24.py`,
`lean/QuarticPoly.lean`.
