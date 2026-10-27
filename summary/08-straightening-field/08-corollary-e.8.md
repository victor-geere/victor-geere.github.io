# Corollary E.8 (Finite-data form of the Riemann hypothesis)

| Field | Value |
|---|---|
| Type | Corollary |
| Status | Proved equivalence, conditional on (E.1) for computation |
| Source | [publication.html Addendum E](publication.html#adde) · Addendum E. The straightening field: rays, holonomy, and finite-data zero detection |
| Proof in source | yes |

> **Editorial note.** A finite-data form of RH: it is an equivalence, not a construction of a contour known to enclose a zero.

## Statement

The Riemann hypothesis holds if and only if for every \(\sigma_0\in(\tfrac12,1)\) and every rectifiable closed \(\Gamma\) as in Theorem E.7 contained in \(\{\sigma>\tfrac12\}\), \[
\operatorname{hol}\bigl(\eta_N^{(N^2)},\Gamma\bigr)-\operatorname{hol}\bigl(1-N^{1-s},\Gamma\bigr)-n(\Gamma,0)\;=\;0
\] for all \(N\) satisfying (E.1). Every quantity on the left is a finite sum of powers of integers.

## Proof

Immediate from Theorem E.7 and Corollary E.5: a nonzero value certifies a zero of \(\zeta\) inside \(\Gamma\subset\{\sigma>\tfrac12\}\), and conversely any such zero is enclosed by some admissible \(\Gamma\), for which (E.1) then holds for all large \(N\) because \(m_\Gamma(N)\gg N^{1-\sigma_0}\) while the error is \(O(N^{1-2\sigma_0})\).
