# Cone residue, the shift-2 core, and the three thresholds $p_N < p_P < p_*$

**First edition, packaged from `research/truths.md` §12. Provenance: these proof files live outside `research/`, at the workspace root `lean/` (the only item of the ledger whose sources are not under `research/twin-prime-parity/`). They are copied into this folder so that the item is packageable like the others; the workspace originals are untouched and remain the canonical copies. Reproduced unmodified except that one docstring reference in `ConeLean/ChowlaEquiv.lean` has been re-pointed to the local copy of the cone residue ledger.**

## Abstract

This manuscript reports one internal item of a programme on the parity problem for the twin-prime
correlation: the machine-checked **cone** development (`ConeLean`) together with the
**three-thresholds** development (`TppLean`). **It does not prove the twin prime conjecture or the
two-point Chowla conjecture, and the three-thresholds theorem is not a twin-prime or parity result.**
Four strands are packaged. (i) *The cone residue.* For the correlation $f(n)=\lambda(n)\lambda(n+2)$
and the critical-cone transform $C_f(p)=\sum_n f(n)(n(n+2))^{-p}$, the residue
$\lim_{\varepsilon\downarrow0}\varepsilon\,C_f(1/2+\varepsilon/2)$ **vanishes**, conditionally on Tao's
log-averaged two-point Chowla theorem, and also follows from $S(x)=o(x)$; the converse **fails** (an
external counterexample), so the residue is strictly weaker than the target. The supporting identities —
discrete Abel summation, the pair-weight comparison, the four-density equivalence of $S(x)=o(x)$ — are
**PROVED** in Lean. (ii) *The shift-2 core.* The finite parity split,
$S_2(x)=S_1(\lfloor x/2\rfloor)+C(\lfloor(x+1)/2\rfloor)$ with $C(K)=\sum_{k\le K}\lambda(4k^2-1)$, is
**PROVED**, and its only correct consequence is the **sufficiency**
`shift_two_of_shift_one_and_core`; an erratum in the source records that the shift-1 correlation is
**not** solved and the converse of the split fails. (iii) *The barriers.* The parity obstruction
(the correlation is neither multiplicative nor a Dirichlet convolution of multiplicative functions) and
the Abel/log-averaging, shift-averaging and scale-averaging barriers are **PROVED**. (iv) *The three
thresholds.* With $P(p)=2^{-p}\zeta(p)$, $N(p)=\sum_{k\ge0}(2k+3)^{-p}$ and $\zeta(p)=\sum_{n\ge1}n^{-p}$,
if $P(p_P)=1$, $N(p_N)=L$ for any $L\ge1$, and $\zeta(p_*)=2$, then $p_N<p_P<p_*$ — **PROVED** in Lean
(`tpp_rh42_three_thresholds`, `tpp_rh42_three_thresholds_level`), by monotonicity plus four certified
rational brackets, with no continuity, no intermediate value theorem and no root-finding. The source's
numerical values ($p_P=1.4649845878051603837$, $p_*=1.7286472389981836181$) are quoted for orientation
and are **not** formalised.

## 1. Introduction and goal

The programme attacks the two-point Liouville correlation
$$S(x) = \sum_{n\le x}\lambda(n)\lambda(n+2),$$
where $\lambda(n)=(-1)^{\Omega(n)}$ and $\Omega(n)$ counts prime factors with multiplicity. The target
$S(x)=o(x)$ is the two-point Chowla conjecture at shift $2$ and is **open**; the twin prime conjecture
is **open**; the programme's parity barrier says that bounded-depth sieving cannot decide either. This
item packages the machine-checked negative and structural results that surround that wall, and one
internal positive theorem.

The item has four parts, in the order of the ledger §12:

1. **The cone residue** (`ConeLean/Cone.lean`, `ConeLean/ResidueReduction.lean`). The programme's
   critical-cone transform places the $n$-th term of a real Dirichlet series at
   $C_n=(n^{-p}\cos(t\log n),\,n^{-p}\sin(t\log n),\,n)\in\mathbb{R}^3$, so that the reciprocal radius
   *is* the index $n$. The question addressed is whether the **Abelian mean** of the correlation — the
   cone residue — carries the same information as the target $S(x)=o(x)$. Answer: it is implied by the
   target and by Tao's log-averaged theorem, and it does **not** imply the target.
2. **The shift-2 core** (`ConeLean/ShiftTwoCore.lean`, `ConeLean/ChowlaEquiv.lean`). The exact finite
   parity split of shift $2$ into the shift-1 correlation at half scale plus an odd core, the reduction
   of the core to a sum of $\lambda$ over the quadratic polynomial $4k^2-1$, and the equivalent
   four-sign-pattern form of the target.
3. **The barriers** (`ConeLean/ParityObstruction.lean`, `ConeLean/ResidueReduction.lean`,
   `ConeLean/ShiftBarrier.lean`, `ConeLean/SpectralStructure.lean`,
   `ConeLean/LogAverageBarrier.lean`). The parity obstruction (no Euler product, no multiplicative
   Dirichlet convolution), the Abel/log-averaging barrier, the shift-average barrier, the finite
   Wiener–Khinchin identity behind the harmonic-analysis route, and the log-average's blindness to sets
   of zero harmonic density.
4. **The three thresholds** (`TppLean/`). The internal rh42 result `p_N < p_P < p_*` for the rh42
   budgets, ledger row **T14**, proved by monotonicity plus certified rational arithmetic, together with
   the radial-pair threshold $p_P<p_{\text{pair}}<p_*$ (`ConeLean/PairThreshold.lean`) and the pair
   census/brown-completeness material (`ConeLean/PairCensus.lean`).

Throughout, "PROVED" means a named Lean 4 + Mathlib declaration with no `sorry`, "MEASURED" means a
finite numerical diagnostic (which proves nothing about asymptotics), and "EXTERNAL" means a cited
published result not reproved here.

## 2. Setup and definitions

**Liouville function and the budgets.** $\lambda(n)=(-1)^{\Omega(n)}$, completely multiplicative. For
real $p>1$, the **real Dirichlet series**, the **positive budget** and the **negative budget** are
```lean
noncomputable def ZetaR (p : ℝ) : ℝ := ∑' n : ℕ, ((n : ℝ) ^ p)⁻¹
noncomputable def BPos  (p : ℝ) : ℝ := (2 : ℝ) ^ (-p) * ZetaR p
noncomputable def BNeg  (p : ℝ) : ℝ := ∑' k : ℕ, ((2 * (k : ℝ) + 3) ^ p)⁻¹
```
that is,
$$\zeta(p) := \mathtt{ZetaR}\,p = \sum_{n\ge1}\frac{1}{n^p},\qquad
P(p) := \mathtt{BPos}\,p = 2^{-p}\zeta(p) = \sum_{k\ge0}\frac{1}{(2k+2)^p},\qquad
N(p) := \mathtt{BNeg}\,p = \sum_{k\ge0}\frac{1}{(2k+3)^p}.$$
$P$ sums the **even** denominators from $2$; $N$ sums the **odd** denominators from $3$. The source's
positive budget is $P$, its negative budget is $N-1$, and its closed form for the negative side is
$\mathtt{Nside}(p) = (1-2^{-p})\zeta(p) = N(p)+1$. The source's two budget identities (ledger rows
T2–T3) are
$$P(p)+N(p) = \zeta(p)-1,\qquad P(p)-N(p) = 1-\eta(p),\qquad
\eta(p) = \sum_{n\ge1}\frac{(-1)^{n-1}}{n^p} = (1-2^{1-p})\zeta(p).$$
$P-N = 1-\eta(p) > 0$ always: **the positive side is the cheaper one**, and everything in T14 is a
quantitative consequence of that asymmetry. The formula $P(p)+N(p)=\zeta(p)-1$ as written is the
source's rearrangement; the development does **not** formalise it (see §5) but proves the separation
$N<P$ directly.

**The three thresholds.** Table 1 gives the thresholds of T14 as the source states them, verified at
$80$ digits by the source's root-finding:

| threshold | defining equation | value | meaning |
|---|---|---|---|
| $p_*$ | $\zeta(p)=2$ | $1.7286472389981836181$ | combined budget $P+N=\zeta-1$ reaches $1$ |
| $p_P$ | $2^{-p}\zeta(p)=1$ | $1.4649845878051603837$ | positive budget reaches $1$ |
| $p_N$ | $(1-2^{-p})\zeta(p)=2$ | $1.3777851698375411838$ | negative budget $N(p)$ reaches $1$ |

**T14 (the claim):** $p_N < p_P < p_*$. Ledger status before this work: **VERIFIED** (numerical
`findroot` at $80$ dps, residual $<10^{-30}$). After: **PROVED** and machine-checked.

**A normalisation to keep straight.** The source writes the negative equation as
$(1-2^{-p})\zeta(p)=2$, i.e. in terms of the budget $N(p)=1$ (the source's Appendix A annotates $p_N$
as "$N(p)=1$"). The development's **primary formal objective** instead fixes the negative budget at
level $2$: $N(p_N)=2$, the crossing value $1.2136006221625785622$ (as recorded in the folder's own
`LEAN-README.md`). These are two different points on the same strictly decreasing function, and the
development proves the ordering at level $2$ (`tpp_rh42_three_thresholds`) **and** for an arbitrary
level $L\ge1$ (`tpp_rh42_three_thresholds_level`), so the source's own normalisation $L=1$ is covered
as an instance. The **values themselves are not formalised**; §5 returns to this.

**Why not Mathlib's `riemannZeta`?** Mathlib provides `riemannZeta : ℂ → ℂ`. It is complex-valued, so
it has no order structure to exploit; it carries no monotonicity statement on $(1,\infty)$; and it
carries no numeric bounds — nothing in Mathlib turns it into a rational enclosure, and its definitional
unfolding goes through the completed zeta function and the functional equation rather than the
Dirichlet series. The object one actually wants is the Dirichlet series, which is what `ZetaR` is. The
two are not left disconnected: on the real axis above $1$ they agree, and the bridge is **proved**
(§3.4).

**Cone data (`ConeLean/Cone.lean`).**
```lean
def coneRadius (p : ℝ) (n : ℕ) : ℝ := (n : ℝ) ^ (-p)          -- r_n = n^{-p}
def coneIndex  (p : ℝ) (r : ℝ) : ℝ := r ^ (-(1 / p))          -- index readout
def pairWeight (p : ℝ) (n : ℕ) : ℝ := ((n : ℝ) * ((n : ℝ) + 2)) ^ (-p)
def critWeight (n : ℕ) : ℝ := ((n : ℝ) * ((n : ℝ) + 2)) ^ (-(1 / 2 : ℝ))
```

**The correlation sequence (`ConeLean/ChowlaEquiv.lean`, `ParityObstruction.lean`).** With
$\lambda$ written as a real number, `lam n = (liouville n : ℝ)`, and the window
$\mathrm{window}(N) = \{1,\dots,N-2\}$:
$$S(N) := \mathtt{chowlaSum}\,N = \sum_{n\in\mathrm{window}(N)}\lambda(n)\lambda(n+2),\qquad
\mathrm{patCount}(N,e_1,e_2) = \#\{n\in\mathrm{window}(N): \lambda(n)=e_1 \wedge \lambda(n+2)=e_2\},$$
and $\mathtt{chowlaAF}$ is $n\mapsto\lambda(n)\lambda(n+2)$ as an `ArithmeticFunction ℤ`.

**Shift-2 data (`ConeLean/ShiftTwoCore.lean`).** $\mathtt{oddLam}(k) = \lambda(2k+1)$; the core
sequence is $k\mapsto\mathtt{oddLam}(k)\cdot\mathtt{oddLam}(k+1) = \lambda(2k+1)\lambda(2k+3)$.

