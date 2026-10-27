# Two-Point Chowla and the Finite-Prefix Indeterminacy of the Liouville Correlation

**Seventh published edition, packaged from `research/truths.md` §7 (round `rh46`). Edition
note: this is the same theorem as `publish/014-two-point-chowla`, which is the fuller package
(a self-contained paper, an independent recomputation with its own $\lambda$, and
bit-identical rerun logs). `007` is the copy made by item number when the `truths.md` ledger
was packaged; this folder is self-contained too, but its verification layer is the round's
own. No priority is claimed for either edition. This folder does not prove the twin prime
conjecture, and it does not prove two-point Chowla.**

## Abstract

Let $\lambda(n)=(-1)^{\Omega(n)}$ be the Liouville function, $\Omega$ counted with
multiplicity, and let $\mathrm{corr}(h,N)=\sum_{n\le N}\lambda(n)\lambda(n+h)$. Two-point
Chowla is the assertion $\mathrm{corr}(2,N)=o(N)$; it is **OPEN**. This folder establishes
the exact status around it. PROVED in Lean: the trivial bound
$|\mathrm{corr}(h,N)|\le N$ for every $h,N$; its sharpness witness
$\mathrm{corr}(0,N)=N$ (so $o(N)$ is not a formal consequence of multiplicativity plus
boundedness, and $\mathrm{corrAsymptotic}\,0$ is false); the finite-prefix indeterminacy
theorem — flipping $\lambda$ at one index $a$ gives a function that agrees with $\lambda$ on
every prefix $N+h<a$, hence has identical correlation data, but differs from $\lambda$; the
$\ell^2$-mass of that perturbation is exactly $4$; the shifted product
$n\mapsto\lambda(n)\lambda(n+2)$ is **not** completely multiplicative, so its Dirichlet
series has no Euler product and the $\zeta$-based route does not apply. The prefix layer is
also VERIFIED numerically in its strongest form: a modification agreeing with $\lambda$ on
all of $[1,10^8]$ and equal to $1$ beyond satisfies $S''(x)=S(x)$ for every $x\le 10^8-2$
(0 of $99\,999\,998$ prefixes differ) while $S''(x)/x\to 1$. The round's numerics are a
finite check (30/30, sieve to $10^9$) and prove nothing about the limit; an independent
recomputation gives 25/26, the single non-pass being the recorded data correction
$S(10^7)=1244\to 1246$.

**Keywords.** Liouville function; Chowla conjecture; two-point correlation; finite-prefix
indeterminacy; non-multiplicativity; Lean 4; Mathlib; parity problem.

## 1. Introduction and goal

The question of the round is to establish

$$\sum_{n\le x}\lambda(n)\lambda(n+2)=o(x),\tag{$\star$}$$

the two-point Chowla correlation for the Liouville function. It **cannot** be established:
$(\star)$ is the two-point Chowla conjecture, a special case of the Chowla conjecture that
the $k$-point correlations of $\lambda$ vanish. No proof is known, unconditionally or even
conditionally on RH in the elementary Dirichlet-series sense, and this round does not produce
one. What the round does establish, rigorously and reproducibly, is the precise status of
$(\star)$, the exact bounds that *are* available, and — substantively — a proof that **no
pointwise or finite-prefix argument can ever establish it**.

The work matters to the programme for three reasons. It fixes the logical shape of the
obstruction: since the completely multiplicative $\lambda\equiv 1$ has correlation exactly
$N$, the input needed for $o(N)$ must be genuinely arithmetic, not a soft consequence of
multiplicativity and boundedness. It removes a wrong route from the record: the shifted
product is not multiplicative, so the Dirichlet series $\sum\lambda(n)\lambda(n+2)n^{-s}$ has
no Euler product and the standard $\zeta$-based analysis does not apply; an earlier draft of
the round asserted an elementary conditional proof that way, and the claim was withdrawn.
And it states plainly what the numerics can and cannot do: a finite computation can refute
$(\star)$ but can never prove it, and the round's own data are equally consistent with
$o(x)$ and with $\Theta(x)$.

Edition note, repeated from the head of this paper: this folder is the same theorem as
`publish/014-two-point-chowla`, the fuller package. `007` is the by-item-number copy; its
verification layer is the round's own, and no priority is claimed.

## 2. Setup and definitions

**The Liouville function.** $\Omega(n)$ is the number of prime factors of $n$ counted with
multiplicity, and

$$\lambda(n)=(-1)^{\Omega(n)} .$$

The Lean development defines `Omega n` as Mathlib's prime-factor count
`ArithmeticFunction.cardFactors` (`Omega_eq_cardFactors`), proves
$\Omega(n)=\sum_{p^k\parallel n}k$ for $n\ne 0$ via `Nat.factorization`
(`Omega_eq_factorization_sum`), and defines `liouville n = (-1)^(Omega n)` with the value
$\lambda(0)=1$; the only point where this differs from Mathlib's
`ArithmeticFunction.liouville` is $n=0$ (`liouville_eq_arithLiouville`), where Mathlib's value
is $0$.

**The correlation.** For $h,N\in\mathbb{N}$,

