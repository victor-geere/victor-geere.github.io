# Finite explicit formula

**Status:** partial. This dossier fixes a test function and certifies its
autocorrelation and the finite prime side of the explicit formula. The analytic
explicit formula, the archimedean term and the zero side are **not** formalised;
they are recorded as source claims and open tasks.

Target of `status.html` §7 **P4**: a rigorous certified finite-window explicit
formula for a fixed test function, replacing floating point in B5.

## The fixed test function

The tent function

\[
  f(x)=\max(0,1-|x|)
\]

is even, non-negative and supported on `[-1,1]`. Its autocorrelation is the cubic
B-spline

\[
  g(x)=(f*f)(x)=
  \begin{cases}
    \tfrac12|x|^3-|x|^2+\tfrac23, & |x|\le 1,\\[2pt]
    -\tfrac16|x|^3+|x|^2-2|x|+\tfrac43, & 1\le |x|\le 2,\\[2pt]
    0, & |x|\ge 2.
  \end{cases}
\]

`g` is even and non-negative, and its Fourier transform is `ĝ(t)=|f̂(t)|²≥0`.
The explicit formula for `g` is the source identity

\[
  \sum_\rho \hat g(\gamma_\rho)
  = \hat g(\tfrac i2)+\hat g(-\tfrac i2)
    -\sum_{n\ge 2}\frac{\Lambda(n)}{\sqrt n}\bigl(g(\log n)+g(-\log n)\bigr)
    + \text{(archimedean term)},
\]

with the standard conventions. This dossier does **not** prove it.

## What is proved

| id | type | statement | Lean name |
|---|---|---|---|
| T1 | Theorem | `0 ≤ f(x)` for all real `x`. | `FiniteExplicitFormula.tent_nonneg` |
| T2 | Theorem | `0 ≤ g(x)` for all real `x`. | `FiniteExplicitFormula.tentAutocorr_nonneg` |
| T3 | Theorem | `g(-x)=g(x)`. | `FiniteExplicitFormula.tentAutocorr_even` |
| T4 | Theorem | `0 < g(x)` for `|x| < 2` (strict cone positivity inside the support). | `FiniteExplicitFormula.tentAutocorr_pos` |
| T5 | Theorem | The dominant `n=2` prime term `-2(log 2/√2)(log³2/2-log²2+2/3)` is negative; its rational interval enclosure is Lean-checked. | `FiniteExplicitFormula.term2Value_negative` |
| T6 | Theorem | The **full five-term** prime side for support `2` is negative; the sum of rational interval enclosures is Lean-checked. | `FiniteExplicitFormula.primeSideValue_negative` |
| T7 | Theorem | The tent function is continuous. | `FiniteExplicitFormula.tent_continuous` |
| T8 | Theorem | `∫_{-1}^1 f(x)^2 dx = 2/3`, matching `g(0) = 2/3` (the autocorrelation at zero). | `FiniteExplicitFormula.integral_tent_sq` |
| T9 | Theorem | `∫_{-1}^1 f(x) dx = 1` (the normalization of the tent test function). | `FiniteExplicitFormula.integral_tent` |
| T10 | Theorem | `∫_0^1 g(x) dx = 11/24`, the first piece of the autocorrelation integral. | `FiniteExplicitFormula.integral_g01` |
| T11 | Theorem | `g(1) = 1/6`, the matching boundary value of the two cubic branches. | `FiniteExplicitFormula.tentAutocorr_one` |
| T12 | Theorem | `g(2) = 0`, the outer boundary value. | `FiniteExplicitFormula.tentAutocorr_two` |
| T13 | Theorem | `∫_1^2 g(x) dx = 1/24`, the second piece of the autocorrelation integral. | `FiniteExplicitFormula.integral_g12` |
| T14 | Theorem | `∫_0^2 g(x) dx = 1/2`, combining the two pieces. | `FiniteExplicitFormula.integral_g02` |
| T15 | Theorem | **Full autocorrelation normalization:** `∫_{-2}^{2} g(x) dx = 1`, via evenness and integrability under negation. | `FiniteExplicitFormula.integral_tentAutocorr` |
| T16 | Theorem | **Convolution at `x=0`:** `∫ f(t)f(t)dt = g(0)`, the first point of `g = f*f`. | `FiniteExplicitFormula.autocorr_at_zero` |
| T17 | Theorem | `f(0) = 1`. | `FiniteExplicitFormula.tent_zero` |
| T18 | Theorem | `f(1) = 0`. | `FiniteExplicitFormula.tent_one` |
| T19 | Theorem | **Convolution at `x=1`:** `∫ f(t)f(t-1)dt = g(1) = 1/6`. | `FiniteExplicitFormula.autocorr_at_one` |
| T20 | Theorem | **Convolution at `x=3/2`:** `∫ f(t)f(t-3/2)dt = g(3/2) = 1/48`. | `FiniteExplicitFormula.autocorr_at_three_halves` |
| T21 | Theorem | **Convolution at `x=5/2`:** `∫ f(t)f(t-5/2)dt = g(5/2) = 0` (disjoint supports). | `FiniteExplicitFormula.autocorr_at_five_halves` |
| T22 | Theorem | **Convolution at `x=2`:** `∫ f(t)f(t-2)dt = g(2) = 0`. | `FiniteExplicitFormula.autocorr_at_two` |
| T23 | Theorem | `g(x)=0` for every `|x| ≥ 2`. | `FiniteExplicitFormula.tentAutocorr_eq_zero_of_two_le` |
| T24 | Theorem | The convolution integral vanishes for every `|x| ≥ 2`. | `FiniteExplicitFormula.autocorr_eq_zero_of_two_le` |
| T25 | Theorem | **General convolution outside the support:** for every `|x| ≥ 2`, `∫ f(t)f(t-x)dt = g(x)`. | `FiniteExplicitFormula.autocorr_outside_support` |
| T26 | Theorem | **General convolution on `[1,2]`:** for every `1 ≤ x ≤ 2`, `∫ f(t)f(t-x)dt = g(x)`. | `FiniteExplicitFormula.autocorr_between_one_two` |
| T27 | Theorem | **General convolution on `[-2,-1]`:** for every `-2 ≤ x ≤ -1`, `∫ f(t)f(t-x)dt = g(x)`. | `FiniteExplicitFormula.autocorr_between_neg_two_neg_one` |
| C1 | Computation | Exact rational values: `g(0)=2/3`, `g(1/2)=23/48`, `g(1)=1/6`, `g(3/2)=1/48`, `g(2)=0`. | `tests/test_programme.py` |
| C2 | Computation | A rigorous interval enclosure of the finite prime side for support `2` (prime powers `2,3,4,5,7`), using `mpmath.iv`. | `python/programme.py` |
| C3 | Computation | Numerical quadrature checks `∫f = 1` and `∫f² = 2/3` (40-digit `mpmath`, not a certificate). | `tests/test_programme.py` |
| C4 | Computation | Numerical convolution check `g(x) ≈ ∫ f(t)f(t-x)dt` at `x = 0, 1/2, 1, 3/2` (not a certificate). | `tests/test_programme.py` |
| C5 | Computation | Numerical check `∫_{-2}^{2} g = 1` (not a certificate). | `tests/test_programme.py` |
| C6 | Computation | Numerical convolution check `g(x) ≈ ∫ f(t)f(t-x)dt` on a grid of `x ∈ [-0.9,0.9]` (not a certificate). | `tests/test_programme.py` |

