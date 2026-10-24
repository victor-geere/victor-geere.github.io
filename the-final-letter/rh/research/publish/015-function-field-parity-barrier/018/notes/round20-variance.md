# Round 20 — the two-point variance

Round 19 identified the one-point/two-point gap. This round computes the
**two-point variance** `Var(T) = (1/(q−1)) Σ_h (T(h) − A)²` and identifies it
as the Plancherel mass of the character expansion — a computable "diagonal"
quantity.

---

## 1. Established direction — the variance

`checks/round20_variance.py` §[A]:

| `d` | `q` | `Var(T)` |
|---|---|---|
| 2 | 5 | 6.25 |
| 2 | 13 | 42.25 |
| 2 | 17 | 72.25 |
| 3 | 7 | 32.67 |
| 3 | 13 | 713.56 |
| 3 | 19 | 3449.56 |
| 4 | 5 | 6.25 |
| 4 | 13 | 3422.25 |
| 4 | 17 | 80992.25 |
| 5 | 11 | 20405.44 |
| 5 | 31 | 38271479.04 |

The variance is **nonzero exactly when the character amplitude is nonzero**:

* `d=2,4`: nonzero for `q ≡ 1 (mod 4)`, zero for `q ≡ 3 (mod 4)`;
* `d=3`: nonzero for `q ≡ 1 (mod 3)`, zero otherwise;
* `d=5`: nonzero for `5 | q−1`, zero otherwise.

So the two-point variance is supported precisely on the `d`-torsion characters
(cf. round 11).

**Plancherel** (`§[B]`).  With `c_k` the multiplicative Fourier coefficients,

```
Var(T) = Σ_{k≠0} |c_k|² ,
```

verified for `d=2,3,4` and several `q` (e.g. `q=5,13,17`).  The variance is the
**diagonal** mass of the character expansion.

**`d=4`, `q ≡ 5 (mod 8)`.**  The expansion has only the quadratic character, so
`T = A ± B`, and

```
Var(T) = B_4(q)²   exactly,
```

verified for `q = 5, 13, 29, 37` (`§[C]`): `Var = 25/4, 13689/4, 2732409/4,
1315609/4`.

---

## 2. The diagonal/off-diagonal reading

The variance is computable and vanishes in the generic class.  The individual
`T(d;q,2)` is **not** determined by the variance: it needs the *values* of the
characters at `h = 2`, not just their squared magnitudes.  In the `d=4,
q ≡ 5 (mod 8)` case:

```
T(4;q,2) = A_4(q) + B_4(q)·χ(2) ,
```

so the individual count is `A ± B`; the variance `B²` gives `|B|` but not the
sign, and the sign is `χ(2)` (computable here, but the analogue over `ℚ` is not).

---

## 3. Wild guess 20 — diagonal versus off-diagonal

> **Wild guess 20.** The two-point variance is the **diagonal** of the
> two-point correlation: it is a sum of squares of character amplitudes and is
> exactly computable in the function field.  The individual twin count at a
> fixed shift needs the **off-diagonal**: the phases `χ(2)`, i.e. the character
> values at the specific shift. Over `ℚ` the diagonal is the singular series /
> the variance of the additive divisor correlation; the off-diagonal is the
> Kloosterman/spectral sum. The parity barrier is the failure to control the
> off-diagonal — the diagonal is not enough.

**Evidence.**

* Plancherel: the variance is exactly `Σ|c_k|²`, a diagonal quantity.
* `T = A + B·χ(2)`: the variance gives `|B|`, the individual count needs
  `χ(2)`.
* The variance vanishes in the generic class while the individual count is
  still `O(q^d)`; the variance is a small correction, not the main term.

**Why it is a guess.** The identification of "off-diagonal" with the `ℚ`
Kloosterman/spectral sum is an analogy. There is no proof that the variance is
the *only* diagonal quantity, nor that the off-diagonal is the *only*
obstruction.

**What would falsify it.** A proof of the twin conjecture from variance-type
(diagonal) data alone would show the off-diagonal is not needed.

---

## 4. Lean — the `d=2` variance at `𝔽₅`

`lean/Variance.lean` proves

```
twin2_values : twin2 1 = 5 ∧ twin2 2 = 0 ∧ twin2 3 = 0 ∧ twin2 4 = 5
```

over `𝔽₅`: the degree-2 twin count takes only the values `5` and `0`, so its
variance over the four shifts is `25/4`. Footprint
`[propext, Classical.choice, Quot.sound]`.

---

## 5. Honest verdict

* **Established this round:** the variance table; the Plancherel identity
  `Var = Σ_{k≠0}|c_k|²`; the `d=4` formula `Var = B_4²` for `q ≡ 5 (mod 8)`;
  the diagonal/off-diagonal reading; the Lean `d=2` variance.
* **The wild guess:** the variance is the diagonal, the individual count needs
  the off-diagonal. Coherent, supported by Plancherel and the `A ± B` structure,
  but the `ℚ` identification is heuristic.
* **Not claimed:** that the diagonal is sufficient for anything beyond the
  average; that Kloosterman sums are literally the off-diagonal; any new bound.

## 6. Next round

1. **The `d=4` cap, final attempt**: `|Im ∪ Q| ≥ (q+1)/2` via the
   quadratic-factor parametrization (the one remaining established-direction
   target).
2. **Higher variance moments**: compute `Σ_h (T(h)−A)^4` and see whether the
   character expansion predicts it (a four-point check).
3. **Wild guess 21 (preview).** *The off-diagonal is a **spectral** object: the
   phases `χ(2)` are the eigenvalues of a Hecke operator, and the parity barrier
   is the failure of the spectral gap to give the fixed-shift count.*
   Investigate: fit `B_4(q)` against Hecke eigenvalues.

---

## 7. Reproduction

```
python3 checks/round20_variance.py   # exit 0
python3 -m pytest -q tests/          # 314 passed
cd lean && ./check.sh Variance.lean Axioms.lean   # OK
```

New files this round: `checks/round20_variance.py`, `tests/test_round20.py`,
`lean/Variance.lean`.
