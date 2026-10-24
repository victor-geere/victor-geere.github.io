# Parity barrier in primes over function field zeta

### A dimensional obstruction, measured

**First edition.** Packaged from the twin-prime-parity programme, phases 018, 019 and 020. The manuscript
reports what the programme established, what it measured, and what it did **not** prove. It is a
negative-results paper with a positive core: the obstruction is not an estimate to be sharpened but a
dimensional invariant, and in the polynomial model it can be measured exactly.

---

## Abstract

Over `𝔽_q[x]`, "primes" are monic irreducibles (qrimes) and "twin primes" are pairs `(f, f+2)`. The twin count
`T(n)` is a bilinear statistic, while the zeta function of the ring determines only linear (degree-count) data;
this separation is proved with an explicit witness. The programme's central question is constructive: can a
sieve, a degree window, or a second-moment argument cross the parity barrier in this model?

We report four measured failure modes. The Selberg `Λ²` upper bound at the classical level `n/2` carries the
classical Selberg constant `2^κ κ!` — `8×` the truth for the twin problem (`κ = 2`) and `2×` for the qrime
problem (`κ = 1`). Over `n ≤ 14` the twin ratio hovers near `4`, which an earlier version of this paper
mistook for the limit; computed from the same series it reaches `7.91` at `n = 1000`. **The correction is
marked below.** The constant is shift-independent: a polynomial shift divisible by every linear prime has the
same limit `8` against its own singular series. The bilinear pair weight is indefinite and defines no bound at
all. Degree windows give no `L^{−1/2}`
cancellation. The large sieve is slack by a factor of order `n`. The exact coprime-pair expansion of `T(n)` and
the degree grading that makes it exact are both machine-checked in Lean 4.

On the quantitative side, `T(n) = S(q)q^n/n² + E(n)` holds with `|E|/q^{n/2} ≤ 0.30` for every `n ≤ 14` at
`q = 3` (`T(13) = 3747`, `T(14) = 9510`), and the corresponding character-sum identity of the programme is corrected
at 80 primes: the original form holds exactly when `q ≡ 1 (mod 8)`, the corrected form for every
`q ≡ 1 (mod 4)` tested. None of this proves the fixed-`q` asymptotic; that
statement is conjectural in the literature we surveyed.

**Conclusion.** The barrier is a missing *object* — a way to resolve the two conditions jointly — not a missing
estimate. Over `𝔽_q[x]` that object is the Frobenius; over `ℤ` it would be a grading substitute for the Möbius
truncation. Four standard mechanisms are now closed by measurement, and every proof strategy must reproduce the
numbers recorded here — including the corrected constant `8`, not `4`.


---

## Correction notice

**This edition corrects two claims, and marks both as corrected.**

### C0 — the "dimension law" (this paper's own previous version)

An earlier version of this paper stated that the Selberg `Λ²` bound at level `n/2` is `2^dim` times the truth
asymptotically, `4×` for twins and `2×` for qrimes, and called `4` "the method's limit". **That is false.** Under
the paper's own definition the ratio tends to the classical Selberg constant `2^κ κ!`: `8` for twins
(`κ = 2`), `2` for qrimes (`κ = 1`).

The finite table was an exact optimum at each `n`, not the value of the limit: the twin ratio is
`3.61, 3.76, 4.01, 4.00` at `n = 6, 8, 10, 12`, and then `5.12, 6.26, 7.02, 7.48, 7.72, 7.86, 7.91` at
`n = 20, 40, 80, 160, 300, 600, 1000`. The value near `4` at `n ≈ 12` is a pre-asymptotic transient.

The correction was found by the project's referee (Benjaminsen, review 1736), whose independent computation
this edition reproduces from the same series; section 16 records the exchange and what changed. The qualitative
conclusion is unchanged and slightly stronger: the sieve loses a factor **8**, not 4.

### C1 — the character-sum identity of phase 019

The identity was recorded as

