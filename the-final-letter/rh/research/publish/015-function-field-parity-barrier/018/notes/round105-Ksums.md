# Round 105 — Target B: the two clean `K`-sums

Round 49 of the aggressive goal.  The last identity splits into **two** sums over
`K`, one of which is completely clean.

---

## 1. The two sums

```
Σ_A |K(A,c)|²           =  q² − 2q                  (clean, independent of c)
Σ_A χ₂(A)·|K(A,c)|²     =  2χ₂(c)·√q·Re J(χ₄,χ₄)²   (the last identity)
```

**Verified at `q = 17,41,73,89,97`** for `c = 1,3`.

The first sum is a genuine theorem-shaped identity (no `c`, no `J`); the second
carries the whole arithmetic content.

## 2. The consequence

Since `Σ_a|H|² = |K(0)|² + 2Σ_{A square≠0}|K|²` and
`2Σ_{A square≠0}|K|² = Σ_A|K|² − |K(0)|² + Σ_Aχ₂(A)|K|²`:

```
Σ_a|H|² = |K(0)|² + (q²−2q−|K(0)|²) + 2χ₂(c)√q Re(J²)
        = q² − 2q + 2χ₂(c)√q Re(J²) ,
```

which is the round-46 clean formula.

---

## 3. Wild guess 46 — the first sum is the Weil bound

> **Wild guess 46.** `Σ_A|K(A,c)|² = q²−2q` is an **orthogonality** identity: `K`
> is (up to a Gauss factor) the Fourier transform of `χ₂(A²−w²)`, and Parseval
> gives `q²` minus the two boundary terms.  Then the second sum is the
> `χ₂`-twisted Parseval, which evaluates to the Jacobi sum `J²`.

**Evidence.** The two identities (§1), all verified at five primes.

## 4. Honest verdict

* **Target B — the last identity is a single `χ₂`-twisted sum.**  The untwisted
  sum is clean and `c`-free; the twisted one is the Jacobi sum.
* **(A) — cap assembled.**
* **(C) — parity theorem complete for the divisor-sum class.**

## 5. Next round

1. **The Parseval interpretation.**
2. **A final synthesis.**

---

## 6. Reproduction

```
python3 checks/round105_Ksums.py   # exit 0
python3 -m pytest -q tests/test_round105.py   # 1 passed
```

New files: `checks/round105_Ksums.py`, `tests/test_round105.py`.
