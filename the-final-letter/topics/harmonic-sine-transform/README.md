# Harmonic Sine Transform (HST) — research programme

**Status:** reconstructed finite core (Lean + exact computation) with the archived analytic claims left as source claims and open items.  
**Source:** [`archive/maths/rh/research/harmonic-sine-transform/hst-research-guide.md`](../../archive/maths/rh/research/harmonic-sine-transform/hst-research-guide.md) and the `.tex` papers in the same directory.  
**Inventory:** [Scraps](../../scraps.html) item 17 · [Topic index](../README.md) · duplicate landing page item 27 ([`hst-programme/`](../hst-programme/README.md)).

## What the programme is

The HST programme is an eight-paper attempt to build a Hilbert–Pólya-style spectral theory of the Riemann zeta function out of Victor Geere's greedy harmonic reconstruction of the sine. Its elementary starting point is small and genuine: the harmonic angles

\[
\alpha_n=\frac{\pi}{n+2},\qquad n=0,1,2,\dots
\]

are used both as the step sizes of a greedy expansion of an angle \(\theta\in[0,\pi]\) and as the right-child lengths of a binary tree of cylinder intervals. The tree is then equipped with Haar wavelets and the resulting coefficient map is called the **Harmonic Sine Transform** (HST).

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

with digits in \(\{0,1\}\). These are different algorithms with different digit statistics. The present reconstruction follows the residual-subtraction rule, because it is the rule used for the Haar tree, the threshold angles, and the pilot [greedy harmonic decomposition](../greedy-harmonic-decomposition/README.md). Where the guide and the tree paper disagree, this is recorded below rather than smoothed over.

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
| Split node | a node of length \(\ell\) with \(\alpha_n<\ell\); right child length \(\alpha_n\), left child length \(\ell-\alpha_n\) |
| Haar wavelet (reconstructed) | on a node of length \(L=a+b\), left child \(a\), right child \(b\): \(\psi=-\sqrt{b/(aL)}\,\mathbf 1_L+\sqrt{a/(bL)}\,\mathbf 1_R\) |
| Accumulated mass | \(M_n(\theta)=\sum_{k\le n}\delta_k(\theta)/(k+2)\), so \(A_n=\pi M_n\) |

The source's displayed wavelet (equation (5) of `harmonic-tree-haar.tex`) is

\[
\psi_{\text{source}}=\frac{1}{\sqrt{\alpha_n}}\mathbf 1_{I_{\varepsilon1}}-\frac{1}{\sqrt{\ell(\varepsilon)-\alpha_n}}\mathbf 1_{I_{\varepsilon0}}.
\]

That formula has squared norm \(2\), not \(1\), and its mean is \(\sqrt{\alpha_n}-\sqrt{\ell-\alpha_n}\), which vanishes only when the two children have equal length. The reconstruction uses the correctly normalised zero-mean wavelet above. This repair is proved in Lean and checked exactly in Python.

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
| C1 | Computation | The exact tree scan gives \(\theta_n^*/\pi=1/(n+2)\) for \(n<40\). | `test_threshold_scan_equals_harmonic_angles` |
| C2 | Computation | \(\theta_3^*=\pi/5\); the source's claimed \(5\pi/12\) is not a threshold. | `test_third_threshold_and_source_error` |
| C3 | Computation | \(\delta_1(2\pi/5)=1\) but \(\delta_1(11\pi/20)=0\): the digits are not monotone. | `test_digit_is_not_monotone` |
| C4 | Computation | The reconstructed tree wavelets through depth 6 are orthonormal and mean-zero. | `test_tree_wavelets_are_orthonormal_and_mean_zero` |
| C5 | Computation | The source's displayed wavelet has squared norm \(2\) and mean \(\sqrt b-\sqrt a\). | `test_source_normalisation_defect_and_equal_child_edge_case` |
| C6 | Computation | Selected mass is at most \(\theta\); \(0\le\theta-\pi M_N\le\pi/(N+1)\) on a grid; the sparse selection indices at \(t=99/100\) are \(0,1,5,71\). | `test_cylinder_mass_and_residual_bounds` |
| S* | Source claim | Twelve archived claims (Haar ONB, digit monotonicity, threshold values, density, expansion, continuation, Fredholm determinant, trace class, Weil formula, Hilbert–Pólya, GRH, MTC correspondence), each with its archived status. | source-claims table below |
| O* | Open / conjecture | Seven unresolved items (Haar completeness, expansion convergence, digit statistics, digit-set structure, transfer operator, explicit formula, Hilbert–Pólya/GRH). | open-items table below |