$$\mathrm{corr}(h,N)=\sum_{n=1}^{N}\lambda(n)\lambda(n+h),\qquad
S(x,h)=\sum_{n\le x}\lambda(n)\lambda(n+h),$$

with $S(x)=S(x,2)=\mathrm{corr}(2,\lfloor x\rfloor)$ the object of $(\star)$.

**The asymptotic form.** `corrAsymptotic h` is the proposition

$$\forall\varepsilon>0\ \exists X\ \forall N\ge X:\quad |\mathrm{corr}(h,N)|\le\varepsilon N ,$$

i.e. $\mathrm{corr}(h,N)=o(N)$. Two-point Chowla is `corrAsymptotic 2`.

**The sliced function.** For an index $a$,

$$\lambda^{(a)}(n)=\begin{cases}-\lambda(a),&n=a,\\ \lambda(n),&n\ne a,\end{cases}
\qquad\text{and}\qquad
\mathrm{corrSlice}(h,a,N)=\sum_{n=1}^{N}\lambda^{(a)}(n)\lambda^{(a)}(n+h).$$

**The shifted product.** `shiftProd h n = λ(n) λ(n+h)`, the summand of `corr h`; `shiftProd`
is what would need to be multiplicative for an Euler product.

**Status labels used below.** PROVED (Lean) means machine-checked from Mathlib alone with no
`sorry`, no extra `axiom` and no `native_decide`; VERIFIED means independently recomputed or
checked; RECORDED means the source states it without elaboration; OPEN means not proved. No
status is upgraded anywhere in this paper.

## 3. Results

### 3.1 The trivial bound

**Theorem 1 (trivial bound).** *For every $h,N\in\mathbb{N}$,*
$|\mathrm{corr}(h,N)|\le N$. **PROVED (Lean)**, `corr_abs_le`
(`Rh46/Chowla.lean#L210`).

*Proof (as carried by the source).* Each of the $N$ summands has absolute value $\le1$
because $|\lambda(n)|\le1$ for every $n$ (`liouville_abs_le_one`); summing
$N$ terms gives $|\mathrm{corr}(h,N)|\le N$. $\blacksquare$

**Theorem 2 (sharpness of the trivial bound).** *For every $N$,
$\mathrm{corr}(0,N)=N$.* **PROVED (Lean)**, `corr_zero` (`Rh46/Chowla.lean#L227`).

*Proof (as carried by the source).* $\mathrm{corr}(0,N)=\sum_{n\le N}\lambda(n)^2$, and
$\lambda(n)^2=1$ at *every* $n$ (`liouville_sq`), so the sum is $N$. $\blacksquare$

**Corollary 3.** *`corrAsymptotic 0` is false: for a completely multiplicative, bounded
$\pm1$-valued function the correlation is exactly $N$, so $o(N)$ is not a formal consequence
of multiplicativity plus boundedness.* **PROVED (Lean)**, `corrAsymptotic_zero_false`
(`Rh46/Chowla.lean#L239`). This is the only asymptotic statement proved in the development;
it shows `corrAsymptotic` is a genuine restriction.

### 3.2 The elementary facts about $\lambda$

**Theorem 4.** *(i) $\lambda(mn)=\lambda(m)\lambda(n)$ for $m,n\ne0$ (`liouville_mul`);
(ii) the zero case is genuinely false — at $n=2$ the would-be identity reads $1=-1$
(`liouville_mul_zero_false`); (iii) $\lambda(n)\in\{1,-1\}$ for $n\ne0$ (`liouville_mem`),
$\lambda(n)\ne0$ for $n\ne0$ (`liouville_ne_zero`), and $\lambda(n)^2=1$ for **every** $n$
including $0$ (`liouville_sq`); (iv) $|\lambda(n)|\le1$ for every $n$
(`liouville_abs_le_one`); (v) `ArithmeticFunction.liouville` agrees with $\lambda$ off zero
and is completely multiplicative (`arithLiouville_multiplicative`).* **PROVED (Lean)**.

### 3.3 The shifted product is not multiplicative

**Theorem 5 (non-multiplicativity witness).** *`shiftProd 2` is not completely
multiplicative.* **PROVED (Lean)**, `shiftProd_two_five` and its existential form
`shiftProd_not_completely_multiplicative` (`Rh46/Chowla.lean#L298`).

*Proof (as carried by the source).* Take $m=n=5$. On the left,
$\mathrm{shiftProd}\,2\,(5\cdot 5)=\lambda(25)\lambda(27)=1\cdot(-1)=-1$; on the right,
$\mathrm{shiftProd}\,2\,5\cdot\mathrm{shiftProd}\,2\,5=(\lambda(5)\lambda(7))^2=1$. Since
$-1\ne1$, `shiftProd 2` is not completely multiplicative. $\blacksquare$

