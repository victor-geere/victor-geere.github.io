# Harmonic Sine Transform (HST) — research programme

**Status:** reconstructed finite core (Lean + exact computation), with the imported corpus reconciled source-by-source. The greedy expansion converges with an explicit rate, the digit map separates points, and the cylinder mesh is proved to shrink. The source's threshold table, digit monotonicity, child-length prose, wavelet normalisation and floor recursion are now corrected or refuted; the analytic claims are left as source claims and open items. See the [source reconciliation](SOURCE-RECONCILIATION.md) and the [expansion roadmap](ROADMAP.md).
**Source:** [`archive/maths/rh/research/harmonic-sine-transform/hst-research-guide.md`](../../archive/maths/rh/research/harmonic-sine-transform/hst-research-guide.md) and the `.tex` papers in the same directory.  
**Inventory:** [Scraps](../../scraps.html) item 17 · [Topic index](../README.md) · duplicate landing page item 27 ([`hst-programme/`](../hst-programme/README.md)).

## What the programme is

The HST programme is an eight-paper attempt to build a Hilbert–Pólya-style spectral theory of the Riemann zeta function out of Victor Geere's greedy harmonic reconstruction of the sine. Its elementary starting point is small and genuine: the harmonic angles

\[
\alpha_n=\frac{\pi}{n+2},\qquad n=0,1,2,\dots
\]

are used both as the step sizes of a greedy expansion of an angle \(\theta\in[0,\pi]\) and as the **left-child** lengths of a binary tree of cylinder intervals. (The source prose says right child; its figure and the recursion give left — see R5 in the [reconciliation](SOURCE-RECONCILIATION.md).) The tree is then equipped with Haar wavelets and the resulting coefficient map is called the **Harmonic Sine Transform** (HST).

The word "programme" is load-bearing. The archive presents a coherent narrative — Haar basis, isometric HST, transfer operator \(\mathcal{L}_s\), Fredholm determinant \(\det(I-\mathcal{L}_s)=\zeta(s)/\zeta(2s)e^{P(s)}\), Weil explicit formula, spectral flow, Hilbert–Pólya, and a GRH paper — but the load-bearing analytic steps are proofs sketches or unsupported claims. This folder reconstructs the part that can actually be proved and computed, and records the rest with its archived status.

### Provenance and corpus condition

The guide calls itself a synthesis of papers in `maths/rh/geo/`, a path that does not exist in this archive. The actual corpus relevant to item 17 is split across several archive folders:

| Role | File |
|---|---|
| Guide / synthesis | [`hst-research-guide.md`](../../archive/maths/rh/research/harmonic-sine-transform/hst-research-guide.md) |
| Foundations I: tree and Haar basis | [`harmonic-tree-haar.tex`](../../archive/maths/rh/research/harmonic-sine-transform/harmonic-tree-haar.tex) |
| Foundations II: open problems | [`hst-research-programme.tex`](../../archive/maths/rh/research/harmonic-sine-transform/hst-research-programme.tex) |
| Analytic comparison | [`harmonic-sine-transform-vs-fourier.tex`](../../archive/maths/rh/research/harmonic-sine-transform/harmonic-sine-transform-vs-fourier.tex) |
| Further research (problems) | [`hst-further-research.tex`](../../archive/maths/rh/research/harmonic-sine-transform/hst-further-research.tex) |
| Further research (claimed results) | [`hst-further-research-results.tex`](../../archive/maths/rh/research/harmonic-sine-transform/hst-further-research-results.tex) |
| Significance claims | [`hst-significance.tex`](../../archive/maths/rh/research/harmonic-sine-transform/hst-significance.tex) |
| Zero-spectral programme | [`hst-zero-spectral-programme.tex`](../../archive/maths/rh/research/harmonic-sine-transform/hst-zero-spectral-programme.tex), [`hst-zero-spectrum-companion.tex`](../../archive/maths/rh/research/harmonic-sine-transform/hst-zero-spectrum-companion.tex) |
| Duplicate programme landing page | [`archive/maths/hst/index.html`](../../archive/maths/hst/index.html) |

The corpus is **internally inconsistent**. The guide's Section 3.1 defines the digits by the floor recursion

\[
r_0=\theta/\pi,\qquad \delta_n=\lfloor (n+2)r_n\rfloor,\qquad r_{n+1}=(n+2)r_n-\delta_n,
\]

which allows digits \(\delta_n\ge 2\). `harmonic-tree-haar.tex` equation (1) instead uses the residual-subtraction rule

\[
\delta_n(\theta)=\Theta\bigl(\theta-A_n-\alpha_n\bigr),\qquad A_{n+1}=A_n+\delta_n\alpha_n,\qquad A_0=0,
\]

with digits in \(\{0,1\}\). These are different algorithms with different digit statistics. The floor recursion is also not binary: at \(t=9/10\) its second digit is \(2\), and its correct expansion has factorial denominators, not harmonic ones (R1–R2, T18–T19). The present reconstruction follows the residual-subtraction rule, because it is the rule used for the Haar tree, the threshold angles, and the pilot [greedy harmonic decomposition](../greedy-harmonic-decomposition/README.md). Where the guide and the tree paper disagree, this is recorded in the [source reconciliation](SOURCE-RECONCILIATION.md) rather than smoothed over.

The guide also cites a `greedy-harmonic-zeta-function.tex` that is not in this folder (a related paper survives as [`archive/maths/rh/research/greedy-harmonic-zeta/`](../../archive/maths/rh/research/greedy-harmonic-zeta) and as HTML under `harmonic-categorical-hilbert-polya/geo/`). The "eight-paper" count therefore does not correspond to eight self-contained, mutually consistent papers.

## Reconstructed objects and notation

Angles are written \(\theta\); it is often convenient to use \(t=\theta/\pi\in[0,1]\), in which case \(\alpha_n/\pi=1/(n+2)\).

| Object | Reconstruction definition |
|---|---|
| Harmonic angle | \(\alpha_n=\pi/(n+2)\) |
| Accumulated angle | \(A_0=0\), \(A_{n+1}=A_n+\delta_n\alpha_n\) |
| Greedy digit | \(\delta_n(\theta)=1\) if \(\alpha_n\le \theta-A_n\), else \(0\) |
| Threshold | \(\theta_n^*=\inf\{\theta:\delta_n(\theta)=1\}\) |
| Cylinder interval | \(I_\varepsilon=\{\theta:\delta_k(\theta)=\varepsilon_k,\ k<|\varepsilon|\}\) |
| Split node | a node of length \(\ell\) with \(\alpha_n<\ell\); left child length \(\alpha_n\), right child length \(\ell-\alpha_n\) |
| Haar wavelet (reconstructed) | on a node of length \(L=a+b\), left child \(a\), right child \(b\): \(\psi=\sqrt{b/(aL)}\,\mathbf 1_L-\sqrt{a/(bL)}\,\mathbf 1_R\) |
| Accumulated mass | \(M_n(\theta)=\sum_{k\le n}\delta_k(\theta)/(k+2)\), so \(A_n=\pi M_n\) |

The source's displayed wavelet (equation (5) of `harmonic-tree-haar.tex`) is

\[
\psi_{\text{source}}=\frac{1}{\sqrt{\alpha_n}}\mathbf 1_{I_{\varepsilon1}}-\frac{1}{\sqrt{\ell(\varepsilon)-\alpha_n}}\mathbf 1_{I_{\varepsilon0}}.
\]

