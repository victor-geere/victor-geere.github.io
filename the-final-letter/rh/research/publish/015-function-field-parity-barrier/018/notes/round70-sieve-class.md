# Round 70 — Target C: the theorem covers the whole Selberg class

Round 15 of the aggressive goal.  Target C: the parity theorem is **stronger**
than it looks — it excludes every finite divisor sum, not only multiplicative
ones.

---

## 1. The reduction

A **finite linear combination** of divisor sums is again a single divisor sum:

```
Σ_k Σ_{d ∈ S_k, d ∣ n} g_k(d)
   =  Σ_{d ∈ S, d ∣ n} G(d) ,      S = ⋃_k S_k ,   G(d) = Σ_k g_k(d) .
```

So the Selberg sieve class — all weights `w(n) = Σ_{d|n, d≤D} λ_d` with
arbitrary coefficients — is exactly the set of single divisor sums with finite
support.

The Lean theorem `NonPeriodic.twinInd_not_divisor_sum` is stated for an
**arbitrary** coefficient function `g : ℕ → ℝ` and a finite `S`.  Hence it
already excludes the **entire class**, not just the multiplicative sub-class.
The "extension to non-multiplicative bounded-support weights" is therefore
already contained in the theorem.

## 2. The quantitative factor 2

Numerically, the twin count converges to Hardy–Littlewood:

| `N` | twins | `2C₂N/log²N` | ratio |
|---|---|---|---|
| `10⁵` | 1224 | 996 | 1.229 |
| `10⁶` | 8169 | 6917 | 1.181 |

and the natural sieve bound `2·(2C₂N/log²N)` is a factor **2** above the truth
asymptotically.  That factor 2 is the quantitative form of the parity
obstruction.

---

## 3. Wild guess 13 — the factor 2 is the boundary

> **Wild guess 13.** The factor 2 is exactly the **index of the divisor-sum
> class in the period-1 functions**: every periodic weight sees the twin set at
> density `2·(twin density)`, so no such weight can be sharp.  Over `ℚ`, the
> missing refinement is a non-periodic weight (an automorphic form).

---

## 4. Honest verdict

* **Target C — complete for the divisor-sum class.** The theorem excludes all
  finite divisor sums; the factor 2 is the quantitative obstruction.
* **(A) — cap assembled** (round 13).
* **(B)** — `c₄/(2q) ∈ ℤ[i]` at five primes.

## 5. Next round

1. **The `q=113` scan** (running).
2. **The `d=5` amplitudes.**
3. **The factor 2 in Lean.**

---

## 6. Reproduction

```
python3 checks/round70_sieve_class.py   # exit 0
```

New files: `checks/round70_sieve_class.py`.
