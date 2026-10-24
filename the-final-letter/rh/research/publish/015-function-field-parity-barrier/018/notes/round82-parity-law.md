# Round 82 — Target B: the parity law `T'(h) ≡ (1 − χ₂(2h))/2`

Round 27 of the aggressive goal.  The round-26 mod-8 structure rests on a cleaner
**parity law** that holds for both `q ≡ 1` and `q ≡ 5 (mod 8)`.

---

## 1. The parity law

```
T'(h)  ≡  (1 − χ₂(2h)) / 2      (mod 2) .
```

That is: `T'(h)` is **even** iff `2h` is a square, and **odd** iff `2h` is a
non-square.

Verified at eleven primes:

| `q` | `χ₂(2)` | `T'` mod 2 | law |
|---|---|---|---|
| 5,13,29,37 | −1 | (odd, even) per class | ✓ |
| 17,41 | +1 | `[0,1,0,1]` | ✓ |
| 73,89,97,113,137 | +1 | `[0,1,0,1]` | ✓ |

For `q ≡ 1 (mod 8)` this reduces to "even on squares, odd on non-squares"; for
`q ≡ 5 (mod 8)` it is **reversed**, consistent with `χ₂(2) = −1`.

## 2. The mod-8 refinement (`q ≡ 1 mod 8`)

With `χ₂(2) = 1`, `T'(h) mod 8` depends only on `χ₂(h)`, and the two values sum
to `−1` (round 26).  Hence `T'_0 ≡ T'_2` and `T'_1 ≡ T'_3 (mod 8)` — the factor
`8`, i.e. `c₄/(2q) ∈ ℤ[i]`.

---

## 3. Wild guess 24 — the doubled shift

> **Wild guess 24.** The character `χ₂(2h)` — i.e. the **doubled** shift — enters
> because the parity of the quartic pair count is governed by the 2-division of
> `𝔽_q*`: `T'` counts pairs modulo the `μ₄` action, and the quotient `μ₄/{±1}`
> is exactly the 2-torsion, whose class is detected by `χ₂(2h)`.  The same
> mechanism, refined 2-adically, gives the mod-8 law.

**Evidence.**

* The parity law at eleven primes, covering both `q mod 8` classes (`§1`).
* The mod-8 refinement (`§2`).
* `q = 5` is the `d = q` boundary case; the law still holds.

**Why it is a guess.** The 2-division mechanism is not exhibited.

## 4. Honest verdict

* **Target B — the parity law** is the 2-adic entry point of the congruence.
  With the mod-8 refinement it gives `c₄/(2q) ∈ ℤ[i]` for `q ≡ 1 (mod 8)`.
* **(A) — cap assembled.**
* **(C) — parity theorem complete for the divisor-sum class.**

## 5. Next round

1. **Prove the parity law** via the `μ₄` quotient.
2. **A final synthesis.**

---

## 6. Reproduction

```
python3 checks/round82_parity_law.py   # exit 0
python3 -m pytest -q tests/test_round82.py   # 1 passed
```

New files: `checks/round82_parity_law.py`, `tests/test_round82.py`.
