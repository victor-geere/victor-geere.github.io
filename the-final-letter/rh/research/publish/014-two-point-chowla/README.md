# publish/014-two-point-chowla — The finite-prefix indeterminacy theorem

Second edition of the programme's papers. This folder contains, in self-contained
form, the **finite-prefix indeterminacy theorem** for the two-point Chowla
correlation of the Liouville function: the statement that no finite computation
can decide whether

```
S(x) := Σ_{n≤x} λ(n) λ(n+2)  is  o(x),                          (★)
```

together with everything that *is* proved about the correlation, and the exact
sense in which (★) is open.

`λ(n) = (−1)^{Ω(n)}` is the Liouville function, `Ω` the number of prime factors
counted with multiplicity.

**The theorem, stated first.**  Write

```
corr h N      = Σ_{n=1}^{N} λ(n) λ(n + h)
λ_a(n)        = −λ(a) if n = a,   λ(n) otherwise          (the "slice" of λ at a)
corrSlice h a N = Σ_{n=1}^{N} λ_a(n) λ_a(n + h).
```

For every `h`, `a`, `N` with `N + h < a`,

```
corrSlice h a N  =  corr h N ,
```

so `λ` and `λ_a` produce **identical** correlation data on every prefix shorter
than `a`, even though `λ_a ≠ λ`.  Hence the truth of (★) is a statement about the
*limit* of `corr 2 N / N`, and no initial segment of values decides it: a finite
check can refute (★) but can never prove it.

## Contents

| File | What it is |
|---|---|
| [`finite-prefix-indeterminacy.html`](finite-prefix-indeterminacy.html) | The paper (open in any browser). Self-contained: styles and mathematics are inline. |
| [`chowla_two_point.py`](chowla_two_point.py) | Reference implementation and self-check (**30/30 checks, exit 0, ≈ 4 min**): the correlation table, the prefix-maximum fit, the logarithmic average, the finite-prefix construction, and the no-Euler-product verification. |
| [`independent_check.py`](independent_check.py) | An independent recomputation (own `λ` by two unrelated algorithms, own correlations, own prefix construction). **25/26** — see "The one non-pass" below. |
| [`Rh46/Chowla.lean`](Rh46/Chowla.lean) | Lean 4 / Mathlib formalisation of the theorem and its supporting layer: **462 lines, 37 theorems/lemmas, 7 definitions**, no `sorry`/`admit`/`axiom`/`native_decide`. |
| [`Rh46.lean`](Rh46.lean) | Root module; importing it checks the whole development. |
| [`check.sh`](check.sh) | Builds the Lean files against a local Lean 4 + Mathlib. |
| [`logs/`](logs) | The recorded runs: `chowla_two_point.log` (30/30), `chowla_two_point.repro1.log` (bit-identical rerun), `independent_check.log` (25/26), `lean_check.log`, `exit_code.txt`. |
| [`ROUND-NOTES.md`](ROUND-NOTES.md) | The original working notes of the round, kept for provenance. |
| `README.md` | This file. |

Everything in this folder is self-contained.  There are no references to files
outside it.  The only external dependencies are

* **Mathlib** (and a Lean 4 toolchain), needed only to elaborate `Rh46/Chowla.lean`
  and `Rh46.lean`;
* **NumPy** and **mpmath**, imported by the two Python scripts (nothing else
  outside the Python standard library is used).

## What is proved, and where

**Proved in Lean** (`Rh46/Chowla.lean`, namespace `Rh46`; `./check.sh --all` exits `0`):

*Trivial bound and its sharpness.*

| Theorem | Statement |
|---|---|
| `corr_abs_le` | `\|corr h N\| ≤ N` for all `h`, `N` |
| `corr_zero` | `corr 0 N = N` (since `λ(n)² = 1`) |
| `corrAsymptotic_zero_false` | `¬ corrAsymptotic 0` — so `o(x)` is **not** a formal consequence of multiplicativity plus boundedness |

