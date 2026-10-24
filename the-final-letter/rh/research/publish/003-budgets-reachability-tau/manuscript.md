# Budgets, reachability and the Tau alphabet

**First published edition, packaged from `research/truths.md` §3 (round `rh42`). This folder contains no HTML paper: the ledgers `TRUTHS.md` (the item, with its statuses and Lean pointers) and `ROUND-TRUTHS.md` (the round's prose ledger) are the source, and the Lean development under `Rh42/` (with `Rh41/DigitWord.lean` bundled as its dependency) plus the two Python scripts and the recorded logs are the evidence. This edition does not prove the twin prime conjecture.**

## Abstract

The programme's greedy construction spends a *budget*: which indices are taken is decided by the positive half-series $P(p)=\sum_{k\ge1}(2k)^{-p}$ and the negative half-series $N(p)=\sum_{k\ge1}(2k+1)^{-p}$ of the signed Tau alphabet $\alpha_n=(-1)^n/(n+2)^p$ at a signed target $x$. This paper records the round's results. The five budget closed forms ($P(2)=\pi^2/24$, $N(2)=\pi^2/8-1$, $P(4)=\pi^4/1440$, $N(4)=\pi^4/96-1$, $P(2)+N(2)=\pi^2/6-1$) and the budget algebra $P+N=\zeta-1$, $P-N=1-\eta$ are **PROVED in Lean**; the sign ledger's correction — the alphabet totals $1-\ln2=+0.30685\ldots$, not its negative — is **PROVED** with a rigorous rational enclosure. Reachability of a target is exactly the sub-sum problem: **Brown's criterion** $a_k\le T_{k+1}$ for every $k$ is **PROVED**, and the brief's single completeness condition is **REFUTED** in Lean. The **census** $S_1=\bigcup_{A}(\sum_{k\in A}a_k+[0,T_{n_{\min}}])$ with $\mathrm{measure}(S_1)=2^{n_{\min}-1}T_{n_{\min}}$ is **PROVED** and **VERIFIED**; the **Tau parity lock** — every take at a positive target sits at an even index, so all support gaps are even and $\ge2$ — is **PROVED in Lean**. Two open items, the $n_{\min}(p)$ asymptotic and the order of $\mathrm{measure}(S_1)/P(p)$, are recorded as resolved in external files not bundled here.

## 1. Introduction and goal

Round `rh41` (packaged as `publish/002-greedy-digit-word`) fixed the *unsigned* greedy word and its factor complexity. Round `rh42` — this folder — makes the construction **signed**: the alphabet alternates sign, the target is a signed height (the programme reads it as $x=\sin(2\pi\theta)$, a *helix* coordinate in turns), and a term is taken only when it has the sign of the residual and fits inside it. Two questions then control everything downstream:

1. **Budgets.** How much positive and how much negative mass does the alphabet carry at exponent $p$? Is there enough of each sign to write any given target?
2. **Reachability.** The budget is only an outer bound: a target inside the budget need not be writable, because the sub-sums of the half-series may fail to fill their interval. Which targets are writable — exactly?

The folder answers (1) in closed form and with a full budget algebra, answers (2) through Brown's criterion, an exact census of the reachable set and its measure, and an exact treatment of the low exponents $p=2,3$. It then proves the structural fact that shapes every signed word: the **parity lock**, which separates index parity and is the reason the budgets cannot be read as carrying $\Omega$-parity information (a reading tested and refuted in `publish/008-parity-barrier`). Finally it records what the signed rule does *not* see: the word is a function of the height $\sin(2\pi\theta)$ alone, never of the turn count.

In scope: the Tau alphabet and its rule, the two budgets and their algebra, Brown's criterion and the exact reachable set, the census and its measure, the thresholds $p_N<p_P<p^*<q$, the parity lock and the transfer of the rh41 complexity law to signed supports, and the helix statement. Out of scope: anything about twin primes; any Chowla-type statement; and the four open items, which are recorded as open or as resolved outside this folder.

## 2. Setup and definitions

**The signed (Tau) alphabet and rule.** Fix $p>0$ and let

$$\alpha_n=\frac{(-1)^n}{(n+2)^p},\qquad n=0,1,2,\dots;\qquad \alpha_0,\alpha_1,\alpha_2,\dots=+\tfrac12,-\tfrac13,+\tfrac14,-\tfrac15,\dots \quad (p=1).$$

The rule: with residual $r_0=x$, at step $n$ take $\alpha_n$ iff $\operatorname{sign}(\alpha_n)=\operatorname{sign}(r_n)$ and $|\alpha_n|\le|r_n|$, and then spend it, $r_{n+1}=r_n-\alpha_n$; otherwise skip it forever. A term is used at most once. The word is the indicator of the taken set, and the **support** is the set of taken indices; within a truncation $N$ it is a finite set $S=\{a_0<\dots<a_m\}$, to which the rh41 factor-complexity law of `publish/002-greedy-digit-word` applies verbatim, since that law is generic in the support.

**Budgets.** For $p>1$ define

$$P(p)=\sum_{k\ge1}(2k)^{-p}=2^{-p}\zeta(p),\qquad N(p)=\sum_{k\ge1}(2k+1)^{-p}=(1-2^{-p})\zeta(p)-1,$$

$$\eta(p)=\sum_{n\ge1}\frac{(-1)^{n-1}}{n^{p}}=(1-2^{1-p})\zeta(p)\ (p\ne1),\qquad \eta(1)=\ln2 .$$

$P$ is the *positive budget* and $N$ the *negative budget*; both are finite exactly for $p>1$, and both diverge at the pole $p=1$.

**Reachability.** Given a non-increasing positive sequence $a_1\ge a_2\ge\dots>0$ with $A=\sum_na_n<\infty$, let

$$T_n=\sum_{k\ge n}a_k,\qquad S=\Bigl\{\sum_{k\in A'}a_k:\ A'\subseteq\mathbb N\Bigr\}$$

(the sub-sums over **arbitrary** subsets, infinite ones included — exactly what a greedy that never stops taking terms produces). $S$ is the *reachable set*; the budgets are its outer bounds, $S\subseteq[0,A]$.

**Two coordinate conventions, kept apart.** The rh41 *bench* coordinate is $\theta_{\mathrm{bench}}=\pi x$; the *helix* coordinate is $\theta$ measured in **turns**, so the target is $\sin(2\pi\theta)$ and $450^\circ$ is not folded back to $90^\circ$. The digit word depends only on the height (§3.8), so the conventions only change which $\theta$ writes which number.

**Counting and thresholds.** $n_{\min}(p)$ is the first index whose tail is complete under Brown's criterion (equivalently the least $n$ with $h(n)\le0$, §3.3). $S_n$ is the sub-sum set of $a_n,a_{n+1},\dots$, and $S_1$ is the reachable set of the positive half. The four thresholds $p_N,p_P,p^*,q$ are defined in §3.6. Measure is Lebesgue measure on $\mathbb R$.

## 3. Results

Statuses follow `TRUTHS.md` and `ROUND-TRUTHS.md`: **PROVED (Lean)** = machine-checked in this folder's development; **PROVED (paper)** = a written argument in the ledger; **VERIFIED** = recomputed by a script in this folder by a route that does not merely re-run the source; **CHECKED** = exhaustive over a stated finite class; **REFUTED** = with the smallest witness found; **OPEN** = a target, not a result. The round's own theorem numbers (T1–T16 and Theorems 1–16) are kept.

### 3.1 The sign ledger — PROVED + rigorously enclosed

**Theorem 1 (sign; `ROUND-TRUTHS.md` §1).**

$$\sum_{n\ge0}\frac{(-1)^n}{(n+2)^p}\Big|_{p=1}=1-\ln2=+0.30685281944005469058\ldots$$

and the source pages' $\ln2-1=-0.30685281944005469058\ldots$ is its **negative**. Status: **PROVED (paper)** — with $m=n+2$, $\sum_{m\ge2}(-1)^m/m=-(\ln2-1)=1-\ln2$ — and **VERIFIED** with exact rational enclosures: $2\operatorname{artanh}(1/3)=2\sum_k(1/3)^{2k+1}/(2k+1)$ with a geometric tail bound brackets $\ln2$ in an interval of width $6.3\cdot10^{-41}$, giving $1-\ln2\in[0.3068528194400546\ldots,0.3068528194400547\ldots]$. The magnitude was always right; only the extraction of the alphabet's total had the sign flipped. $\eta(1)=\ln2$ and $\eta(p)=(1-2^{1-p})\zeta(p)$ are both correct and are used below.

**Refuted R1.** "The alphabet $(-1)^n/(n+2)$ totals $\ln2-1=-0.30685\ldots$" — it totals $1-\ln2=+0.30685\ldots$ (Theorem 1).

### 3.2 The budgets and their algebra — PROVED (paper and Lean) + VERIFIED

**Theorem 2 (T2, T3).** For every $p>1$,

$$P(p)+N(p)=\zeta(p)-1,\qquad P(p)-N(p)=1-\eta(p),\qquad P(p)=\frac{\zeta-\eta}{2},\qquad N(p)=\frac{\zeta+\eta-2}{2}.$$

Status: **PROVED (paper)** (split $\zeta(p)=\sum_{k\ge1}(2k)^{-p}+\sum_{k\ge0}(2k+1)^{-p}$ and subtract) and **VERIFIED to $1\cdot10^{-50}$** at $p=1.5,2,3,4$, and against direct even/odd partial sums truncated at 200 000 terms, in `helix_zeta.py` §1. The round's item table records the status as "PROVED (paper) + VERIFIED to 1e−50".

**Theorem 3 (T4, asymmetry).** $P(p)>N(p)$ for **every** $p>0$; the asymmetry is exactly $1-\eta(p)$, and $0<\eta(p)<1$ because the alternating series has strictly decreasing terms. Status: **PROVED (paper)**; **VERIFIED** at $p=1.01,1.5,2,3,5$ (`helix_zeta.py` §8). **Correction kept visible:** the round records that the asymmetry check's grid was *corrected 2025-10-06* — $p=8$ "was listed but never computed", so it was removed from the grid. *The positive side is always the cheaper one.*

**Theorem 4 (T5, H4; pole).** $P(p)\sim N(p)\sim\frac{1}{2(p-1)}$ as $p\downarrow1$: the pole of $\zeta$ appears **once on each side, halved**. Status: **PROVED (paper)** ($2^{-p}\to1/2$, $1-2^{-p}\to1/2$) and **VERIFIED**: $P(1.001)=499.942\ldots$, $N(1.001)=499.635\ldots$; and $P(p)(p-1)\to1/2$, recorded as $0.49999994$ at $p=1+10^{-6}$. Since both budgets are infinite at $p=1$, no target fails the budget test there — the page's reason that every sine is writable at $p=1$ (item T6, **VERIFIED**, unchanged).

**Theorem 5 (closed forms).**

$$P(2)=\frac{\pi^2}{24},\quad N(2)=\frac{\pi^2}{8}-1,\quad P(4)=\frac{\pi^4}{1440},\quad N(4)=\frac{\pi^4}{96}-1,\quad P(2)+N(2)=\frac{\pi^2}{6}-1.$$

Status: **PROVED in Lean** — `Rh42/Budget.lean` proves all of these from Mathlib's `hasSum_zeta_two` and `hasSum_zeta_four` by splitting the $\zeta$ series into its even and odd parts (`tsum_even_add_odd`, `Summable.comp_injective`), with no `sorry`. The declarations are `hasSum_even_zeta_two`, `hasSum_even_zeta_four`, `tsum_odd_zeta_two`, `tsum_odd_zeta_four`, `positiveBudget_two`, `negativeBudget_two`, `positiveBudget_four`, `negativeBudget_four`, `budget_two_sum`. Numerically verified to $1\cdot10^{-40}$.

The ledger's budget table, reproduced as recorded (`ROUND-TRUTHS.md` §2):

| $p$ | $\zeta(p)$ | $P(p)$ | $N(p)$ | $P+N$ |
|---|---|---|---|---|
| 1.1 | 10.584448 | 4.937820 | 4.646629 | 9.584448 |
| 1.25 | 4.595112 | 1.932007 | 1.663105 | 3.595112 |
| 1.5 | 2.612375 | 0.923614 | 0.688761 | 1.612375 |
| $p^*$ = 1.7286472390 | 2.000000 | **0.603469** | **0.396531** | **1.000000** |
| 2 | 1.644934 | 0.411234 | 0.233701 | 0.644934 |
| 3 | 1.202057 | 0.150257 | 0.051800 | 0.202057 |

### 3.3 The exact reachable set: Brown's criterion — PROVED (paper and Lean)

**Theorem 6 (Brown's criterion; T10/T13 core).** Let $a_1\ge a_2\ge\dots>0$ with $A=\sum a_n<\infty$, $T_n=\sum_{k\ge n}a_k$, and let $S$ be the set of sub-sums. Then

$$S=[0,A]\quad\Longleftrightarrow\quad a_n\le T_{n+1}\ \text{ for every }n .$$

Status: **PROVED (paper)**, with both one-step directions machine-checked in Lean. *Proof as carried by the ledger.*

*($\Longleftarrow$)* Run the greedy at $y\in[0,A]$; its residual $r_k$ decreases to $r\ge0$. If $r>0$, choose $m$ with $a_k<r$ for all $k\ge m$ (possible since $a_k\to0$); then $a_k<r\le r_k$, so every term from $m$ on is taken. Let $k_1$ be the largest skipped index below $m$ — one exists, since otherwise the taken sum would already be $A\ge y$ and $r\le0$. All indices above $k_1$ are taken, so $r_{k_1}=r+T_{k_1+1}>T_{k_1+1}$, while the skip at $k_1$ says $a_{k_1}>r_{k_1}$; hence $a_{k_1}>T_{k_1+1}$, contradicting the hypothesis.

*($\Longrightarrow$)* If $a_k>T_{k+1}$, any sub-sum $s<a_k$ avoids $a_k$ and all earlier indices (they are $\ge a_k$), so $s\le T_{k+1}$: the interval $(T_{k+1},a_k)$ is a gap. $\square$

In Lean: `Icc_subset_union_shift` (sufficiency step), `gap_of_subset_Icc` (necessity step), `Icc_union_Icc_shift` (the interval merge), and the finite sub-sum operator with its gap lemma `gap_lemma`.

**Correction to the handoff (kept visible).** The handoff's §5.5 attributes Brown's criterion in the form "*a non-increasing positive sequence whose first term is at most the sum of the rest is complete*". That single condition is **not sufficient** — Theorem 12 (REFUTED) below — and the correct statement needs **every** $n$, which is what makes the $p$-series work.

**Refuted R3.** "$a_1\le A-a_1$ implies the sub-sums fill $[0,A]$": the sequence $(1/2,\,2/5,\,1/20,\,1/20)$ has $a_1=A-a_1=1/2$ and misses $1/5$. **REFUTED**, smallest witness as stated, and machine-checked as `single_condition_not_sufficient` in `Rh42/Reachable.lean`.

**Theorem 7 (unimodality).** For the positive half put $h(n)=\sum_{k>n}k^{-p}-n^{-p}$. Then

$$h(n+1)-h(n)=n^{-p}-2(n+1)^{-p},$$

which is $>0$ iff $(1+1/n)^p<2$, i.e. iff $n$ is below the single value $1/(2^{1/p}-1)$; and $h(n)\to0^+$ with $h(n)\sim n^{-p}\bigl(n/(p-1)-1\bigr)>0$ for $n>p-1$. So $h$ rises then falls to $0$, and $\{n:h(n)<0\}=\{1,\dots,n_{\min}(p)-1\}$ is an **initial segment**, with $n_{\min}(p)$ the first complete tail. Status: **PROVED (paper)** (the difference formula and the $n\to\infty$ asymptotics are elementary; the sign change count is one), **VERIFIED** over nine exponents in `reachable.py` §1 — the recorded line is "`h(n+1)-h(n) = n^-p - 2(n+1)^-p` changes sign once, and $\{h<0\}$ is an initial segment, for every exponent tested [0 violations over 9 exponents]".

**Theorem 8 (completeness thresholds; T10, T13).** At $p>1$,

$$\text{positive half complete }(S=[0,P(p)])\iff n_{\min}(p)=1\iff\zeta(p)\ge2\iff p\le p^*,$$

$$\text{negative half complete }(S=[0,N(p)])\iff n_{\min}^{\mathrm{odd}}(p)=1\iff N(p)\ge2\cdot3^{-p}\iff p\le q,$$

with $p^*=1.7286472389981836181\ldots$ (the rh41 threshold, $\zeta(p^*)=2$ — an exact cross-reference, not a coincidence) and $q=2.07677517921069\ldots$. Status: **PROVED (paper)**: Theorem 7 makes the condition at $n=1$ the binding one, since $h$ is unimodal (increasing, then decreasing to $0^+$), so $\{n:h(n)<0\}$ is an initial segment — if $h(1)\ge0$ every condition holds, and if $h(1)<0$ the first already fails. **VERIFIED** in both directions at $p^*\pm10^{-9}$ and $q\pm10^{-6}$. **The rh41 threshold $p^*$ is exactly the exponent at which the signed sine set stops being an interval.**

**Corollary 9.** Every $x\in[0,P(p)]$ is writable for $p\le p^*$, and every $x\in[-N(p),0]$ for $p\le q$. Since $p^*\approx1.73<q\approx2.08$, the *negative* half stays complete longer: its first term is $3^{-p}$, not $2^{-p}$.

### 3.4 The census theorem — PROVED and VERIFIED

**Theorem 10 (census).** With $a_k=(2k)^{-p}$, $S_n$ the sub-sum set of $a_n,a_{n+1},\dots$ and $T_n=\sum_{k\ge n}a_k$,

$$S_n=[0,T_n]\quad\text{for every } n\ge n_{\min}(p),\qquad S_n=S_{n+1}\cup(a_n+S_{n+1})\ \text{ with the two pieces \textbf{disjoint} for } n<n_{\min}(p),$$

hence

$$S_1\ \text{is a union of exactly }2^{n_{\min}(p)-1}\text{ disjoint intervals},\qquad \mathrm{measure}(S_1)=2^{n_{\min}(p)-1}\cdot T_{n_{\min}(p)},$$

$$S_1=\bigcup_{A\subseteq\{1,\dots,n_{\min}-1\}}\Bigl(\sum_{k\in A}a_k+[0,T_{n_{\min}}]\Bigr).$$

Status: **PROVED (paper)**: Brown's criterion gives the complete tails; for $n<n_{\min}$ one has $h(n)<0$, i.e. $a_n>T_{n+1}=T_n-a_n$, so $S_{n+1}\subseteq[0,T_{n+1}]$ and $a_n+S_{n+1}\subseteq[a_n,T_n]$ cannot meet, and each level doubles the count; the finite form is machine-checked as `subSums_cons_disjoint`. **VERIFIED** in `reachable.py` §2 by two independent routes — the census formula and the plain recursion $S_k=S_{k+1}\cup(a_k+S_{k+1})$ — agreeing to $3.9\cdot10^{-62}$ on every endpoint, for thirteen exponents from $p=1.2$ to $p=12$.

The census table as recorded (`ROUND-TRUTHS.md` §4):

| $p$ | $P(p)$ | $n_{\min}$ | #intervals | measure | measure$/P$ |
|---|---|---|---|---|---|
| 1.2 … 1.7 | 2.434 … 0.632 | 1 | 1 | $P$ | **1.000** |
| 1.8 | 0.540529 | 2 | 2 | 0.506708 | 0.937430 |
| 2 | 0.411234 | 2 | 2 | 0.322467 | 0.784146 |
| 2.2 | 0.324398 | 2 | 2 | 0.213521 | 0.658207 |
| 2.5 | 0.237144 | 3 | 4 | 0.116468 | 0.491128 |
| 3 | 0.150257 | 3 | 4 | 0.0385285 | 0.256417 |
| 4 | 0.0676452 | 5 | 16 | 0.00357130 | 0.0527946 |
| 6 | 0.0158960 | 8 | 128 | $1.64918\cdot10^{-5}$ | 0.00103748 |
| 8 | 0.00392218 | 11 | 1 024 | $3.97707\cdot10^{-8}$ | $1.013996\cdot10^{-5}$ |
| 10 | 0.000977534 | 13 | 4 096 | $5.82549\cdot10^{-11}$ | $5.959375\cdot10^{-8}$ |
| 12 | 0.000244201 | 16 | 32 768 | $5.73073\cdot10^{-14}$ | $2.346729\cdot10^{-10}$ |

The negative half obeys the same census with its own $n_{\min}^{\mathrm{odd}}$ (recorded as 1, 1, 2, 2, 3, 4, 7 at $p=1.5,2,2.2,2.5,3,4,6$) and thresholds $q$. **The reachable fraction of the budget collapses to zero as $p\to\infty$**: at high exponent almost no sine is writable even though the budget is positive.

**Refuted R7.** "The reachable set has measure $P(p)$ for every $p$": false for every $p>p^*$; the measure is $2^{n_{\min}-1}T_{n_{\min}}$ (Theorem 10). **Refuted R8.** "The interval count grows like $2^{\#\{\text{gaps}\}}$ in any $p$-free way": the count is $2^{n_{\min}(p)-1}$, i.e. $1,2,4,16,128,1024,4096,32768$ at $p=1.5,2,2.5,4,6,8,10,12$.

**Theorem 11 (greedy optimality).** For these sequences the greedy's limit is exactly

$$s_G(x)=\max\{s\in S:\ s\le x\},$$

so the stall residual is $x-\max\{s\in S:s\le x\}$. Status: **PROVED (paper)**. At every index $n$ one of two cases holds: if $h(n)\le0$ then $T_{n+1}\le a_n$, so taking $a_n$ is optimal ($V_{n+1}(x)\le T_{n+1}\le a_n\le a_n+V_{n+1}(x-a_n)$); if $h(n)>0$ then by Theorem 7 every $h(j)$ with $j>n$ is positive, so the tail from $n+1$ is complete by Theorem 8 and taking $a_n$ is again optimal (`Icc_subset_union_shift`). The two cases cover every $n$, so descending induction from $n_{\min}$ proves optimality everywhere. $\square$

**Correction (REFUTED, kept visible).** Greedy optimality is *not* a general fact: on the decreasing sequence $(1/2,\,3/10,\,3/10)$ at $x=3/5$ the greedy takes $1/2$, while $3/10+3/10=3/5$ is the maximum sub-sum $\le x$. It is Theorem 7 that rescues the $p$-series. **VERIFIED** exactly, `reachable.py` §1; recorded as **R4** with that smallest witness.

### 3.5 The exact structure at $p=2$ and $p=3$ — VERIFIED exactly

**Theorem 12 ($p=2$).** At $p=2$,

$$S_2=\Bigl[0,\ \frac{\pi^2}{24}-\frac14\Bigr]\cup\Bigl[\frac14,\ \frac{\pi^2}{24}\Bigr],\qquad\text{the single gap being }(0.161233516712\ldots,\ 0.25).$$

Status: **PROVED (Theorem 10) + VERIFIED exactly**. $\pi^2$ is enclosed by exact rationals (Machin: $\pi=16\arctan(1/5)-4\arctan(1/239)$, width $5.6\cdot10^{-84}$), so reachability of a *rational* target is decidable in exact arithmetic. **VERIFIED**: ten rational targets decided exactly, including $1/5\to$ not reachable, $3/20\to$ reachable, $1/4\to$ reachable, $0.41\to$ reachable, $0.42\to$ not reachable. The unreachable rational $x=1/5$ stalls at $1/5-(\pi^2/24-1/4)=0.038766483287\ldots$; the exact `Fraction` run takes **every** even index $2,4,\dots,2K$ and nothing else, and the deficit from the stall value is the missing tail, rigorously in $(0,1/(4K))$.

**Theorem 13 ($p=3$).** At $p=3$, $n_{\min}=3$ and

$$S_3=[0,0.009632112895]\cup[0.015625,0.025257112895]\cup[0.125,0.134632112895]\cup[0.140625,0.150257112895].$$

Status: **PROVED (Theorem 10) + VERIFIED exactly**: $\zeta(3)$ is enclosed by exact rationals (Euler–Maclaurin, outward-rounded, width $3.1\cdot10^{-18}$) and seven rational targets land exactly where the intervals predict ($1/50$, $13/100$, $1/8$, $3/20$ reach $0$; $1/20$, $7/50$, $1/5$ stall at $x-0.024742887\ldots$, $x-0.005367887\ldots$, $x-0.049742887\ldots$).

**The first gap of each exponent.** At $p=2$ it is $(P-a_1,a_1)$; at $p=3$ the recursion runs twice, at $p=4$ four times (16 intervals), at $p=12$ fifteen times (32 768 intervals) — the census theorem's $2^{n_{\min}-1}$.

**Refuted R2 and R5.** "Inside the budget $\Longrightarrow$ writable": at $p=2$, $x=1/5$ is inside $P(2)=0.4112$, inside the sine range, and inside the gap $(0.16123,0.25)$. And "every rational target terminates" is **not** a signed statement at general $p$: it is a $p=1$ theorem, refuted at $p=2$ by the same $x=1/5$. **REFUTED**, witnesses as stated.

### 3.6 The four thresholds, rigorously enclosed — PROVED + VERIFIED by bisection

| name | equation | value | meaning |
|---|---|---|---|
| $p_N$ | $N(p)=1$ | $1.3777851698375411838\ldots$ | $\sin=-1$ becomes writable |
| $p_P$ | $P(p)=1$ | $1.4649845878051603837\ldots$ | $\sin=+1$ becomes writable |
| $p^*$ | $\zeta(p)=2$ | $1.7286472389981836181\ldots$ | the positive half becomes complete (rh41's threshold) |
| $q$ | $N(p)=2\cdot3^{-p}$ | $2.07677517921069\ldots$ | the negative half becomes complete |

**Ordering:** $p_N<p_P<p^*<q$. The whole sine range $[-1,1]$ is inside budget iff $p\le p_N$; for $p_N<p\le p_P$ only the positive sines are all in budget; beyond $p_P$ even $\sin=1$ is out of budget. At $p^*$ the budget interval is $[-0.3965305007,+0.6034694993]$ — length exactly $\zeta(p^*)-1=1$, the sine range's length — yet $\sin=\pm1$ is *not* writable at $p^*$ because the budget is split unevenly ($P(p^*)=0.6035<1$).

Status: **PROVED (paper)** (the equations and the ordering follow from Theorem 8 and the monotonicity of $\zeta$ on $(1,\infty)$, whose derivative $-\sum\log k\cdot k^{-p}$ is negative termwise), **VERIFIED** by rigorous bisection: $\zeta$ is enclosed at every dyadic test point by Euler–Maclaurin at order 1,

$$\sum_{k>N}k^{-p}=\frac{N^{1-p}}{p-1}-\frac{N^{-p}}{2}+\frac{pN^{-p-1}}{12}\pm\frac{p}{12}N^{-p-1},$$

with a conservative sign test, and the endpoints are re-certified with $N=4\cdot10^5$. The certified brackets (width $\le2.2\cdot10^{-12}$) all contain the published values:

```
p* ∈ [1.72864723899810998, 1.72864723899824641]
pP ∈ [1.46498458780406505, 1.46498458780624784]
pN ∈ [1.37778516983707959, 1.37778516983817098]
q  ∈ [2.07677517921067642, 2.07677517921071053]
```

**Item T15** (at $p^*$ the budget interval has length $1$) is **PROVED + VERIFIED**. **Item T14** (the three thresholds $p_N<p_P<p^*$) is **VERIFIED** rigorously, with $q$ added.

### 3.7 Parity lock and the transfer of the rh41 complexity law — PROVED (Lean) + VERIFIED

**Theorem 14 (parity lock; T9).** At a positive target the residual stays non-negative (it can hit $0$ exactly, when a term is taken with $\alpha=r$), and a term is taken only when the residual is *positive*; odd-index terms are negative, so the sign test rejects them at every positive residual. Hence

$$\text{every take of a positive target sits at an }\textbf{even}\text{ index},\qquad\text{every take of a negative target sits at an }\textbf{odd}\text{ index},$$

$$\text{so every gap of the signed support is }\textbf{even}\text{ and at least }2.$$

Status: **PROVED** by induction on the step, machine-checked in `Rh42/Tau.lean`: `tauStep_nonneg`, `tauStep_pos_of_lt`, `tauStep_nonpos`, `tauStep_neg`, `tauStep_eq_self_of_odd`, `take_parity`, `tauStep_eq_self_of_even`, `take_parity_neg`, `tauResidual_nonneg`, `tauResidual_nonpos`, `support_subset_even`, `support_subset_odd_of_neg`, `support_gap_even_and_two_le`, `support_gap_even`, and the `_of_neg` mirrors. **VERIFIED** for $p=1,2$ and four targets. The strict form "*the residual stays $>0$*" is **false** at the boundary ($x=1/2$, $p=1$: the first term is taken with equality and the residual becomes $0$), which is why the machine-checked statements are the non-strict ones; the parity conclusion is unaffected.

**Corollary 15 (T8).** For $x>0$ the signed rule *is* the classical Egyptian greedy on $\{k^{-p}\}$ at target $2^px$: the term $n=2(k-1)$ has value $2^{-p}k^{-p}$. Status: **PROVED + VERIFIED** at $p=1$ for $x=1/2,1/3,2/5,7/9$, matching support for support ($\{0\}\leftrightarrow\{1\}$, $\{2,10\}\leftrightarrow\{2,6\}$, $\{2,6,38\}\leftrightarrow\{2,4,20\}$, $\{0,2,34\}\leftrightarrow\{1,2,18\}$). So rh41's Theorem 8 (*every rational target terminates*) transfers to the positive half at $p=1$ and **only** there: at $p=2$ the rational $1/5$ is not writable.

**Statements about the signed word's factors.** Since the support of a signed word is just a finite set, rh41's proved law applies verbatim (its Lean `complexity_main` is generic in the support):

* **Plateau and decay (rh41's Theorem 1).** For $L\ge a_m+1$, $p(L)=\min(a_m+1,N-L+1)+[L\le N-a_m-1]$; **VERIFIED** on the signed supports $\{0,2,4,10\}$, $\{2,6,38\}$, $\{0,8\}$, $\{0,2,4\}$.
* **Corollary 4.** $\max_L p(L)=a_m+2$ once $N\ge2a_m+2$; **VERIFIED** on $\{0,2,4\}$ and $\{2,6,38\}$.
* **The C1 regime of a signed word (new, corrected).** C1 says $p(L)=L+1$ for $L\le\min(\min\text{gap},a_0,N-a_0-1)$. By Theorem 14 every gap of a signed word is even and $\ge2$, so the C1 range contains no gap obstruction beyond $\min$ gap, and it sits inside $L\le2$ exactly when the support has a gap of length $2$. The full range is $\min(\min\text{gap},a_0,N-a_0-1)$: for $\{4,8,12\}$, $N=20$ it is $L\le4$ and $p(1..4)=2,3,4,5$; for $\{2,6,38\}$, $N=22$ the min gap is $4$ but $a_0=2$, so the range is $L\le2$; and for $\{0,2,4,10\}$, $N=22$ the min gap is $2$ but $a_0=0$ **empties** the C1 range, even though $p(1)=2$ and $p(2)=3$ still hold by hand and $L=3$ already violates $L\le\min$ gap. **VERIFIED.** *(A previous formulation of this bullet claimed the C1 range is always $L\le2$; that is false — an even gap can be larger — and the corrected statement is the one above.)* In Lean, the structural half is `GapsAtLeast`, `two_le_of_even_pos`, `c1_range_le_two_of_gap_eq_two`, with the worked instance `complexity_c1_example` (support $\{2,4\}$, $N=10$, $p(2)=3$ via `Rh41.complexity_c1`).
* **The onset is still not determined by $(\text{gaps},N)$.** **CHECKED** over the parity-locked supports: **210 of 402** keys $(\text{gaps},N)$ are multi-valued. The parity constraint does not repair rh41's Theorem 6.

**Refuted R6, T16.** "The word sees the turns": the word factors through $\sin(2\pi\theta)$; the height-preserving reflection is $\theta\mapsto1/2-\theta$, **not** $\theta\mapsto1-\theta$ (which flips the sign).

### 3.8 The helix: the word sees the height, never the turn count — PROVED + VERIFIED

**Theorem 16 (T16).** The rule reads exactly one real number, the height $x=\sin(2\pi\theta)$. Hence the word is a function of $x$ alone:

$$\theta,\ \theta+1,\ \theta+2,\ \tfrac12-\theta\quad\text{give the }\textbf{same}\text{ word},\qquad 1-\theta\quad\text{gives the sign-flipped height, hence the other word},$$

and the lift $(\cos2\pi\theta,\sin2\pi\theta,\theta)$ is not periodic — the word simply cannot see it. Status: **PROVED (paper)** (the rule's input is the target; $\sin(2\pi(\theta+1))=\sin(2\pi\theta)$ and $\sin(2\pi(1/2-\theta))=\sin(2\pi\theta)$, while $\sin(2\pi(1-\theta))=-\sin(2\pi\theta)$), **VERIFIED** at 200 dps for $\theta=0.1,0.3,0.42,0.77$, comparing only the prefixes whose residuals stay above the $10^{-100}$ precision floor.

**Consequences.** (a) $\cos$ spends the same two budgets, and at $45^\circ$ ($\theta=1/8$) $\sin=\cos$, so the two words coincide; at $270^\circ$ $\sin=-1$, $\cos=0$ (the empty word). (b) No rule that reads a *periodic* function of $\theta$ — in particular not $\theta\bmod1$ — can see the turn count; to see it the rule must be fed a non-periodic function of $\theta$, which is the honest statement of the handoff's §5.7.

**Fixtures.** $\sin(\pi/4)=1/2+1/5+1/141+1/68575$ (tail $3.1\cdot10^{-11}$, support $\{0,3,139,68573\}$), $x=1\leftrightarrow\{0,1,4\}$, and the $p=2$ unreachable rational $1/5$ of Theorem 12 are the fixed test points; all three reproduce.

### 3.9 The four open items

Recorded with their statuses exactly as the ledger carries them; the two resolved items point to files **outside this folder**, which are not bundled here.

* **OPEN, non-monotone alphabets** in the inverse problem (rh41's §4 open item, untouched).
* **OPEN, non-monotone targets and a complex/phased residual** that *can* see the turn count: $\alpha_n=(-1)^ne^{2\pi i\theta}/(n+2)^p$ is the natural candidate, and whether it keeps a $\zeta$ budget is not known.
* **OPEN, no claimed identity** from the digit word's support to the $\zeta$-train observable (`../xi-horn/horn-helix.md`); no identity is claimed here.
* **RESOLVED outside this folder, with a corrected parenthetical.** The asymptotic of $n_{\min}(p)$ as $p\to\infty$: the handoff's guess "$n_{\min}\approx p+O(1)$" is **wrong** — the slope is $1/\ln2$, and $n_{\min}(p)=p/\ln2-3/2+O(1)$, with thresholds $P_n=(n+3/2)\ln2+c/n+O(1/n^2)$ and $c=3(\ln2)^2-(25/12)\ln2=-0.0026975844\ldots$; the error term is corrected from $O(1/p)$ (false: an integer index cannot beat the Diophantine gap), and $n=1$ reproduces this ledger's own $p^*$ to 18 digits. See `../../open/OP-05-nmin-asymptotic.md` and `op05_nmin.py`.
* **RESOLVED outside this folder.** The exact order of $\mathrm{measure}(S_1)/P(p)\to0$: composing the census law with the $n_{\min}(p)$ asymptotic,

$$-\log\frac{\mathrm{measure}(S_1)}{P(p)}=p\log p-(1+\ln\ln2)p-\frac{0.540509640658\ldots}{p}+O(1/p^2),$$

i.e. $\mathrm{measure}(S_1)/P(p)=p^{-p}e^{(1+\ln\ln2)p}(1+o(1))\to0$; the leading constant of $p\log p$ is $1$, the linear coefficient $-(1+\ln\ln2)=-0.6334870794\ldots$ is exact and matches the census data to 10 figures at $p=10^6$. See `../../open/OP-06-reachable-fraction.md` and `op06_reachable_fraction.py`.

## 4. Verification and evidence

Two layers: the Lean development (the proof layer) and the two Python scripts plus their recorded logs (the numerical and statement-shape layer). "**Observed**" below reports the actual output of a run performed while preparing this manuscript; "**recorded**" reports a log or figure that exists in the folder.

### 4.1 What each artefact checks

| artefact | checks | result |
|---|---|---|
| `Rh42/Budget.lean` | the five closed forms and the even/odd $\zeta(2),\zeta(4)$ splitting | PROVED (Lean) |
| `Rh42/Reachable.lean` | the two one-step lemmas of Brown's criterion, the interval merge, the finite sub-sum operator and `gap_lemma`, the greedy on a list, the machine-checked refutation `single_condition_not_sufficient` | PROVED (Lean) |
| `Rh42/Tau.lean` | the signed greedy on $\mathbb Q$: sign invariance, the parity lock, even gaps $\ge2$, the transfer to `Rh41.complexity_c1` | PROVED (Lean) |
| `Rh41/DigitWord.lean` | the imported rh41 factor-complexity law (bundled dependency) | PROVED (Lean) |
| `reachable.py` | Brown's criterion, unimodality, the census by two independent routes, exact $p=2$ and $p=3$ structure, greedy optimality, the four thresholds by rigorous bisection, the sign ledger, parity and the complexity transfer, the helix | 70/70 checks pass (recorded), exit 0 |
| `helix_zeta.py` | the budget algebra, the pole, the budget test, reuse of rh41's law, the theory page's 45-degree tail | 80/80 checks pass (recorded), exit 0 |
| `logs/reachable.log`, `logs/helix_zeta.log`, `logs/helix_zeta_rerun.log`, `logs/lean_check.log` | the recorded runs of the above | as filed |

### 4.2 Commands, and what was observed

```sh
./check.sh --all          # Lean 4 + Mathlib, 5 files, exits 0
python3 reachable.py      # 70/70 checks
python3 helix_zeta.py     # 80/80 checks
```

**Lean.** **Observed**: `./check.sh --all` elaborates the five files (the bundled `Rh41/DigitWord.lean` first, then the three `Rh42` modules, then the root), prints one `[check] OK <file>` line per file, and exits `0`; wall time about eleven minutes on a cold Mathlib import:

```
[check] OK   Rh41/DigitWord.lean (177s)
[check] OK   Rh42/Reachable.lean (174s)
[check] OK   Rh42/Budget.lean (119s)
[check] OK   Rh42/Tau.lean (97s)
[check] OK   Rh42.lean (72s)
exit=0
```

The recorded log `logs/lean_check.log` is the same four-line result for the `Rh42` modules alone (`Reachable 11s`, `Budget 5s`, `Tau 6s`, root `4s`, `exit=0`) with a warm Mathlib. The toolchain is `leanprover/lean4:v4.35.0-rc2` with elan at `$LEAN_PREFIX/elan` and Mathlib4 at `$LEAN_PREFIX/mathlib4` (`$LEAN_PREFIX` defaults to `$HOME/lean`); `check.sh` prepends this folder and `Rh41` so that `import Rh41.DigitWord` resolves. **Observed caveat**: a module invoked before its imports have `.olean` files exits `1` with `object file '...Rh41/DigitWord.olean' of module Rh41.DigitWord does not exist`; run `--all` (its list is the dependency order) or build the dependency first.

**`reachable.py` and `helix_zeta.py`.** **Observed**: both scripts run to completion and print a per-check PASS line with its measured detail, then the summary line `ALL 70 CHECKS PASS` / `ALL 80 CHECKS PASS`, and exit `0`. Wall time was about eighteen minutes for the 70-check script and about seven minutes for the 80-check script; the recorded logs reproduce the same checks and summaries (`logs/reachable.log`, `logs/helix_zeta_rerun.log`). Representative observed lines (70-check run):

```
PASS  BC   p = 2: no sub-sum of the first 16 positive terms lies in the gap (T_2, 1/4) = (0.16123..., 0.25)  (exact enumeration, 2^16 subsets)
PASS  CEN  the census formula and the plain interval recursion agree (two independent routes)   [max endpoint difference 3.89e-62]
PASS  P2   x = 1/5: the greedy takes exactly the even indices 2..2K and nothing else (exact Fractions)   [20000 takes, first [2, 4, 6, 8, 10]]
PASS  P3   reachable = [0,0.009632] u [0.015625,0.025257] u [0.125,0.134632] u [0.140625,0.150257]
PASS  THR  p*: rigorous sign change on [1.72864723899810998, 1.72864723899824641] (width 1.4e-13), published 1.7286472389981836181
PASS  SGN  ln 2 is enclosed by exact rationals from 2 artanh(1/3)   [width 6.264e-41]
PASS  SGN  sum_{n>=0} (-1)^n/(n+2) = 1 - ln 2 = +0.306852819440054... (the pages print ln 2 - 1, the wrong sign)
PASS  PAR  every gap of a signed support is even and >= 2   [gaps [[2, 2, 6], [4, 32], [8], [2, 2, 2, 14]]]
PASS  PAR  C1 on (4, 8, 12), N = 20: range L <= 4 and p(L) = L+1 there   [min gap 4, values [2, 3, 4, 5]]
PASS  PAR  signed support {0,2,4,10}, N = 22: a_0 = 0 empties the C1 range, yet p(1) = 2, p(2) = 3, and L = 3 already violates L <= min gap = 2
PASS  HEL  theta = 0.42: theta, theta+1, theta+2 and 1/2 - theta give the same word (200 dps, above the 1e-100 floor)
ALL 70 CHECKS PASS
```

and (80-check run):

```
PASS  H3  P + N = zeta(p) - 1  and  P - N = 1 - eta(p)  for every p tested   [max residuals 1.05e-81 / 1.32e-81]
PASS  H6  eta(1) = ln 2 (the alternating harmonic series)   [eta(1) = 0.693147180559945309]
PASS  R3  the positive half is complete exactly for p <= p*, where zeta(p*) = 2 (rh41's threshold)   [complete at p*-1e-6: True; complete at p*+1e-6: False]
PASS  R4  the negative half is complete exactly for p <= q, with q ~ 2.07 > p*   [q = 2.07677517921; p* = 1.728647239]
PASS  R5  the reachable set has measure zeta(p) - 1 before the gaps are removed (at p = 2: P + N = zeta(2) - 1)   [P+N = 0.644934066848]
ALL 80 CHECKS PASS
```

**Observed dependency gap (important for a reviewer).** Both Python scripts begin with `sys.path.insert(0, str(RH))` and then `from rh41.digitword import ...` — they expect the *programme* package `rh41` to be importable from the workspace root. That package is **not** in this folder and **not** in the workspace root, so the commands as published abort immediately with exit `1`:

```
Traceback (most recent call last):
  File ".../reachable.py", line 71, in <module>
    from rh41.digitword import p_offset  # noqa: E402
ModuleNotFoundError: No module named 'rh41'
```

(the same traceback appears at `helix_zeta.py` line 52). To reproduce the recorded 70/70 and 80/80, supply an `rh41` package whose `digitword.py` is the published rh41 ground-truth layer (identical to `../002-greedy-digit-word/digitword.py` except for one comment line that prints the programme's absolute workspace root). With such a package on `PYTHONPATH`, both scripts run to completion and their summaries are `ALL 70 CHECKS PASS` and `ALL 80 CHECKS PASS`, exit `0`, as quoted above and as recorded. The `rh41` import is used for the ground-truth definitions `p_offset`, `greedy_word_mpmath`, `word_from_ones`, `greedy_word_rational` — the shared object layer, not for any rh42-specific claim. This is the one respect in which the folder's README claim of self-containment does not hold for the Python layer; the Lean layer is self-contained as bundled.

**Not run for this folder.** `crosscheck.py` belongs to the sibling folder `publish/002-greedy-digit-word` (rh41's statement-shape check against the Python reference; it was run there while preparing that folder's manuscript, 1 969 905 cases, no violations). It is not part of this folder's evidence and was not invoked from here. No script in this folder checks the *Lean* statements independently of the kernel; that is `Rh42`'s own role. The four open/resolved items of §3.9 were not re-derived: their scripts (`op05_nmin.py`, `op06_reachable_fraction.py`) live outside this folder and were not inspected.

### 4.3 Trust boundary

`Rh42/` uses **no** `sorry`, **no** `admit`, **no** project-specific `axiom` and **no** `native_decide` (`LEAN-README.md` header). The numerical constants themselves — $p^*$, $p_P$, $p_N$, $q$, the $1-\ln2$ enclosure width $6.3\cdot10^{-41}$, the $1\cdot10^{-50}$ budget residuals — are not formalised; the scripts' exact-arithmetic enclosures are what certifies them, and the ledger says so.

## 5. What is not claimed

* **Not the twin prime conjecture**, and no un-averaged Chowla statement. Nothing here asserts either.
* **The parity lock is a statement about *index* parity.** It is explicitly **not** a bridge to $\Omega$-parity; that reading was tested and refuted, and the refutation lives in `publish/008-parity-barrier`.
* **Brown's criterion needs every $n$.** The brief's single condition $a_1\le A-a_1$ is false as a completeness criterion (R3, machine-checked). Nothing here claims that form.
* **Greedy optimality is not general.** It holds for the $p$-series because of the unimodality of $h$ (Theorem 7); on $(1/2,3/10,3/10)$ at $x=3/5$ it fails (R4).
* **"Inside the budget" is not "writable".** R2/R5: the budget is only an outer bound; the exact reachable set is the census's union of intervals.
* **Theorems 6 and 11 are PROVED (paper), with the Lean development contributing the one-step lemmas, the merge, the finite sub-sum operator and its gap lemma — not the full infinite statement.** The census's infinite form and greedy optimality are paper proofs plus exact verification; the machine-checked pieces are named in §4.1.
* **Corrected earlier statements, kept visible:** the sign of the alphabet total (R1); the "single condition" attribution (R3); the C1-range formulation for signed words ("always $L\le2$" is false); the asymmetry grid ($p=8$ was listed but never computed, corrected 2025-10-06); and the $n_{\min}$ parenthetical guess ($p+O(1)$ is wrong; the slope is $1/\ln2$). Each is stated next to the claim it corrects.
* **External resolutions are cited, not bundled.** `OP-05` and `OP-06` (and `op05_nmin.py`, `op06_reachable_fraction.py`, `../xi-horn/horn-helix.md`) are outside this folder; this manuscript reports the ledger's summary of them and does not certify them.

## 6. Value and significance

The round turns "which heights can the greedy write?" into exact arithmetic. The budget algebra is closed (five closed forms in Lean, plus $P+N=\zeta-1$ and $P-N=1-\eta$ verified to $1\cdot10^{-50}$), and reachability is settled by Brown's criterion with the brief's insufficient single condition refuted in Lean. The census then gives the exact shape of the reachable set: $2^{n_{\min}(p)-1}$ disjoint intervals, whose measure is $2^{n_{\min}-1}T_{n_{\min}}$ — so the reachable fraction of the budget falls to $0$ super-exponentially even though the budget stays positive, which is the quantitative statement that "having enough mass" and "being writable" are different conditions. The threshold structure $p_N<p_P<p^*<q$ ties the signed round back to rh41: $p^*$, the rh41 completeness threshold, is exactly where the signed sine set stops being an interval. The parity lock is the structural payoff: index parity is forced, gaps are even and $\ge2$, and the rh41 complexity law transfers to every signed word — while the same lock shows that the budgets cannot be read as parity information about $\Omega$, which is what `publish/008-parity-barrier` needed established. Finally, the sign correction and the corrected C1-range formulation remove two errors from the record, and the two resolved open items ($n_{\min}$'s slope $1/\ln2$, and the exact order of the vanishing reachable fraction) are the inputs later rounds build on.

## Sources

All paths are relative to this folder (`research/publish/003-budgets-reachability-tau`) unless marked `../` (sibling folder) or `../../` (outside the published set). Local-only sources are marked; no external publication is quoted and no hash is invented.

* `README.md` — *publish/003 — Budgets, reachability and the Tau alphabet* (local-only, packaged edition). Contents table, statuses, run instructions, dependencies (note: it states that `Rh41/DigitWord.lean` is byte-identical to the copy in `publish/002-greedy-digit-word`, which this manuscript verified by comparison), provenance.
* `TRUTHS.md` — *§3 Budgets, reachability and the Tau alphabet — `rh42`* (local-only; the item ledger, copied from `research/truths.md` §3 with links re-pointed). Lines 1–21: the result table with per-result status and Lean pointers, and the certification note.
* `ROUND-TRUTHS.md` — *042 — the signed (Tau) alphabet: proven results* (local-only; the round's prose ledger). §0 the object and the two readings; §1 the sign ledger and Theorem 1; §2 the budgets and Theorems 2–4; §3 Brown's criterion, Theorems 6–8 and Corollary 9; §4 the census and Theorem 11 with its refutation; §5 the exact $p=2,3$ structure; §6 the four thresholds; §7 the parity lock, Corollary 15 and the complexity transfer; §8 the helix; §9 the refuted list R1–R8; §10 the open items; §11 the handoff ledger T1–T17; §12 the reproduce block.
* `LEAN-README.md` — *`rh42/lean` — Lean 4 proofs for `rh42/truths.md`* (local-only). The module map and theorem-to-declaration tables for `Rh42/Budget.lean`, `Rh42/Reachable.lean`, `Rh42/Tau.lean`; the import note on `Rh41.DigitWord`; the no-`sorry`/no-`native_decide` statement.
* `Rh42/Budget.lean` — `hasSum_even_zeta_two` (l.42), `hasSum_even_zeta_four` (l.55), `tsum_odd_zeta_two` (l.88), `tsum_odd_zeta_four` (l.98), `positiveBudget_two` (l.122), `negativeBudget_two` (l.131), `positiveBudget_four` (l.140), `negativeBudget_four` (l.149), `budget_two_sum` (l.158).
* `Rh42/Reachable.lean` — `Icc_subset_union_shift` (l.38), `gap_of_subset_Icc` (l.52), `Icc_union_Icc_shift` (l.62), `subSums` and its lemmas (ll.78–155), `gap_lemma` (l.147), `single_condition_not_sufficient` (l.171), `subSums_cons_disjoint` (l.193), `greedySum` and its lemmas (ll.207–241), `greedy_step_optimal` (l.248).
* `Rh42/Tau.lean` — `tauTerm` (l.28), `tauStep` (l.33), `tauTake` (l.38), `tauTake_iff` (l.41), `tauTerm_pos_of_even` (l.60), `tauTerm_neg_of_odd` (l.66), `tauTerm_nonneg_iff_even` (l.98), `tauStep_nonneg` (l.117), `tauStep_pos_of_lt` (l.130), `tauStep_nonpos` (l.142), `tauStep_eq_self_of_odd` (l.169), `take_parity` (l.178), `tauStep_eq_self_of_even` (l.185), `take_parity_neg` (l.194), `tauResidual` (l.204), `tauTaken` (l.210), `support` (l.215), `tauResidual_nonneg` (l.239), `tauResidual_nonpos` (l.249), `support_subset_even` (l.260), `support_subset_odd_of_neg` (l.274), `support_gap_even_and_two_le` (l.289), `support_gap_even` (l.298), the `_of_neg` mirrors (ll.310–326), `GapsAtLeast` (l.336), `two_le_of_even_pos` (l.340), `c1_range_le_two_of_gap_eq_two` (l.347), `complexity_c1_example` (l.356).
* `Rh41/DigitWord.lean` — the bundled imported dependency: `factor` (l.29), `complexity` (l.33), `complexity_main` (l.119), `complexity_main_TRUTHS` (l.212), `complexity_c1` (l.347), `complexity_eq_bitComplexity` (l.515). Verified byte-identical to `../002-greedy-digit-word/Rh41/DigitWord.lean`.
* `Rh42.lean` — root module importing all three files (13 lines).
* `check.sh` — the Lean build script; `--all` order and the `$LEAN_PREFIX` convention (54 lines).
* `reachable.py` — the exact reachable-set theory: header statement of Brown's criterion, unimodality and the census (ll.1–56), the `rh41.digitword` import (ll.65–71), and the check groups §1–§8 (Brown's criterion, census, exact $p=2,3$, optimality, thresholds, the sign ledger, parity and the complexity transfer, the helix).
* `helix_zeta.py` — the budget/criterion investigation (unchanged, re-run): the `rh41.digitword` import (ll.50–52) and the check groups §1–§9 (budgets, the pole, the budget test, reuse of rh41's law, the 45-degree tail, the sign ledger).
* `logs/reachable.log` — the recorded 70/70 run (`ALL 70 CHECKS PASS`, `exit=0`); quoted in §4.2.
* `logs/helix_zeta.log` and `logs/helix_zeta_rerun.log` — the recorded 80/80 run (`ALL 80 CHECKS PASS`, `exit=0`); quoted in §4.2.
* `logs/lean_check.log` — the recorded Lean run: `Rh42/Reachable.lean (11s)`, `Rh42/Budget.lean (5s)`, `Rh42/Tau.lean (6s)`, `Rh42.lean (4s)`, `exit=0`; quoted in §4.2.
* `../002-greedy-digit-word/README.md` and `../002-greedy-digit-word/digitword.py` — the sibling edition and the rh41 ground-truth layer used to compare the bundled Lean copy and to identify the `rh41` import dependency (local-only, sibling folder).
* External, **not bundled**: `../../open/OP-05-nmin-asymptotic.md` with `op05_nmin.py`; `../../open/OP-06-reachable-fraction.md` with `op06_reachable_fraction.py`; `../xi-horn/horn-helix.md`; `publish/008-parity-barrier`. Cited only because the ledger cites them; their contents were not inspected for this manuscript.