```
Σ_A χ₂(A) |K(A,c)|² = 2 χ₂(c) √q Re J(χ₄,χ₄)²   (as stated)
```

**That statement is false at its stated scope.** Tested exactly in `ℤ[ζ_q]` at every prime `q ≡ 1 (mod 4)` up to
1000, it holds at all **37** primes `q ≡ 1 (mod 8)` and fails at all **43** primes `q ≡ 5 (mod 8)`. The
corrected statement is

```
Σ_A χ₂(A) |K(A,c)|² = 2 χ₂(2c) √q Re J(χ₄,χ₄)²   (corrected)
```

which holds at **all 80** primes tested. The one-character factor `χ₂(2c)` is the entire correction, and the
hypothesis is exactly `q ≡ 1 (mod 8)`. The Lean-certified combinatorial step
(`Twist.twisted_parseval_step`) is unaffected — what changes is the arithmetic evaluation, not the splitting.

Four further corrections carried by this edition (the invalid truncation, the `ω` counter, an over-stated
completeness claim, and a non-existent closed form) are listed in **§13**, each beside the claim it corrects.

---

## 1. Introduction

### 1.1 The transposition

The twin prime conjecture asks whether `n` and `n+2` are both prime infinitely often. Over `𝔽_q[x]` the
analogue has a known answer in a large-`q` regime (Pollack; Bary-Soroker–Stix) and is conjectural at fixed `q`:
the large-sieve error `O(q^{n−1/2})` is useless as `n → ∞`. The model is therefore a genuine testbed: the
statements are precise, the computations are exact, and the obstruction is the same parity phenomenon that
blocks `ℤ`.

The programme asks a narrower question than "prove the conjecture": **which statistics can each tool see, and
where exactly does each standard mechanism fail?** The answer is the content of this paper.

### 1.2 What is new here

1. A **measured constant**: the square-weight sieve deficiency is the classical Selberg constant `2^κ κ!`
   (`8` for twins), computed exactly in `F_q[x]` and confirmed to `n = 1000`; it is invariant under polynomial
   shifts that absorb every small prime (§3.3, §4.1, §7). An earlier version stated `2^dim = 4`; correction C0
   records why that was wrong.
2. An **exact expansion** of the twin count with a boundary stratum whose coefficients are `0` or `1`, both
   machine-checked, together with the fact that the natural degree truncation diverges while the boundary
   cancels it (§5).
3. A **closed set of failure modes** for the four standard mechanisms, each with a number (§4).
4. An **exact test** of the programme's residual character-sum identity, which is false as stated and true
   after a one-character correction, with the precise hypothesis `q ≡ 1 (mod 8)` (§6).
5. **Numerical support** for the fixed-`q` asymptotic to `n = 14`, with the error always at the Weil scale (§8).

Nothing here proves the twin prime conjecture, the parity problem over `ℤ`, or the Riemann hypothesis.

---

## 2. The model

Fix an odd prime power `q`. Let `I(n)` be the number of monic irreducibles of degree `n` and

```
T(n; h) = #{f monic, deg f = n : f and f + h both irreducible},     T(n) := T(n; 2).
```

The **singular series** is

```
S(q) = Π_P (1 − 2/N(P)) / (1 − 1/N(P))² ,
```

the product over monic irreducibles `P`, with `N(P) = q^{deg P}`. It converges absolutely. The programme's main
term is `S(q) q^n / n²`, the function-field Hardy–Littlewood prediction.

**The zeta of a set of qrimes.** For a set `S` of monic irreducibles put `Z(S)(n) = #{f ∈ S : deg f = n}` and
`ζ_S(T) = Π_{f ∈ S} (1 − T^{deg f})^{−1}`. Then `[T^n] log ζ_S = (1/n) Σ_{d|n} d Z(S)(d)`, so `ζ_S` and the
degree-count sequence `Z(S)` determine each other exactly (Euler product and Möbius inversion). This is the
"zeta datum" the separation theorem is about: the twin count is a bilinear statistic of the set, and the zeta
records only the linear one.

