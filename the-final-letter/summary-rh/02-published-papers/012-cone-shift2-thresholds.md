# 012 — Cone, Shift-2 Core and the Three Thresholds

| Field | Value |
|---|---|
| Source | [`research/publish/012-cone-shift2-thresholds/manuscript.md`](../../rh/research/publish/012-cone-shift2-thresholds/manuscript.md) |
| Status | Published; truths ledger §12. |
| Harvested statements | 3 |

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

## Harvested theorem-like statements

### Theorem 3.1 (`TppLean.CrossesOnce.exists_unique`).

If `CrossesOnce B q L` then there is exactly one
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

### Theorem 7.1 — `TppLean.tpp_rh42_three_thresholds` (PROVED).

```lean
theorem tpp_rh42_three_thresholds (pP pN pstar : ℝ)
    (hP : BPos pP = 1) (hN : BNeg pN = 2) (hstar : ZetaR pstar = 2) :
    pN < pP ∧ pP < pstar
```

### Theorem 7.2 — `TppLean.tpp_rh42_three_thresholds_level` (PROVED).

The same conclusion with the
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

## Source

[`manuscript.md`](../../rh/research/publish/012-cone-shift2-thresholds/manuscript.md) · [`README.md`](../../rh/research/publish/012-cone-shift2-thresholds/README.md)
