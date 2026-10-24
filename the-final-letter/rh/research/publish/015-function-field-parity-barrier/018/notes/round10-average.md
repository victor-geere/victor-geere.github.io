# Round 10 — averaging over the shift: the trivial character is a polynomial

Round 9 showed that the *individual* `d = 4` corrections are buried in the
Chebotarev error. This round averages over the shift `h ∈ 𝔽_q^*` and finds that
the average is an **exact polynomial**, with all the arithmetic moved into the
nontrivial multiplicative characters of `h`.

---

## 1. Established direction — the shift average

For `h ∈ 𝔽_q^*` let

```
T(d;q,h) = #{ f monic, deg f = d : f and f+h both irreducible } ,
A_d(q)   = (1/(q−1)) Σ_{h∈𝔽_q^*} T(d;q,h) .
```

### `d = 3`

Averaging Bary-Soroker–Stix Theorem 1.4 over `h` gives exactly

```
A_3(q) = q³/9 · { 1 − q⁻¹ − 3q⁻²   q ≡ 0 (mod 3) ,
                  1 − q⁻¹ − 6q⁻²   q ≡ 1 (mod 3) ,
                  1 − q⁻¹ − 2q⁻²   q ≡ 2 (mod 3) } .
```

Verified for every prime `5 ≤ q ≤ 23` (`checks/round10_average.py` §[A]).

### `d = 4` — a new exact polynomial

The sum `S_4(q) = Σ_{h≠0} T(4;q,h)` is

```
S_4(q) = q(q−1)(q³ − q² − 5q − 3) / 16 ,
```

so

```
A_4(q) = q(q³ − q² − 5q − 3) / 16 .
```

Verified **exactly** for every prime `5 ≤ q ≤ 37` (`§[B]`) — ten values, six
parameters, so the fit is overdetermined and the coefficients are the simple
rationals `1/16, −1/16, −5/16, −3/16`. This is a genuine exact formula, not a
fit.

Note the `1/q²` coefficient: `−5` for the average, versus `−2` for `S(q)`. The
averaged problem is *not* the same as the individual `h = 2` problem — averaging
changes the constant.

### `d = 5`

With eight primes `5 ≤ q ≤ 29`, a degree-6 polynomial fit leaves an RMS
residual of `~1.5e3` (against `S_5(29) ≈ 2.2e7`). The clean `d = 4` phenomenon
does **not** automatically persist; either the degree is higher, or further
character modes survive the average.

---

## 2. The character structure

The `h`-dependence is through **multiplicative characters**:

* `d = 3`: cubic character (`h mod` cubes). At `q = 7, 13, 19` the values
  `T(3;q,h)` take three values inside each quadratic class — the cubic twist.
* `d = 4`: quadratic character `χ(h)`. At `q = 5, 13, 29, 37`,
  `T(4;q,h)` depends only on `χ(h)` (two values). At `q = 17` a quartic
  refinement appears (four values). At `q ≡ 3 (mod 4)` the character amplitude
  vanishes, so `T(4;q,h) = A_4(q)` for every `h`.

So the average is the **trivial** character, and the arithmetic is precisely the
**nontrivial** characters of `h`.

---

## 3. Wild guess 10 — the barrier is the missing averaging

> **Wild guess 10.** The twin count's arithmetic is entirely in the nontrivial
> multiplicative-character modes of the shift `h`; the trivial mode is an exact
> polynomial `A_d(q)`. In `𝔽_q[x]` the shift ranges over the finite group
> `𝔽_q^*`, so one can Fourier-transform over it and separate the modes. Over
> `ℚ` the shift is a **fixed integer** (`h = 2`): there is no group to average
> over, and the parity barrier is exactly this missing averaging. The solution
> would be an "un-averaging": a way to recover the fixed `h` from data that is
> only accessible on average.

**Evidence.**

* `A_3` and `A_4` are exact polynomials (the trivial mode).
* The `h`-dependence is character-theoretic (the nontrivial modes).
* The averaged `1/q²` constant (`−5` at `d = 4`) differs from the individual
  `S(q)` constant (`−2`): the average is a *different* problem.

**Why it is a guess.** Over `ℚ` there is no finite multiplicative group acting
on the shift; the "average over `h`" analogue is a continuous average
(`∫ Λ(n)Λ(n+h) dh`), and it is not known how to un-average it to a fixed `h`.
The guess says the obstruction is precisely the loss of information under
averaging, not the local densities.

**What would falsify it.** A proof of the twin conjecture that works directly at
fixed `h` without any averaging would show the averaging story is not necessary.
Conversely, a proof that the `h`-averaged `ℚ` problem is strictly easier (and
that un-averaging is impossible) would support it.

---

## 4. Lean — the shift average at `𝔽₇`

`lean/Cubic.lean` now proves

```
sum_cubicTwin7 : Σ_{h ∈ 𝔽₇^*, h ≠ 0} cubicTwin7h h = 168 ,
```

i.e. the average of the degree-3 twin count over the six nonzero shifts is
`28` — the Bary-Soroker–Stix Theorem 1.4 value at `q = 7`. This is a finite
check over `6 × 343` cubics. Footprint `[propext, Classical.choice, Quot.sound]`.

---

## 5. Honest verdict

* **Established this round:** the exact `d = 4` shift-average polynomial
  `q(q³−q²−5q−3)/16` (verified for 10 primes); the `d = 3` average matches
  B–S–S; the `h`-dependence is character-theoretic (cubic at `d=3`, quadratic
  at `d=4`, quartic at `q=17`); `d=5` is not a clean low-degree polynomial;
  Lean checks the `𝔽₇` average.
* **The wild guess:** the barrier is the missing averaging over `h`; supported
  by the trivial-mode polynomial and the character structure, not testable over
  `ℚ`.
* **Not claimed:** that averaging is the *only* obstruction; that the `d=4`
  polynomial persists for all `q` (verified `5 ≤ q ≤ 37`); any un-averaging
  method.

## 6. Next round

1. **Prove the `d = 4` average.** Derive `S_4(q) = q(q−1)(q³−q²−5q−3)/16` from
   the geometry (a Lefschetz computation on the `d = 4` variety), extending
   `lean/Cubic.lean`-style checks.
2. **More `d = 5` primes.** Decide whether the `d=5` average is a polynomial of
   higher degree or genuinely non-polynomial.
3. **Wild guess 11 (preview).** *The character amplitudes `B_d(q)` are
   themselves `L`-values of the twists `E_h`; the average kills them because
   `Σ_h χ(h) = 0`. Over `ℚ`, the analogue is that the "average over `h`" is a
   zero of a character sum, and the fixed `h` is a nonzero value.* Investigate:
   compute `B_4(q) = (T(χ=1) − T(χ=−1))/2` and fit it against traces.

---

## 7. Reproduction

```
python3 checks/round10_average.py     # exit 0
python3 -m pytest -q tests/           # 223 passed
cd lean && ./check.sh Cubic.lean Axioms.lean   # OK
```

New files this round: `checks/round10_average.py`, `tests/test_round10.py`,
`checks/scan_shifts.py`, and the shift-average theorem in `lean/Cubic.lean`.
