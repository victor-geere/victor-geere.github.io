# 004 — Partial Sums at Re S = 0 and the Equal Split

| Field | Value |
|---|---|
| Source | [`research/publish/004-balance-equal-split/manuscript.md`](../rh/research/publish/004-balance-equal-split/manuscript.md) |
| Status | Published; truths ledger §4. |
| Harvested statements | 18 |

## Abstract

For the finite partial sums $S_N(t)=\sum_{n\le N} n^{-it}$ of the zeta Dirichlet series at the abscissa $\operatorname{Re}(S)=0$, split every term into its positive real part $P_N(t)\ge 0$ and its negative real part $M_N(t)\le 0$. The question of the round is whether that split can be made balanced — two equal positive parts and two equal negative parts. The folder answers yes, and identifies the condition exactly. **PROVED** (Lean 4, `Rh43/Balance.lean`, no `sorry`, no new axiom): $P_N(t)=|M_N(t)|$ is equivalent to the single real equation $\operatorname{Re}S_N(t)=0$, and that, in turn, to the equality of the four pieces $P_N/2,\,P_N/2,\,M_N/2,\,M_N/2$; for $N=3$ the sign change $\operatorname{Re}S_3(5/2)<0<\operatorname{Re}S_3(0)=3$ gives a root by the intermediate value theorem; and for $N=2$ the case is exact, $\operatorname{Re}S_2(\pi/\log 2)=0$, with a *tangential* zero. **VERIFIED** by an independent auditor: 47-digit certified brackets for the smallest positive root for $N=3,\dots,50$ (102/102 checks). **PROOF-SKETCH + VERIFIED** (numerically, $N\le 200$, not proved): a root exists for every $N\ge 3$, by equidistribution of $(t\log 2,\dots,t\log N)$. **REFUTED** as strict readings: the term-level "two-and-two" partition of the terms fails at the certified roots, and $\operatorname{Re}S_N(t)=0$ is *not* the same question as the complex vanishing $S_N(t)=0$. Two earlier statements of the round were corrected and are kept visible: a first draft claimed no root exists for $N=2$, and its docstring claimed $|S_N|$ grows like $N^{1/2}$; the true growth is linear, $|S_N|\sim N/\sqrt{1+t^2}$.

## Harvested theorem-like statements

### Theorem 1

(the split is an identity, and balance is a single equation). For all $N\ge 1$ and real $t$,
$$P_N(t)+M_N(t)=\operatorname{Re}S_N(t),\qquad P_N(t)=-M_N(t)\iff \operatorname{Re}S_N(t)=0,$$
and the second is equivalent to the existence of two equal positive and two equal negative pieces that sum to the split.
**PROVED** (Lean), in `Rh43/Balance.lean`: `realPartial_eq_posRe_add_negRe`, `posRe_nonneg`, `negRe_nonpos`, `balanced_iff_realPartial_eq_zero`, `balanced_equal_split`, `equal_split_balanced`, `balanced_iff_equal_split`, and `zetaPartial_re`. The proof splits the finite sum over the two index sets on which the cosine has a strict sign; the terms with $\cos=0$ contribute $0$, so they drop out. **VERIFIED** in `zeta_split.py` §1 (see §4 here).

### Theorem 2

(equal-split form, with its necessary conjunct). `balanced_iff_equal_split` states the equivalence with the conjunct $p_1+n_1=0$ included; the source notes that without it the statement is false, with the counterexample $N=2$, $t=0$ (`not_balanced_two_zero`): the four numbers still split the two totals there, but the partial sum is not balanced. **PROVED** (Lean).

The whole question therefore reduces to the single real equation $\operatorname{Re}S_N(t)=0$. Everything below concerns that equation.

### Theorem 3

($N=1$ is degenerate). $\operatorname{Re}S_1(t)=1$ for every $t$: one positive part and no negative part, so the split has nothing to balance. **PROVED** (by definition) + **VERIFIED** in `zeta_split.py` §2. The same source records that $N=1$ is the *only* case with no negative part.

### Theorem 4

