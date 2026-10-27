# Balance of the split of zeta partial sums at Re S = 0, and the equal four-part split

**First edition, packaged from this folder's `README.md` and `TRUTHS.md` (item §4 of `research/truths.md`), produced in the programme's round `rh43`. The Lean development, numerics and their run logs are reproduced in this folder; markdown links in the reproduced sources were re-pointed into the folder and nothing else was modified.**

This programme's papers do not prove the twin prime conjecture, and this folder does not either. Nothing here advances, obstructs or interacts with the parity problem; §5 says so explicitly.

## Abstract

For the finite partial sums $S_N(t)=\sum_{n\le N} n^{-it}$ of the zeta Dirichlet series at the abscissa $\operatorname{Re}(S)=0$, split every term into its positive real part $P_N(t)\ge 0$ and its negative real part $M_N(t)\le 0$. The question of the round is whether that split can be made balanced — two equal positive parts and two equal negative parts. The folder answers yes, and identifies the condition exactly. **PROVED** (Lean 4, `Rh43/Balance.lean`, no `sorry`, no new axiom): $P_N(t)=|M_N(t)|$ is equivalent to the single real equation $\operatorname{Re}S_N(t)=0$, and that, in turn, to the equality of the four pieces $P_N/2,\,P_N/2,\,M_N/2,\,M_N/2$; for $N=3$ the sign change $\operatorname{Re}S_3(5/2)<0<\operatorname{Re}S_3(0)=3$ gives a root by the intermediate value theorem; and for $N=2$ the case is exact, $\operatorname{Re}S_2(\pi/\log 2)=0$, with a *tangential* zero. **VERIFIED** by an independent auditor: 47-digit certified brackets for the smallest positive root for $N=3,\dots,50$ (102/102 checks). **PROOF-SKETCH + VERIFIED** (numerically, $N\le 200$, not proved): a root exists for every $N\ge 3$, by equidistribution of $(t\log 2,\dots,t\log N)$. **REFUTED** as strict readings: the term-level "two-and-two" partition of the terms fails at the certified roots, and $\operatorname{Re}S_N(t)=0$ is *not* the same question as the complex vanishing $S_N(t)=0$. Two earlier statements of the round were corrected and are kept visible: a first draft claimed no root exists for $N=2$, and its docstring claimed $|S_N|$ grows like $N^{1/2}$; the true growth is linear, $|S_N|\sim N/\sqrt{1+t^2}$.

## 1. Introduction and goal

The greedy-construction thread of the programme needs a *balanced* configuration: a length $N$ and a height $t$ at which a finite partial sum of the zeta Dirichlet series has real part zero. The object of this folder is the balance condition itself, its structural form (an equal four-part split), and the certified root tables that witness it.

The question is posed for a complex input $S$ with $\operatorname{Re}(S)=0$, i.e. $S=it$ with $t$ real. Take the finite partial sum
$$S_N(t)=\sum_{n=1}^{N} n^{-it}=\sum_{n=1}^{N}\exp(-it\log n)\in\mathbb{C},$$
split every term into its positive real part $P_N(t)\ge 0$ and its negative real part $M_N(t)\le 0$, and ask whether the partial sum can be separated into **two equal positive parts and two equal negative parts, using only the positive parts and the negative parts with ordinary summation**. The answer of the round is yes, for every $N\ge 2$, and the whole content of the question turns out to be the single real equation $\operatorname{Re}S_N(t)=0$.

In scope: the equivalence of balance with the vanishing of the real part, its equivalence with the equal four-part split, the explicit witnesses at $N=2,3,4$, and certified root brackets for $N=3,\dots,50$. Out of scope, and stated as such by the sources: any relation between these roots and the zeros of $\zeta$; the exact complex vanishing for $N\ge 4$; and a proof of general existence that avoids equidistribution.

## 2. Setup and definitions

Throughout, $N$ is a positive integer, $t$ is real, and the input is $S=it$, so that $\operatorname{Im}(S)=t$; the scripts print $t$ as `t=...` under that convention.

* **The term.** For $n\ge 1$, $n^{-it}=\exp(-it\log n)$, with $\log$ the real logarithm; $n=1$ contributes $1$.
* **The partial sum.** $S_N(t)=\sum_{n=1}^{N} n^{-it}$ and $S_N(t)=\operatorname{Re}S_N(t)+i\operatorname{Im}S_N(t)$ with
  $$\operatorname{Re}S_N(t)=\sum_{n=1}^{N}\cos(t\log n),\qquad \operatorname{Im}S_N(t)=-\sum_{n=1}^{N}\sin(t\log n).$$
