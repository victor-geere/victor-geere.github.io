# 003 — Budgets, Reachability and the Tau Alphabet

| Field | Value |
|---|---|
| Source | [`research/publish/003-budgets-reachability-tau/manuscript.md`](../rh/research/publish/003-budgets-reachability-tau/manuscript.md) |
| Status | Published; truths ledger §3. |
| Harvested statements | 17 |

## Abstract

The programme's greedy construction spends a *budget*: which indices are taken is decided by the positive half-series $P(p)=\sum_{k\ge1}(2k)^{-p}$ and the negative half-series $N(p)=\sum_{k\ge1}(2k+1)^{-p}$ of the signed Tau alphabet $\alpha_n=(-1)^n/(n+2)^p$ at a signed target $x$. This paper records the round's results. The five budget closed forms ($P(2)=\pi^2/24$, $N(2)=\pi^2/8-1$, $P(4)=\pi^4/1440$, $N(4)=\pi^4/96-1$, $P(2)+N(2)=\pi^2/6-1$) and the budget algebra $P+N=\zeta-1$, $P-N=1-\eta$ are **PROVED in Lean**; the sign ledger's correction — the alphabet totals $1-\ln2=+0.30685\ldots$, not its negative — is **PROVED** with a rigorous rational enclosure. Reachability of a target is exactly the sub-sum problem: **Brown's criterion** $a_k\le T_{k+1}$ for every $k$ is **PROVED**, and the brief's single completeness condition is **REFUTED** in Lean. The **census** $S_1=\bigcup_{A}(\sum_{k\in A}a_k+[0,T_{n_{\min}}])$ with $\mathrm{measure}(S_1)=2^{n_{\min}-1}T_{n_{\min}}$ is **PROVED** and **VERIFIED**; the **Tau parity lock** — every take at a positive target sits at an even index, so all support gaps are even and $\ge2$ — is **PROVED in Lean**. Two open items, the $n_{\min}(p)$ asymptotic and the order of $\mathrm{measure}(S_1)/P(p)$, are recorded as resolved in external files not bundled here.

## Harvested theorem-like statements

### Theorem 1 (sign; `ROUND-TRUTHS.md` §1).

$$\sum_{n\ge0}\frac{(-1)^n}{(n+2)^p}\Big|_{p=1}=1-\ln2=+0.30685281944005469058\ldots$$

and the source pages' $\ln2-1=-0.30685281944005469058\ldots$ is its **negative**. Status: **PROVED (paper)** — with $m=n+2$, $\sum_{m\ge2}(-1)^m/m=-(\ln2-1)=1-\ln2$ — and **VERIFIED** with exact rational enclosures: $2\operatorname{artanh}(1/3)=2\sum_k(1/3)^{2k+1}/(2k+1)$ with a geometric tail bound brackets $\ln2$ in an interval of width $6.3\cdot10^{-41}$, giving $1-\ln2\in[0.3068528194400546\ldots,0.3068528194400547\ldots]$. The magnitude was always right; only the extraction of the alphabet's total had the sign flipped. $\eta(1)=\ln2$ and $\eta(p)=(1-2^{1-p})\zeta(p)$ are both correct and are used below.

### Refuted R1.

"The alphabet $(-1)^n/(n+2)$ totals $\ln2-1=-0.30685\ldots$" — it totals $1-\ln2=+0.30685\ldots$ (Theorem 1).

### Theorem 2 (T2, T3).

For every $p>1$,

$$P(p)+N(p)=\zeta(p)-1,\qquad P(p)-N(p)=1-\eta(p),\qquad P(p)=\frac{\zeta-\eta}{2},\qquad N(p)=\frac{\zeta+\eta-2}{2}.$$

Status: **PROVED (paper)** (split $\zeta(p)=\sum_{k\ge1}(2k)^{-p}+\sum_{k\ge0}(2k+1)^{-p}$ and subtract) and **VERIFIED to $1\cdot10^{-50}$** at $p=1.5,2,3,4$, and against direct even/odd partial sums truncated at 200 000 terms, in `helix_zeta.py` §1. The round's item table records the status as "PROVED (paper) + VERIFIED to 1e−50".

### Theorem 3 (T4, asymmetry).

