# Round 103 — Target B: the diagonal / off-diagonal split

Round 47 of the aggressive goal.  The clean identity of round 46 splits into two
parts of very different character.

---

## 1. The diagonal

```
Σ_{u=v} χ₂(u)χ₂(v) ζ^{−c(u−v)/4} S(u,u)
   =  Σ_{u≠0} (q − 1 − χ₂(u))
   =  (q − 1)² .
```

**Exact** (using `Σ_{u≠0} χ₂(u) = 0`).

## 2. The off-diagonal

```
Σ_{u≠v} χ₂(u)χ₂(v) ζ^{−c(u−v)/4} S(u,v)
   =  2χ₂(c)·√q·Re J(χ₄,χ₄)²  −  1 .
```

**Verified at `q = 17,41,73,89,97`** for `c = 1,3`.

## 3. The consequence

```
Σ|H|² = (q−1)² + 2χ₂(c)√q Re(J²) − 1 = q²−2q + 2χ₂(c)√q Re(J²) ,
```

which is exactly the clean formula of round 46.

**So the entire remaining computation is the off-diagonal identity**

```
Σ_{u≠v} χ₂(u)χ₂(v) ζ^{−c(u−v)/4} S(u,v)  =  2χ₂(c)·√q·Re J(χ₄,χ₄)²  −  1 .
```

---

## 4. Wild guess 44 — the `−1` is the `u=0` boundary

> **Wild guess 44.** The off-diagonal sum, after completing the square, is a
> Jacobi sum `J(χ₄,χ₄)²` (whose real part is `a²−b²`), and the `−1` is the
> correction from the `u=0` or `v=0` boundary of the sum.  Then the identity is
> proved by standard Jacobi-sum evaluation.

**Evidence.** The exact split (§1–2) and the Jacobi-sum theorem (round 39).

## 5. Honest verdict

* **Target B — the last computation is now one off-diagonal identity** in the
  quartic Jacobi sum.
* **(A) — cap assembled.**
* **(C) — parity theorem complete for the divisor-sum class.**

## 6. Next round

1. **The boundary `−1`.**
2. **A final synthesis.**

---

## 7. Reproduction

```
python3 checks/round103_split.py   # exit 0
python3 -m pytest -q tests/test_round103.py   # 1 passed
```

New files: `checks/round103_split.py`, `tests/test_round103.py`.
