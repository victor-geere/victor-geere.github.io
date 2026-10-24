# 046 — the two-point Chowla sum `Σ_{n≤x} λ(n)λ(n+2)`

## The question

Establish
```
Σ_{n≤x} λ(n) λ(n+2) = o(x)                                      (★)
```
(`λ(n) = (−1)^{Ω(n)}` the Liouville function, `Ω` counted with multiplicity).

## The answer, stated first

**This cannot be established — (★) is open.**  It is the **two-point Chowla
conjecture** (a special case of the Chowla conjecture that the `k`-point correlations
of `λ` vanish).  No proof is known, unconditionally or even conditionally on RH in
the elementary Dirichlet-series sense, and this round does not produce one.  What
this round *does* establish, rigorously and reproducibly, is the precise status of
(★), the exact bounds that *are* available, and — this is the substantive part — a
**proof that no pointwise or finite-prefix argument can ever establish it**.

---

## 1. What is true, and what this round verifies

### 1.1 The trivial bound (PROVED in Lean, `Rh46/Chowla.lean`)

```
|S(x,h)| ≤ x        for every h, x    (each of the x summands lies in {−1,+1})
S(x,0) = x          (λ(n)² = 1)
```

The second line is the sharpness witness: for the (completely multiplicative,
bounded) function `λ ≡ 1` the correlation is exactly `x`, so `o(x)` is **not** a
formal consequence of multiplicativity plus boundedness.  It is a genuine
arithmetic statement about `λ`.

### 1.2 The finite data are consistent with (★), and prove nothing (VERIFIED)

`S(x) = Σ_{n≤x}λ(n)λ(n+2)` (reconnaissance, `numpy` sieve to `10⁷`):

| `x` | `10³` | `10⁴` | `10⁵` | `10⁶` | `10⁷` | `10⁸` | `10⁹` |
|---|---|---|---|---|---|---|---|
| `S(x)` | −30 | 12 | 258 | 68 | **1246** | 4632 | **43790** |
| `S(x)/x` | −3.0·10⁻² | 1.2·10⁻³ | 2.6·10⁻³ | 6.8·10⁻⁵ | 1.25·10⁻⁴ | 4.6·10⁻⁵ | 4.4·10⁻⁵ |
| `max_{x'≤x}\|S\|` | 30 | 73 | 282 | 689 | 3059 | 6454 | **48700** |
| `max\|S\|/√x` | 0.95 | 0.73 | 0.89 | 0.69 | 0.97 | 0.65 | 1.54 |

The round's numerics script (`chowla_two_point.py`, **30/30 checks**, exit 0, sieve to
`10⁹` in 100 windows of `10⁷`, two bit-identical reruns) refits the prefix-maximum
exponent as `α = 0.5200 ± 0.0249` over six decades, with `max|S|/√x` drifting
`0.645 → 1.54` — the expected `x^{1/2+ε}` upward drift.  **`α` is a finite-range fit;
no asymptotic claim is made.**

(The main agent's reconnaissance printed `S(10⁷) = 1244`; the auditor's three
independent `λ` algorithms give **1246**, and the difference is a final-block boundary
slip in the reconnaissance streaming — recorded as the round's one data correction.
The two independent fits differ — `0.4834 ± 0.0186` (auditor, `x ≤ 10⁸`) versus
`0.5200 ± 0.0249` (round numerics, `x ≤ 10⁹`) — and the local exponents range over
`0.32–0.65`, so **the exponent is not resolved**.  All of this is *consistent with*
`x^{1/2+ε}` and **proves nothing**; the round records it as a finite-range
description only.)

The growth of `max|S|` is consistent with `x^{1/2+ε}` — but a finite computation
gives only an upper bound at the computed `x`; it can never give the limit `S(x)/x → 0`.

### 1.3 The unconditional theorems that *are* known (VERIFIED numerically)

The state of the art is **averaged**:

* **logarithmic Chowla** (Tao 2015/2016; Matomäki–Radziwiłł–Tao): for fixed `h`,
  `(1/log x) Σ_{n≤x} λ(n)λ(n+h)/n = o(1)` — a true theorem.  The round *checks it
  finitely* (main agent, sieve to `3·10⁷`):

  | `x` | `10⁴` | `10⁵` | `10⁶` | `10⁷` |
  |---|---|---|---|---|
  | `h = 1` | −9.06·10⁻² | −7.28·10⁻² | −6.10·10⁻² | −5.23·10⁻² |
  | `h = 2` | −1.48·10⁻¹ | −1.18·10⁻¹ | −9.82·10⁻² | −8.41·10⁻² |

  The decay is **slow** (as the theorem's `o(1)` permits), so this is a consistency
  check of a known theorem, not a verification of it — the same logical caveat as
  §1.4 applies.  The un-averaged statement `Σ_{n≤x}λ(n)λ(n+h)/x = o(1)` is the open
  one.
* **Chowla for almost all shifts** in short ranges (Matomäki–Radziwiłł–Tao;
  Tao's entropy-decrement method): the two-point correlation vanishes for almost
  every `h` — a statement about `h`-averages, not about the single `h = 2`.

These are strictly weaker than (★): the logarithmic average divides by `n`, and the
`h`-average forgets the specific shift.  (For contrast, the *one-point* case

```
one-point Chowla  Σ_{n≤x} λ(n) = o(x)      is a THEOREM (equivalent to PNT),
```

via the classical `λ = 1_□ ∗ μ` transfer; an earlier revision of this file mislabelled
it OPEN — see the record correction at the end.)  Even so, the density-zero statement
for prime pairs has no proof: the obstruction there is Selberg's parity principle, a
statement about *method*, not the truth of the one-point case.

### 1.4 A finite prefix does **not** determine the asymptotic (PROVED in Lean)

This is the round's logical core.  Let `λ^{(a)}` be `λ` with the sign flipped at the
single index `a`:

```
λ^{(a)}(n) = −λ(n)  if n = a,     λ^{(a)}(n) = λ(n)  otherwise.
```

Then, for every `N + h < a`,

```
Σ_{n≤N} λ^{(a)}(n) λ^{(a)}(n+h)  =  Σ_{n≤N} λ(n) λ(n+h)
```

— the two functions **agree on every prefix shorter than `a`**, so no computation
whatever, at any finite `x < a`, can distinguish them — while their correlation sums
differ from index `a` onward (each sum acquires a different sign-flip contribution).
The prefix data therefore cannot decide the asymptotic.  **The strongest form of the
gap** (auditor, check A1): define `λ''` to agree with `λ` on *all* of `[1, 10⁸]` and to
equal `1` beyond; then `S''(x) = S(x)` **exactly for every `x ≤ 10⁸ − 2`** (0 of
99 999 998 prefixes differ) yet `S''(x)/x → 1`.  So the entire computed dataset is
equally consistent with `S(x) = o(x)` and with `S(x) = Θ(x)`: a finite check can
**refute** but never **prove** the statement.

A refinement the auditor proved: flipping a *sparse* set cannot work —
`|S_A(x) − S(x)| ≤ 2·#{n ≤ x : n ∈ A or n+2 ∈ A} ≤ 4·#{m ≤ x+2 : m ∈ A}`
(the bound `2·#{n ≤ x+2 : n ∈ A}` quoted in an earlier revision of this section is
**false**; witness `A = {5}`, `x = 5`), so an `o(x)`-sized flip set moves the sum
by `o(x)` only.  Positive density (as above, density `1/2`) is necessary.  The
witness is not multiplicative (parity chains are pinned), which is the correct
reading: prefix-indeterminacy holds for arbitrary `±1` extensions.

### 1.5 Why the RH/Dirichlet-series route does not apply (recorded correction)

An earlier draft of this round asserted an elementary conditional proof via the
Dirichlet series `Σ λ(n)λ(n+2)n^{−s}` and Perron's formula.  That is **wrong**: the
shifted product `n ↦ λ(n)λ(n+2)` is **not multiplicative**, so the series has no Euler
product and the standard `ζ`-based analysis does not apply.  The Lean layer proves a
concrete non-multiplicativity witness.  The claim was withdrawn; it is recorded here
so it is not re-proposed.

## 2. Why (★) is hard — the honest one-paragraph summary

`λ` is completely multiplicative and its Dirichlet series is `ζ(2s)/ζ(s)`, so its
*linear* averages are governed by the zeros of `ζ` — that is the parity problem in its
analytic form.  A *two-point* correlation of a multiplicative function is a shifted
convolution: it is not multiplicative, it is not controlled by an Euler product, and
its evaluation needs either (i) a strong zero-free region together with a
cancellation in the shifted convolution (unknown even under RH by the elementary
method), or (ii) the entropy-decrement/disjointness technology of Tao and
Matomäki–Radziwiłł–Tao, which currently yields only the logarithmic and almost-all-`h`
statements.  For comparison: **Chowla for `k`-point correlations contradicts the twin
prime conjecture's failure mode and implies the Sarnak conjecture**; it is strictly
beyond present technique.  (Note also the elementary consistency check: the
deterministic `λ ≡ 1` has correlation `x`, so no soft/multiplicative argument alone
can give `o(x)` — the input must be genuinely arithmetic.)

## 3. Consequence for the twin-prime question

`Σ_{n≤x}λ(n)λ(n+2) = o(x)` is *necessary* for a positive proportion of `n` to have
`λ(n) = λ(n+2)`; but it is neither implied by nor implies the twin-prime conjecture,
and it is open.  The parity obstruction of Selberg is exactly the statement that
sieves cannot reach the one-point case `Σ_{n≤x}λ(n) = o(x)`; this round adds no way
around it.

## 4. Files and reproduction

| file | what it is |
|---|---|
| [`chowla_two_point.py`](chowla_two_point.py) | the numerics (1044 lines, **30/30 checks**, sieve to `10⁹`): the correlation table, the growth fit, the logarithmic average, the finite-prefix demonstration, and the no-Euler-product verification |
| [`verify/independent_check.py`](verify/independent_check.py) | the auditor's independent recomputation (own `λ`, own correlations, its own prefix construction) |
| [`lean/Rh46/Chowla.lean`](lean/Rh46/Chowla.lean) | **CERTIFIED** — 530 lines, **42 theorems**, 7 definitions, `./check.sh --all` **exit 0**, no `sorry`/`admit`/`axiom`/`native_decide`: `liouville_sq`, `liouville_abs_le_one`, `liouville_mul` (nonzero; with `liouville_mul_zero_false` refuting the zero case), `corr_abs_le`, `corr_zero`, `corrAsymptotic_zero_false`, the non-multiplicativity witness, the slice layer (`slice_agree`, `corrSlice_eq_corr_of_lt`, `corrSliceSqSub`), and — added when OP-11 was closed — the perturbation identity `corrSlice_sub_corr_self_eq` (with the pointwise helper `slice_term_sub`) and its nonvanishing witness `exists_corrSlice_ne_corr`. **No statement is left as a comment.** |

```
cd /Users/victor/workspace/rh
python3 rh46/chowla_two_point.py
python3 rh46/verify/independent_check.py
cd rh46/lean && ./check.sh --all
```

## 5. What is claimed, in one line each

| claim | status |
|---|---|
| `\|Σ_{n≤x}λ(n)λ(n+2)\| ≤ x`; `Σ λ(n)λ(n) = x` | **PROVED** (Lean: `corr_abs_le`, `corr_zero`) |
| the correlation of `λ ≡ 1` is `x`, so `o(x)` is not formal | **PROVED** (Lean: `corrAsymptotic_zero_false`) |
| `n ↦ λ(n)λ(n+2)` is not multiplicative | **PROVED** (Lean: `shiftProd_not_completely_multiplicative`) |
| prefix agreement does not determine the correlation asymptotic | **PROVED** (Lean: `slice_agree`, `corrSlice_eq_corr_of_lt`, and now the full perturbation identity `corrSlice_sub_corr_self_eq` with witness `exists_corrSlice_ne_corr`) + **VERIFIED** numerically to the strongest form (auditor A1, `10⁸` prefixes) |
| `Σ_{n≤x}λ(n)λ(n+2) = o(x)` | **OPEN** — not claimed, not proved, not provable by finite computation |
| the logarithmic average is `o(1)` | known theorem (Tao; MRT); **VERIFIED** numerically here |


---

> **Record correction (from the research harvest at
> [`../../twin-prime-parity/`](../../README.md)).**  Two
> claims were corrected after this round closed; both corrections are now applied
> *in the body text above* as well as recorded here:
> 1. the statement "one-point Chowla `Σ_{n≤x}λ(n) = o(x)` is itself OPEN" is **false**:
>    it is **equivalent to PNT**, i.e. a theorem (`λ = 1_squares ∗ μ`, so
>    `Σ_{n≤x}λ(n) = Σ_{d≤√x}M(x/d²) = o(x)`); §1.3 above has been rewritten accordingly;
> 2. the sparse-modification bound `≤ 2·#{n ≤ x+2 : n ∈ A}` is **false**; the correct
>    bound is `2·#{n ≤ x : n ∈ A or n+2 ∈ A} ≤ 4·#{m ≤ x+2 : m ∈ A}`
>    (witness `A = {5}`, `x = 5`); §1.4 above has been rewritten accordingly.  The
>    `o(x)` conclusion is unaffected.  The corrected bound is machine-checked in the
>    rh47 Lean layer (`Rh47/Sparse.lean`, item OP-12).