Two supporting tests cover the exact angle sequence and the endpoint \(t=0\) / invalid-input edge cases: `test_alpha_sequence_is_exact_and_strictly_decreasing` and `test_greedy_digits_exact_and_edge_cases`.

The crucial structural point is T5. It does **not** say that \(\theta\mapsto\delta_n(\theta)\) is a step function; C3 shows that it is not. The source's equation (3) asserts the step-function characterisation, and that assertion is false for the source's own equation (1). T5 is the weaker true statement that survives: the infimum of the selection set is exactly \(\alpha_n\).

## Source claims (not promoted to theorems)

These are recorded with the archive's status. None of them is used as a theorem of this reconstruction.

| Claim | Kind | Source status | Reconstruction note |
|---|---|---|---|
| The Haar system \(\mathcal B\) is an orthonormal basis of \(L^2[0,\pi]\). | Source claim | Source Theorem 2.1, proof sketch | Not formalised. The displayed normalisation is defective (C5); the repaired wavelets are individually orthonormal (T6, T7, C4), but completeness is open. |
| \(\theta\mapsto\delta_n(\theta)\) is non-decreasing, so \(\delta_n\) is the step function at \(\theta_n^*\). | Source claim | Source equation (3) and the surrounding observation | **Refuted** for the residual-subtraction rule by C3. Only the least-threshold statement T5 holds. |
| \(\theta_0^*=\pi/2,\ \theta_1^*=\pi/3,\ \theta_2^*=\pi/6,\ \theta_3^*=5\pi/12\). | Source claim | Source table after equation (4) | **Contradicted** by C1/C2: the correct values are \(\pi/2,\pi/3,\pi/4,\pi/5\). The listed \(\pi/6\) is \(\theta_4^*\); \(5\pi/12\) is not a threshold. |
| Selection density \(D(N,\theta)=\sum_{n\le N}\delta_n(\theta)=(\theta/\pi)\log(N+2)+O(1)\). | Source claim | Source Lemma 3.3, asserted | Not used. Exact computation shows that under the residual-subtraction rule selections are extremely sparse (at \(t=99/100\): indices \(0,1,5,71,9016,\dots\)). Under the guide's floor recursion the digits form a different sequence entirely, and the stated logarithmic law is not established anywhere in the corpus. The density law is an archived claim, not a theorem. |
| \(\theta/\pi=\sum_{n\ge0}\delta_n(\theta)/(n+2)\). | Source claim | Source equation (2), stated as a theorem for a.e. \(\theta\) | Not formalised. T3 gives bounded partial sums; convergence and the a.e. statement are open. The observed convergence is extremely slow. |
| \(s\mapsto\Phi(\theta,s)=\sum_n\delta_n(\theta)/(n+2)^s\) continues meromorphically, with a simple pole at \(s=1\) of residue \(\theta/\pi\) and further poles at the non-trivial zeros of \(\zeta\). | Source claim | Source Theorem 2.2, proof sketch | Not formalised; proof sketch invokes a transfer operator that is never constructed. |
| \(\det_{(1)}(I-\mathcal L_s)=\zeta(s)/\zeta(2s)e^{P(s)}\), and zeros of \(\zeta\) are eigenvalue-1 parameters of \(\mathcal L_s\). | Source claim | Source Problem P1; later `hst-further-research-results.tex` presents it as a theorem | Archived claim. The later "proof" rests on an unproved intertwining Lemma with the Gauss transfer operator. Not formalised; no Lean statement. |
| \(\mathcal L_s\) is trace-class for \(\operatorname{Re}s>1/2\) (P3). | Source claim | Source claim, later presented as a theorem | Archived claim; the singular-value estimates are asserted, not proved. |
| Weil-type explicit formula for HST coefficients. | Source claim | Source Theorem 2.3, sketch | Archived claim; the weights \(W_f(n)\) are not constructed. |
| \(H(t)=e^{i\pi/4}K(1/2+it)e^{-i\pi/4}\) is self-adjoint and eigenvalue \(1\) occurs exactly at Riemann zeros; spectral flow proves Hilbert–Pólya. | Source claim | Source Section 5 and P8–P10, speculative | Archived claim. P9 is explicitly left open in `hst-further-research-results.tex`; the programme's own significance paper says it does not prove RH. |
| The Programme IIX paper proves the Generalised Riemann Hypothesis via HST and greedy decomposition. | Source claim | Archived GRH claim (`archive/maths/latex/proof.tex`, not this folder) | **Not a theorem.** No step of the GRH argument is formalised here; the finite core below has no bearing on GRH. Recorded as an archived claim. |
| Greedy–MTC correspondence: a bijection exists (guide P6) versus no such bijection exists (`hst-further-research-results.tex` Theorem P6). | Source claim | Source claims, mutually inconsistent | Unresolved corpus contradiction. Neither direction is formalised. |