Two elementary facts are used throughout. First, the **degree grading**: every nontrivial factorisation of a
degree-`n` polynomial has a factor of degree `≤ n/2` (Lean: `Grading.exists_two_mul_le`). Second, the **local
dichotomy**: at a prime of norm `Q`, avoiding `0` leaves `Q−1` residues, while avoiding both `0` and `−h`
leaves `Q−2` (Lean: `Capstone.local_factor_dichotomy`).

---

## 3. The barrier, in three statements

### 3.1 The zeta cannot see the pair

**Theorem (separation).** The zeta function of a set of qrimes determines exactly its degree counts, and no
function of those counts determines the twin count.

The proof exhibits two sets of four degree-2 qrimes over `𝔽₇` with identical degree profiles and twin counts
`1` and `0`. The general statement is machine-checked (`Separation.no_zeta_observable`); the witness is
`Separation.separation_F7`.

The consequence is structural: the twin count is *bilinear* data, and the zeta is *linear* data. No amount of
zeta computation recovers it.

### 3.2 Bounded-support divisor sums cannot see it

**Theorem (parity).** Every divisor sum with bounded support is periodic; the twin indicator is not. Hence no
finite-level Selberg sieve weight equals the twin indicator.

This is the finite form of Selberg's parity principle. The two halves are Lean-checked (`Periodic`,
`NonPeriodic`). The theorem concerns the *indicator*, not the count: it excludes a class of weights, and
therefore any route must use growing support.

### 3.3 Growing support loses the classical Selberg constant

The one route the parity theorem leaves open is a growing-support sieve. Its best square-weight version is
computed exactly, and it loses a constant:

**Measured (Selberg constant).** With `M[d,e] = 2^{ω(lcm(d,e))} q^{−deg lcm(d,e)}` and bound
`= q^n/(M^{-1})_{1,1}`, put `F(u) = Π_P (1 + 2u^{deg P}/(q^{deg P} − 2))`. Then `F(u) = H(u)/(1−u)²` with `H`
analytic at `u = 1` and `H(1) = 1/S(q)`, so with `m = n/2`

```
G(m) = [u^m] F(u)/(1−u) ~ m²/(2 S(q)),      bound ~ 2 S(q) q^n/m² = 8 · S(q)q^n/n² .
```

The ratio therefore tends to `2^κ κ!` — `8` for twins, `2` for qrimes. This is the classical Selberg-sieve
constant (Halberstam–Richert, *Sieve Methods*, ch. 1; Iwaniec–Kowalski, ch. 6–7), not a new law: the
`F_q[x]` computation reproduces it exactly and confirms it numerically to `n = 1000`.

Two consequences are load-bearing. First, the constant is **not** `2^dim`: the value `4` seen at `n ≤ 12` is a
transient (correction C0). Second, the constant is **shift-independent** (§7): the same `8` appears for a
polynomial shift that divides every small prime. That is what the phase's measurements actually establish: the
deficiency is a *dimension-dependent constant*, not a small-`n` artefact of the local densities.

---

## 4. The four mechanisms, measured

All measurements are exact finite computations; the audit script re-checks 35 of them.

### 4.1 The square-weight sieve

With `M[d,e] = 2^{ω(lcm(d,e))} q^{−deg lcm(d,e)}` and bound `= q^n/(M^{-1})_{1,1}`:

| `q` | `n` | bound | `T(n)` | bound / `T(n)` |
|---|---|---|---|---|
| 3 | 6 | 21.67 | 6 | 3.61 |
| 3 | 8 | 135.37 | 36 | 3.76 |
| 3 | 10 | 866.41 | 216 | 4.01 |
| 3 | 12 | 6020.30 | 1506 | 4.00 |
| 5 | 6 | 966.94 | 240 | 4.03 |

These rows are exact, and they are **not** the limit. The matrix is infeasible past `n ≈ 20`, but the equivalent
Selberg series `G(m)` is not, and it gives the same numbers (to three decimals) and then keeps going:

| `n` | 12 | 20 | 40 | 80 | 160 | 300 | 600 | 1000 |
|---|---|---|---|---|---|---|---|---|
| bound / main | 4.12 | 5.12 | 6.26 | 7.02 | 7.48 | 7.72 | 7.86 | 7.91 |

consistent with `8(1 − c/m)`. The value `≈ 4` at `n ≈ 12` is a transient: the ratio is monotonically rising.
The dimension-1 control (counting qrimes) behaves the same way toward `2`: `1.10` at `n = 4`, `1.57` at 12,
`1.85` at 40, `1.98` at 300.

### 4.2 The bilinear pair weight

The natural bilinear weight gives the matrix `C[d,e] = #{f : d | f, e | f+2}`. Its eigenvalues at `q = 3`,
`κ = 1` are `(−27, −27, −20.65, 317.65)` at `n = 5`, and negative eigenvalues persist at every `n` tested. The
form is indefinite, so there is no minimum and no bound. The square in `Λ²` is not cosmetic: it is what makes
the weight nonnegative.

### 4.3 Degree windows

Windowed averages of the main term do not cancel like `L^{−1/2}`. At `q = 3`, with the relative error measured
against `S(q)q^n/n²`: pointwise errors fall from `25.2%` at `n = 6` to `3.0%` at `n = 12`; length-4 windows
range from `0.34%` (over `n = 6..9`) to `4.23%` (over `n = 7..10`). The improvement is position-dependent, not
length-dependent — the error is a deterministic oscillation, not noise, so a window is not a self-validating
estimator.

### 4.4 The large sieve

For the twin indicator, `L(κ)/R(κ)` at level `κ = n/2` is `0.161, 0.069, 0.077, 0.056, 0.076, 0.045` for
`n = 5..10`, decaying roughly like `1/n`. The bound extracted is `≍ q^n/n`, larger than the main term by a
factor `n`. This is the concrete form of the known statement that the large-sieve error `O(q^{n−1/2})` is
useless at fixed `q`.

### 4.5 Summary

| mechanism | failure | factor |
|---|---|---|
| `Λ²` square weight at level `n/2` | capped | `2^κ κ!` (`8` for twins, `2` for qrimes) |
| bilinear pair weight | indefinite | undefined |
| degree windows | no cancellation | position-dependent |
| large sieve | slack in the second moment | `≍ n` |

The four failures have one cause: none resolves the two local conditions **jointly and exactly**.

---

## 5. The exact side

### 5.1 The expansion

For `f` of degree `n`, the Legendre sieve over primes of degree `≤ n/2` is an exact indicator
(`1_Irr`), by the degree-grading lemma. Expanding the product gives an exact, finite sum over coprime divisor
pairs:

```
T(n) = Σ_{d,e | P} μ(d) μ(e) · #{f : deg f = n, d | f, e | f+2},
```

where `P` is the product of the primes of degree `≤ n/2`. The CRT count is `q^{n−deg d−deg e}` when
`deg d + deg e ≤ n`, and `0` or `1` on the boundary `deg d + deg e > n` — the boundary coefficients are `0/1`
because a residue class modulo `m` with `deg m > n` contains at most one polynomial of degree `n` (Lean:
`Boundary.unique_of_deg_lt`).

The expansion reproduces the brute-force count exactly (8 test cases), and it exposed a real defect in an
earlier draft of the programme: dropping the boundary terms is invalid.

### 5.2 Two truncations, not one

Truncating the expansion at `k = deg d + deg e ≤ n` gives a partial product of a **divergent** product: its
logarithm is `≈ −2 Σ_{d ≤ n/2} 1/d → −∞`. The truncation is off by factors `10–100` and changes sign. The
Euler product truncated by **prime degree** (`deg Q ≤ n/2`) instead tracks `T(n)` to about `10%`, but `y²P(y)`
has no limit (`0.070 → 0.115` for `y ≤ 12`), so it is an approximation, not a closed form.

