# Round 73 — Target B: the `c₄` congruence reformulated

Round 18 of the aggressive goal.  The congruence `c₄/(2q) ∈ ℤ[i]` is recast as a
**divisibility of a quartic-character sum** of the reduced shift counts.

---

## 1. The reformulation

Since `d = 4 < q`, the translation divisibility (round 23) gives `q ∣ T(h)` for
every `h`.  Write `T'(h) = T(h)/q` and

```
S  =  Σ_h T'(h)·χ₄(h)   ∈  ℤ[i] .
```

The Fourier coefficient is `c₄ = q·conj(S)/(q−1)`, so

```
c₄/(2q) ∈ ℤ[i]     ⇔     S ≡ 0  (mod 2(q−1))  in ℤ[i] .
```

## 2. Verification

| `q` | `q ∣ T(h)` | `S/(2(q−1))` | `conj(c₄/(2q))` |
|---|---|---|---|
| 17 | ✓ | `1 − 5i` | `1 − 5i` |
| 41 | ✓ | `20 − 5i` | `20 − 5i` |
| 73 | ✓ | `−27 − 2i` | `−27 − 2i` |
| 89 | ✓ | `5 − 82i` | `5 − 82i` |
| 97 | ✓ | `81 + 13i` | `81 + 13i` |
| 113 | ✓ | `−28 − 82i` | `−28 − 82i` |
| 137 | ✓ | `−176 − 5i` | `−176 − 5i` |

All match.  (The conjugation is the convention `χ₄ ↔ χ₄⁻¹`.)

## 3. Why this is cleaner

The congruence is now a statement about the **reduced** counts `T'(h) = T(h)/q`
— integers of size `~q³/16` — against the quartic character, with no `q` in the
denominator.  The divisibility by `2(q−1)` is a **character-orthogonality**
statement: the `χ₄`-component of `T'` is divisible by `2(q−1)`.

---

## 4. Wild guess 16 — the orthogonality

> **Wild guess 16.** `T'(h)` is `(q−1)`-periodic up to a twisted shift: as `h`
> runs over `𝔽_q*`, the involution `h ↦ −h` and the translation `h ↦ h+t` force
> the `χ₄`-sum to be a multiple of `(q−1)`, and the quadratic sign contributes
> the extra `2`.

---

## 5. Honest verdict

* **Target B — the congruence recast.** `S ≡ 0 (mod 2(q−1))` in `ℤ[i]`, six
  primes; still no closed form for the values.
* **(A) — cap assembled.**
* **(C) — parity theorem complete for the divisor-sum class.**

## 6. Next round

1. **Prove `S ≡ 0 mod 2(q−1)`** via the `h ↦ −h` involution.
2. **The `q=137` scan** (running).
3. **A synthesis.**

---

## 7. Reproduction

```
python3 checks/round73_c4_reformulation.py   # exit 0
python3 -m pytest -q tests/test_round73.py   # 1 passed
```

New files: `checks/round73_c4_reformulation.py`, `tests/test_round73.py`.
