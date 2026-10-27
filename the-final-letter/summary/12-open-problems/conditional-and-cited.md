# Conditional and cited results

This file separates three things that are easy to conflate in a large paper: results proved here, results cited from the literature, and results that depend on an explicit hypothesis or numerical constant.

## Conditional on a named hypothesis

| Result | Hypothesis | What is unconditional |
|---|---|---|
| Refined Theorem 4.1 (Addendum A) | Bourgain’s subconvexity constant fixed explicitly; van der Corput order 1; stationary-phase expansion to order two | The Euler–Maclaurin Theorem 4.1 is unconditional. Addendum A is an optional refinement. |
| Refined remainder (Addendum B) | Bourgain $\mu(1/2)=13/84$ and a van der Corput estimate on dual tails, with explicit constant | Not needed for Theorems 9.1–12.2. |
| Corollary C.14 | Hypothesis (M): no zeros in $\sigma>1$ | Corollary C.10 (the limitative result) is unconditional without (M). |
| Corollary E.8 | Rouché condition (E.1) on each contour | Theorem E.7 is proved from (E.1); the equivalence is unconditional, the computation is not. |
| Corollary F.9 | Bourgain $13/84$ for $\varepsilon>13/194$ | Under Lindelöf every $\varepsilon>0$; isolation stays per zero. |
| Uniform slow passage | $\lvert\zeta'(\rho)\rvert\le N^{\varepsilon}$ on the window | Conjectural; not used by any theorem. |

## Cited classical results

| Result used | Citation | Where |
|---|---|---|
| Euler–Maclaurin with explicit remainder | Titchmarsh, *The Theory of the Riemann Zeta-Function*, §4.11; Montgomery–Vaughan, Theorem 1.12 | Theorem 4.1, Theorem 4.3 |
| Montgomery–Vaughan Hilbert inequality | Montgomery–Vaughan (1974) | Theorem 7.1 |
| Gallagher/Sobolev | Gallagher; standard | Lemma 7.3 |
| Riemann–von Mangoldt zero count | classical | Corollary 4.1.2, Lemma 9.2 |
| Titchmarsh classical floor for $\zeta$ | Titchmarsh §9.6 | Lemma 9.4 |
| Rouché / argument principle | Ahlfors, *Complex Analysis* | Lemma 5.5, Theorem E.4, Theorem E.7 |
| Weil explicit formula | Weil (1952); Bombieri (2000) | `tensor.md` Lemma 2.4 |
| Saias–Weingartner dichotomy | Saias–Weingartner | Theorem C.12 |
| Bourgain subconvexity | Bourgain, *J. Amer. Math. Soc.* 30 (2017) | Addenda A/B, Corollary F.9 |
| de Bruijn–Newman and Rodgers–Tao | de Bruijn (1950); Newman (1976); Rodgers–Tao (2020); Polymath15 | Frozen truths §15; Addendum F |
| Selberg trace formula / spectral determinant | Selberg | Addendum F |
| Bombieri–Hejjal, Montgomery, Gonek–Ledoan | cited in Addendum F | Open item F.4, Remark F.13 |

## Numerical verification

| Script | What it checks |
|---|---|
| [`geometric_dqpt_test.py`](../../geometric-dynamical-phase-transitions/geometric_dqpt_test.py) | Path closures, depth scans, the three-scale comparison. |
| [`quantum_fisher_zeros_test.py`](../../geometric-dynamical-phase-transitions/quantum_fisher_zeros_test.py) | Fisher zeros of $\eta_N^{(N^2)}$ for $N\le20$; clock zeros; Landau–Gonek ingredients; the DH holonomy. |
| `tensor.md` §9 | Theorems A and B, the normalisation $\hat\Phi=\Xi/2$, the tilt identities, and the failure of positive type, at 25 significant digits. |

Numerics support the exact identities; they do not replace a proof of the open statement.

## What is *not* conditional

The following are unconditional and do not depend on (M), (E.1), Bourgain, or GUE:

- The exact identity and the Euler–Maclaurin comparison (Theorem 4.1/4.3).
- The speed bound Identity L / Lemma 4.5.2.
- Tightness and the limit theorems (Theorems 9.1, 10.1, 11.1, 12.1, 12.2).
- The conversion Corollary 12.3.
- The Davenport–Heilbronn sharpness (Theorems C.7–C.9, Corollary C.10).
- The modular shadow (Addendum D).
- The straightening field identities (Addendum E), conditional only on (E.1) for the finite-data computation.

[Back to folder README](README.md) · [Back to the summary index](../README.md)