This distinction matters: "the truncated product diverges" is true of the degree truncation only.

---

## 6. The character-sum identity of 019

Phase 019 tests the programme's residual identity

```
Σ_A χ₂(A) |K(A,c)|² = 2 χ₂(c) √q Re J(χ₄,χ₄)²,
```

with `K(A,c) = Σ_w χ₂(A² − w²) ζ^{−cw/4}`. The test is exact: both sides are elements of `ℤ[ζ_q]`, compared
modulo the cyclotomic polynomial. Results at every prime `q ≡ 1 (mod 4)` up to 1000:

* the identity **as stated** holds at all 37 primes `≡ 1 (mod 8)` and fails at all 43 primes `≡ 5 (mod 8)`;
* the corrected form `Σ_A χ₂(A)|K(A,c)|² = 2 χ₂(2c) √q Re J²` holds at **all 80**;
* the untwisted identity `Σ_A |K(A,c)|² = q² − 2q` holds at all 80.

The corrected form holds at every `q ≡ 1 (mod 4)` tested; the **original** form is valid exactly when
`q ≡ 1 (mod 8)` (because `χ₂(2) = −1` precisely then). The corrected statement is the one a proof should
target. **This is the correction marked in the notice above**: it is a correction to the programme's own earlier
statement, not to the literature, and the corrected form is the one this paper carries. The combinatorial step
"sum over squares = sum over all plus the `χ₂`-twist" is Lean-certified (`Twist.twisted_parseval_step`).

The identity itself remains open.

---

## 7. Polynomial shifts

Constant shifts never share a prime with `h`, which is why the singular series is shift-free. For a polynomial
shift `h ∈ 𝔽_q[x]` of positive degree, primes can divide `h`; at such a prime the two conditions coincide and
the local factor becomes `1/(1−1/Q)` instead of `(1−2/Q)/(1−1/Q)²`. The ratio is `(Q−1)/(Q−2)`, giving

```
S_h(q) = S(q) · Π_{Q | h} (Q−1)/(Q−2).
```

At `q = 3`, `h = x` gives `S_h = 0.792208 = 2 S(3)`, and the measured ratios `T(n;x)/(S_h q^n/n²)` are
`1.039, 0.997, 0.962, 0.985, 0.987` for `n = 5..9`. Polynomial shifts therefore obey the same asymptotic with
the modified series.

Crucially, the **constant is unchanged**. For `h = x(x+1)(x+2)`, divisible by every linear prime, the ratio
rises through `1.94, 2.37, 2.42, 3.12, 2.83, 3.51, 3.21, 3.84` for `n = 6..13`, and the same Selberg series at
larger `n` gives `5.73` (40), `7.30` (160), `7.61` (300): it approaches `8`, not `2` — the same constant as the
constant-shift problem, measured against its own `S_h`. The deficiency is dimensional and shift-independent;
the earlier claim that it "approaches 4" was the same small-`n` transient as C0.

---

## 8. The main term and the error

With `S(3) = 0.396104`, `S(5) = 0.709544`, `S(7) = 0.812706`:

| `n` | `T(n)` (`q = 3`) | `S(3)q^n/n²` | `E(n)` | `q^{n/2}` | `|E|/q^{n/2}` |
|---|---|---|---|---|---|
| 10 | 216 | 233.90 | −17.90 | 243.0 | 0.074 |
| 11 | 585 | 579.91 | +5.09 | 420.9 | 0.012 |
| 12 | 1506 | 1461.85 | +44.15 | 729.0 | 0.061 |
| 13 | 3747 | 3736.79 | +10.21 | 1262.7 | 0.008 |
| 14 | 9510 | 9666.09 | −156.09 | 2187.0 | 0.071 |

The ratio stays in `[0.008, 0.30]` over `n = 2..14`; at `q = 5`, `T(9) = 17265` against `17108.99` predicted
(ratio `0.112`). The main term is accurate to `0.3%` at `n = 13`.

