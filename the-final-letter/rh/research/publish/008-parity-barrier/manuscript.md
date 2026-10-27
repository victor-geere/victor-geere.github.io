# Greedy Sine versus the Parity Barrier: Sylvester-Sparsity and Three Refuted Bridges

**First edition, packaged from `research/truths.md` §8 (`rh47`); prose ledger `rounds/rh47/truths.md`. Local-only folder: this edition reproduces the round's files unmodified except that markdown links have been re-pointed into the folder and one transient draft (`verify/_draft_probe_03h56.py.bak`) has been dropped.**

## Abstract

This folder records one round of the twin-prime-conjecture project (math.solveathome.org) that asked whether the *greedy harmonic sine* can supply the positive-density coupling to $\Omega$ that the parity barrier requires. The answer is a sharpened **no**, and the round's own goal is **not achieved**: nothing here solves, or claims to solve, the twin prime conjecture or the parity problem, and $\sum_{n\le x}\lambda(n)\lambda(n+2)=o(x)$ remains **open**. The new structural fact is **Sylvester-sparsity**: for the support $A=\{m_1<m_2<\cdots\}$ of the greedy word, $m_{i+1}\ge m_i(m_i-1)+1$ — proved on paper and verified numerically with $0$ violations. It makes the specified test's domain empty and forces the support density to $\approx 3.9\cdot10^{-5}$. Three bridges from the greedy construction to $\lambda$-parity are tested and **refuted**, a false sparse bound inherited from `rh46` is corrected (with an explicit witness), and the round's own one-sentence barrier phrasing is **withdrawn** as too wide after audit. The impossibility statement stays a **heuristic, open**. There is deliberately **no Lean layer** in this folder: the round's Lean directory is empty and its formalisation obligation `R4` is open.

## 1. Introduction and goal

The round's goal, verbatim, was to *use the greedy harmonic sine to solve the parity problem for the twin prime conjecture*. The greedy harmonic sine is a constructive selection rule on the alphabet $\alpha_n=(-1)^n/(n+2)^p$; the parity problem is the obstruction that sign-blind sieves cannot detect the parity of $\Omega(n)$. The question this folder asks is therefore precise and falsifiable: can the greedy word's support carry positive-density multiplicative information about $\Omega$?

The round harvests the earlier conversation (`rh40`–`rh46`) into one place, states the goal falsifiably, runs a reconnaissance against it, tests three explicit bridges, and fixes the barrier that any greedy-sine attack must cross. What is in scope is exactly that reconnaissance and its audit. What is out of scope — and explicitly not claimed — is any progress on the twin prime conjecture, on the parity problem, or on the un-averaged two-point Chowla statement
$$\textstyle (\star)\qquad \sum_{n\le x}\lambda(n)\lambda(n+2)=o(x),$$
which the programme records as **open**. The round's verdict is that the goal is **not reachable by this programme as it stands**, and the reconnaissance shows *why*.

A deliberate feature of this item: **there is no Lean development in this folder**. The round's Lean directory `lean/Rh47/` is empty, so the `R4` obligation (formalising the barriers already proved in prose) is open. That emptiness is part of the item, not an omission of this edition.

## 2. Setup and definitions

**The unsigned greedy word (definition of record).** Fix $x=p/q\in(0,1)$ and put $r_0=x$. At step $n\ge 0$ take the term $1/(n+2)$ if and only if $r_n\ge 1/(n+2)$, otherwise skip it; never reuse a term. Write
$$A(x)=\{\,m=n+2 \;:\; 1/m \text{ was taken}\,\},\qquad A(x)=\{m_1<m_2<\cdots\}.$$
Equivalently $A(x)$ is the greedy Egyptian expansion of $x$: the least admissible denominator at residual $r$ is $m=\lceil 1/r\rceil$. The probe cross-checks the $O(|A|)$ ceiling-chain computation against the literal step-by-step simulation. Exact `Fraction` arithmetic is used throughout.