The defect has two layers. Under the source's prose convention (right child length \(\alpha_n\), left \(\ell-\alpha_n\)) the displayed wavelet has squared norm \(2\), not \(1\), and mean \(\sqrt{\alpha_n}-\sqrt{\ell-\alpha_n}\) (T14). But the prose is itself swapped: on the actual tree the left child has length \(\alpha_n\) and the right \(\ell-\alpha_n\), so the displayed coefficients give squared norm \(a/b+b/a\ge2\) and mean \(-a/\sqrt b+b/\sqrt a\) (T15, C10). The reconstruction uses the correctly normalised zero-mean wavelet above. This repair is proved in Lean and checked exactly in Python.

## Source reconciliation

The imported corpus is not internally consistent. The full ledger has eighteen rows with source locations, verdicts and evidence in [SOURCE-RECONCILIATION.md](SOURCE-RECONCILIATION.md). The seven defects that change the mathematics are:

| # | Defect | Verdict | Evidence |
|---|---|---|---|
| R1 | The guide's floor recursion is not binary, and is not the tree's rule. | **Resolved**: canonical rule is the residual subtraction; floor digit `2` at `t=9/10`. | T18, C11 |
| R2 | The floor recursion is said to expand `θ/π = Σ δₙ/(n+2)`. | **Refuted**: its exact denominators are factorial; the harmonic partial at `t=9/10` is `121/60 > 9/10`. | T19, C11 |
| R3 | The digits are said to be non-decreasing step functions. | **Refuted**: `δ₁(2π/5)=1` but `δ₁(11π/20)=0`. | T17, C3 |
| R4 | The threshold table lists `θ₂*=π/6`, `θ₃*=5π/12`. | **Corrected**: `θₙ*=π/(n+2)`, so `θ₃*=π/5`; `5π/12` is not a threshold. | T5, T16, C1–C2 |
| R5 | The source text puts length `α_n` on the right child. | **Corrected**: the figure and recursion put it on the left; the right child has length `ℓ−α_n`. | C10 |
| R6 | The displayed wavelet is called normalised. | **Corrected**: squared norm `2` under the prose convention and `a/b+b/a ≥ 2` on the actual tree. | T14–T15, C5, C10 |
| R16 | The centred family \(e_n=\delta_n-\theta/\pi\) is called a single-jump complete basis with a Parseval identity. | **Refuted/unproved**: the digits are not monotone, so \(e_n\) has many jumps; the synthesis operator is unbounded and no Parseval frame exists. | T17, T11–T12 |

The remaining rows — the logarithmic density law, the closed-form correlation kernel, the Fredholm determinant, the explicit formula and the self-adjoint family — are refuted or recorded as archived claims; none is promoted. R7 (Haar completeness) is now closed in density form by O1 (T45–T46).

## Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`, `axiom`, or `admit`. Every row marked **Computation** has a pytest test in [`tests/test_programme.py`](tests/test_programme.py). The Lean names are in namespace `HST`.

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | \(\alpha_n>0\) for every \(n\). | `HST.alpha_pos` |
| T2 | Theorem | \(n\mapsto\alpha_n\) is strictly antitone. | `HST.alpha_strictAnti` |
| T3 | Theorem | The accumulated angle never exceeds the target for \(\theta\ge0\): \(A_n(\theta)\le\theta\). | `HST.accum_le_self` |
| T4 | Theorem | Below the threshold, \(A_n(\theta)=0\) whenever \(\theta<\alpha_n\). | `HST.accum_eq_zero_of_lt` |
| T5 | Theorem | **Threshold theorem.** \(\alpha_n\) is the least \(\theta\) with \(\delta_n(\theta)=1\). | `HST.threshold_isLeast` |
| T6 | Theorem | The reconstructed Haar wavelet of a split node has squared norm \(1\). | `HST.haar_normSq` |
| T7 | Theorem | The reconstructed Haar wavelet has zero mean (orthogonality to constants). | `HST.haar_mean_zero` |
| T8 | Theorem | **Residual bound.** For \(0\le\theta\le\pi\), the residual satisfies \(r_n(\theta)=\theta-A_n(\theta)\le\pi/(n+1)\). | `HST.residual_le_pi_div` |
| T9 | Theorem | **Convergence.** \(r_n(\theta)\to0\) and \(A_n(\theta)\to\theta\) for every \(\theta\in[0,\pi]\). | `HST.tendsto_residual`, `HST.tendsto_accum` |
| T10 | Theorem | **Greedy expansion theorem.** \(\theta=\sum_{n\ge0}\delta_n(\theta)\alpha_n\) for every \(\theta\in[0,\pi]\) (source equation (2), for the residual-subtraction rule). | `HST.hasSum_digit_mul_alpha`, `HST.hasSum_digit_div_pi` |
| T11 | Theorem | **Separation.** Angles in \([0,\pi]\) with the same greedy digits are equal; the digit map is injective. | `HST.digits_eq_imp_eq` |
| T12 | Theorem | **Cylinder diameter.** If two angles agree on their first \(n\) digits, they differ by at most \(\pi/(n+1)\). | `HST.cylinder_diameter` |
| T13 | Theorem | **Sine error with rate.** \(|\sin\theta-\sin A_n(\theta)|\le\pi/(n+1)\), the source's \(O(1/n)\) claim made explicit. | `HST.abs_sin_sub_sin_accum_le` |
| T14 | Theorem | **Source wavelet under its prose convention.** With left length \(a\) and right length \(b\), the displayed wavelet has squared norm \(2\) and mean \(\sqrt b-\sqrt a\). | `HST.source_haar_normSq`, `HST.source_haar_mean` |
| T15 | Theorem | **Source wavelet on the actual tree.** With left length \(a=\alpha_n\) and right \(b=\ell-\alpha_n\), the displayed wavelet has squared norm \(a/b+b/a\ge2\) and mean \(-a/\sqrt b+b/\sqrt a\). | `HST.actual_source_normSq`, `HST.actual_source_normSq_ge_two`, `HST.actual_source_mean` |
| T16 | Theorem | **Threshold correction.** \(\delta_3(5\pi/12)=0\), so the source's listed \(5\pi/12\) is not a threshold. | `HST.source_threshold_three_wrong` |
| T17 | Theorem | **Digit monotonicity fails.** \(\delta_1(2\pi/5)=1\) but \(\delta_1(11\pi/20)=0\) although \(2\pi/5<11\pi/20\). | `HST.digit_not_monotone_explicit` |
| T18 | Theorem | **The guide's floor recursion is not binary.** At \(t=9/10\), \(\delta_1=2\). | `HST.floor_digit_not_binary` |
| T19 | Theorem | **The floor recursion is factorial, not harmonic.** \(t=\sum_{k<n}\delta_k/(k+2)!+r_n/(n+1)!\); at \(t=9/10\) the harmonic partial is \(121/60>9/10\), while the factorial partial through five digits is \(9/10\). | `HST.floor_factorial_identity`, `HST.floor_harmonic_partial_gt_target`, `HST.floor_factorial_partial_eq_target` |
| T20 | Theorem | **F1 tiling.** The depth-\(n\) cylinder partition tiles \([0,1)\) in order. | `HST.partition_tiles` |
| T21 | Theorem | **F1 mesh.** Every depth-\(n\) cylinder has length at most \(1/(n+1)\). | `HST.partition_mesh` |
| T22 | Theorem | **F1 split lengths.** At a split, the left child has length exactly \(1/(n+2)\) and the right child has length \(\ell-1/(n+2)\). | `HST.splitAt_left_length`, `HST.splitAt_right_length` |
| T23 | Theorem | **F1 coverage.** Every \(x\in[0,1)\) lies in a depth-\(n\) cylinder. | `HST.partition_cover` |
| T24 | Theorem | **F1 uniqueness.** The depth-\(n\) cylinder containing \(x\in[0,1)\) is unique. | `HST.partition_unique` |
| T25 | Theorem | **O1 real tiling.** The real partition (cast from the rational one) tiles \([0,1)\). | `HST.partitionR_tiles` |
| T26 | Theorem | **O1 real coverage.** Every \(x\in[0,1)\) lies in a real depth-\(n\) cylinder. | `HST.partitionR_cover` |
| T27 | Theorem | **O1 real uniqueness.** The real depth-\(n\) cylinder containing \(x\) is unique. | `HST.partitionR_unique` |
| T28 | Theorem | **O1 real mesh.** Every real depth-\(n\) cylinder has length at most \(1/(n+1)\). | `HST.partitionR_mesh` |
| T29 | Theorem | **Uniform oscillation.** For continuous \(f\) on \([0,1]\) and \(\varepsilon>0\), some depth-\(n\) partition has oscillation at most \(\varepsilon\) on every cylinder. | `HST.exists_partition_oscillation_lt` |
| T30 | Theorem | **Cylinder-step approximation.** Every continuous \(f\) on \([0,1]\) is uniformly approximated on \([0,1)\) by a cylinder-constant function. | `HST.exists_cylinder_step_approx` |
| T31 | Theorem | **Density.** Continuous functions on \([0,1]\) are uniformly approximated by cylinder step functions. | `HST.cylinder_step_dense` |
| T32 | Theorem | **Dimension count.** The depth-\(n\) partition has \(1+\sum_{k<n}\text{splitCount}(k)\) cylinders; refining adds one cylinder per split. | `HST.partition_length`, `HST.partition_length_succ` |
| T33 | Theorem | **Local partition identity.** A parent cylinder indicator is the sum of its two child indicators. | `HST.cylInd_parent_eq_add` |
| T34 | Theorem | **Local Haar identity.** Each child indicator is a linear combination of the parent indicator and the Haar difference. | `HST.cylInd_left_eq_smul`, `HST.cylInd_right_eq_smul` |
| T35 | Theorem | **Local Haar span.** Each child indicator lies in the span of the parent indicator and the Haar difference. | `HST.cylInd_left_mem_span`, `HST.cylInd_right_mem_span` |
| T36 | Theorem | **Global cylinder-to-Haar span.** Every depth-\(n\) cylinder indicator lies in the span of the root indicator and the Haar differences above it. | `HST.cylInd_mem_haarSpan` |
| T37 | Theorem | **Indicator span inclusion.** The span of the depth-\(n\) cylinder indicators is contained in the constant-plus-Haar span. | `HST.indicatorSpan_le_haarSpan` |
| T38 | Theorem | **Haar-span density.** Continuous functions on \([0,1]\) are uniformly approximated by elements of the constant-plus-Haar span. | `HST.haarSpan_dense` |
| T39 | Theorem | **Continuous \(L^2\) approximation.** Every continuous \(f\) on \([0,1]\) is approximated in \(L^2([0,1))\) by an element of the constant-plus-Haar span. | `HST.haarSpan_eLpNorm_approx` |
| T40 | Theorem | **\(L^2\) membership.** For continuous \(f\), the finite cylinder-step sum `cylSum n f` lies in \(L^2([0,1))\). | `HST.cylSum_memLp` |
| T41 | Theorem | **Continuous \(L^2\) membership.** A function continuous on \([0,1]\) lies in \(L^2([0,1))\). | `HST.memLp_of_continuousOn` |
| T42 | Theorem | **Cylinder-step \(L^2\) approximation.** For continuous \(f\), some `cylSum n f` is within \(\varepsilon\) of \(f\) in `eLpNorm`. | `HST.cylSum_eLpNorm_approx` |
| T43 | Theorem | **\(Lp\)-distance approximation.** The `Lp` distance between a continuous \(f\) and its cylinder-step sum is at most \(\varepsilon\). | `HST.edist_toLp_cylSum_approx` |
| T44 | Theorem | **Full \(L^2\) density with a continuous witness.** Every \(L^2\) class is within \(\varepsilon\) of a cylinder-step sum from a continuous function. | `HST.exists_cylSum_edist_lt` |
| T45 | Theorem | **Haar-span \(L^2\) density.** Every \(L^2\) class is within \(\varepsilon\) of the image of an element of the constant-plus-Haar span. | `HST.haarSpan_dense_Lp` |
| T46 | Theorem | **Haar completeness (density form).** The constant-plus-Haar span is dense in \(L^2([0,1))\). | `HST.haar_complete` |
| T47 | Theorem | **Normalised Haar wavelet.** `haarFun` is a nonzero scalar multiple of `haarDiff`; the local span is unchanged. | `HST.haarFun`, `HST.span_haarFun_eq_span_haarDiff` |
| T48 | Theorem | **Normalised generator spans.** The span of the normalised split wavelets equals the span of the `haarDiff` wavelets at every depth. | `HST.span_haarDiffAtNorm_eq` |
| T49 | Theorem | **Normalised span equality.** `haarSpanNorm n = haarSpan n`. | `HST.haarSpanNorm_eq` |
| T50 | Theorem | **Normalised Haar completeness.** The constant-plus-normalised-Haar span is dense in \(L^2([0,1))\). | `HST.haar_complete_norm` |
| T51 | Theorem | **Normalised norm.** The normalised wavelet has unit squared coefficient norm. | `HST.haarFun_coeff_normSq` |
| T52 | Theorem | **Normalised zero mean.** The normalised wavelet has zero signed coefficient mass. | `HST.haarFun_coeff_mean` |
| T53 | Theorem | **Normalised support.** The normalised wavelet vanishes outside its two child intervals. | `HST.haarFun_apply_of_not_mem` |
| T54 | Theorem | **Selection gap bound.** If digits at \(n<m\) are both selected, then \((n+1)(n+2)\le m+2\); selection indices grow at least quadratically. | `HST.digit_one_gap` |
| T55 | Theorem | **Cylinder integral.** The integral of a cylinder indicator over `unitMeasure` is its length. | `HST.integral_cylInd` |
| T56 | Theorem | **Haar difference mean zero.** The `haarDiff` wavelet has zero integral over `unitMeasure`. | `HST.integral_haarDiff_eq_zero` |
| T57 | Theorem | **Normalised wavelet mean zero.** The normalised wavelet has zero integral over `unitMeasure`. | `HST.integral_haarFun_eq_zero` |
| T58 | Theorem | **No consecutive selections after index 1.** If `1 ≤ n` and `δ_n = 1`, then `δ_{n+1} = 0`. | `HST.digit_one_not_succ` |
| T59 | Theorem | **O3 doubling.** For `1 ≤ n`, later selected indices satisfy `2(n+2) ≤ m+2`. | `HST.digit_one_doubling` |
| T60 | Theorem | **Pointwise square identity.** On disjoint children, the wavelet square equals the scalar square of the two child indicators. | `HST.haarFun_sq_eq` |
| T61 | Theorem | **Unit \(L^2\) norm.** The normalised wavelet has integral of its square equal to \(1\). | `HST.integral_haarFun_sq` |
| T62 | Theorem | **First digit component.** For \(n\ge1\) and \(\theta<\alpha_{n-1}\), \(\delta_n(\theta)=1\iff\alpha_n\le\theta\); thus \([\alpha_n,\alpha_{n-1})\) is the first component of the digit-one set. | `HST.digit_one_on_first_interval`, `HST.digit_one_iff_first_interval` |
| T63 | Theorem | **Parent support.** The normalised wavelet vanishes outside its parent interval. | `HST.haarFun_eq_zero_of_not_mem_parent` |
| T64 | Theorem | **Disjoint-support orthogonality.** Normalised wavelets with disjoint parent intervals are orthogonal in \(L^2\). | `HST.integral_mul_eq_zero_of_disjoint` |
| T65 | Theorem | **Child constancy.** The normalised wavelet is constant on each child interval. | `HST.haarFun_eq_left_const`, `HST.haarFun_eq_right_const` |
| T66 | Theorem | **Nested-support orthogonality.** If one wavelet's parent lies in the left child of another, they are orthogonal. | `HST.integral_mul_eq_zero_of_subset_left` |
| T67 | Theorem | **Nested-support orthogonality (right).** If one wavelet's parent lies in the right child of another, they are orthogonal. | `HST.integral_mul_eq_zero_of_subset_right` |
| T68 | Theorem | **Second-band accumulator.** On the second band, `A_k = π/2` for every `1 ≤ k ≤ n`. | `HST.accum_eq_half_pi_of_lt` |
| T69 | Theorem | **Second digit component.** For `n ≥ 2`, the second component of the digit-one set is exactly `[π/2+π/(n+2), π/2+π/(n+1))`. | `HST.digit_one_iff_second_interval` |
| T70 | Theorem | **General digit component.** For \(1\le j<n\), on the band with first selected digit \(j\) and no intermediate selection, \(\delta_n=1\) whenever \(\alpha_j+\alpha_n\le\theta<\alpha_j+\alpha_{n-1}\). | `HST.digit_one_on_component` |
| T71 | Theorem | **Component accumulator.** If `j` is the first selected digit and no intermediate digit is selected, `A_n = αⱼ`. | `HST.accum_eq_alpha_of_first_component` |
| T72 | Theorem | **General component converse.** On the component with first selected digit `j`, `δ_n = 1 ⇔ αⱼ + αₙ ≤ θ`. | `HST.digit_one_component_iff` |
| T73 | Theorem | **Same-depth disjointness.** Distinct nodes of the same partition have disjoint intervals. | `HST.partitionR_disjoint` |
| T74 | Theorem | **Same-depth orthogonality.** Wavelets on distinct nodes of the same partition are orthogonal. | `HST.integral_mul_eq_zero_of_partition_ne` |
| T75 | Theorem | **Real parent refinement.** Every real depth-\(n+1\) node is its parent or one of its two children. | `HST.partitionR_succ_parent` |
| T76 | Theorem | **Parent subset.** Every real depth-\(n+1\) node is contained in its parent. | `HST.partitionR_succ_subset_parent` |
| T77 | Theorem | **Refinement.** A deeper node is either contained in a shallower node or disjoint from it. | `HST.partitionR_subset_or_disjoint` |
| T78 | Theorem | **Not-disjoint containment.** A deeper node not disjoint from a shallower one is contained in it. | `HST.partitionR_subset_of_not_disjoint` |
| T79 | Theorem | **Same-depth containment.** If two same-depth nodes are nested, they are equal. | `HST.partitionR_eq_of_subset` |
| T80 | Theorem | **Tree order.** Any two real partition nodes are disjoint, or one is contained in the other. | `HST.partitionR_disjoint_or_subset` |
| T81 | Theorem | **Exact child-or-self refinement.** Every depth-\(n+1\) node is its parent, left child, or right child, with exact cut endpoints. | `HST.partitionR_succ_child_or_self` |
| T82 | Theorem | **One-step child containment.** A depth-\(n+1\) node contained in a depth-\(n\) node is that node or lies in one of its children. | `HST.partitionR_succ_subset_child_or_eq` |
| T83 | Theorem | **Child disjointness.** The two child intervals at a cut point are disjoint. | `HST.child_intervals_disjoint` |
| T84 | Theorem | **Split-node persistence.** A node present at two consecutive depths is unsplit at the earlier depth. | `HST.partitionR_persist_unsplit` |
| T85 | Theorem | **Membership monotonicity.** A node present at depths \(m<n\) is already present at depth \(m+1\). | `HST.partitionR_mem_succ_of_mem_of_lt` |
| T86 | Theorem | **Split nodes do not persist.** A node that splits at depth \(m\) does not appear at any deeper depth. | `HST.partitionR_not_mem_of_splits` |
| T87 | Theorem | **Arbitrary-depth child containment.** A deeper node inside a splitting shallower node lies in its left or right child. | `HST.partitionR_subset_child_of_lt` |
| T88 | Theorem | **Pairwise orthogonality from local cases.** If two Haar parents are disjoint or one lies in a child of the other, the wavelets are orthogonal. | `HST.integral_mul_eq_zero_of_haar_cases` |
| T89 | Theorem | **General pairwise orthogonality.** Wavelets whose parents are partition nodes and whose split points match the partition cuts are orthogonal unless the parents coincide. | `HST.integral_mul_eq_zero_of_partition_parents` |
| T90 | Theorem | **Root unit norm.** The root indicator equals `1` on `[0,1)` and has unit \(L^2\) norm. | `HST.cylInd_root_apply`, `HST.integral_root_sq` |
| T91 | Theorem | **Root orthogonality.** The root indicator is orthogonal to every normalised wavelet. | `HST.integral_root_mul_haarFun` |
| T92 | Theorem | **Generator membership.** Every normalised generator is the root indicator or a wavelet at some partition node below the depth. | `HST.haarGensNorm_cases` |
| T93 | Theorem | **Generator unit norm.** Every normalised generator has unit \(L^2\) norm. | `HST.haarGensNorm_unit` |
| T94 | Theorem | **Wavelet parent data.** Every normalised wavelet generator exposes its partition parent, child midpoint, and matching cut. | `HST.haarDiffAtNorm_parent_data` |
| T95 | Theorem | **Root distinctness.** The root indicator is distinct from every normalised wavelet. | `HST.root_ne_haarFun` |
| T96 | Theorem | **Parent split.** A wavelet's parent cut is strictly inside its parent interval. | `HST.wavelet_parent_split_of_data` |
| T97 | Theorem | **Same-parent equality.** Two normalised wavelets with the same parent interval are equal. | `HST.haarFun_eq_of_parent_eq` |
| T98 | Theorem | **Generator orthogonality.** Distinct normalised generators are orthogonal. | `HST.haarGensNorm_orthogonal` |
| T99 | Theorem | **Two-term isometry step.** The sum of two orthogonal unit vectors has squared norm \(2\). | `HST.integral_add_sq_of_orthonormal` |
| T100 | Theorem | **Scaled two-term isometry.** For orthogonal unit `f, g`, the combination `a f + b g` has squared norm `a² + b²`. | `HST.integral_add_scaled_sq` |
| T101 | Theorem | **Generator orthonormality.** `haarGensNorm N` is a unit-norm, pairwise-orthogonal family. | `HST.haarGensNorm_orthonormal` |
| T102 | Theorem | **Orthogonal block additivity.** Adding an orthogonal block adds squared norms. | `HST.integral_add_sq_of_orthogonal` |
| T103 | Theorem | **Cross-term finite-sum linearity.** Multiplication by a fixed function distributes over a finite sum under the integral. | `HST.integral_mul_finsetSum` |
| T104 | Theorem | **Three-block additivity.** Three pairwise orthogonal blocks add squared norms. | `HST.integral_add_three_sq_of_orthogonal` |
| T105 | Theorem | **Single-generator coefficient isometry.** Scaling a unit vector by `c` scales its squared norm by `c²`. | `HST.integral_smul_sq_of_unit` |
| T106 | Theorem | **Finite-sum square integrability.** A squared finite sum is integrable when all pairwise products are. | `HST.integrable_finset_sum_sq` |
| T107 | Theorem | **Finite-sum coefficient isometry.** For a finite orthonormal family, the squared norm of a coefficient sum is the sum of squared coefficients. | `HST.integral_finset_sum_sq_of_orthonormal` |
| T108 | Theorem | **Wavelet integrability.** Every normalised wavelet is integrable over `unitMeasure`. | `HST.integrable_haarFun` |
| T109 | Theorem | **Root–wavelet integrability.** The root indicator times a wavelet is integrable. | `HST.integrable_root_mul_haarFun` |
| T110 | Theorem | **Wavelet boundedness.** Every normalised wavelet is bounded by its coefficient times the sum of inverse child lengths. | `HST.haarFun_abs_le` |
| T111 | Theorem | **Wavelet–wavelet integrability.** The product of two normalised wavelets is integrable. | `HST.integrable_haarFun_mul` |
| T112 | Theorem | **Root–root integrability.** The root indicator squared is integrable. | `HST.integrable_root_mul_root` |
| T113 | Theorem | **Haar coefficient isometry.** For any finite subfamily of the normalised generators, the squared \(L^2\) norm of a coefficient sum is the sum of squared coefficients. | `HST.hst_isometry` |
| T114 | Theorem | **Generator self-integrability.** Every normalised generator squared is integrable. | `HST.integrable_haarGensNorm_sq` |
| T115 | Theorem | **Single-generator Haar isometry.** For every generator, `∫ (c f)² = c²`, with no extra hypotheses. | `HST.hst_isometry_single` |
| T116 | Theorem | **Single-component criterion.** For `1 ≤ j`, if `j(j+3) < n` then the single-previous-selection component exists. | `HST.single_component_lower_of_mul_lt` |
| T117 | Theorem | **Accumulator as selected sum.** `A_n(θ)` is the sum of `α_k` over the selected digits `k<n`. | `HST.accum_eq_sum_digits` |
| T118 | Theorem | **General selection criterion.** `δ_n=1` exactly when the sum of earlier selected angles plus `α_n` is at most `θ`. | `HST.digit_eq_one_iff_sum_add_le` |
| T119 | Theorem | **Two-selected-index component.** If exactly `j` and `k` are selected before `n`, then `δ_n = 1 ⇔ α_j + α_k + α_n ≤ θ`. | `HST.digit_one_two_selected_iff` |
| T120 | Theorem | **General component criterion.** For any finite set `s` of earlier selected indices, `δ_n = 1 ⇔ ∑_{k∈s} α_k + α_n ≤ θ`. | `HST.digit_one_iff_selected_finset_sum_le` |
| T121 | Theorem | **Local digit density.** For `n ≥ 1`, the interval `[n, 2n+1]` contains at most one selected index. | `HST.at_most_one_selected_in_doubling_interval` |
| T122 | Theorem | **Dyadic block density.** For every `m`, the block `[2^m, 2^(m+1)-1]` contains at most one selected index. | `HST.at_most_one_selected_in_dyadic_block` |
| T123 | Theorem | **Global digit-count bound.** The number of selected indices in `[1,N]` is at most `log₂ N + 1`. | `HST.digit_count_le_log` |
| T124 | Theorem | **Zero target has zero digit frequency.** At `θ=0`, every harmonic digit is `0`. | `HST.digit_zero_eq_zero` |
| T125 | Theorem | **Residual recurrence.** `r_{n+1} = r_n - δ_n α_n`. | `HST.residual_succ_eq` |
| T126 | Theorem | **Normalised greedy remainder map.** With `x_n=(n+2)r_n/π`, `x_{n+1}=(1+1/(n+2))(x_n-1_{x_n≥1})`. | `HST.greedyX_succ` |
| T127 | Theorem | **Zero-branch inverse.** For `y < (n+3)/(n+2)`, `greedyT n (greedyBranch0 n y)=y`. | `HST.greedyT_branch0` |
| T128 | Theorem | **One-branch inverse.** For `y ≥ 0`, `greedyT n (greedyBranch1 n y)=y`. | `HST.greedyT_branch1` |
| T129 | Theorem | **Greedy Markov branch partition.** The branches recover `x` on `x<1` and `x≥1`. | `HST.greedyT_branch_partition` |
| T130 | Theorem | **Finite transfer operator.** The archived `L_s` truncation is defined and linear in `f`. | `HST.greedyL`, `HST.greedyL_add`, `HST.greedyL_smul` |
| T131 | Theorem | **Greedy harmonic zeta summability.** `Φ(θ,s)=Σ δ_n(θ)/(n+2)^s` converges for integer `s ≥ 2`. | `HST.greedyZeta_summable` |
| T132 | Theorem | **Finite operator on constants.** `L f` for constant `f=c` equals `2c Σ (n+1)/(n+2)^k`. | `HST.greedyL_const` |
| T133 | Theorem | **Finite operator bound.** If `|f|≤C`, then `|L f|≤C·2Σ(n+1)/(n+2)^k`. | `HST.greedyL_abs_le` |
| T134 | Theorem | **Trace-class threshold.** The `k=1` weight series diverges; its terms are at least `1/2`. | `HST.greedyWeight_one_not_summable` |
| T135 | Theorem | **Greedy endpoint dynamics.** `T_n(0)=0` and `T_n(1)=0`. | `HST.greedyT_zero`, `HST.greedyT_one` |
| T136 | Theorem | **Weight summability for `k ≥ 3`.** The finite-operator weight behaves like `1/n^{k−1}` and is summable for `k ≥ 3`. | `HST.greedyWeight_summable` |
| T137 | Theorem | **Source map mismatch.** The source's displayed `T` at `n=0` sends `1` to `1`; the actual normalised remainder map sends `1` to `0`. | `HST.sourceT0_one_ne_greedyT_zero_one` |
| T138 | Theorem | **Uniform finite-operator bound.** For `k ≥ 3`, `|L f|` is bounded uniformly in truncation depth by `C·2Σ'(n+1)/(n+2)^k`. | `HST.greedyL_uniform_bound` |
| T139 | Theorem | **Transfer term summability.** For bounded `f` and `k ≥ 3`, the branch series is summable. | `HST.summable_greedyL_term` |
| T140 | Theorem | **Infinite transfer operator.** The finite truncations converge to `greedyLInf`. | `HST.greedyL_tendsto` |
| T141 | Theorem | **Infinite operator on constants.** The finite constant action converges to `c·2Σ′(n+1)/(n+2)^k`. | `HST.greedyL_const_tendsto` |
| T142 | Theorem | **Infinite operator additivity.** `greedyLInf` is additive on bounded functions. | `HST.greedyLInf_add` |
| T143 | Theorem | **Infinite operator homogeneity.** `greedyLInf` is homogeneous. | `HST.greedyLInf_smul` |
| T144 | Theorem | **Greedy zeta bound.** `Φ(θ,s)` is bounded by the corresponding `p`-series for `s ≥ 2`. | `HST.greedyZeta_le_base` |
| T145 | Theorem | **Greedy zeta exponent monotonicity.** `Φ(θ,s+1) ≤ Φ(θ,s)` for `s ≥ 2`. | `HST.greedyZeta_succ_le` |
| T146 | Theorem | **Greedy zeta partial sums.** `Φ(θ,s)` is the limit of its finite partial sums for `s ≥ 2`. | `HST.greedyZeta_tendsto` |
| T147 | Theorem | **Greedy zeta signs.** `Φ(θ,s) ≥ 0`, and `Φ(0,s)=0`. | `HST.greedyZeta_nonneg`, `HST.greedyZeta_zero` |
| T148 | Theorem | **Infinite operator bound.** The infinite operator satisfies the same `C·2Σ′(n+1)/(n+2)^k` bound for `k ≥ 3`. | `HST.greedyLInf_abs_le` |
| T149 | Theorem | **Infinite operator zero and negation.** `greedyLInf` sends `0` to `0` and commutes with negation. | `HST.greedyLInf_zero`, `HST.greedyLInf_neg` |
| T150 | Theorem | **Infinite operator Lipschitz bound.** `|L f − L g| ≤ C·2Σ′(n+1)/(n+2)^k` when `|f−g|≤C`. | `HST.greedyLInf_sub_abs_le` |
| C12 | Computation | Component-count jump points through \(n=155\): \(2,4,6,8,10,14,18,22,26,30,34,40\) at \(n=1,5,11,19,29,41,55,71,89,109,131,155\). | `test_component_count_jump_table` |
| C13 | Computation | Exact measure of the digit-one set for \(n=1,\dots,15\): \(1/3,1/6,1/10,1/15,2/21,1/14,1/18,2/45,2/55,1/33,1/26,3/91,1/35,1/40,3/136\). | `test_digit_one_measure_small_depths` |
| C14 | Computation | Selected-digit counts up to `n=200` at `t=0,1/3,9/10,99/100` are `0,1,3,4`. | `test_sample_digit_frequencies` |
| C1 | Computation | The exact tree scan gives \(\theta_n^*/\pi=1/(n+2)\) for \(n<40\). | `test_threshold_scan_equals_harmonic_angles` |
| C2 | Computation | \(\theta_3^*=\pi/5\); the source's claimed \(5\pi/12\) is not a threshold. | `test_third_threshold_and_source_error` |
| C3 | Computation | \(\delta_1(2\pi/5)=1\) but \(\delta_1(11\pi/20)=0\): the digits are not monotone. | `test_digit_is_not_monotone` |
| C4 | Computation | The reconstructed tree wavelets through depth 6 are orthonormal and mean-zero. | `test_tree_wavelets_are_orthonormal_and_mean_zero` |
| C5 | Computation | Under the source's prose child-length convention, the displayed wavelet has squared norm \(2\) and mean \(\sqrt b-\sqrt a\). | `test_source_normalisation_defect_and_equal_child_edge_case` |
| C6 | Computation | Selected mass is at most \(\theta\); \(0\le\theta-\pi M_N\le\pi/(N+1)\) on a grid; the sparse selection indices at \(t=99/100\) are \(0,1,5,71\). | `test_cylinder_mass_and_residual_bounds` |
| C7 | Computation | The exact depth-\(n\) cylinder mesh is \(1/(n+1)\) for \(1\le n\le40\). | `test_cylinder_mesh_is_exact_and_shrinks` |
| C8 | Computation | The digit-one set \(\{\theta:\delta_n(\theta)=1\}\) is a finite union of intervals, not an interval in the computed range: component counts \(1,2,2,2,2,4,4,4,4,4,4,6,\dots\). | `test_digit_sets_are_finite_unions_not_intervals` |
| C9 | Computation | Points in the same depth-\(n\) cylinder agree on the first \(n\) digits and differ by at most \(1/(n+1)\). | `test_cylinders_separate_points` |
| C10 | Computation | Every split node has left length \(\alpha_n\) and right length \(\ell-\alpha_n\); at depth 1 the children of \([0,1/2]\) are \((1/3,1/6)\), so the displayed wavelet has actual squared norm \(5/2\). | `test_source_child_lengths_are_swapped` |
| C11 | Computation | The guide's floor digits at \(t=9/10\) are \([1,2,1,3,0,0]\); the harmonic partial is \(121/60>9/10\), the factorial partial is \(9/10\), and the factorial identity holds exactly. | `test_guide_floor_recursion_is_factorial_not_harmonic` |
| S* | Source claim | Thirteen archived claims (Haar ONB, digit monotonicity, threshold values, density, floor recursion, child lengths, continuation, Fredholm determinant, trace class, Weil formula, Hilbert–Pólya, GRH, MTC correspondence), each with its archived status. The expansion claim is no longer a source claim: it is proved as T10. | source-claims table below |
| O* | Open / conjecture | Five unresolved items (digit statistics, digit-set structure, transfer operator, explicit formula, Hilbert–Pólya/GRH). O1 (Haar completeness) is closed by T45–T46; O2 is closed by T8–T10. | open-items table below |

