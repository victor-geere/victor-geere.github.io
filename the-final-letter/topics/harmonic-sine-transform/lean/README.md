# Lean formal core — Harmonic Sine Transform

## Build

```bash
cd the-final-letter/topics/harmonic-sine-transform
./lean/check.sh
```

`check.sh` wraps [`../../tools/check-lean.sh`](../../tools/check-lean.sh), which elaborates `Topic.lean` against the shared local Mathlib installation (`~/lean/mathlib4`, Lean `v4.35.0-rc2`). The committed [`BUILD.log`](BUILD.log) records the last successful check.

## What is proved

[`Topic.lean`](Topic.lean) imports Mathlib, uses namespace `HST`, and defines:

- `HST.alpha n = π / (n + 2)` — the harmonic angle;
- `HST.accum n θ` — the accumulated selected angle \(A_n(\theta)\);
- `HST.digit n θ` — the greedy digit \(\delta_n(\theta)\);
- `HST.haarL a b L`, `HST.haarR a b L` — the left/right coefficients of the repaired zero-mean Haar wavelet on a node with child lengths \(a,b\) and total length \(L=a+b\);
- `HST.sourceHaarL`, `HST.sourceHaarR` and `HST.actualSourceHaarL`, `HST.actualSourceHaarR` — the source's displayed coefficients under its prose convention and on the actual tree;
- `HST.floorDigit`, `HST.floorRem` — the research guide's alternative floor recursion over \(\mathbb{Q}\);
- `HST.Cyl`, `HST.partition` — the exact rational cylinder partition used by F1.

It proves one hundred and twenty-three ledger theorems (one hundred and ninety-five Lean declarations in all), each with a complete proof:

| Name | Statement |
|---|---|
| `alpha_pos` | \(0<\alpha_n\) |
| `alpha_strictAnti` | \(n\mapsto\alpha_n\) is strictly decreasing |
| `accum_le_self` | for \(\theta\ge0\), the accumulated angle never exceeds \(\theta\) |
| `accum_eq_zero_of_lt` | if \(\theta<\alpha_n\) then \(A_n(\theta)=0\) |
| `threshold_isLeast` | \(\alpha_n\) is the least \(\theta\) with \(\delta_n(\theta)=1\) |
| `haar_normSq` | the repaired wavelet has squared norm \(1\) |
| `haar_mean_zero` | the repaired wavelet has zero mean |
| `residual_nonneg` | \(r_n(\theta)\ge0\) for \(\theta\ge0\) |
| `residual_le_pi_div` | \(r_n(\theta)\le\pi/(n+1)\) for \(0\le\theta\le\pi\) |
| `tendsto_residual` | \(r_n(\theta)\to0\) |
| `tendsto_accum` | \(A_n(\theta)\to\theta\) |
| `accum_eq_sum_range` | \(A_n(\theta)=\sum_{k<n}\delta_k(\theta)\alpha_k\) |
| `hasSum_digit_mul_alpha` | \(\theta=\sum_n\delta_n(\theta)\alpha_n\) for \(\theta\in[0,\pi]\) |
| `hasSum_digit_div_pi` | \(\theta/\pi=\sum_n\delta_n(\theta)/(n+2)\) |
| `digits_eq_imp_eq` | equal digits force equal angles |
| `cylinder_diameter` | equal first \(n\) digits give \(|\theta-\phi|\le\pi/(n+1)\) |
| `abs_sin_sub_sin_accum_le` | \(|\sin\theta-\sin A_n(\theta)|\le\pi/(n+1)\) |
| `source_haar_normSq` | the source wavelet has squared norm \(2\) under its prose convention |
| `source_haar_mean` | its mean is \(\sqrt b-\sqrt a\) |
| `actual_source_normSq` | on the actual tree its squared norm is \(a/b+b/a\) |
| `actual_source_normSq_ge_two` | on the actual tree its squared norm is at least \(2\) |
| `actual_source_mean` | its actual-tree mean is \(-a/\sqrt b+b/\sqrt a\) |
| `source_threshold_three_wrong` | \(\delta_3(5\pi/12)=0\) |
| `digit_not_monotone_explicit` | \(\delta_1(2\pi/5)=1\) and \(\delta_1(11\pi/20)=0\) |
| `floor_factorial_identity` | the floor recursion expands with factorial denominators |
| `floor_digit_not_binary` | its second digit at \(t=9/10\) is \(2\) |
| `floor_harmonic_partial_gt_target` | the harmonic partial at \(t=9/10\) is \(121/60>9/10\) |
| `floor_factorial_partial_eq_target` | the factorial partial at \(t=9/10\) is \(9/10\) |
| `partition_tiles` | the depth-\(n\) partition tiles \([0,1)\) |
| `partition_mesh` | every depth-\(n\) cylinder has length \(\le 1/(n+1)\) |
| `splitAt_left_length` | the left child has length exactly \(1/(n+2)\) |
| `splitAt_right_length` | the right child has length \(\ell-1/(n+2)\) |
| `partition_cover` | every \(x\in[0,1)\) lies in a depth-\(n\) cylinder |
| `partition_unique` | the containing depth-\(n\) cylinder is unique |
| `partitionR_tiles` | the real partition tiles \([0,1)\) |
| `partitionR_cover` | real coverage of \([0,1)\) |
| `partitionR_unique` | real uniqueness of the containing cylinder |
| `partitionR_mesh` | the real mesh is at most \(1/(n+1)\) |
| `exists_partition_oscillation_lt` | uniform oscillation bound on cylinders |
| `exists_cylinder_step_approx` | uniform approximation by cylinder steps |
| `cylinder_step_dense` | cylinder step functions are uniformly dense in \(C[0,1]\) |
| `partition_length_succ` | refining adds one cylinder per split |
| `partition_length` | depth-\(n\) has \(1+\) the total number of splits |
| `cylInd_parent_eq_add` | a parent indicator is the sum of its child indicators |
| `cylInd_left_eq_smul`, `cylInd_right_eq_smul` | local Haar linear combinations |
| `cylInd_left_mem_span`, `cylInd_right_mem_span` | child indicators lie in the parent-plus-Haar span |
| `cylInd_mem_haarSpan` | every cylinder indicator lies in the constant-plus-Haar span |
| `indicatorSpan_le_haarSpan` | the cylinder-indicator span is contained in the Haar span |
| `haarSpan_dense` | the constant-plus-Haar span is uniformly dense in \(C[0,1]\) |
| `haarSpan_eLpNorm_approx` | continuous functions are approximated in \(L^2\) by the Haar span |
| `cylSum_memLp` | the cylinder-step sum is an \(L^2\) function |
| `memLp_of_continuousOn` | continuous functions on \([0,1]\) are in \(L^2\) |
| `cylSum_eLpNorm_approx` | the cylinder-step `eLpNorm` approximation |
| `edist_toLp_cylSum_approx` | the corresponding `Lp`-distance bound |
| `exists_cylSum_edist_lt` | every \(L^2\) class is near a continuous cylinder-step sum |
| `haarSpan_dense_Lp` | the constant-plus-Haar span is dense in \(L^2\) |
| `haar_complete` | Haar completeness in density form |
| `span_haarFun_eq_span_haarDiff` | the normalised wavelet spans the same line as `haarDiff` |
| `span_haarDiffAtNorm_eq` | the global normalised and `haarDiff` generator spans agree |
| `haarSpanNorm_eq` | the normalised and `haarDiff` spans agree at every depth |
| `haar_complete_norm` | normalised Haar completeness in density form |
| `haarFun_coeff_normSq` | the normalised wavelet has unit coefficient norm |
| `haarFun_coeff_mean` | the normalised wavelet has zero coefficient mass |
| `haarFun_apply_of_not_mem` | the normalised wavelet is supported on its two children |
| `digit_one_gap` | selected indices satisfy \((n+1)(n+2)\le m+2\) |
| `integral_cylInd` | the integral of a cylinder indicator is its length |
| `integral_haarDiff_eq_zero` | the Haar difference has zero integral |
| `integral_haarFun_eq_zero` | the normalised wavelet has zero integral |
| `digit_one_not_succ` | no two consecutive selections after index 1 |
| `digit_one_doubling` | later selected indices at least double after index 1 |
| `haarFun_sq_eq` | pointwise square identity for the normalised wavelet |
| `integral_haarFun_sq` | the normalised wavelet has unit \(L^2\) norm |
| `digit_one_iff_first_interval` | the first digit-set component is exactly \([\alpha_n,\alpha_{n-1})\) |
| `haarFun_eq_zero_of_not_mem_parent` | the wavelet is supported on its parent interval |
| `integral_mul_eq_zero_of_disjoint` | disjoint-parent wavelets are orthogonal |
| `haarFun_eq_left_const`, `haarFun_eq_right_const` | the wavelet is constant on each child |
| `integral_mul_eq_zero_of_subset_left` | nested-in-left-parent wavelets are orthogonal |
| `integral_mul_eq_zero_of_subset_right` | nested-in-right-parent wavelets are orthogonal |
| `accum_eq_half_pi_of_lt` | the second band keeps `A_k = π/2` |
| `digit_one_iff_second_interval` | the second-band digit component is `[π/2+π/(n+2), π/2+π/(n+1))` |
| `digit_one_on_component` | general component for first selected index `j < n` |
| `accum_eq_alpha_of_first_component` | the component accumulator is `αⱼ` |
| `digit_one_component_iff` | the general component converse |
| `partitionR_disjoint` | same-depth partition nodes are disjoint |
| `integral_mul_eq_zero_of_partition_ne` | same-depth wavelets are orthogonal |
| `partitionR_succ_parent` | real depth-\(n+1\) nodes refine their parents |
| `partitionR_succ_subset_parent` | a child node is contained in its parent |
| `partitionR_subset_or_disjoint` | deeper nodes are contained in or disjoint from shallower ones |
| `partitionR_subset_of_not_disjoint` | non-disjoint deeper nodes are contained |
| `partitionR_eq_of_subset` | same-depth nested nodes are equal |
| `partitionR_disjoint_or_subset` | full tree order: disjoint or nested |
| `partitionR_succ_child_or_self` | exact child-or-self refinement with cut endpoints |
| `partitionR_succ_subset_child_or_eq` | one-step child containment |
| `child_intervals_disjoint` | the two child intervals at a cut point are disjoint |
| `partitionR_persist_unsplit` | a node present at consecutive depths is unsplit |
| `partitionR_mem_succ_of_mem_of_lt` | membership is monotone in depth |
| `partitionR_not_mem_of_splits` | a split node does not persist deeper |
| `partitionR_subset_child_of_lt` | arbitrary-depth child containment |
| `integral_mul_eq_zero_of_haar_cases` | pairwise orthogonality from the four local cases |
| `integral_mul_eq_zero_of_partition_parents` | general pairwise orthogonality from the partition tree |
| `integral_root_sq` | the root indicator has unit \(L^2\) norm |
| `integral_root_mul_haarFun` | the root indicator is orthogonal to every wavelet |
| `haarGensNorm_cases` | every generator is the root or a partition-node wavelet |
| `haarGensNorm_unit` | every normalised generator has unit norm |
| `haarDiffAtNorm_parent_data` | parent data for a normalised wavelet generator |
| `root_ne_haarFun` | the root indicator is distinct from every wavelet |
| `wavelet_parent_split_of_data` | a wavelet parent cut is strictly inside the parent |
| `haarFun_eq_of_parent_eq` | same-parent wavelets are equal |
| `haarGensNorm_orthogonal` | distinct normalised generators are orthogonal |
| `integral_add_sq_of_orthonormal` | the two-term isometry step |
| `integral_add_scaled_sq` | the scaled two-term isometry step |
| `haarGensNorm_orthonormal` | the normalised generator family is orthonormal |
| `integral_add_sq_of_orthogonal` | orthogonal block additivity |
| `integral_mul_finsetSum` | cross-term finite-sum linearity |
| `integral_add_three_sq_of_orthogonal` | three-block additivity |
| `integral_smul_sq_of_unit` | single-generator coefficient isometry |
| `integrable_finset_sum_sq` | squared finite sums are integrable |
| `integral_finset_sum_sq_of_orthonormal` | finite-sum coefficient isometry |
| `integrable_haarFun` | every normalised wavelet is integrable |
| `integrable_root_mul_haarFun` | the root–wavelet product is integrable |
| `haarFun_abs_le` | the wavelet is bounded by its coefficient norm |
| `integrable_haarFun_mul` | the wavelet–wavelet product is integrable |
| `integrable_root_mul_root` | the root–root product is integrable |
| `hst_isometry` | the Haar coefficient isometry |
| `integrable_haarGensNorm_sq` | generator self-integrability |
| `hst_isometry_single` | the unconditional single-generator isometry |
| `single_component_lower_of_mul_lt` | the `j(j+3) < n` component criterion |
| `accum_eq_sum_digits` | the accumulator is the sum of selected angles |
| `digit_eq_one_iff_sum_add_le` | the general selection criterion |
| `digit_one_two_selected_iff` | the two-selected-index component criterion |
| `digit_one_iff_selected_finset_sum_le` | the general `Finset` component criterion |
| `at_most_one_selected_in_doubling_interval` | local digit density in `[n,2n+1]` |
| `at_most_one_selected_in_dyadic_block` | at most one selection per dyadic block |
| `digit_count_le_log` | global count bound `D(N) ≤ log₂ N + 1` |