**The signed word and the parity lock (`rh41`/`rh42`).** The signed construction uses the alphabet $\alpha_n=(-1)^n/(n+2)^p$, keeping a term if its sign matches the residual and it does not overshoot. For a positive target only even denominators are taken, for a negative target only odd ones; all gaps are even (the *parity lock*). The word is proved (in `rh42`, quoted here, not reproved) to factor through the height $\sin(2\pi\theta)$; the budgets are
$$P(p)=2^{-p}\zeta(p),\qquad N(p)=(1-2^{-p})\zeta(p)-1;$$
the exact reachable set is governed by Brown's criterion, and the positive half is complete if and only if $p\le p^\ast$ with $\zeta(p^\ast)=2$.

**Arithmetic functions.** $\Omega(n)$ is the number of prime factors of $n$ counted with multiplicity, and $\lambda(n)=(-1)^{\Omega(n)}$ is the Liouville function. $(\star)$ is the two-point Chowla statement above. A *modification set* $A$ acts on the correlation by
$$S_A(x)=\sum_{n\le x}\lambda_A(n)\lambda_A(n+2),\qquad \lambda_A(n)=\begin{cases}-\lambda(n),& n\in A,\\ \lambda(n),& n\notin A,\end{cases}$$
so that $S(x)=S_\emptyset(x)$; the required witness must have **positive density**. The programme's inherited estimate for sparse modifications was this bound (the `rh46` sparse bound):
$$|S_A(x)-S(x)|\le 2\,\#\{n\le x+2: n\in A\}.$$
That bound is refuted below.

**The three bridges.** A greedy-sine attack on $(\star)$ needs a map from the word to the arithmetic of $\Omega(n)$. The three tested candidates are B1 (the greedy *support* carries $\lambda$-parity signal), B2 (the $\zeta$ budgets carry $\Omega$-parity information) and B3 (the $\zeta$-machinery applies to the correlation). All three are specified and tested in `greedy_parity_probe.py`; the barrier claim itself is audited independently in `independent_check.py`.

**Sylvester's sequence.** $s_1=2$ and $s_{i+1}=s_i(s_i-1)+1$. The ladder $x_k=(s_{k+1}-2)/(s_{k+1}-1)$ has support exactly $\{s_1,\dots,s_k\}$, so the support-size classes below are non-empty as rational objects.

## 3. Results

Statuses are exactly the source statuses: **PROVED (paper)**, **VERIFIED**, **REFUTED**, **OPEN**.

### 3.1 Sylvester-sparsity of the greedy support — PROVED (paper) + VERIFIED

**Theorem (Sylvester-sparsity).** Let $A(x)=\{m_1<m_2<\cdots\}$ be the support of the greedy word. Then
$$m_{i+1}\ \ge\ m_i(m_i-1)+1 .$$

*Proof sketch (as the sources carry it).* After taking $1/m_i$ the residual satisfies $r<1/\bigl(m_i(m_i-1)\bigr)$, so no index below $m_i(m_i-1)+1$ can be taken. $\square$

*Consequences.*

1. $|A|\ge 20$ forces $\max A\ge s_{20}$, an integer with **106 721 decimal digits**. Computing $\lambda$ at such an element would mean factoring a 106 721-digit integer, so the class of targets the specification's $|A|\ge20$ test asks for is empty of objects whose parity class exists for us.
2. The support density is $\approx 3.9\cdot10^{-5}$: measured $\overline{|A|}=2.95,3.25,3.60,3.90$ for $N=10^2,10^3,10^4,10^5$, i.e. density $2.95\cdot10^{-2},3.25\cdot10^{-3},3.60\cdot10^{-4},3.90\cdot10^{-5}$. The number of takes is $O(\log\log N)$ (`rh41`).

*Verification.* The current `greedy_parity_probe.py` reports **0 violations in 53 159 consecutive pairs** of the 20 320 computed supports. The shipped run log `logs/greedy_parity_probe.log` records the earlier revision's count, **0 violations in 52 969 consecutive pairs of the 20 300 computed supports**; both are reproduced in §4. The README and `TRUTHS.md` quote 53 159, the current script's number.