($N=2$ is balanced, exactly, at $t=\pi/\log 2$).
$$S_2(\pi/\log 2)=1+e^{-i\pi}=0,\qquad \operatorname{Re}S_2(\pi/\log 2)=1+\cos\pi=0,\qquad P_2=1,\quad M_2=-1 .$$
The zero is **tangential**: $\operatorname{Re}S_2(t)=1+\cos(t\log 2)\ge 0$ with equality exactly at $t=(2k+1)\pi/\log 2$, so a search for a *sign change* misses it. **PROVED** (Lean, `Rh43/Balance.lean`: `realPartial_two`, `realPartial_two_pi_div_log_two`, `balanced_two`, `exists_balanced_two`, `posRe_two_at_pi_div_log_two`, `negRe_two_at_pi_div_log_two`, `zetaPartial_two`, `zetaPartial_two_pi_div_log_two`) + **VERIFIED** in the script §2, and independently with 74-digit certified enclosures by the auditor (the source witnesses the smallest root as $4.5323601418271938096276829457166668$). This is the trap of the round: the smallest positive root is $\pi/\log 2$, not "none".

### Theorem 5

(explicit IVT witness at $N=3$). There is $t\in(0,5/2)$ with $\operatorname{Re}S_3(t)=0$; hence $\operatorname{balanced}(3,t)$ holds. Indeed $\operatorname{Re}S_3(t)=1+\cos(t\log 2)+\cos(t\log 3)$, $\operatorname{Re}S_3(0)=3>0$, and
$$\operatorname{Re}S_3(5/2)<0,\qquad\text{the certified value being } -0.08433575829842532\ldots$$
so continuity plus the intermediate value theorem gives a root. **PROVED** (Lean: `realPartial_three_at_zero`, `cos_two_mul_log_two_lt` ($\cos((5/2)\log 2)<-0.16$), `cos_two_mul_log_three_lt` ($\cos((5/2)\log 3)<-0.92$), `realPartial_three_five_halves_neg`, `exists_zero_realPartial_three`, `exists_realPartial_three_eq_zero`, `exists_balanced_partial_sum`), with the trigonometric bounds derived from Mathlib's `Real.log_two_gt_d9`, `Real.log_three_gt_d9`, `Real.pi_gt_d20`/`Real.pi_lt_d20`, `Real.one_sub_sq_div_two_le_cos` and `Real.sin_ge_sub_cube`; no numerical axiom is used. **VERIFIED** in the script §3, by a certified sign change of the enclosure of $\operatorname{Re}S_3$ across $[2.42,2.43]$.

### Theorem 6

(the same route at $N=4$). $\operatorname{Re}S_4(0)=4>0$ and $\operatorname{Re}S_4(12/5)=-0.950677206742\ldots<0$, so $N=4$ is balanced in $(0,12/5)$ too. **VERIFIED** (certified numerical enclosure, `zeta_split.py` §3). The ledger marks this **PROVED** (numerically certified) and notes that the Lean development currently formalises the $N=3$ witness only.

### Theorem 7

(certified root table). For every $N$ in the table there is a *sign change* of $\operatorname{Re}S_N$ on the stated rational bracket, hence a root inside it. The computation uses the `ivmath.py` engine, whose `Num` carries a value plus a guaranteed error at 400 dps ($\pi$ by Machin, $\log n=2\operatorname{atanh}((n-1)/(n+1))$ over the prime factors of $n$, $\cos$/$\sin$ by Taylor series with explicit remainder bounds), so the brackets are certificates, not estimates. **VERIFIED**.

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

### Theorem 8

