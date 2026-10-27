# Round 102 — Target B: the clean form of the `H`-sum

Round 46 of the aggressive goal.  The last remaining computation is reduced to
its **cleanest form**: a single identity involving `Re J(χ₄,χ₄)²`.

---

## 1. The clean formula

```
Σ_{a₂} |H(a₂,c)|²  =  q² − 2q  +  2χ₂(c)·√q·(a² − b²)
                   =  q² − 2q  +  2χ₂(c)·√q·Re J(χ₄,χ₄)² .
```

**Verified at `q = 17,41,73,89,97,113,137`** for `c = 1,3`.

The `a² − b²` is `Re(J²)` since `J = ±(a+bi)`.

## 2. The consequence for `m`

```
bulk_c = (1/16)[2q² + (q²−2q+2χ₂(c)√q(a²−b²)) + 2χ₂(c)q√q + 4q]
       = (3q²+2q)/16 + (a²√q/4)χ₂(c) ,
```

using `a²−b²+q = 2a²` (since `q = a²+b²`).

So the whole remaining problem is the **single identity**

```
Σ_{a₂} |H(a₂,c)|²  =  q² − 2q  +  2χ₂(c)·√q·Re J(χ₄,χ₄)² .
```

---

## 3. Wild guess 43 — the diagonal plus Jacobi

> **Wild guess 43.** The diagonal `S(u,u) = q−1−χ₂(u)` contributes `q²−2q`, and
> the off-diagonal contributes `2χ₂(c)√q·Re(J²)`.  The off-diagonal sum
> `Σ_{u≠v}χ₂(u)χ₂(v)ζ^{−c(u−v)/4}S(u,v)` is a **Jacobi sum** in the quartic
> character because `S(u,v)` is a Salié sum; its evaluation gives `Re(J²)`.

**Evidence.** The clean formula (§1) and the Jacobi-sum theorem (round 39).

## 4. Honest verdict

* **Target B — the last computation is now a single, clean identity.**
  `Σ|H|² = q²−2q+2χ₂(c)√q Re(J²)`; everything else in the chain is proved.
* **(A) — cap assembled.**
* **(C) — parity theorem complete for the divisor-sum class.**

## 5. Next round

1. **The diagonal-versus-off-diagonal split of the clean identity.**
2. **A final synthesis.**

---

## 6. Reproduction

```
python3 checks/round102_clean.py   # exit 0
python3 -m pytest -q tests/test_round102.py   # 1 passed
```

New files: `checks/round102_clean.py`, `tests/test_round102.py`.