$P(p)>N(p)$ for **every** $p>0$; the asymmetry is exactly $1-\eta(p)$, and $0<\eta(p)<1$ because the alternating series has strictly decreasing terms. Status: **PROVED (paper)**; **VERIFIED** at $p=1.01,1.5,2,3,5$ (`helix_zeta.py` §8). **Correction kept visible:** the round records that the asymmetry check's grid was *corrected 2025-10-06* — $p=8$ "was listed but never computed", so it was removed from the grid. *The positive side is always the cheaper one.*

### Theorem 4 (T5, H4; pole).

$P(p)\sim N(p)\sim\frac{1}{2(p-1)}$ as $p\downarrow1$: the pole of $\zeta$ appears **once on each side, halved**. Status: **PROVED (paper)** ($2^{-p}\to1/2$, $1-2^{-p}\to1/2$) and **VERIFIED**: $P(1.001)=499.942\ldots$, $N(1.001)=499.635\ldots$; and $P(p)(p-1)\to1/2$, recorded as $0.49999994$ at $p=1+10^{-6}$. Since both budgets are infinite at $p=1$, no target fails the budget test there — the page's reason that every sine is writable at $p=1$ (item T6, **VERIFIED**, unchanged).

### Theorem 5 (closed forms).

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

### Theorem 6 (Brown's criterion; T10/T13 core).

Let $a_1\ge a_2\ge\dots>0$ with $A=\sum a_n<\infty$, $T_n=\sum_{k\ge n}a_k$, and let $S$ be the set of sub-sums. Then

$$S=[0,A]\quad\Longleftrightarrow\quad a_n\le T_{n+1}\ \text{ for every }n .$$

Status: **PROVED (paper)**, with both one-step directions machine-checked in Lean. *Proof as carried by the ledger.*

*($\Longleftarrow$)* Run the greedy at $y\in[0,A]$; its residual $r_k$ decreases to $r\ge0$. If $r>0$, choose $m$ with $a_k<r$ for all $k\ge m$ (possible since $a_k\to0$); then $a_k<r\le r_k$, so every term from $m$ on is taken. Let $k_1$ be the largest skipped index below $m$ — one exists, since otherwise the taken sum would already be $A\ge y$ and $r\le0$. All indices above $k_1$ are taken, so $r_{k_1}=r+T_{k_1+1}>T_{k_1+1}$, while the skip at $k_1$ says $a_{k_1}>r_{k_1}$; hence $a_{k_1}>T_{k_1+1}$, contradicting the hypothesis.

*($\Longrightarrow$)* If $a_k>T_{k+1}$, any sub-sum $s<a_k$ avoids $a_k$ and all earlier indices (they are $\ge a_k$), so $s\le T_{k+1}$: the interval $(T_{k+1},a_k)$ is a gap. $\square$

In Lean: `Icc_subset_union_shift` (sufficiency step), `gap_of_subset_Icc` (necessity step), `Icc_union_Icc_shift` (the interval merge), and the finite sub-sum operator with its gap lemma `gap_lemma`.

**Correction to the handoff (kept visible).** The handoff's §5.5 attributes Brown's criterion in the form "*a non-increasing positive sequence whose first term is at most the sum of the rest is complete*". That single condition is **not sufficient** — Theorem 12 (REFUTED) below — and the correct statement needs **every** $n$, which is what makes the $p$-series work.

**Refuted R3.** "$a_1\le A-a_1$ implies the sub-sums fill $[0,A]$": the sequence $(1/2,\,2/5,\,1/20,\,1/20)$ has $a_1=A-a_1=1/2$ and misses $1/5$. **REFUTED**, smallest witness as stated, and machine-checked as `single_condition_not_sufficient` in `Rh42/Reachable.lean`.

### Theorem 7 (unimodality).

For the positive half put $h(n)=\sum_{k>n}k^{-p}-n^{-p}$. Then

$$h(n+1)-h(n)=n^{-p}-2(n+1)^{-p},$$

