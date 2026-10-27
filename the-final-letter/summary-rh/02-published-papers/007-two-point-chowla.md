# 007 — Two-Point Chowla and the Finite-Prefix Theorem

| Field | Value |
|---|---|
| Source | [`research/publish/007-two-point-chowla/manuscript.md`](../../rh/research/publish/007-two-point-chowla/manuscript.md) |
| Status | Published; truths ledger §7. 014 is the fuller edition. |
| Harvested statements | 10 |

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

## Harvested theorem-like statements

### Theorem 1 (trivial bound).

*For every $h,N\in\mathbb{N}$,*
$|\mathrm{corr}(h,N)|\le N$. **PROVED (Lean)**, `corr_abs_le`
(`Rh46/Chowla.lean#L210`).

*Proof (as carried by the source).* Each of the $N$ summands has absolute value $\le1$
because $|\lambda(n)|\le1$ for every $n$ (`liouville_abs_le_one`); summing
$N$ terms gives $|\mathrm{corr}(h,N)|\le N$. $\blacksquare$

### Theorem 2 (sharpness of the trivial bound).

*For every $N$,
$\mathrm{corr}(0,N)=N$.* **PROVED (Lean)**, `corr_zero` (`Rh46/Chowla.lean#L227`).

*Proof (as carried by the source).* $\mathrm{corr}(0,N)=\sum_{n\le N}\lambda(n)^2$, and
$\lambda(n)^2=1$ at *every* $n$ (`liouville_sq`), so the sum is $N$. $\blacksquare$

### Corollary 3.

*`corrAsymptotic 0` is false: for a completely multiplicative, bounded
$\pm1$-valued function the correlation is exactly $N$, so $o(N)$ is not a formal consequence
of multiplicativity plus boundedness.* **PROVED (Lean)**, `corrAsymptotic_zero_false`
(`Rh46/Chowla.lean#L239`). This is the only asymptotic statement proved in the development;
it shows `corrAsymptotic` is a genuine restriction.

### Theorem 4.

*(i) $\lambda(mn)=\lambda(m)\lambda(n)$ for $m,n\ne0$ (`liouville_mul`);
(ii) the zero case is genuinely false — at $n=2$ the would-be identity reads $1=-1$
(`liouville_mul_zero_false`); (iii) $\lambda(n)\in\{1,-1\}$ for $n\ne0$ (`liouville_mem`),
$\lambda(n)\ne0$ for $n\ne0$ (`liouville_ne_zero`), and $\lambda(n)^2=1$ for **every** $n$
including $0$ (`liouville_sq`); (iv) $|\lambda(n)|\le1$ for every $n$
(`liouville_abs_le_one`); (v) `ArithmeticFunction.liouville` agrees with $\lambda$ off zero
and is completely multiplicative (`arithLiouville_multiplicative`).* **PROVED (Lean)**.

### Theorem 5 (non-multiplicativity witness).

*`shiftProd 2` is not completely
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

### Theorem 6 (prefix agreement).

*For every $h,a,N$ with $N+h<a$,
$\mathrm{corrSlice}(h,a,N)=\mathrm{corr}(h,N)$.* **PROVED (Lean)**,
`corrSlice_eq_corr_of_lt` (`Rh46/Chowla.lean#L381`), with the pointwise input
`slice_agree` (`#L332`): the slice is indistinguishable from $\lambda$ below $a$
(`slice_agree {a n} (hn : n < a) : liouvilleSlice a n = liouville n`).
Consequently the values $\mathrm{corr}(h,1),\dots,\mathrm{corr}(h,N)$ carry no information
that could distinguish $\lambda$ from a function differing from it at a later index.

### Theorem 7 (the slice is different).

*For $a\ne0$, $\lambda^{(a)}\ne\lambda$*
(`slice_ne`), and the slice leaves the range of $\lambda$: $|\lambda^{(a)}(n)|\le1$
(`slice_abs_le_one`). The flipped value is $\lambda^{(a)}(a)=-\lambda(a)$ (`slice_self`), and
the slice differs from $\lambda$ exactly at $a$, by $-2\lambda(a)$ (`slice_sub_self`).
**PROVED (Lean)**.

### Theorem 8 ($\ell^2$-mass of the perturbation).

*For $1\le a\le N$,*
$\sum_{n\le N}\bigl(\lambda^{(a)}(n)-\lambda(n)\bigr)^2=4$. **PROVED (Lean)**,
`corrSliceSqSub` (`Rh46/Chowla.lean#L392`).

*Proof (as carried by the source).* `slice_sub_self` makes the difference
$-2\lambda(a)$ at $n=a$ and $0$ elsewhere on the prefix; one index contributes
$(\pm2)^2=4$, and the finite sum isolates $n=a$. $\blacksquare$

### Theorem 9 (the exact perturbation; RECORDED, not elaborated).

*Changing the value of
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

### Theorem 10 (the logical reading).

*The truth of `corrAsymptotic h` is a statement about
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

## Source

[`manuscript.md`](../../rh/research/publish/007-two-point-chowla/manuscript.md) · [`README.md`](../../rh/research/publish/007-two-point-chowla/README.md)