* **The split.** $P_N(t)=\sum_{n\le N:\ \cos(t\log n)>0}\cos(t\log n)\ \ (\ge 0)$ and $M_N(t)=\sum_{n\le N:\ \cos(t\log n)<0}\cos(t\log n)\ \ (\le 0)$ are the totals of the positive and of the negative real parts. An index with $\cos(t\log n)=0$ belongs to neither set; it contributes $0$ to the real part, so it is harmless there, and it is the reason why the analogous identity for the *complex* sum is false.
* **Balanced.** $\operatorname{balanced}(N,t)$ means $P_N(t)=-M_N(t)$, i.e. the positive and the negative totals have equal magnitude.
* **The equal split.** Two equal positive pieces $p_1=p_2$ and two equal negative pieces $n_1=n_2$ with $p_1+p_2=P_N(t)$, $n_1+n_2=M_N(t)$ and $p_1+n_1=0$.
* **Reader conventions.** The formulation above is reading (R1)/(R2) of the source ledger: "two equal positive parts" means *the positive total splits into two equal halves*. The stronger, term-level reading (R2$'$) — the positive **terms** partition into two subsets of equal sum, and likewise the negative terms — is a different question and is answered separately in §3. The complex equation $S_N(t)=0$ is reading (R3), again a different question.
* **Notation in this folder's Lean file.** `zetaPartial N t` is $S_N(t)$, `realPartial N t` is $\operatorname{Re}S_N(t)$, `posRe N t` is $P_N(t)$, `negRe N t` is $M_N(t)$, and `balanced N t` is the balance predicate, all under the namespace `Rh43` in `Rh43/Balance.lean`.

## 3. Results

Status markers are the sources' own: **PROVED** (written argument or Lean), **VERIFIED** (independent recomputation), **MEASURED** (numbers with their scales), **PROOF-SKETCH**, **REFUTED**, **OPEN**.

### 3.1 The key identity and the reduction to one real equation

**Theorem 1** (the split is an identity, and balance is a single equation). For all $N\ge 1$ and real $t$,
$$P_N(t)+M_N(t)=\operatorname{Re}S_N(t),\qquad P_N(t)=-M_N(t)\iff \operatorname{Re}S_N(t)=0,$$
and the second is equivalent to the existence of two equal positive and two equal negative pieces that sum to the split.
**PROVED** (Lean), in `Rh43/Balance.lean`: `realPartial_eq_posRe_add_negRe`, `posRe_nonneg`, `negRe_nonpos`, `balanced_iff_realPartial_eq_zero`, `balanced_equal_split`, `equal_split_balanced`, `balanced_iff_equal_split`, and `zetaPartial_re`. The proof splits the finite sum over the two index sets on which the cosine has a strict sign; the terms with $\cos=0$ contribute $0$, so they drop out. **VERIFIED** in `zeta_split.py` §1 (see §4 here).

**Theorem 2** (equal-split form, with its necessary conjunct). `balanced_iff_equal_split` states the equivalence with the conjunct $p_1+n_1=0$ included; the source notes that without it the statement is false, with the counterexample $N=2$, $t=0$ (`not_balanced_two_zero`): the four numbers still split the two totals there, but the partial sum is not balanced. **PROVED** (Lean).

The whole question therefore reduces to the single real equation $\operatorname{Re}S_N(t)=0$. Everything below concerns that equation.

### 3.2 The small cases

**Theorem 3** ($N=1$ is degenerate). $\operatorname{Re}S_1(t)=1$ for every $t$: one positive part and no negative part, so the split has nothing to balance. **PROVED** (by definition) + **VERIFIED** in `zeta_split.py` §2. The same source records that $N=1$ is the *only* case with no negative part.

**Theorem 4** ($N=2$ is balanced, exactly, at $t=\pi/\log 2$).
$$S_2(\pi/\log 2)=1+e^{-i\pi}=0,\qquad \operatorname{Re}S_2(\pi/\log 2)=1+\cos\pi=0,\qquad P_2=1,\quad M_2=-1 .$$
The zero is **tangential**: $\operatorname{Re}S_2(t)=1+\cos(t\log 2)\ge 0$ with equality exactly at $t=(2k+1)\pi/\log 2$, so a search for a *sign change* misses it. **PROVED** (Lean, `Rh43/Balance.lean`: `realPartial_two`, `realPartial_two_pi_div_log_two`, `balanced_two`, `exists_balanced_two`, `posRe_two_at_pi_div_log_two`, `negRe_two_at_pi_div_log_two`, `zetaPartial_two`, `zetaPartial_two_pi_div_log_two`) + **VERIFIED** in the script §2, and independently with 74-digit certified enclosures by the auditor (the source witnesses the smallest root as $4.5323601418271938096276829457166668$). This is the trap of the round: the smallest positive root is $\pi/\log 2$, not "none".

**Theorem 5** (explicit IVT witness at $N=3$). There is $t\in(0,5/2)$ with $\operatorname{Re}S_3(t)=0$; hence $\operatorname{balanced}(3,t)$ holds. Indeed $\operatorname{Re}S_3(t)=1+\cos(t\log 2)+\cos(t\log 3)$, $\operatorname{Re}S_3(0)=3>0$, and
$$\operatorname{Re}S_3(5/2)<0,\qquad\text{the certified value being } -0.08433575829842532\ldots$$
so continuity plus the intermediate value theorem gives a root. **PROVED** (Lean: `realPartial_three_at_zero`, `cos_two_mul_log_two_lt` ($\cos((5/2)\log 2)<-0.16$), `cos_two_mul_log_three_lt` ($\cos((5/2)\log 3)<-0.92$), `realPartial_three_five_halves_neg`, `exists_zero_realPartial_three`, `exists_realPartial_three_eq_zero`, `exists_balanced_partial_sum`), with the trigonometric bounds derived from Mathlib's `Real.log_two_gt_d9`, `Real.log_three_gt_d9`, `Real.pi_gt_d20`/`Real.pi_lt_d20`, `Real.one_sub_sq_div_two_le_cos` and `Real.sin_ge_sub_cube`; no numerical axiom is used. **VERIFIED** in the script §3, by a certified sign change of the enclosure of $\operatorname{Re}S_3$ across $[2.42,2.43]$.

**Theorem 6** (the same route at $N=4$). $\operatorname{Re}S_4(0)=4>0$ and $\operatorname{Re}S_4(12/5)=-0.950677206742\ldots<0$, so $N=4$ is balanced in $(0,12/5)$ too. **VERIFIED** (certified numerical enclosure, `zeta_split.py` §3). The ledger marks this **PROVED** (numerically certified) and notes that the Lean development currently formalises the $N=3$ witness only.

### 3.3 Certified root brackets, $N=3,\dots,50$

**Theorem 7** (certified root table). For every $N$ in the table there is a *sign change* of $\operatorname{Re}S_N$ on the stated rational bracket, hence a root inside it. The computation uses the `ivmath.py` engine, whose `Num` carries a value plus a guaranteed error at 400 dps ($\pi$ by Machin, $\log n=2\operatorname{atanh}((n-1)/(n+1))$ over the prime factors of $n$, $\cos$/$\sin$ by Taylor series with explicit remainder bounds), so the brackets are certificates, not estimates. **VERIFIED**.

The round's own engine (`zeta_split.py` §4) certifies a bracket for every $N=3,\dots,20$ and for $N=25,30,40,50$, with widths $3.47\cdot10^{-21}$ for $N\le 12$ (growing to $1.22\cdot10^{-7}$ at $N=50$), and the auditor's independent engine (`verify/independent_check.py`, check C3) certifies the smallest positive root for $N=3,4,5,6,7,8,10,12,20,50$ to 47 digits, width $8.7581\cdot10^{-47}$:

| $N$ | smallest positive root, certified (32 digits shown) |
|---|---|
| 3 | 2.42665205162968924405857564688668 |
| 4 | 1.85039292764260780631379556995417 |
| 5 | 1.55009817600781349235317852292262 |
| 6 | 1.36250808733474170983371419814076 |
| 7 | 1.23274015620690914900467129090098 |
| 8 | 1.13684395014600383257874781653817 |
| 10 | 1.00316316617548533918513548856522 |
| 12 | 0.91319827876062629357124803935550 |
| 20 | 0.72461569909908482871273815855624 |
| 50 | 0.52144338691777468350280721800959 |

Each is certified by "no zero on $[0,s_{\mathrm{lo}}]$" together with a strict derivative sign on $[s_{\mathrm{lo}},b]$, so the root is the *smallest* positive one; the source prints the accompanying margin $\min|f|$ on $[0,s_{\mathrm{lo}}]$ and $\min|f'|$, e.g. for $N=3$: `min f on [0,s_lo] = 6.0081e-2`, `|f'| min = 1.1792e0`.

The table in the prose ledger `ROUND-TRUTHS.md` §1.3 lists the nine auditor brackets for $N=3,4,5,6,8,10,12,20,50$; the auditor's own run in this folder covers the ten values above (it includes $N=7$). The round's script covers the wider list $N=3,\dots,20,25,30,40,50$.

> **A warning worth carrying (from the source).** `mpmath.findroot` with its default tolerance returns $2.4266520516296892218\ldots$ for the $N=3$ root — wrong from the 18th digit. The true value is $2.426652051629689244058575646886684647621\ldots$. Any value quoted to more than about 17 digits must come from a certified bracket.

### 3.4 Existence for every $N\ge 3$: sketch, and what is not proved

**Theorem 8** (existence for every $N\ge 3$). For every $N\ge 3$ there is a real $t$ with $\operatorname{Re}S_N(t)=0$; hence a balanced split exists for every $N\ge 2$. **PROOF-SKETCH + VERIFIED numerically, not proved here.** Argument as the source gives it: $\operatorname{Re}S_N$ is continuous and $\operatorname{Re}S_N(0)=N>0$. On the other side, for a fixed $N$ the vector $(t\log 2,\dots,t\log N)$ is equidistributed on the torus as $t$ varies — the functions $t\mapsto t\log n$ are linearly independent over $\mathbb{Q}$ — so the values $\operatorname{Re}S_N(t)$ take both signs infinitely often; in particular some $t$ has $\operatorname{Re}S_N(t)<0$ (choose $t$ so that the terms of one sign dominate), and the intermediate value theorem gives a root. **VERIFIED** numerically for every $N=3,\dots,200$ (the smallest positive root is bracketed and bisected for $N\le 50$ above, and the sign of $\operatorname{Re}S_N$ is found negative for a range of heights up to $N=200$). A self-contained proof that avoids equidistribution is **OPEN** (see §5). Note carefully what Lean does and does not give here: the Lean theorem named `exists_balanced_partial_sum` states $\exists\,N\ t,\ 0<N\wedge\operatorname{balanced}N t$ — a *single* witness, obtained from the explicit $N=3$ case — not the statement for every $N$.

### 3.5 The complex partial sum is a different question

**Theorem 9** ($N=3$ has no complex zero). For $N=3$, $S_3(t)\ne 0$ for every real $t$. **PROVED** (Lean, `Rh43.zetaPartial_three_ne_zero`): writing $x=\exp(-it\log 2)$, $y=\exp(-it\log 3)$, the equation $1+x+y=0$ forces $\cos(t\log 2)=\cos(t\log 3)=-1/2$, hence $3t\log 2,3t\log 3\in 2\pi\mathbb{Z}$; a nonzero solution would give integers $n,m\ne 0$ with $m\log 2=n\log 3$, hence $3^{|n|}=2^{|m|}$, which forces $3\mid 2$. The source reports that the axiom audit over the development returns only `propext, Classical.choice, Quot.sound`.

**Theorem 10** (why the complex picture is not the question). For $N\ge 2$ the numbers $1,2^{-it},\dots,N^{-it}$ are $\mathbb{Q}(t)$-linearly independent, so $S_N(t)=0$ is a non-degenerate algebraic relation and can hold only in degenerate configurations of log-arithmetic — as at $N=2$, where $2^{-it}=-1$ is exactly $t=(2k+1)\pi/\log 2$. **PROVED** for the linear-independence statement + **MEASURED** for $N\ge 4$: the grid minima of $|S_N|$ recorded by the script are $3.58\cdot10^{-1},3.08\cdot10^{-1},2.19\cdot10^{-3},7.75\cdot10^{-4}$ for $N=3,4,5,6$ on $[0,15]$ (the auditor's certified lower bounds); these are evidence, not proof. For $N\ge 4$ whether a real solution exists is **OPEN**.

**Theorem 11** (the blanket non-vanishing is false). $\neg\,\forall N\,t,\ S_N(t)\ne 0$, with the $N=2$ witness. **PROVED** (Lean, `not_forall_zetaPartial_ne_zero`).

### 3.6 The four-part split: two readings, opposite answers

**Theorem 12** (the numeric four-part split is exact). At any balance point the four numbers $P_N/2,P_N/2,M_N/2,M_N/2$ are two equal positive and two equal negative pieces: $P_N/2=|M_N|/2$ follows from $P_N=|M_N|$, and $P_N/2+P_N/2+M_N/2+M_N/2=P_N+M_N=0$. **PROVED** (trivial algebra once Theorem 1 holds; Lean `balanced_equal_split`, `equal_split_balanced`, `balanced_iff_equal_split`) + **VERIFIED** in the script §5 at $N=3$, where $P=1=|M|$ and the four pieces are $\pm1/2$.

**Theorem 13** (the term-level split fails; this is a different question). Read "two equal positive parts" as *the positive terms partition into two subsets of equal sum*, and likewise for the negative terms. Then the split does **not** exist at the certified roots. At $N=6$, $t=1.3625080873347417\ldots$: $P=1.660074847\ldots$, so $P/2=0.830037423\ldots$, while the best subset of the positive terms sums to $0.660074847\ldots$ — an exact subset-sum defect of $0.169962576\ldots$; the negative side is short of $|M|/2$ by $0.065392329\ldots$. The cause is structural: $\cos(t\log 1)=1$ is the first positive term and it exceeds $P/2$ whenever $P<2$, so $1$ can never lie in a half. At the tested roots $P$ runs $1.00,1.28,1.48,1.66,2.02,2.40,2.74$ for $N=3,4,5,6,8,10,12$, so the strict split fails at every one of them (the defect shrinks like $1/N$ but is positive at each tested root; for $N\ge 8$ it is no longer the first term that binds). **PROVED** for the structural obstruction (and for $N=3$, where the positive side is the single term $\{1\}$ and cannot be split at all) + **VERIFIED** exactly by exhaustive subset-sum over the positive and negative term sets at the certified roots. The source's list of positive-side defects is $0.5,0.358,0.262,0.170,0.0108,0.0202,0.0286$ for $N=3,4,5,6,8,10,12$.

The source records the two readings side by side so that they are not confused: the *split* (positive total against negative total) balances for every $N\ge 2$; the *term-level partition into two equal halves* does not, at the balance points. If "two-and-two" is relaxed to "any number of equal pieces", the three-piece identity $P/3+P/3+P/3=P$, $M/3+M/3+M/3=M$ with $P/3=|M|/3$ is exact, but that decomposes the totals, not the terms.

### 3.7 The positive-values-only two-subset problem

**Theorem 14.** Work with the positive terms only and ask for two **disjoint** subsets $A,B$ with $\sum A=\sum B$ (equivalently $\sum A=P/2$); no balance equation is involved. **PROOF-SKETCH + VERIFIED (15/15 checks)**, `verify/positive_only_split.py`.

* The top-level criterion is much weaker than balance: since $\cos(t\log 1)=1$ is always the largest positive term, a nonempty split needs $1\le P/2$, i.e. $P\ge 2$. That is a single *inequality*, satisfiable for every $t$ once $N$ is large enough ($N=200$, $t=0.2$: $P=127.44$), whereas the balanced split needs the exact transcendental equation $\operatorname{Re}S_N(t)=0$.
* Exact equality of two subsets needs completeness at *every* index. By Brown's criterion the subset sums of $a_1\ge a_2\ge\cdots\ge a_m$ fill $[0,P]$ exactly when $a_k\le a_{k+1}+\cdots+a_m$ for every $k$. For the positive terms the last condition is $a_m\le 0$, which always fails: the final term has nothing after it, so a gap survives and no two subsets are exactly equal.
* **MEASURED:** the greedy split (largest first, no overshoot) leaves $P/2-\sum A=4.3\cdot10^{-4}$ at $N=20,t=1/2$; $2.0\cdot10^{-2}$ at $N=20,t=1$; $4.3\cdot10^{-1}$ at $N=40,t=0.2$; $1.4\cdot10^{-2}$ at $N=60,t=2$; and only $1.0\cdot10^{-4}$, $1.5\cdot10^{-4}$ at $N=400,800$, $t=1$. The defect is small and irregular but never zero. The recorded run `logs/positive_only_split.log` carries these numbers and 15/15 checks.
* The rendered evidence `positive_only_N20.png` draws the best pair at $N=20,t=1/2$: $A=\{2,3,6,8,9,10,13,15,17\}$, $B=\{1,4,5,7,11,12,14,16,18,19,20\}$, sums $4.439862577$ and $4.439877757$ against $P/2=4.439870167$, gap $1.52\cdot10^{-5}$; the corresponding data file is `positive_only_N20.json`.
* **Caveat (the source's own).** The last-index obstruction shows the subset sums do not *fill* $[0,P]$; it does not by itself prove $P/2$ is outside the reachable set for every $N$ and $t$. Exactness would require $P/2$ to coincide with one of the finitely many subset sums — a coincidence among transcendental values. It is **REFUTED** at every tested point and **OPEN** in general. If exactness is relaxed to "within floating-point tolerance", the split always exists; the obstruction is only to *exact* equality.

### 3.8 Only finite partial sums: the series diverges

**Theorem 15** (linear divergence). For every real $t$, $S_N(t)$ does not converge as $N\to\infty$ in the ordinary sense; in fact
$$\frac{|S_N(t)|}{N}\longrightarrow \frac{1}{\sqrt{1+t^2}} .$$
**PROVED** (first-order Euler summation gives $S_N=(N^{1-it}-1)/(1-it)+(1+N^{-it})/2+R_N$ with $|R_N|\le (|t|/2)\log N$, hence $|S_N|\ge N/\sqrt{1+t^2}-(|t|/2)\log N-O(1)\to\infty$) + **VERIFIED** by the auditor with certified values, at $t=1$: $|S_{10}|=7.845596$, $|S_{100}|=70.798738$, $|S_{1000}|=707.396987$, $|S_{10^4}|=7071.771405$, against $1/\sqrt2=0.70710678$, with a maximum deviation $5.44\cdot10^{-7}$ at $N=10^6$; and empirically in the script §6. The source adds the reading: the naive picture $|S_N|\sim\sqrt N$ belongs to $\operatorname{Re}(S)=1/2$, not $\operatorname{Re}(S)=0$; at $\operatorname{Re}(S)=0$ the sum grows linearly, so the partial sum of the question is necessarily a finite one.

### 3.9 The imaginary-part mirror

**Theorem 16** (Im-balance existence). Split each term by the sign of its imaginary part $-\sin(t\log n)$: $J_p(t)=\sum_{\sin<0}(-\sin(t\log n))\ge 0$ and $J_m(t)=\sum_{\sin>0}(-\sin(t\log n))\le 0$. Then $\operatorname{Im}S_N(t)=J_p(t)+J_m(t)$, and the split is balanced, $J_p=|J_m|$, exactly when $\operatorname{Im}S_N(t)=0$. For every $N\ge 2$ there is $t>0$ with $\operatorname{Im}S_N(t)=0$. **PROOF-SKETCH** (conditional on Weyl equidistribution, + **VERIFIED** for $N=2,\dots,20,25,30,40,50$ by `ivmath` certificates in `im_balance.py` and `logs/im_balance.log`). The exact small cases are $N=2$: first root $t=\pi/\log 2=4.53236\ldots$, and $N=3$: first root $t=2\pi/\log 6=3.50671\ldots$, from $\operatorname{Im}S_3(t)=-2\sin(t\log 6/2)\cos(t\log(2/3)/2)$; $t=0$ is a trivial root for every $N$, so the content is the *positive* height. Certified first positive roots include $[4.53236014182719381,4.53236014182719381]$ ($N=2$), $[3.50671248852758995,3.50671248852758995]$ ($N=3$), $[2.94027481914407386,2.94027481914407386]$ ($N=4$), $[1.360292964088076,1.360292964088149]$ ($N=20$, width $7.3\cdot10^{-14}$), $[1.004896240234375,1.004896545410156]$ ($N=50$, width $3.1\cdot10^{-7}$). The two conventions differ: at $N=3$ the Im-root $3.50671\ldots$ has $\operatorname{Re}S_3=-0.515517499\ldots$, while the real-part root $2.42665\ldots$ has $\operatorname{Im}S_3=-1.451730310\ldots$. The term-level split fails here too: at the $N=6$ Im-balance height the positive imaginary terms have exact subset-sum defect $0.093688585\ldots$ and the negative ones $0.227630314\ldots$.

The source also reports Brown's criterion applied to a tail with a general abscissa $\sigma$: at $\sigma=0$ (the setting of this folder) $A_{\mathrm{pos}}$ diverges, so Brown's summability hypothesis fails and there is no summable tail; for $\sigma>1$ Brown applies, and scanning the balance roots the Im-split stays complete through a threshold near $\sigma\approx1.87$ and fails above it (the pure even/odd power budget's Brown threshold is $p^\ast=1.7286472389981836$, from $\zeta(p^\ast)=2$, recorded as **MEASURED**).

### 3.10 The asymptotic of the split, and the critical line

**Theorem 17** (the $N\to\infty$ asymptotic of the split). At the general abscissa $S=\sigma+it$, two identities are exact for every $N$: $P_N+|M_N|=\sum_{n\le N}n^{-\sigma}|\cos(t\log n)|$ (the additive size) and $P_N-|M_N|=\operatorname{Re}S_N(\sigma+it)$ (the signed total), hence
$$\text{relative gap}=\frac{\bigl|P_N-|M_N|\bigr|}{P_N+|M_N|}=\frac{|\operatorname{Re}S_N(\sigma+it)|}{\sum n^{-\sigma}|\cos(t\log n)|}.$$
**PROVED** (identities) + **VERIFIED** (the abscissa table below). The numerator is a cancelling sum, the denominator a non-cancelling one: for $\sigma>1$ both converge and the relative gap is $O(1)$; for $0<\sigma\le1$ the denominator is $\sim N^{1-\sigma}/(1-\sigma)$ (times a positive constant; $\sim\frac12\log N$ at $\sigma=1$) and the gap is $O(N^{-(1-\sigma)})\to0$; at $\sigma=0$ both the split and its difference grow linearly and the ratio **does not settle**. Measured at $t=14.134725$: at $\sigma=1/2$, $N=10^6$, the gap is $36.05/1284.83=0.0281$; at $\sigma=1$, $0.3577/9.899=0.0361$; at $\sigma=2$, $0.6892/1.5427=0.4467$. Measured $P_N/|M_N|$ at $t=1$: $0.042,13.0,0.26,0.40,21.3,0.10$ for $N=10^2,\dots,10^7$ — it does not settle. The source also records a **REFUTED** natural guess: $P_\infty=(\zeta(\sigma)-\operatorname{Re}\zeta(\sigma+it))/2$ fails at $\sigma=2,t=14.13$, predicting $0.478$ against the measured $1.11597$.

**Theorem 18** (the critical line $\sigma=1/2$). **PROVED** (identities, radial law) + **VERIFIED** (numerics): the partial sums converge, $S_N(1/2+it)\to\zeta(1/2+it)$, and the split obeys the radial law $P_N,|M_N|\sim\frac12\sum_{n\le N}n^{-1/2}=\sqrt N$, i.e. half the sign-blind total each; measured at $t=14.134725$, $(P_N+|M_N|)/\sqrt N=1.2602,1.2848,1.2704,1.2643$ for $N=10^5,\dots,10^8$, i.e. the constant $\int|\cos|=4/\pi=1.2732$ (each part $\sim(2/\pi)\sqrt N=0.6366\sqrt N$); fitted growth exponents of $P_N$ are $0.955,0.716,0.477,0.241,0.057,0.0002$ at $\sigma=0,0.25,0.5,0.75,1,1.5$, against the law $N^{1-\sigma}$ ($1,0.75,0.5,0.25,0,<0$). What does **not** improve (**VERIFIED**): at the first zero $t=14.134725141734693$ (where $\zeta(1/2+it)=1.2\cdot10^{-16}-7.3\cdot10^{-16}i$), $|S_N|/\sqrt N=0.0707053,0.0707037,0.0707035,0.07070353$ for $N=10^4,10^5,10^6,10^7$ — the constant $1/\sqrt{2t}=0.0707036\ldots$ — so the partial sum *grows* like $0.0707\sqrt N$ at the zero and the zero lives entirely in the cancellation $\zeta-S_N=-0.0707\sqrt N+o(\sqrt N)$; the finite-$N$ balance condition $\operatorname{Re}S_N(1/2+it)=0$ has its smallest positive root at $0.505,0.304,0.214,0.164,0.132$ for $N=10^2,\dots,10^6$, in rough agreement with the scale $1/\log N$ of the oscillation of the main term and **not** at the zeta zeros ($14.13,21.02,\dots$); the relative gap stays $\approx0.05$ ($0.055,0.074,0.00075,0.065,0.071$ for $N=10^4,\dots,10^8$). **Verdict as the source gives it:** $\sigma=1/2$ is the right abscissa for radial decay and for a convergent difference, but the bridge from this finite-$N$ split to the zeta zeros would still require a smoothing/summation step that unwinds the main term $N^{1/2+it}$ and extracts $\zeta$ to $o(1)$ accuracy; with a plain sharp cutoff the error is $O(\sqrt N)$.

### 3.11 Falsified statements of the round (kept visible)

| # | statement | smallest witness |
|---|---|---|
| F1 | "the split can be balanced **iff** $N\ge3$" | $N=2$, $t=\pi/\log 2$: $\operatorname{Re}S_2=0$ exactly, $P=1=|M|$. The zero is tangential, so a sign-change scan misses it. |
| F2 | "$N=2$ has no root of $\operatorname{Re}S_2$" | false: the roots are $t=(2k+1)\pi/\log 2$, the smallest $\pi/\log 2=4.5323601418271938096276829457166668$ (74-digit certified). |
| F3 | "$N=1$ is the same as $N=2$" | $N=1$ is the *only* case with no negative part ($\operatorname{Re}S_1\equiv1$); $N=2$ has both parts non-degenerate. |
| F4 | "the complex partial sum never vanishes for $N\ge2$" | $N=2$, $t=\pi/\log 2$: $S_2=1+e^{-i\pi}=0$ exactly. |
| F5 | "$|S_N(t)|$ grows like $N^{1/2}$" | certified $|S_{10^4}(1)|=7071.771405$; the growth is linear, $1/\sqrt{1+t^2}$. |
| F6 | "the sum of positive parts minus the absolute sum of negative parts is the imaginary part" | it is the **real** part: $P+M=\operatorname{Re}S_N$. A sign/convention slip to keep out of the ledger. |
| F7 | "a balance point implies the *terms* can be split two-and-two" | false at the certified roots: $N=6$, $t=1.3625080873\ldots$, the positive terms miss $P/2$ by an exact subset-sum defect of $0.169962576\ldots$ (the term $\cos(t\log 1)=1$ can never be in a half while $P<2$). The numeric pieces $P/2,M/2$ are equal; the term-level partition is not. |

**Corrections recorded by the source (not deleted).** "Statements **corrected** from the earlier drafts of this round: the first script and the first Lean file both claimed 'no root for $N=2$' (F1/F2), and the script's docstring claimed $N^{1/2}$ growth (F5). Both are fixed here, and the corrections are recorded rather than deleted."

### 3.12 Open

* A self-contained proof of Theorem 8 — existence of a root of $\operatorname{Re}S_N$ for every $N\ge3$ — without quoting equidistribution. The numerical evidence is complete through $N=200$; the missing piece is a quantitative "some height makes the sum negative" estimate. **OPEN**.
* Exact complex vanishing for $N\ge4$: does $S_N(t)=0$ have any real solution? $N=2$ yes, $N=3$ no, $N\ge4$ unknown. **OPEN**.
* The term-level two-and-two split: whether it can ever succeed at *some* balance point of some $N$ (where $P\ge2$ and the defect closes) is **OPEN**; the defect data suggest it does not close for the real-part convention.
* The imaginary-split convention is settled as in Theorem 16 (positive root for every $N\ge2$, with a Weyl proof sketch); the real-part convention is the one §3.1–§3.6 answer.

### 3.13 What this folder does not claim about the parity problem

The source devotes a section to refusing a tempting connection, and it is kept here. The balance/partition results say nothing about **Selberg's parity problem**: the parity problem is a statement about *sieve weights* and the distribution of $\lambda$ over residue classes, whereas everything in this folder is a statement about the real parts of finite partial sums of the zeta Dirichlet series at $\operatorname{Re}(S)=0$ — a one-variable analytic question with no asymptotic error term, no multiplicative function and no sieve weight. The only number theory entering the balance theorem is the $\mathbb{Q}$-linear independence of $\{\log n\}$. The source's numerical demonstration of the barrier: among twin-prime *candidates* $n,n+2$ up to $2\cdot10^6$, the counts split $999382$ with $\lambda(n)=+1$ against $1000615$ with $\lambda(n)=-1$, ratio $0.9988$, and the mean of $\lambda$ over the candidates is $-0.00062$; a weight depending only on $n\bmod 2\cdot3\cdot5\cdot7$ leaves $\sum\lambda w=-5241$ over $457141$ weighted candidates — a relative bias of order $10^{-2}$, not the parity break a proof would need (**MEASURED**). Consequently: **no result in this folder advances, obstructs or interacts with the parity problem or the twin prime conjecture.** What a proof of twin primes would need from this direction is a correlation statement such as $\sum_{n\le x}\lambda(n)\lambda(n+2)=o(x)$, itself open; the balanced-partition results here say nothing about it.

## 4. Verification and evidence

Everything below was run in this folder by the packaging pass; the recorded logs are also in the folder and agree.

**Lean.** `./check.sh --all` elaborates `Rh43/Balance.lean` and `Rh43.lean` against Lean 4 + Mathlib (elan at `$HOME/lean`, toolchain `leanprover/lean4:v4.35.0-rc2`, Mathlib4 at `$HOME/lean/mathlib4`; a different installation is selected with `LEAN_PREFIX`). Observed:

```
[check] OK   Rh43/Balance.lean (129s)
[check] OK   Rh43.lean (100s)
real 233.49
EXIT=0
```

The folder's recorded run `logs/lean_check.log` shows the same two `[check] OK` lines (18s and 5s on the recording machine). The development has no `sorry`, no `admit`, no project-specific `axiom` and no `native_decide`; a temporary `#print axioms` audit over every theorem reports exactly `[propext, Classical.choice, Quot.sound]` (source: `LEAN-README.md`).

**Main numerics.** `python3 zeta_split.py` exits 0 iff every check passes; it uses the `ivmath.py` engine for the sign certificates and `mpmath` at 60 dps for reporting. Observed in the packaging pass, exit status 0, wall time 1157.09 s:

```
======================================================================
64 checks pass, 0 fail
```

The recorded run `logs/zeta_split.log` ends with the same `64 checks pass, 0 fail` and contains, among others, the lines

```
PASS  N=3: Re S_3(5/2) < 0 (certified rational witness; this is the Lean proof's input)   [Re S_3(5/2) in [-0.084335758298, -0.084335758298]]
PASS  N=3: certified sign change on [2.42, 2.43] (exact Fraction enclosure)
PASS  a certified root bracket was found for every N in 3..20, 25, 30, 40, 50   [all present]
PASS  N=6: the positive terms do NOT split into two equal halves (the exact subset-sum misses P/2 by a rigorous margin)   [best subset [2, 3] = 0.660074847238644 vs P/2 = 0.830037423619322 (defect 0.169962576380678)]
PASS  N=6: likewise the negative terms do not split into two equal halves   [defect 0.065392329418967]
PASS  t=1: |S_N| grows LINEARLY in N (log-log exponent ~ 1); ratio |S_N|/N bounded, limit 1/sqrt(1+t^2) = 0.707107
```

**Independent auditor.** `python3 verify/independent_check.py` recomputes every claim on rational interval enclosures (fixed-point directed rounding, `SCALE_BITS = 320`, its own $\pi$ by Machin-like arctangents and its own Taylor $\sin/\cos$), importing nothing from the round. Observed exit status 0, and on stderr:

```
102/102 checks pass   (elapsed 234.6 s)
```

The same script's recorded run `logs/independent_check.log` ends `102/102 checks pass   (elapsed 56.3 s)`. Its certified root table (C3) is the one reproduced in §3.3, with each entry carrying the "no zero on $[0,s_{\mathrm{lo}}]$" margin and the derivative margin. It also records the refutations of the blanket claims: `C5 REFUTED/PARTIAL  the claim 'no exact complex vanishing for N<=6' is REFUTED by N=2`, and `C6 divergence VERIFIED ... the suggested N^{1/2}-ish growth is REFUTED`.

**Imaginary-part mirror.** `python3 im_balance.py` exits 0 iff every check passes. Observed in the packaging pass, exit status 0, wall time 1121.25 s, `59 checks pass, 0 fail`; the recorded run `logs/im_balance.log` ends with the same count and contains the certified first positive roots for $N=2,\dots,20,25,30,40,50$. Its Brown scan records `1.60:ok; 1.70:ok; 1.80:ok; 1.85:ok; 1.90:FAIL; 2.00:FAIL; 2.50:FAIL` over $\sigma$, i.e. a visibility threshold near $\sigma=1.87$ against the pure-budget threshold $p^\ast=1.7286472389981836$.

**Positive-only problem.** `python3 verify/positive_only_split.py`, recorded run `logs/positive_only_split.log`, ends `15 checks pass, 0 fail`; representative lines:

```
PASS  N=20, t=0.5: two subsets are NOT exactly equal (a gap survives)   [P/2=4.4398702  best=4.4394388  defect=0.0004314  Brown failures=1 (first at k=19)]
PASS  N=200: the defect stays small (order 1e-4 .. 1e-3) as the positive set grows   [defect=0.003643  (#pos 4 -> 93)]
```

**Data and figures.** The certified balanced partition for $N=20$ is `partition_N20.json` (`N=20`, `t_used=0.724615699099086`, bracket `[0.724615699099028, 0.724615699099144]`, `P=3.99924880886696`, `M=-3.9992488088667506`, enclosure of the total `[-5.3933338501343984e-14, 4.723911133644578e-13]`, positive indices $1..8$, negative indices $9..20$); it is rendered as `partition_N20.png`. The positive-only best pair is `positive_only_N20.json` (`N=20`, `t="1/2"`, `P=8.87974033385977`, `sumA=4.439862577237219`, `sumB=4.439877756622551`), rendered as `positive_only_N20.png`. Both JSON files were inspected in the packaging pass; the PNG files were not opened here (their content is described by the logs and the JSON).

**Scripts not run in the packaging pass, and why.**

* `plot_partition.py` and `verify/plot_positive_only_png.py`, `verify/plot_partition_png.py` (rendering of the JSON/PNG evidence): not run — they are plotting helpers, they write into the folder, and the JSON/PNG outputs already exist and were inspected. They need `Pillow` and read fonts under `/System/Library/Fonts/Supplemental/`, falling back to Pillow's default font otherwise.
* `ivmath.py` is imported by `zeta_split.py`, `im_balance.py` and `verify/positive_only_split.py` rather than run directly; its engine is validated inside those runs (the ledger records 918 rational points and 198 logarithms, 0 containment failures).
* The Lean checks for this folder were run through `check.sh` (above); the `--all` list was not extended to any other module because the development has exactly two.

## 5. What is not claimed

* **No relation to zeta zeros.** No identity is claimed between the roots of $\operatorname{Re}S_N(t)$ tabulated here and the zeros of $\zeta(1/2+it)$ or $\zeta(it)$. The tabulated roots are roots of the *partial sums* at $\operatorname{Re}(S)=0$.
* **General existence is not proved here.** The statement for every $N\ge3$ (Theorem 8) is a proof sketch that quotes equidistribution; the numerical evidence runs to $N=200$. The Lean development proves existence for one explicit witness ($N=3$, $t\in(0,5/2)$), not for all $N$.
* **Complex vanishing for $N\ge4$ is open.** $N=2$ vanishes exactly; $N=3$ never vanishes (proved); $N\ge4$ unknown. The grid minima of $|S_N|$ are evidence, not bounds.
* **The term-level split is refuted only at the tested balance points, and open in general.** The last-index completeness obstruction does not by itself exclude a coincidental exact equality; the general statement is open, not refuted.
* **The corrected earlier claims stay visible.** The first script and the first Lean file claimed "no root for $N=2$"; the script's docstring claimed $N^{1/2}$ growth. Both are false (F1, F2, F5) and the corrections are recorded rather than deleted.
* **This folder does not touch `rh40`, `rh41` or `rh42`;** their ledgers stand as they are.
* **No parity-problem claim**, as detailed in §3.13: no result here advances, obstructs or interacts with the parity problem or the twin prime conjecture.

## 6. Value and significance

The folder closes a small but load-bearing question in the programme's greedy-construction thread: it identifies the balance condition for the partial sums at $\operatorname{Re}(S)=0$ as *exactly one real equation*, proves the equivalence with the equal four-part split in Lean, and supplies certified roots. Three things make it worth recording.

First, the reduction is exact and machine-checked, so later arguments can use $\operatorname{Re}S_N(t)=0$ in place of any statement about splitting totals, and the equal-split form is available with its necessary side condition ($p_1+n_1=0$) made explicit.

Second, the traps are part of the answer, not commentary: the $N=2$ zero is tangential (a sign-change scan misses it), the complex equation $S_N(t)=0$ is a different and harder question ($N=2$ yes, $N=3$ provably never, $N\ge4$ open), the answer depends on the split convention (the imaginary mirror has different roots), and at the *term* level the two-and-two split fails at the certified roots for a structural reason ($\cos(t\log 1)=1$). Each of these is a place where a plausible reading of the original question gives a different answer, and each is recorded with its witness.

Third, the numerical layer is certified rather than estimated: rational interval enclosures for the round's own engine and an independent engine with directed rounding for the auditor, giving 47-digit brackets for the smallest positive root as far as $N=50$, with the smallest-root property certified by a no-zero and a monotonicity argument. The negative results are recorded the same way (the falsified statements F1–F7, and the corrections to the first drafts of the round), so the ledger does not overstate what is known.

## Sources

All paths are relative to this folder. Quoted files were read in the packaging pass; SHA-256 digests are given for the files whose content is quoted above.

| source | what was used from it | locator |
|---|---|---|
| `README.md` | the item statement, contents table, proved/not-proved list, run recipe, provenance | whole file |
| `TRUTHS.md` | the §4 ledger: the seven result rows with statuses and Lean line links; certification counts | whole file |
| `ROUND-NOTES.md` | the round's summary: the answer table, the three traps, the "what this folder does not claim" list, the reproduce block | whole file |
| `ROUND-TRUTHS.md` | the full prose ledger: §0 definitions, §1.1–§1.5, §2, §3/§3.2, §4, §5 (F1–F7 and the corrections paragraph), §6, §7, §8 (T1–T17), §7.5, §7.6, §8.5 | §§0–9 |
| `LEAN-README.md` | the Lean object definitions, the theorem-by-theorem table, the build instructions, the axiom-audit note, the `cos = 0` remark | whole file |
| `Rh43/Balance.lean` | the development: definitions `zetaPartial`, `realPartial`, `posRe`, `negRe`, `balanced`; `balanced_iff_realPartial_eq_zero` (L187), `balanced_equal_split` (L201), `balanced_iff_equal_split` (L230), `realPartial_three_five_halves_neg` (L330), `exists_zero_realPartial_three` (L337), `exists_realPartial_three_eq_zero` (L350), `exists_balanced_partial_sum` (L359), `not_balanced_two_zero` (L369), `balanced_two` (L392), `not_forall_zetaPartial_ne_zero` (L458), `zetaPartial_three_ne_zero` (L489) | 588 lines, 37 `theorem`/`lemma` declarations |
| `Rh43.lean` | root module importing `Rh43.Balance` | 12 lines |
| `check.sh` | the build driver: `--all` = `Rh43/Balance.lean`, `Rh43.lean`; `LEAN_PREFIX` convention | whole file |
| `zeta_split.py` | the definitions, the main numerics: §1 split/balance, §2 small $N$, §3 the $N=3,4$ witnesses, §4 the certified root brackets, §5 the four-part split and the term-level defects, §6 complex zero and divergence | §§1–6 |
| `im_balance.py` | the imaginary-part mirror: definitions, exact small cases, certified brackets, the Brown scan | whole file |
| `ivmath.py` | the rigorous engine (`Num` = value + guaranteed error, 400 dps; Machin $\pi$, atanh $\log n$, Taylor $\cos/\sin$) | header description and engine |
| `verify/independent_check.py` | the auditor: C1–C7; `SCALE_BITS = 320`; `N_LIST = [3, 4, 5, 6, 7, 8, 10, 12, 20, 50]`; the C3 bracket table; the C5, C6, C7 verdict lines | whole file, 1020 lines |
| `verify/positive_only_split.py` | the positive-only two-subset problem: the $P\ge2$ criterion, Brown's criterion, the defect measurements | whole file |
| `partition_N20.json` | the certified balanced partition data for $N=20$ (quoted values) | whole file |
| `positive_only_N20.json` | the best positive-only pair at $N=20$, $t=1/2$ (quoted values) | whole file |
| `logs/lean_check.log` | the recorded Lean run: two `[check] OK` lines | whole file |
| `logs/zeta_split.log` | the recorded main numerics: 64 checks, 0 fail, with the quoted `PASS` lines | whole file |
| `logs/independent_check.log` | the recorded audit: 102/102, with the C1–C7 verdict lines | whole file |
| `logs/im_balance.log` | the recorded mirror run: 59 checks, 0 fail, Brown scan | whole file |
| `logs/positive_only_split.log` | the recorded positive-only run: 15 checks, 0 fail | whole file |

Local-only sources (not published elsewhere): every file in the table above is local to this folder. The item is reproduced from `research/truths.md` §4, which is the programme-level ledger this folder packages; it is not part of this folder and was not read here (the folder's `TRUTHS.md` is its in-folder copy).

SHA-256 of the sources whose content is quoted (computed in the packaging pass with `shasum -a 256`):

| source | SHA-256 |
|---|---|
| `Rh43/Balance.lean` | `111560d26d95bab80fb193d35c77a954e014cf1640e5ee9b8a1d07e3af824a94` |
| `Rh43.lean` | `f547b03105d662a99a82b4c92353987438af55ee1184ac69bfab0a668415691e` |
| `zeta_split.py` | `7d84a0303f6c248bb876dfd6a7b4894c5d12e9c252b6854add858db7559c26af` |
| `im_balance.py` | `6b02ddf5b10cf03230bedb8b7e08ce91a51127d8fafb289ddb967daa87b2b734` |
| `ivmath.py` | `3d167bae50e6e4d8590bd3975eb52cad25a0b930ea59bc9d34a1cf40e53d8a6b` |
| `verify/independent_check.py` | `409c1148235f3229889b4d8c1adc3b7aad19db21e33fa4dac3a070024c0c4726` |
| `verify/positive_only_split.py` | `50de1e27b80821a8105fe41a3ba5e8b2745d2d33212c0c36fa9086e99870db0a` |
| `ROUND-TRUTHS.md` | `3a4c629be4c84dbd752a61c18c34ecf8babb898445bbe124e462ca0fc2cbee01` |
| `ROUND-NOTES.md` | `89565eeccfdc60f9ac297634442d4b786752a8ec4da63348d00b3a268c582e2c` |
| `TRUTHS.md` | `5315c0db7c8e83190cbff895ca51458b864af8c6c3dc4adc08c612f56d709a7d` |
| `README.md` | `41f8e4cc28e6436feff4c9c05a03fbd7973fade3d4318541c6b5574adccbab40` |
| `LEAN-README.md` | `f39e9bc1b9466ca93085edc08c7bc363f6f9a8ec6ea030af009ea3a3ecfe4ba0` |
| `logs/zeta_split.log` | `33a723034026c2e81838af9f1827eb7075a5247b0a42f568bb97ce0cb93186fa` |
| `logs/independent_check.log` | `a75d4cde69aa1188004cf0a22c8ec2a3d39015573cf388d43eba3a556b267586` |
| `logs/im_balance.log` | `dd457c90a5f8cd09c37ed0f42fad82f7b47adee4842b0e29c2076b0e15962d57` |
| `logs/positive_only_split.log` | `93a05e8dc7228b7dc8f4cd706566dee21007f8fefe86e87e07f828f7e83bbc1a` |
| `logs/lean_check.log` | `47d0b800f17a3551946b6fefaf81a9e3d579c3238794cfc17b2e171b3a676748` |
| `partition_N20.json` | `e1abdfe52105eaded2dc983e9f9b30dafc09eab5698a71a04ba8939de8e1f228` |
| `positive_only_N20.json` | `81607cfb7f2fc085ccf820d35ec61b06a8706a4084d3918786da7138ac278cac` |

`check.sh`, `verify/plot_partition_png.py`, `verify/plot_positive_only_png.py`, `plot_partition.py`, `partition_N20.png` and `positive_only_N20.png` were read or listed but not quoted; they carry no digest here.

**Version / provenance.** The folder is `publish/004-balance-equal-split`, round `rh43` of the programme. The Lean toolchain used for the recorded runs is `leanprover/lean4:v4.35.0-rc2` with Mathlib4 from `$HOME/lean/mathlib4`; the numerics used `mpmath 1.3.0` (working precision 60 dps, certificates from exact `Fraction` intervals in the round's engine and fixed-point directed rounding in the auditor's).
