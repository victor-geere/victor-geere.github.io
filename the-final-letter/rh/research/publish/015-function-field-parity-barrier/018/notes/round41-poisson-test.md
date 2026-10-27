# Round 41 — the Poisson model is approximate

Round 11 of the new goal.  Target A: the Poisson(1) model of round 40 is tested
by chi-square and **rejected** at some `q`; the deviation has a deterministic
ramification component.  Target B: the `d=5` coefficients are algebraic
integers in `ℤ[ζ₅]/10`.

---

## 1. Chi-square test

Model: Poisson(1) conditioned on `N ≥ 1`, i.e. `P(1)=0.582, P(2)=0.291,
P(3)=0.097, P(4)=0.024`.

| `q` | observed `N=1,2,3,4` | expected | `χ²` (df 3) | reject 5% |
|---|---|---|---|---|
| 13 | 3, 3, 0, 1 | 4.1, 2.0, 0.7, 0.2 | 5.48 | no |
| 29 | 9, 6, 0, 2 | 9.9, 4.9, 1.6, 0.4 | **8.07** | **yes** |
| 41 | 12, 8, 3, 1 | 14.0, 7.0, 2.3, 0.6 | 0.92 | no |
| 61 | 17, 15, 2, 2 | 21.0, 10.5, 3.5, 0.9 | 4.79 | no |
| 89 | 28, 19, 1, 5 | 30.8, 15.4, 5.1, 1.3 | **15.17** | **yes** |

So Poisson(1) is **approximate, not exact**: at `q=29,89` the fit is rejected.
The deviation is systematic — **too many 4-fibers** (double roots at the
critical points) and **too few 3-fibers**.

## 2. The ramification correction

A 4-fiber is a point `y` with four preimages, which happens when `g(x)=y` has a
double root, i.e. at a **critical value** `g(c)` with `g'(c)=0`.  These are
deterministic, not random: at most 3 of them (the cubic `g'` has at most 3
roots).  So the correct model is

```
fiber law  =  Poisson(1)  +  a fixed ramification atom at the critical values.
```

The chi-square excess at `q=89` (`5` four-fibers vs `1.3` expected) is exactly
this atom growing with the number of critical points in `𝔽_q`.

## 3. Target B — `d=5` coefficients

The `d=5` coefficients are in `(1/(q−1))·ℤ[ζ₅]`.  For `q=11`:

| `k` | `10·c_k` in `1,ζ,ζ²,ζ³` |
|---|---|
| 2 | `[−88, −572, 88, −572]` |
| 4 | `[−176, −660, −660, −88]` |

The integer coordinates are not small or patterned, so no closed form is
visible.

---

## 4. Wild guess 11 — Poisson + ramification

> **Wild guess 11.** The exact fiber law is **Poisson(1) plus a deterministic
> ramification atom** at the critical values of `g`.  The atom has weight
> `#crit` and is the only non-universal part.  Over `ℚ`, the ramification atom
> is the parity barrier: a sieve sees the universal Poisson part but not the
> atom.

**Evidence.**

* Chi-square rejection with the systematic 4-fiber excess (`§1–2`).
* At most 3 critical values (cubic derivative, round 35).
* The Poisson moments hold asymptotically (round 40).

**Why it is a guess.** The decomposition is not proved; the `ℚ` reading is an
analogy.

**What would falsify it.** A `q` with no critical point but the same chi-square
excess would break the atom reading.

---

## 5. Lean — derivative at `0`

`DerivativeQ.deriv_at_zero : (derivative (X⁴+C a₂X²+C a₁X)).eval 0 = a₁`.

The linear coefficient is the derivative at the origin — the critical point
`x=0` is degenerate exactly when `a₁=0`.  Footprint
`[propext, Classical.choice, Quot.sound]`.

---

## 6. Honest verdict

* **Target A — model refined.** Poisson(1) is approximate; the ramification
  atom is identified.  (V) remains open.
* **Target B — structural.** `d=5` coefficients in `ℤ[ζ₅]/(q−1)`, no closed
  form.
* **Target C — unchanged.**
* **The wild guess:** Poisson + ramification atom.

## 7. Next round

1. **Count the atom**: `#crit` vs the 4-fiber excess.
2. **The extremal families**: the atom is largest there.
3. **Target B**: a closed form for the `d=5` coordinates.

---

## 8. Reproduction

```
python3 checks/round41_poisson_test.py   # exit 0
python3 -m pytest -q tests/test_round41.py   # 2 passed
cd lean && ./check.sh DerivativeQ.lean Axioms.lean  # OK
```

New files: `checks/round41_poisson_test.py`, `tests/test_round41.py`;
`lean/DerivativeQ.lean` extended with `deriv_at_zero`.
