# Round 98 — Target B: the bulk/boundary split, and where the `+1` comes from

Round 42 of the aggressive goal.  The integer `m` decomposes into a **bulk** part
and a **boundary** part, and the origin of the `+1` in `m = (a²+1)/2` is
identified.

---

## 1. The boundary is a single point

The indicator `(1−χ₂(b))(1−χ₂(a₂²−4b))/4` differs from `1_{B(a₂)}` only at
`b = 0`, and that can only be in `B(a₂)` when `a₂ = 0`.  Hence the boundary
correction is a **single point**, and

```
S_c − bulk_c  =  (1/16)[2(χ₂(c)+χ₂(−c))√q + 3]
              =  (√q/4)·χ₂(c)  +  3/16 .
```

**Verified at `q = 17,41,73`** (exactly).

## 2. The bulk formula

```
bulk_c  =  (3q² + 2q)/16  +  (a²√q/4)·χ₂(c) .
```

**Verified at `q = 17,41,73,89,97,113,137`** (all `c`).

## 3. The split of `m`

```
S_c  =  A  +  (m√q/2)χ₂(c) ,      A = (3q²+2q+3)/16 ,
```

and the two parts give

```
bulk     :  a²√q/4 · χ₂(c)        boundary :  √q/4 · χ₂(c)
total    :  (a²+1)√q/4 · χ₂(c)  =  (m√q/2) χ₂(c) ,    m = (a²+1)/2 .
```

**So the `a²` comes from the bulk and the `+1` from the boundary** — exactly the
structural guess of round 41.

---

## 4. Wild guess 39 — the bulk via the Jacobi sum

> **Wild guess 39.** The bulk sum
> `Σ_{a₂}|T2+T3−T4|² = (3q²+2q)/4 + a²q` (dividing out the `√q` and `χ₂`)
> evaluates by completing the square: the `T2+T3` cross term gives
> `2χ₂(c)q√q`, and `Σ|T4|²` together with the `T4` cross terms gives
> `(3q²+2q)/4 + a²q − 2q√q`.  The `a²` enters through the **Jacobi sum**
> `J(χ₄,χ₄) = ±(a+bi)`.

**Evidence.** The bulk formula (§2) and the Jacobi-sum theorem (round 39).

## 5. Honest verdict

* **Target B — `m`'s structure is fully explained**: bulk `a²` + boundary `1`.
  The last step is to prove the bulk formula.
* **(A) — cap assembled.**
* **(C) — parity theorem complete for the divisor-sum class.**

## 6. Next round

1. **The bulk evaluation** (the Jacobi sum).
2. **A final synthesis.**

---

## 7. Reproduction

```
python3 checks/round98_bulk.py   # exit 0
python3 -m pytest -q tests/test_round98.py   # 1 passed
```

New files: `checks/round98_bulk.py`, `tests/test_round98.py`.
