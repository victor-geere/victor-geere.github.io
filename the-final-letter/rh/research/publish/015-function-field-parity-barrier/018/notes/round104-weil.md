# Round 104 — Target B: `H` as a shifted quadratic Weil sum

Round 48 of the aggressive goal.  The off-diagonal identity is recast as a sum
over **squares** of a quadratic character sum.

---

## 1. The reformulation

With `A = a²/2` and

```
K(A,c)  =  Σ_w χ₂(A² − w²) ζ^{−cw/4} ,
```

one has

```
H(a,c)  =  ζ^{−c a²/8} · K(A,c) .
```

**`K` is real.**  Verified for all `a`, `c = 1,3` at `q = 17`.

## 2. The square-sum

Since `A = a²/2` runs over the squares (twice for `A ≠ 0`),

```
Σ_a |H(a,c)|²  =  |K(0,c)|²  +  2 Σ_{A square, A≠0} |K(A,c)|² .
```

**Verified at `q = 17,41,73`** for `c = 1,3`.

## 3. Why this is progress

The double sum `Σ_a|H|²` is now a **sum over the squares** of `|K(A,c)|²`,
where `K` is a quadratic character sum.  The `a²`-dependence of `m` is now
entirely in the restriction to squares.

---

## 4. Wild guess 45 — the conic count

> **Wild guess 45.** `K(A,c)` counts points on the conic `w² + (character) = A²`
> with a multiplicative weight; its square `|K(A,c)|²` is a **point count** of the
> conic over `𝔽_q`, and the sum over squares evaluates by the standard
> conic/Weil bound.  Then `Σ|H|² = q²−2q+2χ₂(c)√q Re(J²)` follows.

**Evidence.** The exact reformulations (§1–2) and the Jacobi-sum theorem
(round 39).

## 5. Honest verdict

* **Target B — the last computation is now a sum over squares of a quadratic
  Weil sum.**
* **(A) — cap assembled.**
* **(C) — parity theorem complete for the divisor-sum class.**

## 6. Next round

1. **The conic count for `K`.**
2. **A final synthesis.**

---

## 7. Reproduction

```
python3 checks/round104_weil.py   # exit 0
python3 -m pytest -q tests/test_round104.py   # 1 passed
```

New files: `checks/round104_weil.py`, `tests/test_round104.py`.
