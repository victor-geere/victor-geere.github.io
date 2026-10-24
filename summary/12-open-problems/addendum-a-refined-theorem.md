# Addendum A — Refined quadratic asymptotic

**Source:** [`publication-addendum-A.html`](publication-addendum-A.html), 17 August 2026.
**Status:** conditional refinement. It is not required for Theorems 9.1–12.2 and is not part of the main proof chain.

## What it adds

Addendum A strengthens Theorem 4.1 in two directions: it retains the first two secondary terms of the stationary-phase expansion at the dual critical point, and it inserts Bourgain’s subconvexity exponent $\mu(1/2)=13/84$ together with a van der Corput estimate on the residual oscillatory integrals. The resulting power saving exceeds the classical Weyl exponent $1/6$, and the uniformity range in $t$ is enlarged.

## The theorem

There exist absolute constants $c\neq0$, $c_1$, $c_2$ and a positive exponent

$$
\delta=\frac{29}{168}-\eta
$$

for an arbitrarily small absolute $\eta>0$, together with a uniformity range

$$
\delta'=\frac13+\frac{1}{42}-\eta,
$$

such that, for every integer $N\ge2$ and every real $t$ with $\lvert t\rvert\le N^{\delta'}$,

$$
\begin{aligned}
\eta_N^{(N^2)}\Bigl(\tfrac12+it\Bigr)
&=\bigl(1-N^{1/2-it}\bigr)\zeta\Bigl(\tfrac12+it\Bigr)\\
&\quad+N^{1/2}c\,\zeta\Bigl(\tfrac12-it\Bigr)e^{-it\log(N^2/2\pi)}\\
&\quad+N^{1/2-\delta}c_1\,\zeta\Bigl(\tfrac12-it\Bigr)e^{-it\log(N^2/2\pi)}(\log N)^{O(1)}\\
&\quad+N^{1/2-2\delta}c_2\,\zeta\Bigl(\tfrac12-it\Bigr)e^{-it\log(N^2/2\pi)}(\log N)^{O(1)}\\
&\quad+O\bigl(N^{1/2-\delta-\eta'}(1+\lvert t\rvert)^\varepsilon\bigr),
\end{aligned}
$$

where $\eta'>0$ depends only on the subconvexity saving and the implied constant is absolute (or at worst a fixed power of $\log N$).

## Proof sketch, in seven steps

1. **Smooth cutoff.** Replace the sharp truncation at $M=N^2$ by a smooth weight $\varphi(m/N^2)$, with $\varphi\equiv1$ on $[0,1]$ and transition width $N^{2\theta}$, $\theta=\tfrac1{12}-\eta$. The difference between the sharp and smooth sums is $O(N^{\theta+\varepsilon})$ after one integration by parts.
2. **Fourier expansion of the coefficients.** The sequence $c_m(N)$ is $N$-periodic. Its finite Fourier expansion has $\hat c_0=0$ (mean-zero) and $\lvert\hat c_k\rvert\ll1$. The polygon becomes a sum of incomplete twisted zeta sums $S_k(N^2;\tfrac12+it)$.
3. **Mellin–Poisson / approximate functional equation.** Apply Mellin–Poisson to each $S_k$. The dual length is $\ll\lvert t\rvert/N^2+1$, hence $O(N^\varepsilon)$ on the stated range. The leading stationary-phase contribution produces the displayed main dual term.
4. **Stationary-phase expansion to order two.** The phase is non-degenerate at the critical point. The expansion is a complete asymptotic series in descending powers of $N^{1/2}$; retaining $r=0,1,2$ gives the leading and two secondary dual terms. The remainder after these three is $O(N^{1/2-3\delta_0})$ with preliminary $\delta_0=1/6$.
5. **Residual oscillatory integrals and subconvexity.** Estimate the residual integrals by the hybrid bound $\lvert\zeta(\sigma+it)\rvert\ll_\varepsilon\lvert t\rvert^{\mu(\sigma)+\varepsilon}$ with $\mu(1/2)=13/84$. A single van der Corput estimate of order 1 removes an additional logarithmic factor and contributes $N^{-1/168}$. Collecting exponents gives $\delta=\tfrac16+\tfrac1{168}-\eta=\tfrac{29}{168}-\eta$.
6. **Uniformity range.** The dual length remains $O(N^\varepsilon)$ throughout $\lvert t\rvert\le N^{1/3+1/42-\eta}$; outside it the stationary-phase analysis would have to be rewritten.
7. **Assembly.** Sum the Fourier modes, absorb the cutoff error, rename constants. The secondary and tertiary dual terms contain $\zeta(1/2-it)$ and therefore vanish at every critical-line zero, so they do not disturb the local-minimum analysis near zeros.

## What it buys

The improved exponent permits a larger depth parameter $\varepsilon$ in Definition 5.1 while still guaranteeing path-closures at every critical-line zero for large $N$ within the uniformity range. The secondary dual terms do not create additional local minima of intermediate depth. The wider range reduces the number of $N$ values needed when comparing the global count of deep minima with the classical zero-counting function $N(T)$.

## What it does not buy

It does not remove the need for an explicit constant in Bourgain’s bound, and it does not prove RH. The main theorems remain valid with either the original Theorem 4.1 or this refinement; the refinement is an optional quantitative improvement.

[Back to folder README](summary/12-open-problems/README.md) · [Back to the summary index](summary/README.md)
