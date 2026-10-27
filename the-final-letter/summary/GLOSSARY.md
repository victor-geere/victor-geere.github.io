# Glossary

Notation is the paper’s. Where a symbol has a different meaning in an archived programme, both are noted.

## The polygon

| Symbol | Meaning |
|---|---|
| $N$ | Integer scale, $N\ge2$; no parity restriction. |
| $M$ | Truncation length of the polygon; the quadratic link is $M=N^2$. |
| $s$ | Complex weight, $s=\sigma+it$. |
| $H_x^{(s)}$ | Depth-one finite Euler sum $\sum_{n\le x}n^{-s}$. |
| $c_m^{(N)}$ | Mean-zero filter: $1$ if $N\nmid m$, $1-N$ if $N\mid m$. |
| $\eta_N^{(M)}(s)$ | Coherent polygonal sum $H_M^{(s)}-N^{1-s}H_{\lfloor M/N\rfloor}^{(s)}=\sum_{m\le M}c_m^{(N)}m^{-s}$. |
| $\eta$ (bare) | In the greedy/harmonic-sine notes, the Dirichlet eta function; in the canonical paper, always subscripted as the polygon. Check context. |
| $P_N(s)$ | Prefactor $\lvert1-N^{1-s}\rvert$. |
| $F_N(s)$ | Remainder scale $(1+\lvert t\rvert)N^{1-2\sigma}$. |
| $D_N$ | Depth scale $N^{1/2-\varepsilon}$. |
| $H_N(s)$ | Last chord $\tfrac12(1-N)N^{-2s}$. |
| $\Xi$ | Completed xi-function $\tfrac12s(s-1)\pi^{-s/2}\Gamma(s/2)\zeta(s)$; zeros are the non-trivial zeros of $\zeta$. |
| $\Xi_{\cos}(t)$ | $\Xi(\tfrac12+it)$. |
| $\Phi$ | Riemann’s even positive Jacobi density, with $\Xi_{\cos}(t)=4\int_0^\infty\Phi(u)\cos(tu)\,du$. |
| $S_\delta$ | Truncated strip $\{\delta\le\sigma\le1-\delta\}$. |
| $I_k$ | Packet $[(k-1)R,(k+1)R]$ in the continuous-radius interpolation. |

## Closures and measures

| Term | Meaning |
|---|---|
| Path-closure | A near-return of the polygon to the origin at some height. |
| Depth | The size threshold of the closure; depth $N^{1/2-\varepsilon}$ means $\lvert\eta\rvert\le N^{1/2-\varepsilon}$. |
| Relative depth | $\lvert\eta(s)\rvert\le\lvert1-N^{1-s}\rvert N^{-\varepsilon}$; used for unrestricted closures. |
| Balanced closure | Relatively small, slow ($\lvert\partial_t\eta\rvert\le N^{1/2+\varepsilon}$), and with prefactor $\ge N^{1/2-\varepsilon/2}$. Confined to $\sigma\le\tfrac12+\varepsilon/2$. |
| Unrestricted closure | A closure relative to the main-term scale, without the slowness/balance conditions; can occur in the right half-strip. |
| $\mu_N$ | Balanced finite measure on the strip. |
| $\nu_N$ | Unrestricted finite measure on the strip. |
| Tightness | Every sequence has a weakly convergent subsequence; uniform mass control. |
| Pure-point | A measure with no continuous part. |
| Tempered | A measure growing at most polynomially, paired against Schwartz functions. |
| Isolation disk | $\lvert s-\rho\rvert\le N^{-\varepsilon}$ around a zero $\rho$. |
| Vanishing aperture | A sequence $\varepsilon_N\to0$ with $\varepsilon_N\log N\to\infty$. |

## Named identities and bounds

