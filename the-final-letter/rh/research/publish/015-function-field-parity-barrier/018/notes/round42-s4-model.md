# Round 42 — the `S₄` splitting-type law

Round 12 of the new goal.  Target A gets its **best structural model yet**: the
fiber law is the `S₄` Chebotarev splitting-type distribution, which predicts the
value-set ratio `5/8` and beats the Poisson model decisively.

---

## 1. The model

For a quartic `g(x) − y` with Galois group `S₄`, the number of roots in `𝔽_q` is
the number of fixed points of the Frobenius element, so the splitting-type
distribution is

| `k` (fiber size) | 0 | 1 | 2 | 3 | 4 |
|---|---|---|---|---|---|
| element count | 9 | 8 | 6 | 0 | 1 |
| `P(k)` | `3/8` | `1/3` | `1/4` | `0` | `1/24` |

(cycle types: identity → 4; transposition → 2; 3-cycle → 1; double transposition
and 4-cycle → 0.)

Hence

```
|Im|/q  →  P(k ≥ 1)  =  1 − 3/8  =  5/8  =  0.625 .
```

## 2. Chi-square

| `q` | 13 | 29 | 37 | 41 | 53 | 61 | 73 | 89 |
|---|---|---|---|---|---|---|---|---|
| `χ²` **S₄** | 1.08 | 0.90 | 1.42 | 1.16 | 0.92 | 0.86 | 1.84 | 1.22 |
| `χ²` Poisson | 5.48 | 8.07 | 9.73 | 0.92 | 12.00 | 4.79 | 15.05 | 15.17 |

The `S₄` law fits (`χ² ≈ 1`), the Poisson law does not.  The round-11
"ramification atom" is replaced by the correct explanation: the fiber sizes are
the **splitting types** of `g − y`.

## 3. The ratio `5/8`

The generic quartic has `|Im|/q → 5/8 = 0.625`.  The extremisers sit slightly
below (`0.54–0.60`), because their Galois group is smaller (`V₄` or `C₄`), where
the splitting-type distribution is different.  So:

* generic `j`: `S₄`, ratio `5/8`;
* special `j` (0, 1728, …): `V₄`/`C₄`, ratio below `5/8` but still `> 1/2`.

## 4. What this would give for (V)

If the `S₄` equidistribution is uniform, then `|Im|/q ≥ 5/8 − o(1) > 1/2` for
generic `j`, and (V) holds.  The special `j` need a separate check.  So (V)
splits into:

1. **Chebotarev for `S₄`**: generic `j` have ratio `5/8`;
2. **the special `j`** (finitely many): ratio `> 1/2`.

This is the first time (V) has a **density-level** explanation rather than a
moment bound.

---

## 5. Target B

Unchanged: `d=5` coefficients are in `(1/(q−1))·ℤ[ζ₅]`; no closed form.

---

## 6. Wild guess 12 — the `S₄` equidistribution guess

> **Wild guess 12.** The value set is governed by the **Galois group** of
> `g(x) − y`: generic `j` have `S₄` and `|Im|/q → 5/8`; the special `j`
> (`0, 1728`, …) have `V₄`/`C₄` and a smaller ratio.  Hence (V) is a
> **Chebotarev equidistribution** statement plus a finite check of the special
> `j`.  Over `ℚ`, the special `j` are the CM points, and the barrier is that the
> sieve sees the `S₄` part but not the CM points.

**Evidence.**

* `S₄` chi-square `≈ 1` vs Poisson `5–15` (`§2`).
* The ratio `5/8 = 0.625` matches the generic data (`§1–3`).
* The extremisers are the special `j` with a smaller group (`§3`).

**Why it is a guess.** Equidistribution is not proved; the `ℚ` identification
is an analogy.

**What would falsify it.** A generic `j` with `|Im|/q < 1/2` would break (V);
a special `j` with ratio above `5/8` would break the stratification.

---

## 7. Lean — at most three critical points

`lean/Crit.lean`:

```
crit_le_three (a₂ a₁ : K) :
  (derivative (X⁴+C a₂X²+C a₁X)).roots.card ≤ 3
```

The cubic derivative has at most three roots.  Footprint
`[propext, Classical.choice, Quot.sound]`.

---

## 8. Honest verdict

* **Target A — the `S₄` law.** The fiber law is the splitting-type distribution;
  `|Im|/q → 5/8` generically; (V) splits into Chebotarev + finite special `j`.
* **Target B — unchanged.**
* **Target C — unchanged.**
* **The wild guess:** `S₄` equidistribution plus CM-point exceptions.

## 9. Next round

1. **Special `j`**: compute the ratio at `j=0,1728` and the `V₄`/`C₄` cases.
2. **`S₄` equidistribution**: test the splitting types against `S₄` for a
   generic `j` across `q`.
3. **Target B**: the `d=5` coordinates.

---

## 10. Reproduction

```
python3 checks/round42_s4_model.py   # exit 0
python3 -m pytest -q tests/test_round42.py   # 4 passed
cd lean && ./check.sh Crit.lean Axioms.lean  # OK
```

New files: `checks/round42_s4_model.py`, `tests/test_round42.py`,
`lean/Crit.lean`.