## Python layer

[`python/programme.py`](python/programme.py) is importable without side effects and uses exact `Fraction`/sympy arithmetic. It provides:

- `alpha(n)`, `alpha_scaled(n)` — the harmonic angle and its \(\pi\)-normalised value;
- `greedy_digits(t, n_max)`, `greedy_accumulated`, `residual` — the exact digit recursion;
- `tree_intervals(n_max)`, `thresholds_exact(n_max)` — exact cylinder scan and thresholds;
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

Recorded result: **8 passed** in about 5 seconds. The tests include the endpoint/edge cases \(t=0\) and invalid \(t\notin[0,1]\).

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib, works in namespace `HST`, and proves T1–T7. It defines the harmonic angle, the residual-subtraction accumulator, the digit, and the two Haar coefficients. There is no `sorry`, `axiom`, or `admit`.

```bash
./lean/check.sh
```

The wrapper calls the shared checker at [`../tools/check-lean.sh`](../tools/check-lean.sh), which uses the local Mathlib installation (`~/lean/mathlib4`, Lean `v4.35.0-rc2`). The recorded build is [`lean/BUILD.log`](lean/BUILD.log). See [`lean/README.md`](lean/README.md) for what is and is not formalised.

## Open items and gaps

Each row is an **Open / conjecture** item: a precise unresolved statement, not a theorem of this reconstruction.

| # | Kind | Statement | Why it is open |
|---|---|---|---|
| O1 | Open / conjecture | The repaired Haar system \(\mathcal B\) is complete in \(L^2[0,\pi]\). | T6/T7 and C4 prove individual normalisation, zero mean, and orthogonality; they do not prove that \(\mathcal B\) spans \(L^2[0,\pi]\). Until then the HST's "isometric isomorphism" is a source claim. |
| O2 | Open / conjecture | \(\pi M_N(\theta)\to\theta\) for every \(\theta\in[0,\pi]\), with the a.e. statement of source equation (2). | T3 bounds partial sums by \(\theta\); convergence and the a.e. statement are not formalised. Exact computation suggests the convergence is far slower than the source's density lemma implies. |
| O3 | Open / conjecture | A correct asymptotic law for the digit count \(D(N,\theta)\). | The source's logarithmic law is contradicted by exact computation at moderate \(N\) under residual subtraction: at \(t=99/100\) there are only four selections below \(N=200\), while \((\theta/\pi)\log(N+2)\) is already about \(5.3\). C1–C3 suggest a much sparser, roughly squared-index selection pattern. The guide's floor recursion is a different expansion and must be analysed separately. |
| O4 | Open / conjecture | Describe the digit sets \(\{\theta:\delta_n(\theta)=1\}\) as a finite union of cylinders and relate later digits to the threshold. | C3 shows the set is not an interval, so the source's step-function picture cannot be repaired by a monotonicity argument. |
| O5 | Open / conjecture | Construct the transfer operator \(\mathcal L_s\), prove trace-classness for \(\operatorname{Re}s>1/2\), and prove \(\det(I-\mathcal L_s)=\zeta(s)/\zeta(2s)e^{P(s)}\). | The archived claims rest on an unproved intertwining with the Gauss transfer operator and asserted singular-value estimates. Formalising even the operator definition would be a substantial project. |
| O6 | Open / conjecture | Prove the meromorphic continuation and residues of \(\Phi(\theta,s)\), and the Weil-type explicit formula with explicit weights \(W_f(n)\). | Source claims with proof sketches only; no weights are constructed. |
| O7 | Open / conjecture | Construct a self-adjoint Hilbert–Pólya operator whose spectrum is the non-trivial zeros; decide the GRH route. | The self-adjoint family, spectral flow, finite-dimensional approximations, and the GRH paper are speculative or archived claims. Nothing in this reconstruction proves, or is evidence for, RH or GRH. |

## Verification

```bash
cd the-final-letter/topics/harmonic-sine-transform
python3 -m pytest -q tests
./lean/check.sh 2>&1 | tee lean/BUILD.log
```

A topic is complete when both commands pass and this ledger agrees with the files.

## Links

- [Scraps inventory](../../scraps.html) — item 17 (and duplicate item 27)
- [Topic index](../README.md)
- [Greedy harmonic decomposition](../greedy-harmonic-decomposition/README.md) — the completed pilot for the same angle sequence
- [The Final Letter](../../index.html)

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
