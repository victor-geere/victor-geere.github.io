# Round 16 — the value-set collapse at `d = 6, 7` and the null-polynomial mechanism

Round 15 identified the `d = 5` extremal families as power maps. This round
extends the check to `d = 6, 7`, identifies the **null-polynomial** mechanism
behind the collapse, and records the derivative fact that rules out a
multiple-root explanation.

---

## 1. Established direction — the extremal families at `d = 6, 7`

The maximal-`I` families all have **tiny value sets**:

| `d` | `q` | `max I` | `(q−1)/2` | `|Im(g)|` | `q − I` |
|---|---|---|---|---|---|
| 6 | 5 | 3 | 2 | 2 | 2 |
| 7 | 5 | 4 | 3 | **1** | 1 |
| 6 | 7 | 4 | 3 | 3 | 3 |
| 7 | 7 | 6 | 3 | **1** | 1 |

At `d=7, q=7` the extremal family is the Artin-Schreier `x⁷ − x`; at `d=7, q=5`
it is `x⁷ + 4x⁴ = x⁴(x³ − 1)`, which vanishes on `𝔽₅` after using `x⁵ = x`
(so `x⁷ = x³` and `x⁴(x³−1) = x⁷ − x⁴ = x³ − x⁴ = x³(1−x)`).

## 2. The null-polynomial mechanism

A monic degree-`d` polynomial vanishing on all of `𝔽_q` exists exactly when
`d ≥ q`: it is

```
x^{d−q} · (x^q − x) ,
```

which is monic of degree `d` and vanishes on `𝔽_q` (Fermat). Hence

```
d ≥ q   ⇒   min |Im(g)| = 1 .
```

For `d < q` no null polynomial of degree `d` exists, so `|Im(g)| ≥ 2`. The
computed ranges confirm this:

| `d` | `q` | `min |Im|` | `max |Im|` |
|---|---|---|---|
| 4 | 5 | 2 | 4 |
| 4 | 7 | 3 | 7 |
| 5 | 5 | 1 | 5 |
| 5 | 7 | 3 | 7 |
| 6 | 5 | 1 | 5 |
| 6 | 7 | 2 | 6 |

But a full collapse to `|Im| = 1` is not necessary to break the cap: at
`d=6, q=7` the extremal family has `|Im| = 3` (with `d < q`) and already
`max I = 4 > 3`. Small images suffice.

---

## 3. Wild guess 16 — the characteristic-`p` collapse

> **Wild guess 16.** The value-set collapse is a **finite-field** phenomenon.
> `x^p − x` vanishes on all of `𝔽_p`; more generally `x^{d−q}(x^q−x)` collapses
> the image to a point for `d ≥ q`. Over `ℚ` there is **no** monic polynomial of
> degree `d` vanishing on all integers (a nonzero polynomial has finitely many
> roots), so the analogue of the extremal family is not a collapse but the
> **generic** behaviour of Hilbert irreducibility. The barrier is the absence of
> the characteristic-`p` collapse over `ℚ`: the `ℚ` twin problem lives in the
> generic regime, where the function-field argument gives no leverage.

**Evidence.**

* The null polynomial `x^{d−q}(x^q−x)` gives `min |Im| = 1` exactly for `d ≥ q`.
* The extremal families at `d=6,7` all have `|Im| ≤ 3`.
* `(x^5−x)' = −1` (Lean): the collapse is not caused by multiple roots — the
  polynomial is squarefree. It is caused by having **degree equal to the field
  size**, so it is the product of all linear factors.

**Why it is a guess.** The "over `ℚ` there is no collapse" statement is
elementary, but its consequence for the twin problem is heuristic. The
identification with Hilbert irreducibility is an analogy.

**What would falsify it.** A `ℚ` analogue of the null-polynomial collapse (e.g.
a polynomial family that is reducible for almost all `n` for a structural
reason) would undercut the "generic regime" reading.

---

## 4. Lean — squarefreeness of the collapsing polynomial

`lean/ArtinSchreier.lean` now also proves

```
derivative_X_pow_five_sub_X : (x^5 − x)' = −1   in  𝔽₅[x] .
```

So `x^5 − x` is squarefree: the value-set collapse is *not* a multiple-root
phenomenon. The collapse is purely because `deg = q` and the polynomial is the
product of all `q` linear factors. Footprint
`[propext, Classical.choice, Quot.sound]`.

---

## 5. Honest verdict

* **Established this round:** the `d=6,7` extremal families all have
  `|Im| ≤ 3`; the null-polynomial mechanism `x^{d−q}(x^q−x)`; the value-set
  ranges for `d=4,5,6`; squarefreeness of the collapsing polynomial in Lean.
* **The wild guess:** the collapse is characteristic-`p`; over `ℚ` the twin
  problem is in the generic (Hilbert-irreducibility) regime. Coherent, supported
  by the null-polynomial criterion, not testable over `ℚ`.
* **Not claimed:** that the collapse is the only `d ≥ 5` mechanism; that
  Hilbert irreducibility is literally the `ℚ` analogue; any proof of the `d=4`
  cap.

## 6. Next round

1. **Prove the `d=4` cap** — the remaining established-direction target. The
   value-set lower bound alone is insufficient (`|Im|` can be 2 at `q=5`); the
   quadratic-factor set `Q` must fill the gap.
2. **`d = 8, 9` extremal families** to see whether the minimal images persist.
3. **Wild guess 17 (preview).** *The `d=4` cap is the last case where the
   quadratic-factor set is large enough; at `d ≥ 5` the relevant factor set
   (quadratic for `d=5,6`, …) is too small. Over `ℚ`, the analogue is the
   failure of the "small sieve" beyond dimension 1.* Investigate: compute the
   size of `Q` as a function of `d`.

---

## 7. Reproduction

```
python3 checks/round16_extremal.py   # exit 0
python3 -m pytest -q tests/          # 276 passed
cd lean && ./check.sh ArtinSchreier.lean Axioms.lean   # OK
```

New files this round: `checks/round16_extremal.py`, `tests/test_round16.py`,
and the derivative theorem in `lean/ArtinSchreier.lean`.
