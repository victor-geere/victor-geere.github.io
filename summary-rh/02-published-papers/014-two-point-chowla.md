# 014 — The Finite-Prefix Indeterminacy Theorem for the Two-Point Liouville Correlation

| Field | Value |
|---|---|
| Source | [`research/publish/014-two-point-chowla/manuscript.md`](../rh/research/publish/014-two-point-chowla/manuscript.md) |
| Status | Published second edition; fuller than 007. |
| Harvested statements | 10 |

> **Second edition.** Same theorem as 007; 014 is the fuller edition (self-contained HTML paper, independent recomputation, logs).

## Abstract

Let $\lambda(n) = (-1)^{\Omega(n)}$ be the Liouville function, $\Omega$ the number of
prime factors counted with multiplicity, and let
$\mathrm{corr}(h,N) = \sum_{n=1}^{N} \lambda(n)\lambda(n+h)$. The two-point Chowla
conjecture in the case $h = 2$ asserts $\mathrm{corr}(2,N) = o(N)$; it is **open**. We
prove that it is also *not decidable from finite data*. Explicitly, for each index $a$
let $\lambda_a$ be $\lambda$ with its value at $a$ negated. Then $\lambda_a(n) =
\lambda(n)$ for every $n < a$; consequently $\mathrm{corrSlice}(h,a,N) =
\mathrm{corr}(h,N)$ whenever $N + h < a$, so the two functions present *identical*
correlation data on every prefix shorter than $a$, while $\lambda_a \ne \lambda$. The
cumulative $\ell^2$-mass of the perturbation over a prefix containing $a$ is exactly
$4$. Hence the truth of $\mathrm{corr}(2,N) = o(N)$ is a statement about the limit of
$\mathrm{corr}(2,N)/N$ and cannot be settled by inspecting any initial segment of
values: a finite computation may refute the assertion but can never establish it. We
also record the trivial bound $|\mathrm{corr}(h,N)| \le N$ and the sharpness witness
$\mathrm{corr}(0,N) = N$, which show that $o(N)$ is not a formal consequence of
multiplicativity and boundedness; and we verify that the summand
$n \mapsto \lambda(n)\lambda(n+2)$ is not multiplicative, so that the shifted product
admits no Euler product and the $\zeta$-based route does not apply.

**Keywords:** Liouville function; Chowla conjecture; two-point correlation; finite-prefix
indeterminacy; parity problem; Lean 4; Mathlib; computer-assisted proof.

## Harvested theorem-like statements

### Definition 2.1 (Liouville function).

For $n \ge 1$,
$\lambda(n) = (-1)^{\Omega(n)}$, where $\Omega(n)$ is the number of prime factors of
$n$ counted with multiplicity. The Lean development defines `Omega n :=
ArithmeticFunction.cardFactors n` and `liouville n := (-1) ^ Omega n`, with value
$1$ at $n = 0$ (`Rh46/Chowla.lean`, definitions `Omega`, `liouville`); the agreement
with Mathlib's `ArithmeticFunction.liouville` off zero is the theorem
`liouville_eq_arithLiouville`.

### Definition 2.2 (correlation).

For $h, N \in \mathbb{N}$,

$$\mathrm{corr}(h,N) = \sum_{n=1}^{N} \lambda(n)\lambda(n+h).$$

Lean: `corr h N := ∑ n ∈ Finset.Icc 1 N, liouville n * liouville (n + h)`.

### Definition 2.3 (the slice of $\lambda$ at $a$).

For $a \in \mathbb{N}$ define
$\lambda_a : \mathbb{N} \to \mathbb{Z}$ by

$$\lambda_a(n) = \begin{cases} -\lambda(a), & n = a, \\ \lambda(n), & n \ne a,\end{cases}$$

and let

$$\mathrm{corrSlice}(h,a,N) = \sum_{n=1}^{N} \lambda_a(n)\lambda_a(n+h).$$

Lean: `liouvilleSlice a n := if n = a then -liouville a else liouville n`, and
`corrSlice h a N`.

### Definition 2.4 (the asymptotic statement).

$\mathrm{corrAsymptotic}\ h$ is the
assertion $\mathrm{corr}(h,N) = o(N)$, i.e. $\mathrm{corr}(h,N)/N \to 0$
(`Rh46/Chowla.lean`, definition `corrAsymptotic`). Thus $(\star)$ is the statement
$\mathrm{corrAsymptotic}\ 2$.

The shifted product is $f(n) = \lambda(n)\lambda(n+2)$ with Dirichlet series
$D(s) = \sum_{n \ge 1} f(n)n^{-s}$ (§4.3).

### Theorem 3.1 (trivial bound).

For all $h, N \in \mathbb{N}$,
$|\mathrm{corr}(h,N)| \le N$. *(Status: PROVED. Lean `Rh46.corr_abs_le`.)*
Each of the $N$ summands is $\pm 1$.

### Theorem 3.2 (sharpness witness).

$\mathrm{corr}(0,N) = N$ for every $N$, since
$\lambda(n)^2 = 1$. Hence $\mathrm{corr}(0,N)/N \to 1$, and $o(N)$ is *not* a formal
consequence of multiplicativity together with the bound $|\lambda| \le 1$: the
deterministic, completely multiplicative function $\lambda \equiv 1$ has correlation
exactly $N$. Equivalently, $\neg\,\mathrm{corrAsymptotic}\ 0$.
*(Status: PROVED. Lean `Rh46.corr_zero` and `Rh46.corrAsymptotic_zero_false`.)*

Theorem 3.2 is the reason $(\star)$ must use genuine arithmetic input: no soft argument
that consumes only multiplicativity and boundedness can produce it.

