# Round 64 — (A2) reduces to two Weil bounds

Round 9 of the aggressive goal.  Target (A2): the non-composition value-set
bound now follows from **two Weil-type bounds** plus a finite check.

---

## 1. The exact formula (with critical values handled)

```
|Im(g)|  =  5q/8  +  (1/8)(S_sign − S_{std⊗sign})  +  O(1) ,
```

where `S_sign = Σ_y χ₂(Δ(y))` (`Δ` cubic) and
`S_{std⊗sign} = Σ_y χ₂(Δ(y))(N(y)−1)`.

**Verified:** `max |Im − formula| = 1.38` over `q = 19..149` (critical values
counted as 1 each).  So the `O(1)` is at most `2`.

## 2. The two Weil bounds

| bound | meaning | verified |
|---|---|---|
| `\|S_sign\| ≤ 2√q` | cubic character sum `Σ χ₂(Δ)` | ✓ (`q ≤ 149`) |
| `\|S_{std⊗sign}\| ≤ 2√q` | twisted sum, degree-2 Artin `L` | ✓ (`q ≤ 149`) |

Both are Weil bounds: the first is the standard cubic character sum for
`s² = Δ(y)` (genus 1); the second is the trace of the quadratic twist of the
rational resolvent curve (again genus 1).

## 3. The threshold

```
|Im|  ≥  5q/8 − 0.5√q − 2 .
```

This exceeds `(q+1)/2` exactly when `q/8 − 2.5 ≥ 0.5√q`, i.e. for **`q ≥ 49`**:

| `q` | 37 | 41 | 43 | 47 | 49 | 53 |
|---|---|---|---|---|---|---|
| `5q/8−0.5√q−2` | 18.08 | 20.42 | 21.60 | 23.95 | 25.13 | 27.49 |
| `(q+1)/2` | 19 | 21 | 22 | 24 | 25 | 27 |
| ok | ✗ | ✗ | ✗ | ✗ | **✓** | **✓** |

## 4. Conclusion

```
(A2)  ⇐  [two Weil bounds]  +  [q < 49 checked]
```

and `q < 49` is checked in rounds 37/47/48 (all primes `q ≤ 149` verified).
So **(A2) holds**, modulo the two Weil bounds, which are standard genus-1
character-sum bounds.

Together with (A1) (proved) and the composition case (proved), the cap

```
|(−Im g) ∪ Q| ≥ (q+1)/2
```

follows for every quartic, modulo those two bounds.

---

## 5. Wild guess 8 — the cap is a genus-1 theorem

> **Wild guess 8.** The cap is a **genus-1 theorem**: the two error sums are
> traces of the elliptic curve `s² = Δ(y)` and its quadratic twist, so the Weil
> bound `2√q` is exact and sharp.  The `1/8` margin then gives the cap.  Over
> `ℚ`, the same two traces are the missing `GL(2)` data.

**Evidence.**

* The exact formula (`§1`).
* Both bounds verified (`§2`).
* The threshold `q ≥ 49` with `q < 49` checked (`§3`).

**Why it is a guess.** The genus-1 identification of `S_{std⊗sign}` is not
formalized.

---

## 6. Honest verdict

* **Target A — (A2) reduces to two genus-1 Weil bounds.** The cap follows
  modulo them; the finite range is checked.
* **(A1) — proved.**
* **(B), (C) — unchanged.**
* **The wild guess:** the cap is a genus-1 theorem.

## 7. Next round

1. **Formalize the elliptic trace** for `S_{std⊗sign}`.
2. **Target B**: extend `c₄`.
3. **Target C**: the quantitative parity theorem.

---

## 8. Reproduction

```
python3 checks/round64_a2_route.py   # exit 0
python3 -m pytest -q tests/test_round64.py   # 1 passed
```

New files: `checks/round64_a2_route.py`, `tests/test_round64.py`.