### 3.2 The specified test has an empty domain — CHECKED

Sample A is every $x=a/b$ with $2\le b\le200$ (19 900 targets); sample B is 400 random targets with $b\in[10^6,10^{12}]$. The observed support-size maxima are $11$ (sample A) and $18$ (sample B). Hence:

* **0 of the 19 900** rational targets with denominator $\le200$ has $|A|\ge20$ — the exclusion rule drops 100 % of a natural exact sample;
* **0 of the 20 300** computed supports (sample A plus sample B; the rigidity check adds 20 ladder supports, the 20 320 of §3.1) has $|A|\ge20$, and **0** of those has $\max A\le10^{13}$, so the number of targets with an admissible support *and* a computable parity class is **0**.

The specified `|A| >= 20` test therefore **cannot be run**. This is a statement about the greedy object (via §3.1), not about $\lambda$. What follows in the probe is a threshold-relaxed diagnostic ($|A|\ge4$, all elements $\le10^{13}$), labelled everywhere as below the specified threshold and as a weak diagnostic.

### 3.3 The corrected sparse bound — PROVED (paper) + VERIFIED; `rh46`'s bound REFUTED

**Refutation (with witness).** Bound (rh46) is **false**. Take $A=\{5\}$, $x=5$. Then $\lambda_A$ flips at $n=5$ and at $n=3$ (because $3+2=5$), so the two affected terms each change by $-2$ in $S$, giving
$$|S_A(5)-S(5)|=4\ >\ 2\,\#\{n\le 7: n\in A\}=2 .$$
The two affected terms are $n=3: +1\to-1$ and $n=5: +1\to-1$.

**Corrected bound (paper).** For every modification set $A$,
$$|S_A(x)-S(x)|\ \le\ 2\,\#\{n\le x: n\in A \text{ or } n+2\in A\}\ \le\ 4\,\#\{m\le x+2: m\in A\}.$$
The mechanism: each affected term changes by exactly $2$ in absolute value, and the affected indices are those with $n\in A$ or $n+2\in A$, i.e. at most $2\,\#\{m\le x+2:m\in A\}$ indices. The $o(x)$ conclusion of `rh46` is unaffected.

*Verification.* For random $A$ of densities $0.001$, $0.01$, $0.5$ (with $|A|\le500$) and all $x\le10^6$, both the sharp form $2\,\#\{n\le x:n\in A\lor n+2\in A\}$ and the four-count form $4\,\#\{m\le x+2:m\in A\}$ hold. Observed maxima in the audit's three density classes: $|S_A-S|_{\max}=2,4,42$ against sharp right-hand sides $4,20,998$.

**Consequence for the greedy support.** By the corrected bound, the greedy support moves $S(x)$ by $O(\log\log x)=o(x)$ only; it cannot be the positive-density witness that $(\star)$ requires.

### 3.4 Bridge B1 — the greedy support carries $\lambda$-parity signal? **REFUTED**

Relaxed diagnostic ($|A|\ge4$, elements $\le10^{13}$): 8 820 targets (tier A, $\max A\le10^7$ and $\lambda$ from the exact sieve: 6 461; tier B, $10^7<\max A\le10^{13}$ and $\lambda$ from exact factorisation: 2 359), size histogram $\{(4,5762),(5,2580),(6,478)\}$.