which is $>0$ iff $(1+1/n)^p<2$, i.e. iff $n$ is below the single value $1/(2^{1/p}-1)$; and $h(n)\to0^+$ with $h(n)\sim n^{-p}\bigl(n/(p-1)-1\bigr)>0$ for $n>p-1$. So $h$ rises then falls to $0$, and $\{n:h(n)<0\}=\{1,\dots,n_{\min}(p)-1\}$ is an **initial segment**, with $n_{\min}(p)$ the first complete tail. Status: **PROVED (paper)** (the difference formula and the $n\to\infty$ asymptotics are elementary; the sign change count is one), **VERIFIED** over nine exponents in `reachable.py` §1 — the recorded line is "`h(n+1)-h(n) = n^-p - 2(n+1)^-p` changes sign once, and $\{h<0\}$ is an initial segment, for every exponent tested [0 violations over 9 exponents]".

### Theorem 8 (completeness thresholds; T10, T13).

At $p>1$,

$$\text{positive half complete }(S=[0,P(p)])\iff n_{\min}(p)=1\iff\zeta(p)\ge2\iff p\le p^*,$$

$$\text{negative half complete }(S=[0,N(p)])\iff n_{\min}^{\mathrm{odd}}(p)=1\iff N(p)\ge2\cdot3^{-p}\iff p\le q,$$

with $p^*=1.7286472389981836181\ldots$ (the rh41 threshold, $\zeta(p^*)=2$ — an exact cross-reference, not a coincidence) and $q=2.07677517921069\ldots$. Status: **PROVED (paper)**: Theorem 7 makes the condition at $n=1$ the binding one, since $h$ is unimodal (increasing, then decreasing to $0^+$), so $\{n:h(n)<0\}$ is an initial segment — if $h(1)\ge0$ every condition holds, and if $h(1)<0$ the first already fails. **VERIFIED** in both directions at $p^*\pm10^{-9}$ and $q\pm10^{-6}$. **The rh41 threshold $p^*$ is exactly the exponent at which the signed sine set stops being an interval.**

### Corollary 9.

Every $x\in[0,P(p)]$ is writable for $p\le p^*$, and every $x\in[-N(p),0]$ for $p\le q$. Since $p^*\approx1.73<q\approx2.08$, the *negative* half stays complete longer: its first term is $3^{-p}$, not $2^{-p}$.

### Theorem 10 (census).

With $a_k=(2k)^{-p}$, $S_n$ the sub-sum set of $a_n,a_{n+1},\dots$ and $T_n=\sum_{k\ge n}a_k$,

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

### Theorem 11 (greedy optimality).

For these sequences the greedy's limit is exactly

$$s_G(x)=\max\{s\in S:\ s\le x\},$$

so the stall residual is $x-\max\{s\in S:s\le x\}$. Status: **PROVED (paper)**. At every index $n$ one of two cases holds: if $h(n)\le0$ then $T_{n+1}\le a_n$, so taking $a_n$ is optimal ($V_{n+1}(x)\le T_{n+1}\le a_n\le a_n+V_{n+1}(x-a_n)$); if $h(n)>0$ then by Theorem 7 every $h(j)$ with $j>n$ is positive, so the tail from $n+1$ is complete by Theorem 8 and taking $a_n$ is again optimal (`Icc_subset_union_shift`). The two cases cover every $n$, so descending induction from $n_{\min}$ proves optimality everywhere. $\square$

**Correction (REFUTED, kept visible).** Greedy optimality is *not* a general fact: on the decreasing sequence $(1/2,\,3/10,\,3/10)$ at $x=3/5$ the greedy takes $1/2$, while $3/10+3/10=3/5$ is the maximum sub-sum $\le x$. It is Theorem 7 that rescues the $p$-series. **VERIFIED** exactly, `reachable.py` §1; recorded as **R4** with that smallest witness.

### Theorem 12 ($p=2$).

At $p=2$,

$$S_2=\Bigl[0,\ \frac{\pi^2}{24}-\frac14\Bigr]\cup\Bigl[\frac14,\ \frac{\pi^2}{24}\Bigr],\qquad\text{the single gap being }(0.161233516712\ldots,\ 0.25).$$

Status: **PROVED (Theorem 10) + VERIFIED exactly**. $\pi^2$ is enclosed by exact rationals (Machin: $\pi=16\arctan(1/5)-4\arctan(1/239)$, width $5.6\cdot10^{-84}$), so reachability of a *rational* target is decidable in exact arithmetic. **VERIFIED**: ten rational targets decided exactly, including $1/5\to$ not reachable, $3/20\to$ reachable, $1/4\to$ reachable, $0.41\to$ reachable, $0.42\to$ not reachable. The unreachable rational $x=1/5$ stalls at $1/5-(\pi^2/24-1/4)=0.038766483287\ldots$; the exact `Fraction` run takes **every** even index $2,4,\dots,2K$ and nothing else, and the deficit from the stall value is the missing tail, rigorously in $(0,1/(4K))$.