**Consequence (RECORDED).** The Dirichlet series
$D(s)=\sum_{n\ge1}\lambda(n)\lambda(n+2)n^{-s}$ has no Euler product, so the standard
$\zeta$-based analysis does not apply to the Chowla sum; only the algebraic obstruction is
recorded, and nothing analytic is claimed. This is the round's **recorded correction**: an
earlier draft asserted an elementary conditional proof of $(\star)$ via $D$ and Perron's
formula. That is **wrong**, the claim was withdrawn, and it is recorded so that it is not
re-proposed. The numerics agree with the algebraic witness
(`logs/chowla_two_point.log`, S5): $f(1)=\lambda(1)\lambda(3)=-1$ although multiplicativity
would need $f(1)=1$, with coprime counterexamples $f(2)f(11)=-1\cdot1=-1\ne f(22)=1$,
$f(2)f(13)=1\ne f(26)=-1$, $f(2)f(17)=-1\ne f(34)=1$; and the naive Euler product differs
from $D(2)$ by $2.014409$, which exceeds the sum of the truncation bounds $1.808988$. In the
absolute region $\sigma=1.5$ the series does converge
($|\sum_{n\le10^8}f(n)n^{-1.5}|=1.191997\le\zeta(1.5)=2.612375$, rigorous since $|f|\le1$),
which the source labels a consistency check of a theorem; in the strip the source records the
observed partial sums as a **diagnostic only**, with no bound on the tail, so
$\beta\le\tfrac12$ remains **UNPROVEN**.

### 3.4 The finite-prefix indeterminacy theorem

**Theorem 6 (prefix agreement).** *For every $h,a,N$ with $N+h<a$,
$\mathrm{corrSlice}(h,a,N)=\mathrm{corr}(h,N)$.* **PROVED (Lean)**,
`corrSlice_eq_corr_of_lt` (`Rh46/Chowla.lean#L381`), with the pointwise input
`slice_agree` (`#L332`): the slice is indistinguishable from $\lambda$ below $a$
(`slice_agree {a n} (hn : n < a) : liouvilleSlice a n = liouville n`).
Consequently the values $\mathrm{corr}(h,1),\dots,\mathrm{corr}(h,N)$ carry no information
that could distinguish $\lambda$ from a function differing from it at a later index.

**Theorem 7 (the slice is different).** *For $a\ne0$, $\lambda^{(a)}\ne\lambda$*
(`slice_ne`), and the slice leaves the range of $\lambda$: $|\lambda^{(a)}(n)|\le1$
(`slice_abs_le_one`). The flipped value is $\lambda^{(a)}(a)=-\lambda(a)$ (`slice_self`), and
the slice differs from $\lambda$ exactly at $a$, by $-2\lambda(a)$ (`slice_sub_self`).
**PROVED (Lean)**.

**Theorem 8 ($\ell^2$-mass of the perturbation).** *For $1\le a\le N$,*
$\sum_{n\le N}\bigl(\lambda^{(a)}(n)-\lambda(n)\bigr)^2=4$. **PROVED (Lean)**,
`corrSliceSqSub` (`Rh46/Chowla.lean#L392`).

*Proof (as carried by the source).* `slice_sub_self` makes the difference
$-2\lambda(a)$ at $n=a$ and $0$ elsewhere on the prefix; one index contributes
$(\pm2)^2=4$, and the finite sum isolates $n=a$. $\blacksquare$

**Theorem 9 (the exact perturbation; RECORDED, not elaborated).** *Changing the value of
$\lambda$ at the single index $a$ changes $\mathrm{corr}(h,N)$ through exactly the two
summands containing $\lambda(a)$ — the summand at $n=a$ and the summand at $n=a-h$. At
$N=a$ both are present, so for $h\ge1$, $a\ge1$ (the $n=a-h$ term vanishing if $a-h<1$),*

$$\mathrm{corrSlice}(h,a,a)-\mathrm{corr}(h,a)
=-2\lambda(a)\lambda(a+h)-2\lambda(a-h)\lambda(a).$$

This is a **documented comment** in `Rh46/Chowla.lean` (lines ~407–419), recorded as a
statement rather than elaborated; the source flags it as the single statement in the
development that is not proved. Its two halves *are* proved: the prefix agreement
(Theorem 6) and the $\ell^2$-mass (Theorem 8). The companion Lean theorem
`corrSlice_ne_corr_self_statement` (`#L427`) proves the non-vanishing content that is used:
for $0<h$ and $1\le a$, $0<2\lambda(a)\lambda(a+h)$ or $2\lambda(a)\lambda(a+h)<0$, i.e.
the statistic is a nonzero sign. The Finset-level manipulation establishing the displayed
identity is what is missing.

**Theorem 10 (the logical reading).** *The truth of `corrAsymptotic h` is a statement about
the limit of $\mathrm{corr}(h,N)/N$ and cannot be decided from any initial segment of
values.* **PROVED (Lean)** as a packaged statement, `corrAsymptotic_reading`
(`Rh46/Chowla.lean#L451`): $\neg$`corrAsymptotic 0`, and for every $h,a,N$ with $N+h<a$ the
slice correlation agrees with the true one. The development proves no instance of
`corrAsymptotic h` for $h\ne0$; in particular **two-point Chowla is open and is not asserted
here**.