* **Nominal signal.** Mean of $\lambda$ over the support is $-0.300635$ ($-0.3006$), and the pooled deviation against the specification's size- and range-matched random control C0 is $z=-47.9170$ ($p=0$). The nominal signal is present and must be killed.
* **Kill 1, positional sign-permutation control C1** (pool of 38 816 occurrences, 7 033 distinct positions; pool sign-mean $-0.280348$; observed support mean $-0.278216$): $z=+0.4342$, $p=0.664$.
* **Kill 2, rank-matched slot control C2**: $z=+1.5484$, $p=0.122$; per-target 5 % rejection rate $0.024$.
* **Why the nominal $z$ is meaningless.** The 8 820 supports use only 7 033 distinct indices; the 8 most frequent positions carry 15 915 of the 38 816 occurrences, and $m=2$ occurs in 6 217/8 820 supports ($70.5\,\%$), $m=3$ in $46.5\,\%$, $m=4$ in $19.3\,\%$. The statistic is largely a statement about $\lambda(2)=\lambda(3)=\lambda(7)=\lambda(8)=-1$ and $\lambda(4)=+1$, so its nominal effective sample is far smaller than 8 820.
* **Counterexample to the finding itself.** The strongest single-target residual is $x=30/103$, $A(x)=[4,25,793,907545,1482547361100]$, $|A|=5$, mean $\lambda=1.0000$, residual/sd $=3.048$; only 4 of 8 820 targets exceed 3 slot-controlled sd (chance $\approx24$), so no single target rescues the signal.
* **Auditor's independent attempts.** All null: pooled $z=-1.68$ (support vs $\lambda$), $-0.72$ ($\lambda(n)\lambda(n+2)$), $+1.37$ (support pairs), $-0.74$ (span-block density). The parity-lock route (C3c) matches $\{\lambda=+1\}$ at $0.4938$ against chance $0.5009$ ($z=-0.22$) at support density $2.43\cdot10^{-3}$ (zero density); a shift scan over 101 even shifts has $\max|z|=2.60$ against a Bonferroni 5 % threshold $3.66$.

**Verdict B1: no parity signal in the sense the bridge needs.** The large nominal deviation from the specification's range control is a position-frequency artefact (the rigidity forces tiny early chain elements); it is fully reproduced by the positional and rank-matched controls; and the only regime in which B1 could be tested non-trivially ($|A|\ge20$) contains no computable target.

### 3.5 Bridge B2 — the $\zeta$ budgets carry $\Omega$-parity information? **REFUTED**

The `rh42` budgets are
$$P(p)=2^{-p}\zeta(p)=\sum_{k\ge1}(2k)^{-p}\ \text{(even }m),\qquad N(p)=(1-2^{-p})\zeta(p)-1=\sum_{k\ge2}(2k+1)^{-p}\ \text{(odd }m\ge3),$$
i.e. a split by **index parity**, not by $\Omega$-parity. The identities $P+N=\zeta-1$ and $P-N=1-\eta$ hold to better than $10^{-30}$ (`mpmath`, 40 dps); the budgets are constants in $p$ and contain no arithmetic of $n$.

* **Overlap statistic.** The $2\times2$ table of index parity against $\Omega$-parity at $N=10^7$ has $\chi^2(1)=2.9441$ with $z=0.9905$ for the (even, $\Omega$ even) cell; $0.4997$ of $n\le10^7$ have index parity different from $\Omega$-parity. The auditor reproduces the conditioning at $N=10^6$ with permutation $z=1.30$, and at $N=10^5$ with $z=1.47$.
* **The decisive strengthening: index parity is invisible to the correlation.** Put $\lambda'(n)=(-1)^n\lambda(n)$. Then
$$\lambda'(n)\lambda'(n+2)=(-1)^{2n+2}\lambda(n)\lambda(n+2)=\lambda(n)\lambda(n+2),$$
since $2$ is even. The twist identity
$$\sum \lambda(n)(-1)^n\,\lambda(n+2)(-1)^{n+2}=\sum\lambda(n)\lambda(n+2)$$
is therefore **exact**, verified with **0 mismatches for all $x\le10^6$**. Even perfect knowledge of index parity would say nothing about $(\star)$.

**Verdict B2: the budgets cannot carry $\Omega$-parity information**; the index-parity split they encode is statistically independent of the $\Omega$-parity class and, by twist invariance, orthogonal to $(\star)$.