*The Liouville function.*  `Omega_eq_cardFactors`, `Omega_eq_factorization_sum`,
`liouville_eq_arithLiouville` (agreement with Mathlib's
`ArithmeticFunction.liouville` off zero), `liouville_mul` (complete multiplicativity
on nonzero arguments) with `liouville_mul_zero_false` refuting the zero case,
`liouville_mem`, `liouville_ne_zero`, `liouville_sq`, `liouville_abs_le_one`.

*Non-multiplicativity of the Chowla summand.*  `shiftProd_two_five`,
`shiftProd_not_completely_multiplicative` — the coefficient sequence
`n ↦ λ(n)λ(n+2)` is not multiplicative, so its Dirichlet series has no Euler
product and the `ζ`-based route does not apply.

*The finite-prefix (slice) layer — the logical core.*

| Theorem | Statement |
|---|---|
| `slice_self` | `λ_a(a) = −λ(a)` |
| `slice_agree` | `n < a → λ_a(n) = λ(n)` |
| `slice_sub_self` | `λ_a(n) − λ(n) = −2λ(a)` at `n = a`, else `0` |
| `slice_abs_le_one` | `\|λ_a(n)\| ≤ 1` |
| `slice_ne_self_iff` | `λ_a(n) ≠ λ(n) ↔ n = a` |
| `slice_ne` | `a ≠ 0 → λ_a ≠ λ` |
| `corrSlice_eq_corr_of_lt` | `N + h < a → corrSlice h a N = corr h N` |
| `corrSliceSqSub` | `1 ≤ a ≤ N → Σ_{n≤N} (λ_a(n) − λ(n))² = 4` |
| `corrAsymptotic_reading` | the asymptotic reading: prefixes do not determine `corrAsymptotic h` |

**Verified numerically** (`chowla_two_point.py`, 30/30, exit 0):

* the correlation table `S(10^k)`, `max_{x'≤x}|S|` and `max|S|/√x` for `k ≤ 8`;
* a prefix-maximum exponent fit `α = 0.5200 ± 0.0249` over six decades — recorded
  explicitly as a **finite-range fit**, making no asymptotic claim;
* the logarithmically averaged correlation (a known theorem, checked finitely);
* the finite-prefix construction, including a witness agreeing with `λ` on all of
  `[1, 10⁸]` whose correlation sum grows like a non-zero multiple of `x`;
* the failure of multiplicativity and of the naive Euler product.

## What is *not* proved, and where

* **Two-point Chowla (★) is open.**  Nothing in this folder asserts, proves, or
  "verifies" it; a finite computation cannot.
* The exact perturbation identity
  `corrSlice h a a − corr h a = −2λ(a)λ(a+h) − 2λ(a−h)λ(a)`
  is recorded in `Rh46/Chowla.lean` as a documented comment rather than
  elaborated; it is the single statement in the file that is not proved.  The
  prefix-agreement half is `corrSlice_eq_corr_of_lt`, and the `ℓ²`-mass of the
  perturbation is computed rigorously in `corrSliceSqSub`.

## The one non-pass in the independent check

`independent_check.py` reports **25/26**.  The single `[FAIL]` is `S2.crosscheck`,
and it is a *recorded data correction*, not a disagreement about the mathematics:
the round's early reconnaissance printed `S(10⁷) = 1244`, while the auditor's three
mutually independent computations of `λ` (segmented trial division, an additive
prime-power sieve, and direct factorization) together with a flat cumulative sum
all give

```
S(10^7) = 1246 .
```

The difference of `+2` was traced to a final-block boundary slip in the
reconnaissance's streaming scan.  `1246` is the value used throughout.

## Running the checks

```sh
# numerics: 30 checks, exit 0, wall clock ≈ 4 min, sieve to 10^9
python3 chowla_two_point.py

# independent recomputation: 25/26 (see above), ≈ 30 s, sieve to 10^8
python3 independent_check.py

# Lean 4 + Mathlib
./check.sh --all
```