Three further tests cover the new structural computations C7–C9. Two supporting tests cover the exact angle sequence and the endpoint \(t=0\) / invalid-input edge cases: `test_alpha_sequence_is_exact_and_strictly_decreasing` and `test_greedy_digits_exact_and_edge_cases`.

T8–T10 close the convergence question. The proof is a two-line induction: if \(r_n\ge\alpha_n\) then \(r_{n+1}=r_n-\alpha_n\le\pi/(n+1)-\pi/(n+2)\le\pi/(n+2)\), and if \(r_n<\alpha_n\) then \(r_{n+1}=r_n<\pi/(n+2)\). Squeezing between \(0\) and \(\pi/(n+1)\) gives convergence with an explicit rate, hence the expansion identity by uniqueness of sums. T11–T12 are the two hypotheses of the standard completeness argument for a Haar system: injectivity of the digit map and mesh-to-zero. Together with the real lift, the cylinder-step approximation and the `Lp` density theorem (T25–T46), these now prove Haar completeness in density form.

The crucial structural point is T5. It does **not** say that \(\theta\mapsto\delta_n(\theta)\) is a step function; C3 shows that it is not. The source's equation (3) asserts the step-function characterisation, and that assertion is false for the source's own equation (1). T5 is the weaker true statement that survives: the infimum of the selection set is exactly \(\alpha_n\).

