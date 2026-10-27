# Frozen truths from `publication.html`

These statements are true, and the proofs do not depend on how path-closures or measures are later named. They will not be reopened by renaming “Identity L”, changing the balanced/unrestricted checklist, or rewriting the Hilbert-zoom prose.

This file is **not** a proof of the Riemann hypothesis. Anything that only holds after a definition of “balanced” or “unrestricted” is restated below as an inequality, or omitted.

Withdrawn falsehoods, so they are not put back:

- \(\int(1-R\varphi)(-\varphi)\,du=-\tfrac12\). False. The integral is \(-1+R\int\varphi^2\).
- The local diagonal of Section 6 is \(c_1=\tfrac12\) times \(\rho^2\). False.
- At an off-line zero, \(\lvert\eta_N^{(N^2)}(\rho)\rvert\ge c\,N^{1/2-\varepsilon}\) on the tightness range. False if such a zero exists: Corollary 4.3.1 gives the opposite upper bound \(\lvert\eta\rvert\ll(1+\lvert\gamma\rvert)N^{1-2\sigma}=o(N^{1/2-\varepsilon})\) for \(\sigma>\tfrac14+\varepsilon/2\).

---

## 1. Classical facts used as black boxes

**1.1.** \(\Xi(s)=\tfrac12 s(s-1)\pi^{-s/2}\Gamma(s/2)\zeta(s)\) and \(\Xi(s)=\Xi(1-s)\). The zeros of \(\Xi\) are exactly the non-trivial zeros of \(\zeta\).

**1.2.** Euler–Maclaurin (Titchmarsh §4.11; Montgomery–Vaughan Theorem 1.12): for \(x\ge 1\), \(\sigma\ge\sigma_0>0\), \(s\neq 1\),
\[
\sum_{n\le x}n^{-s}=\zeta(s)-\frac{x^{1-s}}{1-s}+\tfrac12 x^{-s}+O_{\sigma_0}\bigl((1+\lvert s\rvert)\,x^{-\sigma}\bigr).
\]
Keeping \(B_2=1/6\), the next remainder is \(O_{\sigma_0}(\lvert s\rvert^2 x^{-\sigma-1})\) in the usual form; after the algebra of Theorem 4.3 this is \(O(\lvert s\rvert^2 N^{-2\sigma})\) in \(\eta\).

**1.3.** Apostol: the periodic Bernoulli function satisfies \(\lvert\overline{B}_1\rvert\le\tfrac12\).

**1.4.** Montgomery–Vaughan (Hilbert’s inequality): for finitely supported \((a_m)\) and \(T\ge 1\),
\[
\int_0^T\Bigl\lvert\sum_m a_m m^{-it}\Bigr\rvert^2 dt=\sum_m\lvert a_m\rvert^2 T+\theta\cdot 2\pi\sum_m m\lvert a_m\rvert^2,
\quad\lvert\theta\rvert\le 1.
\]

**1.5.** The Fourier transform of \((1+t^2)^{-1}\) is \(\pi e^{-\lvert\xi\rvert}\).

**1.6.** Gallagher / Sobolev on the line: for \(F\in C^1(\mathbb{R})\) and \(H>0\),
\[
\lvert F(\gamma)\rvert^2\le\frac2H\int_0^H\lvert F(\gamma+u)\rvert^2\,du+2H\int_0^H\lvert F'(\gamma+u)\rvert^2\,du.
\]

**1.7.** Riemann–von Mangoldt: the number of zeros of \(\Xi\) with \(\lvert\gamma\rvert\le T\) is \(O(T\log T)\).