**The cone residue (`notes/residue-verdict.md`).** With $f(n)=\lambda(n)\lambda(n+2)$,
$$C_f(p) = \sum_n f(n)\,(n(n+2))^{-p},\qquad
\mathrm{residue} = \lim_{\varepsilon\downarrow0}\varepsilon\,C_f\!\left(\tfrac12+\tfrac{\varepsilon}{2}\right),$$
and the **Abelian mean** at parameter $\varepsilon>0$ is
$$\mathtt{abelMean}(f,\varepsilon) = \varepsilon\sum_n f(n)\,n^{-1-\varepsilon}.$$
The residue is the Abelian mean, not the Cesàro mean; the identification of the two transforms is the
content of the (1c) comparison below.

**Barrier data.** The **two-spike sequence** $\mathtt{spike}(n) = \mathbf{1}_{n\in\{0,1\}}$ and its
aperiodic autocorrelation $\mathtt{corr}(f,N,h) = \sum_{n<N}f(n)f(n+h)$; the **block indicator**
$\mathtt{block}(N,n) = \mathbf{1}_{N/2\le n<N}$; the **autocorrelation** and **power spectrum** of
$\Phi:\mathbb{Z}/N\to\mathbb{C}$,
$$\mathtt{autocorr}(\Phi,h) = \sum_{j\in\mathbb{Z}/N}\Phi(j+h)\overline{\Phi(j)},\qquad
\mathtt{dft}(\Phi,k) = \text{the Fourier transform}.$$

**Pair threshold data (`ConeLean/PairThreshold.lean`, `PairCensus.lean`).** The radial-pair alphabet
$$a_k = (4k+2)^{-p}+(4k+4)^{-p},\qquad k=0,1,2,\dots,$$
i.e. $P(p)=2^{-p}\zeta(p)$ grouped into consecutive radial pairs $\{2,4\},\{6,8\},\{10,12\},\dots$;
$\sum_k a_k = P(p)$; Brown's first completeness condition $a_0\le\sum_{k\ge1}a_k$ reads
$2+2^{1-p}\le\zeta(p)$, so the pair-completeness threshold $p_{\text{pair}}$ is the root of
$$\Psi(p) := \zeta(p) - 2 - 2^{1-p} = 0.$$
The set of finite sub-sums is
$\mathtt{SubSumIco}(a,m,n) = \{\sum_{i\in I}a_i : I\subseteq[m,n)\}$.

**Build.** `./check.sh --all` elaborates both developments, $15$ files in dependency order:
`TppLean` first (`TppLean.ThreeThresholds` imports `TppLean.Budget`), then `ConeLean`
(`ShiftTwoCore` imports `ChowlaEquiv`; `Cone` imports `TppLean.Budget`; `PairThreshold` imports `Cone`
and `TppLean.ThreeThresholds`). `check.sh` reconstructs `LEAN_PATH` from `lake env` inside Mathlib at
`$LEAN_PREFIX` (default `$HOME/lean`) and invokes the toolchain binary directly; there is no `lake`
project file. Toolchain: Lean `v4.35.0-rc2`.

## 3. Results

### 3.1 The cone and its index readout (PROVED)

* `ConeLean.coneIndex_coneRadius`: for $p\ne0$ and $n\ge1$, $\ \mathtt{coneIndex}\,p\,(\mathtt{coneRadius}\,p\,n) = n$:
  the reciprocal radius is the index itself.
* `ConeLean.coneRadius_injective`: for $p>0$, $n\mapsto n^{-p}$ is injective. **The radius determines
  the index.** (The helix is the degenerate case $p=0$, where the radius is identically $1$ and this
  fails.)
* `ConeLean.inv_add_two_le_critWeight` and `ConeLean.critWeight_le_inv`: the critical-cone sandwich
  $$(n+2)^{-1} \le (n(n+2))^{-1/2} \le n^{-1}\qquad(n\ge1).$$
* `ConeLean.critWeight_error_le`, `ConeLean.summable_critWeight_error`,
  `ConeLean.summable_critWeight_sub_inv_mul`: $n^{-1}-(n(n+2))^{-1/2}\le 2/(n(n+2))$, the series
  $\sum_n 2/(n(n+2))$ converges, and for every bounded correlation $f$ the series
  $\sum_n f(n)(\mathtt{critWeight}\,n - n^{-1})$ is absolutely convergent. Hence **the critical-cone
  transform is the log-Chowla transform up to $O(1)$**.
* `ConeLean.pairSeparation_eq`: at $p=1$ the radial separation of a pair is exactly twice the pair
  weight, $n^{-1}-(n+2)^{-1} = 2\,\mathtt{pairWeight}\,1\,n$.
* **The one-power dichotomy**: `ConeLean.shiftDiff_le` gives, for $p>0$ and $n\ge1$,
  $$n^{-p}-(n+2)^{-p} \le 2p\,n^{-p-1},$$
  and `ConeLean.summable_shiftDiff` gives that the shift-difference series
  $\sum_n (n^{-p}-(n+2)^{-p})$ is absolutely convergent for every $p>0$. Differencing along the shift
  costs one power; the mean value lives only in the *undifferenced* channel.

### 3.2 The cone residue (PROVED, conditionally on an EXTERNAL theorem, plus an EXTERNAL counterexample)

The logical geography, as the source states it:

```
                 log-average  Σ_{n≤x} f(n)/n = o(log x)     ← external input: Tao 2015
                          │                                  (reduction MACHINE-CHECKED)
                          ▼
  Cesàro  Σ_{n≤x} f(n) = o(x) ──►  residue = 0  ◄── (1c) the pair weight differs by O(1)
                          MACHINE-CHECKED
                          ▲
                          └── the converse FAILS
```

**Discrete Abel summation (PROVED, `ConeLean.sum_mul_eq`).** For any $f,w:\mathbb{N}\to\mathbb{R}$ and
every $N$,
$$\sum_{n<N} f(n)w(n) = M(N)\,w(N-1) - \sum_{n<N-1} M(n+1)\bigl(w(n+1)-w(n)\bigr),\qquad
M(N) = \mathtt{partSum}\,f\,N = \sum_{i<N} f(i).$$

**The weight-difference bound (PROVED, `ConeLean.abelWeight_sub_le`).** For $w_\varepsilon(n)=n^{-1-\varepsilon}$,
$\varepsilon>0$, $n\ge1$: $w_\varepsilon(n)-w_\varepsilon(n+1)\le(1+\varepsilon)n^{-2-\varepsilon}$.
Supporting: `summable_abelWeight`, `summable_mul_abelWeight`, `abelWeight_mono`,
`abelWeight_diff_nonneg`, `sum_abelWeight_diff`, `mul_abelWeight_pred_le` ($N\,w_\varepsilon(N-1)\le4$
for $N\ge2$, $\varepsilon\le1$), `tsum_abelWeight_tail_le`
($\sum_{n\ge X}n^{-1-\varepsilon}\le(X-1)^{-\varepsilon}/\varepsilon$ for $X\ge2$),
`sum_abelWeight_gap_le` (the gaps telescope: $\sum_{n<X}|w(n+1)-w(n)|\le2$ for $X\ge1$),
`abs_partSum_le`, `abel_partial_bound`, `abel_tsum_bound`.

**Cesàro $\Rightarrow$ Abel (PROVED, `ConeLean.abelMean_tendsto_zero`).** If $f$ is bounded,
$|f(n)|\le1$, and its Cesàro mean vanishes, $\sum_{n\le x}f(n)=o(x)$, then
$$\lim_{\varepsilon\downarrow0}\ \varepsilon\sum_n f(n)\,n^{-1-\varepsilon} = 0.$$

