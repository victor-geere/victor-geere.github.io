# 002 — The Greedy Digit Word and the Complexity Law

| Field | Value |
|---|---|
| Source | [`research/publish/002-greedy-digit-word/manuscript.md`](../rh/research/publish/002-greedy-digit-word/manuscript.md) |
| Status | Published; truths ledger §2. |
| Harvested statements | 15 |

## Abstract

For $x\in(0,1)$ run the greedy rule that at step $n$ takes the fraction $1/(n+2)$ exactly when it fits the residual, and subtracts it if it does. The resulting infinite binary word $w(x)$ has a finite support $S=\{a_0<a_1<\dots<a_m\}$, and one asks how many distinct length-$L$ factors its length-$N$ truncation has. This paper records the answer, as proved in Lean 4 + Mathlib in this folder. **Theorem 1** gives the exact complexity law $p(L)=\min(a_m+1,N-L+1)+[\,L\le N-a_m-1\,]$ for every $L\ge a_m+1$; the printed hypothesis $L\ge a_m-a_0$ is redundant, and the two versions are both formalised. Corollaries 2–4 give the plateau $p(L)=a_m+2$, the linear decay $p(L)=N-L+1$ with $p(N-1)=2$, $p(N)=1$, and $\max_L p(L)=a_m+2$ when $N\ge 2a_m+2$. Theorem 5 gives the C1 regime $p(L)=L+1$. Six naive formulas for $p$ are refuted by explicit witnesses. The residual orbit carries the squaring law $r'/r^2=(1-f)/(1+(1-f)r)$, $f=\{1/r\}$, which yields $A(N)=\Omega_x(\log\log N)$; its matching upper bound is **OPEN**, and a two-sided squaring law is **REFUTED**. Also proved: rational termination with support $\{0,1,4\}$ for $x=1$, the exact $u$-map, the failure of the printed halting criterion as an `iff`, and the impossibility of $p(L)=cL$ for any halting alphabet.

## Harvested theorem-like statements

### Theorem 1 (complexity law; `TRUTHS.md` §1).

For $L\ge\max(\mathrm{span},a_m+1)$ (and $1\le L\le N$),

$$p(L)=\min(a_m+1,\,N-L+1)+\bigl[\,L\le N-a_m-1\,\bigr],$$

where $[\,\cdot\,]$ is $1$ if the condition holds and $0$ otherwise. Status: **PROVED (Lean)**, `Rh41.DigitWord.complexity_main_TRUTHS`.