**1.8.** Stereographic projection from the north pole \(N=(0,0,1)\) onto the equatorial plane \(z=0\):
\[
\pi_N(x,y,z)=\frac{x+iy}{1-z},\qquad
\pi_N^{-1}(u+iv)=\Bigl(\frac{2(u+iv)}{1+u^2+v^2},\;\frac{u^2+v^2-1}{1+u^2+v^2}\Bigr).
\]
The south pole maps to the origin; \(N\) is the point at infinity. The round metric pulls back as \(2\lvert dw\rvert/(1+\lvert w\rvert^2)\). The spherical (Marty) derivative of a curve \(w(t)\) in \(\mathbb{C}\) is
\[
w^{\#}(t)=\frac{\lvert w'(t)\rvert}{1+\lvert w(t)\rvert^2}.
\]
Near \(w=0\), \(w^{\#}\sim\lvert w'\rvert\). Circles map to circles or lines; meridians through \(N\) map to straight lines through \(0\). Parallels (constant colatitude) map to concentric circles. The map is conformal, so a rhumb line (constant bearing) maps to a logarithmic spiral. (Page: `projection.html`.)

**1.9.** In spherical coordinates \(P=(\sin\theta\cos\varphi,\sin\theta\sin\varphi,\cos\theta)\) with colatitude \(\theta\in(0,\pi]\) measured from \(N\),
\[
\lvert\pi_N(P)\rvert=\cot(\theta/2).
\]
The equator \(\theta=\pi/2\) is the unit circle. The south pole \(\theta=\pi\) is the origin. As \(\theta\downarrow 0\), \(\lvert\pi_N(P)\rvert\to\infty\).

**1.10.** Chordal distance on the Riemann sphere from \(w\in\mathbb{C}\) to the origin:
\[
\chi(w,0)=\frac{\lvert w\rvert}{\sqrt{1+\lvert w\rvert^2}}.
\]
The height of the lift is \(z=(\lvert w\rvert^2-1)/(\lvert w\rvert^2+1)\). Southern hemisphere: \(\lvert w\rvert<1\). Equator: \(\lvert w\rvert=1\). Northern hemisphere: \(\lvert w\rvert>1\).

**1.11.** A regular \(N\)-gon inscribed in a circle of radius \(R\) has sagitta \(R\bigl(1-\cos(\pi/N)\bigr)=O(R N^{-2})\). The coarser bound “edge subtends angle \(O(N^{-1})\) on a fibre of radius \(O(1)\)” is \(O(N^{-1})\) in Hausdorff distance.

**1.12.** \(\zeta(\overline{s})=\overline{\zeta(s)}\) for real \(\sigma\) off the pole. Non-trivial zeros come in conjugate pairs. Combined with \(\Xi(s)=\Xi(1-s)\), they come in quadruples \(\{\rho,\,\overline{\rho},\,1-\rho,\,1-\overline{\rho}\}\) unless they lie on the critical line or the real axis (none of the latter are non-trivial).

**1.13.** Approximate functional equation dual lengths: the dual of a sum to \(x\) at height \(t\) has length \(\lvert t\rvert/(2\pi x)\). For \(x=N^2\) and \(x=N\), on the window \(\lvert t\rvert\le N^{1/2-\varepsilon}\) both lengths are \(<1\) for \(N\ge 3\). Those dual sums are empty.

**1.14.** \(\exp\bigl(-\lvert\log(m/n)\rvert\bigr)=\min(m,n)/\max(m,n)\) for \(m,n>0\).

**1.15.** Speiser: the Riemann hypothesis is equivalent to \(\zeta'\) having no zeros in \(0<\operatorname{Re}s<\tfrac12\). Recorded as a classical equivalence, not as a theorem of this construction.

---

## 2. The integer filter and the Dirichlet polynomial

**2.1.** For \(N\ge 2\),
\[
c_m^{(N)}=\begin{cases}1&N\nmid m,\\1-N&N\mid m.\end{cases}
\]
For \(\operatorname{Re}s>1\),
\[
\sum_{m=1}^\infty c_m^{(N)}m^{-s}=(1-N^{1-s})\zeta(s),
\]
and the identity continues meromorphically. The factor \(1-N^{1-s}\) vanishes only on \(\operatorname{Re}s=1\).

**2.2.** Write \(D_x(s)=\sum_{n\le x}n^{-s}\). Then, identically as Dirichlet polynomials,
\[
\eta_N^{(N^2)}(s)=D_{N^2}(s)-N^{1-s}D_N(s)=\sum_{m=1}^{N^2}c_m^{(N)}m^{-s}.
\]

**2.3.** On the truncated strip \(S_\delta=\{\delta\le\sigma\le 1-\delta\}\) with \(\delta\in(0,1/4)\),
\[
\lvert 1-N^{1-s}\rvert\ge N^{1-\sigma}-1.
\]

**2.4.** For each fixed \(\sigma\), the map \(t\mapsto\eta_N^{(N^2)}(\sigma+it)\) is a trigonometric polynomial, hence real-analytic \(\mathbb{R}\to\mathbb{C}\).

**2.5.** Coefficient sums for the spikes: there are \(N\) multiples of \(N\) up to \(N^2\), each with \(\lvert c_m\rvert=N-1\), so
\[
\sum_{m\le N^2}\lvert c_m\rvert^2\asymp N^3,\qquad
\sum_{m\le N^2}\frac{\lvert c_m\rvert^2}{m}\asymp N\log N.
\]
Mean-zero cancellation is in \(\sum c_m m^{-s}\), not in \(\sum\lvert c_m\rvert^2\). The diagonal of the \(L^2\) mean is not \(O(1)\).

**2.6.** \(\eta_N^{(N^2)}\) is an entire function (a Dirichlet polynomial of length \(N^2\)). It has finitely many zeros. The integer \(N\) may be even or odd; 2.1–2.5 do not use parity.

**2.7.** Because \(N\mid N^2\), one has \(c_{N^2}^{(N)}=1-N\). If the sharp truncation is differentiated in a continuous radius \(R\) through the Leibniz boundary term \(B=c_{\lfloor R^2\rfloor}(R^2)^{-1/2-i\gamma}\cdot 2R\), then at integer \(R=N\) on the critical line \(\lvert B\rvert=2(N-1)\). The integer Euler–Maclaurin theorems do not use \(B\).

**2.8.** The modulus of the order-zero boundary term is exact:
\[
\bigl\lvert\tfrac12(1-N)N^{-2s}\bigr\rvert=\tfrac12(N-1)N^{-2\sigma}.
\]
Its argument is \(\pi-2\gamma\log N\) (since \(1-N<0\)).

---

## 3. Euler–Maclaurin for \(\eta\)

**3.1 (Theorem 4.1).** For \(N\ge 2\) and all real \(t\),
\[
\eta_N^{(N^2)}\bigl(\tfrac12+it\bigr)=(1-N^{1/2-it})\zeta\bigl(\tfrac12+it\bigr)+O(1+\lvert t\rvert),
\]
with an absolute implied constant \(C_1\). Polar terms cancel because \((N^2)^{1-s}=N^{1-s}\cdot N^{1-s}\). At a critical-line zero,
\[
\bigl\lvert\eta_N^{(N^2)}(\tfrac12+i\gamma)\bigr\rvert\le C_1(1+\lvert\gamma\rvert).
\]

**3.2 (Theorem 4.3).** For \(\sigma\in[\sigma_0,1-\sigma_0]\), \(\sigma_0\in(0,1/2)\), \(s\neq 1\),
\[
\eta_N^{(N^2)}(s)=(1-N^{1-s})\zeta(s)+\tfrac12(1-N)N^{-2s}+O_{\sigma_0}\bigl((1+\lvert s\rvert)\,N^{1-2\sigma}\bigr).
\]
In particular
\[
\eta_N^{(N^2)}(s)=(1-N^{1-s})\zeta(s)+O_{\sigma_0}\bigl((1+\lvert s\rvert)\,N^{1-2\sigma}\bigr).
\]

**3.3 (Proposition 4.2).** For truncation \(M=N^\alpha\), polar terms cancel if and only if \(\alpha=2\). Only \(\alpha=2\) at \(\sigma=\tfrac12\) makes the error \(O(1+\lvert t\rvert)\) while the prefactor of \(\zeta\) has size \(N^{1/2}\).

**3.4 (Lemma 4.5).** Differentiating 3.2 in the height,
\[
\partial_t\eta_N^{(N^2)}(s)
=i(1-N^{1-s})\zeta'(s)+i(\log N)\,N^{1-s}\zeta(s)
-i(\log N)(1-N)N^{-2s}
+O_{\sigma_0}\bigl((1+\lvert s\rvert)(\log N)\,N^{1-2\sigma}\bigr).
\]

---

## 4. Size of \(\eta\) at zeros of \(\Xi\)

Throughout, \(\rho=\sigma+i\gamma\) is a zero of \(\Xi\) (hence of \(\zeta\)).

**4.1 (Corollary 4.1.1).** If \(\sigma=\tfrac12\) and \(\varepsilon\in(0,1/4)\), then
\[
\bigl\lvert\eta_N^{(N^2)}(\rho)\bigr\rvert\le N^{1/2-\varepsilon}
\]
for all integers \(N\ge N_0(\gamma)=\bigl(C_1(1+\lvert\gamma\rvert)\bigr)^{2/(1-2\varepsilon)}\). In particular \(\log N_0(\gamma)\ll\log(2+\lvert\gamma\rvert)\).

**4.2.** For all critical-line zeros with \(\lvert\gamma\rvert\le T\), the same bound holds uniformly for \(N\ge N_0(T)=\bigl(C_1(1+T)\bigr)^{2/(1-2\varepsilon)}\). There are \(O(T\log T)\) such zeros.

**4.3 (Corollary 4.3.1).** In the strip \(\sigma\in[\sigma_0,1-\sigma_0]\),
\[
\bigl\lvert\eta_N^{(N^2)}(\rho)\bigr\rvert\ll(1+\lvert\gamma\rvert)\,N^{1-2\sigma}.
\]
This is \(\le N^{1/2-\varepsilon}\) as soon as \((1+\lvert\gamma\rvert)N^{1-2\sigma}\le N^{1/2-\varepsilon}\). For each **fixed** such \(\rho\) with \(\sigma>\tfrac14+\varepsilon/2\), this happens for all large \(N\).

**4.4 (Corollary 4.3.2).** Fix \(\varepsilon\in(0,1/6)\). If \(\lvert\gamma\rvert\le N^{1/2-\varepsilon}\) and \(N\) is large enough (uniformly in that range of \(\gamma\)), then
\[
\bigl\lvert\eta_N^{(N^2)}(\rho)\bigr\rvert\ge\tfrac14\,N^{1-2\sigma}.
\]
Reason: the explicit half-term has size \(\tfrac12(N-1)N^{-2\sigma}\); the next Euler–Maclaurin remainder is \(O(\lvert\gamma\rvert^2 N^{-2\sigma})\); the ratio is \(O(\lvert\gamma\rvert^2/N)=O(N^{-2\varepsilon})\). Consequently a zero in this height window with \(\sigma\le\tfrac14-\varepsilon/2\) cannot satisfy \(\lvert\eta\rvert\le N^{1/2-\varepsilon}\).

**4.5.** The three comparison scales
\[
P_N(s)=\lvert 1-N^{1-s}\rvert,\qquad
F_N(s)=(1+\lvert t\rvert)\,N^{1-2\sigma},\qquad
D_N=N^{1/2-\varepsilon}
\]
satisfy \(\lvert\eta\rvert=P_N\lvert\zeta\rvert+O(F_N)\). They are of the same order (up to \(1+\lvert t\rvert\)) if and only if \(\sigma=\tfrac12\).

**4.6.** At a zero, the relative size of the remainder against the prefactor is
\[
\frac{F_N(\rho)}{P_N(\rho)}\ll(1+\lvert\gamma\rvert)N^{-\sigma}.
\]
This is \(\le N^{-\varepsilon}\) once \(N^{\sigma-\varepsilon}\ge 1+\lvert\gamma\rvert\). For each **fixed** \(\rho\) with \(\sigma>0\), that happens for all large \(N\).

**4.7.** On the window \(\lvert\gamma\rvert\le N^{1/2-\varepsilon}\) one has \(\lvert\gamma\rvert^2/N\le N^{-2\varepsilon}\). This is the only input that makes the \(B_2\) remainder smaller than the half-term in 4.4.

**4.8.** For \(\sigma>\tfrac12\) and \(\lvert\gamma\rvert\) fixed, \(\lvert\eta(\rho)\rvert\ll N^{1-2\sigma}\to 0\). For \(\sigma<\tfrac12\) and \(\lvert\gamma\rvert\) in the window of 4.4, \(\lvert\eta(\rho)\rvert\to\infty\). For \(\sigma=\tfrac12\), \(\lvert\eta(\rho)\rvert\) stays \(O(1+\lvert\gamma\rvert)\), independent of \(N\).

---

## 5. Derivatives of \(\eta\) at zeros of \(\Xi\)

**5.1 (Lemma 4.5.1).** If \(\zeta(\tfrac12+i\gamma)=0\), then
\[
\bigl\lvert\partial_t\eta_N^{(N^2)}(\tfrac12+i\gamma)\bigr\rvert
\le N^{1/2}\lvert\zeta'(\tfrac12+i\gamma)\rvert+O\bigl((1+\lvert\gamma\rvert)\log N\bigr).
\]
For each **fixed** such \(\gamma\) and each \(\varepsilon>0\), this is \(\le N^{1/2+\varepsilon}\) for all large \(N\).

**5.2 (Lemma 4.5.2).** If \(\rho\) is a **simple** zero in the interior of \(S_\delta\), there is \(N_1(\rho)\) such that for \(N\ge N_1(\rho)\) and all \(s\) with \(\lvert s-\rho\rvert\le N^{-\varepsilon}\),
\[
\bigl\lvert\partial_t\eta_N^{(N^2)}(s)\bigr\rvert\ge\tfrac12 N^{1-\sigma}\lvert\zeta'(\rho)\rvert.
\]
If also \(\sigma\le\tfrac12-\delta\) with \(\delta>\varepsilon\), the right-hand side exceeds \(N^{1/2+\varepsilon}\) for all large \(N\).

**5.3 (Lemma 4.5.3).** If \(\rho\) has multiplicity \(m\ge 1\), the same disk and the same \(N\)-threshold (now depending on \(\rho\) and \(m\)) give
\[
\bigl\lvert\partial_t^{\,m}\eta_N^{(N^2)}(s)\bigr\rvert\ge\tfrac12 N^{1-\sigma}\lvert\zeta^{(m)}(\rho)\rvert.
\]
If \(\sigma\le\tfrac12-\delta\) with \(\delta>\varepsilon\), this exceeds \(N^{1/2+\varepsilon}(2\log N)^m\) for all large \(N\).

**5.4.** Therefore: no point of the isolation disk of a simple zero with \(\sigma\le\tfrac12-\varepsilon\) can satisfy \(\lvert\partial_t\eta\rvert\le N^{1/2+\varepsilon}\) for all large \(N\). No point of the isolation disk of a zero of multiplicity \(m\) with \(\sigma\le\tfrac12-\varepsilon\) can satisfy \(\lvert\partial_t^m\eta\rvert\le N^{1/2+\varepsilon}(2\log N)^m\) for all large \(N\).

These are statements about the Dirichlet polynomial \(\eta\), not about the Riemann hypothesis.

---

## 6. Mean values of \(\eta\)

**6.1.** On the critical line, Montgomery–Vaughan and 2.5 give
\[
\int_{-T}^T\bigl\lvert\eta_N^{(N^2)}(\tfrac12+it)\bigr\rvert^2 dt\ll TN\log N+N^3.
\]

**6.2 (Lemma 7.2).** Exactly,
\[
\int_{\mathbb{R}}\frac{\bigl\lvert\eta_N^{(N^2)}(\tfrac12+it)\bigr\rvert^2}{1+t^2}\,dt
=\pi\sum_{m,n\le N^2}c_m\overline{c}_n\,(mn)^{-1/2}\frac{\min(m,n)}{\max(m,n)}.
\]
The diagonal is \(\pi\sum\lvert c_m\rvert^2/m\asymp\pi N\log N\). There is no \(N^3\) remainder in this weighted identity.

**6.3.** Lemma 7.3 applied to \(F(t)=\eta_N^{(N^2)}(\tfrac12+it)\) with \(H=1/\log N\) costs two logarithms relative to the local \(L^2\) mean. It does not produce a factor \(N^{-1}\). Depth at zeros is 4.1, not this lemma.

---

## 7. Local diagonal of the continuous filter (what it actually is)

**7.1.** For the interpolated coefficients \(c_m(R)=1-R\sum_k\varphi(m/R-k)\) with \(\varphi\in C_c^\infty([-1,1])\), \(\int\varphi=1\), the map \(R\mapsto\eta_R(R^2)(s)\) is \(C^1\) on \([2,\infty)\) for each fixed \(s\) with \(\operatorname{Re}s\in(0,1)\), with majorant \(\sum_{m\le R^2}\lvert\partial_R(c_m m^{-s})\rvert\ll_\varphi R^{1-\sigma}\log R\). The sharp integer truncation is only piecewise \(C^1\).

**7.2.** On a packet \(I_k=[(k-1)R,(k+1)R]\),
\[
\sum_{m\in I_k}c_m(R)\,(\partial_R c_m(R))\,m^{-1}
=-\int_{-1}^{1}\frac{\varphi(u)}{k+u}\,du+R\int_{-1}^{1}\frac{\varphi(u)^2}{k+u}\,du+R_{\mathrm{EM}}^{(k)},
\]
and summing in \(k\) produces \(R(\int\varphi^2)\log R+O_\varphi(R)\) plus Apostol remainders. This is not a multiple of \(R^{-1}\rho^2\). The integer depth bound 4.1 does not pass through this form.

---

## 8. Stereographic comparison (classical, applied to \(\eta\))

Let \(w(t)=\eta_N^{(N^2)}(\sigma+it)\). Write
\[
\eta^{\#}(\sigma+it)=\frac{\lvert\partial_t\eta_N^{(N^2)}(\sigma+it)\rvert}{1+\lvert\eta_N^{(N^2)}(\sigma+it)\rvert^2}.
\]

**8.1.** If \(\lvert w\rvert\to\infty\), then \(\pi_N^{-1}(w)\) tends to the north pole. If \(w=0\), the lift is the south pole.

**8.2.** Combined with 4.4: at a zero with \(\sigma<\tfrac12\) and \(\lvert\gamma\rvert\le N^{1/2-\varepsilon}\), for large \(N\), \(\lvert\eta(\rho)\rvert\ge\tfrac14 N^{1-2\sigma}\to\infty\), so the lift of the endpoint **at \(\rho\)** tends to the north pole.

**8.3.** Combined with 5.2: at a local minimiser in the isolation disk of a simple zero with \(\sigma\le\tfrac12-\varepsilon\), \(\lvert\eta\rvert\) is small (so \(\eta^{\#}\sim\lvert\partial_t\eta\rvert\)) and \(\eta^{\#}>N^{1/2+\varepsilon}\) for large \(N\).

**8.4.** At a simple zero with \(\sigma>\tfrac12\), the same expansion gives \(\lvert\partial_t\eta\rvert\asymp N^{1-\sigma}\lvert\zeta'(\rho)\rvert\), which is \(o(N^{1/2+\varepsilon})\) because \(1-\sigma<\tfrac12\).

**8.5.** At a simple zero with \(\sigma<\tfrac12\), on the tightness window, the Marty speed **at \(\rho\) itself** (not at a nearby minimiser) is
\[
\eta^{\#}(\rho)\asymp\frac{N^{1-\sigma}}{1+N^{2-4\sigma}}\asymp N^{3\sigma-1}.
\]
The exponent \(3\sigma-1\) is negative for \(\sigma<\tfrac13\) and positive for \(\tfrac13<\sigma<\tfrac12\). This does not cancel 8.3: at a minimiser with \(\lvert\eta\rvert\) small, the denominator is \(1+o(1)\) and the speed is \(N^{1-\sigma}\).

**8.6.** Near \(w=0\) the spherical metric is \(2\lvert dw\rvert\) up to \(1+O(\lvert w\rvert^2)\). Euclidean speed \(\lvert\partial_t\eta\rvert\) and spherical speed \(\eta^{\#}\) therefore coincide, up to a factor \(2+o(1)\), at any point where \(\eta\to 0\).

---

## 9. Arithmetic about prefactors (no measures)

**9.1.** \(P_N(s)\ge N^{1-\sigma}-1\). The inequality \(P_N(s)\ge N^{1/2-\varepsilon/2}\) forces \(\sigma\le\tfrac12+\varepsilon/2\) for large \(N\).

**9.2.** On \(\sigma=\tfrac12\), \(P_N\asymp N^{1/2}\), so \(\lvert\eta\rvert\le P_N N^{-\varepsilon}\) and \(\lvert\eta\rvert\le N^{1/2-\varepsilon}\) are the same comparison up to constants.

**9.3.** Isolation packing is arithmetic. On \(O(N^{\kappa})\) vertical grid lines, with isolation radius \(N^{-\kappa}\) and tempering \((1+t^2)^{-1}\),
\[
N^{2\kappa}\int_{N^{1/2-\varepsilon}}^\infty\frac{dt}{1+t^2}\ll N^{2\kappa-1/2+\varepsilon}.
\]
If \(\kappa=\varepsilon\in(0,1/6)\), the exponent is \(3\varepsilon-1/2<0\).

**9.4.** If a residual density on \(S_\delta\) is defined by
\[
\rho_N(\sigma+it)=\frac1N\min\bigl(1,\lvert\eta_N^{(N^2)}(\sigma+it)\rvert^2\bigr)\,(1+\lvert s\rvert^2)^{-1},
\]
then \(\int_{S_\delta}\rho_N=O(N^{-1})\), because \(\int_{S_\delta}(1+\lvert s\rvert^2)^{-1}\,d\sigma\,dt\ll 1\). This is the factor \(1/N\), not a theorem about \(\zeta\).

**9.5.** Analyticity: if \(\rho\) is a simple zero and \(\lvert\sigma_N-\sigma\rvert\le N^{-\kappa}\), then \(\zeta(\sigma_N+i\gamma)=O_\rho(N^{-\kappa})\). The leaked main term at the nearest grid abscissa is \(O_\rho(P_N N^{-\kappa})\). For \(\kappa=\varepsilon\) this is the same order as the relative threshold \(P_N N^{-\varepsilon}\).

---

## 10. Rouché for \(\eta\) versus \((1-N^{1-s})\zeta\)

**10.1.** On the circle \(\lvert s-\rho\rvert=N^{-\kappa}\) about a zero of multiplicity \(m<\infty\), \(\lvert\zeta(s)\rvert\asymp_\rho N^{-\kappa}\). Theorem 4.3 gives \(\lvert\eta-(1-N^{1-s})\zeta\rvert=O(F_N)\). The main term has size \(P_N\lvert\zeta\rvert\asymp_\rho N^{1-\sigma-\kappa}\). This dominates \(F_N\asymp(1+\lvert\gamma\rvert)N^{1-2\sigma}\) once
\[
N^{\sigma-\kappa}\gg 1+\lvert\gamma\rvert.
\]
For each **fixed** \(\rho\) with \(\sigma>\kappa\), this holds for all large \(N\). Rouché then equates the number of zeros of \(\eta_N^{(N^2)}\) inside the disk with the multiplicity of \(\rho\), because \(1-N^{1-s}\) has no zero in \(S_\delta\).

**10.2.** Dirichlet polynomials may have additional zeros in \(S_\delta\) besides those captured by 10.1. That is not a contradiction: they are zeros of \(\eta\), not of \(\zeta\).

---

## 11. Last-chord pairing (algebra, then zeros)

The order-zero Euler–Maclaurin boundary term of Theorem 4.3 is the unmatched last chord of the polygon,
\[
H_N(s)=\tfrac12(1-N)N^{-2s}.
\]
Nothing in this section names a measure.

**11.1.** For every complex \(s\) and every integer \(N\ge 2\),
\[
H_N(s)\,H_N(1-s)=\frac{(N-1)^2}{4N^2}.
\]
The right-hand side is real, positive, and independent of \(s\). In particular
\[
\bigl\lvert H_N(s)\bigr\rvert\cdot\bigl\lvert H_N(1-s)\bigr\rvert=\frac{(N-1)^2}{4N^2}\to\tfrac14.
\]
Proof: \(N^{-2s}N^{-2(1-s)}=N^{-2}\), and \((1-N)^2=(N-1)^2\).

**11.2.** The same identity in moduli, written at a point and its twin:
\[
\bigl\lvert H_N(\sigma+it)\bigr\rvert=\tfrac12(N-1)N^{-2\sigma},\qquad
\bigl\lvert H_N(1-\sigma-it)\bigr\rvert=\tfrac12(N-1)N^{2\sigma-2}.
\]
The two sizes are equal if and only if \(\sigma=\tfrac12\). One tends to \(0\) and the other to \(\infty\) if and only if \(\sigma\neq\tfrac12\).

**11.3 (Two-sided last chord at zeros, tightness window).** Let \(\rho=\sigma+i\gamma\) be a zero of \(\Xi\), and let \(\varepsilon\in(0,1/6)\). On the window \(\lvert\gamma\rvert\le N^{1/2-\varepsilon}\), the proof of Corollary 4.3.2 gives more than a floor: the \(B_2\) term is \(O(\lvert\gamma\rvert N^{-2\sigma})\) and the next remainder is \(O(\lvert\gamma\rvert^2 N^{-2\sigma})\), so
\[
\eta_N^{(N^2)}(\rho)=H_N(\rho)\bigl(1+\theta_N(\rho)\bigr),\qquad
\lvert\theta_N(\rho)\rvert=O(N^{-2\varepsilon}).
\]
The same expansion holds at \(1-\rho\), with the same \(O(N^{-2\varepsilon})\), because \(\lvert\operatorname{Im}(1-\rho)\rvert=\lvert\gamma\rvert\). Consequently, for all large \(N\),
\[
\bigl\lvert\eta_N^{(N^2)}(\rho)\bigr\rvert=\tfrac12(N-1)N^{-2\sigma}\bigl(1+O(N^{-2\varepsilon})\bigr).
\]
This is two-sided. The floor 4.4 is the lower half; the matching upper bound on the same window is \(\lvert\eta(\rho)\rvert\le N^{1-2\sigma}\). The coarse bound 4.3 remains valid off the window.

**11.4 (Product at twins).** Under the hypotheses of 11.3,
\[
\eta_N^{(N^2)}(\rho)\,\eta_N^{(N^2)}(1-\rho)
=\frac{(N-1)^2}{4N^2}\bigl(1+O(N^{-2\varepsilon})\bigr).
\]
The product is therefore real and positive in the limit, and tends to \(\tfrac14\), independently of \(\sigma\) and of \(\gamma\). This uses only Euler–Maclaurin at a pair of zeros related by 1.1, on the tightness window. It does not use the Riemann hypothesis.

**11.5 (Dichotomy).** Still on that window, exactly one of the following holds.

- \(\sigma=\tfrac12\): both \(\lvert\eta(\rho)\rvert\) and \(\lvert\eta(1-\rho)\rvert\) tend to \(\tfrac12\).
- \(\sigma>\tfrac12\): \(\lvert\eta(\rho)\rvert\to 0\) and \(\lvert\eta(1-\rho)\rvert\to\infty\).
- \(\sigma<\tfrac12\): \(\lvert\eta(\rho)\rvert\to\infty\) and \(\lvert\eta(1-\rho)\rvert\to 0\).

In all three cases the product tends to \(\tfrac14\). Both residuals remain of order one if and only if \(\sigma=\tfrac12\).

**11.6.** Combined with 8.1–8.2: the twin whose residual tends to \(\infty\) lifts to the north pole; the twin whose residual tends to \(0\) lifts to the south pole. An off-line quadruple therefore produces one northern blow-up and one southern envelope collapse. The northern blow-up is not an atom of either geometric family (Lemma 4.8 / 8.3). The southern collapse is a right-half unrestricted atom.

---

## 12. First principles of the cosine kernel

Notation in this section follows the classical \(t\)-picture. The function \(\Xi(s)\) of 1.1, restricted to the critical line and written as a function of height, is
\[
\Xi_{\mathrm{cos}}(t):=\Xi\bigl(\tfrac12+it\bigr).
\]
Zeros of \(\Xi_{\mathrm{cos}}\) are exactly the non-trivial zeros of \(\zeta\), read in the coordinate \(t=-i(s-\tfrac12)\). A non-real zero of \(\Xi_{\mathrm{cos}}\) is an off-line zero of \(\Xi\).

**12.1 (Riemann).** There is an even, real, rapidly decreasing function \(\Phi\), given by the Jacobi theta expansion
\[
\Phi(u)=\sum_{n=1}^\infty\bigl(2\pi^2 n^4 e^{9u/2}-3\pi n^2 e^{5u/2}\bigr)\exp(-\pi n^2 e^{2u}),
\]
such that \(\Phi(u)>0\) for all real \(u\), \(\Phi(-u)=\Phi(u)\), and
\[
\Xi_{\mathrm{cos}}(t)=c\int_0^\infty\Phi(u)\cos(tu)\,du
\]
for an absolute constant \(c\neq 0\). The constant does not move zeros. Super-exponential decay of \(\Phi\) makes \(\Xi_{\mathrm{cos}}\) entire of order one. Evenness of \(\Phi\) makes \(\Xi_{\mathrm{cos}}\) even. Reality of \(\Phi\) makes \(\Xi_{\mathrm{cos}}\) real on the real axis.

**12.2.** The identity \(\Xi(s)=\Xi(1-s)\) is the statement that \(\Xi_{\mathrm{cos}}\) is even. Conjugation 1.12 is the statement that \(\Xi_{\mathrm{cos}}(\overline{t})=\overline{\Xi_{\mathrm{cos}}(t)}\). Off-line zeros therefore come in quadruples, which in the \(t\)-plane are \(\{\,t,\,-t,\,\overline{t},\,-\overline{t}\,\}\).

**12.3 (Off-line zero as a hyperbolic cosine moment).** Write \(t=\gamma-i\alpha\) with \(\alpha=\sigma-\tfrac12\) real. Evenness of \(\Phi\) expands the cosine transform as
\[
\Xi_{\mathrm{cos}}(\gamma-i\alpha)=c\int_0^\infty\Phi(u)\cosh(\alpha u)\cos(\gamma u)\,du.
\]
A zero with \(\sigma\neq\tfrac12\) is exactly the vanishing of this moment for some \(\alpha\neq 0\). The weight \(\cosh(\alpha u)\) is even, convex, and strictly greater than \(1\) for \(u\neq 0\).

**12.4 (What positivity of \(\Phi\) does not give).** \(\Phi>0\) and even does not force \(\Xi_{\mathrm{cos}}\) to have only real zeros. The Fourier cosine transform of a positive even bump may have non-real zeros. Log-concavity of \(\Phi\) (the kernel \(\Phi(x-y)\) totally positive of order \(2\)) is likewise insufficient: \(e^{-u^4}\) is positive, even, and log-concave, and its cosine transform has non-real zeros. The Gaussian \(e^{-u^2}\) is the boundary case: it is totally positive of every order, and its cosine transform has no zeros at all.

**12.5 (What does force real zeros).** If \(\Phi(x-y)\) is totally positive of every order (a Pólya frequency function of order \(\infty\)), then \(\Xi_{\mathrm{cos}}\) lies in the Laguerre–Pólya class, hence has only real zeros (Schoenberg). This is a sufficient condition for the Riemann hypothesis, not a necessary one: Laguerre–Pólya does not imply that the inverse Fourier transform is a Pólya frequency function.

**12.6 (Equivalences, classical).** The following are equivalent to the Riemann hypothesis. They are recorded as equivalences, not as theorems of the Dirichlet polygon.

1. Every non-trivial zero of \(\zeta\) has real part \(\tfrac12\).
2. \(\Xi_{\mathrm{cos}}\) has only real zeros.
3. \(\Xi_{\mathrm{cos}}\) lies in the Laguerre–Pólya class.
4. Weil positivity: the explicit-formula pairing \(W(h)\ge 0\) for the Weil class of test functions.
5. de Bruijn–Newman: \(\Lambda\le 0\). Combined with Rodgers–Tao \(\Lambda\ge 0\), this is \(\Lambda=0\).
6. Speiser: \(\zeta'\) has no zero in \(0<\operatorname{Re}s<\tfrac12\) (already 1.15).
7. In the language of `publication.html`, after Lemma 4.8: \(\operatorname{supp}\nu=\operatorname{supp}\mu\), equivalently \(\nu\) has no atom with real part greater than \(\tfrac12\).

**12.7.** The quadratic truncation \(\alpha=2\) of Proposition 4.2 is the discrete Poisson scale: the approximate-functional-equation dual of a sum to \(N^2\) at height \(\lvert t\rvert\le N^{1/2-\varepsilon}\) is empty (1.13). That is why the last chord is a pure boundary term \(H_N(s)\) rather than a dual Dirichlet polynomial. The cosine kernel and the mean-zero filter see the same self-dual length.

---

## 13. The sieve, from adjacent truths

No new estimate. The statements below are 11.5, 8.1–8.4, 12.3, and 12.6 rewritten as a single filter.

**13.1.** On the tightness window the last chord is the only surviving scale at a zero of \(\Xi\). Its size is \(N^{1-2\sigma}\) on one twin and \(N^{2\sigma-1}\) on the other. The unique abscissa at which both twins remain of order one is \(\sigma=\tfrac12\). That is 4.5 and 11.5.

**13.2.** Finite Marty speed at both twins is possible only at that abscissa. At an off-line quadruple, one twin is a north-pole blow-up (speed either too large at a minimiser, or the endpoint itself tends to \(N\)) and the other is a south-pole collapse at speed \(N^{1-\sigma}=o(N^{1/2+\varepsilon})\). The geometric families keep the southern twin as an unrestricted atom and discard the northern twin. That is 11.6.

**13.3.** In the cosine picture the same dichotomy is 12.3: the weight \(\cosh(\alpha u)\) is identically \(1\) if and only if \(\alpha=0\). For \(\alpha\neq 0\) the moment \(\int\Phi(u)\cosh(\alpha u)\cos(\gamma u)\,du\) is a strictly reweighted copy of the critical-line transform. Vanishing of the reweighted moment is the off-line zero.

**13.4.** Therefore the following four writings name one and the same remaining statement.

- A right-half atom of \(\nu\).
- A twin pair at which one last chord tends to \(0\) and the other to \(\infty\).
- A non-real zero of the cosine transform of \(\Phi\).
- Failure of Weil positivity for some test function.

The Riemann hypothesis is the assertion that this statement is false. The Dirichlet polygon, the north-pole chart, and the last-chord product do not decide it. They locate it: the only scale at which a zero can exist as a pair of finite spherical speeds is the self-dual scale \(\sigma=\tfrac12\), and the only kernel whose cosine transform is \(\Xi_{\mathrm{cos}}\) is \(\Phi\).

**13.5.** The equation that would kill off-line zeros is the non-vanishing of 12.3 for \(\alpha\neq 0\). It is not proved here.

> **Further research.** A proof, had it existed here, would have been a proof that \(\int\Phi(u)\cosh(\alpha u)\cos(\gamma u)\,du\) cannot vanish for \(\alpha\neq 0\). Writing that sentence as a theorem would be lying. The adjacent truths define the object; they do not force \(\Phi\) to be in the class that kills non-real zeros. The place that sentence would have to occupy is §15.

---

## 14. What is true because it is, not because it is wished

**14.1.** The last-chord product 11.1 exists for every \(s\), zeros or not. It is an identity of two monomials.

**14.2.** The two-sided tracking 11.3 exists at every zero of \(\Xi\) on the tightness window, zeros off the line included. Euler–Maclaurin does not wait for the Riemann hypothesis.

**14.3.** The function \(\Phi\) exists, is positive, and is even. Riemann wrote the series. The cosine representation 12.1 exists. The zeros of \(\zeta\) exist (Hadamard, von Mangoldt). Their number up to height \(T\) is \(O(T\log T)\).

**14.4.** The unique self-dual abscissa of the filter, of the last chord, of the three scales \(P_N,F_N,D_N\), and of the cosine weight \(\cosh(\alpha u)\), is \(\sigma=\tfrac12\). That uniqueness is proved. It is not the statement that every zero lies there.

**14.5.** If a non-trivial zero lies off the line, it still has to occupy the twin geometry of 11.5–11.6 and the hyperbolic-cosine moment of 12.3. That occupation is the definition of an off-line zero, not a contradiction. The contradiction that would be the Riemann hypothesis is the additional claim that this occupation cannot occur for this \(\Phi\). The adjacent truths do not supply that claim.

---

## 15. Where the solution of that equation sits

Write
\[
K(\alpha,\gamma)=\int_0^\infty\Phi(u)\cosh(\alpha u)\cos(\gamma u)\,du.
\]
By 12.3, an off-line zero is a pair \((\alpha,\gamma)\) with \(\alpha\neq 0\) and \(K(\alpha,\gamma)=0\). The equation that would kill off-line zeros is \(K(\alpha,\gamma)\neq 0\) for all \(\alpha\neq 0\) and all real \(\gamma\). This section locates that equation. It does not solve it.

**15.1 (The \(\gamma=0\) slice, solved).** For every real \(\alpha\),
\[
K(\alpha,0)=\int_0^\infty\Phi(u)\cosh(\alpha u)\,du>0,
\]
because the integrand is positive. There is no cancellation. In the \(s\)-plane this is \(\Xi(\sigma)\neq 0\) for \(\sigma\) real. It is the same kind of object as 11.1: an identity, not a wish. Oscillation is absent, positivity of \(\Phi\) wins.

**15.2 (The \(\alpha=0\) slice, correctly vanishing).** \(K(0,\gamma)\) is a constant multiple of \(\Xi_{\mathrm{cos}}(\gamma)\). It vanishes at the on-line zeros. Oscillation beats positivity on that slice, and is supposed to. A criterion that forbade all zeros (a positive mixture of Gaussians, 12.4) is too strong: it would contradict 1.7.

**15.3 (The mixed slice is a sign law).** For each fixed \(\alpha\), \(\gamma\mapsto K(\alpha,\gamma)\) is real-analytic and even. A real-analytic real function vanishes if and only if it changes sign. Killing off-line zeros at that \(\alpha\) is the assertion that \(K(\alpha,\cdot)\) does not change sign.

**15.4 (\(L^2\) does not sit here).** Parseval gives
\[
\int_{\mathbb{R}}K(\alpha,\gamma)^2\,d\gamma \;\asymp\; \int_0^\infty\Phi(u)^2\cosh^2(\alpha u)\,du>0.
\]
The right-hand side is increasing in \(\lvert\alpha\rvert\) and never zero. This is an envelope, not a pointwise law. It is the same distinction as the withdrawn envelope of Identity L against the speed that actually locates left-half zeros: an integral can stay large while the integrand crosses zero.

**15.5 (Moments of \(\Phi\) exist).** Super-exponential decay of \(\Phi\) makes every even moment finite:
\[
m_{2k}=\int_0^\infty\Phi(u)\,u^{2k}\,du<\infty,\qquad k=0,1,2,\ldots.
\]
The Taylor series of the cosine transform at the origin is these moments:
\[
\Xi_{\mathrm{cos}}(t)=c\sum_{k=0}^\infty(-1)^k\frac{m_{2k}}{(2k)!}\,t^{2k}.
\]
The constant term is \(c\,m_0=c K(0,0)>0\), which is 15.1 at \(\alpha=0\). Each higher \(m_{2k}\) is the next order of oscillation about \(t=0\).

**15.6 (The solution sits in this jet).** The Jensen polynomials built from the coefficients \(m_{2k}\) are real-rooted for every degree if and only if \(\Xi_{\mathrm{cos}}\) lies in the Laguerre–Pólya class (Pólya). That class membership is 12.6.3, hence equivalent to the Riemann hypothesis. The object that would kill off-line zeros is therefore the hyperbolicity of the whole Jensen tower of the moment sequence of \(\Phi\). The moments exist because \(\Phi\) exists. Hyperbolicity of every degree is the remaining statement.

The first two steps of the tower are already visible: \(m_0>0\) is 15.1; \(m_2=\int\Phi(u)u^2\,du\) is the second variation of \(K\) in \(\alpha\) at \(\alpha=0\),
\[
\partial_\alpha^2 K(0,\gamma)=\int_0^\infty\Phi(u)\,u^2\cos(\gamma u)\,du,
\]
which is the cosine transform of \(u^2\Phi(u)\). Evenness in \(\alpha\) kills the first variation. The obstruction to zeros leaving the line starts at this second moment and continues through the Hankel forms of \((m_{2k})\).

**15.7 (The same jet, written at the filter’s kernel).** The elementary factor \(1-N^{1-s}\) vanishes on \(\operatorname{Re}s=1\) and nowhere in \(S_\delta\) (2.1). The Dirichlet polygon is blind on that line. Li’s coefficients
\[
\lambda_n=\frac{1}{(n-1)!}\frac{d^n}{ds^n}\Bigl[s^{n-1}\log\Xi(s)\Bigr]_{s=1}
\]
are the jet of \(\log\Xi\) at that degeneration. Bombieri–Lagarias: \(\lambda_n\ge 0\) for all \(n\) if and only if the Riemann hypothesis. The functional equation identifies a neighbourhood of \(s=1\) with a neighbourhood of \(s=0\), and the completed factor identifies both with a neighbourhood of \(t=0\) in the cosine picture. The Li jet and the Jensen jet are two coordinates of one object. The polygon can read the cosine moments at \(t=0\); it cannot read Li’s jet at \(\sigma=1\).

**15.8 (What is already known at this place).** Griffin–Ono–Rolen–Zagier: for each fixed degree \(d\), the shifted Jensen polynomials of \(\Xi_{\mathrm{cos}}\) are hyperbolic for all sufficiently large shift. That is occupation of 15.6 in the limit of large shift at bounded degree. It is not uniformity in the degree, which is the full tower of 15.6.

**15.9 (Why this is the place, not a substitute).** At \(\gamma=0\) positivity of \(\Phi\) already kills zeros, with no remaining gap. Introducing oscillation is exactly passing from \(m_0\) to the sequence \((m_{2k})\). A sign law for \(K(\alpha,\cdot)\) at some \(\alpha\neq 0\) is a statement about that sequence after the hyperbolic weight \(\cosh(\alpha u)\) has reweighted the measure, i.e. after the moments have been replaced by
\[
m_{2k}(\alpha)=\int_0^\infty\Phi(u)\cosh(\alpha u)\,u^{2k}\,du.
\]
The weighted sequence at \(\alpha=0\) must be allowed to produce real zeros (15.2). The weighted sequence at \(\alpha\neq 0\) must be forbidden from producing any zeros (15.3). That pair of demands is the Laguerre–Pólya class of order one, sitting at \(t=0\), equivalently Li positivity sitting at \(\sigma=1\). There is no closer point: one step back is the solved slice 15.1; one step forward is the tautology \(K\neq 0\).

**15.10.** Hyperbolicity of the Jensen tower is not proved here. Positivity of the Li jet is not proved here. Either sentence is the Riemann hypothesis. The footnote to 13.5 still applies. The same sentence on \(\mathbb{R}\), without \(\xi\), is the defining pairing of `tensor.html`. That file is a redefinition, not a frozen truth.

If a later edit of `publication.html` contradicts this file, the later edit is wrong.
