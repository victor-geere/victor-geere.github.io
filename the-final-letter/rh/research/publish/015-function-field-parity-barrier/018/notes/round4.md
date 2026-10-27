# Round 4 — the three follow-ups of §7: fixed-`q` status, the oscillation, the curve lift

This round executes the three "next steps" listed in
[`round3-formal-statement.md`](round3-formal-statement.md) §7. Two of them
produced clean results; the second produced a **correction of the round-2/3
numerical constant**.

| step | question | outcome |
|---|---|---|
| 1 | is the fixed-`q`, `n→∞` twin asymptotic a theorem? | **no** — it is open; sources prove only `q→∞`. Kept as Pollack's Conjecture 2. |
| 2 | is the even/odd oscillation a second-order main term? | **no** — the "O(1/n), slow" diagnosis was caused by a floating-point bug in `S(q)`; with the corrected constant the approach is fast, and the residual oscillation is arithmetic. |
| 3 | does the separation lift to a curve? | **yes** — on a fixed curve the pair statistic depends on the map `π : C → P¹`; witness on `P¹/𝔽₅` with pair counts `0` and `5`. Lean: `CurveLift.curve_separation`. |

---

## 1. Step 1 — status of the fixed-`q` theorem

**The question.** Is `T(n) = (1+o(1)) S(q) qⁿ/n²` for *fixed* `q` and `n → ∞`
a theorem?

**What the literature says.**

* **Pollack, Theorem A** (in *An explicit approach to Hypothesis H for
  polynomials over a finite field*, Anatomy of Integers, CRM Proc. Lecture Notes
  46, 2008) proves

  ```
  #{g monic deg n : f_1(g),…,f_r(g) all prime} = qⁿ/nʳ + O_{n,B}(q^{n-1/2})
  ```

  when `q` is large compared to `n` and `gcd(q,2n)=1`.

* **Bary-Soroker** (*Irreducible values of polynomials*, Adv. Math. 229 (2012);
  arXiv:1005.4528) is explicit about the regime:

  > “The asserted constant in Pollack's theorem is of order of magnitude
  > `(n!)^B`, hence the asymptotic is *useless when n → ∞*, but it works when
  > `n` is fixed and `q → ∞`. A **conjectural** formula for `qⁿ → ∞` is given
  > in [Conrad–Conrad–Gross / Pollack], there the main term depends on local
  > data.”

  So `qⁿ → ∞` (which includes fixed `q`, `n → ∞`) is *conjectural*, and the
  large-`q` error term `O(q^{n-1/2})` is larger than the main term once
  `q ≪ n²`.

* **Bary-Soroker–Stix**, *Cubic twin prime polynomials are counted by a modular
  form* (2017), introduce the regime explicitly:

  > “If we fix `h`, this only makes sense with fixed `q` and `d → ∞`, and this
  > case should be considered an analog of Conjecture 1.1 [Hardy–Littlewood]
  > for the field `F_q(T)`.”

  They compute the degree-3 count exactly for every `q` via a Lefschetz trace
  formula; the result involves the elliptic curve `X³ = Y(Y−1)`, agrees with
  the Hardy–Littlewood heuristic for `q ≡ 2 (mod 3)`, and shows **anomalies for
  `q ≡ 1 (mod 3)`**.

**Conclusion.** The fixed-`q`, `n → ∞` asymptotic is **open** in the literature
we could locate (through 2017). It is exactly Pollack's Conjecture 2, and it is
labelled as a conjecture in `README.md` §8 and
`round3-formal-statement.md` §3. The normalisation (constant `S(q)`, no extra
factor) is not affected: it follows from `ω(P) = 2` and `∏ deg f_i = 1`.

A concrete, checkable consequence of the Bary-Soroker–Stix computation is
recorded in step 2 below: for `q ≡ 2 (mod 3)`, `T(3) = q(q−2)(q+1)/9` exactly.

---

## 2. Step 2 — the oscillation: a floating-point bug, not a second-order term

### 2.1 The bug

Round 2 evaluated

```
S(q) = ∏_{d} ( (1 − 2/q^d) / (1 − 1/q^d)^2 )^{I(d)}
```

in double precision. For large `d` the ratio `(1−2/Q)/(1−1/Q)²` rounds to
`1 + ε` with `ε ≈ 1e-16`; `log` turns that into `±1e-16`, and multiplying by
`I(d) ≈ q^d/d` (up to `~1e17` for `d ≈ 40`) produces spurious terms of size
`~0.1`. The product therefore **drifts**:

| `q` | naive (round 2/3) | correct | error |
|---|---|---|---|
| 3 | 0.461349767 | **0.396104282** | +6.5·10⁻² |
| 5 | 0.709170386 | **0.709544330** | −3.7·10⁻⁴ |
| 7 | 0.831729087 | **0.812706003** | +1.9·10⁻² |
| 11 | 0.897079310 | **0.891686831** | +5.4·10⁻³ |
| 13 | 0.887689499 | **0.910722904** | −2.3·10⁻² |

The fix is elementary: use the algebraically identical, numerically stable form

```
S(q) = ∏_{d} (1 − 1/(q^d − 1)^2)^{I(d)}
```

with `log1p`, or exact rationals / high-precision arithmetic. This is now in
[`lib/singular_series.py`](../lib/singular_series.py), with
`S_exact` (small `D`), `S_sym` (symbolic log), `S_mp` (mpmath) and `S_bounds`.
Unit tests: [`tests/test_singular_series.py`](../tests/test_singular_series.py).

**This correction reverses the qualitative picture of round 2/3.**

### 2.2 The corrected deviations

`D(n) = T(n)n²/qⁿ − S(q)`, with the fast sieve data
([`lib/fast_twin.py`](../lib/fast_twin.py), validated against the brute force
up to `n = 12` and against the Möbius irreducible counts to `n = 16`):

`q = 3`, `S(3) = 0.396104281655`:

| `n` | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 |
|---|---|---|---|---|---|---|---|---|
| `D(n)` | +3.60e−2 | −3.03e−2 | +3.48e−3 | +1.20e−2 | +1.08e−3 | −6.40e−3 | +4.61e−3 | **+3.4e−6** |

`q = 5`, `S(5) = 0.709544330307`:

| `n` | 7 | 8 | 9 | 10 | 11 |
|---|---|---|---|---|---|
| `D(n)` | +5.46e−3 | +2.77e−2 | +6.47e−3 | **−3.2e−4** | +6.18e−3 |

`q = 7`, `S(7) = 0.812706003387`:

| `n` | 5 | 6 | 7 | 8 | 9 |
|---|---|---|---|---|---|
| `D(n)` | +2.03e−2 | +3.38e−3 | +1.73e−2 | +3.90e−3 | −7.69e−3 |

### 2.3 No `c/n` term

If `D(n) ~ c/n` then `n D(n)` would converge to `c`. It does not:

* `q = 3`, `nD` for `n = 9…16`: `0.324, −0.303, 0.038, 0.144, 0.014, −0.090, 0.069, 0.0001`.
* `q = 5`, `nD` for `n = 7…11`: `0.038, 0.222, 0.058, −0.003, 0.068`.
* `q = 7`, `nD` for `n = 5…9`: `0.101, 0.020, 0.121, 0.031, −0.069`.

Least-squares fits of `D(n)` against `{0, 1/n, 1/n², (−1)ⁿ/n, (−1)ⁿ/n²}` leave
most of the RMS unexplained (best model still ≈ 0.64–0.71 of the RMS of `D`).
The envelope does shrink: for `q = 3`, `max|D|` over `n ∈ [6,9]`, `[10,13]`,
`[14,17]` is `9.98e−2`, `3.03e−2`, `6.40e−3`; for `q = 5` it drops from
`1.57e−1` to `6.18e−3`. This is consistent with an exponentially small
Chebotarev/Weil error, not with a `1/n` main term.

**So the "O(1/n), slow convergence" of rounds 2–3 was an artefact of the wrong
constant.** With `S(q)` correct, the approach is fast: the cleanest check is
now `q = 3, n = 16`, where `T n²/qⁿ = 0.396107662` versus
`S(3) = 0.396104282` (relative error `8.5e−6`).

### 2.4 What the residual oscillation is: arithmetic

The Bary-Soroker–Stix degree-3 result gives a precise example. For
`q ≡ 2 (mod 3)`,

```
T(3) = q(q−2)(q+1) / 9      exactly,
```

verified here for `q = 5, 11, 17, 23, 29` (sympy exact rationals, and the finite
`q = 5` case in Lean as `CubicTwins.cubicTwin_five`). For `q ≡ 1 (mod 3)` the
count deviates from this polynomial, and the deviation is governed by the trace
of Frobenius on `X³ = Y(Y−1)` — an *arithmetic* fluctuation of size `O(√q)`,
not a smooth correction. The same phenomenon is what the residual `D(n)`
oscillation reflects at fixed `q`.

**Answer to step 2.** The oscillation is *not* a genuine second-order main term
`c/n` (or `c(−1)ⁿ/n`): `nD(n)` does not converge, and no such fit works. It is
a finite-`n`/arithmetic fluctuation riding on an exponentially small error
term. The earlier "slow `O(1/n)`" observation was a numerical artefact.

---

## 3. Step 3 — lifting the separation to a curve