### 3.6 Bridge B3 — the $\zeta$-machinery applies to the correlation? **REFUTED**

$f(n)=\lambda(n)\lambda(n+2)$ is **not multiplicative**:

* $f(1)=\lambda(1)\lambda(3)=-1\ne1$, so multiplicativity fails immediately;
* coprime witnesses: $f(2)f(11)=(-1)(+1)=-1\ne f(22)=+1$; $f(2)f(13)=(-1)(-1)=+1\ne f(26)=-1$; $f(2)f(17)=-1\ne f(34)=+1$; $f(3)f(5)=+1\ne f(15)=-1$;
* 12 016 coprime pairs $a,b\le200$ with $ab\le10^6$ violate multiplicativity (the auditor, with its own count, finds 11 942 of 23 906 coprime pairs $m,n<200$).

Hence there is no Euler product. The probe evaluates
$$D(2)=\sum_{n\le10^6}\frac{f(n)}{n^2}=-1.1268130386,\qquad \text{naive multiplicative model}=0.8875735163,$$
$$|D(2)-\text{model}|=2.0143865549,$$
while the rigorous truncation bound (prime tail $\le\zeta(2)(e^{1/P}-1)=1.6449\cdot10^{-5}$ for $P=10^5$, $n$-tail $\le2/N=2.0\cdot10^{-6}$, $k$-tail $\le1.0\cdot10^{-9}$) totals $1.845042\cdot10^{-5}$; the discrepancy exceeds it by a factor **109 178**. The auditor's independently tighter total tail is $1.836\cdot10^{-5}$, giving the same verdict with a discrepancy of $2.014387$.

**A second inherited defect.** `rh46`'s published product "tail bound" $1.80898647$ is **mis-derived**: it equals $4\sum_{p\le10^5}1/p^2$ over the *retained* primes, not a bound on the omitted factor $p>10^5$ (which is $\le1.00\cdot10^{-5}$). The no-Euler-product conclusion survives, but for a different reason than the source stated.

**Verdict B3: no Euler product; the correlation is not multiplicative and the $\zeta$/$L$-function machinery does not apply to it.**

### 3.7 The barrier, stated correctly — corrections recorded; impossibility OPEN

**Corrected statement.** For a **sign-blind alphabet with no arithmetic input**, no object of the greedy-sine programme supplies a positive-density coupling to $\Omega$; and $(\star)$ is **OPEN**.

Two corrections the audit forced, both kept visible:

1. **The round's one-sentence barrier — "every greedy-sine object is an additive character in $\log n$" — was withdrawn as too wide and imprecise.** $n^{-it}$ is a *multiplicative* character on $(\mathbb R_+,\times)$, and the budgets are *constants* in $p$, not characters. The audit exhibited a greedy object of the *same take rule* whose alphabet is arithmetic — $\alpha_p=(-1)^{\Omega(p+2)}/(p+2)$ — and which of course mixes: import $=\operatorname{mean}(\operatorname{sign}(q)\lambda(q))=1.0000$ over 141 takes with mean $\lambda=+1.0000$, $z=+10.1$; the weaker $\omega$-indexed variant has import $0.6272$ and $z=+6.3$; the sign-permuted control is null (mean $+0.0192\pm0.0968$). The signal lives in the **alphabet**, in the target function itself, and using it is **circular**.
2. **The impossibility is a heuristic and must stay OPEN.** What is *proved* is the budget sign-blindness (strengthened by twist invariance) and the Euler-product failure. "The two do not mix" is not a theorem; the document says "no mechanism known".

The audit's verdict on the barrier itself: **correctly stated in substance, with the two caveats above**; the verified legs are sign-blindness and the absence of an Euler product, and the impossibility statement stays open.

### 3.8 What the goal would need; the programme's verdict