### Theorem 13 ($p=3$).

At $p=3$, $n_{\min}=3$ and

$$S_3=[0,0.009632112895]\cup[0.015625,0.025257112895]\cup[0.125,0.134632112895]\cup[0.140625,0.150257112895].$$

Status: **PROVED (Theorem 10) + VERIFIED exactly**: $\zeta(3)$ is enclosed by exact rationals (Euler–Maclaurin, outward-rounded, width $3.1\cdot10^{-18}$) and seven rational targets land exactly where the intervals predict ($1/50$, $13/100$, $1/8$, $3/20$ reach $0$; $1/20$, $7/50$, $1/5$ stall at $x-0.024742887\ldots$, $x-0.005367887\ldots$, $x-0.049742887\ldots$).

**The first gap of each exponent.** At $p=2$ it is $(P-a_1,a_1)$; at $p=3$ the recursion runs twice, at $p=4$ four times (16 intervals), at $p=12$ fifteen times (32 768 intervals) — the census theorem's $2^{n_{\min}-1}$.

**Refuted R2 and R5.** "Inside the budget $\Longrightarrow$ writable": at $p=2$, $x=1/5$ is inside $P(2)=0.4112$, inside the sine range, and inside the gap $(0.16123,0.25)$. And "every rational target terminates" is **not** a signed statement at general $p$: it is a $p=1$ theorem, refuted at $p=2$ by the same $x=1/5$. **REFUTED**, witnesses as stated.

### Theorem 14 (parity lock; T9).

At a positive target the residual stays non-negative (it can hit $0$ exactly, when a term is taken with $\alpha=r$), and a term is taken only when the residual is *positive*; odd-index terms are negative, so the sign test rejects them at every positive residual. Hence

$$\text{every take of a positive target sits at an }\textbf{even}\text{ index},\qquad\text{every take of a negative target sits at an }\textbf{odd}\text{ index},$$

$$\text{so every gap of the signed support is }\textbf{even}\text{ and at least }2.$$

Status: **PROVED** by induction on the step, machine-checked in `Rh42/Tau.lean`: `tauStep_nonneg`, `tauStep_pos_of_lt`, `tauStep_nonpos`, `tauStep_neg`, `tauStep_eq_self_of_odd`, `take_parity`, `tauStep_eq_self_of_even`, `take_parity_neg`, `tauResidual_nonneg`, `tauResidual_nonpos`, `support_subset_even`, `support_subset_odd_of_neg`, `support_gap_even_and_two_le`, `support_gap_even`, and the `_of_neg` mirrors. **VERIFIED** for $p=1,2$ and four targets. The strict form "*the residual stays $>0$*" is **false** at the boundary ($x=1/2$, $p=1$: the first term is taken with equality and the residual becomes $0$), which is why the machine-checked statements are the non-strict ones; the parity conclusion is unaffected.

### Corollary 15 (T8).

For $x>0$ the signed rule *is* the classical Egyptian greedy on $\{k^{-p}\}$ at target $2^px$: the term $n=2(k-1)$ has value $2^{-p}k^{-p}$. Status: **PROVED + VERIFIED** at $p=1$ for $x=1/2,1/3,2/5,7/9$, matching support for support ($\{0\}\leftrightarrow\{1\}$, $\{2,10\}\leftrightarrow\{2,6\}$, $\{2,6,38\}\leftrightarrow\{2,4,20\}$, $\{0,2,34\}\leftrightarrow\{1,2,18\}$). So rh41's Theorem 8 (*every rational target terminates*) transfers to the positive half at $p=1$ and **only** there: at $p=2$ the rational $1/5$ is not writable.

**Statements about the signed word's factors.** Since the support of a signed word is just a finite set, rh41's proved law applies verbatim (its Lean `complexity_main` is generic in the support):

