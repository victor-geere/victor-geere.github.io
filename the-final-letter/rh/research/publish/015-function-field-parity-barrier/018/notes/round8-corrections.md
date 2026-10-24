# Round 8 — the `1/q` corrections are traces; degree 4 is a new motive

Round 7 showed the generating function is `Li₂` at leading order. This round
extracts the **first correction** `A_d(q) = q·(d² T(d;q)/q^d − 1)` and asks
whether it is a finite sum of Frobenius traces.

---

## 1. Established direction — the exact corrections

### `d = 2`: an exact character formula

For shift 2 (our `T(2)`), the count is `q·N` with
`N = #{d : χ(d)=χ(d−8)=−1}`; evaluating the character sum (using
`Σ_u χ(u²−16) = −1`) gives exactly

```
4·T(2;q)/q² = 1 − (3 − χ(2)(1+χ(−1)))/q ,
```

so

```
A_2(q) = −(3 − χ(2)(1+χ(−1)))  ∈  {−1, −3, −5} ,
```

namely `−1` for `q ≡ 1 (mod 8)`, `−5` for `q ≡ 5 (mod 8)`, and `−3` for
`q ≡ 3, 7 (mod 8)`. Verified for every `q` in the grid
(`checks/round8_corrections.py` §[A], `tests/test_round8.py`). This is a
**0-dimensional (Dirichlet-character) trace**, not a constant.

### `d = 3`: the branch formulas

Using the exact Bary-Soroker–Stix formula,

```
A_3(q) = q(9π(3,q)/q³ − 1) = {
  −1 − 2/q                       q ≡ 2 (mod 3),
  c_q² − 3 − 2/q                 q ≡ 1 (mod 3), 2 a cube,
  c_q·c_{q,2} − 8/q              q ≡ 1 (mod 3), 2 not a cube,
}
```

verified for every `q` in the grid (§[B]). Here `c_q = (1+q−#E)/√q` is the
Frobenius trace on `E: Y²−Y=X³`. So `A_3` is the trace on `Sym²(E)` (or on the
cubic twist), up to the explicit `−2/q`, `−8/q` tails.

### `d = 4`: a new motive

`A_4(q)` computed for all primes `5 ≤ q ≤ 61` (§[C]):

| `q` | 5 | 11 | 17 | 23 | 29 | 41 | 47 | 53 | 59 |
|---|---|---|---|---|---|---|---|---|---|
| `A_4(q)` | −2.44 | −1.48 | −1.06 | −1.22 | −1.72 | −2.07 | −1.11 | −0.96 | −1.09 |

All these `q` satisfy `q ≡ 2 (mod 3)`, where the elliptic-curve trace is
`c_q = 0` (supersingular). Yet `A_4` varies over `[−2.44, −0.96]`, a spread of
`1.48`. **So `A_4` is not a function of `c_q`**: the degree-4 correction is a
new arithmetic object, not a symmetric power of `E`.

### `d = 5, 6`: no clean split

`r_d = d²T/q^d` for `d = 5, 6` interleaves across `q mod 3` and `q mod 4`
(§[D]); no analogue of the `q ≡ 2 (mod 3)` dichotomy survives.

---

## 2. Wild guess 8 — the corrections are `L`-values

> **Wild guess 8.** The first correction is a **Frobenius trace on a motive**
> `M_d`: `A_d(q) = Tr(Frob_q | M_d) + O(1/q)`. For `d = 2`, `M_2` is a sum of
> Dirichlet characters; for `d = 3`, `M_3 = Sym²(E)` (or the cubic twist); for
> `d = 4`, `M_4` is a genuinely new motive (a surface) that does not factor
> through `E`. Over `ℚ`, the barrier is that these `M_d` have **no known
> L-functions**: the corrections are traces without an analytic theory.

**Evidence for the guess.**

* `d = 2`: `A_2` takes the three values `−1, −3, −5` according to the
  Dirichlet characters `χ(2)`, `χ(−1)` — a 0-dimensional trace.
* `d = 3`: `A_3` is `c_q² − 3` (cube branch) or `c_q c_{q,2}` (non-cube branch)
  — traces on `Sym²(E)` and on the twist.
* `d = 4`: `A_4` varies while `c_q = 0`, so it cannot be a polynomial in `c_q`;
  a new motive is present.

**What would falsify it.** If `A_4` were a function of `c_q` (it is not), or if
`A_d` were a constant (it is not), the guess would fail. A positive test of the
"motive" claim would need the exact `d = 4` formula, which is not in the
literature.

**Why it is a guess.** "Trace of Frobenius on a motive" is a structural
statement, not a construction: over `ℚ` we cannot even name `M_4`. The guess
reframes the barrier as *the absence of the analytic theory of the `M_d`*, in
line with the "automorphic/spectral" route of the dictionary.

---

## 3. Lean — more of the `χ` table

`lean/Quad.lean` adds the degree-2 shift-2 counts at two more primes:

* `QuadEleven.pair11_shift_two : pairCount = 22`  (`𝔽₁₁`, `q ≡ 3 (mod 8)`);
* `QuadThirteen.pair13_shift_two : pairCount = 26` (`𝔽₁₃`, `q ≡ 5 (mod 8)`).

Together with `QuadSeven` (`𝔽₇`: 7, 7) and `CurveLift` (`𝔽₅`: 0 for shift 2),
this is a Lean-checked table of the `χ`-dependence that produces the
`A_2 ∈ {−1,−3,−5}` values.

---

## 4. Honest verdict

* **Established this round:** the exact degree-2 correction
  `A_2 = −(3−χ(2)(1+χ(−1)))`; the exact degree-3 branch formulas for `A_3`; the
  numerical fact that `A_4` varies on the supersingular class `c_q = 0`, so the
  `d=4` correction is a new arithmetic object; no congruence split at `d=5,6`.
* **The wild guess:** the corrections are traces of motives `M_d`; supported by
  `d=2,3,4`, not testable over `ℚ`.
* **Not claimed:** the existence of `M_4` over `ℚ`; any `L`-function for it;
  that the correction series terminates.

## 5. Next round

1. **Identify `M_4`.** Fit `A_4(q)` against traces of small genus-2 curves
   (and symmetric powers of `E`); if a match is found, that is a concrete
   "new motive" identity.
2. **`d = 5`.** Same for `A_5`; the grid is smaller (`q ≤ 31`), so start with a
   genus-2 / abelian-surface search.
3. **Wild guess 9 (preview).** *The `A_d(q)` are periods of the motives `M_d`,
   and the `d → ∞` limit is governed by a "stable" period; the barrier is that
   the stable period over `ℚ` is not a classical period (not in the ring of
   multiple zeta values).* Investigate: test whether `A_2, A_3` are MZV-like
   (rational combinations of `ζ`-values) in the function-field limit.

---

## 6. Reproduction

```
python3 checks/round8_corrections.py   # exit 0
python3 -m pytest -q tests/            # 170 passed
cd lean && ./check.sh Quad.lean Axioms.lean   # OK
```

New files this round: `checks/round8_corrections.py`, `tests/test_round8.py`,
`lean/Quad.lean`.
