# 15. Where the solution of that equation sits

> Source: [`truths.md`](truths.md), §15. Frozen by the canonical paper; corrections from `tensor.md` are noted in the folder README.

## Truth 15.1 — (The \(\gamma=0\) slice, solved).

For every real \(\alpha\),
\[
K(\alpha,0)=\int_0^\infty\Phi(u)\cosh(\alpha u)\,du>0,
\]
because the integrand is positive. There is no cancellation. In the \(s\)-plane this is \(\Xi(\sigma)\neq 0\) for \(\sigma\) real. It is the same kind of object as 11.1: an identity, not a wish. Oscillation is absent, positivity of \(\Phi\) wins.

## Truth 15.2 — (The \(\alpha=0\) slice, correctly vanishing).

\(K(0,\gamma)\) is a constant multiple of \(\Xi_{\mathrm{cos}}(\gamma)\). It vanishes at the on-line zeros. Oscillation beats positivity on that slice, and is supposed to. A criterion that forbade all zeros (a positive mixture of Gaussians, 12.4) is too strong: it would contradict 1.7.

## Truth 15.3 — The mixed slice is a sign law

For each fixed \(\alpha\), \(\gamma\mapsto K(\alpha,\gamma)\) is real-analytic and even. A real-analytic real function vanishes if and only if it changes sign. Killing off-line zeros at that \(\alpha\) is the assertion that \(K(\alpha,\cdot)\) does not change sign.

## Truth 15.4 — (\(L^2\) does not sit here).

Parseval gives
\[
\int_{\mathbb{R}}K(\alpha,\gamma)^2\,d\gamma \;\asymp\; \int_0^\infty\Phi(u)^2\cosh^2(\alpha u)\,du>0.
\]
The right-hand side is increasing in \(\lvert\alpha\rvert\) and never zero. This is an envelope, not a pointwise law. It is the same distinction as the withdrawn envelope of Identity L against the speed that actually locates left-half zeros: an integral can stay large while the integrand crosses zero.

## Truth 15.5 — (Moments of \(\Phi\) exist).

Super-exponential decay of \(\Phi\) makes every even moment finite:
\[
m_{2k}=\int_0^\infty\Phi(u)\,u^{2k}\,du<\infty,\qquad k=0,1,2,\ldots.
\]
The Taylor series of the cosine transform at the origin is these moments:
\[
\Xi_{\mathrm{cos}}(t)=c\sum_{k=0}^\infty(-1)^k\frac{m_{2k}}{(2k)!}\,t^{2k}.
\]
The constant term is \(c\,m_0=c K(0,0)>0\), which is 15.1 at \(\alpha=0\). Each higher \(m_{2k}\) is the next order of oscillation about \(t=0\).

## Truth 15.6 — The solution sits in this jet

The Jensen polynomials built from the coefficients \(m_{2k}\) are real-rooted for every degree if and only if \(\Xi_{\mathrm{cos}}\) lies in the Laguerre–Pólya class (Pólya). That class membership is 12.6.3, hence equivalent to the Riemann hypothesis. The object that would kill off-line zeros is therefore the hyperbolicity of the whole Jensen tower of the moment sequence of \(\Phi\). The moments exist because \(\Phi\) exists. Hyperbolicity of every degree is the remaining statement.

The first two steps of the tower are already visible: \(m_0>0\) is 15.1; \(m_2=\int\Phi(u)u^2\,du\) is the second variation of \(K\) in \(\alpha\) at \(\alpha=0\),
\[
\partial_\alpha^2 K(0,\gamma)=\int_0^\infty\Phi(u)\,u^2\cos(\gamma u)\,du,
\]
which is the cosine transform of \(u^2\Phi(u)\). Evenness in \(\alpha\) kills the first variation. The obstruction to zeros leaving the line starts at this second moment and continues through the Hankel forms of \((m_{2k})\).

## Truth 15.7 — The same jet, written at the filter’s kernel

The elementary factor \(1-N^{1-s}\) vanishes on \(\operatorname{Re}s=1\) and nowhere in \(S_\delta\) (2.1). The Dirichlet polygon is blind on that line. Li’s coefficients
\[
\lambda_n=\frac{1}{(n-1)!}\frac{d^n}{ds^n}\Bigl[s^{n-1}\log\Xi(s)\Bigr]_{s=1}
\]
are the jet of \(\log\Xi\) at that degeneration. Bombieri–Lagarias: \(\lambda_n\ge 0\) for all \(n\) if and only if the Riemann hypothesis. The functional equation identifies a neighbourhood of \(s=1\) with a neighbourhood of \(s=0\), and the completed factor identifies both with a neighbourhood of \(t=0\) in the cosine picture. The Li jet and the Jensen jet are two coordinates of one object. The polygon can read the cosine moments at \(t=0\); it cannot read Li’s jet at \(\sigma=1\).

## Truth 15.8 — What is already known at this place

Griffin–Ono–Rolen–Zagier: for each fixed degree \(d\), the shifted Jensen polynomials of \(\Xi_{\mathrm{cos}}\) are hyperbolic for all sufficiently large shift. That is occupation of 15.6 in the limit of large shift at bounded degree. It is not uniformity in the degree, which is the full tower of 15.6.

## Truth 15.9 — Why this is the place, not a substitute

At \(\gamma=0\) positivity of \(\Phi\) already kills zeros, with no remaining gap. Introducing oscillation is exactly passing from \(m_0\) to the sequence \((m_{2k})\). A sign law for \(K(\alpha,\cdot)\) at some \(\alpha\neq 0\) is a statement about that sequence after the hyperbolic weight \(\cosh(\alpha u)\) has reweighted the measure, i.e. after the moments have been replaced by
\[
m_{2k}(\alpha)=\int_0^\infty\Phi(u)\cosh(\alpha u)\,u^{2k}\,du.
\]
The weighted sequence at \(\alpha=0\) must be allowed to produce real zeros (15.2). The weighted sequence at \(\alpha\neq 0\) must be forbidden from producing any zeros (15.3). That pair of demands is the Laguerre–Pólya class of order one, sitting at \(t=0\), equivalently Li positivity sitting at \(\sigma=1\). There is no closer point: one step back is the solved slice 15.1; one step forward is the tautology \(K\neq 0\).

## Truth 15.10

Hyperbolicity of the Jensen tower is not proved here. Positivity of the Li jet is not proved here. Either sentence is the Riemann hypothesis. The footnote to 13.5 still applies. The same sentence on \(\mathbb{R}\), without \(\xi\), is the defining pairing of `tensor.html`. That file is a redefinition, not a frozen truth.

If a later edit of `publication.html` contradicts this file, the later edit is wrong.