`check.sh` needs a Lean installation at `$LEAN_PREFIX` (default `$HOME/lean`):
elan at `$LEAN_PREFIX/elan` and Mathlib4 at `$LEAN_PREFIX/mathlib4`.  The
toolchain is read from Mathlib's own `lean-toolchain`; this folder was checked
against `leanprover/lean4:v4.35.0-rc2`.  Inside any Lean 4 project that provides
Mathlib one may equivalently run

```sh
lake env lean Rh46/Chowla.lean
lake env lean Rh46.lean
```

`Rh46/Chowla.lean` imports `Mathlib` and nothing else.  Each script tees its output
to `logs/` and exits with status `0` if and only if every one of its checks passes
(so `independent_check.py` exits `1`, by design — see above).

## What is claimed, in one line each

| Claim | Status |
|---|---|
| `\|Σ_{n≤x} λ(n)λ(n+h)\| ≤ x`; `Σ_{n≤x} λ(n)² = x` | **proved** (Lean: `corr_abs_le`, `corr_zero`) |
| the correlation of `λ ≡ 1` is `x`, so `o(x)` is not formal | **proved** (Lean: `corrAsymptotic_zero_false`) |
| `n ↦ λ(n)λ(n+2)` is not multiplicative | **proved** (Lean: `shiftProd_not_completely_multiplicative`) |
| prefix agreement: `λ_a` and `λ` give identical correlations on `[1, N]` whenever `N + h < a` | **proved** (Lean: `slice_agree`, `corrSlice_eq_corr_of_lt`) |
| a function agreeing with `λ` on all of `[1, 10⁸]` can still have `S(x) = Θ(x)` | **verified** numerically (auditor check A1) |
| the perturbation has `ℓ²`-mass exactly `4` | **proved** (Lean: `corrSliceSqSub`) |
| the exact perturbation identity | *recorded, not elaborated* |
| `Σ_{n≤x} λ(n)λ(n+2) = o(x)` | **open** — not claimed |
| the logarithmically averaged form is `o(1)` | known theorem (Tao; Matomäki–Radziwiłł–Tao); checked finitely here |

## References

Published work only; nothing below is internal to the programme.

1. S. Chowla, *The Riemann hypothesis and Hilbert's tenth problem*, Mathematics and
   its Applications, Gordon and Breach, New York, 1965.  (The conjecture.)
2. P. Sarnak, *Three lectures on the Möbius function, randomness and dynamics*,
   lecture notes, IAS, 2010.
3. T. Tao, *The logarithmically averaged Chowla and Elliott conjectures for
   two-point correlations*, Forum of Mathematics, Pi **4** (2016), e8.
4. K. Matomäki, M. Radziwiłł and T. Tao, *Sign patterns of the Liouville and
   Möbius functions*, Forum of Mathematics, Sigma **4** (2016), e14.
5. K. Matomäki and M. Radziwiłł, *Multiplicative functions in short intervals*,
   Annals of Mathematics **183** (2016), 1015–1056.
6. J. Friedlander and H. Iwaniec, *Opera de cribro*, AMS Colloquium Publications
   **57**, 2010.  (The parity problem.)

## Provenance

The material was produced in the programme's round `rh46` and is reproduced here
verbatim except for (i) the paths in `check.sh`, which have been made
folder-relative, and (ii) the replacement of absolute machine paths in the logs
with folder-relative ones.  The Lean sources, the two Python scripts and the log
contents are otherwise unmodified.

**Deliberately excluded: development fragments.**  The round's working directory
also contained 67 transient files (`Check1.lean` … `Check35.lean`,
`Test1.lean` … `Test27.lean`, `Scratch.lean` … `Scratch5.lean`) used while the
proofs were being developed.  They are exploratory fragments rather than
deliverables: several are partial restatements of individual lemmas now in
`Rh46/Chowla.lean`, some are `#check` sessions rather than compilable modules,
and seven of them contain `sorry` or `admit`.  Including them would break the
package's no-`sorry` property and add nothing that `Rh46/Chowla.lean` does not
already establish, so they are omitted.  `Rh46/Chowla.lean` is the complete,
`sorry`-free development.
