# Round 23 — translation divisibility and `B₄(73)`

Round 22 refuted the class-number guess. This round identifies the structural
reason `2B₄(q)/q` is an integer — the **free translation action** — and adds a
new amplitude.

---

## 1. Established direction — translation divisibility

For `a ∈ 𝔽_q`, let `σ_a : f(X) ↦ f(X + a)`.  This preserves:

* monicity and degree;
* irreducibility;
* the pair condition: `(f + h)(X + a) = f(X + a) + h`.

The action `a ↦ σ_a` of `𝔽_q` on monic degree-`d` polynomials is **free** when
`d < q`: a nonzero translation-invariant polynomial has degree at least `q`
(the minimal one is `X^q − X`).  Hence the set of `f` with `f` and `f + h`
irreducible is a disjoint union of orbits of size `q`, and

```
q | T(d;q,h)      whenever d < q .
```

Verified for `d = 2,3,4,5,6` and every `q = 5,7,11,13,17,19,23,29,31` with
`d < q` (`checks/round23_translation.py` §[A]): no failures.

**The counterexample at `d = q = 5`.**  The action is not free: `X⁵ − X` is
invariant under all translations.  Indeed

```
T(5;5,h) = 98   for every h ≠ 0 ,    5 ∤ 98 .
```

So the divisibility genuinely needs `d < q` (`§[B]`).

**Consequence.**  For `d = 4` and `q > 4`, `q | T(4;q,h)`, so `2B₄(q)/q` is an
integer.  The mod-8 congruence of rounds 21–22 is therefore a statement about
the **orbit count** `T(4;q,2)/q` modulo `8`.

## 2. `B₄(73)` and the congruence

Extending the scan to `q = 73`:

| `q` | 5 | 13 | 17 | 29 | 37 | 41 | 53 | 61 | 73 |
|---|---|---|---|---|---|---|---|---|---|
| `2B₄/q` | 1 | 9 | 17 | 57 | −31 | −39 | −47 | 153 | 57 |

The congruence `2B₄(q)/q ≡ 1 (mod 8)` holds for all **nine** primes.  (Note
`q = 29` and `q = 73` share the value `57`.)

---

## 3. Wild guess 23 — the orbit / 2-adic guess

> **Wild guess 23.** The translation action is the free `𝔽_q`-action that makes
> `q | T` and hence makes `2B₄/q` integral.  The residual mod-8 congruence is
> the **2-adic weight of the orbit space**: `T/q` counts translation orbits, and
> its value modulo `8` is controlled by a 2-adic central extension (a
> Heisenberg-type group).  Over `ℚ`, the translation orbits are the intervals
> `n ↦ n+1`; the quotient by translation is free, but the parity barrier is the
> failure of the quotient to retain the two-point correlation.

**Evidence.**

* The divisibility `q | T` is proved by the free action (`§1`).
* The mod-8 congruence is a statement about `T/q`, the orbit count.
* The failure at `d = q` shows exactly where the free action breaks.

**Why it is a guess.** The "2-adic central extension" is not identified; the
orbit count `T/q` has no known closed form.  The `ℚ` analogy is loose.

**What would falsify it.** A proof of the congruence that does not use the
orbit structure would undercut the reading; a value of `2B₄/q` not `≡ 1 mod 8`
would break the congruence itself.

---

## 4. Lean — translation divisibility at `d = 2`, `q = 5`

`lean/Variance.lean` now proves

```
twin2_divisible : ∀ h : 𝔽₅, h ≠ 0 → 5 ∣ twin2 h .
```

This is the `d = 2 < 5` instance of the free-action divisibility.  Footprint
`[propext, Classical.choice, Quot.sound]`.

---

## 5. Honest verdict

* **Established this round:** the free translation action and the divisibility
  `q | T(d;q,h)` for `d < q`; the counterexample at `d = q = 5`; `B₄(73)` and
  the ninth confirmation of the mod-8 congruence; the `d=2` divisibility in
  Lean.
* **The wild guess:** the mod-8 congruence is the 2-adic weight of the orbit
  space. Coherent with the free action, but the central extension is not
  identified.
* **Not claimed:** a proof of the mod-8 congruence; that the orbit space is the
  right object; any `ℚ` theorem.

## 6. Next round

1. **Reduce the congruence to `T(4;q,2)/q mod 8`** and try to prove it from the
   exact `q ≡ 3 (mod 4)` formula (where `T = A₄`).
2. **More amplitudes** (`q = 89, 97`) if the scan is affordable.
3. **Wild guess 24 (preview).** *The orbit count `T(4;q,2)/q` is a **Hurwitz
   class number**: the translation orbits are the `𝔽_q`-points of a Hurwitz
   space, and the mod-8 congruence is the 2-adic valuation of its class number.
   Over `ℚ`, the Hurwitz class number is the obstruction.* Investigate: compare
   `T(4;q,2)/q` to Hurwitz class numbers `H(4q)`.

---

## 7. Reproduction

```
python3 checks/round23_translation.py   # exit 0
python3 -m pytest -q tests/             # 338 passed
cd lean && ./check.sh Variance.lean Axioms.lean   # OK
```

New files this round: `checks/round23_translation.py`, `tests/test_round23.py`,
and the divisibility theorem in `lean/Variance.lean`.
