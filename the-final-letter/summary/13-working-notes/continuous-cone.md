# Continuous-cone working note — claim inventory

**Source:** [`maths/continuous_cone_RH_solution.md`](../../geometric-dynamical-phase-transitions/maths/continuous_cone_RH_solution.md) and [`maths/continuous_cone_RH_solution.html`](../../geometric-dynamical-phase-transitions/maths/continuous_cone_RH_solution.html).
**Verdict:** the definitions and regularity lemma are consistent with the canonical paper; the local quadratic form is **wrong**; the differential inequality and the final RH claim are **not established**.

## Claims and status

| # | Claim | Status |
|---|---|---|
| Definition 1.1 | Continuous mean-zero filter $c_m(R)=1-R\sum_k\varphi(m/R-k)$, $\eta_R(R^2)(s)=\sum_{m\le R^2}c_m(R)m^{-s}$. | Definition; consistent with canonical Definition 2.3. |
| Definition 1.2 | Residual function $\rho(R,s)=\lvert\eta_R(R^2)(s)\rvert$. | Definition. |
| Lemma 1.3 | $R\mapsto\rho(R,s)$ is $C^1$; differentiation under the sum justified by $R^{1-\sigma}\log R$. | Correct; cf. canonical Lemma 6.1. |
| Lemma 2.1 | Local quadratic form with constant $\tfrac12$: $\operatorname{Re}(\overline{\eta^{(k)}}A^{(k)})=\tfrac12R^{-1}\lvert\eta^{(k)}\rvert^2+O(\cdots)$. | **Invalid.** It relies on $\int(1-R\varphi)(-\varphi)\,du=-\tfrac12$, which is false; the integral is $-1+R\int\varphi^2$. Canonical Lemma 6.3 gives the correct diagonal and says it is not a multiple of $R^{-1}\rho^2$. |
| Theorem 2.2 | Differential inequality $\partial_R\rho\le -cR^{-1/2}\rho+O(R^{1/2-\delta}(1+\lvert\gamma\rvert)^\varepsilon)$. | **Not established.** The proof sums the invalid Lemma 2.1. The canonical paper explicitly does not use this inequality. |
| Definition 3.1 | Continuous residual measure $\mu_R(dt)=\rho(R,1/2+it)(1+t^2)^{-1}dt$. | Definition. |
| Lemma 3.2 | $\lVert\mu_R\rVert=O(R^{-1})$ uniformly. | Unsupported as stated. The proof uses the mean-square integral $O(R)$ and then asserts a dyadic improvement to $O(R^{-1})$; the canonical paper obtains the factor $1/N$ by a different argument (residual density with $1/N$). |
| Theorem 3.3 | The family $\{\mu_R\}$ is tight. | Would follow from a correct uniform mass bound; not established here. Canonical tightness is Theorem 9.1, proved by Lemmas 9.2–9.6. |
| Lemma 3.4 | Tails $\mu_R(\lvert t\rvert>R^\alpha)=O(R^{-\alpha/2})$. | Unsupported; the proof uses the same mass bound and a second-moment estimate. |
| Theorem 4.1 | Off-line lower bound $\rho(R,s)\gg R^{\lvert1-2\sigma\rvert/2-\varepsilon}$. | No proof is given. The heuristic exponential factor is plausible, but the statement is not derived. |
| Theorem 5.1 | “Geometric realisation of the Riemann hypothesis”: power-saving depth bound, pure-point limit supported exactly on critical-line zeros, hence every zero has $\operatorname{Re}s=\tfrac12$. | **Not accepted.** It inherits the invalid differential inequality and the over-strong support claim. The canonical paper’s Corollary 12.3 is an equivalence, not a proof; right-half zeros remain unrestricted atoms. |

## The exact failure

The note’s proof of Lemma 2.1 reads, in part:

> the constant $1/2$ arises from $\int_{-1}^{1}(1-R\varphi(u))(-\varphi(u))\,du=-\frac12+O(R^{-1})$.

The canonical paper’s Lemma 6.3 evaluates the same integral:

$$
\int_{-1}^{1}(1-R\varphi(u))(-\varphi(u))\,du
=-1+R\int_{-1}^{1}\varphi(u)^2\,du.
$$

The claimed $-\tfrac12$ is not the local diagonal. Without the negative constant, the differential inequality has no drift term and the integrating-factor argument collapses.

## What to read instead

- [Lemma 6.3 (Local diagonal)](../04-continuous-radius-and-mean-values/03-lemma-6.3.md) — the correct evaluation.
- [Theorem 4.1 (Explicit remainder)](../02-exact-filter-and-remainder/04-theorem-4.1.md) — the depth bound actually used.
- [Theorem 9.1 (Tightness)](../05-spectral-measures-and-tightness/08-theorem-9.1.md) — unconditional tightness.
- [Corollary 12.3 (Conversion)](../05-spectral-measures-and-tightness/13-corollary-12.3.md) — the correct conclusion.

[Back to folder README](README.md) · [Back to the summary index](../README.md)
