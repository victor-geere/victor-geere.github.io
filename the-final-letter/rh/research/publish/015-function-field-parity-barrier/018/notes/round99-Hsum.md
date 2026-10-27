# Round 99 — Target B: the single character sum carrying `a²`

Round 43 of the aggressive goal.  The whole bulk reduces to **one** character
sum, and that sum carries the entire `a²` dependence of `m`.

---

## 1. The reduction

Expanding `|T2+T3−T4|²` and summing over `a₂`:

```
bulk_c  =  (1/16)[ 2q² + Σ|H|² + 2χ₂(−1)χ₂(−c)q√q + 4q ] .
```

The terms used: `Σ|T2|² = Σ|T3|² = q²`, `Σ2Re(T2 conj T3) = 2χ₂(−1)χ₂(−c)q√q`,
and `Σ(−2Re(T2 conj T4)) = Σ(−2Re(T3 conj T4)) = 2q`.

## 2. The `H`-sum

```
Σ_{a₂} |H(a₂,c)|²  =  q² − 2q − 2χ₂(c)q√q + 4a²χ₂(c)√q ,
```

with `H(a₂,c) = Σ_u χ₂(u)χ₂(a₂²−u)ζ^{−cu/4}`.

**Verified at `q = 17,41,73,89,97,113,137`** for `c = 1,3`.

Substituting into the bulk gives

```
bulk_c = (3q²+2q)/16 + (a²√q/4)χ₂(c) ,
```

so the equivalence is exact.

## 3. What this means

**The whole `a²` dependence of `m` lives in the single sum `Σ_{a₂}|H(a₂,c)|²`.**
Every other term in the bulk is a rational polynomial in `q`.

---

## 4. Wild guess 40 — the Kloosterman/Salié evaluation

> **Wild guess 40.** Expanding `|H|²` and summing over `a₂` produces
> `Σ_{a₂}χ₂(a₂²−4v)χ₂(a₂²−4w)`, a **Salié-type** sum evaluated by completing the
> square; its `v = w` diagonal contributes the `q²−2q` and the `v ≠ w` terms
> contribute `−2χ₂(c)q√q`, while the `4a²χ₂(c)√q` comes from the Jacobi sum
> `J(χ₄,χ₄) = ±(a+bi)`.  Then the formula is proved.

**Evidence.** The exact `H`-sum formula (§2) and the Jacobi-sum theorem
(round 39).

## 5. Honest verdict

* **Target B — reduced to a single character sum.**  The `c₄` congruence now
  depends only on the evaluation of `Σ|H|²`.
* **(A) — cap assembled.**
* **(C) — parity theorem complete for the divisor-sum class.**

## 6. Next round

1. **The Salié-type evaluation.**
2. **A final synthesis.**

---

## 7. Reproduction

```
python3 checks/round99_Hsum.py   # exit 0
python3 -m pytest -q tests/test_round99.py   # 1 passed
```

New files: `checks/round99_Hsum.py`, `tests/test_round99.py`.