(existence for every $N\ge 3$). For every $N\ge 3$ there is a real $t$ with $\operatorname{Re}S_N(t)=0$; hence a balanced split exists for every $N\ge 2$. **PROOF-SKETCH + VERIFIED numerically, not proved here.** Argument as the source gives it: $\operatorname{Re}S_N$ is continuous and $\operatorname{Re}S_N(0)=N>0$. On the other side, for a fixed $N$ the vector $(t\log 2,\dots,t\log N)$ is equidistributed on the torus as $t$ varies — the functions $t\mapsto t\log n$ are linearly independent over $\mathbb{Q}$ — so the values $\operatorname{Re}S_N(t)$ take both signs infinitely often; in particular some $t$ has $\operatorname{Re}S_N(t)<0$ (choose $t$ so that the terms of one sign dominate), and the intermediate value theorem gives a root. **VERIFIED** numerically for every $N=3,\dots,200$ (the smallest positive root is bracketed and bisected for $N\le 50$ above, and the sign of $\operatorname{Re}S_N$ is found negative for a range of heights up to $N=200$). A self-contained proof that avoids equidistribution is **OPEN** (see §5). Note carefully what Lean does and does not give here: the Lean theorem named `exists_balanced_partial_sum` states $\exists\,N\ t,\ 0<N\wedge\operatorname{balanced}N t$ — a *single* witness, obtained from the explicit $N=3$ case — not the statement for every $N$.

### Theorem 9

($N=3$ has no complex zero). For $N=3$, $S_3(t)\ne 0$ for every real $t$. **PROVED** (Lean, `Rh43.zetaPartial_three_ne_zero`): writing $x=\exp(-it\log 2)$, $y=\exp(-it\log 3)$, the equation $1+x+y=0$ forces $\cos(t\log 2)=\cos(t\log 3)=-1/2$, hence $3t\log 2,3t\log 3\in 2\pi\mathbb{Z}$; a nonzero solution would give integers $n,m\ne 0$ with $m\log 2=n\log 3$, hence $3^{|n|}=2^{|m|}$, which forces $3\mid 2$. The source reports that the axiom audit over the development returns only `propext, Classical.choice, Quot.sound`.

### Theorem 10

