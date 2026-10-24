# Round 12 — the low-degree miracle stops at `d = 5`

Rounds 10–11 found exact polynomial formulas for the generic-class twin count
at `d = 3, 4`. This round asks whether the pattern persists, and answers **no**:
the `d = 5` generic count is already non-polynomial. On the Lean side, the
algebraic reason for the `d = 3` shift-independence is proved.

---

## 1. Established direction — `d = 5` is not polynomial

The generic class is `5 ∤ q−1`. Nine primes are available:
`q = 5, 7, 13, 17, 19, 23, 29, 37, 43`, with

```
T(5;q,2) = 98, 560, 13676, 53142, 94050, 245640, 791004, 2698484, 5746520 .
```

**Degree bound.** The general theorem gives
`T(5;q,2) = q⁵/25 · S(q) + O(q^{9/2})` with `S(q) → 1`. So any polynomial
formula has degree `≤ 5` (the leading term is `q⁵/25`).

**Interpolation test.** A degree-5 polynomial is determined by six points. The
exact rational interpolant through `q = 5,7,13,17,19,23` misses the remaining
points by

| `q` | 29 | 37 | 43 |
|---|---|---|---|
| error | `1069876/21 ≈ 5.1e4` | `551738` | `12860394/7 ≈ 1.8e6` |

So no degree-5 polynomial fits, and by the degree bound no polynomial fits at
all. **The `d = 5` generic count is not a polynomial.**

(For completeness, degrees 4, 6, 7 also miss; the errors are listed in
`checks/round12_degree5.py` §[B].)

**The dichotomy.**

| `d` | generic class | polynomial formula |
|---|---|---|
| 3 | `q ≡ 2 (mod 3)` | `q³/9 (1 − 1/q − 2/q²)` |
| 4 | `q ≡ 3 (mod 4)` | `q(q³ − q² − 5q − 3)/16` |
| 5 | `5 ∤ q−1` | **none** |

The exact formulas are a low-degree miracle, and they stop at `d = 5`.

---

## 2. Lean — the cubing bijection

The reason the `d = 3` count is shift-independent for `q ≡ 2 (mod 3)` is that
the cubing map is a bijection of `𝔽_q`. This is now proved in Lean:

* `Cubing.cube_eq_one` — if `3 ∤ q−1`, the only cube root of unity in `𝔽_q`
  is `1`;
* `Cubing.cube_injective` — `x ↦ x³` is injective;
* `Cubing.cube_bijective` — `x ↦ x³` is bijective.

The proof uses the cyclic unit group: `orderOf u ∣ 3` and
`orderOf u ∣ q−1 = #𝔽_q^*`, so `orderOf u ∣ gcd(3, q−1) = 1`. Footprint
`[propext, Classical.choice, Quot.sound]`.

This is a genuine general theorem (all primes `q` with `3 ∤ q−1`), not a finite
check.

---

## 3. Wild guess 12 — the cohomological jump

> **Wild guess 12.** Polynomiality of the twin count is a low-dimensional
> accident: the generic-class count is a polynomial exactly for `d ≤ 4`, where
> the twist geometry is an elliptic curve / an `𝔸¹`-bundle over a hyperelliptic
> surface (Bary-Soroker–Stix Thm. 1.5). At `d = 5` the geometry is
> higher-dimensional and the count is already non-polynomial. The barrier is the
> **jump in cohomological dimension at `d = 5`**: no finite-dimensional
> truncation of the twin motive suffices beyond `d = 4`.

**Evidence.**

* `d = 3, 4` have exact polynomial formulas (rounds 10–12).
* `d = 5` fails the degree-5 interpolation by `~1e6` (`§1`).
* The Bary-Soroker–Stix geometry is an elliptic curve at `d = 3`; for `d = 4`
  they do not compute the cohomology, but the polynomial formula exists
  empirically; for `d ≥ 5` the computations become "harder" in their own words.

**Why it is a guess.** We have no proof that `d = 5` is non-polynomial for *all*
`q` (only the nine generic primes above, plus the degree bound). The guess is
that the failure is structural (cohomological dimension), not a finite-data
artifact.

**What would falsify it.** A polynomial formula for the `d = 5` generic class
(e.g. from a Lefschetz computation on the `d = 5` variety) would show the jump
is not at `d = 5`. More primes (`q = 47, 53, …`) would test the interpolation
conclusion further.

---

## 4. Honest verdict

* **Established this round:** the `d = 5` generic count is not a polynomial
  (degree-5 interpolation fails on 9 primes, with a degree bound); the
  `d = 3,4` polynomial dichotomy; the general cubing-bijection theorem in Lean.
* **The wild guess:** the barrier is the cohomological jump at `d = 5`;
  supported by the `d ≤ 4` / `d = 5` contrast, not testable over `ℚ`.
* **Not claimed:** that `d = 5` is non-polynomial for every `q`; that the jump
  is exactly at `d = 5`; any construction of the `d = 5` cohomology.

## 5. Next round

1. **More `d = 5` primes** (`q = 47, 53`) to reinforce the interpolation
   conclusion (the degree bound already makes it rigorous for the tested set).
2. **Prove the `d = 4` polynomial** from the geometry (a Lefschetz computation
   on the `d = 4` variety), extending the exact-formula programme.
3. **Wild guess 13 (preview).** *The `d = 5` non-polynomiality is the first
   appearance of a **non-abelian** motive: the twist group at `d = 5` is the
   Frobenius group of order 20, whose 2-dimensional representations contribute a
   trace that is not a character sum. Over `ℚ`, the barrier is the non-abelian
   part of the twin motive.* Investigate: decompose the `d = 5` deviations into
   irreps of the order-20 group.

---

## 6. Reproduction

```
python3 checks/round12_degree5.py   # exit 0
python3 -m pytest -q tests/         # 244 passed
cd lean && ./check.sh Cubing.lean Axioms.lean   # OK
```

New files this round: `checks/round12_degree5.py`, `tests/test_round12.py`,
`lean/Cubing.lean`.