The prime side is **finite** because `g` is supported on `[-2,2]`: only `n` with
`log n ≤ 2` contribute. The full sum is computed independently in `mpmath.iv`
(C2) and is **Lean-certified** as a rational interval in `PrimeSide.lean`
(T6), including the dominant `n=2` term (T5).

## What is open

- **Full convolution identity.** Certified at `x=0` and `x=1`; the general
  `x` case and the remaining sample points are open.
- **Analytic explicit formula.** Source claim (Weil/Bombieri); not formalised.
- **Archimedean term.** Needs a rigorous integral enclosure of the
  `Γ'/Γ` factor against `g`.
- **Zero side.** Requires certified zeros *with their real parts*, plus a
  zero-counting tail. The P3 dossier certifies non-vanishing at `1/2+5i` and a
  thin zero-free segment; it does **not** isolate a zero.
- **Finite-window positivity (B5).** Needs the analytic formula, the
  archimedean term and the zero side together.

## What would close P4

1. A certified zero isolation (real and imaginary parts) for at least the first
   zero in the window.
2. A rigorous archimedean integral enclosure.
3. A zero-counting tail bound (Riemann–von Mangoldt) matching the window.
4. The explicit formula itself, either formalised or accepted as a named source
   theorem with a checked specialisation.

## Commands

```bash
cd the-final-letter/topics/finite-explicit-formula
python3 -m pytest -q tests
./lean/check.sh
```

## Provenance

- `status.html` §7 P3–P4.
- `topics/finite-window-zeros/` — the certified enclosure machinery reused by a
  future zero side.
- `topics/partial-sum-plus-tail/` — the rational interval and complex-power atoms.