(why the complex picture is not the question). For $N\ge 2$ the numbers $1,2^{-it},\dots,N^{-it}$ are $\mathbb{Q}(t)$-linearly independent, so $S_N(t)=0$ is a non-degenerate algebraic relation and can hold only in degenerate configurations of log-arithmetic — as at $N=2$, where $2^{-it}=-1$ is exactly $t=(2k+1)\pi/\log 2$. **PROVED** for the linear-independence statement + **MEASURED** for $N\ge 4$: the grid minima of $|S_N|$ recorded by the script are $3.58\cdot10^{-1},3.08\cdot10^{-1},2.19\cdot10^{-3},7.75\cdot10^{-4}$ for $N=3,4,5,6$ on $[0,15]$ (the auditor's certified lower bounds); these are evidence, not proof. For $N\ge 4$ whether a real solution exists is **OPEN**.

### Theorem 11

(the blanket non-vanishing is false). $\neg\,\forall N\,t,\ S_N(t)\ne 0$, with the $N=2$ witness. **PROVED** (Lean, `not_forall_zetaPartial_ne_zero`).

### Theorem 12

(the numeric four-part split is exact). At any balance point the four numbers $P_N/2,P_N/2,M_N/2,M_N/2$ are two equal positive and two equal negative pieces: $P_N/2=|M_N|/2$ follows from $P_N=|M_N|$, and $P_N/2+P_N/2+M_N/2+M_N/2=P_N+M_N=0$. **PROVED** (trivial algebra once Theorem 1 holds; Lean `balanced_equal_split`, `equal_split_balanced`, `balanced_iff_equal_split`) + **VERIFIED** in the script §5 at $N=3$, where $P=1=|M|$ and the four pieces are $\pm1/2$.

### Theorem 13

(the term-level split fails; this is a different question). Read "two equal positive parts" as *the positive terms partition into two subsets of equal sum*, and likewise for the negative terms. Then the split does **not** exist at the certified roots. At $N=6$, $t=1.3625080873347417\ldots$: $P=1.660074847\ldots$, so $P/2=0.830037423\ldots$, while the best subset of the positive terms sums to $0.660074847\ldots$ — an exact subset-sum defect of $0.169962576\ldots$; the negative side is short of $|M|/2$ by $0.065392329\ldots$. The cause is structural: $\cos(t\log 1)=1$ is the first positive term and it exceeds $P/2$ whenever $P<2$, so $1$ can never lie in a half. At the tested roots $P$ runs $1.00,1.28,1.48,1.66,2.02,2.40,2.74$ for $N=3,4,5,6,8,10,12$, so the strict split fails at every one of them (the defect shrinks like $1/N$ but is positive at each tested root; for $N\ge 8$ it is no longer the first term that binds). **PROVED** for the structural obstruction (and for $N=3$, where the positive side is the single term $\{1\}$ and cannot be split at all) + **VERIFIED** exactly by exhaustive subset-sum over the positive and negative term sets at the certified roots. The source's list of positive-side defects is $0.5,0.358,0.262,0.170,0.0108,0.0202,0.0286$ for $N=3,4,5,6,8,10,12$.

The source records the two readings side by side so that they are not confused: the *split* (positive total against negative total) balances for every $N\ge 2$; the *term-level partition into two equal halves* does not, at the balance points. If "two-and-two" is relaxed to "any number of equal pieces", the three-piece identity $P/3+P/3+P/3=P$, $M/3+M/3+M/3=M$ with $P/3=|M|/3$ is exact, but that decomposes the totals, not the terms.

### Theorem 14.

Work with the positive terms only and ask for two **disjoint** subsets $A,B$ with $\sum A=\sum B$ (equivalently $\sum A=P/2$); no balance equation is involved. **PROOF-SKETCH + VERIFIED (15/15 checks)**, `verify/positive_only_split.py`.

* The top-level criterion is much weaker than balance: since $\cos(t\log 1)=1$ is always the largest positive term, a nonempty split needs $1\le P/2$, i.e. $P\ge 2$. That is a single *inequality*, satisfiable for every $t$ once $N$ is large enough ($N=200$, $t=0.2$: $P=127.44$), whereas the balanced split needs the exact transcendental equation $\operatorname{Re}S_N(t)=0$.
* Exact equality of two subsets needs completeness at *every* index. By Brown's criterion the subset sums of $a_1\ge a_2\ge\cdots\ge a_m$ fill $[0,P]$ exactly when $a_k\le a_{k+1}+\cdots+a_m$ for every $k$. For the positive terms the last condition is $a_m\le 0$, which always fails: the final term has nothing after it, so a gap survives and no two subsets are exactly equal.
* **MEASURED:** the greedy split (largest first, no overshoot) leaves $P/2-\sum A=4.3\cdot10^{-4}$ at $N=20,t=1/2$; $2.0\cdot10^{-2}$ at $N=20,t=1$; $4.3\cdot10^{-1}$ at $N=40,t=0.2$; $1.4\cdot10^{-2}$ at $N=60,t=2$; and only $1.0\cdot10^{-4}$, $1.5\cdot10^{-4}$ at $N=400,800$, $t=1$. The defect is small and irregular but never zero. The recorded run `logs/positive_only_split.log` carries these numbers and 15/15 checks.
* The rendered evidence `positive_only_N20.png` draws the best pair at $N=20,t=1/2$: $A=\{2,3,6,8,9,10,13,15,17\}$, $B=\{1,4,5,7,11,12,14,16,18,19,20\}$, sums $4.439862577$ and $4.439877757$ against $P/2=4.439870167$, gap $1.52\cdot10^{-5}$; the corresponding data file is `positive_only_N20.json`.
* **Caveat (the source's own).** The last-index obstruction shows the subset sums do not *fill* $[0,P]$; it does not by itself prove $P/2$ is outside the reachable set for every $N$ and $t$. Exactness would require $P/2$ to coincide with one of the finitely many subset sums — a coincidence among transcendental values. It is **REFUTED** at every tested point and **OPEN** in general. If exactness is relaxed to "within floating-point tolerance", the split always exists; the obstruction is only to *exact* equality.

### Theorem 15

(linear divergence). For every real $t$, $S_N(t)$ does not converge as $N\to\infty$ in the ordinary sense; in fact
$$\frac{|S_N(t)|}{N}\longrightarrow \frac{1}{\sqrt{1+t^2}} .$$
**PROVED** (first-order Euler summation gives $S_N=(N^{1-it}-1)/(1-it)+(1+N^{-it})/2+R_N$ with $|R_N|\le (|t|/2)\log N$, hence $|S_N|\ge N/\sqrt{1+t^2}-(|t|/2)\log N-O(1)\to\infty$) + **VERIFIED** by the auditor with certified values, at $t=1$: $|S_{10}|=7.845596$, $|S_{100}|=70.798738$, $|S_{1000}|=707.396987$, $|S_{10^4}|=7071.771405$, against $1/\sqrt2=0.70710678$, with a maximum deviation $5.44\cdot10^{-7}$ at $N=10^6$; and empirically in the script §6. The source adds the reading: the naive picture $|S_N|\sim\sqrt N$ belongs to $\operatorname{Re}(S)=1/2$, not $\operatorname{Re}(S)=0$; at $\operatorname{Re}(S)=0$ the sum grows linearly, so the partial sum of the question is necessarily a finite one.

### Theorem 16

(Im-balance existence). Split each term by the sign of its imaginary part $-\sin(t\log n)$: $J_p(t)=\sum_{\sin<0}(-\sin(t\log n))\ge 0$ and $J_m(t)=\sum_{\sin>0}(-\sin(t\log n))\le 0$. Then $\operatorname{Im}S_N(t)=J_p(t)+J_m(t)$, and the split is balanced, $J_p=|J_m|$, exactly when $\operatorname{Im}S_N(t)=0$. For every $N\ge 2$ there is $t>0$ with $\operatorname{Im}S_N(t)=0$. **PROOF-SKETCH** (conditional on Weyl equidistribution, + **VERIFIED** for $N=2,\dots,20,25,30,40,50$ by `ivmath` certificates in `im_balance.py` and `logs/im_balance.log`). The exact small cases are $N=2$: first root $t=\pi/\log 2=4.53236\ldots$, and $N=3$: first root $t=2\pi/\log 6=3.50671\ldots$, from $\operatorname{Im}S_3(t)=-2\sin(t\log 6/2)\cos(t\log(2/3)/2)$; $t=0$ is a trivial root for every $N$, so the content is the *positive* height. Certified first positive roots include $[4.53236014182719381,4.53236014182719381]$ ($N=2$), $[3.50671248852758995,3.50671248852758995]$ ($N=3$), $[2.94027481914407386,2.94027481914407386]$ ($N=4$), $[1.360292964088076,1.360292964088149]$ ($N=20$, width $7.3\cdot10^{-14}$), $[1.004896240234375,1.004896545410156]$ ($N=50$, width $3.1\cdot10^{-7}$). The two conventions differ: at $N=3$ the Im-root $3.50671\ldots$ has $\operatorname{Re}S_3=-0.515517499\ldots$, while the real-part root $2.42665\ldots$ has $\operatorname{Im}S_3=-1.451730310\ldots$. The term-level split fails here too: at the $N=6$ Im-balance height the positive imaginary terms have exact subset-sum defect $0.093688585\ldots$ and the negative ones $0.227630314\ldots$.

The source also reports Brown's criterion applied to a tail with a general abscissa $\sigma$: at $\sigma=0$ (the setting of this folder) $A_{\mathrm{pos}}$ diverges, so Brown's summability hypothesis fails and there is no summable tail; for $\sigma>1$ Brown applies, and scanning the balance roots the Im-split stays complete through a threshold near $\sigma\approx1.87$ and fails above it (the pure even/odd power budget's Brown threshold is $p^\ast=1.7286472389981836$, from $\zeta(p^\ast)=2$, recorded as **MEASURED**).

### Theorem 17

(the $N\to\infty$ asymptotic of the split). At the general abscissa $S=\sigma+it$, two identities are exact for every $N$: $P_N+|M_N|=\sum_{n\le N}n^{-\sigma}|\cos(t\log n)|$ (the additive size) and $P_N-|M_N|=\operatorname{Re}S_N(\sigma+it)$ (the signed total), hence
$$\text{relative gap}=\frac{\bigl|P_N-|M_N|\bigr|}{P_N+|M_N|}=\frac{|\operatorname{Re}S_N(\sigma+it)|}{\sum n^{-\sigma}|\cos(t\log n)|}.$$
**PROVED** (identities) + **VERIFIED** (the abscissa table below). The numerator is a cancelling sum, the denominator a non-cancelling one: for $\sigma>1$ both converge and the relative gap is $O(1)$; for $0<\sigma\le1$ the denominator is $\sim N^{1-\sigma}/(1-\sigma)$ (times a positive constant; $\sim\frac12\log N$ at $\sigma=1$) and the gap is $O(N^{-(1-\sigma)})\to0$; at $\sigma=0$ both the split and its difference grow linearly and the ratio **does not settle**. Measured at $t=14.134725$: at $\sigma=1/2$, $N=10^6$, the gap is $36.05/1284.83=0.0281$; at $\sigma=1$, $0.3577/9.899=0.0361$; at $\sigma=2$, $0.6892/1.5427=0.4467$. Measured $P_N/|M_N|$ at $t=1$: $0.042,13.0,0.26,0.40,21.3,0.10$ for $N=10^2,\dots,10^7$ — it does not settle. The source also records a **REFUTED** natural guess: $P_\infty=(\zeta(\sigma)-\operatorname{Re}\zeta(\sigma+it))/2$ fails at $\sigma=2,t=14.13$, predicting $0.478$ against the measured $1.11597$.

### Theorem 18

(the critical line $\sigma=1/2$). **PROVED** (identities, radial law) + **VERIFIED** (numerics): the partial sums converge, $S_N(1/2+it)\to\zeta(1/2+it)$, and the split obeys the radial law $P_N,|M_N|\sim\frac12\sum_{n\le N}n^{-1/2}=\sqrt N$, i.e. half the sign-blind total each; measured at $t=14.134725$, $(P_N+|M_N|)/\sqrt N=1.2602,1.2848,1.2704,1.2643$ for $N=10^5,\dots,10^8$, i.e. the constant $\int|\cos|=4/\pi=1.2732$ (each part $\sim(2/\pi)\sqrt N=0.6366\sqrt N$); fitted growth exponents of $P_N$ are $0.955,0.716,0.477,0.241,0.057,0.0002$ at $\sigma=0,0.25,0.5,0.75,1,1.5$, against the law $N^{1-\sigma}$ ($1,0.75,0.5,0.25,0,<0$). What does **not** improve (**VERIFIED**): at the first zero $t=14.134725141734693$ (where $\zeta(1/2+it)=1.2\cdot10^{-16}-7.3\cdot10^{-16}i$), $|S_N|/\sqrt N=0.0707053,0.0707037,0.0707035,0.07070353$ for $N=10^4,10^5,10^6,10^7$ — the constant $1/\sqrt{2t}=0.0707036\ldots$ — so the partial sum *grows* like $0.0707\sqrt N$ at the zero and the zero lives entirely in the cancellation $\zeta-S_N=-0.0707\sqrt N+o(\sqrt N)$; the finite-$N$ balance condition $\operatorname{Re}S_N(1/2+it)=0$ has its smallest positive root at $0.505,0.304,0.214,0.164,0.132$ for $N=10^2,\dots,10^6$, in rough agreement with the scale $1/\log N$ of the oscillation of the main term and **not** at the zeta zeros ($14.13,21.02,\dots$); the relative gap stays $\approx0.05$ ($0.055,0.074,0.00075,0.065,0.071$ for $N=10^4,\dots,10^8$). **Verdict as the source gives it:** $\sigma=1/2$ is the right abscissa for radial decay and for a convergent difference, but the bridge from this finite-$N$ split to the zeta zeros would still require a smoothing/summation step that unwinds the main term $N^{1/2+it}$ and extracts $\zeta$ to $o(1)$ accuracy; with a plain sharp cutoff the error is $O(\sqrt N)$.

## Source

[`manuscript.md`](../rh/research/publish/004-balance-equal-split/manuscript.md) · [`README.md`](../rh/research/publish/004-balance-equal-split/README.md)
