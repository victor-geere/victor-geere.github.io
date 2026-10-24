# Theorem C

| Field | Value |
|---|---|
| Type | Theorem |
| Status | Proved (classical equivalence) |
| Source | [`tensor.md`](../../geometric-dynamical-phase-transitions/tensor.md), §2–7 |

## Statement and proof

1. (*Identity.*) For every \(g\) in the cone, \(\displaystyle\langle\mathcal{W},g\rangle=\sum_{\rho}\hat g(\gamma_\rho)\). In particular \(\langle\mathcal{W},f*\check f\rangle=\sum_\rho\hat f(\gamma_\rho)\overline{\hat f(\bar\gamma_\rho)}\).
2. (*RH \(\Rightarrow\) positivity.*) If all \(\gamma_\rho\) are real, \(\langle\mathcal{W},f*\check f\rangle=\sum_\rho\lvert\hat f(\gamma_\rho)\rvert^2\ge0\) for every \(f\) in the cone.
3. (*Positivity \(\Rightarrow\) RH; Weil.*) Conversely, if \(\langle\mathcal{W},f*\check f\rangle\ge0\) for all \(f\) in the cone, every zero is on the line.

*Proof.* (1) is Lemma 2.4 rearranged, using \(2\int g\cosh\tfrac u2=\hat g(i/2)+\hat g(-i/2)\). (2) is Lemma 2.1 on the real axis. (3) is classical (Weil 1952; Bombieri 2000). Sketch, for completeness: suppose \(\gamma_0=\beta+i\theta\), \(\theta\neq0\); then \(\beta\neq0\) (\(\xi\) has no real zeros in \([0,1]\)). Take \(f\) real, even, \(\hat f\) a narrow Gaussian pair at \(\pm\beta\) — narrow enough that only the quadruple \(\{\pm\gamma_0,\pm\bar\gamma_0\}\) of maximal \(\lvert\theta\rvert\) within the window matters exponentially — and modulate: \(f_c(u)=f(u-c)+f(u+c)\), so \(\hat f_c(z)=2\hat f(z)\cos(cz)\) and
\(\hat g_c(\gamma_0)=4\hat f(\gamma_0)^2\cos^2(c\gamma_0)\). The quadruple contributes \(\asymp e^{2\theta c}\bigl(\cos(2c\beta-\varphi)+o(1)\bigr)\cdot\lvert\hat f(\gamma_0)\rvert^2\) for a fixed phase \(\varphi\), while all real zeros contribute \(O(1)\) uniformly in \(c\) (\(\lvert\cos(c\gamma)\rvert\le1\) for real \(\gamma\)). Choosing \(c\to\infty\) with \(\cos(2c\beta-\varphi)\le-\tfrac12\) drives the form to \(-\infty\). \(\square\)