The goal needs a map from a rule **determined by the target alone** and **sign-blind** to **positive-density multiplicative information about $\Omega$**. The greedy support is Sylvester-sparse (density $3.9\cdot10^{-5}$), so the programme has no object that can even be placed in the regime where such information could live; by the corrected sparse bound it moves $S(x)$ by $O(\log\log x)=o(x)$. The round's verdict: **the goal is not reachable by this programme as it stands**.

**Open.** `R2`, the barrier as a theorem ("no sign-blind $\log n$-rule forces a multiplicative correlation"): as inherited it is **not well-posed**; the well-posed replacement is `OP-19` (in `research/open.md` §5, outside this folder). `R4`, the Lean formalisation of the barriers (Brown's criterion, the parity lock, the corrected sparse bound, `rh46`'s finite-prefix theorem): **open — the `rh47` Lean layer is empty**. The inherited `rh46/lean/Rh46/Chowla.lean` layer is separately recorded as **certified** (37 theorems, 0 `sorry`, 0 `axiom`, `./check.sh --all` exit 0); an earlier revision of the round ledger claiming it "still does not compile" is stale and corrected.

## 4. Verification and evidence

### 4.1 Scripts run for this edition

Both Python checks were run on **2026-10-16** from temporary copies of the scripts (so that the folder was not written to; the scripts write a `verify/` log next to themselves).

| Command | Exit | Observed output |
|---|---|---|
| `python3 greedy_parity_probe.py` | **0** | header `started 2026-10-16 08:31:47`; `[PASS] S1.rigidity.no.violations \| m_{i+1} >= m_i(m_i-1)+1 holds at all 53159 consecutive pairs of the 20320 computed supports (0 violations)`; `[PASS] S2.nominal.signal.under.spec.control \| ... z = -47.9170 (p = 0)`; `[PASS] S2.kill.positional.control \| ... z = 0.4342 (p = 0.664)`; `[PASS] S2.kill.slot.control \| ... z = 1.5484 (p = 0.122)`; `[PASS] S3.overlap.chance.level \| ... chi-square = 2.9441 (z = 0.9905 ...)`; `[PASS] S4.no.euler.product \| \|D(2) - naive Euler product\| = 2.014387, which exceeds the rigorous truncation bound 1.845042e-05 by a factor 109178`; **`23 checks pass, 0 fail (wall clock 13.6s)`**. |
| `python3 independent_check.py` | **0** | `[PASS] C1.2d twist invariance \| S(lambda) == S(lambda*(-1)^n) exactly for all x<=10^6 (0 mismatches)`; `[PASS] C2c discrepancy > tight tail \| \|D(2)-model A\| = 2.014387 > tight rigorous tail 1.836e-05`; `[PASS] C4a quoted constant refuted \| witness A={5}, x=5: \|S_A-S\|=4 > 2*#{n<=x+2:n in A}=2`; **`RESULT: 31/31 checks pass`**, `elapsed: 154.4s`. |

The audit's own script (`independent_check.py`) refuses to rest any claim on the round's probe file: at audit time the file was being revised by the round *while the audit ran*, so no audit claim depends on it.

### 4.2 Recorded runs shipped in the folder

`logs/greedy_parity_probe.log` contains **two** runs concatenated:

* lines 1–335: the long reconnaissance, `21 checks pass, 1 fail (wall clock 26491.0s)`, with `[FAIL] S2.nominal.signal.under.spec.control` (in that revision the specification's range control returned $z=0$, so the check's `z_range < -20` assertion failed) and without the later-added `S1.sylvester.ladder.exact` check. This run reports `m_{i+1} >= m_i(m_i-1)+1 holds at all 52969 consecutive pairs of the 20300 computed supports (0 violations)`;
* lines 336–367: the re-run, `23 checks pass, 0 fail (wall clock 3.5s)`, including `S1.sylvester.ladder.exact`.

`logs/greedy_parity_probe.stdout` carries the same two summaries. `logs/independent_check.log` records `RESULT: 31/31 checks pass`, `elapsed: 38.8s` (a faster machine than the one used in §4.1). `logs/independent_check.py` is a byte-identical copy of the top-level `independent_check.py` (both SHA-256 `7ab527c0…`), retained in the folder; it is not listed among the attachments to avoid a duplicate.