The two Haar theorems are stated for child lengths \(a,b>0\) and \(L=a+b\): the wavelet is
\[
\psi=-\sqrt{\frac{b}{aL}}\,\mathbf 1_L+\sqrt{\frac{a}{bL}}\,\mathbf 1_R,
\]
so
\[
\int\psi^2=a\cdot\frac{b}{aL}+b\cdot\frac{a}{bL}=1,
\qquad
\int\psi=-\sqrt{\frac{b}{aL}}\,a+\sqrt{\frac{a}{bL}}\,b=0.
\]
The proof of `haar_mean_zero` shows inside the theorem that both signed child masses equal \(\sqrt{ab/L}\).

## Convergence and separation

T8 is the key quantitative lemma. If \(r_n\ge\alpha_n\) then
\(r_{n+1}=r_n-\alpha_n\le\pi/(n+1)-\pi/(n+2)\le\pi/(n+2)\); if
\(r_n<\alpha_n\) then \(r_{n+1}=r_n<\pi/(n+2)\). This closes the induction.
Together with \(r_n\ge0\) it squeezes \(r_n\) to zero, so \(A_n\to\theta\) and,
by uniqueness of the sum, \(\theta=\sum_n\delta_n(\theta)\alpha_n\). The
source's equation (2) is therefore a theorem for the residual-subtraction rule,
with an explicit \(O(1/n)\) rate; the source's a.e. wording is stronger than
needed.

