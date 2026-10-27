# The Finite-Prefix Indeterminacy Theorem for the Two-Point Liouville Correlation

**Second edition.** Subject class: 11Nxx (multiplicative functions), 11A25 (arithmetic
functions), 03B35 (mechanisation of proofs). This edition packages the same theorem as
`publish/007-two-point-chowla`, in self-contained form; the README of this folder records
that `014` is the fuller edition, adding a self-contained paper
(`finite-prefix-indeterminacy.html`), an independent recomputation carrying its own
Liouville function (`independent_check.py`), and bit-identical rerun logs. No priority
over `007` is claimed. Material is from the programme's round `rh46`.

**The two-point Chowla conjecture is not proved here.** Nothing in this folder asserts,
disproves, or numerically "verifies" it. What is proved is a statement *about* it: that
its truth value is not a finite-prefix property of the Liouville function.

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

## 1. Introduction and goal

The **Chowla conjecture** asserts that the correlations of the Liouville function
vanish. The two-point case relevant to twin primes is the assertion

$$(\star)\qquad \mathrm{corr}(2,N) = \sum_{n \le N} \lambda(n)\lambda(n+2) = o(N)
\qquad (N \to \infty).$$

This is the **two-point Chowla conjecture**, and it is open
(`README.md`, §"What is *not* proved"; `ROUND-NOTES.md`, §"The answer, stated
first"). The goal of this folder is *not* to prove $(\star)$. It is to establish the
precise status of $(\star)$, the exact bounds that are available, and the substantive
logical point: that **no pointwise or finite-prefix argument can ever establish it**.

The folder is self-contained; its only external dependencies are Mathlib (with a Lean 4
toolchain), needed only to elaborate the Lean sources, and NumPy and mpmath, imported by
the two Python scripts. The unconditionally known results are *averaged*, and are quoted
rather than reproved: Tao's logarithmically averaged two-point Chowla theorem and the
Matomäki–Radziwiłł–Tao almost-all-shifts and short-interval results (`README.md`,
"References"; `ROUND-NOTES.md`, §1.3).

## 2. Setup and definitions

All sums below are over integers $n \ge 1$; all indices $h, a, N$ are non-negative
integers.

**Definition 2.1 (Liouville function).** For $n \ge 1$,
$\lambda(n) = (-1)^{\Omega(n)}$, where $\Omega(n)$ is the number of prime factors of
$n$ counted with multiplicity. The Lean development defines `Omega n :=
ArithmeticFunction.cardFactors n` and `liouville n := (-1) ^ Omega n`, with value
$1$ at $n = 0$ (`Rh46/Chowla.lean`, definitions `Omega`, `liouville`); the agreement
with Mathlib's `ArithmeticFunction.liouville` off zero is the theorem
`liouville_eq_arithLiouville`.

**Definition 2.2 (correlation).** For $h, N \in \mathbb{N}$,

$$\mathrm{corr}(h,N) = \sum_{n=1}^{N} \lambda(n)\lambda(n+h).$$

Lean: `corr h N := ∑ n ∈ Finset.Icc 1 N, liouville n * liouville (n + h)`.

**Definition 2.3 (the slice of $\lambda$ at $a$).** For $a \in \mathbb{N}$ define
$\lambda_a : \mathbb{N} \to \mathbb{Z}$ by

$$\lambda_a(n) = \begin{cases} -\lambda(a), & n = a, \\ \lambda(n), & n \ne a,\end{cases}$$

and let

$$\mathrm{corrSlice}(h,a,N) = \sum_{n=1}^{N} \lambda_a(n)\lambda_a(n+h).$$

Lean: `liouvilleSlice a n := if n = a then -liouville a else liouville n`, and
`corrSlice h a N`.

**Definition 2.4 (the asymptotic statement).** $\mathrm{corrAsymptotic}\ h$ is the
assertion $\mathrm{corr}(h,N) = o(N)$, i.e. $\mathrm{corr}(h,N)/N \to 0$
(`Rh46/Chowla.lean`, definition `corrAsymptotic`). Thus $(\star)$ is the statement
$\mathrm{corrAsymptotic}\ 2$.

The shifted product is $f(n) = \lambda(n)\lambda(n+2)$ with Dirichlet series
$D(s) = \sum_{n \ge 1} f(n)n^{-s}$ (§4.3).

## 3. Results

### 3.0 The trivial bound and its sharpness

**Theorem 3.1 (trivial bound).** For all $h, N \in \mathbb{N}$,
$|\mathrm{corr}(h,N)| \le N$. *(Status: PROVED. Lean `Rh46.corr_abs_le`.)*
Each of the $N$ summands is $\pm 1$.

**Theorem 3.2 (sharpness witness).** $\mathrm{corr}(0,N) = N$ for every $N$, since
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

### 3.1 The finite-prefix indeterminacy theorem

**Theorem 3.3 (prefix agreement / indistinguishability on prefixes).** For all
$h, a, N$ with $N + h < a$,

$$\mathrm{corrSlice}(h,a,N) = \mathrm{corr}(h,N).$$

Equivalently: the values $\mathrm{corr}(h,1), \mathrm{corr}(h,2), \dots,
\mathrm{corr}(h,N)$ carry no information that could distinguish $\lambda$ from a
function differing from it at a later index.

*(Status: PROVED. Lean `Rh46.slice_agree`, the pointwise agreement
$n < a \Rightarrow \lambda_a(n) = \lambda(n)$, and `Rh46.corrSlice_eq_corr_of_lt`, the
identity of correlations; combined in `Rh46.corrAsymptotic_reading`.)*

**Theorem 3.4 (the two functions are nevertheless different).** Let $a \ne 0$. Then
$\lambda_a \ne \lambda$, and $\lambda_a$ differs from $\lambda$ exactly at $a$, by
$-2\lambda(a)$. Moreover $\lambda_a$ takes its values in $\{-1,+1\}$, and the
perturbation has cumulative $\ell^2$-mass exactly $4$ over any prefix containing $a$:
for $1 \le a \le N$,

$$\sum_{n=1}^{N} \bigl(\lambda_a(n) - \lambda(n)\bigr)^2 = 4.$$

*(Status: PROVED. Lean `Rh46.slice_ne`, `Rh46.slice_self`, `Rh46.slice_sub_self`,
`Rh46.slice_ne_self_iff`, `Rh46.slice_abs_le_one`, `Rh46.corrSliceSqSub`.)*

**Corollary 3.5 (indeterminacy).** Two functions that agree on an arbitrarily long
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

### 3.2 The Dirichlet-series route does not apply

**Proposition 3.7.** The function $n \mapsto \lambda(n)\lambda(n+2)$ is not
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

### 3.3 What is open

* $(\star)$, i.e. $\mathrm{corrAsymptotic}\ 2$, is **OPEN** and is not claimed. Nothing
  in this folder asserts, proves, or "verifies" it; a finite computation cannot.
* The logarithmically averaged form
  $L_h(x) = (1/\log x)\sum_{n \le x}\lambda(n)\lambda(n+h)/n \to 0$ for fixed $h$ is a
  **known theorem** (Tao; Matomäki–Radziwiłł–Tao), checked finitely here. One-point
  Chowla is quoted in `ROUND-NOTES.md` §1.3 as unreachable by sieve weights built from
  small-prime residue conditions — the parity problem of Selberg, for which see
  Friedlander–Iwaniec [6].
* The status table of `README.md` ("What is claimed, in one line each") is reproduced in
  §5.

## 4. Verification and evidence

Everything in this section is a *finite check*: a computation on finitely many integers.
It illustrates the theorems, and by §3.1 it cannot do more. Two independent programs are
included; the values below are those agreed by both, except where noted.

**No script was re-run while writing this manuscript.** The counts, exit statuses and
timings below are exactly as recorded in `logs/` and reported in `README.md`; the
sections say plainly where a recorded run was not reproduced.

### 4.1 The reference self-check `chowla_two_point.py`

* Command: `python3 chowla_two_point.py`
* Recorded outcome: **30 checks pass, 0 fail**, exit status **0**, wall clock
  **253.0 s** in `logs/chowla_two_point.log` ("log written to logs/chowla_two_point.log",
  final block `30 checks pass, 0 fail (wall clock 253.0s)`). The folder's
  `logs/exit_code.txt` records `EXIT_CODE=0 (final run, 30 checks pass, 0 fail, wall
  clock 262.5s)`, and the second recorded run `logs/chowla_two_point.repro1.log` reports
  **30 checks pass, 0 fail** at wall clock **264.1 s**. `README.md` states 30/30, exit 0,
  ≈ 4 min, sieve to $10^9$. The script tees its output to `logs/` and exits with status
  $0$ if and only if every one of its checks passes.
* **Not run here.** The script's own README note gives its cost as about four minutes
  (sieve to $10^9$); the numbers above are the recorded ones.

The script's own header states the logical situation explicitly: "(STAR) is OPEN. Every
number in this file is a FINITE CHECK. Nothing here proves (STAR); §4 proves that no
finite check could."

### 4.2 The correlation table (checked finitely)

Exact integer values of $\mathrm{corr}(2,x) = S(x)$, all with $\mathrm{tol} = 0$
(`logs/chowla_two_point.log` §1; `logs/independent_check.log` §3):

| $x$ | $10^3$ | $10^4$ | $10^5$ | $10^6$ | $10^7$ | $10^8$ | $10^9$ |
|---|---|---|---|---|---|---|---|
| $S(x)$ | $-30$ | $12$ | $258$ | $68$ | $1246$ | $4632$ | $43790$ |
| $S(x)/x$ | $-3.0\cdot10^{-2}$ | $1.2\cdot10^{-3}$ | $2.6\cdot10^{-3}$ | $6.8\cdot10^{-5}$ | $1.25\cdot10^{-4}$ | $4.6\cdot10^{-5}$ | $4.4\cdot10^{-5}$ |
| $\max_{x'\le x}\lvert S\rvert$ | $30$ | $73$ | $282$ | $689$ | $3059$ | $6454$ | $48700$ |
| $\max\lvert S\rvert/\sqrt{x}$ | $0.95$ | $0.73$ | $0.89$ | $0.69$ | $0.97$ | $0.65$ | $1.54$ |

The attainers are $\max\lvert S\rvert = 3059$ at $x = 8572105$ and
$\max\lvert S\rvert = 6454$ at $x = 66967578$. Also exact, from the independent
recomputation: $\sum_{n \le 10^8}\lambda(n) = -3884$ (`logs/independent_check.log`,
§2). The $x = 10^9$ row is in `logs/chowla_two_point.log` §1 and in `ROUND-NOTES.md`
§1.2 (the script's window log reaches $S(10^9) = 43790$); it was not re-run here.

`S1.trivial.bound`, `S1.crosscheck.direct` and `S1.crosscheck.weighted` compare the
segmented pass against one flat $\lambda$ array with a single cumulative sum at
$x = 10^5, 10^6, 10^7$ (differences $0.00\cdot10^0$), which is what detects a dropped
pair straddling a window boundary.

### 4.3 The prefix-maximum exponent (a finite-range fit only)

The log–log fit of $\max_{x' \le x}\lvert S(x')\rvert$ against $x^\alpha$ over seven
points spanning six decades ($x = 10^3, \dots, 10^9$, sieve to $10^9$, 100 windows of
$10^7$) gives

$$\alpha = 0.5200 \pm 0.0249, \qquad b = -0.4038, \qquad \text{rms residual in } \log M
= 0.2562$$

(`logs/chowla_two_point.log` §2, check `S2.exponent.in.range`). The independent run over
$x \le 10^8$ gives $\theta = 0.4834 \pm 0.0186$ with $R^2 = 0.9941$, $C = 0.9896$, and
local exponents between consecutive decades $0.386, 0.587, 0.388, 0.647, 0.324$, ranging
$0.324$–$0.647$ (`logs/independent_check.log` §4, checks `B2`, `B4`).

**This is a finite-range fit and no asymptotic claim is made.** The script's own honest
reading is recorded as check `S2.no.claim.from.fit`: "$\alpha$ is a description of 7
points over 6 decades; no asymptotic statement follows from it". The $\max\lvert S\rvert
/\sqrt{x}$ column drifts from $0.645$ to $1.54$; the script calls this the expected
$x^{1/2+\varepsilon}$ behaviour and states that it proves nothing. The independent check
records the "RH-conditional $x^{1/2+\varepsilon}$" reading as **WITHDRAWN / unverified**
(B4), with the reason that $\lambda(n)\lambda(n+2)$ is not multiplicative.

### 4.4 The logarithmic average (a known theorem, checked finitely)

$L_h(x) = (1/\log x)\sum_{n \le x}\lambda(n)\lambda(n+h)/n$, computed in `float64`
(check `L5.prec` compares against an mpmath 40-digit evaluation at $x = 10^4$; observed
difference $0$ for $h = 2$ and $1.110\cdot10^{-16}$ for $h = 1$, within the a-priori
bound $10^{-13}$):

| $x$ | $10^5$ | $10^6$ | $10^7$ | $10^8$ |
|---|---|---|---|---|
| $L_2(x)$ | $-0.117631$ | $-0.098159$ | $-0.084148$ | $-0.073634$ |
| $L_1(x)$ | $-0.072811$ | $-0.061008$ | $-0.052265$ | $-0.045736$ |

The decay is slow, exactly as the theorem's $o(1)$ permits. The reference script also
records $L_2(10^9) = -0.0654503824$ and $L_1(10^9) = -0.0406543156$. The reference run
fits the $1/\log x$ model with maximum relative residual $9.64\cdot10^{-4}$ ($h=2$) and
$3.39\cdot10^{-3}$ ($h=1$), concluding that the decay seen is the $1/\log x$
normalisation, not a power saving (check `S3.logarithmic.scale`). This is a consistency
check of a known result [3, 4], not a verification of it; check
`S3.unconditional.label` records exactly that caveat, and `C1.status` in the independent
check records that the theorem's hypothesis $a_1b_2 - a_2b_1 \ne 0$ covers both $h = 1$
and $h = 2$.

### 4.5 The finite-prefix construction, and the absent Euler product

With $X = 10^4$ and exact computation to $x = 10^7$
(`logs/chowla_two_point.log` §4):

* Prefix agreement: $\lambda$, $\lambda_+$ and $\lambda_-$ agree on every $n \le 10^4$
  (0 differences); the first index in $A_+$ or $A_-$ is $n = 10012$; and the correlation
  partial sums agree *exactly* for every $x \le 10^4$ (`S4.prefix.identical`,
  `S4.prefix.sums.identical`).
* The identity
  $S_\pm(x) - S(x) = \pm 4\,\#\{n \in A_\pm : n \le x\} \pm 2\varepsilon$,
  $\varepsilon \in \{0,1\}$, holds exactly at every $x \le 10^7$
  (`S4.identity.exact`).

| $x$ | $S(x)$ | $S_+(x)$ | $S_+(x)/x$ | $S_-(x)$ | $S_-(x)/x$ | $S_0(x)/x$ (control) |
|---|---|---|---|---|---|---|
| $10^4$ | $12$ | $12$ | $0.00120$ | $12$ | $0.00120$ | $0.001200$ |
| $10^5$ | $258$ | $22762$ | $0.22762$ | $-22394$ | $-0.22394$ | $0.001100$ |
| $10^6$ | $68$ | $247744$ | $0.24774$ | $-247536$ | $-0.24754$ | $0.000140$ |
| $10^7$ | $1246$ | $2500246$ | $0.25002$ | $-2496886$ | $-0.24969$ | $0.000211$ |

The positive witness has $S_+(10^7)/x = 0.25002$ (density of $A_+$ over $[1,x]$ is
$0.06248$, and $4 \times 0.06248 = 0.24990$ matches); the mirror witness gives
$-0.24969$. The naive control $A_0 = \{n > X : 4 \mid n\}$ gives $S_0(x)/x = 0.000211$ at
$x = 10^7$: flipping every multiple of 4 produces no linear bias here — an observation,
and a warning that the witness must be built from the data above $X$. The recorded
conclusion (`S4.logical.conclusion`) is that $(\star)$ is a statement about the tail, and
that the values certified in §4.2–§4.4 are all compatible both with $(\star)$ and with
its failure. The script adds, in the same block, that this does **not** show $(\star)$ is
false, because $\lambda_\pm$ are not the Liouville function (they are not even
completely multiplicative): the correct conclusion is epistemic.

The independent recomputation reaches the strongest recorded form: with $\lambda'' =
\lambda$ on $[1,10^8]$ and $1$ beyond, $\mathrm{corr}''(x) = \mathrm{corr}(x)$ for every
$x \le 10^8 - 2$ (verified over all $99\,999\,998$ prefixes by streaming: differing $= 0$,
max $\lvert$difference$\rvert = 0$), while $\mathrm{corr}''(10^8) = 4634$ versus
$\mathrm{corr}(10^8) = 4632$, and $\mathrm{corr}''(x) = \mathrm{corr}(10^8-2) + B +
(x - 10^8)$ with $B = \lambda(10^8-1) + \lambda(10^8) = +2$, so
$\mathrm{corr}''(x)/x \to 1$ (`A1`, `D1`–`D3`). The flip-set bound
$\lvert S_A(x) - S(x)\rvert \le 2\,\#\{n \le x+2 : n \in A\}$ is verified for
$A = \{n > X : n \equiv 0 \bmod 1000\}$ at every $x \le 10^8$ with maximum slack $0$
(`D4`), so a sparse flip set cannot produce a linear term.

On the Dirichlet-series side (`logs/chowla_two_point.log` §5): the non-multiplicativity
witnesses are $f(1) = \lambda(1)\lambda(3) = -1$ where multiplicativity would need
$f(1) = 1$, and the coprime counterexamples $f(2)f(11) = -1 \ne f(22) = 1$,
$f(2)f(13) = 1 \ne f(26) = -1$, $f(2)f(17) = -1 \ne f(34) = 1$
(`S5.not.multiplicative`). At $s = 2$ (absolute convergence, so both sides are defined):
$D(2) = \sum_{n \le 10^6} f(n)/n^2 = -1.12681304$ with tail bound
$2.00000000\cdot10^{-6}$, while $\prod_{p \le 10^5}(1 + \sum_k f(p^k)/p^{2k}) =
0.88759631$ with tail bound $1.80898647$; the difference $2.01440934$ exceeds the sum of
the truncation bounds $1.808988$, so the naive Euler product fails
(`S5.no.euler.product`). Absolute convergence for $\operatorname{Re} s \ge 1 + \delta$ is
trivial since $|f| \le 1$; divergence or convergence at $\operatorname{Re} s \le 1$ is
not unconditional, and with no Euler product there is no independent handle. The one
general implication that does hold is one-directional,
$D(s)$ convergent on $\operatorname{Re} s > \beta \Rightarrow S(x) = O(x^{\beta +
\varepsilon})$ by partial summation, so a proven $\beta \le 1/2$ would give $(\star)$;
nothing computes $\beta$, and the partial sums reported are recorded explicitly as a
finite diagnostic only (`S5.strip.diagnostic.only`).

### 4.6 The independent recomputation `independent_check.py`

* Command: `python3 independent_check.py`
* Recorded outcome: **25/26 checks pass**, wall clock **26.9 s**, sieve to $10^8$; by
  design the script **exits 1**, because its single failure is a recorded data
  correction rather than a mathematical disagreement (`README.md`,
  `logs/independent_check.log` final block: "FINAL: 25/26 checks pass (t=26.9s)").
* Its own $\lambda$ is built by three unrelated algorithms: a segmented
  Omega-by-trial-division sieve, an additive prime-power sieve ($\Omega = \sum_{p^k
  \mid n} 1$), and direct factorization. `LAM2` compares the first two on all of
  $[1, 10^8 + 2]$ — $100\,000\,001$ values, $0$ mismatches; `LAM3` compares pure-Python
  factorization at 23 integers including $10^7 - 2, \dots, 10^7 + 2$ and
  $10^8 - 3, \dots, 10^8 + 2$ — $0$ mismatches.
* **Not run here.**

**The one non-pass: `S2.crosscheck`, a recorded data correction.** An early
reconnaissance of the round printed $S(10^7) = 1244$; the independent recomputation's
three constructions of $\lambda$ together with a flat cumulative sum give

$$S(10^7) = 1246.$$

The difference of $+2$ was traced to a final-block boundary slip in the reconnaissance's
streaming scan; $1244$ equals $\sum_{n \le x-2}$ there, dropping the last two terms
$n = 10^7 - 1, 10^7$, whose products are both $+1$. The value $1246$ is used throughout,
and the discrepancy is reported as the one non-pass of the independent check
(`README.md`, "The one non-pass in the independent check"; `logs/independent_check.log`,
`S2.crosscheck`; `ROUND-NOTES.md`, §1.2).

### 4.7 The Lean development

* Files: `Rh46/Chowla.lean` (462 lines, 37 theorems/lemmas, 7 definitions, no `sorry`,
  `admit`, `axiom` or `native_decide`; imports `Mathlib` only) and the root module
  `Rh46.lean`.
* Command: `./check.sh --all` — the build script expects a Lean installation at
  `$LEAN_PREFIX` (default `$HOME/lean`): elan at `$LEAN_PREFIX/elan`, Mathlib4 at
  `$LEAN_PREFIX/mathlib4`. The toolchain is read from Mathlib's own `lean-toolchain`;
  the sources were checked against `leanprover/lean4:v4.35.0-rc2`. Equivalently, inside
  any Lean 4 project providing Mathlib: `lake env lean Rh46/Chowla.lean` and
  `lake env lean Rh46.lean`.
* Recorded outcome (`logs/lean_check.log`): `[check] OK Rh46/Chowla.lean (23s)` and
  `[check] OK Rh46.lean (9s)`, with four linter warnings (two unused variable bindings
  named `hn`, one unused binding named `n`, and a deprecation notice for `mul_le_one₀`).
  `README.md` states `./check.sh --all` exits `0`. The warnings are recorded here because
  the log carries them.
* **Not run here.** A Lean 4 + Mathlib installation is not part of this writing step.

### 4.8 Reproduction recipe (as the folder gives it)

```sh
# numerics: 30 checks, exit 0, wall clock ~4 min, sieve to 10^9
python3 chowla_two_point.py

# independent recomputation: 25/26 (see 4.6), ~30 s, sieve to 10^8
python3 independent_check.py

# Lean 4 + Mathlib
./check.sh --all
```

Each script tees its output to `logs/` and exits with status `0` if and only if every
one of its checks passes — so `independent_check.py` exits `1`, by design. The logs are
the record of the runs packaged with this edition:
`logs/chowla_two_point.log`, `logs/chowla_two_point.repro1.log` (bit-identical rerun),
`logs/independent_check.log`, `logs/lean_check.log`, `logs/exit_code.txt`.

## 5. What is not claimed

* **The two-point Chowla conjecture is open.** $(\star)$,
  $\sum_{n \le x}\lambda(n)\lambda(n+2) = o(x)$, is not asserted, proved, or numerically
  "verified" anywhere in this folder. The contribution of this edition is the
  demonstrable impossibility of deciding it from finite data.
* The exact perturbation identity of §3.6 is *recorded, not elaborated*; it is the single
  statement in `Rh46/Chowla.lean` that is not proved.
* The exponent $\alpha = 0.5200 \pm 0.0249$ (and the auditor's $0.4834 \pm 0.0186$) is a
  finite-range fit; no asymptotic claim is made from it, and the independent check records
  the RH-conditional reading as WITHDRAWN / unverified.
* The logarithmic average is quoted from the literature and only checked finitely; the
  numerics are not evidence about $(\star)$.
* The prefix-maximum values, the correlation table and the witness constructions are
  finite computations and are consistent with both $(\star)$ and its failure.
* The witness functions $\lambda''$, $\lambda_\pm$ are not multiplicative; they are
  arbitrary $\pm 1$ extensions of a prefix. Per `logs/independent_check.log` (`D3`), a
  completely multiplicative witness cannot be constructed this way, so the
  prefix-indeterminacy claim holds for arbitrary $\pm 1$ functions, which the folder
  records as the correct reading.
* The withdrawn claim is kept visible: an earlier draft of the round asserted an
  elementary conditional proof of $(\star)$ via the Dirichlet series
  $\sum \lambda(n)\lambda(n+2)n^{-s}$ and Perron's formula. That is wrong — the shifted
  product is not multiplicative — and the claim was withdrawn (`ROUND-NOTES.md` §1.5).
* In `ROUND-NOTES.md` §1.3 the one-point statement $\sum_{n \le x}\lambda(n) = o(x)$ is
  called "itself OPEN"; `README.md` does not repeat that characterisation, and this
  manuscript makes no claim about the one-point case beyond citing the parity problem
  [6]. Because the two sources disagree on this point, this manuscript records the
  disagreement instead of restating either reading; see `uncertainties` in the
  accompanying report.
* Development fragments are deliberately excluded: 67 transient Lean files
  (`Check1.lean` … `Check35.lean`, `Test1.lean` … `Test27.lean`, `Scratch.lean` …
  `Scratch5.lean`) from the round's working directory, several of them partial
  restatements and seven containing `sorry` or `admit`. `Rh46/Chowla.lean` is the
  complete, `sorry`-free development.

## 6. Value and significance

The folder closes a gap in how a finite verification of a correlation statement such as
$(\star)$ may be read. It proves, in Lean 4 / Mathlib, that no prefix of $\lambda$ — and
no prefix of correlation data — can distinguish $\lambda$ from functions with different
correlation asymptotics (Theorems 3.3 and 3.4), and it exhibits the strongest numerical
form of that gap on the computed range ($\lambda''$ agreeing with $\lambda$ on all of
$[1,10^8]$ with $\mathrm{corr}''(x)/x \to 1$). The dataset of §4.2 is therefore equally
consistent with $(\star)$ and with its failure, and the honest reading of any finite
table is an upper bound at the computed $x$ and nothing beyond.

It also records, with a proved witness, why the elementary Dirichlet-series/Perron route
is unavailable (Proposition 3.7), and it preserves the withdrawal of the earlier draft
that used that route, so the mistake is not re-proposed.

For the twin-prime programme this fixes the epistemic status of the object it cares
about: $\mathrm{corr}(2,N) = o(N)$ is a statement about the limit, needing global
structure — for instance Tao's entropy-decrement method, which reaches the
logarithmically averaged form checked here — and never more numerical values. A finite
check can refute it; it can never prove it.

## Sources

All paths are relative to this folder unless marked; SHAs are not recorded in the
sources, so none are given.

1. `README.md` — "publish/014-two-point-chowla — The finite-prefix indeterminacy
   theorem": the theorem statement, the edition claim that `014` is the fuller second
   edition of `publish/007-two-point-chowla`, the check counts (30/30, exit 0, ≈ 4 min;
   25/26), the status table, the recorded data correction $1244 \to 1246$, the Lean
   inventory (462 lines, 37 theorems/lemmas, 7 definitions), the references, and the
   provenance note that material is from round `rh46`. Local-only.
2. `finite-prefix-indeterminacy.html` — "The Finite-Prefix Indeterminacy Theorem for the
   Two-Point Liouville Correlation", second edition; the self-contained paper, read as
   content source (also via the mechanical HTML-to-Markdown scaffold prepared for this
   folder in the programme's work tree, outside this folder).
   Its title, edition line, subject class, abstract and keywords are used here. Local-only.
3. `ROUND-NOTES.md` — "Provenance notes — the two-point Chowla sum
   $\sum_{n \le x}\lambda(n)\lambda(n+2)$": §1.1–§1.5 (trivial bound, finite data, the
   unconditional theorems, the finite-prefix proof, and the §1.5 record of the withdrawn
   Dirichlet-series claim), §2, §3, §4 (reproduction commands), §5 (status table).
   Local-only.
4. `Rh46/Chowla.lean` — the Lean 4 / Mathlib development, namespace `Rh46`, 462 lines:
   definitions `Omega`, `liouville`, `corr`, `corrAsymptotic`, `shiftProd`,
   `liouvilleSlice`, `corrSlice`; theorems `corr_abs_le` (line 210), `corr_zero` (227),
   `corrAsymptotic_zero_false` (239), `shiftProd_two_five` (283),
   `shiftProd_not_completely_multiplicative` (298), `slice_self` (319),
   `slice_sub_self` (323), `slice_agree` (332), `slice_abs_le_one` (336), `slice_ne_self_iff` (344),
   `slice_ne` (357), `corrSlice_eq_corr_of_lt` (386), `corrSliceSqSub` (399),
   `corrSlice_ne_corr_self_statement` (440), `corrAsymptotic_reading` (455); and the
   documented-not-elaborated comment carrying the exact perturbation identity after
   `corrSliceSqSub`. Local-only. Line numbers from the copy in this folder.
5. `Rh46.lean` — root module (36 lines); importing it checks the whole development.
   Local-only.
6. `check.sh` — Lean build script (59 lines), `./check.sh --all`; `$LEAN_PREFIX` default
   `$HOME/lean`. Local-only.
7. `chowla_two_point.py` — reference implementation and self-check (1044 lines); the
   source of §4.1–§4.5 (log sections §0–§5, checks `S0.*`, `S1.*`, `S2.*`, `S3.*`,
   `S4.*`, `S5.*`).
8. `independent_check.py` — independent recomputation (675 lines); the source of §4.3
   (fit $0.4834 \pm 0.0186$, local exponents) and §4.5–§4.6 (checks `LAM1`–`LAM3`,
   `S0.flat`, `S1`, `S2.crosscheck`, `S3`, `B1`–`B4`, `L1.*`, `L2.*`, `L5.prec`,
   `C1.status`, `D1`–`D4`, `A1`–`A3`).
9. `logs/chowla_two_point.log` — the recorded reference run: 30 checks pass, 0 fail,
   wall clock 253.0 s; the correlation table, the fit $\alpha = 0.5200 \pm 0.0249$, the
   logarithmic averages, the finite-prefix construction, and the no-Euler-product
   evidence. Local-only.
10. `logs/chowla_two_point.repro1.log` — the bit-identical rerun: 30 checks pass, 0 fail,
    wall clock 264.1 s. Local-only.
11. `logs/independent_check.log` — the recorded independent run: 25/26 checks pass,
    $t = 26.9$ s; the `S2.crosscheck` failure and its diagnosis, the independent key
    numbers, and the `WITHDRAWN` note on the RH-conditional reading. Local-only.
12. `logs/exit_code.txt` — `EXIT_CODE=0 (final run, 30 checks pass, 0 fail, wall clock
    262.5s)`. Local-only.
13. `logs/lean_check.log` — `[check] OK Rh46/Chowla.lean (23s)`, `[check] OK Rh46.lean
    (9s)`, plus four linter warnings. Local-only.
14. `../007-two-point-chowla/README.md` — the sibling edition's "Note on editions",
    recording that `007` is the copy made by item number from the `truths.md` ledger and
    that `014` is the fuller package (self-contained paper, independent recomputation
    with its own $\lambda$, bit-identical rerun logs). Local-only; read only for the
    edition note.
15. Published work quoted above, as listed in `README.md` "References": S. Chowla, *The
    Riemann hypothesis and Hilbert's tenth problem*, Gordon and Breach, New York, 1965
    (the conjecture); P. Sarnak, *Three lectures on the Möbius function, randomness and
    dynamics*, IAS lecture notes, 2010; T. Tao, *The logarithmically averaged Chowla and
    Elliott conjectures for two-point correlations*, Forum of Mathematics, Pi **4**
    (2016), e8; K. Matomäki, M. Radziwiłł and T. Tao, *Sign patterns of the Liouville and
    Möbius functions*, Forum of Mathematics, Sigma **4** (2016), e14; K. Matomäki and
    M. Radziwiłł, *Multiplicative functions in short intervals*, Annals of Mathematics
    **183** (2016), 1015–1056; J. Friedlander and H. Iwaniec, *Opera de cribro*, AMS
    Colloquium Publications **57**, 2010 (the parity problem).