### 4.3 Evidence cited from the record

* The Sylvester-sparsity ceiling and the digit count (`s_20` has 106 721 decimal digits) are recorded in the probe log §1.
* The corrected sparse bound and the witness $A=\{5\}$, $x=5$ are recorded in the probe log §4 and the audit log C4a/C4b.
* The twist identity and its $0/10^6$ mismatches are recorded in the audit log C1.2d.
* The two barrier corrections (the withdrawn "additive character" phrasing and the exhibited circular arithmetic alphabet with $z=+10.1$) are recorded in the audit log C3a and in the round ledger §3.
* `rh46`'s product-tail mis-derivation is recorded in the audit log C2d; the referee is `rh46`'s published number $1.808988$.

### 4.4 Not run here

The round's Lean build could not be run because **this folder has no Lean development**: `check.sh` is absent by design and `lean/Rh47/` is empty. That is the item. No other script exists in the folder.

## 5. What is not claimed

* **No progress on the twin prime conjecture, on the parity problem, or on $(\star)$.** $\sum_{n\le x}\lambda(n)\lambda(n+2)=o(x)$ is **open**.
* **The barrier is not a theorem.** The impossibility statement ("sign-blind, no arithmetic input" cannot force a positive-density multiplicative coupling to $\Omega$) stays a **heuristic, open**. Only the budget sign-blindness / twist invariance and the Euler-product failure are proved.
* **`R2` is not well-posed as inherited**; its well-posed replacement is `OP-19`, which lies outside this folder.
* **`R4` is open.** There is no Lean layer here; the Sylvester-sparsity theorem's paper proof is not machine-checked in this folder.
* **The numerical checks are finite checks.** Every number in §3.4–§3.6 is a finite check on finitely many rational targets; none proves or disproves the twin prime conjecture, the parity problem, or $(\star)$. The only logically exhaustive statements are the Sylvester-sparsity ceiling and the corrected sparse bound.
* **The corrected sparse bound is proved on paper**, not in Lean, and verified numerically on finitely many random sets.
* **B1's negative is a statement about the tested sample** (8 820 targets, supports of size up to 6 after the factorability relaxation), not about all targets; the specified $|A|\ge20$ regime is empty of computable objects.
* **The circular $z=+10.1$ finding is not a bridge**: it imports the target function into the alphabet and is recorded as a witness of circularity.
* **Two record errors are retained, not hidden**: the `rh46` sparse constant $2$ (should be $4$ in the stated form) and the `rh46` product tail $1.808988$ (mis-derived). An earlier revision of the round ledger claiming the inherited `rh46` Lean layer does not compile is also corrected as stale.
* **No authorship, date or return id is asserted here beyond what the folder states.** The folder names the programme (math.solveathome.org), the round (`rh47`), and the recorded run timestamps; it does not state individual authors.

## 6. Value and significance

The item is worth recording because it does four things at once. (i) It **closes a route**, not by opinion but by a structural theorem: the greedy support is Sylvester-sparse, hence of density $\approx3.9\cdot10^{-5}$ and unable to supply the positive-density witness that $(\star)$ needs. (ii) It supplies a **new exact fact** about the greedy Egyptian expansion, $m_{i+1}\ge m_i(m_i-1)+1$, with an elementary paper proof and exhaustive numerical confirmation; the same rigidity explains *why* the specified test's domain is empty. (iii) It **corrects the record**: `rh46`'s sparse bound and product tail are refuted with explicit witnesses, and the round's own one-sentence barrier phrasing is withdrawn as too wide after audit. (iv) It states precisely **what a successor would have to build** — a sign-blind alphabet with a positive-density multiplicative coupling to $\Omega$ — and records that nothing in the programme supplies it, while keeping the impossibility itself open. The absence of a Lean layer is itself informative: it marks the exact formalisation obligation (`R4`) that this round left open.

