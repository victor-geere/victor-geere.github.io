# Publication Addendum A — quantum algorithms in geometric language

> **Not to be confused with** [`publication-addendum-A.html`](publication-addendum-A.html), the refined-remainder addendum summarised in [folder 12](summary/12-open-problems/addendum-a-refined-theorem.md). This file is Addendum A *inside* `publication.html` (§A.1–A.3).

| Field | Value |
|---|---|
| Type | Dictionary / placement |
| Status | Explanatory; no new theorem |
| Source | [`publication.html` §A](publication.html#adda) |

## The three correspondences

### A.1 DQPT systems as coherent polygonal paths

In the Wei et al. systems the logarithmic Hamiltonian $\mathcal{H}_0=\sum_n(\log n)\lvert n\rangle\langle n\rvert$ generates a Loschmidt amplitude

$$
\mathcal{L}(\beta,t)=\sum_n e^{-\beta\log n}e^{-it\log n}=\sum_n n^{-\beta-it}.
$$

At $\beta=\tfrac12$ this is a Dirichlet series on the critical line. The dictionary is:

- vanishing of the Loschmidt amplitude ↔ a path-closure event of controlled depth for the polygon;
- critical temperature $\beta=\tfrac12$ ↔ the quadratic geometric scaling $M=N^2$;
- discrete DQPT times ↔ the support of the pure-point measure built from path-closure ordinates.

### A.2 Quantum evaluation of exponential sums

A quantum algorithm estimating $S(f,w,N)=\sum_k w_k e^{2\pi i f(k)}$ by amplitude estimation (Tyagi) evaluates the Dirichlet polynomials of the polygon for $f(k)=-(t/2\pi)\log k$. In geometric language it computes the endpoint length, or decides whether it falls below $N^{1/2-\varepsilon}$, with a quadratic improvement in the precision parameter. The path-closure definition, isolation, measures, and weak-star analysis remain classical; the quantum routine is a computational acceleration, not a change of mathematical content.

### A.3 Unified dictionary

| Quantum object | Analytic / geometric counterpart |
|---|---|
| Loschmidt amplitude / accumulated phase | endpoint $\eta_N^{(N^2)}(\tfrac12+it)$ |
| DQPT (vanishing amplitude) | path-closure of depth $N^{1/2-\varepsilon}$ |
| critical temperature $\beta=\tfrac12$ | quadratic scaling $M=N^2$ |
| quantum simulation of the DQPT system | unitary realisation of the same cancellations |
| quantum exponential-sum algorithm | accelerated evaluation of the polygonal endpoint |
| discrete DQPT times | support of the pure-point measure $\mu$ |

## Status

This is a dictionary, not a theorem. The source says the quantum routine “does not alter the geometric or measure-theoretic content of the construction.” Addendum F later sharpens the placement: Lemma F.1 identifies the averaged accumulated phase factor with the period-two polygon, and Proposition F.2 reads the three scales as free-energy densities. Nothing in Sections 1–14 depends on this dictionary.

[Back to folder README](summary/09-quantum-placements/README.md) · [Back to the summary index](summary/README.md)
