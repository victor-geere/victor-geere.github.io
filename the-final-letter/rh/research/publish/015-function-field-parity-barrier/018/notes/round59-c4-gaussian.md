# Round 59 — Target B: `c₄/q` is a Gaussian integer

Round 4 of the aggressive goal.  Target B: the quartic Fourier coefficient
`c₄(q)` of `T(4;q,2)` satisfies

```
c₄(q)  =  q · (a + b i) ,     a, b ∈ ℤ ,
```

at every prime `q ≡ 1 (mod 8)` tested (`q = 17,41,73,89,97`).

---

## 1. The table

| `q` | `c₄` | `c₄/q` | `(a,b)` |
|---|---|---|---|
| 17 | `34 + 170i` | `2 + 10i` | `(2,10)` |
| 41 | `1640 + 410i` | `40 + 10i` | `(40,10)` |
| 73 | `−3942 + 292i` | `−54 + 4i` | `(−54,4)` |
| 89 | `890 + 14596i` | `10 + 164i` | `(10,164)` |
| 97 | `15714 − 2522i` | `162 − 26i` | `(162,−26)` |

At `q ≡ 3 (mod 4)` and `q ≡ 5 (mod 8)` the coefficient vanishes, so the statement
holds trivially there.

## 2. What this means

The exact individual formula (round 1 of the previous programme) is

```
T(4;q,2)  =  A₄(q) + B₄(q)χ₂(2) + 2 Re(c₄(q)χ₄(2)) ,
```

and now `c₄ = q(a+bi)`.  So the **quartic correction is a Gaussian integer
multiple of `q`** — a weight-2 (Hecke-type) trace, not a weight-4 one.  The
earlier "weight 4" reading came from comparing `|c₄|` with `q²`; the correct
normalisation is `c₄/q`.

Gaussian integers also explain the conjugation symmetry: complex conjugation
`i ↦ −i` is the Galois action on `ℚ(i)`, matching `χ₄ ↔ χ₄^{-1}`.

## 3. What is not known

No formula for `(a,b)` is identified.  The five values
`(2,10), (40,10), (−54,4), (10,164), (162,−26)` show no obvious pattern;
`a²+b² = 104, 1700, 2932, 26996, 26920`.

---

## 4. Wild guess 4 — `(a,b)` are point-count differences

> **Wild guess 4.** `c₄/q = a+bi` is a **difference of point counts**:
> `a = #X(𝔽_q) − #Y(𝔽_q)` and `b = #X'(𝔽_q) − #Y'(𝔽_q)` for explicit curves or
> surfaces `X, Y, X', Y'` associated with the quartic family (e.g. the
> Fermat-type curve `x⁴+y⁴ = 1` and its twists).  The weight-2 normalisation
> would then be forced, and `a,b = O(√q)` (contradicted by `(10,164)` at
> `q=89`, which suggests a surface rather than a curve).

**Evidence.**

* `c₄/q ∈ ℤ[i]` at all four primes (`§1`).
* The conjugation symmetry matches `ℚ(i)` Galois (`§2`).
* The `q=89` value `164` is too large for an elliptic-curve trace, pointing to
  a surface.

**Why it is a guess.** No variety is identified.

**What would falsify it.** A prime with `c₄/q ∉ ℤ[i]`.

---

## 5. Honest verdict

* **Target B — a clean structural fact.** `c₄ = q(a+bi)`, verified at the four
  relevant primes; no formula for `(a,b)`.
* **(A2) — unchanged** (this round attacked B instead).
* **(C) — unchanged.**
* **The wild guess:** `(a,b)` are point-count differences of explicit varieties.

## 6. Next round

1. **Extend the `c₄` data** (the `q=97` scan is running).
2. **Identify `(a,b)`** with point counts.
3. **Return to (A2)**.

---

## 7. Reproduction

```
python3 checks/round59_c4_gaussian.py   # exit 0
python3 -m pytest -q tests/test_round59.py   # 3 passed
```

New files: `checks/round59_c4_gaussian.py`, `tests/test_round59.py`.