## Sources

All paths are relative to this folder. SHA-256 values are of the files as read for this edition; lines cited are from the copies in this folder.

| Source | Role | Locator | SHA-256 |
|---|---|---|---|
| [`README.md`](README.md) | folder guide, contents, proved/refuted/open summary | whole file | `13d4c9f8e9a96662dedb9d92c6a244bad73d4d152e4ff09a4a60936378ebe47f` |
| [`TRUTHS.md`](TRUTHS.md) | the §8 ledger: statuses, the three bridges, the corrected bound | table, lines 8–19 | `9eb392bf5145976c30062a0f7a4743d144bc02c6415436ed72c3145b5e486877` |
| [`ROUND-NOTES.md`](ROUND-NOTES.md) | round summary: goal, Sylvester-sparsity, bridges, barrier sentence | §§1–5 | `73fc1df4c38acc371fcedfe8b29f4814a526f7bb2bb9ad94f87b8fc41b9b6aec` |
| [`ROUND-TRUTHS.md`](ROUND-TRUTHS.md) | full prose ledger: proof sketch, audit corrections, `rh46` defects | §§1–5 | `fde5b0599d8c41e11b0a52f721313ccd32565c4a2d7554b2c102ea41ae06b55e` |
| [`greedy_parity_probe.py`](greedy_parity_probe.py) | the reconnaissance: support statistics, budgets, Euler-product failure | 1101 lines | `cd2b0101bd626dc5ec3cfa114c7b07eaa89eaa00eb61f08ad734a6b5c78bbe18` |
| [`independent_check.py`](independent_check.py) | the auditor's independent recomputation | 1206+ lines | `7ab527c0e5405ebd1fd61e7cc2922ad1b90a22b327a9949a9e37b1dd121e25fe` |
| [`logs/greedy_parity_probe.log`](logs/greedy_parity_probe.log) | recorded probe runs (21/1 then 23/0) | whole file | `58adb02a4a4a0538656759086258da02a8cc76931a92272dfec353640a8924f4` |
| [`logs/greedy_parity_probe.stdout`](logs/greedy_parity_probe.stdout) | recorded probe stdout | whole file | `21a22ed18aa55c88ef2d4c58de101f2cd96c5c3247e9e42386774f4df8630172` |
| [`logs/independent_check.log`](logs/independent_check.log) | recorded audit run, 31/31 | whole file | `ec8bc4eed87f4ea145e4bc4f529ac2970105e91ca5d5701d2254b6e1726ef57c` |
| [`logs/independent_check.py`](logs/independent_check.py) | duplicate of the auditor script | byte-identical to top-level copy | `7ab527c0e5405ebd1fd61e7cc2922ad1b90a22b327a9949a9e37b1dd121e25fe` |
| `research/truths.md` §8 | upstream ledger | cited by `README.md` | local-only, not in this folder |
| `rounds/rh47/truths.md` | upstream prose ledger | reproduced as `ROUND-TRUTHS.md` | local-only, not in this folder |
| `research/open.md` §5 (`OP-19`) | the well-posed replacement for `R2` | cited in `README.md` | local-only, not in this folder |
| `rh42`, `rh41`, `rh46` (rounds) | inherited results quoted here (budgets, parity lock, census/Chowla context) | cited throughout the ledgers | local-only, not in this folder |

*Recorded literature status (cited in the audit log C4, not proved here):* the un-averaged two-point Chowla statement $(\star)$ is open; Tao (arXiv:1509.05422, Forum of Math. Pi 2016) proves the logarithmically averaged version and describes it as breaking the parity barrier for that problem; Matomäki–Radziwiłł (2015) and Matomäki–Radziwiłł–Tao (2015) give cancellation for almost all shifts; Tao (arXiv:1605.04628) and Tao–Teräväinen (arXiv:1809.02518) work at averaged scales. No source in the folder claims the un-averaged two-point case.