| Name | Meaning |
|---|---|
| **Identity L** | The lower bound $\lvert\partial_t\eta_N^{(N^2)}(s)\rvert\ge\tfrac12N^{1-\sigma}\lvert\zeta'(\rho)\rvert>N^{1/2+\varepsilon}$ throughout the isolation disk of a simple zero with $\sigma\le\tfrac12-\delta$. Proved as Lemma 4.5.2. A **speed** bound, not an envelope. |
| $L_m$ | The jet form at a zero of multiplicity $m$ (Lemma 4.5.3). |
| $L_{\mathrm{band}}$ | The vanishing-aperture placement of balanced atoms on the line (Theorem 12.6). |
| Last-chord product | $H_N(s)H_N(1-s)=(N-1)^2/(4N^2)\to\tfrac14$. |
| Marty speed | $\eta^{\#}=\lvert\partial_t\eta\rvert/(1+\lvert\eta\rvert^2)$, the spherical speed under the north-pole chart. |
| North-pole chart | Stereographic projection from $N=(0,0,1)$ of $S^2$ to $\mathbb{C}$; see `projection.html`. |

## The remaining gap

| Symbol | Meaning |
|---|---|
| $K(\alpha,\gamma)$ | $\int_0^\infty\Phi(u)\cosh(\alpha u)\cos(\gamma u)\,du=\tfrac14\operatorname{Re}\xi(\tfrac12+\alpha+i\gamma)$. |
| $S(\alpha,\gamma)$ | $\int_0^\infty\Phi(u)\sinh(\alpha u)\sin(\gamma u)\,du=\tfrac14\operatorname{Im}\xi(\tfrac12+\alpha+i\gamma)$. |
| Off-line zero | A zero with $\alpha=\sigma-\tfrac12\neq0$; equivalently $K=S=0$. |
| Jensen polynomials | Polynomials built from the even moments $m_{2k}=\int\Phi u^{2k}$; hyperbolicity at every degree iff Laguerre–Pólya iff RH. |
| Li coefficients | $\lambda_n=\frac{1}{(n-1)!}\frac{d^n}{ds^n}[s^{n-1}\log\Xi(s)]_{s=1}$; $\lambda_n\ge0$ for all $n$ iff RH. |
| $\Lambda$ | de Bruijn–Newman constant; RH is $\Lambda\le0$; known $0\le\Lambda\le0.22$. |
| Laguerre–Pólya class | Entire functions that are limits of real-rooted polynomials; membership of $\Xi_{\cos}$ is equivalent to RH. |
| Pólya frequency function | A kernel totally positive of every order; sufficient for real zeros, not necessary. |

## The tensor

| Symbol | Meaning |
|---|---|
| $\mathcal{W}_\delta$ | Weil cone: even functions whose Fourier transform is holomorphic and decaying on $\lvert\operatorname{Im}z\rvert\le\tfrac12+\delta$. |
| $\Pi(f)$ | Prime current $\sum_{n\ge2}\Lambda(n)n^{-1/2}f(\log n)$. |
| $\Theta(f)$ | Archimedean current $\int\Phi f$. |
| $\mathcal{P}$ | Naive current $\Pi+\Theta$; its positivity $(\star)$ is false. |
| $\mathcal{W}$ | Weil current $2\int g\cosh(u/2)-2\Pi(g)+\frac1{2\pi}\int\hat g\Omega$; positivity is RH. |
| $\Omega(t)$ | $\operatorname{Re}\psi(\tfrac14+\tfrac{it}{2})-\log\pi$. |
| $(\star)$ | The proposed inequality $\langle\mathcal{P},f*\check f\rangle\ge0$; refuted by Theorem B. |

## Arithmetic and limitative

| Term | Meaning |
|---|---|
| Hypothesis (M) | The limit function has no zeros in $\sigma>1$. |
| Davenport–Heilbronn function $f$ | $bL(s,\chi)+\overline bL(s,\overline\chi)$, with a functional equation and no Euler product; has Spira’s off-line zero. |
| Spira’s zero | $\rho_{\mathrm{DH}}=0.80851718\ldots+85.69934849\ldots i$. |
| DH litmus | A result can close a gap only if it fails for the DH function, i.e. only if it consumes an Euler product, positivity, or self-adjointness. |
| Saias–Weingartner | Among periodic Dirichlet series, non-vanishing in $\sigma>1$ characterises $P(s)L(s,\chi)$. |
| Modular shadow | Reduction of the polygon in the Kaneko–Zagier ring $\mathcal{A}$; exact at positive integer weight, no transfer to complex zeros. |
| Fermat quotient | $q_p(a)=(a^{p-1}-1)/p$; the period-two polygon closes mod $p$ iff $p$ is Wieferich. |
| Straightening field | $\mathsf{r}_f(s)=f(s)/s$; punctures are zeros, holonomy is the zero count. |
| Rouché condition (E.1) | $\lvert E\rvert<\lvert F\rvert$ on the contour $\Gamma$, so $\eta$ and $(1-N^{1-s})\zeta$ have the same zero count inside. |

## Physics placements

| Term | Meaning |
|---|---|
| DQPT | Dynamical quantum phase transition; non-analyticities of a Loschmidt amplitude / free-energy density. |
| Fisher zeros | Zeros of the partition function in the complex temperature plane; the polygon’s analogues. |
| Lee–Yang circle theorem | Ferromagnetic positivity confines finite-system zeros to a line; fails for superpositions of partition functions. |
| Latent drop | The exponent $\sigma$ in the free-energy density of the polygon; the transition is at $\sigma=\tfrac12$. |
| GUE | Gaussian Unitary Ensemble; Montgomery’s pair correlation conjecture and random-matrix statistics. |
| Hilbert–Pólya | The conjecture that a self-adjoint operator has the zero ordinates as eigenvalues. |
| Primon gas / Bost–Connes | The statistical-mechanical / operator-algebraic model whose partition function is $\zeta$; the meaning of (M) in Addendum F. |
| CCM | Connes–Consani–Moscovici spectral triple and their Conjecture 1. |
| GHD / HST | Greedy harmonic decomposition / harmonic sine transform; archived programmes. |
| QEFE | Quantum-Egyptian functional equation; archived programme. |
| GDST | Greedy Dirichlet sub-sum transform; archived claimed proof. |
| GHF | Global Harmonic Framework; archived claimed proof. |

## Status words

See [STATUS.md](STATUS.md) and [the status taxonomy](00-scope-and-method/status-taxonomy.md) for the precise use of **proved**, **conditional**, **equivalent**, **open**, **refuted/withdrawn**, and **archived claim**.

[Master README](README.md) · [Master TOC](TABLE-OF-CONTENTS.md) · [Status ledger](STATUS.md)
