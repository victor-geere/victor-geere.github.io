# The defining equation of `tensor.html`: resolved, refuted, repaired

Companion to [tensor.html](tensor.html). That note poses, as the defining equation of its Section 4,

\[
\bigl\langle\mathcal{P},\,f*\check f\bigr\rangle\;\ge\;0
\qquad\text{for every }f\text{ in the Weil cone},
\tag{\(\star\)}
\]

for the current \(\mathcal{P}=\Pi+\Theta\) of its Definition 3.1, and asks whether the zeros are the Bochner spectrum of \(\mathcal{P}\). This file records what can actually be proved about \((\star)\). The outcome, stated at once so that nothing below upgrades it:

1. **Theorem A** computes \(\langle\mathcal{P},f*\check f\rangle\) exactly, via the Weil explicit formula. The Fourier resolution of \(\mathcal{P}\) on the cone is a *signed* object: a non-negative mass at the two non-real frequencies \(\pm i/2\) (the pole of \(\zeta\)), a **negative atom of weight \(\tfrac12\) at every zero frequency \(\pm\gamma_\rho\)**, and a smooth density that is negative near the origin.
2. **Theorem B**: \((\star)\) is **false**. There is an explicit even test function in the Weil cone with \(\langle\mathcal{P},f*\check f\rangle=-0.6773\ldots\) The refutation is unconditional — it does not assume, contradict, or bear on the Riemann hypothesis; the negativity is produced by the *on-line* zeros. \((\star)\) therefore does not replace the Riemann hypothesis: the two statements are not equivalent, because \((\star)\) is false in every world, including one where RH holds.
3. **Proposition 5.1**: the finite-tuple rendition of \((\star)\) fails as well, and for a shallower reason: \(\Phi\) is positive but not of positive type (\(\hat\Phi=\tfrac12\Xi_{\cos}\) changes sign).
4. **Proposition 6.1–6.3**: the tilted moments of truths.md §15 are values of \(\xi\) itself, \(K(\alpha,\gamma)=\tfrac14\operatorname{Re}\xi(\tfrac12+\alpha+i\gamma)\); an off-line zero is the *joint* vanishing of \(K\) and its sine partner \(S\), not of \(K\) alone (correcting truths.md 12.3); and the hoped-for sign law of truths.md 15.3 — \(K(\alpha,\cdot)\) of one sign for \(\alpha\neq0\) — is false for every \(\alpha\): \(K(\alpha,\cdot)\) changes sign near every simple on-line zero and infinitely often.
5. **Theorem C** identifies the repair. The current on \(\mathbb{R}\) whose positivity on the cone is equivalent to the Riemann hypothesis is the Weil current \(\mathcal{W}\): the prime term enters with the **opposite sign** to \(\Pi\), the archimedean density is the digamma term, not \(\Phi\), and the pole modes \(\cosh(u/2)\) must be carried. With \(\mathcal{W}\) in place of \(\mathcal{P}\), every structural sentence of tensor.html §4 becomes correct — and becomes Weil's positivity criterion (1952), so the replacement is classical, not new.

Everything asserted below is either proved here, cited, or verified numerically at 25 significant digits with all residuals below \(10^{-23}\) (Appendix, §9). Nothing here proves or disproves the Riemann hypothesis.

---

## 1. Conventions

Fourier transform: \(\hat f(z)=\int_{\mathbb{R}}f(u)\,e^{-izu}\,du\).

**Cone.** For \(\delta>0\) let \(\mathcal{W}_\delta\) be the set of even \(f:\mathbb{R}\to\mathbb{C}\) whose transform extends to a holomorphic function on the strip \(\lvert\operatorname{Im}z\rvert\le\tfrac12+\delta\) with
\(\sup\,(1+\lvert z\rvert)^{2+\delta}\lvert\hat f(z)\rvert<\infty\) there. The Weil cone is \(\bigcup_{\delta>0}\mathcal{W}_\delta\). Shifting the inversion contour gives \(f(u)\ll e^{-(1/2+\delta)\lvert u\rvert}\), so
\(\Pi(f)=\sum_{n\ge2}\Lambda(n)n^{-1/2}f(\log n)\) converges absolutely on the cone (\(\sum\Lambda(n)n^{-1-\delta}<\infty\)); this is the growth condition tensor.html §3 imposes for exactly this reason.

**Reflection.** Throughout, \(\check f(u):=\overline{f(-u)}\). tensor.html writes \(\check f(u)=f(-u)\) without the conjugate; for complex \(f\) the conjugate is required for \(f*\check f\) to be the square of the Gram form (otherwise \((\star)\) fails trivially on \(if\)). Every witness used below is real and even, where the two conventions coincide, so no result depends on this fix.

**Data.** \(\Phi\) is the Jacobi density of truths.md 12.1; \(\Theta(f)=\int_{\mathbb{R}}\Phi\,f\,du\); \(\mathcal{P}=\Pi+\Theta\); \(\Xi_{\cos}(t)=\xi(\tfrac12+it)\). Non-trivial zeros are written \(\rho=\tfrac12+i\gamma_\rho\) with \(\lvert\operatorname{Im}\gamma_\rho\rvert<\tfrac12\), listed with multiplicity; the zero multiset is stable under \(\gamma\mapsto-\gamma\) and \(\gamma\mapsto\bar\gamma\) (truths.md 12.2). Also
\[
\Omega(t):=\operatorname{Re}\psi\Bigl(\tfrac14+\tfrac{it}{2}\Bigr)-\log\pi,\qquad \psi=\Gamma'/\Gamma .
\]

---

## 2. Four lemmas

**Lemma 2.1 (the square).** Let \(f\in\mathcal{W}_\delta\) and \(g=f*\check f\). Then \(g\in\mathcal{W}_\delta\), it is even, and
\[
\hat g(z)=\hat f(z)\,\overline{\hat f(\bar z)} .
\]
In particular \(\hat g=\lvert\hat f\rvert^2\ge0\) on \(\mathbb{R}\), and on the imaginary axis \(\hat g(iy)=\lvert\hat f(iy)\rvert^2\ge0\). Moreover \(\overline{\hat g(\bar z)}=\hat g(z)\) and \(\hat g(-z)=\hat g(z)\).

