# 01 — Foundations and definitions

This folder contains the objects the whole programme is built from. They are definitions rather than results, but they fix every later comparison: the completed xi-function whose zeros are counted, the mean-zero filter that makes the polygon possible, the tempered measure that makes weak limits meaningful, and the two finite Euler sums whose difference is the polygon.

## What is here

| Item | What it fixes |
|---|---|
| [Definition 2.1 (Completed xi-function)](summary/01-foundations/01-definition-2.1.md) | The entire function $\Xi$ whose zeros are the non-trivial zeros of $\zeta$, including the functional equation and reality/conjugation symmetries. |
| [Definition 2.3 (Continuous mean-zero filter)](summary/01-foundations/02-definition-2.3.md) | The smooth interpolation $c_m(R)=1-R\sum_k\varphi(m/R-k)$ used only to move between integer scales. |
| [Definition 2.4 (Tempered measure)](summary/01-foundations/03-definition-2.4.md) | The topology in which the limiting spectral measures are taken. |
| [Definition 3.0 (Depth-one finite Euler sums)](summary/01-foundations/04-definition-3.0.md) | $H_x^{(s)}=\sum_{n\le x}n^{-s}$: the finite sums that replace a truncation of the infinite Dirichlet series. |
| [Definition 3.1 (Coherent polygonal sum)](summary/01-foundations/05-definition-3.1.md) | The polygon $\eta_N^{(M)}(s)=H_M^{(s)}-N^{1-s}H_{\lfloor M/N\rfloor}^{(s)}$ as a path in $\mathbb{C}$. |

## Why these definitions matter

The construction never truncates the infinite series $\zeta(s)$. It compares two *exact* finite objects at the quadratic link $M=N^2$:

$$
\eta_N^{(N^2)}(s)=H_{N^2}^{(s)}-N^{1-s}H_N^{(s)}
=\sum_{m\le N^2}c_m^{(N)}m^{-s},
\qquad
c_m^{(N)}=\begin{cases}1,&N\nmid m,\\1-N,&N\mid m.\end{cases}
$$

The coefficients carry a mean-zero root-of-unity filter. Their sum is $(1-N^{1-s})\zeta(s)$ for $\operatorname{Re}s>1$, and the factor $1-N^{1-s}$ vanishes only on the line $\operatorname{Re}s=1$. Everything quantitative later is a comparison between $\eta_N^{(N^2)}$ and that factor times $\zeta$.

Two conventions are worth keeping in view:

- The integer $N$ may be even or odd; the filter is not a dyadic construction. Parity independence is recorded in the archived working note but is already visible here.
- The polygon is a *path*, not a partial sum of a convergent series. Its endpoint is the finite object; there is no truncation error to estimate in the definition.

## What is deliberately not here

Classical black boxes (Euler–Maclaurin, Montgomery–Vaughan, Riemann–von Mangoldt, the stereographic chart) are collected in [Frozen truths §1](summary/11-frozen-truths/01-classical-facts-used-as-black-boxes.md). The two working notes in [`maths/`](maths/) introduce a continuous-radius version of the filter; that interpolation is treated in [folder 04](summary/04-continuous-radius-and-mean-values/README.md), and its use in the archived notes is audited in [folder 13](summary/13-working-notes/README.md).

## Reading order

If you are new to the programme, read Definitions 3.0 and 3.1 first, then the exact identity in [Lemma 2.2](summary/02-exact-filter-and-remainder/01-lemma-2.2.md) and the filter form in [Lemma 3.2](summary/02-exact-filter-and-remainder/02-lemma-3.2.md). The remaining definitions can be consulted as needed.

**Status.** All five items are definitions. None asserts a zero of $\zeta$ lies on the critical line.

[Back to the summary index](summary/README.md) · [Folder TOC](summary/01-foundations/TOC.md)