The error is not spectral: `T(n)` satisfies no finite linear recurrence (Berlekamp–Massey on held-out terms
fails for `q = 3, 5, 7`). The natural reading is an infinite `q^{n/2}` zero spectrum.

---

## 9. Proved, measured, open

**Proved** (Lean 4, standard axioms; 61 modules in `018/lean`, `019/lean`, `020/lean`): the separation witness;
the parity theorem; the degree grading; the boundary `0/1` lemma; the local factor `2^k` and the local-factor
dichotomy; the shift law's two halves; the window algebra; the `(Q−1)/(Q−2)` correction; the 019 splitting
step.

**Measured** (exact finite computation, 35 audited claims + the Selberg series to `n = 1000`): the constant
`2^κ κ!` (`8` for twins, `2` for qrimes); the error band; the orbit counts; the large-sieve slack; the
polynomial-shift series; `T(13)`, `T(14)`.

**Open**: the fixed-`q` asymptotic; its polynomial-shift version; the 019 identity; the generic case of the
`d=4` cap of phase 018.

---

## 10. The transfer demand

The function-field crossing has two ingredients: an exact growing-support identity, and a canonical truncation
of it. Over `𝔽_q[x]` the degree supplies both. Over `ℤ` the analogous identity runs through `Λ = μ ∗ log`, whose
support has no canonical truncation, and the truncation error *is* the two-point Chowla correlation.

**So the demand is a grading substitute**: a canonical, error-controlled truncation of the Möbius sum. Every
standard `ℤ` method that supplies one — the circle method, the large sieve — is blocked at exactly this point,
and §4 says why: their truncations lose the Selberg constant `8`, a factor `n`, or worse.

---

## 11. Limitations

1. Nothing here crosses the barrier. The paper measures it and closes four mechanisms.
   **An earlier version stated the wrong constant** — it claimed `2^dim = 4`; the correct limit is
   `2^κ κ! = 8` for twins. Correction C0 and §16 record the error, the referee who found it, and the fix.
2. The fixed-`q` asymptotic is **not** proved. The data to `n = 14` constrains it; it does not establish it.
3. The character-sum identity is verified, not proved.
4. The `d=4` cap of phase 018 depends on three cited theorems and one unformalised decomposition.
5. "Measured" means exact finite computation over the stated ranges. It is evidence of the stated strength,
   nothing more.

---

## 12. Reproduction

```
./check.sh                      # all 61 Lean modules (needs Lean 4 + Mathlib at $HOME/lean)
python3 020/checks/audit.py     # 35 numeric claims
python3 -m unittest discover -s 020/tests
python3 -m unittest discover -s 019/tests
python3 020/checks/linkcheck.py
```

Python conventions: results go to **stdout**, diagnostics and banners to **stderr**; no script writes files.
Recorded inputs live in `020/data/`.

---

---

## 13. Corrections carried by this edition

Each correction is kept beside the claim it corrects; the first is the one marked in the notice above.

| # | claim as recorded | correction | evidence |
|---|---|---|---|
| C0 | the `Λ²` bound at level `n/2` is `2^dim` times truth: `4` for twins, `2` for qrimes | **false**: the ratio tends to `2^κ κ!`, i.e. **8** for twins and 2 for qrimes; `4` was a transient at `n ≈ 12` | referee review 1736; §4.1 series to `n = 1000`; §3.3 |
| C1 | `Σ_A χ₂(A)|K(A,c)|² = 2 χ₂(c) √q Re J²` | **false at `q ≡ 5 (mod 8)`**; corrected to `2 χ₂(2c)`, hypothesis `q ≡ 1 (mod 8)` | 80 primes, exact `ℤ[ζ_q]` arithmetic |
| C2 | the coprime-pair expansion may be truncated at `deg d + deg e ≤ n` | **invalid**: the boundary terms exist and are `0/1`, not zero | `020/notes/round108.md`; Lean `Boundary.unique_of_deg_lt` |
| C3 | the constant `c(κ)` of round 109 | **over-counted repeated prime factors** (only one copy of `ω` divided out) | `020/notes/round109.md` erratum; 0 mismatches after the fix |
| C4 | "the sieve is complete for the entire Selberg class" | **over-stated**: complete for bounded-support weights only | `020/notes/round118.md` |
| C5 | a closed form exists for the boundary stratum | **no constant exists**: `y²P(y)` has no limit (`0.070 → 0.115`) | `020/notes/round119.md` |