**Log-average $\Rightarrow$ Abel (PROVED, `ConeLean.abelMean_tendsto_zero_of_logAverage`).** If $f$ is
bounded and the logarithmic average of $f$ vanishes — $\sum_{n\le N} f(n)/n = o(\log N)$, which for
$f(n)=\lambda(n)\lambda(n+2)$ is **Tao's log-averaged two-point Chowla theorem** (EXTERNAL) — then the
Abelian mean vanishes. The intermediate bounds are `ConeLean.abel_tsum_le_of_logAverage`
($|\sum' f(n)n^{-1-\varepsilon}|\le\varepsilon K + 8\,\mathrm{lam}/\varepsilon$),
`ConeLean.log_abel` (Abel summation in log form), `ConeLean.sq_mul_log_tail_le` (the log-weighted tail
constant $\varepsilon^2\sum_{n\ge X}\log(n+1)n^{-1-\varepsilon}\le8$), `log_abelWeight_le`,
`rpow_neg_gap_le`, `log_abel_partial_le`, `tendsto_log_mul_rpow_neg`.

**The pair transform versus the Dirichlet series ((1c); PROVED, `ConeLean.coneTransform_sub_dirichlet_le`).**
For $f$ bounded and $1/2<p\le1$,
$$\Bigl|\sum_n \bigl(f(n)\,\mathtt{pairWeight}\,p\,n - f(n)\,n^{-2p}\bigr)\Bigr| \;\le\; 2\sum_n n^{-2},$$
a bound that does **not** depend on $p$ (the dominating series is the $p$-series at $2$). At
$p=1/2+\varepsilon/2$ this reads $C_f(1/2+\varepsilon/2) = F(1+\varepsilon)+O(1)$ uniformly in
$\varepsilon\in(0,1]$: **the pair transform's residue is the Dirichlet-series residue.** The per-term
input is `ConeLean.pairWeight_sub_le` — $|(n(n+2))^{-p}-n^{-2p}|\le 2n^{-2}$ for $1/2\le p\le1$ —
proved by the mean-value theorem on $x\mapsto x^{-p}$ over $[n,n+2]$
(`ConeLean.rpow_neg_gap_two`: $n^{-p}-(n+2)^{-p}\le 2p\,n^{-p-1}$). The source records that an earlier
attempt at this item failed on real-power bookkeeping ($(n\cdot n)^{-p}=n^{-2p}$ is where the rewrites
bit) and that the working proof avoids it by comparing $n^{-p}(n+2)^{-p}$ with $n^{-p}n^{-p}$ directly.

**The converse fails (EXTERNAL).** For $\theta\ne0$ let $f(n)=\cos(\theta\log n)$. Then $|f|\le1$ and
the associated Dirichlet series is $(\zeta(s-i\theta)+\zeta(s+i\theta))/2$, holomorphic at $s=1$ (its
poles are at $s=1\pm i\theta$), so $\lim_{\varepsilon\downarrow0}\varepsilon\sum_n f(n)n^{-1-\varepsilon}=0$.
But
$$\sum_{n\le x}\cos(\theta\log n) = \mathrm{Re}\Bigl(\frac{x^{1+i\theta}}{1+i\theta}\Bigr)+O(1),$$
whose absolute value is $\asymp x/\sqrt{1+\theta^2}$ — **not** $o(x)$. So $\mathrm{residue}=0$ does
**not** imply $o(x)$. The source labels this EXTERNAL/classical (the standard illustration that the
Dirichlet-series Abelian mean is not equivalent to the Cesàro mean for bounded sequences, in contrast
with the power-series case where Hardy–Littlewood do give equivalence), cites G. H. Hardy,
*Divergent Series* (Oxford, 1949) and the Hardy–Littlewood Tauberian papers, and records plainly that
**the specific page was not verified in the session** and that this item is deliberately **not**
machine-checked (the estimate $\sum_{n\le x}n^{i\theta}=x^{1+i\theta}/(1+i\theta)+O(1)$ needs
Euler–Maclaurin-type input Mathlib does not currently provide for this shape).

**The verdict on the residue (as the source states it).** The residue vanishes, conditional on Tao's
log-averaged two-point Chowla theorem (**PROVED-modulo-external, machine-checked reduction**);
$o(x)$ implies the residue vanishes (**PROVED**); the residue does **not** imply $o(x)$ (**EXTERNAL
counterexample**); and $o(x)$ is equivalent to the four-density-$1/4$ statement (**PROVED**, §3.3).
The residue is therefore a theorem, not open — and **strictly weaker** than the target, so it cannot be
used to reach it. The source calls that asymmetry the single most useful thing established.

### 3.3 The shift-2 core (PROVED) and its erratum

**The two identities (PROVED, `ConeLean.ChowlaEquiv`).** With the window $\{1,\dots,N-2\}$,
$$\mathtt{chowlaSum}\,N = 2\,\mathtt{eqCount}\,N - (N-2) \qquad(\mathtt{chowlaSum\_eq}),$$
$$4\,\mathtt{patCount}(N,e_1,e_2) = (N-2) + e_1\sum_{n\in\mathrm{window}(N)}\lambda(n)
+ e_2\sum_{n\in\mathrm{window}(N)}\lambda(n+2) + e_1e_2\,\mathtt{chowlaSum}\,N
\qquad(\mathtt{patCount\_mul\_four}),$$
for $e_1^2=e_2^2=1$. Combining them with the one-point input
$\sum_{n\le x}\lambda(n)=o(x)$ (PNT, in its two shifted forms) gives the **equivalence**
(`ConeLean.chowlaSum_tendsto_iff_patCount_tendsto`): $S(x)=o(x)$ holds **if and only if** each of the
four sign patterns of $(\lambda(n),\lambda(n+2))$ has density $1/4$. This is the Lean counterpart of
Theorem 3.5 of the programme's dictionary `03-parity-problem.md`.

**The parity split of shift 2 (PROVED, `ConeLean.chowlaSum_shift_two_split`).** For every $M$,
$$\sum_{n<2M}\lambda(n)\lambda(n+2) = \sum_{j<M}\lambda(j)\lambda(j+1)
+ \sum_{k<M}\lambda(2k+1)\lambda(2k+3).$$
The even part is the shift-1 correlation because
`ConeLean.lam_even_shift_two`: $\lambda(2j)\lambda(2j+2)=\lambda(j)\lambda(j+1)$, which uses complete
multiplicativity `ConeLean.lam_mul` and `ConeLean.lam_two` ($\lambda(2)=-1$).

**Related structure (PROVED).**
* `ConeLean.prime_dvd_shift_two`: if a prime $p$ divides both $n$ and $n+2$ then $p=2$. **No further
  reduction of the shift exists** — the substitution above is the only one of its kind.
* `ConeLean.core_diff_squares`: the core is a difference of squares,
  $(2k+1)(2k+3) = (2k+2)^2-1$.
* `ConeLean.core_coprime`: the core's arguments are coprime, $\gcd(2k+1,2k+3)=1$, so no shared-factor
  mechanism is available there.
* `ConeLean.chowlaAF_not_multiplicative`, `ConeLean.chowlaAF_not_conv` (in `ParityObstruction.lean`):
  the correlation sequence is **not** multiplicative and is **not** the Dirichlet convolution of two
  multiplicative arithmetic functions. `ConeLean.chowlaAF_one` records $f(1)=-1$, whereas
  multiplicativity would force $f(1)=1$. Since a convolution of multiplicative functions is
  multiplicative, the classical Type-II shape (model $\Lambda=\mu*\log$) is closed for $f$: the algebra
  is machine-checked, not merely cited.
* `ConeLean.core_not_multiplicative`, `core_not_multiplicative_lam`,
  `ConeLean.oddLam_not_multiplicative`: the **core** is not multiplicative either — witness $k=2$,
  $m=5$ (coprime), where the core at $km=10$ is $\lambda(21)\lambda(23)=-1$ while the product of the
  core values is $+1$; and the underlying sequence $\mathtt{oddLam}(k)=\lambda(2k+1)$ is not
  multiplicative, witness $k=3$, $m=5$ ($g(15)=\lambda(31)=-1$ while $g(3)g(5)=\lambda(7)\lambda(11)=+1$).
  The source labels this a *reason*, not a proof that the Matomäki–Radziwiłł–Tao mechanism cannot be
  adapted.

**What the split actually gives (PROVED, `ConeLean.shift_two_of_shift_one_and_core`).** If
$$\lim_{M\to\infty}\frac{1}{M}\sum_{j<M}\lambda(j)\lambda(j+1)=0
\quad\text{and}\quad
\lim_{M\to\infty}\frac{1}{M}\sum_{k<M}\lambda(2k+1)\lambda(2k+3)=0,$$
then $\lim_{M\to\infty}\frac{1}{2M}\sum_{n<2M}\lambda(n)\lambda(n+2)=0$: a **sufficiency**.

**Erratum, quoted from the source and kept visible (this is a correction of an earlier wrong claim).**
An earlier version of `ConeLean/ShiftTwoCore.lean` described the shift-1 correlation
$\sum_n\lambda(n)\lambda(n+1)$ as **SOLVED** (Matomäki–Radziwiłł–Tao). **That is FALSE.** The
un-averaged Chowla conjecture is open for every $k\ge2$, i.e. for every shift: Matomäki–Radziwiłł–Tao,
*An averaged form of Chowla's conjecture*, Algebra & Number Theory **9** (2015) 2167–2196
(arXiv:1503.05121), state verbatim that the conjecture "remains unproven for any $h_1,\dots,h_k$ with
$k\ge2$". What they prove is the average over shifts. What is known for $k=2$ is (i) the shift-averaged
form (ibid.), (ii) the logarithmically averaged form (Tao 2015), and (iii) the un-averaged form for all
scales outside a set of zero logarithmic density (Tao–Teräväinen, ANT **13** (2019) 2103–2150,
arXiv:1809.02518). **No un-averaged case at a prescribed scale is known.** Consequently the converse of
the split **fails in general** (the two halves can cancel), so shift 2 is *not* equivalent to the core,
and — both halves being open — the split does not reduce the problem to a solved case. The file's own
formulation: the split is an identity "not a reduction to something known", whose correct consequence is
a sufficiency; "nothing in the literature distinguishes the halves". Equivalent picture:
$\lambda(n)\lambda(n+2)=\lambda((n+1)^2-1)$, so shift 2 is $\sum_m\lambda(m^2-1)$ over all $m$, and the
two halves are its odd-$m$ and even-$m$ parts.

### 3.4 The bridge to Mathlib's zeta (PROVED)

**`TppLean.ZetaR_eq_riemannZeta_re`.** For real $p>1$,
$$\mathtt{ZetaR}\,p = \bigl(\mathtt{riemannZeta}\,(p:\mathbb{C})\bigr).\mathrm{re}.$$
*Proof.* `zeta_eq_tsum_one_div_nat_cpow` writes
$\zeta(s)=\sum'_n 1/(n:\mathbb{C})^s$ whenever $1<s.\mathrm{re}$. Each summand is the coercion of a real
one: $(n:\mathbb{C})^p = \uparrow((n:\mathbb{R})^p)$ by `Complex.ofReal_cpow` with
`Complex.ofReal_natCast`, and $1/\uparrow x=\uparrow(x^{-1})$ by `Complex.ofReal_inv`. So the complex
series is exactly $\uparrow(\sum'_n((n:\mathbb{R})^p)^{-1})$, by `Complex.ofReal_tsum` — the coercion
commutes with the infinite sum — and `Complex.ofReal_re` reads off the real part.

**Corollaries.** `TppLean.BPos_eq_riemannZeta_re`:
$P(p) = 2^{-p}\,\mathrm{Re}\,\zeta(p)$ for $p>1$; and `TppLean.Nside_eq_riemannZeta_re`:
$\mathtt{Nside}(p) = (1-2^{-p})\,\mathrm{Re}\,\zeta(p)$. So both budgets of the source's §5.1 are
expressed against the classical $\zeta$, not merely against the series.

**The no-go companion, `TppLean.BPos_ne_riemannZeta_re`.** $P(2)\ne\mathrm{Re}\,\zeta(2)$. The factor
$2^{-p}$ is not decoration: $P$ sums over even denominators only, so $P(p)=2^{-p}\mathrm{Re}\,\zeta(p)$,
whereas $\mathrm{Re}\,\zeta(p)$ is $\mathtt{ZetaR}\,p$ itself; at $p=2$ the two differ by a factor of
$4$ ($P(2)=\pi^2/24$ against $\mathrm{Re}\,\zeta(2)=\pi^2/6$). The proof needs **no evaluation of
$\zeta(2)$**: if the two agreed then $\mathrm{Re}\,\zeta(2)=\tfrac14\mathrm{Re}\,\zeta(2)$, hence
$\mathrm{Re}\,\zeta(2)=0$, contradicting `TppLean.ZetaR_pos`. The source records the false form next to
its true neighbour deliberately, as the precise mistake the notation invites.

### 3.5 The barriers (PROVED)

**(b1) Finite Wiener–Khinchin (`ConeLean/SpectralStructure.lean`).** For $\Phi:\mathbb{Z}/N\to\mathbb{C}$,
$$ \mathtt{dft}(\mathtt{autocorr}\,\Phi)(k) = \mathtt{dft}(\Phi)(k)\cdot\overline{\mathtt{dft}(\Phi)(k)}
\qquad(\mathtt{dft\_autocorr}),$$
the Fourier transform of the autocorrelation is the power spectrum — the structure route
"harmonic analysis of $h\mapsto\sum_{n\le x}\lambda(n)\lambda(n+h)$" consumes. With it, the two
directions of the equivalence:
* `ConeLean.dft_mul_star_dft_eq_of_corr_eq_zero`: if every nonzero shift has zero autocorrelation then
  the power spectrum is constant, $(\mathtt{dft}\,\Phi\,k)\overline{(\mathtt{dft}\,\Phi\,k)} = \mathtt{autocorr}\,\Phi\,0$;
* `ConeLean.corr_eq_zero_of_dft_mul_star_dft_eq`: conversely, a flat spectrum,
  $(\mathtt{dft}\,\Phi\,k)\overline{(\mathtt{dft}\,\Phi\,k)}=c$ for all $k$, forces
  $\mathtt{autocorr}\,\Phi\,j=0$ for every $j\ne0$. This second direction is where the arithmetic
  content of the route sits: it uses Fourier inversion together with the orthogonality of the standard
  additive character (`AddChar.sum_mulShift` and primitivity of `stdAddChar`), i.e. exactly the step
  saying "no periodic/pretentious component". The only non-Mathlib ingredient is
  `ConeLean.star_stdAddChar` ($\overline{\ }$ inverts the character), proved via `Circle.coe_inv_eq_conj`.

**(b2) The shift-average and scale-average barriers (`ConeLean/ShiftBarrier.lean`).**
* `ConeLean.corr_spike_eq_zero`, `corr_spike_one`, `corr_spike_zero`: for the two-spike sequence,
  $\mathtt{corr}(N,h)=0$ for $h\ge2$, $=1$ at $h=1$ and $=2$ at $h=0$ (for $N\ge2$).
* `ConeLean.sum_abs_corr_spike_le`: the total correlation mass is at most $3$ for every $N\ge2$,
  $\sum_{h<N}|\mathtt{corr}\,\mathtt{spike}\,N\,h|\le3$.
* **`ConeLean.shift_average_does_not_control_single`.** For $N\ge2$ there is a sequence
  $f:\mathbb{N}\to\mathbb{R}$ with $|f(n)|\le1$, total correlation mass
  $\sum_{h<N}|\mathtt{corr}\,f\,N\,h|\le3$ — average $3/N\to0$ — and prescribed shift $h=1$ carrying
  correlation exactly $1$. So an almost-all-shifts statement **cannot**, on its own, deliver a
  prescribed shift such as the Chowla shift $h=2$; the averaging must be paid for by additional input.
* `ConeLean.sum_block_eq`: $\sum_{n<x}\mathtt{block}(N,n) = \bigl(\min(x,N)-N/2\bigr)$.
* **`ConeLean.scale_average_does_not_control_prescribed`**, the scale-side analogue: for every $N\ge2$
  there is a bounded sequence whose partial sums vanish at every scale up to $N/2$, equal $N-N/2$ at the
  prescribed scale $N$, and are $O(1)$ from $N$ onward. The "conspiracy" is confined to a single window
  of scales, so any almost-all-scales statement is blind to it.

**(b3) The log-average barrier (`ConeLean/LogAverageBarrier.lean`).**
* `ConeLean.sum_inv_sq_le_zeta_two`: $\sum_{n\le N}1/n^2\le\pi^2/6$ — the harmonic weight of the
  squares is bounded (Mathlib's `hasSum_zeta_two`).
* `ConeLean.tendsto_sum_inv_sq_div_log`: $\bigl(\sum_{n\le N}1/n^2\bigr)/\log N\to0$.
  So the log-average is **blind to the squares**: their harmonic weight is bounded while (ARGUMENT, not
  mechanised: there are $C+1$ squares among $0,\dots,C^2$) their counting function is unbounded. The
  log-average's weight is $1/n$, so a set of zero harmonic density is invisible to it however many
  elements it has — the quantitative reason a log-averaged theorem cannot certify a prescribed scale.
* `ConeLean.zero_log_density_meets_every_dyadic_block`: an exceptional set of zero logarithmic density
  can intersect **every** dyadic block; here $\sum_k 2^{-k}\le2$ while $2^k\in[2^k,2^{k+1})$ for every
  $k$. Nothing about the *structure* of an exceptional set follows from its density alone.

### 3.6 The three thresholds (PROVED)

**The abstract ordering core (`TppLean/Core.lean`, proved for arbitrary real functions).**
```lean
structure CrossesOnce (B : ℝ → ℝ) (q L : ℝ) : Prop where
  cont      : ContinuousOn B (Set.Ici q)
  anti      : ∀ x y, q < x → q < y → x < y → B y < B x
  above_q   : L < B q
  below_far : ∃ x, q < x ∧ B x < L
```
**Theorem 3.1 (`TppLean.CrossesOnce.exists_unique`).** If `CrossesOnce B q L` then there is exactly one
$c>q$ with $B(c)=L$. *Proof.* Apply `intermediate_value_Icc'` on $[q,x]$ to
$L\in[B(x),B(q)]$; the endpoint $c=q$ is excluded by `above_q`. Uniqueness is real trichotomy: a second
solution $d$ on either side of $c$ violates `anti`, giving $L<L$. $\blacksquare$

`TppLean.BudgetHyp` packages the two crossings at levels $1$ and $2$ plus $G<F$; and
`TppLean.threshold_ordering` proves $p_G<p_F$: suppose $p_F\le p_G$. Since $G<F$ everywhere and
$F(p_F)=1$, we get $G(p_F)<1$; but if $p_F<p_G$ then antitonicity gives $G(p_F)>G(p_G)=2$, and if
$p_F=p_G$ then $G(p_F)=2$. Either way $G(p_F)$ is both below $1$ and at least $2$.

**The moral, as the source states it.** The ordering of two crossings is *order theory*, not analysis.
Analysis is needed only to know that the crossings exist and are unique — and even that is not needed to
*state* T14, because T14 is a statement about solutions given by their defining equations. The source
records that the abstract core is therefore **not on the critical path** of the concrete theorem: the
concrete assembly uses trichotomy directly, which is the same argument with continuity removed. This is
a redundancy, not a gap.

**Strict antitonicity (PROVED).** `TppLean.ZetaR_strictAnti`: for $1<p<q$, $\zeta(q)<\zeta(p)$ — the
fact Mathlib does not have, and where the "value-free" claim is earned. *Proof.* Write
$c(n)=n^{-p}-n^{-q}$. Because $n\mapsto n^{-x}$ is decreasing in $x$ for $n>1$, every $c(n)$ is
nonnegative, and $c(0)=0$; the $n=2$ term is **strictly** positive since $2^{-q}<2^{-p}$. Hence the
difference series has strictly positive sum, by `Summable.le_tsum` applied at index $2$; since both
series are summable, `Summable.tsum_sub` identifies the difference of the sums with the sum of the
differences, so $\zeta(p)-\zeta(q)>0$. The strictness matters: at $p_*$ the two budgets sum to exactly
$1$, so the inequalities are tight at the endpoints, and a non-strict version would not do. Companions:
`TppLean.BPos_strictAnti`, `TppLean.BNeg_strictAnti`, `TppLean.summable_zetaR`,
`TppLean.summable_shift`, `TppLean.summable_BNeg`, `TppLean.zetaR_shift`,
`TppLean.zetaR_eq_shift_neg`, `TppLean.summable_shift_neg`.

**The floor oracle (PROVED, `TppLean/ThreeThresholds.lean`).** To bracket $\zeta(r)$ at a rational
$r=\mathtt{num}/\mathtt{den}$, the partial sums are computed by the kernel rather than asserted; the
obstacle is that $10^9/k^{\mathtt{num}/\mathtt{den}}$ is irrational for the exponents needed, so the
summands cannot be natural numbers. The resolution: compute exact **floors** at scale
$\mathtt{SCn}=10^9$ and absorb the floor error into the tail term.
```lean
def SCn : ℕ := 10 ^ 9
def go (den knum : ℕ) : ℕ → ℕ → ℕ → ℕ
  | 0, lo, _ => lo
  | f + 1, lo, hi =>
      if lo + 1 < hi then
        let mid := (lo + hi) / 2
        if mid ^ den * knum ≤ SCn ^ den then go den knum f mid hi
        else go den knum f lo mid
      else lo
def fpow (num den k : ℕ) : ℕ := if k = 0 then SCn else go den (k ^ num) 64 0 (SCn + 1)
```
`go` is a binary search for the largest $j$ with $j^{\mathtt{den}}\cdot\mathtt{knum}\le\mathtt{SCn}^{\mathtt{den}}$;
its correctness is a single induction on the fuel with three invariants (`TppLean.go_spec`), and
`TppLean.fpow num den k` is exactly $\lfloor 10^9/k^{\mathtt{num}/\mathtt{den}}\rfloor$. Four lemmas say
so in the two directions needed: `fpow_valid`, `fpow_max`, `fpow_le`
($\mathtt{fpow}\le \mathtt{SCn}/k^{\mathtt{num}/\mathtt{den}}$ as a real), and `le_fpow`
($\mathtt{SCn}/k^{\mathtt{num}/\mathtt{den}} < \mathtt{fpow}+1$). The step from the integer statement
`fpow_valid` to the real statement `fpow_le` is where the irrational exponent is handled: raise both
sides to the $\mathtt{den}$-th power, use $(k^{\mathtt{num}/\mathtt{den}})^{\mathtt{den}}=k^{\mathtt{num}}$
(`TppLean.rpow_div_pow`, from `Real.rpow_mul`), and take $\mathtt{den}$-th roots with
`pow_le_pow_iff_left₀`.

**The bridges (PROVED).** With $\mathtt{sumF}\,\mathtt{num}\,\mathtt{den}\,N = \sum_{k<N}\mathtt{fpow}\,\mathtt{num}\,\mathtt{den}\,(k+1)$,
$$\mathtt{sumF}\le 10^9\sum_{k<N}(k+1)^{-\mathtt{num}/\mathtt{den}}
\qquad(\mathtt{sumF\_le\_zetaR\_partial}),$$
$$10^9\sum_{k<N}(k+1)^{-\mathtt{num}/\mathtt{den}} \le \mathtt{sumF}+N
\qquad(\mathtt{zetaR\_partial\_le}).$$
Read together: the certified integer sum and $10^9$ times the true partial sum differ by at most $N$.
The floor error is **asymmetric by construction**: the lower bracket is exact, the upper is too large by
at most $N/10^9$ — exactly the slack structure the application needs. Choosing $N=10^4$ makes the slack
$10^{-5}$ against a tail of $2\times10^{-2}$: two orders of magnitude of room.

**The tail (PROVED).** Mathlib's integral test in the exact indexed form needed:
`TppLean.tail_finite` states that for $p>1$, $N\ge1$ and every $M$,
$\sum_{i<M}(N+i+1)^{-p}\le N^{1-p}/(p-1)$, by `AntitoneOn.sum_le_integral_Ico` on each interval of the
partition and `intervalIntegral.integral_rpow` for the integral; passing to the limit
(`HasSum.tendsto_sum_nat` against a constant sequence) gives the infinite form `TppLean.tsum_tail_le`.
With the split identity `TppLean.ZetaR_split`, this yields the only two statements about $\zeta$ the
rest of the development consumes:
$$\frac{\mathtt{sumF}}{10^9}\ \le\ \zeta(p)
\qquad(\mathtt{ZetaR\_lower}),\qquad
\zeta(p)\ \le\ \frac{\mathtt{sumF}+N}{10^9} + \frac{N^{1-p}}{p-1}
\qquad(\mathtt{ZetaR\_upper}),$$
for $p=\mathtt{num}/\mathtt{den}>1$ and $N^{\mathtt{num}}\le\mathtt{SCn}^{\mathtt{den}}$.

**The four certified brackets (PROVED; Table 2).** $\mathtt{SCn}=10^9$.

| lemma | statement | certificate (integer) | tail |
|---|---|---|---|
| `ZetaR_4_3_gt` | $3.42 < \zeta(4/3)$ | `sumF 4 3 10^4 = 3461687465` | — |
| `ZetaR_3_2_gt` | $2 < \zeta(3/2)$ | `sumF 3 2 10^4 = 2592370811` | — |
| `ZetaR_3_2_lt` | $\zeta(3/2) < 2.64$ | $(\mathtt{sumF}+10^4)/10^9\le2.5924$ | $0.02$ |
| `ZetaR_7_5_lt` | $\zeta(7/5) < 3.13$ | $(\mathtt{sumF}+10^5)/10^9\le3.0806$ | $0.025$ |

The three large integer sum evaluations are closed by `native_decide` at the named values. The two
tails are exactly rational because the truncation lengths are chosen that way: for $p=3/2$, $N=10^4$
the tail is $N^{-1/2}/(1/2)=2\cdot10^{-2}$; for $p=7/5$, $N=10^5$ it is $(5/2)\cdot10^{-2}$. Both are
proved as real equalities by reducing $r^s$ to an integer power via `Real.rpow_mul`; no floating point
enters. Concretely the two upper brackets read
$$\zeta(3/2)\le2.592380811+0.02 = 2.612380811 < 2.64,\qquad
\zeta(7/5)\le3.080597357+0.025 = 3.105597357 < 3.13,$$
and the two lower brackets read $\zeta(4/3)\ge3.461687465>3.42$ and $\zeta(3/2)\ge2.592370811>2$.
Compared with the true values $3.6009$, $2.6124$, $3.1055$, the enclosures are loose by a few percent —
all the argument needs.

**The power comparisons (PROVED; Table 3).** `two_rpow_7_5_lt`, `two_rpow_7_5_gt`,
`two_rpow_7_5_gt_16`, `two_rpow_4_3_lt`, `two_rpow_4_3_gt_25`, `two_rpow_3_2_lt`,
`two_rpow_3_2_gt_282`, `two_rpow_19_10_gt`: each reduces to a single integer inequality discharged by
`decide`, e.g. $2^{7/5}<2.64$ becomes $2^7\cdot100^5<264^5$; $1.6<2^{7/5}$ becomes
$16^5\cdot2^7<10^5\cdot2^{12}$; $2^{4/3}<2.52$ becomes $2^4\cdot100^3<252^3$; $2.5<2^{4/3}$ becomes
$25^3<16\cdot10^3$; $2^{3/2}<2.83$ becomes $2^3\cdot1000^2<2830^2$; $2.82<2^{3/2}$ becomes
$282^2<8\cdot100^2$; $3.73<2^{19/10}$ becomes $373^{10}<100^{10}\cdot2^{19}$. Because both sides are
nonnegative the $k$-th power is monotone, and `pow_le_pow_iff_left₀` converts the integer fact back into
the real one.

**From brackets to budget brackets (PROVED).** `BPos_4_3_gt_one`: $1<P(4/3)$, since
$P(4/3)=2^{-4/3}\zeta(4/3)>(1/2.52)\cdot3.42>1$ using $2^{-4/3}>1/2.52$
(`two_rpow_neg_4_3_gt`); and `BPos_3_2_lt_one`: $P(3/2)<1$, since
$P(3/2)=2^{-3/2}\zeta(3/2)<(1/2.82)\cdot2.64<1$. With antitonicity of $P$ these pin $p_P$ to
$(4/3,3/2)$. Companions: `two_rpow_neg_7_5_gt`, `two_rpow_neg_4_3_lt`, `two_rpow_neg_3_2_lt`,
`Nside_7_5_lt_two`, `Nside_4_3_gt_two`, `ZetaR_22_15_gt`, `ZetaR_22_15_lt`, `ZetaR_7_5_gt_three`,
`ZetaR_8_5_lt`, `Psi_22_15_gt`, `Psi_3_2_lt`, `BPos_22_15_lt_one`, `Psi_strictAnti`,
`Psi_pos_of_lt_seven_fifths`, `Psi_neg_of_eight_fifths_le`.

**Gap (1): the parity separation (PROVED).** `TppLean.BPos_eq_even`:
$P(p)=2^{-p}\zeta(p)=\sum_{k\ge0}(2k+2)^{-p}$ — the positive budget is the even-index sub-series, and
writing it that way is the key move. (Proof: shift $\zeta(p)=\sum_k(k+1)^{-p}$
(`zetaR_eq_shift_neg`), then $2^{-p}(k+1)^{-p}=(2(k+1))^{-p}$ by `Real.mul_rpow`, and pull the factor
through by `tsum_mul_left`.) `TppLean.odd_lt_even`: for $p>1$ and every $k$, $(2k+3)^{-p}<(2k+2)^{-p}$
(proof: $x\mapsto x^p$ is strictly increasing on the positives, so $(2k+2)^p<(2k+3)^p$ by
`Real.rpow_lt_rpow`; inverting a strictly positive inequality reverses it, and $x^{-p}=(x^p)^{-1}$ is
`Real.rpow_neg`). **`TppLean.BNeg_lt_BPos`: for every $p>1$, $N(p)<P(p)$** — rewrite $P$ by
`BPos_eq_even` and apply `Summable.tsum_lt_tsum` with the pointwise bound and the strict witness at
$k=0$; both series are summable (`summable_BNeg`, `summable_even`). The source notes that it proves
$P-N=1-\eta(p)$ and then $\eta(p)<1$, a route needing the alternating-series identity and the
even/odd rearrangement of $\zeta$; **by defining $N$ as its series rather than as
$(1-2^{-p})\zeta(p)-1$, the same content drops out of `tsum_lt_tsum` with no rearrangement at all** —
the single design decision that made gap (1) short.

**The thresholds lie in $(1,\infty)$ (PROVED).** `TppLean.one_lt_of_zetaR_eq`: a crossing of `ZetaR`
past a positive level lies in $(1,\infty)$; below and at $p=1$ the series is not summable, so
`tsum_eq_zero_of_not_summable` gives $\zeta(p)=0$ (the `tsum`-of-a-non-summable-family convention), and
$0\ne2$. `TppLean.one_lt_of_BPos_eq`: likewise for $P(p)=1$.

**Theorem 7.1 — `TppLean.tpp_rh42_three_thresholds` (PROVED).**
```lean
theorem tpp_rh42_three_thresholds (pP pN pstar : ℝ)
    (hP : BPos pP = 1) (hN : BNeg pN = 2) (hstar : ZetaR pstar = 2) :
    pN < pP ∧ pP < pstar
```
**Theorem 7.2 — `TppLean.tpp_rh42_three_thresholds_level` (PROVED).** The same conclusion with the
single extra hypothesis $N(p_N)=L$ for an arbitrary $L\ge1$:
```lean
theorem tpp_rh42_three_thresholds_level (pP pN pstar L : ℝ) (hL : 1 ≤ L)
    (hP : BPos pP = 1) (hN : BNeg pN = L) (hstar : ZetaR pstar = 2) :
    pN < pP ∧ pP < pstar
```
Theorem 7.2 is not a separate argument: it is the proof of Theorem 7.1 with `hL` added. Its point is
that the source's own normalisation is $L=1$, so the source's claim is an instance.

**The five moves of the assembly** (everything is monotonicity applied to the three antitonicity lemmas,
with the brackets of §3.6 supplying the numeric anchors):
1. **$1<p_P$** (`one_lt_of_BPos_eq`): if $p_P\le1$ then the series is not summable,
   $\zeta(p_P)=0$, so $P(p_P)=0\ne1$.
2. **$4/3<p_P$**: trichotomy on $(4/3,p_P)$; the equal case contradicts `BPos_4_3_gt_one` against
   `hP`; the decreasing case $p_P<4/3$ uses `BPos_strictAnti` (legitimate by move 1) to get
   $P(4/3)<P(p_P)=1$, contradicting $P(4/3)>1$.
3. **$N(p_P)<1$**: apply gap (1) at $p_P$ (legitimate by move 1) and substitute `hP`:
   $N(p_P)<P(p_P)=1$. This one line is the whole point of gap (1), and it is the only place the parity
   separation is used.
4. **$p_N<p_P$**: trichotomy on $(p_N,p_P)$. If $p_N=p_P$ then $N(p_P)=L\ge1$, contradicting
   $N(p_P)<1$. If $p_P<p_N$ then `BNeg_strictAnti` gives $N(p_N)<N(p_P)$, i.e. $L<1\le L$. Move 4
   needs **no** lower bound on $p_N$: the antitonicity is applied with $p_P>1$ as the left endpoint,
   which is why move 1 was about $p_P$ and not about $p_N$.
5. **$p_P<3/2<p_*$**: two independent applications of the same pattern — for $p_P$, trichotomy on
   $(p_P,3/2)$ with `BPos_3_2_lt_one`; for $p_*$, first `one_lt_of_zetaR_eq` gives $p_*>1$, then
   trichotomy on $(3/2,p_*)$ with `ZetaR_3_2_gt` ($2<\zeta(3/2)$).

Chaining: $p_N<p_P<3/2<p_*$. **Where the analysis went:** the proof uses analytic input in exactly two
places, both inside lemmas proved once and reused — strict antitonicity of the series and the integral
tail bound. The final assembly is real trichotomy; it never needs to know that $\zeta$ is *continuous*,
never invokes the intermediate value theorem, never locates a root numerically, and never evaluates
$\zeta$.

**The radial-pair threshold (PROVED, `ConeLean.pair_threshold_between`).**
```lean
theorem pair_threshold_between {pP pPair pstar : ℝ}
    (hP : BPos pP = 1) (hpair : Psi pPair = 0) (hstar : ZetaR pstar = 2) :
    pP < pPair ∧ pPair < pstar
```
unconditionally, with the bracket $7/5\le p_{\text{pair}}\le8/5$ **derived** (not assumed) from
`Psi_pos_of_lt_seven_fifths` and `Psi_neg_of_eight_fifths_le`, through the certified brackets
$\Psi(22/15)>0>\Psi(3/2)$, using the certified constant
$\log3\cdot3^{-8/5}+\log4\cdot4^{-8/5}-\log2\cdot2^{-7/5}>0$ (`pair_constant_pos`), the
one-power bound `ConeLean.shiftDiff_le` at $n=3,4$ against the loss at $n=2$, and the cross-checks
$3<\zeta(7/5)$, $\zeta(8/5)<2.29$, $3<P(22/15)<1$-style numerics (`ZetaR_22_15_gt`,
`ZetaR_22_15_lt`, `ZetaR_7_5_gt_three`, `tail_8_5`, `ZetaR_8_5_lt`, `BPos_22_15_lt_one`,
`two_rpow_neg_22_15_lt`, `two_rpow_neg_7_15_lt`, `two_rpow_neg_half_gt`,
`two_rpow_neg_three_fifths_gt`, `three_rpow_neg_eight_fifths_gt`,
`four_rpow_neg_eight_fifths_gt`, `two_rpow_neg_seven_fifths_lt`).

**The pair census (PROVED, `ConeLean/PairCensus.lean`).** `ConeLean.tsum_even_add_odd_real` — the
even/odd splitting identity for real series, which Mathlib lacks for $\mathbb{R}$ (the source
identifies it as the lemma the rh42 paper records as having eluded elaboration — the companion paper
records the corresponding attempt at `tsum_even_add_odd` as unfinished, §5) — gives
`ConeLean.tsum_pairAlphabet`: $\sum_k a_k = P(p)$. `ConeLean.pair_brown_zero_iff`: Brown's first
condition $a_0\le\sum_{k\ge1}a_k$ is equivalent to $0\le\Psi(p)$, i.e. to $p\le p_{\text{pair}}$.
`ConeLean.pair_brown_all_k` (with `tsum_rpow_inv_tail_ge`, `pairAlphabet_tail_ge`, `pair_key`): **every**
Brown condition holds for $1<p\le3/2$ at $k\ge1$, with slack $\ge3$. Then the census:
`SubSumIco` (finite sub-sum sets), the recursion
`SubSumIco_succ`: $S_{[m,n)} = S_{[m+1,n)}\cup(a_m+S_{[m+1,n)})$, `SubSumIco_gap`, `SubSumIco_glue`,
`SubSumIco_two_intervals`, **Brown completeness `ConeLean.SubSumIco_eq_Icc_of_brown`**, and the
pair-alphabet gap `pairAlphabet_subsum_gap`. The reachable set has gaps: at $p=2$ the subset-sum set is
two intervals, at $p=3$ four (source rows T11–T12; the source calls these the most tractable remaining
rows and they do not need zeta input beyond the budgets).

## 4. Verification and evidence

All paths are relative to this folder. `check.sh` defaults `LEAN_PREFIX` to `$HOME/lean`; a run
requires elan at `$LEAN_PREFIX/elan` and Mathlib4 at `$LEAN_PREFIX/mathlib4`.

### 4.1 The build (run here; observed output quoted)

```sh
./check.sh --all
```

Observed in this packaging session on this machine (Lean `v4.35.0-rc2`,
`lean-toolchain` = `leanprover/lean4:v4.35.0-rc2`):

```
[check] OK   TppLean/Core.lean (10s)
[check] OK   TppLean/Budget.lean (39s)
[check] OK   TppLean/ThreeThresholds.lean (130s)
[check] OK   TppLean.lean (40s)
[check] OK   ConeLean/ChowlaEquiv.lean (118s)
[check] OK   ConeLean/ShiftTwoCore.lean (97s)
[check] OK   ConeLean/Cone.lean (31s)
[check] OK   ConeLean/PairThreshold.lean (69s)
[check] OK   ConeLean/PairCensus.lean (40s)
[check] OK   ConeLean/ResidueReduction.lean (86s)
[check] OK   ConeLean/ShiftBarrier.lean (16s)
[check] OK   ConeLean/SpectralStructure.lean (10s)
[check] OK   ConeLean/LogAverageBarrier.lean (11s)
[check] OK   ConeLean/ParityObstruction.lean (4s)
[check] OK   ConeLean.lean (55s)
EXIT=0
```

**$15/15$ `[check] OK`, exit status $0$.** This agrees with the folder's recorded status
(`LEAN-README.md`: "complete", "no `sorry`"; `README.md`: "15 files, exits 0"). The run emits linter
warnings only — an unused-tactic note at `TppLean/ThreeThresholds.lean:143`, deprecated `if_pos`/
`if_neg`/`push_neg` names, an unnecessary-`simpa` note, unused-variable names — and two informational
"try `ring_nf`" messages during `ConeLean/ResidueReduction.lean` and `ConeLean/SpectralStructure.lean`.
None of these is an error; the sources are reproduced unmodified, and the folder's `README.md` therefore
does not claim a warning-free build (`notes/residue-verdict.md` §2 does claim "zero warnings" for "all
six modules" of an earlier state, which is a **claim of the source that my run does not confirm**: the
build succeeds, but warnings are printed). This is the one place where the folder's own wording and the
observed output differ, and it is recorded here rather than smoothed over.

### 4.2 Axiom footprints (queries run here; observed output quoted)

The queries (the folder's own guides prescribe these shapes):
```lean
import ConeLean
import TppLean
#print axioms ConeLean.chowlaSum_eq
#print axioms ConeLean.chowlaSum_tendsto_iff_patCount_tendsto
#print axioms ConeLean.chowlaSum_shift_two_split
#print axioms ConeLean.shift_two_of_shift_one_and_core
#print axioms ConeLean.chowlaAF_not_multiplicative
#print axioms ConeLean.core_not_multiplicative
#print axioms ConeLean.abelMean_tendsto_zero
#print axioms ConeLean.abelMean_tendsto_zero_of_logAverage
#print axioms ConeLean.shift_average_does_not_control_single
#print axioms ConeLean.dft_autocorr
#print axioms ConeLean.corr_eq_zero_of_dft_mul_star_dft_eq
#print axioms ConeLean.sum_inv_sq_le_zeta_two
#print axioms ConeLean.coneTransform_sub_dirichlet_le
#print axioms ConeLean.pair_threshold_between
#print axioms TppLean.tpp_rh42_three_thresholds
#print axioms TppLean.tpp_rh42_three_thresholds_level
#print axioms TppLean.ZetaR_eq_riemannZeta_re
#print axioms TppLean.BNeg_lt_BPos
```
run against the `.olean` files produced by the build above, with `LEAN_PATH` reconstructed the same way
`check.sh` does. Observed (verbatim, line-wrapped to fit; exit status $0$):

```
'ConeLean.chowlaSum_eq' depends on axioms: [propext, Classical.choice, Quot.sound]
'ConeLean.chowlaSum_tendsto_iff_patCount_tendsto' depends on axioms: [propext, Classical.choice, Quot.sound]
'ConeLean.chowlaSum_shift_two_split' depends on axioms: [propext, Classical.choice, Quot.sound,
 ConeLean.lam_two._native.native_decide.ax_1_1]
'ConeLean.shift_two_of_shift_one_and_core' depends on axioms: [propext, Classical.choice, Quot.sound,
 ConeLean.lam_two._native.native_decide.ax_1_1]
'ConeLean.chowlaAF_not_multiplicative' depends on axioms: [propext, Classical.choice, Quot.sound,
 ConeLean.chowlaAF_one._native.native_decide.ax_1_1]
'ConeLean.core_not_multiplicative' depends on axioms: [propext, Classical.choice, Quot.sound,
 ConeLean.core_not_multiplicative._native.native_decide.ax_1_1]
'ConeLean.abelMean_tendsto_zero' depends on axioms: [propext, Classical.choice, Quot.sound]
'ConeLean.abelMean_tendsto_zero_of_logAverage' depends on axioms: [propext, Classical.choice, Quot.sound]
'ConeLean.shift_average_does_not_control_single' depends on axioms: [propext, Classical.choice, Quot.sound]
'ConeLean.dft_autocorr' depends on axioms: [propext, Classical.choice, Quot.sound]
'ConeLean.corr_eq_zero_of_dft_mul_star_dft_eq' depends on axioms: [propext, Classical.choice, Quot.sound]
'ConeLean.sum_inv_sq_le_zeta_two' depends on axioms: [propext, Classical.choice, Quot.sound]
'ConeLean.coneTransform_sub_dirichlet_le' depends on axioms: [propext, Classical.choice, Quot.sound]
'ConeLean.pair_threshold_between' depends on axioms: [propext, Classical.choice, Quot.sound,
 ConeLean.ZetaR_22_15_gt._native.native_decide.ax_1_1, ConeLean.ZetaR_22_15_gt._native.native_decide.ax_1_2,
 ConeLean.ZetaR_22_15_lt._native.native_decide.ax_1_1, ConeLean.ZetaR_22_15_lt._native.native_decide.ax_1_2,
 ConeLean.ZetaR_7_5_gt_three._native.native_decide.ax_1_1, ConeLean.ZetaR_7_5_gt_three._native.native_decide.ax_1_2,
 ConeLean.four_rpow_neg_eight_fifths_gt._native.native_decide.ax_1_1,
 ConeLean.three_rpow_neg_eight_fifths_gt._native.native_decide.ax_1_1,
 ConeLean.two_rpow_neg_22_15_lt._native.native_decide.ax_1_1,
 ConeLean.two_rpow_neg_7_15_lt._native.native_decide.ax_1_1,
 ConeLean.two_rpow_neg_seven_fifths_lt._native.native_decide.ax_1_1,
 TppLean.ZetaR_3_2_gt._native.native_decide.ax_1_1, TppLean.ZetaR_3_2_lt._native.native_decide.ax_1_1]
'TppLean.tpp_rh42_three_thresholds' depends on axioms: [propext, Classical.choice, Quot.sound,
 TppLean.ZetaR_3_2_gt._native.native_decide.ax_1_1, TppLean.ZetaR_3_2_lt._native.native_decide.ax_1_1,
 TppLean.ZetaR_4_3_gt._native.native_decide.ax_1_1]
'TppLean.tpp_rh42_three_thresholds_level' depends on axioms: [propext, Classical.choice, Quot.sound,
 TppLean.ZetaR_3_2_gt._native.native_decide.ax_1_1, TppLean.ZetaR_3_2_lt._native.native_decide.ax_1_1,
 TppLean.ZetaR_4_3_gt._native.native_decide.ax_1_1]
'TppLean.ZetaR_eq_riemannZeta_re' depends on axioms: [propext, Classical.choice, Quot.sound]
'TppLean.BNeg_lt_BPos' depends on axioms: [propext, Classical.choice, Quot.sound]
```

**Reading, and a claim of the source that the observed output does not support.** No declaration
depends on `sorryAx`, and every footprint is the programme-standard base
`[propext, Classical.choice, Quot.sound]` plus, where `native_decide` is used, one or more
`._native.native_decide.ax_i_j` assumptions — the standard `Lean.ofReduceBool` assumption about the
Lean compiler, not a mathematical axiom. In particular the **T14 theorems themselves** carry exactly
three such assumptions, one for each of the three large integer sum evaluations named in Table 2
(`TppLean.ZetaR_4_3_gt`, `TppLean.ZetaR_3_2_gt`, `TppLean.ZetaR_3_2_lt`), and nothing else. The other
twelve queried declarations — including the whole cone/barrier group
(`abelMean_tendsto_zero`, `abelMean_tendsto_zero_of_logAverage`,
`shift_average_does_not_control_single`, `dft_autocorr`, `corr_eq_zero_of_dft_mul_star_dft_eq`,
`sum_inv_sq_le_zeta_two`, `coneTransform_sub_dirichlet_le`, `ZetaR_eq_riemannZeta_re`,
`BNeg_lt_BPos`, `chowlaSum_eq`, `chowlaSum_tendsto_iff_patCount_tendsto`) — have the base footprint
exactly. **`LEAN-README.md` states that "Both developments are axiom-clean", which in the usual sense
of "no assumptions beyond the kernel's three" the observed output does not support**: the footprints
above include the `native_decide` compiler assumptions, and `notes/residue-verdict.md` §9 is explicit
that `ConeLean/ChowlaEquiv.lean` in particular uses `native_decide`. The precise statement the output
supports is: **no `sorry`, no new mathematical axiom, and `native_decide` compiler assumptions wherever
`native_decide` is invoked.** The source's own trust accounting (the scaffold's §8.2) is more careful
than its one-line summary, and it is the careful statement that this manuscript uses. A reader who
wants the compiler assumption removed can replace the `native_decide` invocations by `decide`; the
source says nothing else in the development depends on them. **I did not attempt that replacement.**

### 4.3 What was not run, and why

* The scaffold at `.solveathome/work/html2md/012-cone-shift2-thresholds__three-thresholds-paper.md` is a
  **converted source document, not an executable**; its §8.1 output block (four `[check] OK` lines for
  the `TppLean` files alone, `2s`/`3s`/`10s`/`2s`, and the count "1091 lines across three modules") is
  quoted **as the scaffold states it** and could not be reproduced in this packaging session: the
  scaffold's snippet times and the "1091 lines" figure do not match either the observed timings above
  or a direct line count of the four `TppLean` files ($143+97+838+13 = 1091$ lines *is* the line count
  of `TppLean/Budget.lean`, `Core.lean`, `ThreeThresholds.lean`, `TppLean.lean` — but the
  `TppLean/ThreeThresholds.lean` timing observed here is $130$s, not $10$s). The scaffold's output block
  is therefore reproduced as provenance, not as an observed run.
* `notes/residue-verdict.md` §9 reports a numerical diagnostic `parity_diagnostic.py` (log
  `verify/parity_diagnostic.log`) with statistics at $N=2^{22}$ and a Wiener–Khinchin check on real
  data agreeing to a relative $3.5\times10^{-10}$. **Neither the script nor its log is present in this
  folder** — the folder has no Python at all (its `README.md` says so: "There are no Python scripts in
  this item") — so the (c3) numbers are quoted from the note as **HEURISTIC** and **could not be
  checked here**. The note itself labels them finite-range and not evidence for the conjecture.
* `notes/residue-verdict.md` §2 cites `verify/lean_check.log` for "all six modules re-verify green with
  zero warnings"; that log is **not** in this folder either, and my run prints warnings (§4.1).
* The `research/truths.md` §12 table links `ConeLean/ShiftTwoCore.lean#L63` and `#L155`, `#L120`;
  `ChowlaEquiv.lean#L77`; `ResidueReduction.lean#L443`; `ShiftBarrier.lean#L94`;
  `TppLean/ThreeThresholds.lean#L734`. **All resolve to the declarations named in this manuscript**,
  with one drift this manuscript notes explicitly: `ShiftTwoCore.lean` now carries the **erratum** at
  its head, so the row "core not multiplicative … `ShiftTwoCore.lean#L120`" points at
  `core_not_multiplicative`, and the row "shift-2 split (finite) … #L63" at
  `chowlaSum_shift_two_split`.

## 5. What is not claimed

* **`S(x)=o(x)` and the twin prime conjecture remain OPEN.** The source's verdict on the cone residue is
  that the residue vanishes (conditionally on Tao's log-averaged theorem) but does **not** imply
  $o(x)$; the equivalence of $o(x)$ with the four-density-$1/4$ statement is a reduction, not a proof.
  The source states plainly: "It does not prove `o(x)`, it does not claim that `o(x)` is false, and it
  does not identify a route that is known to work."
* **The three-thresholds theorem is an internal programme result** and is explicitly **not** a
  twin-prime or parity theorem. The barriers recorded here are obstructions, not positive results.
* **The numerical values of the thresholds are not formalised.** The file proves the *ordering*; it does
  not prove $p_P=1.4649845878051603837$. Locating the roots to $19$ digits is the source's $80$-dps
  computation, and formalising it would need a verified root-finder (a rational interval arithmetic
  layer plus a contraction argument). The values in Table 1 are quoted for orientation only.
* **The budget identities are not formalised.** The source's $P+N=\zeta-1$ and $P-N=1-\eta$
  (rows T2–T3) do not appear as theorems. The separation they would be used for is proved directly by
  gap (1), so nothing depends on them — but the file does **not** establish the even/odd rearrangement
  of $\zeta$, only the inequality it implies. The obstruction recorded in the source was the
  even/odd rearrangement $\sum'_k f(2k)+\sum'_k f(2k+1)=\sum'_k f(k)$ via `tsum_even_add_odd`, which is
  available in Mathlib and eluded the elaboration attempts made in the session. (The related
  *real* form is now proved in `ConeLean/PairCensus.lean` as `tsum_even_add_odd_real`, for real series,
  in the course of the pair census.)
* **The abstract core is not on the critical path.** `TppLean.threshold_ordering` is proved and
  available, but the concrete theorem does not call it: the concrete assembly uses trichotomy directly.
  This is a redundancy, not a gap.
* **Level $L<1$ is not covered.** Theorem 7.2 covers $L\ge1$; the case $L<1$ requires a different anchor,
  since $N(p_P)<1$ is no longer enough. The natural anchor would be a bracket for $N$ itself, which is
  not in the file.
* **Continuity of `ZetaR` on $(1,\infty)$ is not proved**, so the abstract core cannot be instantiated
  and **existence** of the thresholds is not formalised — only their *relative order*, which is what
  T14 asserts.
* **The one trust assumption, stated precisely, and a claim the observed output does not support.**
  `native_decide` is used, and its compiler assumption appears in the footprints (§4.2), including in
  the T14 theorems themselves (three assumptions, one per large sum evaluation) and in
  `pair_threshold_between` (thirteen). `norm_num` and `decide` carry no assumption beyond the kernel;
  `decide` handles the seven power comparisons of Table 3 and the initial-interval bound
  $10^9+1\le2^{64}$; `norm_num` handles all rational arithmetic, including the tail evaluations $0.02$
  and $0.025$. Replacing the `native_decide` invocations by `decide` was **not attempted here**. The
  folder's `README.md` states "Both developments are axiom-clean and contain no `sorry`"; the observed
  footprints show no `sorryAx` and no mathematical axiom beyond the three, but they **do** include the
  `native_decide` compiler assumptions, so the summary is only correct under the reading "axiom-clean =
  no new mathematical axiom". `notes/residue-verdict.md` §9 is explicit that
  `ConeLean/ChowlaEquiv.lean` uses `native_decide`, and the scaffold's own trust ledger (§8.2) states
  the position carefully; this manuscript uses the careful statement, and records the discrepancy.
* **Two of the scaffold's own claims cannot be confirmed from the folder, and one folder claim is not
  confirmed by my run.** (i) The scaffold's §8.1 build/output block shows four `[check] OK` lines with
  times `2s/3s/10s/2s` for the `TppLean` files; the observed run gives `10s/39s/130s/40s` for those four
  (T14's assembly module alone takes $130$s here). The scaffold's output block is reproduced as
  provenance, not as an observed run. (ii) The scaffold describes the T14 development as "1091 lines
  across three modules plus the root file"; the four `TppLean` files do total $1091$ lines
  ($143+97+838+13$), so the figure is right and the phrase "three modules plus the root file" is the
  imprecision. (iii) The scaffold's §13.1 states that the even/odd rearrangement "eluded the
  elaboration attempts made in this session", while a **real-series** version of it now exists in
  `ConeLean/PairCensus.lean` as `tsum_even_add_odd_real` (the scaffold predates the pair census); both
  statements are kept, as the scaffold is a snapshot and the Lean file is the artefact. (iv) The
  scaffold's §8.2 trust ledger is consistent with the observed footprints and is the version followed
  above.
* **The (c1)–(c3) items in the residue ledger have mixed status and are labelled as such.** The route
  ledger (R1–R7) marks: R1 (Selberg parity / bounded-depth sieve) **CLOSED**; R2 (positivity/majorant)
  **CLOSED** (ARGUMENT + numbers); R3 (Euler product / $\zeta$-machinery) **CLOSED, machine-checked**;
  R4 (bilinear/spectral Type II) **OPEN**; R5 (entropy decrement / log-average) **THEOREM (external)**
  whose limit is machine-checked; R6 (harmonic analysis of the shift family) **THEOREM on average**
  (external, almost all shifts), **OPEN** for the prescribed shift $h=2$; R7 (almost-all-scales)
  **THEOREM** (external), **OPEN** at a prescribed scale. The (c2) table separating "provably absent"
  from "merely unknown" structure is an ARGUMENT, not a theorem: three of five candidates (Euler
  product, Dirichlet convolution of multiplicative functions, and — as evidence, not proof — automorphy)
  are contradicted by machine-checked facts; spectral positivity and a non-multiplicative Type-II
  summand are **OPEN**. The source states that this classifies *hypotheses of known methods*, not the
  truth of the conjecture.
* **The (c3) diagnostic is HEURISTIC and finite-range**, and its script and log are absent from this
  folder (§4.3). No finite computation can decide $o(x)$.
* **An external counterexample and an unverified citation.** The failure of the converse
  ($\mathrm{residue}=0\not\Rightarrow o(x)$, via $f(n)=\cos(\theta\log n)$) is EXTERNAL/classical and
  deliberately not machine-checked; the source cites Hardy, *Divergent Series* (1949) and the
  Hardy–Littlewood Tauberian papers but records that **the specific page was not verified**.
* **Provenance.** These proof files live at the workspace root `lean/`, outside `research/`. They are
  reproduced here unmodified except for the one re-pointed docstring in `ConeLean/ChowlaEquiv.lean`
  (verified by `diff`: the single changed line is the `residue-verdict.md` link). `check.sh` and
  `README.md` also differ from the workspace copies, as the folder's provenance note describes. The
  workspace originals remain canonical, and this edition makes no priority claim.
* **Nothing here bears on the Riemann Hypothesis.** The source notes that Mathlib's
  `riemannZeta : ℂ → ℂ` has neither monotonicity nor numeric bounds, which is why the real Dirichlet
  series `ZetaR` is used throughout; `riemannZeta` appears only through the proved bridge
  `ZetaR_eq_riemannZeta_re` and its companions.

## 6. Value and significance

**For the ledger (T14).** The rh42 round keeps a ledger with an explicit entry rule: VERIFIED requires
recomputation by an independent route, PROVED a written argument. T14 was VERIFIED only, with the caveat
that root-finding at $80$ digits is evidence about a computation, not a proof about a limit. The
development moves the row to PROVED and machine-checked, and does so **without re-running the numerics**:
the proof is of the same order as the claim. Concretely, for
$\zeta(p)=\sum_{n\ge1}n^{-p}$, $P(p)=2^{-p}\zeta(p)$ and $N(p)=\sum_{k\ge0}(2k+3)^{-p}$, if
$P(p_P)=1$, $N(p_N)=L$ with $L\ge1$, and $\zeta(p_*)=2$, then $p_N<p_P<p_*$.

**For the budgets method.** The budgets $P$ and $N$ are the reachable ranges of a signed greedy rule;
the thresholds are where those ranges cease to cover the targets. The ordering $p_N<p_P$ is the
quantitative form of the statement that the negative side becomes unable to express $-1$ strictly
*earlier* than the positive side becomes unable to express $+1$ — the "half-turn deficit" of the
alternating series. Making that asymmetry a theorem, rather than an estimate, is what lets the
downstream reachable-set analysis cite it: rows T10–T13 (the completeness criteria, the negative
threshold $q=2.07677517921069$, and the reachable-set descriptions at $p=2,3$) and the budget-interval
claim at $p_*$ (row T15: the interval has length exactly $\zeta(p_*)-1=1$ but is split unevenly, so the
endpoints $\pm1$ are still not reachable). T14 is precisely what makes that non-vacuous: the two
endpoint thresholds lie strictly inside $(1,p_*)$, so the failure at $p_*$ is a genuine failure of
*placement*, not of length. The radial-pair companion `pair_threshold_between` adds
$p_P<p_{\text{pair}}<p_*$ for the Brown-condition threshold, and `pair_brown_all_k` gives every Brown
condition for $1<p\le3/2$ with slack $\ge3$, so the census (two intervals at $p=2$, four at $p=3$)
rests on proved budget facts.

**The proof strategy is transferable.** The shape is: **to order the solutions of several monotone
equations, you do not need to solve them, and you do not need continuity. You need strict monotonicity
of each function, one evaluated point per equation to anchor the comparison, and one inequality
separating the functions from each other.** Here the separating inequality is the parity comparison
$N<P$, and it does the entire job of placing $p_N$ before $p_P$. The two reusable artefacts are
`ZetaR_strictAnti` — a strict-antitonicity result obtained from one strictly positive term of a
difference series, a pattern that transfers to any real Dirichlet series with nonnegative coefficients —
and the floor-oracle-plus-bridge architecture: exact integer partial sums from a verified binary-search
oracle, an asymmetric two-sided bridge whose error is at most $N/10^9$, and an analytic tail from
Mathlib's integral test. The source calls this the general recipe for turning a series definition into a
rigorous enclosure; it applies to any Dirichlet series with nonnegative coefficients, to polylogarithms
on the real axis, and to $\eta,\beta,\lambda$ and friends, and it is what makes the development
**value-free** — no evaluation of $\zeta$, no interval–Newton solver, no intermediate value theorem.

**For formalisation practice.** Mathlib has no monotonicity and no numeric bounds for `riemannZeta`.
This development shows that both can be supplied cheaply for the real Dirichlet series, that the two
functions are provably the same object on the real axis above $1$ (`ZetaR_eq_riemannZeta_re`), that
$P$ is *not* that object (`BPos_ne_riemannZeta_re`, the deliberate no-go lemma), and that the
combination is enough for a concrete ordering result. The oracle `fpow` and `ZetaR_strictAnti` itself
are natural candidates for reuse. The source notes that the usual approach — bounding
$k^{\mathtt{num}/\mathtt{den}}$ by pointwise integer surrogates — provably loses too much here: the
available surrogates for $\zeta(3/2)<2.64$ sum to roughly $1.0$–$1.2$ against a true value of $2.59$,
whereas the exact floors sum to $2.5924$.

**For the negative results around the wall.** The barriers are the machine-checked half of the
programme's negative results, and they are what gives the ledger its shape: the parity obstruction
upgrades route R3 from "closed by citation" to "closed, with the algebra machine-checked" (the
correlation has no Euler product and is not a multiplicative convolution, so the classical Type-II shape
is unavailable for it); the Abel/log-averaging reduction says exactly how far entropy decrement reaches
— precisely to the Abelian mean, no further — with the $1/\varepsilon^2$ growth of
$\sum\log(n+1)n^{-1-\varepsilon}$, tamed to the constant $8$, as the quantitative trace of the
averaging; the shift-average and scale-average barriers say that every known un-averaged statement about
the correlation is *almost-everywhere* in a parameter (shift or scale) while the target is the single
point $(h,x)=(2,x)$; the finite Wiener–Khinchin identity says the Fourier transform of the correlation
sequence *is* the power spectrum, so vanishing correlations and a flat spectrum are equivalent — the
exact step at which "no periodic/pretentious component" would have to enter; and the log-average
barrier says that a set of zero harmonic density is invisible to a $1/n$-weighted average however many
elements it has. Together they close four routes, localise the one that remains open, and record — with
labels — exactly where the machine-checked work stops.

## Sources

Local sources are **local-only**. Line locators are as of this packaging.

| Source | What it supplied | Locator |
|---|---|---|
| `README.md`, this folder | the item's identity; the two result tables; the **provenance note** (the files live at the workspace root `lean/`, are copied here for packaging, workspace originals untouched); the `--all` dependency order; "no Python scripts in this item" | §"What the item is", §"Contents", §"Running the checks", §"Provenance" |
| `TRUTHS.md`, this folder | the §12 ledger, all ten rows with Lean names, and the statement that the three-thresholds theorem is **not** a twin-prime/parity result | whole file (19 lines) |
| `LEAN-README.md`, this folder | the T14 theorem statement; the five-move ordering argument; the certified-bracket method and the role of `native_decide`/`norm_num`/`decide`; the module layout; the toolchain; the level-normalisation note ($L=1$: $1.3777851698375411838$; $L=2$: $1.2136006221625785622$); the remark on `riemannZeta` | whole file (67 lines) |
| `TppLean/Core.lean` | `IsThreshold` (L24), `CrossesOnce` (L31), `CrossesOnce.exists_unique` (L38), `BudgetHyp` (L67), `threshold_ordering` (L79) | quoted |
| `TppLean/Budget.lean` | `ZetaR` (L33), `BPos` (L36), `BNeg` (L39), `summable_zetaR` (L41), `summable_shift` (L44), `zetaR_shift` (L53), `summable_BNeg` (L57), `ZetaR_strictAnti` (L77), `ZetaR_eq_riemannZeta_re` (L123), `BPos_eq_riemannZeta_re` (L139) | quoted |
| `TppLean/ThreeThresholds.lean` | the power comparisons (L37–L94), `tail_finite` (L110), `SCn` (L163), `go` (L166), `go_spec` (L176), `fpow` (L212), `go_init` (L216), `go_fuel` (L227), `fpow_valid` (L232), `fpow_max` (L240), `rpow_div_pow` (L248), `fpow_le` (L256), `fpow_le_SCn` (L269), `le_fpow` (L281), `sumF` (L297), `sumF_le_zetaR_partial` (L300), `zetaR_partial_le` (L315), `summable_shift_neg` (L342), `zetaR_eq_shift_neg` (L353), `tsum_tail_le` (L361), `ZetaR_split` (L372), `ZetaR_lower` (L381), `ZetaR_upper` (L400), `ZetaR_7_5_lt` (L465), `ZetaR_4_3_gt` (L488), `ZetaR_3_2_gt` (L498), `ZetaR_3_2_lt` (L508), `Nside` (L533), `ZetaR_pos` (L540), `BPos_ne_riemannZeta_re` (L560), `BPos_4_3_gt_one` (L593), `BPos_3_2_lt_one` (L604), `BPos_strictAnti` (L640), `BPos_eq_even` (L653), `summable_even` (L663), `odd_lt_even` (L675), `BNeg_lt_BPos` (L685), `BNeg_strictAnti` (L691), `one_lt_of_zetaR_eq` (L709), `one_lt_of_BPos_eq` (L721), `tpp_rh42_three_thresholds` (L734), `tpp_rh42_three_thresholds_level` (L790) | quoted |
| `TppLean.lean` | the umbrella imports | whole file |
| `ConeLean/Cone.lean` | `coneRadius` (L41), `coneIndex` (L44), `coneIndex_coneRadius` (L48), `coneRadius_injective` (L66), `pairWeight` (L96), `critWeight` (L99), `inv_add_two_le_critWeight` (L108), `critWeight_le_inv` (L121), `critWeight_error_le` (L138), `summable_two_div_mul_add_two` (L149), `summable_critWeight_error` (L167), `summable_critWeight_sub_inv_mul` (L181), `pairSeparation_eq` (L198), `shiftDiff_nonneg` (L210), `shiftDiff_le` (L219), `summable_shiftDiff` (L255) | quoted |
| `ConeLean/ChowlaEquiv.lean` | `lam` (L25), `window` (L44), `chowlaSum` (L59), `eqCount` (L63), `patCount` (L66), `chowlaSum_eq` (L77), `patCount_mul_four` (L99), `chowlaSum_tendsto_iff_patCount_tendsto` (L149), `chowla_not_multiplicative` (L201), `lam_not_multiplicative` (L207) | quoted |
| `ConeLean/ShiftTwoCore.lean` | the **ERRATUM** (L4–L34), `lam_mul` (L44), `lam_two` (L49), `lam_even_shift_two` (L55), `chowlaSum_shift_two_split` (L63), `prime_dvd_shift_two` (L82), `core_diff_squares` (L91), `core_coprime` (L96), `core_not_multiplicative` (L120), `core_not_multiplicative_lam` (L127), `oddLam` (L140), `oddLam_not_multiplicative` (L146), `shift_two_of_shift_one_and_core` (L155) | quoted |
| `ConeLean/ParityObstruction.lean` | `chowlaAF` (L29), `chowlaAF_one` (L33), `chowlaAF_not_multiplicative` (L37), `chowlaAF_not_conv` (L46) | quoted |
| `ConeLean/ResidueReduction.lean` | `partSum` (L38), `sum_mul_eq` (L51), `abelWeight` (L47), `abelWeight_sub_le` (L61), `summable_abelWeight` (L103), `summable_mul_abelWeight` (L113), `abelMean` (L122), `sum_abelWeight_gap_le` (L231), `abel_partial_bound` (L276), `abel_tsum_bound` (L424), `abelMean_tendsto_zero` (L443), `logPartSum` (L517), `rpow_neg_gap_le` (L520), `log_abel` (L555), `log_abelWeight_le` (L581), `sq_mul_log_tail_le` (L623), `log_abel_partial_le` (L675), `tendsto_log_mul_rpow_neg` (L704), `abel_tsum_le_of_logAverage` (L738), `abelMean_tendsto_zero_of_logAverage` (L929), `pairWeight_zero` (L985), `rpow_neg_gap_two` (L993), `pairWeight_sub_le` (L1026), `coneTransform_sub_dirichlet_le` (L1103) | quoted |
| `ConeLean/ShiftBarrier.lean` | `spike` (L27), `corr` (L30), `corr_spike_eq_zero` (L38), `corr_spike_one` (L43), `corr_spike_zero` (L59), `sum_abs_corr_spike_le` (L74), `shift_average_does_not_control_single` (L94), `block` (L102), `sum_block_eq` (L111), `scale_average_does_not_control_prescribed` (L128) | quoted |
| `ConeLean/SpectralStructure.lean` | `star_stdAddChar` (L24), `autocorr` (L32), `addSwap` (L36), `dft_autocorr` (L48), `dft_mul_star_dft_eq_of_corr_eq_zero` (L82), `corr_eq_zero_of_dft_mul_star_dft_eq` (L94) | quoted |
| `ConeLean/LogAverageBarrier.lean` | `sum_inv_sq_le_zeta_two` (L30), `tendsto_sum_inv_sq_div_log` (L38), `zero_log_density_meets_every_dyadic_block` (L64) | quoted |
| `ConeLean/PairThreshold.lean` | `Psi` (L41), `Psi_sub` (L49), `rpow_sub_lower` (L99), `two_rpow_sub_upper` (L140), `pair_constant_pos` (L238), `Psi_strictAnti` (L260), `ZetaR_22_15_gt`/`lt` (L350/L358), `ZetaR_7_5_gt_three` (L367), `ZetaR_8_5_lt` (L383), `Psi_22_15_gt` (L451), `Psi_3_2_lt` (L459), `BPos_22_15_lt_one` (L467), `Psi_pos_of_lt_seven_fifths` (L483), `Psi_neg_of_eight_fifths_le` (L504), `pair_threshold_between` (L539) | quoted |
| `ConeLean/PairCensus.lean` | `pairAlphabet` (L42), `pairAlphabet_antitone` (L56), `tsum_even_add_odd_real` (L73), `tsum_pairAlphabet` (L121), `pair_brown_zero_iff` (L135), `tsum_rpow_inv_tail_ge` (L176), `pairAlphabet_tail_ge` (L249), `pair_key` (L288), `pair_brown_all_k` (L355), `SubSumIco` (L391), `SubSumIco_succ` (L413), `SubSumIco_gap` (L446), `SubSumIco_glue` (L459), `SubSumIco_two_intervals` (L479), `SubSumIco_eq_Icc_of_brown` (L497), `pairAlphabet_subsum_gap` (L530) | quoted |
| `ConeLean.lean` | the umbrella imports and the module map | whole file |
| `check.sh`, this folder | the build command and the 15-file `--all` list in dependency order | L38–L40 |
| `notes/residue-verdict.md` | the labelled ledger: the cone residue, (1a)–(1d), the route table R1–R7, the (c1)–(c3) table, §9's diagnostic numbers, §4's external counterexample and its citation caveat | whole file (280 lines) |
| `three-thresholds-paper.html`, this folder (and its converted scaffold) | the source paper for T14: Table 1's values and meanings, the normalisation note, the proof narrative, Table 2's certificates, Table 3's power comparisons, the trust ledger, the novelty and significance sections, Appendix A's lemma index, Appendix B's certificate table, the provenance line | §1, §4–§14, Appendices A–B |

SHA-256 of every file whose words are quoted above, computed on the files as packaged in this folder
(`shasum -a 256`):

| File | SHA-256 |
|---|---|
| `README.md` | `da4071c9e7cf39438cc3bf15d0389757152edf96588ec75a5affc83fdcaed9c8` |
| `TRUTHS.md` | `336d3705e5f72516f7d514aa53fe297024ef8bfd2da77baea31ddb8b611e9a7c` |
| `LEAN-README.md` | `c02d69c416248808c1686c3edbba58571020fe521b3ae3a9fe7dee2f514eb0ad` |
| `TppLean/Core.lean` | `dc029172caff23821d530253917293638e143893a0c3380e1146fe2c55f71773` |
| `TppLean/Budget.lean` | `07df2f330053e294e826a9845cede3424aaf33555277423f644c7827fa04fe11` |
| `TppLean/ThreeThresholds.lean` | `32f5fd8c3f1e83b1d0e3bf2e3fad9bbeea90901656d877fc1106e2bb8912d0b5` |
| `TppLean.lean` | `d383a6388c9e4cf0b8d0f53bace86743757e727589f2ca08586680761a9d64d3` |
| `ConeLean/Cone.lean` | `7e1f7c36274b9a9199cebe8f0d81aec801efa173685b828d72b4092104d58ba8` |
| `ConeLean/ChowlaEquiv.lean` | `459edc078946843d68aa1b4dd93c515becf2f8119bede4a448a6765d97a4cdd9` |
| `ConeLean/ShiftTwoCore.lean` | `68245e95b4de7beeb3b2e63e8de2685fe6df03fe4ae8ab8bc639227f06d4ef89` |
| `ConeLean/ParityObstruction.lean` | `4230d5f77a5e654d305af48cc4850c616c411852c726d8db22cc9a2863ff433a` |
| `ConeLean/ResidueReduction.lean` | `57270fc053c250cdd1a14c4f185e7b2e0bcc290e1e9240674f2e20ba822cb3b9` |
| `ConeLean/ShiftBarrier.lean` | `7fae731e612e34aa2ca1bab1954af5e2bbb1160c229437b37e8bf58d6a283d51` |
| `ConeLean/SpectralStructure.lean` | `541d0540f9f86a426ccb2f07555817fac1fefcb2f7eafffedfdcf457f66dfa17` |
| `ConeLean/LogAverageBarrier.lean` | `9c1db610ef6124e2e194f6f6833daa39347d9143a83146584d7c1f1bf2c6016b` |
| `ConeLean/PairThreshold.lean` | `e93780d8013dc1a0e139c4836a68170fd38016e9335c7cb4fe451dfaf5c08ce5` |
| `ConeLean/PairCensus.lean` | `2cd63b20396ca9cc98afa4ff8e785abc9e52b915d11184b32c4a8082faf235ba` |
| `ConeLean.lean` | `813408e392424e0cd23350cd8c45422f95bc52da506f1e11508200cdf17da399` |
| `check.sh` | `4ae7f6ea9ceccd4151268250cbcebe45ad34d86270b72e559bdba25a9b191804` |
| `notes/residue-verdict.md` | `756a19459c904a225e29292fa12572d8769d83a919a729d78b4a1d23e2e6c3af` |
| `three-thresholds-paper.html` | `0c93e6a45454066941dfe26604213d03c40378abf5abbf8aa25aa9276b29e2b6` |

These are hashes of the **packaged** copies. The workspace originals at the root `lean/` differ
(`ConeLean/ChowlaEquiv.lean` in one docstring line, `check.sh` and `README.md` more substantially, as
the provenance note and the `diff` recorded in §5 describe), so their hashes are not the ones above.

The build transcript in §4.1 and the axiom output in §4.2 are transcripts of this session's runs, not
file hashes.

**External citations (from the sources; not read here).** Matomäki–Radziwiłł–Tao, *An averaged form of
Chowla's conjecture*, Algebra & Number Theory **9** (2015) 2167–2196, arXiv:1503.05121 (quoted
verbatim in the source's erratum); Tao (2015), logarithmically averaged Chowla; Tao–Teräväinen, ANT
**13** (2019) 2103–2150, arXiv:1809.02518 (un-averaged Chowla outside a set of zero logarithmic
density); G. H. Hardy, *Divergent Series* (Oxford, 1949), and the Hardy–Littlewood Tauberian papers
(**page not verified in the source's session**); Brown's criterion (complete sequences). The source
documents `theorems/tpp-rh42-handoff-three-thresholds.md` (ledger row T14) and
`research/twin-prime-parity/rounds/rh42/HANDOFF.md` §5.1–5.4, §6, Appendix A are **not** in this folder;
they are the upstream sources of the claim proved here, and they are cited by the scaffold's provenance
line rather than reproduced.