*Proof (as carried by `ROUND-TRUTHS.md` §1 and `Rh41/DigitWord.lean`).* Let $t\in[0,N-L]$. If the window $[t,t+L-1]$ contains $a_m$, then $a_m-t\in F(t)$, and it is the **maximum** of $F(t)$: every offset is $a-t\le a_m-t$ and non-negative. Hence $F(t)=F(t')$ forces $a_m-t=a_m-t'$, i.e. $t=t'$: the map $t\mapsto F(t)$ is injective on the windows containing $a_m$. Those windows number

$$\max\bigl(0,\ \min(a_m,N-L)-\max(0,a_m-L+1)+1\bigr)=\min(a_m+1,\,N-L+1),$$

which is `Rh41.WindowCount.card_windows_containing`, proved for all $N,L,a_m$ with $1\le L\le N$ (see §4). A window that does not contain $a_m$ lies entirely to the right of $a_m$ — here $L\ge a_m+1$ is what rules out a window lying to the left, since the support starts at $a_0\ge0$ — so by `Rh41.factor_eq_empty_of_not` it meets no support point and contributes the single all-zero factor; such a window exists iff $a_m+1\le N-L$, i.e. iff $L\le N-a_m-1$. Adding the two contributions gives the formula. $\square$

**Correction 1 (redundant hypothesis).** The Lean development proves the sharper form with $L\ge a_m+1$ alone (`Rh41.DigitWord.complexity_main`); the hypothesis $L\ge\mathrm{span}$ printed in `TRUTHS.md` is **redundant** and is kept only in the restatement `complexity_main_TRUTHS` that matches the printed hypotheses. Status of the correction: **PROVED (Lean)**; recorded in `LEAN-README.md` "Corrections found while formalising" item 4.

### Corollary 2 (plateau; `TRUTHS.md` Cor. 2).

For $\max(\mathrm{span},a_m+1)\le L\le N-a_m-1$, $p(L)=a_m+2$. **PROVED (Lean)**, `Rh41.DigitWord.complexity_plateau`: in that range the indicator is $1$ and the minimum is $a_m+1$.

### Corollary 3 (decay; `TRUTHS.md` Cor. 3).

For $L\ge\max(\mathrm{span},a_m+1,N-a_m-1)$, $p(L)=N-L+1$; in particular $p(N)=1$ and $p(N-1)=2$. **PROVED (Lean)**, `Rh41.DigitWord.complexity_decay`, with the endpoints `complexity_eq_one_of_le` and `complexity_eq_two_of_pred`.

### Corollary 4 (`TRUTHS.md` Cor. 4).

If $N\ge 2a_m+2$ then $\max_{1\le L\le N}p(L)=a_m+2$. **PROVED (Lean)**, `Rh41.DigitWord.max_complexity`, resting on the general bound $p(L)\le a_m+2$ for **every** $L$ (`complexity_le_max_add_two`): there are at most $a_m+1$ windows starting at or before $a_m$, and every window starting later is empty. If $N<2a_m+2$ the plateau is empty and the maximum is smaller: for the support $\{0,\dots,199\}$ and $N=259$ (where $2a_m+2=400$) the ledger records $\max_L p(L)=60$, not $201$; this is `Rh41.DigitWord.plateau_empty_example`, proved with `native_decide`.

### Necessity of the hypothesis in Theorem 1.

The bound $L\ge a_m+1$ cannot be dropped: for the support $\{0,1\}$ at $N=2$, $L=1$ the formula reads $2$ while $p(1)=1$. **REFUTED (Lean witness)**, `Rh41.DigitWord.refuted_main_formula_all_L`.

### Theorem 5 (C1 regime; `TRUTHS.md` §1).

If

$$L\le\min\Bigl(\min_{1\le j\le m}d_j,\ a_0,\ N-a_0-1\Bigr),$$

then $p(L)=L+1$. **PROVED (Lean)**, `Rh41.DigitWord.complexity_c1`. The argument: by the gap bound a window of length $L$ contains at most one support point, so the factor is either empty or a single offset; the bounds $L\le a_0$ and $L\le N-a_0-1$ make every offset achievable at exactly one window, and $L+1$ counts the $L$ single-offset factors plus the all-zero one. **PROVED (Lean)** also: each of the three bounds is necessary, by the three witnesses `c1_bound_a0_necessary` (support $\{1\}$, $N=3$, $L=2$: $p(2)=2\ne3$), `c1_bound_gap_necessary` (the $1/\pi$ support, $L=13$ with minimum gap $11$: $p=16\ne14$), and `c1_bound_hedge_necessary` (support $\{5\}$, $N=8$, $L=4$: $p$ differs from $5$).

This is the C1 law $p(L)=L+1+\#\{j:d_j<L\}$ in the regime where the correction vanishes. Only the vanishing regime is formalised; the corrected general form is stated in the ledger and left unformalised (`LEAN-README.md`, "Not formalised").

### Theorem 6 (onset determinacy; `TRUTHS.md` §2).

$\mathrm{onset}$ is **not** determined by the pair (gap sequence, $N$): the supports $\{0,2\}$ and $\{1,3\}$ have the same gap sequence and the same truncation $N=6$, but different onsets. Status: **PROVED (Lean, `native_decide`)**, `Rh41.DigitWord.onset_not_determined_by_gaps`; the round ledger treats the same statement as **CHECKED** (3 896 of 7 521 keys $(g,N)$ multi-valued). It *is* trivially determined by $(\text{gaps},N,a_0)$, since those determine $S$; hence any formula for the onset must use absolute positions, not just the gaps.

**Correction 2 (interchanged onsets).** The example printed in `TRUTHS.md` §5 has the two onsets **interchanged**: with $N=6$ the complexity profiles are $\{0,2\}\mapsto(2,3,4,3,2,1)$ and $\{1,3\}\mapsto(2,3,3,3,2,1)$, so the onsets are $3$ and $2$, not $2$ and $3$. The corrected values are the ones computed by `rigorous_check.py::onset` and proved by `onset_not_determined_by_gaps` (`LEAN-README.md` item 1). The wrong printed values remain visible in `TRUTHS.md` §5.

### Theorem 7 (maps; `TRUTHS.md` §3).

With $u=1/r$, $q=\lceil u\rceil$, $s=q-u$,

$$u'=\frac{q^2}{s}-q,\qquad s'=1-\{q^2/s\}.$$

Status: **PROVED (Lean)**, `Rh41.Harmonic.u_map`, `Rh41.Harmonic.induced_map`; the integral case $\{q^2/s\}=0$ is exactly the terminating step and is proved separately (`induced_map_int`). The induced map on $s$ is **not** the Gauss map (max deviation $0.85$, a measurement, not formalised), so the relevant density is Lebesgue, not Gauss–Kuzmin.

### Hypotheses of Theorem 7 (correction).

The identity $u'=q^2/s-q$ requires the strict hypothesis $\frac1{n+2}<r$: at equality the residual vanishes and $s=q-1/r$ becomes $0$. Likewise $s'=1-\{q^2/s\}$ needs $\{q^2/s\}\ne0$. Both strict hypotheses are part of the formalised statements (`LEAN-README.md` item 5).

### Theorem 8 (rational termination; `TRUTHS.md` §3).

Every rational $x\in(0,1)$ terminates: the residual reaches $0$ at some finite step. Status: **PROVED (Lean)**, `Rh41.Harmonic.terminates_rat` (for $x=p/q$ with $0<p<q$), plus `terminates_of_pos_lt_one`, `terminates_from`, `residual_eventually_zero`. For $x=1$ the support is exactly $\{0,1,4\}$, since $1/2+1/3+1/6=1$ (`Rh41.Harmonic.taken_one_iff`). **CHECKED** numerically: all 277 reduced $p/q$ with $q\le30$ terminate; 275 are reached within $n\le5\cdot10^6$, and the two deepest are $4/25$ at $53\,307\,974$ and $27/29$ at $1\,003\,066\,151$ (round ledger §3; the two deep values are ledger data, beyond the cap of the script).

**Correction 3 (the vanishing index for $x=1$).** The residual for $x=1$ first vanishes at index $5$, not $3$: `residual 0 1 3 = 1/6` and `residual 0 1 5 = 0`. The support is $\{0,1,4\}$ either way. Recorded in `Rh41/GreedyResidual.lean` §7.

### Theorem 9 (halting criterion, as printed; `TRUTHS.md` §4).

For a non-increasing positive alphabet $(\alpha_n)$ and target $x$, the process halts finitely **iff** $\sum_n\alpha_n\ge x$. **Correction 4: as printed this `iff` is FALSE.** The sound statements, both formalised in `Rh41/Alphabet.lean`, are:

* if every finite partial sum is $<x$, then every index is taken, the residual equals $x-\sum_{k<n}\alpha_k$ and is $>0$ at every step, so the process never halts: `taken_all_of_bounded_partial_sums`, `never_halts_of_partial_sums_lt`, `residual_ge_sub_sum`, with the equivalent forms `partial_sums_iff` and `taken_all_of_bounded_partial_sums_mono` (the non-increasing hypothesis is kept in the `_mono` variant, not needed for this direction);
* if the residual reaches $0$ at step $N$ then $x\le\sum_{k<N}\alpha_k$: `le_sum_of_residual_eq_zero`, "the only true direction of the printed `iff`".

The inconsistency comes from two readings of "termination" in `TRUTHS.md` — the residual *hits* $0$, and the residual *tends* to $0$ — and the correction is recorded in `LEAN-README.md` item 2 with the two counterexamples: Theorem 10 row 3 has $\sum\alpha_n=\infty$ and never halts, and $\alpha_n=2^{-(n+1)}$ has $\sum\alpha_n=1=x$ with residual $2^{-n}>0$ at every finite step. For $\alpha_n=(n+2)^{-p}$, $x=1$ the printed criterion reads $\zeta(p)\ge2$, i.e. $p\le p^*$ with $p^*=1.7286472389981836181\ldots$ ($\zeta(p^*)=2$ exactly); the threshold is target-dependent, for $x=1/2$ it is the root of $\zeta(p)=3/2$, namely $p=2.18528545179$.

### Theorem 10 (structure, corrected; `TRUTHS.md` §4).

For $\alpha_n=(n+2)^{-p}$, $x=1$, $p>1$, put $S=\zeta(p)-1$. Then

| case | word | halts? | gaps |
|---|---|---|---|
| $S<1$ ($p>p^*$) | $1^\infty$ | never | all $1$ |
| $S=1$ ($p=p^*$) | $1^\infty$ | at the limit | all $1$ |
| $S>1$ ($1<p\le p^*$) | $1^{N-1}0\cdots1\,0\cdots1\cdots$ | **never** | **unbounded** |

*Proof of the third row (round ledger §4).* After the initial segment ends at $N=\min\{n:\sum_{k<n}\alpha_k\ge1\}$, the residual $r=1-\sum_{k<N-1}\alpha_k$ is a fixed positive number while $\alpha_k\to0$; so $\{k:\alpha_k\le r\}$ is an infinite tail, every member of it is taken, and the residual never reaches $0$. $\square$

**Correction 5 (missing hypothesis in row 3).** "The residual never reaches $0$" is not automatic: row 3 needs the extra hypothesis "no finite sub-sum of the alphabet equals $x$". `Rh41.Alphabet.never_halts_of_tendsto_zero` states the theorem with that hypothesis explicit, and `powerAlpha_never_halts` / `powerAlpha_infinitely_many_taken` specialise it to $\alpha_n=(n+2)^{-p}$; for that family the hypothesis holds because the sub-sums are irrational (`LEAN-README.md` item 3), a fact the ledger notes is **not formalised**. Concretely for $p=3/2$ the taken set is $\{0,\dots,8,34,954,77716,\dots\}$ with maximum gap $76\,762$.

### Theorem 11 (dichotomy false; `TRUTHS.md` §4).

$\alpha_n=2^{-(n+1)}$, $x=1$ selects **every** index (gaps all $1$) and its residual is exactly $(1/2)^n$, which tends to $0$. Hence "bounded gaps OR exact termination, never both" is false. Status: **PROVED (Lean)**, `Rh41.Alphabet.expAlpha_bounded_gaps_and_termination`, `expAlpha_support_univ`, `expAlpha_residual`, `expAlpha_residual_tendsto_zero`; the residual is **positive at every finite step** (`expAlpha_residual_pos`), so "terminates exactly" is formalised as convergence to $0$, not finite termination (`LEAN-README.md` item 2).

### Theorem 12 (inverse problem, impossibility half; `TRUTHS.md` §4).

Any alphabet with $\sum\alpha_n\ge x$ halts (subject to Correction 4/5) and therefore has finitely many ones. By Corollary 4 its complexity satisfies $\max_L p(L)=a_m+2$, a number; hence **no halting alphabet realises $p(L)=cL$** for any $c>0$, and in particular not the Sturmian profile $p(L)=L+1$. Exact termination and linear complexity growth are impossible. Status: **PROVED (Lean)**, `Rh41.Alphabet.no_linear_complexity_of_halting` and the finite-support forms `max_complexity_of_finite_support`, `no_linear_complexity_of_finite_support`, `no_sturmian_complexity_of_finite_support`; and process-independently `Rh41.Impossibility.no_linear_growth`, `no_affine_profile`, `no_sturmian_profile`.

### Correction 6 (literal phrasing of Theorem 12).

"For every $c>0$ there is $L$ with $p(L)<cL$" is false for a *fixed* truncation $N$ once $cN\le a_m+2$. The correct formalised version is `Impossibility.no_linear_growth`: for every $c>0$ there are $N$ and $L$ with $1\le L\le N$ and $p(L)<cL$ — the truncation is part of the data and may grow with $L$. `no_affine_profile` and `no_sturmian_profile` are the resulting impossibilities (`LEAN-README.md` item 6).

**Open.** Non-monotone alphabets, where the taken set need not be an initial segment and richer profiles may occur (round ledger §4; untouched).

## Source

[`manuscript.md`](../rh/research/publish/002-greedy-digit-word/manuscript.md) · [`README.md`](../rh/research/publish/002-greedy-digit-word/README.md)