## Source claims (not promoted to theorems)

These are recorded with the archive's status. None is used as a theorem of this reconstruction.

**Resolved source claim.** Source equation (2), \(\theta/\pi=\sum_{n\ge0}\delta_n(\theta)/(n+2)\), stated for a.e. \(\theta\), is now **proved** for every \(\theta\in[0,\pi]\) under the residual-subtraction rule by T10, with the explicit error bound \(\pi/(n+1)\) from T8. The a.e. wording is superseded by the everywhere statement.

| Claim | Kind | Source status | Reconstruction note |
|---|---|---|---|
| The Haar system \(\mathcal B\) is an orthonormal basis of \(L^2[0,\pi]\). | Source claim | source claim, section 2, proof sketch | Not formalised. The displayed wavelet is not normalised under either reading (T14–T15, C5, C10); the repaired wavelets are individually orthonormal (T6, T7, C4). Completeness is now proved in density form by O1 (T45–T46). |
| \(\theta\mapsto\delta_n(\theta)\) is non-decreasing, so \(\delta_n\) is the step function at \(\theta_n^*\). | Source claim | Source equation (3) and the surrounding observation | **Refuted** for the residual-subtraction rule by T17 and C3. Only the least-threshold statement T5 holds. |
| \(\theta_0^*=\pi/2,\ \theta_1^*=\pi/3,\ \theta_2^*=\pi/6,\ \theta_3^*=5\pi/12\). | Source claim | Source table after equation (4) | **Contradicted** by T16 and C1/C2: the correct values are \(\pi/2,\pi/3,\pi/4,\pi/5\). The listed \(\pi/6\) is \(\theta_4^*\); \(5\pi/12\) is not a threshold. |
| The guide's floor recursion is binary and expands \(\theta/\pi=\sum_n\delta_n/(n+2)\). | Source claim | Guide §3.1 | **Refuted** by T18–T19 and C11. The floor digits are not binary, and the exact expansion uses factorial denominators. The harmonic expansion is a theorem for the residual rule only (T10). |
| The source text's right child has length \(\alpha_n\), and the displayed wavelet is normalised. | Source claim | `harmonic-tree-haar.tex` §2.1 and eq. (5) | **Corrected** by C10 and T14–T15: the actual left child has length \(\alpha_n\); the displayed wavelet has squared norm \(2\) under the prose convention and \(a/b+b/a\ge2\) on the actual tree. |
| Selection density \(D(N,\theta)=\sum_{n\le N}\delta_n(\theta)=(\theta/\pi)\log(N+2)+O(1)\). | Source claim | Source Lemma 3.3, asserted | Not used. Exact computation shows that under the residual-subtraction rule selections are extremely sparse (at \(t=99/100\): indices \(0,1,5,71,9016,\dots\)). Under the guide's floor recursion the digits form a different sequence entirely, and the stated logarithmic law is not established anywhere in the corpus. The density law is an archived claim, not a theorem. |
| \(s\mapsto\Phi(\theta,s)=\sum_n\delta_n(\theta)/(n+2)^s\) continues meromorphically, with a simple pole at \(s=1\) of residue \(\theta/\pi\) and further poles at the non-trivial zeros of \(\zeta\). | Source claim | source claim, section 2, proof sketch | Not formalised; proof sketch invokes a transfer operator that is never constructed. |
| \(\det_{(1)}(I-\mathcal L_s)=\zeta(s)/\zeta(2s)e^{P(s)}\), and zeros of \(\zeta\) are eigenvalue-1 parameters of \(\mathcal L_s\). | Source claim | Source Problem P1; later `hst-further-research-results.tex` presents it as a theorem | Archived claim. The later "proof" rests on an unproved intertwining Lemma with the Gauss transfer operator. Not formalised; no Lean statement. |
| \(\mathcal L_s\) is trace-class for \(\operatorname{Re}s>1/2\) (P3). | Source claim | Source claim, later presented as a theorem | Archived claim; the singular-value estimates are asserted, not proved. |
| Weil-type explicit formula for HST coefficients. | Source claim | source claim, section 2, sketch | Archived claim; the weights \(W_f(n)\) are not constructed. |
| \(H(t)=e^{i\pi/4}K(1/2+it)e^{-i\pi/4}\) is self-adjoint and eigenvalue \(1\) occurs exactly at Riemann zeros; spectral flow proves Hilbert–Pólya. | Source claim | Source Section 5 and P8–P10, speculative | Archived claim. P9 is explicitly left open in `hst-further-research-results.tex`; the programme's own significance paper says it does not prove RH. |
| The Programme IIX paper proves the Generalised Riemann Hypothesis via HST and greedy decomposition. | Source claim | Archived GRH claim (`archive/maths/latex/proof.tex`, not this folder) | **Not a theorem.** No step of the GRH argument is formalised here; the finite core below has no bearing on GRH. Recorded as an archived claim. |
| Greedy–MTC correspondence: a bijection exists (guide P6) versus no such bijection exists (`hst-further-research-results.tex` Theorem P6). | Source claim | Source claims, mutually inconsistent | Unresolved corpus contradiction. Neither direction is formalised. |

