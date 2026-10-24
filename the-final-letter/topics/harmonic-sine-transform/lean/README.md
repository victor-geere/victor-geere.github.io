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
- `HST.haarL a b L`, `HST.haarR a b L` — the left/right coefficients of the repaired zero-mean Haar wavelet on a node with child lengths \(a,b\) and total length \(L=a+b\).

It proves seven theorems, all with complete proofs:

| Name | Statement |
|---|---|
| `alpha_pos` | \(0<\alpha_n\) |
| `alpha_strictAnti` | \(n\mapsto\alpha_n\) is strictly decreasing |
| `accum_le_self` | for \(\theta\ge0\), the accumulated angle never exceeds \(\theta\) |
| `accum_eq_zero_of_lt` | if \(\theta<\alpha_n\) then \(A_n(\theta)=0\) |
| `threshold_isLeast` | \(\alpha_n\) is the least \(\theta\) with \(\delta_n(\theta)=1\) |
| `haar_normSq` | the repaired wavelet has squared norm \(1\) |
| `haar_mean_zero` | the repaired wavelet has zero mean |

The last two are stated for child lengths \(a,b>0\) and \(L=a+b\): the wavelet is
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

No `sorry`, no `axiom`, no `admit`.

## Correction to the source's displayed wavelet

`harmonic-tree-haar.tex` equation (5) uses coefficients \(1/\sqrt{\alpha_n}\) on the right child and \(-1/\sqrt{\ell-\alpha_n}\) on the left. With \(a=\ell-\alpha_n\) (left) and \(b=\alpha_n\) (right) that wavelet has squared norm \(2\), and its mean is \(\sqrt b-\sqrt a\), which vanishes only when \(a=b\). The theorem that \(\mathcal B\) is orthonormal therefore cannot hold as displayed. `Topic.lean` formalises the corrected zero-mean normalisation instead; the Python test `test_source_normalisation_defect_and_equal_child_edge_case` records the defect exactly.

## Correction to the source's threshold claim

The source asserts that \(\theta\mapsto\delta_n(\theta)\) is non-decreasing and that \(\delta_n\) is the step function at \(\theta_n^*\). For the residual-subtraction rule of the source's own equation (1) this is false: at \(t=\theta/\pi=2/5\) the first digit is \(0\) and \(\delta_1=1\), while at \(t=11/20\) the first digit is \(1\) and \(\delta_1=0\). The formal core therefore proves only the true least-threshold statement `threshold_isLeast`, together with the two lemmas that drive it. The Python test `test_digit_is_not_monotone` records the counterexample.

The source's listed threshold values are also wrong for this rule: the least thresholds in \(\pi\)-normalised units are \(1/2,1/3,1/4,1/5,1/6,\dots\), so \(\theta_3^*=\pi/5\), not \(5\pi/12\). This is checked by `test_threshold_scan_equals_harmonic_angles` and `test_third_threshold_and_source_error`.

## What is not formalised

- Completeness of the Haar system \(\mathcal B\) in \(L^2[0,\pi]\), and hence the isometric-isomorphism claim for the HST.
- Convergence of \(\theta/\pi=\sum_n\delta_n(\theta)/(n+2)\), and any digit-density law.
- The transfer operator \(\mathcal L_s\), trace-class estimates, the Fredholm determinant identity \(\det(I-\mathcal L_s)=\zeta(s)/\zeta(2s)e^{P(s)}\), meromorphic continuation of \(\Phi(\theta,s)\), residues, and the Weil-type explicit formula.
- The self-adjoint family \(H(t)\), spectral flow, finite-dimensional approximations, Hilbert–Pólya, and the GRH paper.

These are recorded as source claims or open items in the [programme README](../README.md). None is a Lean theorem here.

[Back to the programme](../README.md) · [Topic index](../../README.md)