**Numerical verification in the strongest recorded form (VERIFIED).** The auditor's check A1
(`independent_check.py`) defines $\lambda''$ to agree with $\lambda$ on *all* of
$[1,10^8]$ and to equal $1$ beyond; then $S''(x)=S(x)$ **exactly for every $x\le10^8-2$**
(verified over all $99\,999\,998$ prefixes by streaming; differing prefixes $0$, maximum
difference $0$), while $S''(x)/x\to1$. So the entire computed dataset is equally consistent
with $S(x)=o(x)$ and with $S(x)=\Theta(x)$: a finite check can **refute** but never **prove**
the statement. Two further witnesses are recorded: with $X=10^4$ and $\lambda'$ equal to
$\lambda$ up to $X$ and $1$ beyond, $S'(x)=S(x)$ exactly for every $x\le X-2=9998$ and
$S'(x)=S(X-2)+B+(x-X)$ for $x\ge X$, with $B=\lambda(X-1)+\lambda(X)$, so $S'(x)/x\to1$
($S'(10^6)/10^6=0.25002$ against $S(10^6)/10^6=6.8\cdot10^{-5}$); and a *sparse* flip set of
density $\delta=1/1000$ satisfies the recorded bound
$|S_A(x)-S(x)|\le2\cdot\#\{n\le x+2:n\in A\}$ (verified at every $x\le10^8$, max slack
$\le0$), permitting at most a $2\delta x$ move — so a modification of **positive** density is
necessary to produce a linear term, and the witnesses above use density $\tfrac12$, the
minimal honest construction. The source also records that the witness is **not**
multiplicative (forcing $\lambda'(n)\lambda'(n+2)=+1$ beyond $X$ pins each parity chain), and
that this is the correct reading: prefix-indeterminacy holds for arbitrary $\pm1$
extensions.

**Record correction to one recorded refinement.** `ROUND-NOTES.md` §1.4 records the
sparse-modification bound $\le2\cdot\#\{n\le x+2:n\in A\}$; the record correction at the end
of `ROUND-NOTES.md` states that this bound as written is **false**, and that the correct
bound is $2\cdot\#\{n\le x:n\in A\text{ or }n+2\in A\}\le4\cdot\#\{m\le x+2:m\in A\}$
(witness $A=\{5\}$, $x=5$), the $o(x)$ conclusion being unaffected. Both readings are kept
visible here; the numerical check D4 in `independent_check.py` uses the as-run form with the
`x+2` count, which is the form the log reports.

### 3.5 What is known about $(\star)$: the averaged theorems

