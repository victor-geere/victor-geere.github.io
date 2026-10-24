# Theorem B

| Field | Value |
|---|---|
| Type | Theorem |
| Status | Proved (counterexample) |
| Source | [`tensor.md`](../../geometric-dynamical-phase-transitions/tensor.md), §2–7 |

## Statement and proof

Let \(\gamma_1=14.134725141734693\ldots\) be the first zero ordinate and take the real even test function
\[
f_0(u)=\frac{2}{\sqrt\pi}\,e^{-u^2}\cos(\gamma_1u),\qquad
\hat f_0(t)=e^{-(t-\gamma_1)^2/4}+e^{-(t+\gamma_1)^2/4},
\]
which lies in \(\mathcal{W}_\delta\) for every \(\delta\). Then \(g_0:=f_0*\check f_0=f_0*f_0\) has the closed form
\[
g_0(v)=\sqrt{\tfrac{2}{\pi}}\;e^{-v^2/2}\Bigl(\cos(\gamma_1v)+e^{-\gamma_1^2/2}\Bigr),
\]
and
\[
\bigl\langle\mathcal{P},f_0*\check f_0\bigr\rangle
=\Pi(g_0)+\Theta(g_0)
=-0.67764514730\ldots+0.00034266918\ldots
=\;-0.67730247811\ldots\;<\;0 .
\]
Hence \((\star)\) fails, and with it the positive-semidefiniteness claim for \(K(u,v)=\mathcal{P}(u-v)\) in tensor.html §4.

*Proof.* The closed form of \(g_0\) is Gaussian algebra (checked to \(10^{-26}\) against direct convolution). Both terms are then evaluated directly, with no zero data and no explicit formula:
\(\Pi(g_0)\) is an absolutely convergent prime-power sum whose tail beyond \(n=6\times10^4\) is bounded by
\(\sum_{n>X}\Lambda(n)n^{-1/2}e^{-(\log n)^2/2}<10^{-22}\); \(\Theta(g_0)\) is an integral of the doubly-exponentially decaying \(\Phi\,g_0\), computed two independent ways (directly, and by Lemma 2.2's Parseval), agreeing to all 25 digits. The margin \(0.677\) exceeds the total numerical uncertainty by more than twenty orders of magnitude. \(\square\)

The structural reading comes from Theorem A, which reproduces the same number with residual \(6\times10^{-25}\):

| term | value |
|---|---|
| pole \(\ \lvert\hat f_0(i/2)\rvert^2=4\cos^2(\gamma_1/4)\,e^{-(\gamma_1^2-1/4)/2}\) | \(+1.6\times10^{-43}\) |
| atoms \(\ -\tfrac12\sum_\rho\hat g_0(\gamma_\rho)\) | \(-1.00000000005\ldots\) |
| density \(\ \frac1{2\pi}\int\lvert\hat f_0\rvert^2W\) | \(+0.32269752193\ldots\) |
| **total (Theorem A)** | \(-0.67730247812\ldots\) |
| **total (direct: \(\Pi(g_0)+\Theta(g_0)\))** | \(-0.67730247812\ldots\) |

The test function is a unit bump of \(\lvert\hat f_0\rvert^2\) at the *first on-line zero*; the \(-1\) is that zero's atom (the visible \(5\times10^{-11}\) excess is \(\gamma_2\)'s tail); the pole term is dead because \(\hat f_0\) is microscopic at \(\pm i/2\); the density term recovers only a third of the loss, and \(\Theta\)'s share of it is \(3.4\times10^{-4}\) — the Jacobi density is spectrally empty at \(\gamma_1\) because \(\Xi_{\cos}(\gamma_1)=0\).