## Python layer

[`python/programme.py`](python/programme.py) is importable without side effects and uses exact `Fraction`/sympy arithmetic. It provides:

- `alpha(n)`, `alpha_scaled(n)` — the harmonic angle and its \(\pi\)-normalised value;
- `greedy_digits(t, n_max)`, `greedy_accumulated`, `residual` — the exact digit recursion;
- `tree_intervals(n_max)`, `thresholds_exact(n_max)` — exact cylinder scan and thresholds;
- `cylinder_mesh(n_max)`, `digit_one_intervals(n)`, `digit_set_components(n)` — exact mesh size and the interval decomposition of the digit-one set;
- `split_lengths(n)`, `guide_floor_digits`, `guide_floor_remainder`, `guide_factorial_partial`, `guide_harmonic_partial` — the child-length check and the guide's alternative recursion;
- `tree_wavelets(n_max)`, `reconstructed_wavelet(a, b)`, `source_wavelet(a, b)` — the repaired and source Haar wavelets;
- `haar_norm_sq`, `haar_mean`, `inner_product` — exact integrals of piecewise-constant wavelets.

Example, from this folder:

```python
from fractions import Fraction
from python.programme import thresholds_exact, greedy_digits, tree_wavelets, haar_norm_sq

thresholds_exact(6)                       # [1/2, 1/3, 1/4, 1/5, 1/6, 1/7]
greedy_digits(Fraction(5, 12), 3)         # [0, 1, 0, 0]: 5π/12 is not θ_3*
all(haar_norm_sq(w) == 1 for w in tree_wavelets(5))
```

