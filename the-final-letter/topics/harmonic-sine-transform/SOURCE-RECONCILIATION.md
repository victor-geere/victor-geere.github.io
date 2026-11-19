# HST source reconciliation

This note resolves the internal inconsistencies in the imported HST corpus. It does
not edit the archive: the archive is a provenance snapshot, so each defect is
recorded here with the canonical replacement used by the reconstruction. The
ledger has eighteen rows.

**Sources.** `G` = [`hst-research-guide.md`](../../archive/maths/rh/research/harmonic-sine-transform/hst-research-guide.md);
`T` = [`harmonic-tree-haar.tex`](../../archive/maths/rh/research/harmonic-sine-transform/harmonic-tree-haar.tex);
`P` = [`hst-research-programme.tex`](../../archive/maths/rh/research/harmonic-sine-transform/hst-research-programme.tex);
`F` = [`harmonic-sine-transform-vs-fourier.tex`](../../archive/maths/rh/research/harmonic-sine-transform/harmonic-sine-transform-vs-fourier.tex);
`R` = [`hst-further-research.tex`](../../archive/maths/rh/research/harmonic-sine-transform/hst-further-research.tex);
`RR` = [`hst-further-research-results.tex`](../../archive/maths/rh/research/harmonic-sine-transform/hst-further-research-results.tex);
`S` = [`hst-significance.tex`](../../archive/maths/rh/research/harmonic-sine-transform/hst-significance.tex);
`L` = [`archive/maths/hst/index.html`](../../archive/maths/hst/index.html).

Status labels are the programme's own: **Resolved** means the reconstruction now
has a canonical definition or proof; **Refuted** means an explicit counterexample
exists; **Open** means no proof and no counterexample; **Provenance** means the
conflict is bibliographic rather than mathematical.

## Ledger

