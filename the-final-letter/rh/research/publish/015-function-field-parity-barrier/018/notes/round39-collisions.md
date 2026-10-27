# Round 39 — the exact collision identity

Round 9 of the new goal.  Target A gets an **exact identity** for the collision
count, which pins the second moment of the fiber distribution.

---

## 1. The collision identity

For `g(x) = x⁴+a₂x²+a₁x` and `D(s) = −(s³+2a₂s+2a₁)/s`,

```
Σ_y N(y)²  =  q + 2 · #{s ∈ 𝔽_q^* : D(s) is a nonzero square} .
```

Verified exactly at `q = 13,29,37,41` (`checks/round39_collisions.py` §[A2]):
`S = 9,18,22,23` equals the square count in every case.  (The `D(s)=0` values
are excluded: they give `x=y`, not a collision.)

## 2. The collision surplus

| `q` | 13 | 29 | 37 | 41 | 53 | 61 | 73 | 89 |
|---|---|---|---|---|---|---|---|---|
| `ΣN²` | 31 | 65 | 81 | 87 | 115 | 127 | 151 | 193 |
| `S` | 9 | 18 | 22 | 23 | 31 | 33 | 39 | 52 |
| `ΣN²/(2q)` | 1.192 | 1.121 | 1.095 | 1.061 | 1.085 | 1.041 | 1.034 | 1.084 |

The surplus `ΣN²/(2q) − 1` decays (random-map value `1`), and `S` sits just
above `(q−1)/2` (e.g. `9 > 6` at `q=13`).

## 3. What the identity does and does not give

Cauchy–Schwarz gives `|Im| ≥ q²/ΣN² = q²/(q+2S)`.  So `2S ≤ q−2` would imply
(V).  But the identity shows `S` **exceeds** `(q−1)/2` for the extremal
families, so `2S ≤ q−2` is **false** in general — and (V) nevertheless holds.

So (V) can hold even when the moment bound fails: the fiber distribution is
more uniform than its second moment.  The identity is a **negative** input to
the moment route, not a proof of (V).

Equivalently, `ΣN² = 2q − 1 − cnt₀ − a_E` where `a_E` is the trace of the
plane cubic `s y² = −(s³+2a₂s+2a₁)`; the sign of `a_E` is not fixed.

---

## 4. Target B — `d=5` amplitudes

Unchanged: support `k = 2,4,6,8` at `q=11`, magnitudes `20.11, 98.99, 98.99,
20.11`, and `O(q²)` (`max|amp|/q² = 0.818`).

---

## 5. Wild guess 9 — the cubic trace

> **Wild guess 9.** The collision count is the point count of the **plane
> cubic** `s y² = −(s³+2a₂s+2a₁)`, so `ΣN² = 2q−1−cnt₀−a_E`.  The value set is
> `q²/ΣN²`, and (V) holds because the fiber distribution is *more uniform* than
> the second moment allows — i.e. (V) is a **higher-moment / uniformity**
> statement about a genus-1 trace, not a second-moment bound.

**Evidence.**

* The exact identity (`§1`).
* `S > (q−1)/2` at the extremal families (`§2`).
* (V) holds with a `0.1q` margin (round 37).

**Why it is a guess.** No uniformity estimate is proved; the cubic trace is
identified only tentatively.

**What would falsify it.** A family with `S` large **and** `|Im| < (q+1)/2`
would show the uniformity reading is wrong.

---

## 6. Lean — the even symmetry

`EvenQuartic.even_quartic_neg : (−x)⁴ + a₂(−x)² = x⁴ + a₂x²`, the symmetry
behind the even-fiber structure.  Footprint
`[propext, Classical.choice, Quot.sound]`.

---

## 7. Honest verdict

* **Target A — exact identity.** `ΣN² = q + 2S` with `S` the cubic square count;
  the moment route to (V) is definitively closed (`S > (q−1)/2`).
* **Target B — unchanged.**
* **Target C — unchanged.**
* **The wild guess:** (V) is a uniformity/higher-moment statement about a
  genus-1 trace.

## 8. Next round

1. **Higher moments**: compute `Σ N(y)^3` and `Σ N(y)^4` for the extremisers and
   test the uniformity.
2. **The cubic trace**: compute `a_E` for the extremisers.
3. **Target B**: the `d=5` coefficient formula.

---

## 9. Reproduction

```
python3 checks/round39_collisions.py   # exit 0
python3 -m pytest -q tests/test_round39.py   # 4 passed
cd lean && ./check.sh EvenQuartic.lean Axioms.lean  # OK
```

New files: `checks/round39_collisions.py`, `tests/test_round39.py`;
`lean/EvenQuartic.lean` extended with `even_quartic_neg`.
