# Round 54 — synthesis: the cap chain and the three targets

Round 24 of the new goal.  This note assembles the **whole cap chain**, marks
every link as proved / verified / open, and records the status of the three
targets.

---

## 1. The cap chain

| # | link | status |
|---|---|---|
| 1 | translation: general ⇔ `a₃=0` | **verified** (r28) + Lean `Shift` |
| 2 | `a₃=0`: `R = (−Im g) ∪ Q` | **verified** all families `q ≤ 37` + Lean `Factorization` |
| 3 | `a₁=0` ⇒ `R = Q` | **proved** (r52) + Lean `Composition` |
| 3a | `a₂=0` ⇒ `|Q| = (q+1)/2` or `q` | **proved** (r53) + Lean `NegSquare` |
| 3b | `a₂≠0` ⇒ `|Q| = q − ⌊(q+2)/4⌋` | verified, not proved |
| 4 | `a₁≠0` ⇒ (V′): `|Im| ≥ (q+1)/2` | verified `q ≤ 89` |
| 4a | `S₄` law `|Im| = 5q/8 + O(√q)`, `C = 0.43` | verified, not proved |
| 4b | `q ≥ 25` via Chebotarev; `q ≤ 23` Lean | Lean `SmallCap` for `q ≤ 23` |

## 2. What is now proved

1. **Translation invariance** of the irreducible count (Lean `Shift`).
2. **`R = Q` for compositions** (`−Im ⊆ Q` by the explicit preimage
   `q = x²+a₂`; Lean `Composition`).
3. **`x⁴+b`**: `I = (q−1)/2` for `q ≡ 1 (mod 4)`, `I = 0` for `q ≡ 3 (mod 4)`
   (Lean `NegSquare`, Euler's criterion).
4. **The cap at `q = 5..23`** (Lean `SmallCap`, seven `decide` theorems).

## 3. What is verified but not proved

1. **The union identity** `R = −Im ∪ Q` (all quartics, `q ≤ 37`).
2. **The `a₂≠0` composition size** `|Q| = q − ⌊(q+2)/4⌋`.
3. **(V′) for `q ≤ 89`** (22 primes, zero violations, margin `0.1q`).
4. **The `S₄` law** with measured constant `0.43 < 0.5`.

## 4. Target B — the individual count

* **`d=4`**: exact decomposition
  `T(4;q,2) = A₄ + B₄χ₂(2) + 2Re(c₄χ₄(2))`; `c₄` pinned at `q = 17,41,73,89`;
  weight 4 (`|c₄|/q² ∈ [0.6,1.85]`).
* **`d=5`**: support on quintic characters; amplitudes `O(q²)`;
  `T/q⁵ → 1/25`; **no low-degree polynomial** (cubic interpolant misses by 18×).
* **No closed form** for either `c₄` or the `d=5` amplitudes.

## 5. Target C — the parity barrier

* `twinInd` is not multiplicative (Lean `Barrier.twinInd_not_mult`).
* `twinInd` is not a divisor sum `ζ * g` with **multiplicative** `g` (Lean
  `DivisorSum.twinInd_not_zeta_mul`).
* The full barrier (all finite sieve weights) is **not** reached: a general
  divisor sum with bounded support is not excluded, and excluding it is
  equivalent to the open infinitude of twins.

## 6. Wild guess 24 — the constant is the barrier

> **Wild guess 24 (final).** The cap is **one explicit constant** from a proof:
> `|Im| = 5q/8 + O(√q)` with constant `< 0.5`, plus the Lean finite base and
> the solved `x⁴+b` case.  That constant is a Weil bound for the splitting-type
> character sums.  Over `ℚ`, the same constant is the **error term for a fixed
> `y`-family**, and its absence is exactly the parity barrier: a sieve can see
> the main term `5q/8` but not the error.

**Evidence.**

* The measured constant `0.43` and the threshold `q = 25`.
* The finite base and `x⁴+b` are proved.
* The barrier statements of Target C are about **uniformity**, the same object.

**Why it is a guess.** The explicit constant is not proved; the `ℚ` reading is
an analogy.

---

## 7. Honest verdict

* **Target A** — reduced to two unproved inputs: the `a₂≠0` composition size and
  the explicit Chebotarev constant.  The `x⁴+b` case and `q ≤ 23` are proved.
* **Target B** — exact `d=4` decomposition, `d=5` structure, no closed form.
* **Target C** — two Lean theorems toward the barrier; the barrier itself is
  untouched.

No target is fully established.  The programme's gain is a **complete map**: the
cap is two lemmas away, and both are explicit and finite-dimensional.

---

## 8. Reproduction

```
python3 checks/round54_synthesis.py   # exit 0
```

The full suite: `python3 -m pytest -q tests/` and
`cd lean && ./check.sh` (see the README).
