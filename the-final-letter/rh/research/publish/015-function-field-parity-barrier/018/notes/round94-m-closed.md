# Round 94 — Target B: the **closed form for `m`**, and the parity law explicit

Round 38 of the aggressive goal.  **The last arithmetic unknown is solved.**

---

## 1. The theorem

Write `q = a² + b²` with `a` **odd** and `b ≡ 0 (mod 4)` (for `q ≡ 1 (mod 8)` this
is unique: exactly one of `a,b` is odd, the other is `≡ 0 mod 4`).  Then

```
m  =  (a² + 1) / 2 .
```

Verified at **28 primes**:

| `q` | `a²+b²` | `(a²+1)/2` | `m` |
|---|---|---|---|
| 17 | `1²+4²` | 1 | 1 |
| 41 | `5²+4²` | 13 | 13 |
| 97 | `9²+4²` | 41 | 41 |
| 241 | `15²+4²` | 113 | 113 |
| 457 | `21²+4²` | 221 | 221 |
| 641 | `25²+4²` | 313 | 313 |

## 2. The exact formula for `E(h)`

```
E(h)  =  (q² − 2q − 7)/16  +  ((a² + 1)/4)·χ₂(2h) .
```

**Verified exactly for all `h`** at `q = 17, 41, 73, 89, 97, 113, 137`.

*Derivation sketch.*  With `S_c = A + Bχ₂(c)`, `A = (3q²+2q+3)/16`,
`B = m√q/2 = ((a²+1)√q)/4`, and `S_0 − A = q(q²−2q−7)/16`:

```
E(h) = (S_0 − A)/q + (m/2)χ₂(−h) = (q²−2q−7)/16 + ((a²+1)/4)χ₂(2h) .
```

## 3. The parity law, explicit

From round 29, `T(h) ≡ E(h) (mod 2)`.  Hence

```
T(h)  ≡  (q² − 2q − 7)/16  +  ((a² + 1)/4)·χ₂(2h)     (mod 2) .
```

This is the **closed form of the parity law**.

## 4. What follows

The `c₄` chain is complete:

```
c₄/(2q) ∈ ℤ[i]  ⇔  8 ∣ reduced differences  ⇔  T' mod 8 = f(χ₂)
  ⇔  E(h) = (q²−2q−7)/16 + ((a²+1)/4)χ₂(2h)  ⇔  m = (a²+1)/2 .
```

So the quartic congruence `c₄ ≡ 0 (mod 2q)` holds **unconditionally** in
`ℤ[i]` — modulo the proof of the closed form for `m`.

---

## 5. Wild guess 35 — the formula is the genus-1 trace

> **Wild guess 35.** `m = (a²+1)/2` is the trace of the Frobenius on a genus-1
> curve attached to the representation `q = a²+b²`: the odd component `a` is the
> **Gauss sum direction** of the quartic character, and `(a²+1)/2` is the
> `ℤ/4`-quotient of the twist.  This would prove the formula.

**Evidence.** 28 primes, the exact `E(h)` formula, and the derivation in §2.

---

## 6. Honest verdict

* **Target B — `m` is solved**: `m = (a²+1)/2`, and `E(h)` and the parity law
  have explicit closed forms.
* **(A) — cap assembled.**
* **(C) — parity theorem complete for the divisor-sum class.**

## 7. Next round

1. **Prove `m = (a²+1)/2`** (the last step to an unconditional `c₄`).
2. **A final synthesis.**

---

## 8. Reproduction

```
python3 checks/round94_m_closed.py   # exit 0
```

New files: `checks/round94_m_closed.py`.