## 14. Claim sources

Each numbered claim of this paper names where its evidence lives in the attached tree.

| claim | source |
|---|---|
| separation theorem, `𝔽₇` witness | `018/lean/Separation.lean`; `018/checks/round3.py` |
| parity theorem (periodic vs not) | `018/lean/Periodic.lean`, `018/lean/NonPeriodic.lean` |
| degree grading `≤ n/2` | `020/lean/Grading.lean` |
| boundary coefficients `0/1` | `020/lean/Boundary.lean` |
| local factor `2^k`, dichotomy | `020/lean/Dimension.lean`, `020/lean/Capstone.lean` |
| Selberg constant `2^κ κ!` (`8` twins, `2` qrimes) | this edition's `submission/selberg_constant.py`; §4.1; referee review 1736 |
| §4.1 finite table (21.67, 135.37, 866.41, 6020.30, 966.94) | `020/checks/audit.py`; `020/notes/round110.md`; reproduced by the referee |
| §4.1 large-`n` series (5.12 … 7.91) | `submission/selberg_constant.py` (product form of the same series) |
| bilinear indefiniteness | `020/checks/audit.py`; `020/notes/round111.md` |
| window errors | `020/notes/round112.md`; `020/checks/round114.py` |
| large-sieve slack | `020/checks/round114.py`; `020/notes/round114.md` |
| exact expansion, boundary | `020/checks/round108.py`; `020/notes/round108.md` |
| `T(13)`, `T(14)`, error band | `020/data/round115.json`; `020/checks/audit.py` |
| polynomial shifts, `S_h` | `020/checks/round121.py`, `round122.py`, `round123.py`; `020/data/round123.json` |
| 019 identity and its correction | `019/checks/falsification_test.py`; `019/results.json`; `019/lib/twisted_parseval.py` |
| singular series constants `S(3), S(5), S(7)` | `018/checks/round2.py`; `020/checks/audit.py` |
| the four cited theorems (Ritt, Guralnick–Saxl, Poincaré, Weil) | references 1–4; the `d=4` reduction chain lives in `018/lean/{Shift,Factorization,Composition}.lean` |

## 15. Authorship and AI disclosure

The manuscript, the verification tree and the Lean development were produced by an AI agent (DeepSeek Harness)
working under the direction of the account holder, over the rounds recorded in `provenance/rounds.log`. All
numerical claims are the output of the checked-in scripts; all Lean theorems were elaborated against Lean 4 +
Mathlib with the standard axioms. No claim in this paper is asserted on the agent's authority alone: each is
either machine-checked or measured by code that ships with it, and the calibration is stated with the claim.

---

---

## 16. Referee report and revision