**Recorded (VERIFIED numerically, not proved here).** The state of the art is *averaged*.
**Logarithmic Chowla** (Tao 2015/2016; Matomäki–Radziwiłł–Tao): for fixed $h$,
$\frac{1}{\log x}\sum_{n\le x}\lambda(n)\lambda(n+h)/n=o(1)$ — a true theorem, which the
round checks finitely (`logs/chowla_two_point.log`, S3): $|L_2|$ decreases
$0.117631\ (x=10^5)\to0.084148\ (10^7)\to0.065450\ (10^9)$, with $L_2(x)\log x$ nearly
constant (the $1/\log x$ model fits to a relative residual $9.64\cdot10^{-4}$ for $h=2$ and
$3.39\cdot10^{-3}$ for $h=1$), and $|L_1|$ decreases $0.072811\to0.040654$ over the same
range. The source labels this a finite check of an unconditional theorem, **not** evidence
about $(\star)$. **Chowla for almost all shifts** (MRT; Tao's entropy-decrement method) is a
statement about $h$-averages, strictly weaker than the single $h=2$. The un-averaged
statement $\sum_{n\le x}\lambda(n)\lambda(n+h)/x=o(1)$ is the open one.

**Record correction.** `ROUND-NOTES.md` §1.3 states that one-point Chowla
$\sum_{n\le x}\lambda(n)=o(x)$ "is itself OPEN". The record correction at the end of
`ROUND-NOTES.md` states that this is **false**: it is **equivalent to the prime number
theorem**, hence a theorem, since $\lambda=1_{\text{squares}}*\mu$ and therefore
$\sum_{n\le x}\lambda(n)=\sum_{d\le\sqrt x}M(x/d^2)=o(x)$. Both statements are kept visible.

### 3.6 The finite data (`$(\star)$` is consistent with them; they prove nothing)

**MEASURED, finite.** The round's reconstruction of the correlation table
(`logs/chowla_two_point.log`, SS1; the archived run) is, with
$S(x)=\sum_{n\le x}\lambda(n)\lambda(n+2)$:

| $x$ | $10^3$ | $10^4$ | $10^5$ | $10^6$ | $10^7$ | $10^8$ | $10^9$ |
|---|---|---|---|---|---|---|---|
| $S(x)$ | $-30$ | $12$ | $258$ | $68$ | $1246$ | $4632$ | $43790$ |
| $S(x)/x$ | $-3.0\cdot10^{-2}$ | $1.2\cdot10^{-3}$ | $2.6\cdot10^{-3}$ | $6.8\cdot10^{-5}$ | $1.25\cdot10^{-4}$ | $4.6\cdot10^{-5}$ | $4.4\cdot10^{-5}$ |
| $\max_{x'\le x}|S|$ | $30$ | $73$ | $282$ | $689$ | $3059$ | $6454$ | $48700$ |
| $\max|S|/\sqrt x$ | $0.95$ | $0.73$ | $0.89$ | $0.69$ | $0.97$ | $0.65$ | $1.54$ |

(The $\max|S|$ row is the prefix maximum; the body of `logs/chowla_two_point.log` prints the
running and window maxima, e.g. $S(10^7)=1246$ with prefix maximum $3059$ at $x=8572105$.)
The round's numerics refit the prefix-maximum exponent as
$\alpha=0.5200\pm0.0249$ over six decades, with $\max|S|/\sqrt x$ drifting $0.645\to1.54$ —
the expected $x^{1/2+\varepsilon}$ upward drift. **$\alpha$ is a finite-range fit; no
asymptotic claim is made.** The auditor's independent fit over $x\le10^8$ gives
$0.4834\pm0.0186$, and local exponents range over $0.32$–$0.65$: **the exponent is not
resolved**. All of this is consistent with $x^{1/2+\varepsilon}$ and proves nothing; the
round records it as a finite-range description only. The sieve itself is checked
(SS0): the segmented $(-1)^{\Omega}$ equals an independent smallest-prime-factor recurrence
for every $n\le5000$ in blocks of 977, matches a direct trial division at sampled $n$ near
$10^6$, $1.23\cdot10^8$ and $9.99\cdot10^8$, and the segmented values agree with a single
flat $\lambda$ array plus one cumsum at $x=10^5,10^6,10^7$ (this is what detects a dropped
pair straddling a window boundary).

**Recorded data correction (`1244\to1246`).** The main agent's reconnaissance printed
$S(10^7)=1244$; the round's numerics and the auditor's three independent constructions of
$\lambda$ give **1246**. The auditor attributes the difference to a final-block boundary slip
in the reconnaissance's streaming scan: $\mathrm{recon}$'s $1244$ equals
$\sum_{n\le x-2}$ with the last two terms dropped (both products $+1$), and no single
convention reproduces the whole row. This is the round's one data correction, and it is the
single non-pass in the independent check (25/26).

## 4. Verification and evidence

### 4.1 Commands

From this folder (`research/publish/007-two-point-chowla`):

```sh
./check.sh --all                  # Lean 4 + Mathlib, 2 files, exits 0
python3 chowla_two_point.py       # the round's numerics: 30/30 checks, exit 0, sieve to 10^9
python3 independent_check.py      # the auditor's recomputation: 25/26, exit 1 by design
```

`chowla_two_point.py` tees its output to `verify/chowla_two_point.log` (the archived copy is
`logs/chowla_two_point.log`); `independent_check.py` writes `independent_check.log` next to
itself (the archived copy is `logs/independent_check.log`). Both scripts are self-contained
apart from NumPy/mpmath; `independent_check.py` states that it does not import, exec or re-run
`chowla_two_point.py` and implements three unrelated $\lambda$ algorithms
(`lam_segmented`, `lam_additive`, `lam_factorint`), comparing two of them on all of
$[1,10^8+2]$.

### 4.2 What was observed in this packaging run

* **`python3 chowla_two_point.py` — run in this packaging pass, exit 0, `30 checks pass,
  0 fail` (`wall clock 515.6s` on the packaging machine; the archived run records
  `262.5s`).** The computed values reproduce the archived log exactly:
  $S(10^7)=1246$, $S(10^8)=4632$, $S(10^9)=43790$; $\max|S|/\sqrt x$ at $x=10^8$ is
  $0.645400$; the fit is $\alpha=0.5200\pm0.0249$, $b=-0.4038$; the SS4 witness slopes are
  $+0.25002$ and $-0.24969$; the final status line is `STATUS OF (STAR): OPEN`. The run was
  executed from a copy of the script in a temporary directory so that the archived logs in
  this folder were not overwritten; the rerun's own log is
  `verify/chowla_two_point.log` in that temporary directory (not part of this folder). The
  archived `logs/chowla_two_point.log` is the record quoted in §3.6.
* **`python3 independent_check.py` — run in this packaging pass, exit 1 by design,
  `FINAL: 25/26 checks pass (t=99.0s)`** (the archived run records `32.5s`). The single
  non-pass is `S2.crosscheck`, the recorded data correction: the script computes
  $S(10^7)=1246$ (streamed; flat cumsum $1246$; two independent sieve algorithms) against
  the reconnaissance's $1244$, difference $+2$, with the diagnosis quoted in §3.6. The key
  independent numbers reproduce: $S(10^3..10^8)=-30,12,258,68,1246,4632$;
  $\max|S|$ for $x\le10^7$ is $3059$ at $x=8572105$ and for $x\le10^8$ is $6454$ at
  $x=66967578$; $\max|S|/\sqrt x$ at $x=10^8$ is $0.6454$; and the logarithmic averages at
  $x=10^5..10^8$ are $-0.117631,-0.098159,-0.084148,-0.073634$ for $h=2$ and
  $-0.072811,-0.061008,-0.052265,-0.045736$ for $h=1$ (float64 with a stated absolute error
  $<10^{-13}$). This rerun wrote its log to this folder's top level, not the archived
  `logs/` copy, so the archived log is untouched.
* **`./check.sh --all` (Lean)** — run in this packaging pass: both modules elaborate,
  `[check] OK Rh46/Chowla.lean (41s)`, `[check] OK Rh46.lean (57s)`, exit 0 (the archived
  `logs/lean_check.log` records `23s` and `9s` and exit 0 with four non-fatal linter
  warnings: unused `hn` at two sites, a deprecated `mul_le_one₀` at line 216, and an unused
  `n`; the packaging run emitted the same four warnings). The toolchain found on the packaging
  machine is Lean `v4.35.0-rc2` with the Mathlib checkout at `LEAN_PREFIX/mathlib4` (default `HOME/lean/mathlib4`), matching `check.sh`'s
  expectations. The generated `.olean` files were removed after the check.
* **Not run in this packaging pass:** nothing in this folder's check set was left unrun,
  except the Lean files were checked only through `check.sh --all` (i.e. `Rh46/Chowla.lean`
  and the root module) — which is exactly the deliverable. The archived
  `logs/chowla_two_point.repro1.log` is a second, earlier full run; it was read but not
  re-executed.

### 4.3 Evidence files

| evidence | content | status it supports |
|---|---|---|
| `Rh46/Chowla.lean` (462 lines, 37 `theorem` declarations, 7 `def`s, no `sorry`/`axiom`/`native_decide`) | the whole Lean layer | PROVED rows of §3.1–§3.4 |
| `Rh46.lean`, `check.sh` | root module and build script | `./check.sh --all` exit 0 |
| `chowla_two_point.py` (1044 lines) | sieve, correlation table, fit, logarithmic average, finite-prefix construction, no-Euler-product check | 30/30 checks, exit 0 |
| `logs/chowla_two_point.log` | the archived run, `30 checks pass, 0 fail (wall clock 262.5s)`, `(STAR)` status OPEN | MEASURED / VERIFIED rows |
| `logs/chowla_two_point.repro1.log` | the second full run (`264.1s`), same 30/30 | reproducibility |
| `independent_check.py` (675 lines) | the auditor's own $\lambda$ (three algorithms), own correlations, own prefix construction, 26 checks | 25/26, exit 1 by design |
| `logs/independent_check.log` | `FINAL: 25/26 checks pass (t=32.5s)`; the single FAIL is `S2.crosscheck` | VERIFIED rows, data correction |
| `logs/lean_check.log` | `[check] OK Rh46/Chowla.lean (23s)`, `[check] OK Rh46.lean (9s)` | PROVED rows |
| `logs/exit_code.txt` | `EXIT_CODE=0 (final run, 30 checks pass, 0 fail, wall clock 262.5s)` | exit status |

### 4.4 The status of each claim, in one line each

| claim | status |
|---|---|
| $\lvert\sum_{n\le x}\lambda(n)\lambda(n+2)\rvert\le x$; $\sum\lambda(n)\lambda(n)=x$ | **PROVED** (Lean: `corr_abs_le`, `corr_zero`) |
| the correlation of $\lambda\equiv1$ is $x$, so $o(x)$ is not formal | **PROVED** (Lean: `corrAsymptotic_zero_false`) |
| $n\mapsto\lambda(n)\lambda(n+2)$ is not multiplicative | **PROVED** (Lean: `shiftProd_not_completely_multiplicative`) |
| prefix agreement does not determine the correlation asymptotic | **PROVED** (Lean: `slice_agree`, `corrSlice_eq_corr_of_lt`) + **VERIFIED** numerically in the strongest form (check A1, $10^8$ prefixes) |
| the exact one-flip perturbation identity | **RECORDED** (comment in `Rh46/Chowla.lean`, not elaborated); its halves PROVED |
| $\sum_{n\le x}\lambda(n)\lambda(n+2)=o(x)$ | **OPEN** — not claimed, not proved, not provable by finite computation |
| the logarithmic average is $o(1)$ | known theorem (Tao 2015/2016; MRT); **VERIFIED** numerically here |
| one-point Chowla $\sum_{n\le x}\lambda(n)=o(x)$ | **equivalent to the prime number theorem (a theorem)** — record correction to the round note |
| $\alpha=0.5200\pm0.0249$ (prefix-maximum exponent) | **MEASURED** finite-range fit only; the two fits disagree ($0.4834\pm0.0186$ vs $0.5200\pm0.0249$) and the exponent is not resolved |
| $S(10^7)=1246$ (not $1244$) | **VERIFIED** by three independent $\lambda$ constructions; recorded data correction |

## 5. The Lean development and its one gap

`Rh46/Chowla.lean` is 462 lines with 37 `theorem` declarations and 7 `def` declarations,
built from Mathlib alone: no `sorry`, no project `axiom`, no `native_decide`. (The folder's
README gives the same 462 lines / 37 theorems / 7 definitions; `ROUND-NOTES.md` §4 states 38
theorems for the same file, a discrepancy of one against a direct count of the declarations —
see §8. The `TRUTHS.md` caveat that the source round's `lean/` directory also contains
unrelated `Check*.lean`, `Test*.lean`, `Scratch*.lean` files, a few of them with anonymous
`example`s containing `sorry`, is **not** a caveat for this folder: none of those files is
included here and none is imported by `Rh46.lean`.)

The single unelaborated statement is `corrSlice_sub_corr_self_eq` (Theorem 9), recorded as a
documented comment at `Rh46/Chowla.lean` lines ~407–419 and flagged in place and in
`Rh46.lean`'s header. Everything else in the development is proved. Mathlib supplies the
Liouville function and its arithmetic (`ArithmeticFunction.liouville`,
`cardFactors`), and the development proves the bridge and the range facts it needs.

## 6. What is not claimed

* **Two-point Chowla is not proved** and is not claimed: $(\star)$ is the two-point Chowla
  conjecture and is OPEN. Nothing in the development asserts `corrAsymptotic 2` or any
  `corrAsymptotic h` with $h\ne0$.
* **No finite computation proves $(\star)$.** The numerics are finite checks; they can
  refute and cannot prove, and the round's data are equally consistent with $o(x)$ and with
  $\Theta(x)$.
* **No twin prime result.** The folder proves nothing about the twin prime conjecture.
  `ROUND-NOTES.md` §3 records only that $\sum_{n\le x}\lambda(n)\lambda(n+2)=o(x)$ is
  *necessary* for a positive proportion of $n$ to have $\lambda(n)=\lambda(n+2)$; it is
  neither implied by nor implies the twin prime conjecture, and the parity obstruction of
  Selberg is exactly the statement that sieves cannot reach even the one-point case — this
  round adds no way around it.
* **No Euler product, no RH-conditional proof.** The shifted product is not multiplicative,
  so the Dirichlet-series route is unavailable; the earlier draft's conditional proof was
  withdrawn. The source also records that the numerics verify the logarithmic average only
  as a consistency check of a known theorem.
* **The exponent $\alpha$ is not resolved** and carries no asymptotic content; the two
  independent fits disagree and the local exponents range over $0.32$–$0.65$.
* **The perturbation identity (Theorem 9) is recorded, not proved**, and the source says so
  where it is stated.
* **Two corrections are kept visible**, as the brief requires: the data correction
  $S(10^7)=1244\to1246$, and the false claim that one-point Chowla is open (it is equivalent
  to PNT); plus the correction of the sparse-flip-set bound noted in §3.4.
* **Edition.** This folder is the same theorem as `publish/014-two-point-chowla`, the fuller
  package; `007` is the by-item-number copy with the round's own verification layer, and no
  priority is claimed for either.

## 7. Value and significance

The folder is worth recording because it settles what kind of statement $(\star)$ is. It
proves the exact logical barrier: finite prefix data cannot decide the asymptotic, in the
strongest recorded form (a function agreeing with $\lambda$ on all $10^8$ computed prefixes
while its correlation grows linearly), and it proves the algebraic reason the obvious
analytic route is closed (the shifted product is not multiplicative, so no Euler product).
It also proves the two facts that pin the conjecture down as arithmetic rather than formal:
the trivial bound $N$ and its attainment by a completely multiplicative $\pm1$-function. In
doing so it corrects two records — the withdrawn conditional proof, and the false
one-point-Chowla-open claim — and it quantifies exactly what the finite data can support: a
finite-range exponent fit that is consistent with $x^{1/2+\varepsilon}$ and proves nothing.
For the programme's twin-prime question, the item's value is negative but precise: it shows
that a lower bound for prime pairs cannot come from pointwise correlations of $\lambda$ along
a fixed shift, and it locates the parity obstruction at exactly that step.

## 8. Uncertainties and open items

1. **A theorem-count / line-count discrepancy.** The folder's README states "462 lines, 37
   theorems and lemmas, 7 definitions" for `Rh46/Chowla.lean`; `ROUND-NOTES.md` §4 states
   "456 lines, **38 theorems**, 7 definitions". A direct count of the file gives 462 lines, 37
   `theorem` declarations and 7 `def` declarations. This paper reports 462 lines and 37
   theorems and notes the disagreement (both the theorem count and the line count differ
   between sources); nothing depends on it.
2. **Two different logs for the same script.** `chowla_two_point.py` writes to
   `verify/chowla_two_point.log`; the archived copy is `logs/chowla_two_point.log`. The
   packaging rerun was therefore executed from a temporary copy so as not to overwrite the
   archived record; the archive still shows the path `../../../..` in its closing line, which
   is the round original.
3. **Wall-clock times differ between runs.** The archived round run is `262.5s` (and its
   repro `264.1s`); the packaging rerun of the same script took `515.6s`, and the auditor
   script took `99.0s` against an archived `32.5s`, on a machine running other work. The
   computed values, including every integer in §3.6 and the status line, reproduced exactly.
4. **The `A = {n > X, n ≡ 0 (mod 1000)}` bound in `independent_check.py`.** The script's D4
   check uses the as-run bound $2\cdot\#\{n\le x+2:n\in A\}$; the record correction at the end
   of `ROUND-NOTES.md` states that this bound (with the $x+2$ count) is false in general and
   gives the corrected form $2\cdot\#\{n\le x:n\in A\text{ or }n+2\in A\}$. Both are kept in
   §3.4; this paper did not adjudicate which form the D4 code's specific set satisfies, only
   that the log reports `max slack <= 0` for it.
5. **Literature attributions are taken from the folder.** Tao 2015/2016, Matomäki–Radziwiłł–
   Tao, Perron, Selberg and the Sarnak-conjecture remark occur only as the folder states
   them; no citation was verified against an external copy, and no return id, hash or date
   was invented.
6. **The exact perturbation identity is not machine-checked.** It is the one recorded
   statement in the Lean development, so the "different correlations from identical prefixes"
   conclusion rests on the *proved* prefix agreement plus the *proved* non-vanishing of
   $2\lambda(a)\lambda(a+h)$ and the recorded identity, not on a fully formal derivation of
   the discrepancy.
7. **No external independent check of the Lean build in this pass** beyond `check.sh --all`
   (exit 0) and the archived `logs/lean_check.log`; the four linter warnings in the archived
   log are non-fatal and were accepted.

## Sources

All paths are relative to this folder. SHA-256 hashes are given for the sources quoted or
tabulated; all of them are local to this folder (**local-only**).

| source | role here | SHA-256 |
|---|---|---|
| `README.md` (publish/007) | item description, edition note (same theorem as `publish/014`), contents, running the checks, recorded data correction | `5f95eca772f5fe0e6c7479184dde8cb7861d21d757a209644d89a57d70c2573b` |
| `TRUTHS.md` | the item ledger (`research/truths.md` §7), statuses and line locators | `3f45c98ea4bf424e18417d405c6dc4291bc357c7d4298c22a0724cf48549e964` |
| `ROUND-NOTES.md` | the round's write-up: question, answer, §1.1–1.5, §3 twin-prime consequence, §4 files, §5 claims, and the record corrections | `163e0e69990ff32d24bf46d607b9ae1f2d65c6bc1248f03b93b6193181d00ff5` |
| `Rh46/Chowla.lean` | the Lean layer; 462 lines, 37 theorems, 7 definitions; `#L210` `corr_abs_le`, `#L227` `corr_zero`, `#L239` `corrAsymptotic_zero_false`, `#L298` `shiftProd_not_completely_multiplicative`, `#L332` `slice_agree`, `#L381` `corrSlice_eq_corr_of_lt`, `#L392` `corrSliceSqSub`, `#L427` `corrSlice_ne_corr_self_statement`, comment ~`#L407–419` | `8813c2daaf13b20288430877fa42f6e6bfc99d384755885bdb2fad3a61be95c2` |
| `Rh46.lean`, `check.sh` | root module and build script | — |
| `chowla_two_point.py` | the numerics (1044 lines): sieve, table, fit, logarithmic average, finite-prefix construction, no-Euler-product check | `ed17a6437857991d76b245944794a1c1751958daa9f7ca4ff1e5f30fbb9963fb` |
| `independent_check.py` | the auditor's recomputation (675 lines), 26 checks | `a08655d28c4a3cad0545e75c4806aa895e7075b76e5ea2cc11442811406a78f6` |
| `logs/chowla_two_point.log` | archived run: `30 checks pass, 0 fail (wall clock 262.5s)`, SS0–SS5, `(STAR)` OPEN | `a359236e5ad80fc83bd9ba068a8cb47b65ec127f2059f65099cacfa7fd3ba4c5` |
| `logs/chowla_two_point.repro1.log` | second full run (`264.1s`), same 30/30 | `08531e23cfb7bc130646b135b178f4347561e67be64d421249c84beef299669e` |
| `logs/independent_check.log` | `FINAL: 25/26 checks pass (t=32.5s)`; the single FAIL `S2.crosscheck` | `926a1f36dde0f92bfab812a630e8ef18d6ad293eebebef6083e46c5abef615a3` |
| `logs/independent_check.py` | copy of the auditor's script as archived in `logs/` (identical role to `independent_check.py`) | — |
| `logs/lean_check.log` | `[check] OK Rh46/Chowla.lean (23s)`, `[check] OK Rh46.lean (9s)` | `d9c9e341b62c34a77996535a007e7282bb2f1fd8498d9496bba88b4515b5936d` |
| `logs/exit_code.txt` | `EXIT_CODE=0 (final run, 30 checks pass, 0 fail, wall clock 262.5s)` | `bbcf305c7fb86ddf09aa44f2e4ab2165dbbbf327b345e0b2b33743bb3de5cd73` |

External inputs named by the sources (not in this folder): Mathlib (Lean 4 `v4.35.0-rc2`
toolchain, `ArithmeticFunction.liouville`, `ArithmeticFunction.cardFactors`; NumPy 2.5.0 and
mpmath 1.3.0 for the Python layer, Python 3.13.13); and, as literature facts recorded by the
round, the logarithmic Chowla theorem of Tao (2015/2016) with the short-interval input of
Matomäki–Radziwiłł–Tao (2015/2016), Perron's formula (named in the withdrawn-draft
correction), Selberg's parity obstruction, and the Sarnak-conjecture remark. These are
attributed as the folder states them and were not independently verified.

**Cross-reference (different folder, read only for the edition note):**
`../014-two-point-chowla/` is the fuller package of the same theorem; it was not inspected
for this manuscript, and this paper makes no claim about its contents beyond what this
folder's README records.
