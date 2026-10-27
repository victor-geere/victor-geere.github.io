# Equivalent forms of the Riemann hypothesis

This is an index of the reformulations used across the site. Each is an equivalence, not a proof. The value of the list is diagnostic: it shows that the programme’s gap is the same object seen in analysis, geometry, measure theory, and arithmetic positivity.

## Classical equivalences

From [`truths.md`](../../geometric-dynamical-phase-transitions/truths.md) 12.6, with the standard citations:

1. Every non-trivial zero of $\zeta$ has real part $\tfrac12$.
2. $\Xi_{\cos}$ has only real zeros.
3. $\Xi_{\cos}$ lies in the Laguerre–Pólya class.
4. Weil positivity: the explicit-formula pairing $W(h)\ge0$ for the Weil class of test functions.
5. de Bruijn–Newman: $\Lambda\le0$. Combined with Rodgers–Tao $\Lambda\ge0$, this is $\Lambda=0$.
6. Speiser: $\zeta'$ has no zero in $0<\operatorname{Re}s<\tfrac12$.
7. In the language of the paper, after Lemma 4.8: $\operatorname{supp}\nu=\operatorname{supp}\mu$, equivalently $\nu$ has no atom with real part greater than $\tfrac12$.

## Programme-specific forms

| Form | Statement | Source |
|---|---|---|
| Support equality | $\operatorname{supp}\mu=\operatorname{supp}\nu$ | Corollary 12.3; [`publication.html`](../../geometric-dynamical-phase-transitions/publication.html) §12 |
| No right-half atom | $\nu$ has no atom with $\sigma>\tfrac12$ | Corollary 12.3 and Lemma 4.8 |
| Last-chord dichotomy | At an off-line zero, one twin’s residual tends to $0$ and the other to $\infty$; both stay of order one iff $\sigma=\tfrac12$ | Frozen truths 11.5–11.6 |
| Cosine moment | $K(\alpha,\gamma)=S(\alpha,\gamma)=0$ has no solution with $\alpha\neq0$ | `tensor.md` Corollary 6.2 |
| Weil current | $\langle\mathcal{W},f*\check f\rangle\ge0$ for every $f$ in the Weil cone | `tensor.md` Theorem C |
| Straightening flatness | The straightening field is flat on $\{\tfrac12<\sigma<1\}$ | Corollary E.5 |
| Finite-data holonomy | Every admissible contour in $\{\sigma>\tfrac12\}$ has zero holonomy | Corollary E.8 |
| Modular/arithmetic | A single Euler product, i.e. hypothesis (M) plus the conversion | Corollary C.14 and Remark C.15 |

## The logical relations

- **Corollary 12.3** is the paper’s central conversion. It uses Marty speed (Lemma 4.8) to remove the left half-strip from both families; a right-half zero remains an unrestricted atom. RH is the absence of such an atom.
- **Theorem C** is the classical Weil criterion, recovered on $\mathbb{R}$ after refuting the naive current $\mathcal{P}$. It is not a new proof; it is the correct form of the positivity idea.
- **Corollary E.5** is a restatement of the argument principle in straightening coordinates. It has no Euler-product input, so it cannot by itself close the gap; the finite-data version E.8 is an equivalence, not a construction of a contour known to enclose a zero.
- **The cosine/Jensen/Li forms** locate the gap at $t=0$ (moments) or $s=1$ (Li jet). They are the most analytic forms, and the ones where the de Bruijn–Newman bound $0\le\Lambda\le0.22$ lives.

## What none of them does

None supplies the missing positivity. Each is a coordinate system in which the same open statement is visible. The paper’s contribution is to prove that the coordinates are equivalent and to identify the Davenport–Heilbronn twist as the counterexample that rules out any purely additive proof.

[Back to folder README](README.md) · [Back to the summary index](../README.md)