* **Plateau and decay (rh41's Theorem 1).** For $L\ge a_m+1$, $p(L)=\min(a_m+1,N-L+1)+[L\le N-a_m-1]$; **VERIFIED** on the signed supports $\{0,2,4,10\}$, $\{2,6,38\}$, $\{0,8\}$, $\{0,2,4\}$.
* **Corollary 4.** $\max_L p(L)=a_m+2$ once $N\ge2a_m+2$; **VERIFIED** on $\{0,2,4\}$ and $\{2,6,38\}$.
* **The C1 regime of a signed word (new, corrected).** C1 says $p(L)=L+1$ for $L\le\min(\min\text{gap},a_0,N-a_0-1)$. By Theorem 14 every gap of a signed word is even and $\ge2$, so the C1 range contains no gap obstruction beyond $\min$ gap, and it sits inside $L\le2$ exactly when the support has a gap of length $2$. The full range is $\min(\min\text{gap},a_0,N-a_0-1)$: for $\{4,8,12\}$, $N=20$ it is $L\le4$ and $p(1..4)=2,3,4,5$; for $\{2,6,38\}$, $N=22$ the min gap is $4$ but $a_0=2$, so the range is $L\le2$; and for $\{0,2,4,10\}$, $N=22$ the min gap is $2$ but $a_0=0$ **empties** the C1 range, even though $p(1)=2$ and $p(2)=3$ still hold by hand and $L=3$ already violates $L\le\min$ gap. **VERIFIED.** *(A previous formulation of this bullet claimed the C1 range is always $L\le2$; that is false — an even gap can be larger — and the corrected statement is the one above.)* In Lean, the structural half is `GapsAtLeast`, `two_le_of_even_pos`, `c1_range_le_two_of_gap_eq_two`, with the worked instance `complexity_c1_example` (support $\{2,4\}$, $N=10$, $p(2)=3$ via `Rh41.complexity_c1`).
* **The onset is still not determined by $(\text{gaps},N)$.** **CHECKED** over the parity-locked supports: **210 of 402** keys $(\text{gaps},N)$ are multi-valued. The parity constraint does not repair rh41's Theorem 6.

**Refuted R6, T16.** "The word sees the turns": the word factors through $\sin(2\pi\theta)$; the height-preserving reflection is $\theta\mapsto1/2-\theta$, **not** $\theta\mapsto1-\theta$ (which flips the sign).

### Theorem 16 (T16).

The rule reads exactly one real number, the height $x=\sin(2\pi\theta)$. Hence the word is a function of $x$ alone:

$$\theta,\ \theta+1,\ \theta+2,\ \tfrac12-\theta\quad\text{give the }\textbf{same}\text{ word},\qquad 1-\theta\quad\text{gives the sign-flipped height, hence the other word},$$

and the lift $(\cos2\pi\theta,\sin2\pi\theta,\theta)$ is not periodic — the word simply cannot see it. Status: **PROVED (paper)** (the rule's input is the target; $\sin(2\pi(\theta+1))=\sin(2\pi\theta)$ and $\sin(2\pi(1/2-\theta))=\sin(2\pi\theta)$, while $\sin(2\pi(1-\theta))=-\sin(2\pi\theta)$), **VERIFIED** at 200 dps for $\theta=0.1,0.3,0.42,0.77$, comparing only the prefixes whose residuals stay above the $10^{-100}$ precision floor.

**Consequences.** (a) $\cos$ spends the same two budgets, and at $45^\circ$ ($\theta=1/8$) $\sin=\cos$, so the two words coincide; at $270^\circ$ $\sin=-1$, $\cos=0$ (the empty word). (b) No rule that reads a *periodic* function of $\theta$ — in particular not $\theta\bmod1$ — can see the turn count; to see it the rule must be fed a non-periodic function of $\theta$, which is the honest statement of the handoff's §5.7.

**Fixtures.** $\sin(\pi/4)=1/2+1/5+1/141+1/68575$ (tail $3.1\cdot10^{-11}$, support $\{0,3,139,68573\}$), $x=1\leftrightarrow\{0,1,4\}$, and the $p=2$ unreachable rational $1/5$ of Theorem 12 are the fixed test points; all three reproduce.

## Source

[`manuscript.md`](../rh/research/publish/003-budgets-reachability-tau/manuscript.md) · [`README.md`](../rh/research/publish/003-budgets-reachability-tau/README.md)