Run the suite (from this folder):

```bash
python3 -m pytest -q tests
```

Recorded result: **13 passed** in under a second. The tests include the endpoint/edge cases \(t=0\) and invalid \(t\notin[0,1]\), the C7–C9 structural computations, and the C10–C11 source-reconciliation checks.

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib, works in namespace `HST`, and proves T1–T123. It defines the harmonic angle, the residual-subtraction accumulator, the digit, the residual, the two Haar coefficients, the source-wavelet coefficients under both conventions, and the guide's floor recursion. There is no `sorry`, `axiom`, or `admit`.

```bash
./lean/check.sh
```

The wrapper calls the shared checker at [`../tools/check-lean.sh`](../tools/check-lean.sh), which uses the local Mathlib installation (`~/lean/mathlib4`, Lean `v4.35.0-rc2`). The recorded build is [`lean/BUILD.log`](lean/BUILD.log). See [`lean/README.md`](lean/README.md) for what is and is not formalised.

## Open items and gaps

Each row is an **Open / conjecture** item: a precise unresolved statement, not a theorem of this reconstruction.

**Closed items.** O2 (expansion convergence) is closed: T8 gives \(r_n\le\pi/(n+1)\), T9 gives \(A_n\to\theta\), and T10 gives \(\theta=\sum_n\delta_n\alpha_n\) for every \(\theta\in[0,\pi]\). O1 (Haar completeness) is closed in density form: T45–T46 prove that the constant-plus-Haar span is dense in \(L^2([0,1))\). The isometry statement `hst_isometry` is the remaining corollary target, not a gap in completeness.