### 3.1 The statement

Let `C/𝔽_q` be a curve and `π : C → ℙ¹` a map. For a prime `℘` of `𝔽_q(C)`
write `π(℘)` for the induced prime of `𝔽_q[x]`. Define

```
P_π(n)  = #{ ℘ : deg ℘ = n,  π(℘) and π(℘)+2 both prime } ,
Z_C(n)  = #{ ℘ : deg ℘ = n } .
```

`Z_C` is exactly the zeta datum: the zeros of `ζ_C` determine `Z_C` and
conversely (round-3 Proposition 1.2). The claim is that `P_π` is **not** a
function of `Z_C` alone.

**Theorem (curve lift).** *There is no `Φ : (ℕ→ℕ) → ℕ` with
`P_π(n) = Φ(Z_C)(n)` for every curve `C` and every map `π`.*

*Proof.* Take `C = ℙ¹` over `𝔽₅` and the two maps `π_1(x) = x`,
`π_2(x) = 2x`. Since `a f + 2 = a(f + 2/a)` and irreducibility is
unit-invariant, `P_{π_a}(n)` is the twin count with shift `δ = 2/a`. At `n = 2`:

| `a` | `δ = 2/a` | `P_{π_a}(2)` |
|---|---|---|
| 1 | 2 | 0 |
| 2 | 1 | 5 |
| 3 | 4 | 5 |
| 4 | 3 | 0 |

The curve and its zeta are the same in every row; the pair count is not. ∎

### 3.2 Why this is the right lift

Round 3's Theorem 2.1 separated `B` from `Z` by varying the **world** (two
admissible qrime sets with the same degree counts). The curve lift varies
instead the **map** on a *fixed* curve: the world (the primes of `𝔽_q(C)`) and
its zeta are fixed; only `π` changes. So the higher-genus statement of
round-3 §4 no longer needs the "other worlds" reduction: on a single curve,
`Z_C` is fixed and the pair statistic still varies.

The `ℙ¹` witness is enough for the uniform statement. For a specific
higher-genus `C` one still wants two maps with different counts; the mechanism
is the same (the zeta does not see `π`), and the `ℙ¹` case already shows that
no uniform `Φ` exists.

### 3.3 Verification

* Python: [`checks/round4_lift.py`](../checks/round4_lift.py) — enumerates all
  shifts `δ`, interprets them as maps `π_a`, cross-checks with sympy
  (`Poly.is_irreducible` over `GF(5)`), and records `Z_C(2) = 10`.
* Unit tests: [`tests/test_round4.py`](../tests/test_round4.py).
* Lean: [`lean/Curve.lean`](../lean/Curve.lean) —
  `CurveLift.no_pair_function_of_zeta` (abstract),
  `CurveLift.curve_separation` (the `ℙ¹/𝔽₅` witness), with
  `CurveLift.pair_shift_two = 0`, `CurveLift.pair_shift_one = 5`, and every
  witness quadratic proved irreducible. Footprint:
  `[propext, Classical.choice, Quot.sound]`.

---

## 4. Reproduction

```
python3 checks/round4_lift.py          # exit 0
python3 checks/round4_step2.py         # exit 0
python3 -m pytest -q tests/            # all pass
cd lean && ./check.sh Qrime.lean Separation.lean Mobius.lean Curve.lean Cubic.lean Axioms.lean
```

New files:

* `lib/fast_twin.py` — numpy sieve, `T(n)` to `n = 16` over `𝔽₃` and much more.
* `lib/singular_series.py` — stable `S(q)` (exact / symbolic / mpmath / bounds).
* `checks/round4_lift.py`, `checks/round4_step2.py`, `checks/scan_t.py`.
* `tests/test_round4.py`, `tests/test_singular_series.py`.
* `lean/Curve.lean`, `lean/Cubic.lean`.

---

## 5. What is and is not claimed

* **Corrected:** the numerical values of `S(q)` (round 2/3 tables are superseded
  by §2.1) and the "slow `O(1/n)`" diagnosis (superseded by §2.3).
* **Established:** the curve lift (proved; Lean-checked); the exact cubic
  formula `T(3) = q(q−2)(q+1)/9` for `q ≡ 2 (mod 3)` (verified symbolically);
  the absence of a `c/n` second-order term in the data.
* **Still cited, not proved:** the fixed-`q`, `n→∞` asymptotic (Pollack's
  Conjecture 2). Step 1 found no proof in the literature; it remains open as far
  as we can tell.
* **Not claimed:** any proof of the twin prime conjecture or of the parity
  barrier over `ℚ`; any claim that the residual arithmetic fluctuations are
  fully understood (they are governed by the cohomology of the degree-`n` twin
  variety, which grows with `n`).
