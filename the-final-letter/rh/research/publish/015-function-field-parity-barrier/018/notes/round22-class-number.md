# Round 22 — testing the class-number guess: refuted

Round 21's preview proposed `B₄(q) = (q/2)(1 − 8h(q))` with `h(q)` a class
number. This round tests it on a new prime and finds it **false**, and also
rules out the discriminant-square description of the reducible set.

---

## 1. Established direction — more `B₄` data

Extending the `d=4` shift scan to `q = 61`:

| `q` | 5 | 13 | 17 | 29 | 37 | 41 | 53 | 61 |
|---|---|---|---|---|---|---|---|---|
| `B₄(q)` | `5/2` | `117/2` | `289/2` | `1653/2` | `−1147/2` | `−1599/2` | `−2491/2` | `9333/2` |
| `2B₄/q` | 1 | 9 | 17 | 57 | −31 | −39 | −47 | 153 |

The congruence `2B₄(q)/q ≡ 1 (mod 8)` **survives** for all eight primes.

## 2. The class-number guess is refuted

With `h(q) := (1 − 2B₄/q)/8`:

| `q` | 5 | 13 | 17 | 29 | 37 | 41 | 53 | 61 |
|---|---|---|---|---|---|---|---|---|
| `h(q)` | 0 | −1 | −2 | −7 | 4 | 5 | 6 | −19 |
| `h(−4q)` | 2 | 2 | 4 | 6 | 2 | 8 | 6 | 6 |

Only `q = 53` coincidentally matches; the rest do not. Worse, `h(q)` takes
**negative** values, which a class number cannot. So `B₄` is not a class number
of `ℚ(√−q)`.

## 3. The discriminant-square description also fails

A natural hope was `R(g) = {b : χ(Δ(b)) ≥ 0}` where `Δ(b)` is the discriminant
of `x⁴ + … + b` (a cubic in `b`).  Tested for `q = 5,7,11`
(`checks/round22_class_number.py` §[C]):

| `q` | families with `R = {χ(Δ) ≥ 0}` |
|---|---|
| 5 | 45/125 |
| 7 | 70/343 |
| 11 | **0/1331** |

So reducibility is **not** simply "the discriminant is a square": the
Galois group must also be intransitive.  The test is refuted.

---

## 4. Wild guess 22 — the amplitude is an `L`-value, not a class number

> **Wild guess 22.** `B₄(q)` is an **`L`-value / period** of the quartic twist,
> not a class number.  The congruence `2B₄(q)/q ≡ 1 (mod 8)` is the shadow of
> the functional equation (the sign of the functional equation is `±1`, and the
> `2`-adic valuation of the period gives the `1 mod 8`). Over `ℚ`, the amplitude
> is an `L`-value of the twin motive; the barrier is that `L`-values do not
> determine the *fixed-shift* count without a reciprocity law.

**Evidence.**

* The class-number guess is refuted (`§2`).
* The discriminant-square description is refuted (`§3`).
* The congruence is a 2-adic statement, natural for an `L`-value sign/period.

**Why it is a guess.** "An `L`-value" is a catch-all; no specific `L`-function
is identified. The congruence is consistent with many 2-adic objects.

**What would falsify it.** A closed formula for `B₄` in terms of a known
`L`-function would confirm it; a formula with no `L`-value would refute it.

---

## 5. Lean — a concrete factorisation in the extremal family

`lean/B4.lean` proves

```
x4_add_four : ∀ x : 𝔽₅, x⁴ + 4 = (x−1)(x−2)(x−3)(x−4) .
```

This is the `b = 4` member of the extremal family `x⁴ + b` over `𝔽₅`: it factors
completely, so it is reducible (and, with `b = 0`, part of the `Q`-set).  A
concrete finite piece of the round-13 extremal family.  Footprint
`[propext, Classical.choice, Quot.sound]`.

---

## 6. Honest verdict

* **Established this round:** `B₄(61) = 9333/2`; the congruence holds for eight
  primes; the **class-number guess is refuted**; the **discriminant-square
  description is refuted**; the `x⁴+4` factorisation in Lean.
* **The wild guess:** `B₄` is an `L`-value, not a class number. Coherent with
  the 2-adic congruence, but no specific `L`-function is identified.
* **Not claimed:** that `B₄` is any particular `L`-value; that the congruence
  has a proof; that the `d=4` cap is proved (still open).

## 7. Next round

1. **More `B₄` values** (`q = 73, 89, …`) to constrain the `L`-value candidate.
2. **A direct proof of the mod-8 congruence** from the character expansion.
3. **Wild guess 23 (preview).** *The congruence `2B₄/q ≡ 1 (mod 8)` follows from
   the fact that `B₄` is the trace of an element of a **2-adic Heisenberg
   group**, whose reduction mod 8 lies in the centre. Over `ℚ`, the analogue is
   the metaplectic/Heisenberg representation, and the parity barrier is the
   failure of its centre to control the fixed shift.* Investigate: fit the
   `2`-adic valuations of `B₄`.

---

## 8. Reproduction

```
python3 checks/round22_class_number.py   # exit 0
python3 -m pytest -q tests/              # 329 passed
cd lean && ./check.sh B4.lean Axioms.lean   # OK
```

New files this round: `checks/round22_class_number.py`, `tests/test_round22.py`,
`lean/B4.lean`.
