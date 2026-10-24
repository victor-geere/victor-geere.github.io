# Round 35 — the critical cubic; the `d=5` quintic support

Round 5 of the new goal.  Target A gets a **negative** structural result (the
critical cubic does not control the value set monotonically); Target B gets the
`d=5` support confirmed.

---

## 1. Target A — the critical cubic

`g(x) = x⁴+a₂x²+a₁x` has `g'(x) = 4x³+2a₂x+a₁` (Lean:
`DerivativeQ.deriv_quartic`).  The critical points are the roots of this cubic.
Tabulating `(#critical points, |Im g|)` for `a₁ ≠ 0`:

| `q` | `crit = 0` | `crit = 1` | `crit = 2` | `crit = 3` |
|---|---|---|---|---|
| 13 | [7,10] | [8,10] | [9,9] | [8,10] |
| 29 | [17,20] | [17,20] | [19,19] | [18,20] |

The ranges **overlap**: the number of critical points does not determine `|Im|`.
The extremal case `x⁴+x` (`a₂=0, a₁=1`) has **no critical point** in `𝔽_q` and
the smallest image, `|Im| = (q+1)/2` at `q=13`.

So the "genus-1 derivative data" of round 34 does not give (V) by a simple
monotonicity.  The critical **values**, not the critical points, would be the
right object.

## 2. Target B — the `d=5` support

The `d=5` shift dependence is supported exactly on the **quintic** characters
`k = multiple of (q−1)/5`:

| `q` | support `k` | `\|c_k\|` |
|---|---|---|
| 11 | 2,4,6,8 | 20.1, 99.0, 99.0, 20.1 |
| 41 | 8,16,24,32 | 3133.6, 4378.3, 4378.3, 3133.6 |

The coefficients lie in `ℚ(ζ₅)`; no closed form is identified, but the support
is exactly the quintic torsion, as predicted by round 11.

---

## 3. Wild guess 5 — critical values, not critical points

> **Wild guess 5.** The value set of `g = x⁴+a₂x²+a₁x` is governed by the
> **critical values** `g(c)` at the roots of `4c³+2a₂c+a₁ = 0`, not by the
> critical points.  The extremal `x⁴+x` has no critical point, so its image is
> an unramified coset union of size `(q+1)/2`.  Over `ℚ`, the critical values
> are the stationary points of the polynomial, and the parity barrier is that a
> sieve sees values, not critical values.

**Evidence.**

* The critical-point count does not determine `|Im|` (`§1`).
* The extremal has zero critical points (`§1`).
* The `d=5` support is exactly the quintic torsion (`§2`).

**Why it is a guess.** No formula involving critical values is derived; the `ℚ`
reading is an analogy.

**What would falsify it.** Two quartics with the same critical values but
different `|Im|` would break the reading.

---

## 4. Lean — the derivative identity

`lean/DerivativeQ.lean`:

```
deriv_quartic (a₂ a₁ : R) :
  derivative (X⁴ + C a₂ X² + C a₁ X) = C 4 · X³ + C (2a₂) · X + C a₁
```

The critical-point cubic, as a polynomial identity.  Footprint
`[propext, Classical.choice, Quot.sound]`.

---

## 5. Honest verdict

* **Target A — negative.** The critical cubic does not control `|Im|`
  monotonically; (V) remains open, now with the critical-value guess.
* **Target B — partial.** `d=5` support is quintic; coefficients in `ℚ(ζ₅)`,
  no closed form.
* **Target C — unchanged.**
* **The wild guess:** critical values, not critical points.

## 6. Next round

1. **Critical values**: compute `{g(c) : g'(c)=0}` and correlate with `|Im|`.
2. **The `x⁴+x` case**: prove `|Im(x⁴+a₁x)|` for the no-critical-point family.
3. **Target B**: the `d=5` coefficient formula.

---

## 7. Reproduction

```
python3 checks/round35_derivative.py   # exit 0
python3 -m pytest -q tests/test_round35.py   # 2 passed
cd lean && ./check.sh DerivativeQ.lean Axioms.lean   # OK
```

New files: `checks/round35_derivative.py`, `tests/test_round35.py`,
`lean/DerivativeQ.lean`.
