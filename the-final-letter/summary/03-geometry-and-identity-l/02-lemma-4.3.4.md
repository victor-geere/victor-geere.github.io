# Lemma 4.3.4 (Hilbert zoom; the envelope scale)

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [publication.html §4](../../geometric-dynamical-phase-transitions/publication.html#sec4) · 4. Quadratic scaling and the explicit remainder |
| Proof in source | yes |

## Statement

The nested completed curves of Lemma 4.3.3, with fibre radii scaled by successive factors \(N^{-1}\) and outer length \(M=N^2\), form a self-similar approximating sequence in the same sense as the dyadic polygonal approximations to a Hilbert curve: granularity \(N^{-1}\) tends to zero, and the parameter interval on which the approximations are packed is the tightness window \(\lvert t\rvert\le N^{1/2-\varepsilon}\), playing the role of the unit interval. The unique rescaling that keeps the \(\sigma=\tfrac12\) pictures in a compact family is division by the DQPT depth \(D_N=N^{1/2-\varepsilon}\). Write \[
\widetilde{\gamma}_{N,\sigma}(t)=D_N^{-1}\gamma_{N,\sigma}(t),\qquad \lvert t\rvert\le N^{1/2-\varepsilon}.
\] A point of the window is an *envelope collapse* of this zoom when \(\widetilde{\gamma}_{N,\sigma}(t)\to 0\) as \(N\to\infty\). Corollary 4.3.1 says every off-line zero in the band \(\sigma>\tfrac14+\varepsilon/2\) is an envelope collapse: the last chord has Euclidean size \(N^{1-2\sigma}=o(D_N)\). The fractal therefore does *not* force \(\lvert\eta\rvert\ge c\,D_N\) off the line — that comparison is the envelope of \(C_1(1+\lvert t\rvert)\) over the whole window, too coarse at a single height. What the nested curves do detect is the speed of the cancellation that produces the collapse (Lemma 4.5.2).

## Proof

The quadratic link \(M=N^2\) at \(\sigma=\tfrac12\) makes the prefactor \(P_N\asymp N^{1/2}\) and the Euler–Maclaurin remainder \(O(1+\lvert t\rvert)\). Dividing by \(D_N=N^{1/2-\varepsilon}\) is the only power of \(N\) for which both the typical path (size \(P_N\lvert\zeta\rvert\)) and the isolation scale \(N^{-\kappa}\) stay bounded, up to \(N^{\pm\varepsilon}\), on the window of Theorem 9.1. Nested fibres of radius \(\asymp N^{-1}\) are the analogue of Hilbert cells of side \(2^{-n}\): each stage refines the previous by a linear factor \(N\), while the quadratic link \(M=N^2\) is the analogue of the fact that a Hilbert cell at level \(n\) is traversed by a curve of length \(2^n\). The zoomed modulus is \(\lvert\eta\rvert/D_N\) up to \(O(N^{-1}/D_N)\to 0\), so envelope non-collapse of \(\widetilde{\gamma}_{N,\sigma}(\gamma)\) would be \(\lvert\eta(\sigma+i\gamma)\rvert\ge c D_N\). The Euler–Maclaurin size of \(\eta\) at an off-line zero is not altered by the rescaling. That envelope comparison is therefore false at any such zero (Corollary 4.3.1). The quantity that does not collapse is the speed of the last-chord cancellation, Lemma 4.5.2.