| # | Source | Statement as imported | Conflict / defect | Canonical resolution | Status and evidence |
|---|---|---|---|---|---|
| R1 | `G` §3.1; `T` eq. (1) | `G`: `δₙ = ⌊(n+2)rₙ⌋`, called binary. `T`: `δₙ = Θ(θ−Aₙ−αₙ) ∈ {0,1}`. | Different algorithms. The floor rule is not binary: at `t = 9/10`, `δ₁ = 2`. | Adopt `T` eq. (1), the residual-subtraction rule, because the tree, thresholds and Haar construction are defined from it. The floor rule is kept as a separate object. | **Resolved** for the canonical rule; **refuted** for the binary claim. `HST.floor_digit_not_binary`, C11. |
| R2 | `G` §3.1 | `θ/π = Σ δₙ/(n+2)` for the floor digits. | False. The floor recursion has factorial denominators; at `t = 9/10` the harmonic partial sum is `121/60 > 9/10`. | The harmonic expansion is a theorem for the *residual* rule (T10). The floor rule has the exact expansion `t = Σ δₙ/(n+2)! + r_N/(N+1)!`. | **Resolved / refuted.** `HST.floor_factorial_identity`, `HST.floor_harmonic_partial_gt_target`, C11. |
| R3 | `T` §2.1 | `θ ↦ δₙ(θ)` is non-decreasing, so `δₙ` is the step function at `θₙ*`. | False for `T`'s own recursion: `δ₁(2π/5)=1` while `δ₁(11π/20)=0`, and `2π/5 < 11π/20`. | Only the least-threshold statement survives: `αₙ = inf{θ : δₙ(θ)=1}`. | **Refuted.** `HST.digit_not_monotone_explicit`, C3. |
| R4 | `T` table after eq. (4) | `θ₀*=π/2`, `θ₁*=π/3`, `θ₂*=π/6`, `θ₃*=5π/12`; thresholds need not be rational multiples of `π`. | The least thresholds are `π/2, π/3, π/4, π/5, …`; `π/6` is `θ₄*`, and `5π/12` is not a threshold. | Use `θₙ* = π/(n+2)`, proved as the least threshold. | **Corrected.** `HST.threshold_isLeast`, `HST.source_threshold_three_wrong`, C1–C2. |
| R5 | `T` §2.1 text and Figure 1 | Text: the right child has length `αₙ`, the left `ℓ−αₙ`. Figure: the left child is the shorter one at `[0,π/2]`. | Text is swapped. The split is at `Aₙ+αₙ`; every cylinder has residual zero at its lower endpoint, so the **left** child has length `αₙ` and the right has length `ℓ−αₙ`. | The figure and the recursion are correct; the prose is corrected. | **Corrected.** `HST.partition_tiles`, `HST.splitAt_left_length`, `HST.splitAt_right_length`, T20–T22; C10 checks every split node exactly. |
| R6 | `T` eq. (5) | `ψ = (1/√αₙ)1_{I_{ε1}} − (1/√(ℓ−αₙ))1_{I_{ε0}}`. | Under the prose convention the squared norm is `2`, not `1`, and the mean is `√b−√a`. Under the **actual** tree the squared norm is `a/b+b/a ≥ 2`, so the wavelet is not normalised on any non-centred split. | Use the repaired zero-mean, unit-norm wavelet `√(b/(aL))` on the left and `−√(a/(bL))` on the right. | **Corrected.** `HST.source_haar_normSq`, `HST.source_haar_mean`, `HST.actual_source_normSq`, `HST.actual_source_normSq_ge_two`, `HST.haar_normSq`, `HST.haar_mean_zero`. |
| R7 | `T` Theorem 2.1 | `B` is an orthonormal basis of `L²[0,π]`; proof says “normalisation is by construction” and completeness follows from separation a.e. | Normalisation is false (R6). Completeness is not proved; the proof is a sketch. | Individual normalisation, zero mean and orthogonality are proved. Separation and mesh-to-zero are now proved (T11–T12), reducing completeness to the standard density step. | **Open / reduced (O1).** `HST.digits_eq_imp_eq`, `HST.cylinder_diameter`, the F1 partition theorems (T20–T24), and the real lift and density theorems (T25–T31); C4, C7–C10. The uniform density step is proved; the cylinder-span/Haar-span and L² passage remain. |
| R8 | `T` eq. (8), attributed to Geere Lemma 3.3 | `D(N,θ) = (θ/π)log(N+2) + O(1)`. | Contradicted by exact computation: at `t = 99/100` there are four selections below `N = 200`, while the formula predicts about `5.3`. | Record the law as an archived claim. The true digit count is the open item O3; exact data show very sparse, irregular selection. | **Refuted.** C6 and the O3 discussion. |
| R9 | `T` §3, eq. (7) | Closed forms for `K(n,n)`, `K(n,m)` using thresholds, and `K` is positive semidefinite. | The formula treats `eₙ = δₙ − θ/π` as a single step at `θₙ*`, which R3 refutes. The true kernel differs; the sibling [`ghd-correlation-kernel`](../ghd-correlation-kernel/README.md) topic records the first off-diagonal mismatch (`π/72` versus `−7π/72`). | Do not use the archived kernel for the true greedy digits. | **Refuted / superseded.** Cross-reference the GHD correction. |
| R10 | `T` §4 and §6; `G` §3.4 | `Φ(θ,s)` continues meromorphically, with poles at the non-trivial zeros; `ℒ_s` is trace-class and `det(I−ℒ_s) = ζ(s)/ζ(2s)e^{P(s)}`. | No construction of `ℒ_s`, no trace-class estimate, no determinant identity. `RR` presents the identity as a theorem but its proof invokes an unproved intertwining lemma. The source itself lists P1 as open. | Record as an archived claim. | **Open (O5–O6).** No Lean statement. |
| R11 | `T` Theorem 5.2; `G` §3.4 | A Weil-type explicit formula with weights `W_f(n)`. | The class `S` and the weights are not constructed; the derivation is a sketch. | Record as an archived claim. | **Open (O6).** |
| R12 | `T` §6; `G` P9 | `H(t)=e^{iπ/4}K(1/2+it)e^{−iπ/4}` is self-adjoint, and eigenvalue `1` occurs exactly at Riemann zeros. | Depends on R10; self-adjointness and the eigenvalue correspondence are asserted, not proved. `G` calls the weaker statement a “partial result available”, while `T` presents it as established. | Record as an archived claim; no Hilbert–Pólya conclusion. | **Open (O7).** |
| R13 | `L` versus `RR` | `L` calls Programmes I–V “fully rigorous”; its own Fredholm-proof card says the proof “contains gaps”; Programme IIX is labelled speculative. | The corpus contradicts itself on proof status. | Treat “fully rigorous” as an archived claim; the reconciliation above is the operative status. | **Provenance / resolved editorially.** |
| R14 | `G` P6 versus `RR` Theorem P6 | `G` asks whether a greedy–MTC bijection exists. `RR` proves that no bijection maps harmonic fractions to scaled Egyptian denominators while preserving branching. | No contradiction: `G` is a research question; `RR` is the negative answer. The true connection is through the transfer operators, not a tree bijection. | Adopt `RR`: no literal bijection. Categorical work may use only the transfer-operator route. | **Resolved.** |
| R15 | `G` header and §2 | The guide synthesises papers in `maths/rh/geo/` and cites `greedy-harmonic-zeta-function.tex`. | That path and file are absent from the archive; the corpus is split across folders and duplicated at item 27. | Item 17 is canonical; item 27 is the duplicate hub. | **Provenance resolved.** |
| R16 | `F` §2.1 versus `T` §3 | `F`: each centred function `eₙ = δₙ − θ/π` “jumps at a unique threshold” and `{eₙ}` is complete, with a Parseval-type identity. `T`: `{eₙ}` is not a Riesz basis; its synthesis operator is unbounded. | The digits are not monotone (R3), so `eₙ` has many jumps, not one. Completeness of `{eₙ}` is not proved, and unbounded synthesis rules out a Parseval frame. | Do not use the centred family as a basis; use the repaired Haar system. | **Refuted / unproved.** T17, T11–T12; no formal Parseval statement. |
| R17 | `G` §3.4 versus `RR` eq. (Ls) | `G` writes `ℒ_s` as a sum over inverse branches with `Tₙ'`; `RR` gives a two-branch Hardy-space formula with explicit weights `(n+1)/(n+2)^{s+1}`. | Two different operators, neither derived from the digit map or the partition. | Record both as underspecified; no canonical `ℒ_s` yet. | **Open**, part of O5. |
| R18 | `harmonic-sine-transform.tex` eq. (Tmap) | The displayed `T` uses scaling `(n+2)/(n+1)` and threshold `1/(n+2)`. | The actual normalised remainder `x_n=(n+2)r_n/π` obeys `x_{n+1}=(n+3)/(n+2)(x_n-1_{x_n≥1})`, threshold `1`. At `n=0` the source map sends `1` to `1`; the actual map sends `1` to `0`. | Adopt the recurrence derived from the residual rule; T125–T126. | **Refuted as written.** T137. |

## What the reconciliation changes

Three substantive corrections follow, and all three are now proved rather than
asserted:

1. **The two digit systems are different.** The binary residual rule and the
   floor rule cannot both be the HST digit rule. The reconstruction uses the
   binary rule, and the floor rule is proved to be a factorial expansion.
2. **The Haar geometry in the text is swapped.** The figure and the recursion
   agree; the prose and equation (5) do not. The repaired wavelet uses the
   actual child lengths.
3. **The threshold and density claims are not repairable.** The threshold table
   is corrected to `π/(n+2)`, digit monotonicity is refuted, and the logarithmic
   density law is contradicted by exact computation.
4. **The centred family is not a basis.** Because the digits are not monotone,
   `eₙ` has many jumps, and the unbounded synthesis operator rules out the
   Parseval identity claimed for it. The Haar repair is not cosmetic; it is
   what makes the transform well posed.

The remaining rows are not defects that a convention can fix: they are the
analytic programme itself, and they remain open or archived claims. The
[roadmap](ROADMAP.md) lists the bridge work each would require.