*Proof.* \(\widehat{\check f}(z)=\int\overline{f(-u)}e^{-izu}du=\overline{\int f(v)e^{-i\bar z v}dv}=\overline{\hat f(\bar z)}\), and the transform of a convolution is the product; holomorphy and the decay \((1+\lvert z\rvert)^{-(4+2\delta)}\) follow. At \(z=iy\): evenness of \(\hat f\) gives \(\hat f(-iy)=\hat f(iy)\), so \(\hat g(iy)=\hat f(iy)\overline{\hat f(-iy)}=\lvert\hat f(iy)\rvert^2\). The symmetries are read off the formula. \(\square\)

**Lemma 2.2 (the archimedean transform).** \(\hat\Phi(t)=\tfrac12\,\Xi_{\cos}(t)\); equivalently the constant in truths.md 12.1 is \(c=4\):
\(\Xi_{\cos}(t)=4\int_0^\infty\Phi(u)\cos(tu)\,du\). Consequently, for every \(g\) in the cone,
\[
\Theta(g)=\frac{1}{4\pi}\int_{\mathbb{R}}\Xi_{\cos}(t)\,\hat g(t)\,dt .
\]

*Proof.* Riemann's integral representation (Riemann 1859; Edwards §1.8; Titchmarsh §10.1) is
\(\xi(s)=4\int_1^\infty \frac{d}{dx}\bigl[x^{3/2}\psi'(x)\bigr]\,x^{-1/4}\cosh\bigl(\tfrac12(s-\tfrac12)\log x\bigr)dx\) with \(\psi(x)=\sum_{n\ge1}e^{-\pi n^2x}\). Since
\(\frac{d}{dx}\bigl[x^{3/2}\psi'(x)\bigr]=\sum_{n\ge1}\bigl(\pi^2n^4x^{3/2}-\tfrac{3\pi}{2}n^2x^{1/2}\bigr)e^{-\pi n^2x}\),
the substitution \(x=e^{2u}\), \(s=\tfrac12+it\) gives
\(\Xi_{\cos}(t)=8\int_0^\infty\sum_n\bigl(\pi^2n^4e^{9u/2}-\tfrac{3\pi}{2}n^2e^{5u/2}\bigr)e^{-\pi n^2e^{2u}}\cos(tu)\,du=4\int_0^\infty\Phi(u)\cos(tu)\,du\)
for exactly the \(\Phi\) of 12.1. (Numerical confirmation: \(\hat\Phi(t)/\Xi_{\cos}(t)=0.5\) to 25 digits at \(t=0,3,15\); Appendix.) The Parseval identity is Fubini: \(\Phi\in L^1\) with doubly-exponential decay, \(\hat g\in L^1\), \(g\) continuous, so
\(\int\Phi g=\frac1{2\pi}\int\hat\Phi(t)\hat g(t)\,dt\), both transforms being even. \(\square\)

**Lemma 2.3 (the prime current as a line integral).** For \(g\) in the cone, \(c=1+\varepsilon\) with \(0<\varepsilon<\delta\), and
\(F(s):=\hat g\bigl(\tfrac{s-1/2}{i}\bigr)=\int_{\mathbb{R}}g(u)e^{-(s-1/2)u}\,du\) (so \(F(1-s)=F(s)\), \(F(\tfrac12+it)=\hat g(t)\)),
\[
\frac{1}{2\pi i}\int_{(c)}\Bigl(-\frac{\zeta'}{\zeta}(s)\Bigr)F(s)\,ds=\Pi(g).
\]

*Proof.* Expand \(-\zeta'/\zeta(s)=\sum\Lambda(n)n^{-s}\), absolutely convergent on \((c)\), and integrate term by term (justified by \(\int\lvert F(c+it)\rvert dt<\infty\)). With \(s=c+it\),
\(\frac1{2\pi}\int F(c+it)n^{-it}dt=g_c(-\log n)\) by Fourier inversion applied to \(g_c(u):=g(u)e^{-(c-1/2)u}\), whence
\(\frac{1}{2\pi i}\int_{(c)}n^{-s}F(s)ds=n^{-c}\,g(-\log n)\,n^{c-1/2}=g(\log n)/\sqrt n\) using evenness. Summing against \(\Lambda(n)\) gives \(\Pi(g)\). \(\square\)

**Lemma 2.4 (explicit formula, even form).** For every \(g\) in the cone,
\[
2\,\Pi(g)\;=\;\hat g\Bigl(\frac i2\Bigr)+\hat g\Bigl(-\frac i2\Bigr)\;-\;\sum_{\rho}\hat g(\gamma_\rho)\;+\;\frac{1}{2\pi}\int_{\mathbb{R}}\hat g(t)\,\Omega(t)\,dt,
\]
the sum over zeros converging absolutely.

*Proof.* Shift the line of Lemma 2.3 from \(\operatorname{Re}s=c\) to \(\operatorname{Re}s=-\varepsilon\), through rectangles of height \(T_j\to\infty\) chosen so that \(\zeta'/\zeta(\sigma+iT_j)\ll\log^2T_j\) uniformly in \(-1\le\sigma\le2\) (Davenport §17). On the horizontals \(\lvert F\rvert\ll T_j^{-(2+\delta)}\) (the argument \((s-\tfrac12)/i\) stays in the strip \(\lvert\operatorname{Im}z\rvert\le\tfrac12+\varepsilon\)), so they vanish in the limit. The poles crossed are: \(s=1\) (residue of \(-\zeta'/\zeta\) is \(+1\)), contributing \(F(1)\); and each non-trivial zero \(\rho\) (residue \(-m_\rho\)), contributing \(-\sum_\rho F(\rho)\), absolutely convergent since \(F(\rho)=\hat g(\gamma_\rho)\ll(1+\lvert\operatorname{Re}\gamma_\rho\rvert)^{-(4+2\delta)}\) against \(N(T+1)-N(T)\ll\log T\). Trivial zeros and \(s=0\) are not crossed (\(\zeta(0)=-\tfrac12\neq0\)). Hence
\[
\Pi(g)=F(1)-\sum_\rho F(\rho)+\frac{1}{2\pi i}\int_{(-\varepsilon)}\Bigl(-\frac{\zeta'}{\zeta}\Bigr)F .
\]
On \((-\varepsilon)\) use \(\zeta(s)=\chi(s)\zeta(1-s)\), i.e. \(-\zeta'/\zeta(s)=-\chi'/\chi(s)+\zeta'/\zeta(1-s)\). The substitution \(w=1-s\) and \(F(1-w)=F(w)\) turn the second piece into \(\frac{1}{2\pi i}\int_{(c)}\frac{\zeta'}{\zeta}F=-\Pi(g)\) by Lemma 2.3. For the first piece, \(\chi(s)=2^s\pi^{s-1}\sin(\pi s/2)\Gamma(1-s)\) has in \(-\varepsilon<\operatorname{Re}s<\tfrac12\) exactly one pole of \(\chi'/\chi\), at \(s=0\), simple with residue \(1\) (the simple zero of \(\sin(\pi s/2)\)), so
\(\frac{1}{2\pi i}\int_{(-\varepsilon)}\frac{\chi'}{\chi}F=\frac{1}{2\pi i}\int_{(1/2)}\frac{\chi'}{\chi}F-F(0)\).
On the critical line, \(\chi(s)=\pi^{s-1/2}\Gamma(\tfrac{1-s}2)/\Gamma(\tfrac s2)\) gives
\(\frac{\chi'}{\chi}(\tfrac12+it)=\log\pi-\operatorname{Re}\psi(\tfrac14+\tfrac{it}2)=-\Omega(t)\), which is real, whence
\(-\frac{1}{2\pi i}\int_{(-\varepsilon)}\frac{\chi'}{\chi}F=F(0)+\frac1{2\pi}\int\hat g(t)\,\Omega(t)\,dt\).
Assembling, with \(F(0)=\hat g(i/2)\) and \(F(1)=\hat g(-i/2)\), gives the display. \(\square\)

The identity of Lemma 2.4 is verified numerically to a residual of \(6\times10^{-25}\) on the witness of §4 (Appendix). It is Weil's explicit formula for \(\zeta\) in the even normalisation (Weil 1952; Bombieri 2000; Iwaniec–Kowalski, ch. 5).

---

## 3. Theorem A: what \(\langle\mathcal{P},f*\check f\rangle\) actually is

**Theorem A.** For every \(f\) in the Weil cone, with \(g=f*\check f\) and \(\hat g(z)=\hat f(z)\overline{\hat f(\bar z)}\),
\[
\bigl\langle\mathcal{P},f*\check f\bigr\rangle
=\underbrace{\bigl\lvert\hat f(i/2)\bigr\rvert^{2}}_{\text{pole of }\zeta}
\;-\;\frac12\sum_{\rho}\hat g(\gamma_\rho)
\;+\;\frac{1}{2\pi}\int_{\mathbb{R}}\bigl\lvert\hat f(t)\bigr\rvert^{2}\,W(t)\,dt,
\qquad
W:=\tfrac12\,\Xi_{\cos}+\tfrac12\,\Omega .
\]
The zero sum is real (Lemma 2.1 symmetries pair \(\gamma\) with \(-\bar\gamma\)); under the Riemann hypothesis it equals \(\sum_\rho\lvert\hat f(\gamma_\rho)\rvert^2\). For real even \(f\), \(\lvert\hat f(i/2)\rvert^2=\bigl(\int f(u)\cosh\tfrac u2\,du\bigr)^2\).

*Proof.* \(\langle\mathcal{P},g\rangle=\Pi(g)+\Theta(g)\). Halve Lemma 2.4, add Lemma 2.2, and use \(\hat g(\pm i/2)=\lvert\hat f(i/2)\rvert^2\) from Lemma 2.1. \(\square\)

**Corollary 3.1 (the spectrum of \(\mathcal{P}\) is signed).** On the cone, the Fourier resolution of \(\mathcal{P}\) consists of:

- a non-negative point mass at the two **non-real** frequencies \(z=\pm i/2\) — the pole of \(\zeta\), i.e. the Laplace modes \(e^{\pm u/2}\);
- a **negative atom of weight \(\tfrac12\)** at every zero frequency \(\gamma_\rho\) (and its mirror), on \(\mathbb{R}\) exactly when the zero is on the line;
- the smooth density \(W=\hat\Phi+\tfrac12\Omega\), with \(W(0)=-2.43753\ldots<0\) and \(W(t)\sim\tfrac12\log\tfrac{t}{2\pi}\) as \(t\to\infty\).

Two readings matter. First, the negative atoms are contributed by \(\Pi\) **alone**: \(\Theta\)'s entire contribution is the density \(\tfrac12\Xi_{\cos}\), which *vanishes at every* \(\gamma_\rho\). The Jacobi density can never fill the holes the primes dig at the zero frequencies — the explicit formula says primes and zeros sit on opposite sides with a definite orientation, so adding a positively-weighted prime current deepens the negative atoms rather than cancelling them. Second, positivity of \(\Phi\) is spectrally inert: what \((\star)\) needed was positive *type* (\(\hat\Phi\ge0\)), which \(\Phi\) does not have (§5).

**Remark 3.2 (Bochner, as invoked in tensor.html §4, cannot apply).** \(\mathcal{P}\) is not a tempered distribution — its mass to \(u\) grows like \(e^{u/2}\) — so the classical Bochner–Schwartz theorem is unavailable from the outset; any spectral statement must live on the cone, where Theorem A *is* the Fourier resolution. And no positive measure on \(\mathbb{R}\) can represent \(\mathcal{P}\) even conditionally: the modes at \(\pm i/2\) are off \(\mathbb{R}\), forced by the pole of \(\zeta\). The sentence "they are real because the group is \(\mathbb{R}\)" fails at exactly this point: living on \(\mathbb{R}\) does not make a spectrum a positive measure, and \(\mathcal{P}\)'s is not.

---

## 4. Theorem B: \((\star)\) is false

**Theorem B.** Let \(\gamma_1=14.134725141734693\ldots\) be the first zero ordinate and take the real even test function
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

**Remark 4.1 (unconditional, and independent of RH).** The direct route uses no information about zeros at all — only \(\Lambda(n)\) and \(\Phi\). Moreover the failure mechanism *persists under RH*: by Theorem A, concentrating \(\lvert\hat f\rvert^2\) at any real zero ordinate always produces \(\approx-\tfrac12\) per zero of the pair against a density recovery bounded by \(\sup_{\text{bump}}W<\tfrac12\). So \((\star)\) is not "the Riemann hypothesis rewritten on \(\mathbb{R}\)"; it is a statement false in every scenario.

**Remark 4.2 (tensor.html §8's inference is the wrong way round).** §8 says: "If \((\star)\) fails, the Fourier transform of \(\mathcal{P}\) is not a measure, and the Laplace picture in \(\mathbb{C}\) will show poles off the line." The first clause is now a theorem; the second does not follow and is (as far as anyone knows) false: the failure is caused by the on-line zeros, whose atoms enter with a negative sign, not by any off-line zero. Failure of \((\star)\) carries no information about RH.

**Remark 4.3.** The refutation is insensitive to the \(\check f\) convention (the witness is real and even) and to the normalisation of \(\Phi\) (rescaling \(\Theta\) by any constant leaves \(\lvert\Theta(g_0)\rvert<10^{-3}\), against \(\Pi(g_0)=-0.678\)).

---

## 5. The kernel form, and \(\Phi\) itself

tensor.html §4 also states \((\star)\) in kernel language: \(\sum_{j,k}a_j\bar a_k\,\mathcal{P}(u_j-u_k)\ge0\) "whenever the pairing is defined". For generic tuples the differences \(u_j-u_k\) avoid every \(\log(p^m)\) — e.g. on the grid \(u_j=j/20\) the difference \(m/20\) has \(e^{m/20}\) transcendental for \(m\neq0\) (Lindemann), never a prime power — so the defined pairing sees only the density part \(\Phi\). The kernel form of \((\star)\) is therefore the assertion that \(\Phi\) is of positive type. It is not:

**Proposition 5.1.** \(\Phi\) is positive, even, integrable — and not of positive type. Indeed \(\hat\Phi(t)=\tfrac12\Xi_{\cos}(t)\) (Lemma 2.2) changes sign at every simple on-line zero; numerically
\(\hat\Phi(15)=-3.5284897941\times10^{-4}<0\), and \(\hat\Phi<0\) throughout \((\gamma_1,\gamma_2)\). By Bochner's theorem the kernel \(\Phi(u-v)\) is not positive-semidefinite; explicitly, with \(u_j=j/20\), \(\lvert j\rvert\le600\), \(a_j=e^{15iu_j}\),
\[
\sum_{j,k}a_j\bar a_k\,\Phi(u_j-u_k)=-5.9384\ldots<0
\qquad(\text{the same form at frequency }0\text{ is }+5953.27).
\]

So the finite-tuple version of \((\star)\) fails at exactly the tuples where tensor.html declares the pairing defined, and it fails for a reason one step shallower than Theorem B: it does not even need the primes. This also settles the sentence in tensor.html §5 — "positivity of \(\Phi\) solves that slice" — in the intended direction only for the constant mode. Positivity of a function and positivity of its type are transverse properties (truths.md 12.4 already knew this for the zero-location question; the same distinction kills the kernel form of \((\star)\)).

Note the irony made precise by Lemma 2.2: \(\Theta\) *is* \(\xi\). Pairing against the Jacobi density is pairing against \(\Xi_{\cos}\) on the spectral side, so tensor.html's "no entire function is named" is not achieved by \(\mathcal{P}\) — the named function \(\xi\) rides inside \(\Theta\) as its transform.

---

## 6. The tilted moments are \(\xi\): the \(K\)-programme of truths.md §15

Write, as in truths.md §15,
\[
K(\alpha,\gamma)=\int_0^\infty\Phi(u)\cosh(\alpha u)\cos(\gamma u)\,du,
\qquad
S(\alpha,\gamma):=\int_0^\infty\Phi(u)\sinh(\alpha u)\sin(\gamma u)\,du .
\]

**Proposition 6.1 (closed form).** For all real \(\alpha,\gamma\):
\[
K(\alpha,\gamma)=\tfrac14\operatorname{Re}\,\xi\bigl(\tfrac12+\alpha+i\gamma\bigr),
\qquad
S(\alpha,\gamma)=\tfrac14\operatorname{Im}\,\xi\bigl(\tfrac12+\alpha+i\gamma\bigr).
\]
*Proof.* With \(\hat\Phi(z)=\int\Phi(u)e^{-izu}du\) and \(z=-\gamma+i\alpha\),
\[
\int_{\mathbb{R}}\Phi(u)\,e^{(\alpha+i\gamma)u}\,du=\hat\Phi(-\gamma+i\alpha)=\hat\Phi(\gamma-i\alpha)=\tfrac12\,\Xi_{\cos}(\gamma-i\alpha)=\tfrac12\,\xi\bigl(\tfrac12+\alpha+i\gamma\bigr),
\]
by evenness of \(\hat\Phi\) and Lemma 2.2 (the continuation is legitimate: \(\Phi\) decays doubly exponentially, so \(\hat\Phi\) is entire). Expanding \(e^{(\alpha+i\gamma)u}=\bigl[\cosh(\alpha u)+\sinh(\alpha u)\bigr]\bigl[\cos(\gamma u)+i\sin(\gamma u)\bigr]\), the two cross terms are odd in \(u\) and integrate to zero against the even \(\Phi\); what survives is \(2K(\alpha,\gamma)+2i\,S(\alpha,\gamma)\). Verified to \(10^{-27}\) at \((\alpha,\gamma)=(0.1,14)\) and \((0.25,2)\) (Appendix). \(\square\)

**Corollary 6.2 (correction to truths.md 12.3).** A zero of \(\xi\) at \(\tfrac12+\alpha+i\gamma\), \(\alpha\neq0\), is the *joint* vanishing \(K(\alpha,\gamma)=S(\alpha,\gamma)=0\). The vanishing of the cosine moment alone — 12.3's "exactly the vanishing of this moment" — is only the real half, hence necessary, not sufficient. (The programme direction survives: if \(K(\alpha,\cdot)\) never vanished for \(\alpha\ne0\) there would be no off-line zeros. But:)

**Proposition 6.3 (the sign law of 15.3 is false for every \(\alpha\)).** Fix any \(\alpha\neq0\) (by evenness in \(\alpha\), take \(\alpha>0\)).

1. *Near every simple on-line zero.* If \(\Xi_{\cos}(\gamma_0)=0\), \(\Xi_{\cos}'(\gamma_0)\neq0\), then \(\xi(\tfrac12+\alpha+i\gamma)=-i\,\Xi_{\cos}'(\gamma_0)\bigl(\alpha+i(\gamma-\gamma_0)\bigr)+O(\alpha^2+(\gamma-\gamma_0)^2)\), so
\(K(\alpha,\gamma)=\tfrac14\Xi_{\cos}'(\gamma_0)(\gamma-\gamma_0)+O(\cdot)\): the cosine moment changes sign essentially **at** \(\gamma_0\), for every tilt \(\alpha\), while \(S(\alpha,\gamma_0)\approx-\tfrac14\Xi_{\cos}'(\gamma_0)\,\alpha\neq0\) keeps the joint system away from zero. Numerically: \(K(0.1,14.1)=+1.0\times10^{-5}\) against \(K(0.1,14.2)=-2.4\times10^{-5}\), and \(K(0.25,14.0)=+3.7\times10^{-5}\) against \(K(0.25,14.1)=-5.6\times10^{-7}\): a sign change of \(K(\alpha,\cdot)\) inside \((14.1,14.2)\) and \((14.0,14.1)\) respectively, at both tilts.
2. *Globally.* On the vertical line \(\operatorname{Re}s=\tfrac12+\alpha\), \(\arg\xi(s)=\tfrac t2\log\tfrac{t}{2\pi e}+O(\log t)\) (Stirling for \(\arg\Gamma(s/2)\), \(\arg\zeta(\sigma+it)\ll\log t\) uniformly for \(\sigma\ge\tfrac12\), Titchmarsh §9.4). The phase increases without bound, so \(\operatorname{Re}\xi\), hence \(K(\alpha,\cdot)\), has \(\gg T\log T\) sign changes in \([T,2T]\) — the same density as the zeros of \(\Xi_{\cos}\) itself.

Consequently the assertion of truths.md 15.3 — "killing off-line zeros at that \(\alpha\) is the assertion that \(K(\alpha,\cdot)\) does not change sign" — is unsatisfiable: \(K(\alpha,\cdot)\) changes sign for every \(\alpha\), off-line zeros or not. Likewise the further-research sentence quoted in tensor.html §8 ("a proof that \(\int\Phi(u)\cosh(\alpha u)\cos(\gamma u)\,du\) cannot vanish for \(\alpha\neq0\)") targets a false statement — the note was right to refuse to assert it, for a stronger reason than it gave. What remains open is exactly Corollary 6.2's joint statement: for \(\alpha\neq0\) the real curve \(K(\alpha,\cdot)=0\) and the curve \(S(\alpha,\cdot)=0\) never meet. That is the Riemann hypothesis, undisguised: \(K\) and \(S\) are \(\operatorname{Re}\xi\) and \(\operatorname{Im}\xi\).

(The solved slice 15.1 reads correctly in this notation: at \(\gamma=0\), \(S(\alpha,0)\equiv0\) identically, and \(K(\alpha,0)=\tfrac14\xi(\tfrac12+\alpha)>0\) — positivity of \(\Phi\) wins precisely where the sine partner is trivially dead.)

---

## 7. Theorem C: the repair, and why it is Weil's criterion

Theorem A dictates the repair uniquely: flip the sign of the prime term so the zero atoms come out positive, keep the pole modes, and use the archimedean density that the contour actually produces (\(\tfrac12\Omega\) per side), not \(\Phi\).

**Definition 7.1 (Weil current).** For \(g\) in the cone,
\[
\langle\mathcal{W},g\rangle\;:=\;2\int_{\mathbb{R}}g(u)\cosh\tfrac u2\,du\;-\;2\,\Pi(g)\;+\;\frac1{2\pi}\int_{\mathbb{R}}\hat g(t)\,\Omega(t)\,dt .
\]

**Theorem C.**
1. (*Identity.*) For every \(g\) in the cone, \(\displaystyle\langle\mathcal{W},g\rangle=\sum_{\rho}\hat g(\gamma_\rho)\). In particular \(\langle\mathcal{W},f*\check f\rangle=\sum_\rho\hat f(\gamma_\rho)\overline{\hat f(\bar\gamma_\rho)}\).
2. (*RH \(\Rightarrow\) positivity.*) If all \(\gamma_\rho\) are real, \(\langle\mathcal{W},f*\check f\rangle=\sum_\rho\lvert\hat f(\gamma_\rho)\rvert^2\ge0\) for every \(f\) in the cone.
3. (*Positivity \(\Rightarrow\) RH; Weil.*) Conversely, if \(\langle\mathcal{W},f*\check f\rangle\ge0\) for all \(f\) in the cone, every zero is on the line.

*Proof.* (1) is Lemma 2.4 rearranged, using \(2\int g\cosh\tfrac u2=\hat g(i/2)+\hat g(-i/2)\). (2) is Lemma 2.1 on the real axis. (3) is classical (Weil 1952; Bombieri 2000). Sketch, for completeness: suppose \(\gamma_0=\beta+i\theta\), \(\theta\neq0\); then \(\beta\neq0\) (\(\xi\) has no real zeros in \([0,1]\)). Take \(f\) real, even, \(\hat f\) a narrow Gaussian pair at \(\pm\beta\) — narrow enough that only the quadruple \(\{\pm\gamma_0,\pm\bar\gamma_0\}\) of maximal \(\lvert\theta\rvert\) within the window matters exponentially — and modulate: \(f_c(u)=f(u-c)+f(u+c)\), so \(\hat f_c(z)=2\hat f(z)\cos(cz)\) and
\(\hat g_c(\gamma_0)=4\hat f(\gamma_0)^2\cos^2(c\gamma_0)\). The quadruple contributes \(\asymp e^{2\theta c}\bigl(\cos(2c\beta-\varphi)+o(1)\bigr)\cdot\lvert\hat f(\gamma_0)\rvert^2\) for a fixed phase \(\varphi\), while all real zeros contribute \(O(1)\) uniformly in \(c\) (\(\lvert\cos(c\gamma)\rvert\le1\) for real \(\gamma\)). Choosing \(c\to\infty\) with \(\cos(2c\beta-\varphi)\le-\tfrac12\) drives the form to \(-\infty\). \(\square\)

**Corollary 7.2 (the repaired Section 4 of tensor.html).** Define the prime spectrum as the spectrum of \(\mathcal{W}\), not of \(\mathcal{P}\): the identity (1) says the spectral resolution of \(\mathcal{W}\) on the cone is *exactly* \(\mathrm{Z}=\sum_\rho\delta_{\gamma_\rho}\), with no density and no pole term left over — unconditionally. Then:
\[
\text{RH}\iff \mathrm{Z}\ \text{is a positive measure on}\ \mathbb{R} \iff \mathcal{W}\ \text{is of positive type on the cone} .
\]
Every structural sentence of tensor.html §4 becomes true with \(\mathcal{P}\mapsto\mathcal{W}\): the relationship between primes and zeros is a translation-invariant 2-tensor on \(\mathbb{R}\); its spectrum is the zeros; positivity of the tensor is the open statement. What must be surrendered is the hope that the tensor is the *naïvely signed* prime current: the primes enter \(\mathcal{W}\) negatively, because the explicit formula orients them against the zeros (Corollary 3.1); the archimedean term is the digamma density, because that is what \(\chi'/\chi\) leaves on the critical line — the Jacobi density \(\Phi\) belongs to \(\xi\)'s transform, not to the measure; and the two \(\cosh(u/2)\) modes stay, because the pole of \(\zeta\) is part of the relationship and its frequencies \(\pm i/2\) are honestly off \(\mathbb{R}\). "The zeros are real because the group is \(\mathbb{R}\)" must be retired: on the group \(\mathbb{R}\), realness of the spectrum is not a grammatical consequence but the assertion \(\langle\mathcal{W},f*\check f\rangle\ge0\) itself — Weil's criterion, which is RH.

**Remark 7.3 (relation to Lemma 7.2 of publication.html).** The polygonal paper's positive tensor has kernel \(e^{-\lvert\log(m/n)\rvert}\) with transform \(\tfrac2{1+t^2}>0\): genuinely of positive type, by a *strictly positive* spectral density. The passage "from \(c_m^{(N)}\) to \(\Lambda\)" is therefore not a sign-preserving analogy: the completed object on the \(\Lambda\) side has spectral density \(W\) of both signs plus negative atoms (Theorem A) unless the primes are subtracted, after which its spectrum is purely atomic at the zeros (Theorem C). The min/max tensor is a true Bochner positivity; \((\star)\) never was.

---

## 8. Status of the claims in tensor.html and truths.md

- tensor.html §4, \((\star)\ge0\): **false** (Theorem B; witness \(f_0\), value \(-0.6773\)).
- §4, "equivalently \(K(u,v)=\mathcal{P}(u-v)\) is positive semi-definite": **false**; the tuple form fails already for the density part (\(\Phi\) not of positive type, Proposition 5.1).
- §4, "If \((\star)\) holds, Bochner's theorem ... supplies a unique even tempered positive measure": antecedent false; also \(\mathcal{P}\) is not tempered and its resolution has mass off \(\mathbb{R}\) (Remark 3.2). The true resolution is Theorem A.
- §4, Definition 4.1 ("the prime spectrum is the Bochner measure of \(\mathcal{P}\)"): empty as defined. The object that exists is the spectrum of \(\mathcal{W}\), which is \(\sum_\rho\delta_{\gamma_\rho}\) unconditionally, positive iff RH (Corollary 7.2).
- §4/abstract, "\((\star)\) replaces the Riemann hypothesis": **no**. \((\star)\) is false while RH is open, so they are not equivalent. The statement on \(\mathbb{R}\) that is equivalent to RH is Weil positivity, \(\langle\mathcal{W},f*\check f\rangle\ge0\) (Theorem C).
- §5, "the \(\gamma=0\) slice ... positivity of \(\Phi\) solves that slice": on low-frequency test functions the positivity of \(\langle\mathcal{P},f*\check f\rangle\) is carried by the pole term \(\lvert\hat f(i/2)\rvert^2\), not by \(\Phi\) (the density \(W\) is negative near \(0\): \(W(0)=-2.4375\)). The \(K(\alpha,0)>0\) slice itself is fine (truths.md 15.1) but is about \(\operatorname{Re}\xi\) on the real axis, not about positive type.
- §6, "Passing from \(c_m^{(N)}\) to \(\Lambda\) ... is \((\star)\)": the completed statement is Weil positivity, and the sign of the prime side flips on the way (Remark 7.3).
- §8, "If \((\star)\) fails ... the Laplace picture will show poles off the line": non sequitur; \((\star)\) fails unconditionally with no off-line consequence (Remark 4.2).
- §8, further research ("\(K(\alpha,\gamma)\) cannot vanish for \(\alpha\neq0\)"): the target statement is **false for every \(\alpha\)** (Proposition 6.3); the surviving open statement is the joint non-vanishing of \((K,S)\), i.e. RH (Corollary 6.2).
- truths.md 12.3, "a zero ... is exactly the vanishing of this moment": "exactly" should be "in particular"; the zero condition is \(K=S=0\) jointly (Corollary 6.2).
- truths.md 15.3, the sign law: unsatisfiable for every \(\alpha\) (Proposition 6.3). 15.1, 15.2, 15.4–15.10 are untouched.
- truths.md 12.1: the unspecified constant is \(c=4\) for the \(\Phi\) as printed, i.e. \(\hat\Phi=\tfrac12\Xi_{\cos}\) (Lemma 2.2).

What this file does **not** do: prove or disprove the Riemann hypothesis, or diminish the reformulation programme. It relocates the programme onto the current for which the reformulation is true — \(\mathcal{W}\), where it is Weil's — and closes \((\star)\), the \(K\)-sign law, and the kernel form as dead ends, with proofs.

---

## 9. Numerical appendix

Environment: Python 3 with mpmath 1.3.0, `mp.dps = 25`. Two structurally independent evaluations of \(\langle\mathcal{P},f_0*\check f_0\rangle\) (prime sum + \(\Phi\)-integral, with no zero data; versus Theorem A's pole/atoms/density, with no prime data) agree to \(6\times10^{-25}\). The zeros used are \(\gamma_1,\dots,\gamma_{12}\) from `mpmath.zetazero`; the tail beyond them contributes \(<10^{-400}\) to the atom sum for this witness, and hypothetical off-line zeros (which would have \(\lvert\operatorname{Re}\gamma_\rho\rvert>3\times10^{12}\), Platt–Trudgian) are annihilated by the Gaussian decay of \(\hat g_0\).

```python
# Numerical companion to tensor.md: verification of Theorems A and B,
# the normalisation \hat Phi = Xi/2, the tilt identities, and the
# failure of positive type for Phi.  Requires mpmath (tested: 1.3.0).
from mpmath import (mp, mpf, mpc, exp, cos, cosh, sin, sinh, sqrt, pi, log,
                    gamma, zeta, digamma, re, im, quad, zetazero, fabs)

mp.dps = 25
g1 = im(zetazero(1))                      # gamma_1 = 14.134725...
print("gamma_1 =", g1)

# ---- witness f0 and g0 = f0 * f0 ----
def f0(u):   return (2/sqrt(pi))*exp(-u**2)*cos(g1*u)
def fhat(z): return exp(-(z - g1)**2/4) + exp(-(z + g1)**2/4)
def ghat(z): return fhat(z)**2            # f0 real and even
def g0(v):   return sqrt(2/pi)*exp(-v**2/2)*(cos(g1*v) + exp(-g1**2/2))

conv = quad(lambda u: f0(u)*f0(mpf('0.7')-u), [-8, mpf('0.35'), 8])
print("closed form of g0: resid =", conv - g0(mpf('0.7')))

# ---- Pi(g0): sum over prime powers ----
X = 60000
sieve = bytearray([1])*(X+1); sieve[0] = sieve[1] = 0
for i in range(2, int(X**0.5)+1):
    if sieve[i]:
        for j in range(i*i, X+1, i): sieve[j] = 0
Pg = mpf(0)
for p in range(2, X+1):
    if sieve[p]:
        lp = log(p); pk = p
        while pk <= X:
            Pg += lp*g0(log(mpf(pk)))/sqrt(mpf(pk)); pk *= p
print("Pi(g0)    =", Pg)

# ---- Phi (truths.md 12.1) and Xi_cos ----
def Phi(u):
    u = fabs(u); e2u = exp(2*u); s = mpf(0)   # Phi is even (Jacobi)
    for n in range(1, 14):
        s += (2*pi**2*n**4*exp(mpf(9)*u/2) - 3*pi*n**2*exp(mpf(5)*u/2))*exp(-pi*n**2*e2u)
    return s
def Xi(t):
    s = mpc(mpf(1)/2, t)
    return re(mpf(1)/2*s*(s-1)*pi**(-s/2)*gamma(s/2)*zeta(s))

for t in [0, 3, 15]:                       # hatPhi(t) / Xi_cos(t) = 1/2
    hp = 2*quad(lambda u: Phi(u)*cos(t*u), [0, 1, 2, mpf('3.8')])
    print("t=%2s  hatPhi/Xi =" % t, hp/Xi(mpf(t)))

# ---- Theta(g0), two independent ways ----
pts = [0, 8, 11, mpf(g1), 17, 20, 26, 45]
Tg  = 2*quad(lambda u: Phi(u)*g0(u), [0, mpf('0.5'), 1, mpf('1.5'), 2, mpf('2.6'), mpf('3.8')])
TgP = (1/(2*pi))*quad(lambda t: Xi(t)*ghat(t), pts)
print("Theta(g0) =", Tg, "  Parseval resid =", Tg - TgP)

LHS = Pg + Tg
print("<P, f0*f0> =", LHS)

# ---- explicit-formula side (Theorem A) ----
def Om(t): return re(digamma(mpc(mpf(1)/4, t/2))) - log(pi)
pole  = re(ghat(mpc(0, mpf(1)/2)))         # |fhat(i/2)|^2
zsum  = sum(2*re(ghat(im(zetazero(k)))) for k in range(1, 13))
archW = (1/pi)*quad(lambda t: ghat(t)*(Xi(t)/2 + Om(t)/2), pts)
archO = (1/pi)*quad(lambda t: ghat(t)*Om(t), pts)
print("pole      =", pole)
print("atoms     =", -zsum/2)
print("density   =", archW)
print("Theorem A resid  =", LHS - (pole - zsum/2 + archW))
print("Lemma 2.4 resid  =", Pg - (2*pole - zsum + archO)/2)
print("W(0)      =", Xi(mpf(0))/2 + Om(mpf(0))/2)
print("hatPhi(15)=", Xi(mpf(15))/2)

# ---- tilt identities K, S = (1/4) Re, Im xi ----
def xi_s(s): return mpf(1)/2*s*(s-1)*pi**(-s/2)*gamma(s/2)*zeta(s)
for (a, gg) in [(mpf('0.1'), mpf(14)), (mpf('0.25'), mpf(2))]:
    K = quad(lambda u: Phi(u)*cosh(a*u)*cos(gg*u), [0, 1, 2, mpf('3.8')])
    S = quad(lambda u: Phi(u)*sinh(a*u)*sin(gg*u), [0, 1, 2, mpf('3.8')])
    v = xi_s(mpc(mpf(1)/2 + a, gg))
    print("K,S(%s,%s) resids =" % (a, gg), K - re(v)/4, S - im(v)/4)

# ---- sign changes of K(alpha, .) near gamma_1 ----
for a in ['0.1', '0.25']:
    for gg in ['14.0', '14.1', '14.2']:
        print("K(%s,%s) =" % (a, gg), re(xi_s(mpc(mpf(1)/2 + mpf(a), mpf(gg))))/4)

# ---- the kernel/tuple form: Phi is not of positive type ----
mp.dps = 15
delta = mpf('0.05'); M = 600               # u_j = j/20, |j| <= M
for th in [0, 15]:
    Q = sum((2*M+1-abs(d))*cos(mpf(th)*d*delta)*Phi(d*delta) for d in range(-80, 81))
    print("tuple form  theta=%2s :  Q = %s" % (th, Q))
```

Output, verbatim:

```text
gamma_1 = 14.13472514173469379045725
closed form of g0: resid = -1.292469707114105741986576e-26
Pi(g0)    = -0.6776451473031691521911752
t= 0  hatPhi/Xi = 0.5
t= 3  hatPhi/Xi = 0.5
t=15  hatPhi/Xi = 0.5
Theta(g0) = 0.0003426691864130141412320551   Parseval resid = 0.0
<P, f0*f0> = -0.6773024781167561380499432
pole      = 1.599008958749348880465888e-43
atoms     = -1.000000000050072433413045
density   = 0.3226975219333162953631013
Theorem A resid  = 5.94536065272488641313825e-25
Lemma 2.4 resid  = 5.94536065272488641313825e-25
W(0)      = -2.437531320518675736160092
hatPhi(15)= -0.0003528489794107737103153125
K,S(0.1,14.0) resids = -3.944304526105059027058643e-30 2.366582715663035416235186e-30
K,S(0.25,2.0) resids = 0.0 1.514612938024342666390519e-27
K(0.1,14.0) = 0.00004812761579292214804889591
K(0.1,14.1) = 0.00001019550231964752534767062
K(0.1,14.2) = -0.0000236369122442162997556447
K(0.25,14.0) = 0.00003661507924554092885701267
K(0.25,14.1) = -0.0000005603368740259796883543041
K(0.25,14.2) = -0.0000336673540507255384833635
tuple form  theta= 0 :  Q = 5953.27220454455
tuple form  theta=15 :  Q = -5.93840474582715
```

Error accounting. The prime-power tail beyond \(6\times10^4\) is \(<10^{-22}\) (bound in the proof of Theorem B); the atom tail beyond \(\gamma_{12}\) is \(<10^{-400}\); the \(5.0\times10^{-11}\) excess of the atom term over \(1\) is \(2\hat g_0(\gamma_2)=2e^{-(\gamma_2-\gamma_1)^2/2}(1+o(1))\), as it should be; all quadratures are adaptive at 25 significant digits and every quantity is confirmed by a second, independent route (convolution vs closed form; direct vs Parseval; direct vs explicit formula; \(K,S\) integrals vs \(\xi\)).

---

## References

- B. Riemann, *Über die Anzahl der Primzahlen unter einer gegebenen Grösse* (1859) — the \(\Xi\) integral representation.
- A. Weil, *Sur les "formules explicites" de la théorie des nombres premiers*, Comm. Sém. Math. Lund (1952) — the explicit-formula pairing and the positivity criterion.
- E. Bombieri, *Remarks on Weil's quadratic functional in the theory of the Riemann zeta-function*, Rend. Mat. Acc. Lincei (2000) — Theorem C(3) in full rigour.
- H. Davenport, *Multiplicative Number Theory*, §17 — the contour estimates in Lemma 2.4.
- E. C. Titchmarsh, *The Theory of the Riemann Zeta-Function*, §9.4 (argument bounds), §10.1 (the \(\Phi\) expansion); H. M. Edwards, *Riemann's Zeta Function*, §1.8.
- H. Iwaniec, E. Kowalski, *Analytic Number Theory*, ch. 5 — the explicit formula in the even normalisation used here.
- D. Platt, T. Trudgian, *The Riemann hypothesis is true up to \(3\cdot10^{12}\)*, Bull. LMS (2021) — used only in the error accounting of §9.
- truths.md §§12, 15; publication.html Lemma 7.2; tensor.html — the objects under examination.

*20 August 2026. Written as the resolution of the request to prove \((\star)\): it cannot be proved, because it is false; what is true in its place is Weil's criterion, and the distance between the two is measured exactly by Theorem A.*