| # | Kind | Statement | Why it is open |
|---|---|---|---|
| O3 | **Closed / proved bound** | A correct digit-count bound for \(D(N,\theta)\). | The source's logarithmic law is contradicted by exact computation. T123 now proves the global bound \(D(N,\theta)\le\log_2 N+1\); the exact asymptotic law remains a refinement, not a correctness issue. See [roadmap §3](ROADMAP.md#3-o3--the-correct-digit-statistics). |
| O4 | **Closed for recurrence and description; count extension open** | Describe the digit-one sets and relate later digits to the selected-angle threshold. | T117 proves \(A_n\) is the sum of selected angles, T118 the exact selection criterion, and T120 the general \(Finset\)-indexed component criterion. The count itself is recorded as the exact jump table C12; a proved count formula for all \(n\) remains an extension. See [F2/O4 status](F2-O4-STATUS.md). |
| O5 | Open / conjecture | Construct the transfer operator \(\mathcal L_s\), prove trace-classness for \(\operatorname{Re}s>1/2\), and prove \(\det(I-\mathcal L_s)=\zeta(s)/\zeta(2s)e^{P(s)}\). | The archived claims rest on an unproved intertwining with the Gauss transfer operator: [`hst-further-research-results.tex`](../../archive/maths/rh/research/harmonic-sine-transform/hst-further-research-results.tex) asserts \(\mathcal L_s=V\mathcal G_sV^{-1}+K_s\) with a trace-class remainder. No live topic proves the trace-class identity; the finite operator core is isolated in [`hst-transfer-operator`](../hst-transfer-operator/README.md). [`proof-99-global-harmonic-framework`](../proof-99-global-harmonic-framework/README.md) is the only live Gauss/Mayer–Ruelle topic, but reconstructs finite algebra only and records the similarity as unproved; [`angular-partition-method`](../angular-partition-method/README.md) uses Gaussian test functions, not the Gauss map; [`greedy-harmonic-transfer-operator`](../greedy-harmonic-transfer-operator/README.md) is an empty-source weighted-shift placeholder. Finite core: [`hst-transfer-operator`](../hst-transfer-operator/README.md). See [Roadmap §5](ROADMAP.md#5-o5--the-transfer-operator-and-fredholm-determinant). |
| O6 | Open / conjecture | Prove the meromorphic continuation and residues of \(\Phi(\theta,s)\), and the Weil-type explicit formula with explicit weights \(W_f(n)\). | Source claims with proof sketches only; no weights are constructed. |
| O7 | Open; finite pieces exist elsewhere | Construct a self-adjoint Hilbert–Pólya operator whose spectrum is the non-trivial zeros; decide the GRH route. | Not done here. Finite algebraic pieces are in [`greedy-harmonic-hilbert-polya`](../greedy-harmonic-hilbert-polya/README.md) (local quadratics and Galerkin eigenvalues, T1–T7), [`harmonic-categorical-hilbert-polya`](../harmonic-categorical-hilbert-polya/README.md) (finite transfer matrix and determinant, T1–T6), and [`self-adjoint-ccm`](../self-adjoint-ccm/README.md) (Hermitian compression, T8–T11). None constructs the operator domain, proves essential self-adjointness, or identifies the spectrum with the zeros. The CCM constant-matching spectrum is a lattice and is explicitly excluded; the greedy-HP Mellin bijectivity is open. Positivity-side work is in [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md) and [`weil-positivity`](../weil-positivity/README.md), not an operator construction. [`qefe`](../qefe/README.md) is unrelated (theta/functional equation). No RH or GRH claim. |

## Expansion and gap bridges

The programme has a clear finite frontier and a much harder analytic one. The full plan is in [ROADMAP.md](ROADMAP.md); the short version is:

| Order | Gap | Next bridge | Status |
|---|---|---|---|
| 1 | F1 | **Proved (T20–T24)**: partition tiles, mesh \(1/(n+1)\), split lengths, coverage, and uniqueness. | done |
| 2 | O1 | **Completeness and isometry proved** (T25–T46, T113–T115). | done |
| 3 | F2/O4 | **Recurrence and closed description proved** (T117–T120); exact count formula remains an extension (C12 jump table). | done (description) |
| 4 | O3 | **Proved** \(D(N,\theta)\le\log_2 N+1\) (T123). | done |
| 5 | F3 | **Closed by obstruction** (T18–T19, C11): the floor rule is factorial, not binary. | done |
| 5b | F4 | **Done**: exact measure (T55, C13), zero frequency (T124), uniform `O(log N/N)` density (T123). | done |
| 6 | O5 | Define the transfer operator, prove trace-classness on \(\operatorname{Re}s>1\), then the determinant identity. | hard |
| 7 | O6 | Construct the test-function class and weights for the Weil formula. | hard |
| 8 | O7 | Build the self-adjoint family and prove the eigenvalue correspondence. Finite HP/Galerkin pieces exist in `greedy-harmonic-hilbert-polya`, `harmonic-categorical-hilbert-polya` and `self-adjoint-ccm`; the operator and spectrum identification remain open. | very hard |
| 9 | R14 | **Resolved**: no literal greedy–MTC bijection; use the transfer-operator route. | done |

A gap is treated as bridged only when the statement is a Lean theorem with no `sorry`, `axiom` or `admit`, and the exact computation agrees. The roadmap also records the acceptance criteria and the known risks for each step.

## Verification

```bash
cd the-final-letter/topics/harmonic-sine-transform
python3 -m pytest -q tests
./lean/check.sh 2>&1 | tee lean/BUILD.log
```

A topic is complete when both commands pass and this ledger agrees with the files.

## Links

- [Scraps inventory](../../scraps.html) — item 17 (and duplicate item 27)
- [Source reconciliation](SOURCE-RECONCILIATION.md) — the eighteen-row defect ledger
- [Expansion and gap bridges](ROADMAP.md) — the forward plan
- [O1 `L²` bridge](O1-L2-BRIDGE.md) — the completed density route and isometry (T113–T115)
- [Isometry status](ISOMETRY-STATUS.md) — the proved orthogonality chain and the closing isometry theorems
- [F2/O4 status](F2-O4-STATUS.md) — the proved digit components and the remaining component-count extension
- [Roadmap support matrix](ROADMAP-SUPPORT.md) — graph-backed support and obstructions for F4/O5–O7/P5–P7
- [Topic index](../README.md)
- [Greedy harmonic decomposition](../greedy-harmonic-decomposition/README.md) — the completed pilot for the same angle sequence
- [The Final Letter](../../index.html)

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