**Elementary properties used above** (each PROVED in `Rh46/Chowla.lean`):
`Omega_eq_cardFactors`, `Omega_eq_factorization_sum`, `liouville_eq_arithLiouville`
(agreement with Mathlib's `ArithmeticFunction.liouville` off zero), `liouville_mul`
(complete multiplicativity on nonzero arguments), with `liouville_mul_zero_false`
refuting the zero case, `liouville_mem`, `liouville_ne_zero`, `liouville_sq`,
`liouville_abs_le_one`.

### Theorem 3.3 (prefix agreement / indistinguishability on prefixes).

For all
$h, a, N$ with $N + h < a$,

$$\mathrm{corrSlice}(h,a,N) = \mathrm{corr}(h,N).$$

Equivalently: the values $\mathrm{corr}(h,1), \mathrm{corr}(h,2), \dots,
\mathrm{corr}(h,N)$ carry no information that could distinguish $\lambda$ from a
function differing from it at a later index.

*(Status: PROVED. Lean `Rh46.slice_agree`, the pointwise agreement
$n < a \Rightarrow \lambda_a(n) = \lambda(n)$, and `Rh46.corrSlice_eq_corr_of_lt`, the
identity of correlations; combined in `Rh46.corrAsymptotic_reading`.)*

### Theorem 3.4 (the two functions are nevertheless different).

Let $a \ne 0$. Then
$\lambda_a \ne \lambda$, and $\lambda_a$ differs from $\lambda$ exactly at $a$, by
$-2\lambda(a)$. Moreover $\lambda_a$ takes its values in $\{-1,+1\}$, and the
perturbation has cumulative $\ell^2$-mass exactly $4$ over any prefix containing $a$:
for $1 \le a \le N$,

$$\sum_{n=1}^{N} \bigl(\lambda_a(n) - \lambda(n)\bigr)^2 = 4.$$

*(Status: PROVED. Lean `Rh46.slice_ne`, `Rh46.slice_self`, `Rh46.slice_sub_self`,
`Rh46.slice_ne_self_iff`, `Rh46.slice_abs_le_one`, `Rh46.corrSliceSqSub`.)*

### Corollary 3.5 (indeterminacy).

Two functions that agree on an arbitrarily long
initial segment can present identical correlation data on that segment and yet be
distinct. The assertion $\mathrm{corr}(2,N) = o(N)$ constrains the *limit* of
$\mathrm{corr}(2,N)/N$, hence is not a finite-prefix property. A computation on
$n \le X$ can refute $(\star)$ — by exhibiting a prefix where the quotient is large —
but can never prove it.

The strongest numerical form of the gap, verified independently in this folder, is a
witness $\lambda''$ agreeing with $\lambda$ on *all* of $[1, 10^8]$ and equal to $1$
beyond, whose correlation sum satisfies $\mathrm{corr}''(x) = \mathrm{corr}(x)$ for
every $x \le 10^8 - 2$ yet $\mathrm{corr}''(x)/x \to 1$. The whole computed dataset is
therefore equally consistent with $\mathrm{corr}(2,N) = o(N)$ and with
$\mathrm{corr}(2,N) = \Theta(N)$. *(Status: VERIFIED numerically; see §4.4 and §4.5.)*

A refinement, also verified numerically, shows *which* perturbations can matter:
replacing the signs on a set $A$ changes the sum by at most
$2\,\#\{n \le x : n \in A \ \text{or}\ n+2 \in A\}$, so an $o(x)$-sized modification
changes the sum by $o(x)$ only. Positive density — as in the slice of Theorem 3.4,
where one index is changed but the correlation sum acquires a fixed $\pm 2$-valued
contribution from the two summands containing $a$ — is necessary for a witness of this
kind.

**Remark 3.6 (the exact perturbation identity — recorded, not elaborated).** The exact
perturbation identity for one sign flip,

$$\mathrm{corrSlice}(h,a,a) - \mathrm{corr}(h,a) = -2\lambda(a)\lambda(a+h) -
2\lambda(a-h)\lambda(a),$$

is recorded in `Rh46/Chowla.lean` as a documented comment rather than elaborated; it is
the single statement in that file which is not proved. Its two halves are each
established there — the prefix agreement is Theorem 3.3, and the $\ell^2$-mass of the
perturbation is Theorem 3.4 — and the Lean file instead proves the weaker but
unconditional sign statement `Rh46.corrSlice_ne_corr_self_statement`. We flag this
explicitly rather than presenting the displayed identity as verified.

### Proposition 3.7.

The function $n \mapsto \lambda(n)\lambda(n+2)$ is not
multiplicative. Consequently the Dirichlet series
$D(s) = \sum_{n \ge 1}\lambda(n)\lambda(n+2)n^{-s}$ has no Euler product, and the
standard $\zeta$-based analysis of the shifted product does not apply.
*(Status: PROVED. Lean `Rh46.shiftProd_not_completely_multiplicative`, with the concrete
witness `Rh46.shiftProd_two_five`.)*

An earlier draft that asserted an elementary $\zeta$/Perron derivation of $(\star)$ was
withdrawn for this reason (`ROUND-NOTES.md`, §1.5; `logs/independent_check.log`, note on
the WITHDRAWN "RH-conditional $x^{1/2+\varepsilon}$" reading).

The obstruction is structural, not technical: the shift $n \mapsto n+2$ destroys
multiplicativity, so the coefficient sequence of $D$ is a genuine shifted convolution.
Its evaluation requires either a strong zero-free region together with cancellation in
the shifted convolution, or the entropy-decrement technology of Tao [3] and
Matomäki–Radziwiłł–Tao [4]. No argument of either kind is asserted here.

## Source

[`manuscript.md`](../rh/research/publish/014-two-point-chowla/manuscript.md) · [`README.md`](../rh/research/publish/014-two-point-chowla/README.md)