T11 and T12 are the two hypotheses of the standard completeness argument for a
Haar system: the digits separate points, and the depth-\(n\) cylinder diameter
is at most \(\pi/(n+1)\). They do not by themselves prove \(L^2\)
completeness; the remaining density step is recorded as open item O1.

No `sorry`, no `axiom`, no `admit`.

## Correction to the source's displayed wavelet

The defect has two layers. `harmonic-tree-haar.tex` equation (5) uses coefficients
\(1/\sqrt{\alpha_n}\) on the right child and \(-1/\sqrt{\ell-\alpha_n}\) on the
left, and its prose says the right child has length \(\alpha_n\).

* Under that prose convention (left \(\ell-\alpha_n\), right \(\alpha_n\)) the
  wavelet has squared norm \(2\), not \(1\), and mean \(\sqrt b-\sqrt a\):
  `source_haar_normSq`, `source_haar_mean`.
* The prose is itself swapped. The split is at \(A_n+\alpha_n\); every cylinder
  has residual zero at its lower endpoint, so the **left** child has length
  \(\alpha_n\) and the right has length \(\ell-\alpha_n\). On the actual tree the
  displayed coefficients give squared norm \(a/b+b/a\ge2\) and mean
  \(-a/\sqrt b+b/\sqrt a\): `actual_source_normSq`,
  `actual_source_normSq_ge_two`, `actual_source_mean`.

`Topic.lean` formalises the repaired zero-mean normalisation instead; C10 checks
the child lengths and the actual norm \(5/2\) at the first non-centred split.

## Correction to the source's threshold claim

The source asserts that \(\theta\mapsto\delta_n(\theta)\) is non-decreasing and that \(\delta_n\) is the step function at \(\theta_n^*\). For the residual-subtraction rule of the source's own equation (1) this is false: at \(t=\theta/\pi=2/5\) the first digit is \(0\) and \(\delta_1=1\), while at \(t=11/20\) the first digit is \(1\) and \(\delta_1=0\). The formal core therefore proves only the true least-threshold statement `threshold_isLeast`, together with the two lemmas that drive it. The Python test `test_digit_is_not_monotone` records the counterexample.

The source's listed threshold values are also wrong for this rule: the least thresholds in \(\pi\)-normalised units are \(1/2,1/3,1/4,1/5,1/6,\dots\), so \(\theta_3^*=\pi/5\), not \(5\pi/12\). This is checked by `test_threshold_scan_equals_harmonic_angles`, `test_third_threshold_and_source_error`, and the Lean theorem `source_threshold_three_wrong`.

## The guide's floor recursion

The research guide's §3.1 defines `δ_n = ⌊(n+2) r_n⌋`,
`r_{n+1} = (n+2) r_n − δ_n`, calls the digits binary, and asserts the
harmonic expansion. All three accompanying claims fail for that recursion:

* `floor_digit_not_binary`: at \(t=9/10\), \(\delta_1=2\).
* `floor_harmonic_partial_gt_target`: the harmonic partial
  \(\sum_{k<4}\delta_k/(k+2)=121/60>9/10\), so the harmonic series cannot
  converge to \(t\).
* `floor_factorial_identity`: the exact expansion is
  \(t=\sum_{k<n}\delta_k/(k+2)!+r_n/(n+1)!\). At \(t=9/10\),
  `floor_factorial_partial_eq_target` gives the factorial partial \(9/10\).

The harmonic expansion belongs to the residual-subtraction rule (T10), not to
the floor rule. The two systems are different algorithms, not two notations for
the same one.

## F1: the finite cylinder partition

The finite combinatorics behind O1 is now formalised over \(\mathbb{Q}\) in the
normalised coordinate \(t=\theta/\pi\).  A `Cyl` is a half-open interval
\([lo,hi)\subseteq[0,1]\); `partition n` is the depth-\(n\) list obtained by
splitting each cylinder at \(lo+1/(n+2)\).  The main results are:

* `partition_tiles`: the list tiles \([0,1)\) in order, with no gaps or overlaps;
* `partition_mesh`: every cylinder has length at most \(1/(n+1)\);
* `splitAt_left_length` and `splitAt_right_length`: at a split the left child
  has length exactly \(1/(n+2)\) and the right child has the remainder.
  This proves the source's figure and refutes its prose (R5);
* `partition_cover`: every \(x\in[0,1)\) lies in a depth-\(n\) cylinder;
* `partition_unique`: that cylinder is unique.

These are the structural hypotheses the completeness argument was missing.  The
real lift and the density theorem below supply the analytic half of O1.

## O1: real lift and uniform density

The rational partition is lifted to \(\mathbb{R}\) by casting its endpoints:
`partitionR n = (partition n).map Cyl.toReal`.  Tiling, coverage, uniqueness and
the mesh bound transfer directly (`partitionR_tiles`, `partitionR_cover`,
`partitionR_unique`, `partitionR_mesh`).

The analytic step is `exists_partition_oscillation_lt`: for continuous \(f\) on
\([0,1]\) and \(\varepsilon>0\), uniform continuity on the compact interval gives
\(\delta>0\), the Archimedean property gives \(n\) with \(1/(n+1)<\delta\), and the
mesh bound makes the oscillation at most \(\varepsilon\) on every depth-\(n\)
cylinder.  Choosing the left endpoint of the unique containing cylinder
(`cylinderRep`) gives the cylinder step function `cylinderStep n f`, and
`cylinder_step_dense` proves that continuous functions are uniformly
approximated by such steps.

The local Haar algebra is also proved: a parent indicator is the sum of its
children (`cylInd_parent_eq_add`), and each child indicator lies in the span of
the parent indicator and the Haar difference (`cylInd_left_mem_span`,
`cylInd_right_mem_span`).  The global induction `cylInd_mem_haarSpan` now proves that every cylinder indicator
lies in the constant-plus-Haar span.  What remains for O1 is the finite-sum/step
assembly and the \(L^2\) passage: show the cylinder-step space is spanned
by the constant function and the Haar wavelets up to depth \(n\), then pass
from uniform density to \(L^2\) completeness and the HST isometry.

## What is not formalised

- Completeness of the Haar system \(\mathcal B\) in \(L^2[0,\pi]\), and hence the isometric-isomorphism claim for the HST. Separation, tiling, mesh, split lengths, coverage, uniqueness, real lift, uniform density, dimension count and the local Haar algebra are proved (T11–T12, T20–T35); the global cylinder-span/Haar-span and the full \(L^2\) completeness passage are not (continuous-function \(L^2\) approximation is proved as T39).
- Any digit-density law (O3) or a closed description of the digit-one sets (O4).
- The transfer operator \(\mathcal L_s\), trace-class estimates, the Fredholm determinant identity \(\det(I-\mathcal L_s)=\zeta(s)/\zeta(2s)e^{P(s)}\), meromorphic continuation of \(\Phi(\theta,s)\), residues, and the Weil-type explicit formula.
- The self-adjoint family \(H(t)\), spectral flow, finite-dimensional approximations, Hilbert–Pólya, and the GRH paper.

These are recorded as source claims or open items in the [programme README](../README.md) and the [source reconciliation](../SOURCE-RECONCILIATION.md). None is a Lean theorem here.

[Back to the programme](../README.md) · [Topic index](../../README.md)
