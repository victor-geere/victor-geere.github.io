# The greedy digit word and the complexity law

**First published edition, packaged from `research/truths.md` §2 (round `rh41`). This folder contains no HTML paper: the ledgers `TRUTHS.md` (the item, with its statuses and Lean pointers) and `ROUND-TRUTHS.md` (the round's prose ledger) are the source, and the Lean development under `Rh41/` plus the Python scripts are the evidence. This edition does not prove the twin prime conjecture; nothing here is a step toward it.**

## Abstract

For $x\in(0,1)$ run the greedy rule that at step $n$ takes the fraction $1/(n+2)$ exactly when it fits the residual, and subtracts it if it does. The resulting infinite binary word $w(x)$ has a finite support $S=\{a_0<a_1<\dots<a_m\}$, and one asks how many distinct length-$L$ factors its length-$N$ truncation has. This paper records the answer, as proved in Lean 4 + Mathlib in this folder. **Theorem 1** gives the exact complexity law $p(L)=\min(a_m+1,N-L+1)+[\,L\le N-a_m-1\,]$ for every $L\ge a_m+1$; the printed hypothesis $L\ge a_m-a_0$ is redundant, and the two versions are both formalised. Corollaries 2–4 give the plateau $p(L)=a_m+2$, the linear decay $p(L)=N-L+1$ with $p(N-1)=2$, $p(N)=1$, and $\max_L p(L)=a_m+2$ when $N\ge 2a_m+2$. Theorem 5 gives the C1 regime $p(L)=L+1$. Six naive formulas for $p$ are refuted by explicit witnesses. The residual orbit carries the squaring law $r'/r^2=(1-f)/(1+(1-f)r)$, $f=\{1/r\}$, which yields $A(N)=\Omega_x(\log\log N)$; its matching upper bound is **OPEN**, and a two-sided squaring law is **REFUTED**. Also proved: rational termination with support $\{0,1,4\}$ for $x=1$, the exact $u$-map, the failure of the printed halting criterion as an `iff`, and the impossibility of $p(L)=cL$ for any halting alphabet.

## 1. Introduction and goal

The programme studies a greedy splitting of a target into unit fractions, and asks how complex the resulting $\{0,1\}$-word is. Complexity here is the number

$$p(L)=\#\{\text{distinct length-}L\text{ factors of }w\},$$

computed over a fixed truncation length $N$. The quantity decides whether the greedy word can carry a Sturmian-like description: Sturmian words are exactly the words with $p(L)=L+1$ for all $L$, and the question is whether the greedy word is of that kind. The folder answers the factor-count question completely for one point of the regime ($L\ge a_m+1$), answers it in the opposite short-window regime (Theorem 5, the *C1 regime*), and closes the Sturmian route negatively (Theorem 12). It also records the structure of the residual orbit that generates the support, because that orbit controls how fast the support grows, and the growth question ($A(N)=O(\log\log N)$?) is left open.

In scope: the factor count of the greedy word, its corollaries, the onset question, the residual orbit and its maps, general alphabets and the inverse (complexity-from-alphabet) problem. Out of scope: anything about twin primes; any claim not carried by the ledgers reproduced in this folder.

## 2. Setup and definitions

**The greedy word.** Fix $x$ with $0<x<1$ and put $r_0=x$. At step $n=0,1,2,\dots$ the rule is

$$r_{n+1}=r_n-\frac{1}{n+2}\quad\text{if } r_n\ge \frac{1}{n+2},\qquad r_{n+1}=r_n \quad\text{otherwise},$$

and the word is $w(x)=\delta_0\delta_1\delta_2\cdots$ with $\delta_n=1$ exactly when the subtraction happened. The *support* is $S=\{n:\delta_n=1\}$; ledger `ROUND-TRUTHS.md` §3 states that for rational $x$ this set is finite, so write

$$S=\{a_0<a_1<\dots<a_m\},\qquad a_m=\max S,\qquad a_0=\min S,$$

and let $\mathrm{span}=a_m-a_0$. Throughout, the word is truncated at length $N$, i.e. only positions $0,\dots,N-1$ are read; the support sits inside the truncation, $S\subseteq\{0,\dots,N-1\}$, so $a_m<N$.

**Factors.** For a window start $t$ and length $L$, the *factor* is the offset set

$$F(t)=\{\,a-t:\ a\in S,\ t\le a\le t+L-1\,\}\subseteq\{0,\dots,L-1\},$$

and the *complexity* is

$$p(L)=\#\{\,F(t):\ 0\le t\le N-L\,\}.$$

This is the definition of record of the folder: factors are offset **sets**, not bit strings; two windows give the same factor exactly when these sets agree, and the all-zero factor counts once however many windows realise it. The Python ground truth (`digitword.py`) and the Lean definition `Rh41.complexity` both implement this definition. The naive alternative — counting bit-string factors of the indicator word — agrees with it, and that agreement is itself proved (`Rh41.complexity_eq_bitComplexity`, claim A1; 59 267 checked cases in the round ledger).

**Gaps and the extended support.** The consecutive gaps are $d_j=a_j-a_{j-1}$ for $1\le j\le m$. The extended support is the list $[-1]+S+[N]$; its consecutive gaps are $a_0+1$, the $d_j$, and $N-a_m$.

**The onset.** $\mathrm{onset}(w)=\min\{L: p(L)=\max_{1\le L'\le N}p(L'\})$; the Lean predicate `Rh41.IsOnset` is the least $L\ge1$ at which $p$ attains its maximum over $[1,N]$.

**The residual orbit.** Two derived quantities recur: $u=1/r$ and, for $q=\lceil u\rceil$, the *gap to the next integer* $s=q-u$; the *fractional-part bookkeeping* is $f=\{1/r\}$. The counting function of the support is

$$A(N)=\#\{k:\ n_k\le N\},$$

where $n_0<n_1<\dots$ are the indices of the original construction (the taken denominators), and $r_k$ is the residual at those indices.

**Normalisation.** All statements below are about a support-with-truncation pair $(S,N)$ as above, or about the greedy word of a target $x\in(0,1)$; no other normalisation is used. The $\Omega_x$ notation always means "with a constant depending on $x$".

## 3. Results

Statuses are those of `TRUTHS.md` and `ROUND-TRUTHS.md`: **PROVED (Lean)** means machine-checked in this folder's Lean development; **VERIFIED** means recomputed by a script in this folder; **CHECKED** means exhaustively verified over a stated finite class. Where the Lean development corrected a printed statement, both the printed form and the correction are kept visible.

### 3.1 The complexity law — PROVED (Lean)

**Theorem 1 (complexity law; `TRUTHS.md` §1).** For $L\ge\max(\mathrm{span},a_m+1)$ (and $1\le L\le N$),

$$p(L)=\min(a_m+1,\,N-L+1)+\bigl[\,L\le N-a_m-1\,\bigr],$$

where $[\,\cdot\,]$ is $1$ if the condition holds and $0$ otherwise. Status: **PROVED (Lean)**, `Rh41.DigitWord.complexity_main_TRUTHS`.

*Proof (as carried by `ROUND-TRUTHS.md` §1 and `Rh41/DigitWord.lean`).* Let $t\in[0,N-L]$. If the window $[t,t+L-1]$ contains $a_m$, then $a_m-t\in F(t)$, and it is the **maximum** of $F(t)$: every offset is $a-t\le a_m-t$ and non-negative. Hence $F(t)=F(t')$ forces $a_m-t=a_m-t'$, i.e. $t=t'$: the map $t\mapsto F(t)$ is injective on the windows containing $a_m$. Those windows number

$$\max\bigl(0,\ \min(a_m,N-L)-\max(0,a_m-L+1)+1\bigr)=\min(a_m+1,\,N-L+1),$$

which is `Rh41.WindowCount.card_windows_containing`, proved for all $N,L,a_m$ with $1\le L\le N$ (see §4). A window that does not contain $a_m$ lies entirely to the right of $a_m$ — here $L\ge a_m+1$ is what rules out a window lying to the left, since the support starts at $a_0\ge0$ — so by `Rh41.factor_eq_empty_of_not` it meets no support point and contributes the single all-zero factor; such a window exists iff $a_m+1\le N-L$, i.e. iff $L\le N-a_m-1$. Adding the two contributions gives the formula. $\square$

**Correction 1 (redundant hypothesis).** The Lean development proves the sharper form with $L\ge a_m+1$ alone (`Rh41.DigitWord.complexity_main`); the hypothesis $L\ge\mathrm{span}$ printed in `TRUTHS.md` is **redundant** and is kept only in the restatement `complexity_main_TRUTHS` that matches the printed hypotheses. Status of the correction: **PROVED (Lean)**; recorded in `LEAN-README.md` "Corrections found while formalising" item 4.

**Corollary 2 (plateau; `TRUTHS.md` Cor. 2).** For $\max(\mathrm{span},a_m+1)\le L\le N-a_m-1$, $p(L)=a_m+2$. **PROVED (Lean)**, `Rh41.DigitWord.complexity_plateau`: in that range the indicator is $1$ and the minimum is $a_m+1$.

**Corollary 3 (decay; `TRUTHS.md` Cor. 3).** For $L\ge\max(\mathrm{span},a_m+1,N-a_m-1)$, $p(L)=N-L+1$; in particular $p(N)=1$ and $p(N-1)=2$. **PROVED (Lean)**, `Rh41.DigitWord.complexity_decay`, with the endpoints `complexity_eq_one_of_le` and `complexity_eq_two_of_pred`.

**Corollary 4 (`TRUTHS.md` Cor. 4).** If $N\ge 2a_m+2$ then $\max_{1\le L\le N}p(L)=a_m+2$. **PROVED (Lean)**, `Rh41.DigitWord.max_complexity`, resting on the general bound $p(L)\le a_m+2$ for **every** $L$ (`complexity_le_max_add_two`): there are at most $a_m+1$ windows starting at or before $a_m$, and every window starting later is empty. If $N<2a_m+2$ the plateau is empty and the maximum is smaller: for the support $\{0,\dots,199\}$ and $N=259$ (where $2a_m+2=400$) the ledger records $\max_L p(L)=60$, not $201$; this is `Rh41.DigitWord.plateau_empty_example`, proved with `native_decide`.

**Necessity of the hypothesis in Theorem 1.** The bound $L\ge a_m+1$ cannot be dropped: for the support $\{0,1\}$ at $N=2$, $L=1$ the formula reads $2$ while $p(1)=1$. **REFUTED (Lean witness)**, `Rh41.DigitWord.refuted_main_formula_all_L`.

### 3.2 The short-window (C1) regime — PROVED (Lean)

**Theorem 5 (C1 regime; `TRUTHS.md` §1).** If

$$L\le\min\Bigl(\min_{1\le j\le m}d_j,\ a_0,\ N-a_0-1\Bigr),$$

then $p(L)=L+1$. **PROVED (Lean)**, `Rh41.DigitWord.complexity_c1`. The argument: by the gap bound a window of length $L$ contains at most one support point, so the factor is either empty or a single offset; the bounds $L\le a_0$ and $L\le N-a_0-1$ make every offset achievable at exactly one window, and $L+1$ counts the $L$ single-offset factors plus the all-zero one. **PROVED (Lean)** also: each of the three bounds is necessary, by the three witnesses `c1_bound_a0_necessary` (support $\{1\}$, $N=3$, $L=2$: $p(2)=2\ne3$), `c1_bound_gap_necessary` (the $1/\pi$ support, $L=13$ with minimum gap $11$: $p=16\ne14$), and `c1_bound_hedge_necessary` (support $\{5\}$, $N=8$, $L=4$: $p$ differs from $5$).

This is the C1 law $p(L)=L+1+\#\{j:d_j<L\}$ in the regime where the correction vanishes. Only the vanishing regime is formalised; the corrected general form is stated in the ledger and left unformalised (`LEAN-README.md`, "Not formalised").

### 3.3 Auxiliary structure — PROVED (Lean), previously CHECKED

**All-zero factor (claim A2).** The all-zero factor occurs **iff** some gap of the extended support — between consecutive support points, before the first, or after the last — is $\ge L+1$. Round ledger status **CHECKED** over 95 835 cases; the Lean development upgrades it to **PROVED** for all supports, truncations and window lengths (`Rh41.AllZero.allZero_iff_hasLargeGap`, with the shifted extended support $\{0\}\cup\{s+1:s\in S\}\cup\{N+1\}$).

**Window count (`TRUTHS.md` §2).** For $1\le L\le N$,

$$\#\{t:\ t\le a_m\le t+L-1\}=\max\bigl(0,\ \min(a_m,N-L)-\max(0,a_m-L+1)+1\bigr).$$

Round ledger status **CHECKED** over 25 044 603 cases; **PROVED (Lean)** for all $N,L,a_m$ (`Rh41.WindowCount.card_windows_containing`), stated in $\mathbb{Z}$ to match the Python arithmetic.

**Offset sets versus bit strings (claim A1).** The offset-tuple count equals the bit-string factor count, for every support and every $1\le L\le N$. Round ledger status **CHECKED** (59 267 cases, all words of length $\le14$); **PROVED (Lean)** via the explicit bijection `toBit`/`bitFactor` (`Rh41.DigitWord.complexity_eq_bitComplexity`).

**Theorem 6 (onset determinacy; `TRUTHS.md` §2).** $\mathrm{onset}$ is **not** determined by the pair (gap sequence, $N$): the supports $\{0,2\}$ and $\{1,3\}$ have the same gap sequence and the same truncation $N=6$, but different onsets. Status: **PROVED (Lean, `native_decide`)**, `Rh41.DigitWord.onset_not_determined_by_gaps`; the round ledger treats the same statement as **CHECKED** (3 896 of 7 521 keys $(g,N)$ multi-valued). It *is* trivially determined by $(\text{gaps},N,a_0)$, since those determine $S$; hence any formula for the onset must use absolute positions, not just the gaps.

**Correction 2 (interchanged onsets).** The example printed in `TRUTHS.md` §5 has the two onsets **interchanged**: with $N=6$ the complexity profiles are $\{0,2\}\mapsto(2,3,4,3,2,1)$ and $\{1,3\}\mapsto(2,3,3,3,2,1)$, so the onsets are $3$ and $2$, not $2$ and $3$. The corrected values are the ones computed by `rigorous_check.py::onset` and proved by `onset_not_determined_by_gaps` (`LEAN-README.md` item 1). The wrong printed values remain visible in `TRUTHS.md` §5.

### 3.4 The residual orbit — PROVED (Lean) and CHECKED

**Squaring law (`TRUTHS.md` §3).** At an active step with $\frac{1}{n+2}\le r<\frac1{n+1}$, and $f=\{1/r\}=1/r-(n+1)$,

$$\frac{r-\frac{1}{n+2}}{r^2}=\frac{1-f}{1+(1-f)r},\qquad\text{hence}\qquad r_{k+1}\le r_k^2 .$$

Status: **CHECKED** in the round ledger (max observed ratio $0.993905$); **PROVED (Lean)** as the exact identity `Rh41.Harmonic.squaring_identity` and the inequality `Rh41.Harmonic.squaring_law`. Consequence: $n_k\le(1/x)^{2^{k-1}}+1$ for $k\ge2$, hence

$$A(N)=\#\{k: n_k\le N\}=\Omega_x(\log\log N).$$

The ledger records the passage to logarithms as not formalised: the inequality is, the asymptotic statement is not.

**Squaring law: the sharp half — REFUTED as a two-sided law.** $r'/r^2$ has **no positive lower bound**: for every $\varepsilon>0$ there is an active step with $r'/r^2<\varepsilon$ (witness $r=1/2+1/m$, $n=0$). Status: **PROVED (Lean)**, `Rh41.Harmonic.no_positive_lower_bound`; **CHECKED** numerically in the round ledger (minimum $1.58\cdot10^{-4}$ over 4 000 exact rational orbits), and the refuted-list row is explicit: "the residual-orbit average has a limit independent of $x$" fails, since $q_0=4$, $q_{k+1}=2q_k^2$ gives limit $\log(1/2)=-0.6931\ldots$, not $-1$. Consequently no two-sided law $c\,r_k^2\le r_{k+1}\le r_k^2$ with $c>0$ exists, and the matching upper bound $A(N)=O(\log\log N)$ is **OPEN**.

**Theorem 7 (maps; `TRUTHS.md` §3).** With $u=1/r$, $q=\lceil u\rceil$, $s=q-u$,

$$u'=\frac{q^2}{s}-q,\qquad s'=1-\{q^2/s\}.$$

Status: **PROVED (Lean)**, `Rh41.Harmonic.u_map`, `Rh41.Harmonic.induced_map`; the integral case $\{q^2/s\}=0$ is exactly the terminating step and is proved separately (`induced_map_int`). The induced map on $s$ is **not** the Gauss map (max deviation $0.85$, a measurement, not formalised), so the relevant density is Lebesgue, not Gauss–Kuzmin.

**Hypotheses of Theorem 7 (correction).** The identity $u'=q^2/s-q$ requires the strict hypothesis $\frac1{n+2}<r$: at equality the residual vanishes and $s=q-1/r$ becomes $0$. Likewise $s'=1-\{q^2/s\}$ needs $\{q^2/s\}\ne0$. Both strict hypotheses are part of the formalised statements (`LEAN-README.md` item 5).

**Theorem 8 (rational termination; `TRUTHS.md` §3).** Every rational $x\in(0,1)$ terminates: the residual reaches $0$ at some finite step. Status: **PROVED (Lean)**, `Rh41.Harmonic.terminates_rat` (for $x=p/q$ with $0<p<q$), plus `terminates_of_pos_lt_one`, `terminates_from`, `residual_eventually_zero`. For $x=1$ the support is exactly $\{0,1,4\}$, since $1/2+1/3+1/6=1$ (`Rh41.Harmonic.taken_one_iff`). **CHECKED** numerically: all 277 reduced $p/q$ with $q\le30$ terminate; 275 are reached within $n\le5\cdot10^6$, and the two deepest are $4/25$ at $53\,307\,974$ and $27/29$ at $1\,003\,066\,151$ (round ledger §3; the two deep values are ledger data, beyond the cap of the script).

**Correction 3 (the vanishing index for $x=1$).** The residual for $x=1$ first vanishes at index $5$, not $3$: `residual 0 1 3 = 1/6` and `residual 0 1 5 = 0`. The support is $\{0,1,4\}$ either way. Recorded in `Rh41/GreedyResidual.lean` §7.

### 3.5 Alphabets and the inverse problem — PROVED (Lean), with three corrections

**Theorem 9 (halting criterion, as printed; `TRUTHS.md` §4).** For a non-increasing positive alphabet $(\alpha_n)$ and target $x$, the process halts finitely **iff** $\sum_n\alpha_n\ge x$. **Correction 4: as printed this `iff` is FALSE.** The sound statements, both formalised in `Rh41/Alphabet.lean`, are:

* if every finite partial sum is $<x$, then every index is taken, the residual equals $x-\sum_{k<n}\alpha_k$ and is $>0$ at every step, so the process never halts: `taken_all_of_bounded_partial_sums`, `never_halts_of_partial_sums_lt`, `residual_ge_sub_sum`, with the equivalent forms `partial_sums_iff` and `taken_all_of_bounded_partial_sums_mono` (the non-increasing hypothesis is kept in the `_mono` variant, not needed for this direction);
* if the residual reaches $0$ at step $N$ then $x\le\sum_{k<N}\alpha_k$: `le_sum_of_residual_eq_zero`, "the only true direction of the printed `iff`".

The inconsistency comes from two readings of "termination" in `TRUTHS.md` — the residual *hits* $0$, and the residual *tends* to $0$ — and the correction is recorded in `LEAN-README.md` item 2 with the two counterexamples: Theorem 10 row 3 has $\sum\alpha_n=\infty$ and never halts, and $\alpha_n=2^{-(n+1)}$ has $\sum\alpha_n=1=x$ with residual $2^{-n}>0$ at every finite step. For $\alpha_n=(n+2)^{-p}$, $x=1$ the printed criterion reads $\zeta(p)\ge2$, i.e. $p\le p^*$ with $p^*=1.7286472389981836181\ldots$ ($\zeta(p^*)=2$ exactly); the threshold is target-dependent, for $x=1/2$ it is the root of $\zeta(p)=3/2$, namely $p=2.18528545179$.

**Theorem 10 (structure, corrected; `TRUTHS.md` §4).** For $\alpha_n=(n+2)^{-p}$, $x=1$, $p>1$, put $S=\zeta(p)-1$. Then

| case | word | halts? | gaps |
|---|---|---|---|
| $S<1$ ($p>p^*$) | $1^\infty$ | never | all $1$ |
| $S=1$ ($p=p^*$) | $1^\infty$ | at the limit | all $1$ |
| $S>1$ ($1<p\le p^*$) | $1^{N-1}0\cdots1\,0\cdots1\cdots$ | **never** | **unbounded** |

*Proof of the third row (round ledger §4).* After the initial segment ends at $N=\min\{n:\sum_{k<n}\alpha_k\ge1\}$, the residual $r=1-\sum_{k<N-1}\alpha_k$ is a fixed positive number while $\alpha_k\to0$; so $\{k:\alpha_k\le r\}$ is an infinite tail, every member of it is taken, and the residual never reaches $0$. $\square$

**Correction 5 (missing hypothesis in row 3).** "The residual never reaches $0$" is not automatic: row 3 needs the extra hypothesis "no finite sub-sum of the alphabet equals $x$". `Rh41.Alphabet.never_halts_of_tendsto_zero` states the theorem with that hypothesis explicit, and `powerAlpha_never_halts` / `powerAlpha_infinitely_many_taken` specialise it to $\alpha_n=(n+2)^{-p}$; for that family the hypothesis holds because the sub-sums are irrational (`LEAN-README.md` item 3), a fact the ledger notes is **not formalised**. Concretely for $p=3/2$ the taken set is $\{0,\dots,8,34,954,77716,\dots\}$ with maximum gap $76\,762$.

**Theorem 11 (dichotomy false; `TRUTHS.md` §4).** $\alpha_n=2^{-(n+1)}$, $x=1$ selects **every** index (gaps all $1$) and its residual is exactly $(1/2)^n$, which tends to $0$. Hence "bounded gaps OR exact termination, never both" is false. Status: **PROVED (Lean)**, `Rh41.Alphabet.expAlpha_bounded_gaps_and_termination`, `expAlpha_support_univ`, `expAlpha_residual`, `expAlpha_residual_tendsto_zero`; the residual is **positive at every finite step** (`expAlpha_residual_pos`), so "terminates exactly" is formalised as convergence to $0$, not finite termination (`LEAN-README.md` item 2).

**Theorem 12 (inverse problem, impossibility half; `TRUTHS.md` §4).** Any alphabet with $\sum\alpha_n\ge x$ halts (subject to Correction 4/5) and therefore has finitely many ones. By Corollary 4 its complexity satisfies $\max_L p(L)=a_m+2$, a number; hence **no halting alphabet realises $p(L)=cL$** for any $c>0$, and in particular not the Sturmian profile $p(L)=L+1$. Exact termination and linear complexity growth are impossible. Status: **PROVED (Lean)**, `Rh41.Alphabet.no_linear_complexity_of_halting` and the finite-support forms `max_complexity_of_finite_support`, `no_linear_complexity_of_finite_support`, `no_sturmian_complexity_of_finite_support`; and process-independently `Rh41.Impossibility.no_linear_growth`, `no_affine_profile`, `no_sturmian_profile`.

**Correction 6 (literal phrasing of Theorem 12).** "For every $c>0$ there is $L$ with $p(L)<cL$" is false for a *fixed* truncation $N$ once $cN\le a_m+2$. The correct formalised version is `Impossibility.no_linear_growth`: for every $c>0$ there are $N$ and $L$ with $1\le L\le N$ and $p(L)<cL$ — the truncation is part of the data and may grow with $L$. `no_affine_profile` and `no_sturmian_profile` are the resulting impossibilities (`LEAN-README.md` item 6).

**Open.** Non-monotone alphabets, where the taken set need not be an initial segment and richer profiles may occur (round ledger §4; untouched).

### 3.6 Refuted formulas — REFUTED (Lean witnesses)

The six naive complexity formulas of `TRUTHS.md` §5 are refuted with explicit witnesses, all machine-checked:

| statement | witness | Lean |
|---|---|---|
| $p(L)=\min(a_m+1,N-L+1)+[L\le N-a_m-1]$ for **all** $L$ | $S=\{0,1\}$, $N=2$, $L=1$: formula $2$, truth $1$ | `refuted_main_formula_all_L` |
| $p(L)=L+1+\#\{\text{pairs at distance}\le L\}$ | $1/\pi$, $L=11$: $13$ vs $12$ | `refuted_pair_count_formula` |
| $p(L)=L+1+\#\{\text{distinct distances}\le L\}$ | $1/\pi$, $L=11$: $13$ vs $12$ | `refuted_dist_count_formula` |
| $p(L)=L+1+\sum_j\max(0,L-d_j)$ | $1/\pi$, $L=20$: $30$ vs $24$ | `refuted_gap_deficit_formula` |
| $p(L)=2L-10$ on $12\le L\le593$ | $1/\pi$, $L=100$: $190$ vs $104$ | `refuted_slope_formula` |
| $p(L)=\min(L+\mathrm{span},N-L+1)$ | $S=\{139,151\}$, $N=172$, $L=13$: $25$ vs $15$ | `refuted_span_formula` |

The ledger's remaining refuted rows, recorded but not formalised: the first-difference identity with a left-special correction (the left-special count is $0$ throughout; the correct correction is the count of length-$L$ factors with no right extension); "$\sum_j|\text{intervals}|$ counts the factors" (the intervals overlap); the residual-orbit average limit (see §3.4); $A(N)=\log_2\log N+O(1)$ with an explicit constant; the bounded-gap claim for $\alpha_n=(n+2)^{-3/2}$ (max gap $76\,762$); the dichotomy of Theorem 11; and the onset-as-a-function-of-gaps claim.

## 4. Verification and evidence

Two layers: (i) the Lean development, which is the proof layer, and (ii) the Python scripts, which are the statement-shape and numerical layer. Below, "**observed**" reports the actual output of a run performed while preparing this manuscript; "**recorded**" reports a log or figure that exists in the folder but which this manuscript does not itself re-run.

### 4.1 What each artefact checks

| artefact | checks | status |
|---|---|---|
| `Rh41/DigitWord.lean` | Theorem 1 and `complexity_main_TRUTHS`, Corollaries 2–4, the general bound $p\le a_m+2$, Theorem 5 and its three necessity witnesses, claim A1, Theorem 6, the six refuted formulas, the empty-plateau example | PROVED (Lean) |
| `Rh41/AllZero.lean` | claim A2, all-zero factor iff an extended gap $\ge L+1$ | PROVED (Lean) |
| `Rh41/WindowCount.lean` | the exact window count | PROVED (Lean, in $\mathbb{Z}$) |
| `Rh41/Impossibility.lean` | Theorem 12's process-independent core: no linear, affine or Sturmian profile from a finite support | PROVED (Lean) |
| `Rh41/GreedyResidual.lean` | Theorems 7, 8, the squaring identity and law, `no_positive_lower_bound`, the residual invariant, support $\{0,1,4\}$ for $x=1$ | PROVED (Lean) |
| `Rh41/Alphabet.lean` | Theorem 9's true directions, Theorems 10–12, the exponential alphabet | PROVED (Lean) |
| `rigorous_check.py` | the ledger's numerical claims re-derived from scratch, exact arithmetic or mpmath | script, 31 checks |
| `crosscheck.py` | the Lean *statement shapes* against the Python reference (1 969 905 cases) | script |
| `digitword.py` | reference implementation; reproduces the $1/\pi$ values of `TRUTHS.md` §5 | script |
| `check.sh` | elaborates the Lean development against Lean 4 + Mathlib | build script |

### 4.2 Commands, and what was observed

```sh
python3 digitword.py
```

**Observed** (run in this folder): exit status `0`, 18 stdout lines, for example

```
[OK ] L=  11 p=  12 (expected 12, bruteforce 12)
[OK ] L= 593 p= 597 (expected 597, bruteforce 597)
piecewise slopes: [(1, 10, 1), (11, 13, 2), (14, 604, 1), (605, 791, 0), (792, 1399, -1)]
all §3.1 values reproduce: True
```

```sh
python3 rigorous_check.py
```

**Observed** (run in this folder): exit status `0`, wall time about eight minutes, 31 checks, summary line `ALL 31 CHECKS PASS`, and no `FAIL` line. Representative lines, verbatim:

```
  PASS  A2 all-zero factor iff some extended gap >= L+1   [95835 cases, 0 mismatches]
  PASS  B2 #{windows containing a_m} = max(0, min(a_m,N-L) - max(0,a_m-L+1) + 1), all L   [25044603 cases]
  PASS  B3 THEOREM A: p(L) = min(a_m+1,N-L+1) + [L <= N-a_m-1] for L >= max(span, a_m+1)   [2006696 cases]
  PASS  C1 THEOREM D: p(L) = L+1 for L <= min(min gap, a_0, N-a_0-1)   [572191 cases]
  PASS  D1 onset is NOT a function of (gaps, N)   [3896 of 7521 keys multi-valued]
  PASS  E1 r_{k+1} <= r_k^2 ...   [max ratio r'/r^2 = 0.993905]
  PASS  E3 r'/r^2 has no positive lower bound (min << 1)   [min over 4000 exact rationals = 0.0001576]
  PASS  F3 the induced map is NOT the Gauss map   [max |f' - {1/f}| = 0.8519]
  PASS  G2 alpha_n=(n+2)^-3/2, x=1: gaps are NOT all 1 (max gap > 100)   [taken [0, 1, 2, 3, 4, 5, 6, 7, 8, 34, 954, 77716]..., max gap 76762]
  PASS  G4 p* solves zeta(p*)=2   [p* = 1.7286472389981836181]
  PASS  G5 target-dependence: x=1/2 needs zeta(p)=3/2, p = 2.18528545179
  PASS  I1 every reduced p/q with q<=30 terminates (cap 5e6, 275 reached)   [275 of 277 within the cap]
  ALL 31 CHECKS PASS
```

This matches the round ledger's "run it, 31/31 pass" (`ROUND-TRUTHS.md` §0) exactly. The script checks, among others: the definition of record and the offset-tuple/bit-string agreement; the plateau, decay and maximum statements; the C1 regime and the necessity of each of its three bounds; the onset counts `3896 of 7521`; the squaring ratio (max `0.993905`) and the absence of a positive lower bound; the $u$-map and induced map on exact rationals; the $\{0,1,4\}$ support for $x=1$; the halting census (275 of 277 reduced fractions with $q\le30$ reached within the $5\cdot10^6$ cap); and the inverse-problem statements.

```sh
LEAN_PREFIX=$HOME/lean ./check.sh --all
```

**Observed while preparing this manuscript**: exit status `0`, wall time about thirteen minutes, one `[check] OK` line per file, no `FAIL` line:

```
[check] OK   Rh41/DigitWord.lean (178s)
[check] OK   Rh41/AllZero.lean (173s)
[check] OK   Rh41/WindowCount.lean (118s)
[check] OK   Rh41/Impossibility.lean (99s)
[check] OK   Rh41/GreedyResidual.lean (76s)
[check] OK   Rh41/Alphabet.lean (79s)
[check] OK   Rh41.lean (65s)
exit=0
```

Against toolchain `leanprover/lean4:v4.35.0-rc2`; the `LEAN-README.md` guide of "roughly three minutes" presumably assumes a warm Mathlib and was not the timing observed here. A partial invocation demonstrates the build-order requirement: `./check.sh Rh41/AllZero.lean` alone failed with exit `1` and the message

```
Rh41/AllZero.lean:15:0: error: object file '.../Rh41/DigitWord.olean' of module Rh41.DigitWord does not exist
[check] FAIL Rh41/AllZero.lean
```

because `AllZero.lean` imports `Rh41.DigitWord` and the `.olean` had not been built. Run `--all` (the list `DigitWord, AllZero, WindowCount, Impossibility, GreedyResidual, Alphabet, Rh41` is the dependency order) or build the imported module first. The recorded run of the same command is in the folder's history: "7 files, exits 0" (`README.md`), against toolchain `leanprover/lean4:v4.35.0-rc2`.

```sh
python3 crosscheck.py
```

`crosscheck.py` begins with a `sys.path` insertion and then `from rh41.rigorous_check import allzero_gap, allzero_ref, p_ref`, i.e. it expects the package `rh41` to be importable, which the folder does not contain (the folder's own `rigorous_check.py` is the intended target). **Observed** as published: exit status `1`, with

```
ModuleNotFoundError: No module named 'rh41'
```

**Observed with that package supplied** (a workspace-side `rh41` whose `rigorous_check.py` is this folder's copy): exit status `0`, wall time about ten seconds, summary `all checks pass (1969905 cases examined)`, and no violation:

```
  PASS  DigitWord.complexity_main (Theorem 1) matches p_ref   [397214 (word, N, L) cases, 0 violations]
  PASS  DigitWord.complexity_c1 (Theorem 5) matches p_ref   [117011 cases, 0 violations]
  PASS  AllZero.allZero_iff_hasLargeGap (claim A2) matches the reference   [1444551 cases, 0 violations]
  PASS  WindowCount.card_windows_containing matches the brute-force count   [10850 cases, 0 violations]
  PASS  Theorem 6 counterexample: onsets are 3 for {0,2} and 2 for {1,3} (TRUTHS.md prints them interchanged)
  PASS  Harmonic.terminates_rat census: 275 of the 277 reduced p/q with q <= 30 halt within the cap, the exceptions being 4/25 and 27/29
all checks pass (1969905 cases examined)
```

Note what the census line says: the script certifies that **275 of 277** halt *within its cap*, and names the two it does not reach ($4/25$ and $27/29$); the exact figures $53\,307\,974$ and $1\,003\,066\,151$ for those two are ledger data, not script output.

**Recorded but not re-run here**: the numeric constants that no script in this folder re-derives — $p^*=1.7286472389981836181$ (this one *is* re-derived by `rigorous_check.py` G4), the root of $\zeta(p)=3/2$ at $2.18528545179$ (G5), the observed minimum $1.58\cdot10^{-4}$ of $r'/r^2$ (E3 reports $0.0001576$), the max deviation $0.8519$ of the induced map from the Gauss map (F3), and the max gap $76\,762$ for $p=3/2$ (G2). All five are reproduced by the run above.

### 4.3 Trust boundary

The only non-constructive ingredients in the Lean development are classical logic and Mathlib's standard axioms (`LEAN-README.md`, "Trust and methodology"): no `sorry`, no `admit`, no project-specific `axiom`. A named list of theorems is proved with `native_decide` and therefore relies on compiled evaluation (`Lean.ofReduceBool`) rather than pure kernel reduction: `DigitWord.onset_not_determined_by_gaps` (its gap-sequence part), `refuted_pair_count_formula`, `refuted_dist_count_formula`, `refuted_gap_deficit_formula`, `refuted_slope_formula`, `refuted_span_formula`, `plateau_empty_example`, and `c1_bound_gap_necessary`. `Rh41/Alphabet.lean`, `Rh41/GreedyResidual.lean`, `Rh41/AllZero.lean`, `Rh41/WindowCount.lean` and `Rh41/Impossibility.lean` use none. This is the one caveat the README attaches to the item.

## 5. What is not claimed

* **Not the twin prime conjecture.** Nothing in this folder bears on it; the programme's papers do not prove it and this one does not either.
* **Not a Sturmian description of the greedy word.** The opposite is proved: no halting alphabet gives $p(L)=cL$, in particular not $p(L)=L+1$ (Theorem 12).
* **Not the matching upper bound $A(N)=O(\log\log N)$.** Only $A(N)=\Omega_x(\log\log N)$ is proved, and the two-sided squaring law that would give more is refuted (no positive lower bound for $r'/r^2$).
* **Theorem 9 in its printed `iff` form is false**, and Theorem 10 row 3 needs its extra hypothesis "no finite sub-sum equals $x$" — see Corrections 4 and 5. The printed forms are quoted because the source prints them.
* **Not formalised:** the numerical constants $p^*$ and the $x=1/2$ root $2.18528545179$; the observed minimum of $r'/r^2$; the "not the Gauss map" measurement; the visible orbit data (max gap $76\,762$); the supports such as $1/\pi$ as objects; the passage from $r_{k+1}\le r_k^2$ to the logarithm statement; the C1 law's general form $p(L)=L+1+\#\{j:d_j<L\}$; the first-difference (Cassaigne) rows; and the irrationality of the sub-sums of $(n+2)^{-p}$ that discharges Correction 5's hypothesis. `LEAN-README.md` lists all of these under "Not formalised".
* **Corrected earlier claims, kept visible:** (1) the onset example's two values were printed interchanged; (2) Theorem 9's `iff` is false as printed; (3) Theorem 10 row 3 was missing a hypothesis; (4) Theorem 1's span hypothesis is redundant; (5) Theorems 7's identities need strict hypotheses, and the integral case is separate; (6) Theorem 12's literal phrasing is false for a fixed truncation. Each is stated above next to the claim it corrects, together with the corrected statement.

## 6. Value and significance

The folder closes the factor-complexity question for the greedy digit word in the regime $L\ge a_m+1$, with a proof that is a two-line injectivity argument plus an exact window count, and it closes it in the opposite short-window regime with the C1 law. It also settles the Sturmian question negatively: the greedy word cannot have linear complexity, so a Sturmian-like description of $w(x)$ is not available, and the reason is not the greedy rule but the finiteness of the support. The refuted list is worth as much as the positive results: six plausible formulas are killed with minimal witnesses, and the two-sided squaring law — the only route to the matching upper bound in the programme's own record — is proved impossible, which re-aims the open problem instead of leaving it as a hope. Finally the Lean development corrects six printed statements; those corrections are part of the contribution, because the Python ground truth, the Lean statements and the prose ledger now agree, and the places where they previously disagreed are exactly the places where the mathematics had been mis-stated.

## Sources

All paths are relative to this folder (`research/publish/002-greedy-digit-word`). Local-only sources are marked; no external publication is quoted, and no hash is invented. Line numbers refer to the copies in this folder.

* `README.md` — *publish/002 — The greedy digit word and the complexity law* (local-only, packaged edition). Contents table, statuses, run instructions, provenance (§Provenance), dependencies.
* `TRUTHS.md` — *§2 The greedy digit word and the complexity law — `rh41`* (local-only; the item ledger, copied from `research/truths.md` §2 with links re-pointed). Lines 1–33: the result table with per-result status and Lean pointers.
* `ROUND-TRUTHS.md` — *041 — the greedy digit word: proven results* (local-only; the round's prose ledger). §1 definition and Theorems 1, 5; §2 auxiliary structure and Theorem 6; §3 the residual orbit, Theorems 7–8 and the $A(N)$ bounds; §4 Theorems 9–12; §5 the refuted list.
* `LEAN-README.md` — *`rh41/lean` — Lean 4 proofs for the truths of `rh41/TRUTHS.md`* (local-only). §"What is proved, item by item" (the theorem-to-declaration map), §"Corrections found while formalising" items 1–6, §"Trust and methodology" (the `native_decide` list; the `crosscheck.py` case counts), §"Not formalised".
* `Rh41/DigitWord.lean` — definitions `factor` (l.29), `complexity` (l.33); Theorem 1 `complexity_main` (l.119) and `complexity_main_TRUTHS` (l.212); Corollaries 2–4 `complexity_plateau` (l.226), `complexity_decay` (l.237), `complexity_eq_one_of_le` (l.253), `complexity_eq_two_of_pred` (l.262), `complexity_le_max_add_two` (l.278), `max_complexity` (l.331); Theorem 5 `complexity_c1` (l.347); claim A1 `complexity_eq_bitComplexity` (l.515); Theorem 6 `onset_not_determined_by_gaps` (l.546); the refuted formulas (ll.566–603); `plateau_empty_example` (l.609); the C1 necessity witnesses (ll.620–632).
* `Rh41/AllZero.lean` — `extSupport` (l.23), `AllZero` (l.27), `HasLargeGap` (l.31), claim A2 `allZero_iff_hasLargeGap` (l.41).
* `Rh41/WindowCount.lean` — `card_Icc_int` (l.19), `cast_max_sub` (l.32), `card_windows_containing` (l.50).
* `Rh41/Impossibility.lean` — Theorem 12 core: `no_linear_growth` (l.21), `no_affine_profile` (l.59), `no_sturmian_profile` (l.97).
* `Rh41/GreedyResidual.lean` — the residual orbit under `namespace Rh41.Harmonic`: `active` (l.54), `residual` (l.59), `terminates_rat` (l.362), `terminates_from` (l.375), `residual_eventually_zero` (l.381), `residual_invariant` (l.413), `taken_one_iff` (l.460), `squaring_identity` (l.486), `squaring_law` (l.507), `no_positive_lower_bound` (l.534), `u_map` (l.585), `induced_map` (l.612), `induced_map_int` (l.646).
* `Rh41/Alphabet.lean` — `residual`/`taken`/`digitSupport` (ll.88–108), `TendsToZero` (l.110); Theorem 9 `taken_all_of_bounded_partial_sums` (l.213), `never_halts_of_partial_sums_lt` (l.245), `partial_sums_iff` (l.284), `residual_ge_sub_sum` (l.307), `le_sum_of_residual_eq_zero` (l.328); Theorem 11 `expAlpha_*` (ll.347–437); Theorem 10 row 3 `never_halts_of_tendsto_zero` (l.501), `powerAlpha_never_halts` (l.570), `powerAlpha_infinitely_many_taken` (l.578); Theorem 12 `max_complexity_of_finite_support` (l.642), `no_linear_complexity_of_finite_support` (l.651), `no_sturmian_complexity_of_finite_support` (l.679), `max_complexity_of_halting` (l.690), `no_linear_complexity_of_halting` (l.702).
* `Rh41.lean` — root module importing all six files (6 lines).
* `check.sh` — the Lean build script; `--all` order and the `$LEAN_PREFIX` convention (54 lines).
* `digitword.py` — the ground-truth layer: definition of record, exactness rules, `greedy_word_rational`, `factor_set`, `p_offset`, `p_bruteforce`, the $1/\pi$ support.
* `rigorous_check.py` — the independent numerical recomputation: `p_ref` (l.44), `p_brute` (l.50), `allzero_ref`/`allzero_gap` (ll.56–63), and the claim groups A–I (ll.72–571).
* `crosscheck.py` — the Lean-statement-versus-Python-reference cross-check (`rh41.rigorous_check` import at the top; case table summarised in `LEAN-README.md`).
* Recorded run note, cited as such: the round ledger's certification figures (`31/31` for `rigorous_check.py`, 1 969 905 crosscheck cases, "7 files, exits 0" for the Lean build).