Version 1 of this paper was returned as a proposed paper on solveathome (return #4789, 2026-10-19) and was
**rejected by a trusted reviewer** (Benjaminsen, review 1736, reason `refuted`). The report is a substantive
refutation, and this version is the response to it.

**The finding.** The referee recomputed the paper's numbers independently and confirmed, exactly, the finite
table of §4.1, the counts `T(n)` to `n = 14`, the singular series, the error band, the shift series, the
bilinear eigenvalues and the character-sum identity in both forms. What they refuted is the **law** the paper
drew from the small-`n` table: under the paper's own definition the ratio tends to `2^κ κ!` — `8` for twins —
not `4`, and they exhibited the trend at `n = 20, 40, 80, 160, 300, 600, 1000`. Their derivation is
elementary and correct: `F(u) = H(u)/(1−u)²` with `H(1) = 1/S(q)` gives `G(m) ~ m²/(2S)` and hence `8` times
the main term. The referee also noted, correctly, that a "measured theorem" asserting an `n → ∞` limit from
`n ≤ 13` data is miscalibrated in any case, and that the Lean and audit tree was not attached to the return.

**What this version changes.**

1. Correction **C0** is added to the notice and to §13; §3.3, §4.1, §7, §9, §10 and the abstract now state the
   constant `2^κ κ!` (`8` for twins, `2` for qrimes) and present the small-`n` values as a transient.
2. The bound formula in §4.1 now carries the missing factor `q^n`.
3. Correction **C1**'s hypothesis is stated correctly: the corrected form holds for every `q ≡ 1 (mod 4)`
   tested; the original form is valid exactly when `q ≡ 1 (mod 8)`.
4. The zeta of a qrime set is defined in §2, and §3.1 says what is non-trivial.
5. Claim-source rows are added for the tables and for the Selberg constant, and a script
   (`submission/selberg_constant.py`) ships the series that produces both the finite table and the large-`n`
   trend.
6. The references are corrected: Guralnick–Saxl (LMS Lecture Note Ser. 207, 1995), Poincaré with pages,
   Selberg with venue, Pollack as the actual paper (CRM Proc. Lecture Notes 46, 2008, 259–273), and
   Halberstam–Richert added for the Selberg constant.
7. The full supporting tree is attached (575 files at version 1; the tree plus the new script and build notes
   now), including the 61-module Lean development with its `#print axioms` output.
8. Novelty is stated plainly: the `F_q[x]` tables are a **check of known asymptotics**, not a new law. The
   paper's contribution is the exact measurement of the four failure modes and the corrected constants, not a
   discovery about Selberg sieves.

**What this version does not claim.** The fixed-`q` asymptotic, the character-sum identity, and the `d = 4`
cap of phase 018 all remain open, as before. The conclusion — that the barrier is a missing object rather than
a missing estimate — is unaffected; the sieve's loss is now stated as `8`, which strengthens it.

**Credit.** The refutation is the referee's; the recomputation in §4.1 and `submission/selberg_constant.py` is
this author's independent check of it, and it agrees to every printed digit.

## References

1. J. F. Ritt, *Prime and composite polynomials*, Trans. Amer. Math. Soc. **23** (1922), 51–66.
2. R. Guralnick, J. Saxl, *Monodromy groups of polynomials*, in *Groups of Lie Type and their Geometries*
   (Como, 1993), LMS Lecture Note Ser. **207**, Cambridge Univ. Press (1995), 125–150.
3. H. Poincaré, *Sur les propriétés arithmétiques des courbes algébriques*, J. Math. Pures Appl. (5) **7**
   (1901), 161–233.
4. A. Weil, *On some exponential sums*, PNAS **34** (1948), 204–207.
5. A. Selberg, *On elementary methods in prime number theory and their limitations*, Den 11te Skandinaviske
   Matematikerkongress, Trondheim 1949 (1952), 13–22.
6. P. Pollack, *An explicit approach to Hypothesis H for polynomials over a finite field*, in *Anatomy of
   Integers*, CRM Proc. Lecture Notes **46**, Amer. Math. Soc. (2008), 259–273.
7. L. Bary-Soroker, *Irreducible values of polynomials*, Adv. Math. **229** (2012); arXiv:1005.4528.
8. L. Bary-Soroker, J. Stix, arXiv:1711.05564, Thm. 1.2 and 1.4.
9. K. Ireland, M. Rosen, *A Classical Introduction to Modern Number Theory*, GTM **84**, ch. 8–9.
10. H. Halberstam, H.-E. Richert, *Sieve Methods*, Academic Press (1974), ch. 1 (the Selberg constant).
11. H. Iwaniec, E. Kowalski, *Analytic Number Theory*, AMS Colloq. Publ. **53** (2004), ch. 6–7.
12. The Lean 4 proof assistant and Mathlib4, <https://leanprover-community.github.io/mathlib4/>.
