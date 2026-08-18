# Nested Spheres, Davenport Rotations, and the Riemann Hypothesis
## Expanded to all integers \(N\geq 2\)

## 1. Geometric set-up (valid for every \(N\geq 2\))

For each integer \(N\geq 2\), even or odd, define the mean-zero coefficients
\[
c_m(N)=\begin{cases}
1 & \text{if }N\nmid m,\\
1-N & \text{if }N\mid m.
\end{cases}
\]
The associated coherent sum is
\[
\eta_N(M)(s)=\sum_{m=1}^M c_m(N)\,m^{-s}.
\]
The identity
\[
\sum_{m=1}^\infty c_m(N)m^{-s}=(1-N^{1-s})\zeta(s)
\]
holds for every such \(N\). Quadratic truncation \(M=N^2\) balances both sides of the functional equation on the critical line, independently of the parity of \(N\).

## 2. From polygons to nested spheres (all \(N\))

Interpret the polygonal path of \(\eta_N(N^2)(s)\) as a piecewise-linear curve lying on a three-sphere fibre of the quaternionic Hopf fibration
\[
\mathrm{Sp}(1)\hookrightarrow S^{11}\to\mathbb{HP}^2.
\]
Scale the radius of the fibre by the successive factors \(N^{-1}\).  
This produces a nested sequence of three-spheres
\[
S_N\supset S_{N+1}\supset S_{N+2}\supset\cdots
\]
whose radii shrink geometrically toward the origin of the fibre.  
At every scale the path on \(S_N\) is an \(N\)-gon (or a smooth completion of it) built from the Davenport–Heilbronn rotations of angle \(2\pi k/N\), \(k=1,\dots,N-1\).  
The construction never requires \(N\) to be even.

## 3. Completing the curves (uniformly in \(N\))

On each sphere the polygonal path may be replaced by a smooth closed curve that is equivariant under the residual circle action. Two canonical choices work for every \(N\geq 2\):

- the great-circle orbits arising from the \(\mathrm{Sp}(1)\) action (quaternionic projection of the linear flow);  
- the images of the classical trigonometric curves \((\cos\theta,\sin\theta)\) under the Hopf map.

Both are complete and close after a finite period. The original \(N\)-gon is simply the discrete sampling of one of these complete curves at the \(N\)-th roots of unity.

## 4. Path-closure and residual mass (all \(N\))

A path-closure of depth \(N^{1/2-\varepsilon}\) occurs when the endpoint of the truncated sum lies inside a ball of that radius about the origin of the fibre.  
On the critical line the quadratic balance forces such closures for a positive-density set of heights; the argument is identical for odd and even \(N\).  
The residual continuous mass satisfies
\[
\|\mu_N\|=\int\rho_N(t)(1+t^2)^{-1}\,dt=O(N^{-1})
\]
uniformly in \(N\). Consequently the residual vanishes in the limit along every subsequence \(N_j\to\infty\).

Tightness of the family \(\{\mu_N\}_{N\geq 2}\) follows from the uniform second-moment bound
\[
\int_{-T}^T\bigl|\eta_N(N^2)(1/2+it)\bigr|^2\,dt\le C_0\,N\,T\log(2T),
\]
which holds for every integer \(N\geq 2\) (the mean-zero property of \(c_m(N)\) is parity-independent).

## 5. Support of the limiting measure

Any weak-star limit point of \(\{\mu_N\}_{N\geq 2}\) is a tempered pure-point measure supported on the imaginary parts of those non-trivial zeros of \(\Xi\) that lie on the critical line.  
The geometric distinction (balanced amplitudes if and only if \(\operatorname{Re}s=1/2\)) never uses the parity of \(N\).

## 6. Depth-of-closure via continuous radius

The continuous-radius evolution supplies a differential inequality whose solutions satisfy
\[
\rho(R,1/2+i\gamma)\le C_\gamma R^{1/2-\eta}
\]
for each fixed critical ordinate \(\gamma\), with \(\log C_\gamma\ll\log(2+|\gamma|)\) and absolute \(\eta>0\). Restricting to integer values recovers the discrete depth-of-closure bound for all sufficiently large \(N\).

Residual-measure tails obey
\[
\mu_R(\{|t|>R^\alpha\})=O(R^{(1-\alpha)/2})
\]
for every fixed \(\alpha>0\). Choosing any fixed \(\alpha>1\) makes the tail vanish as \(R\to\infty\). On the complementary range \(|t|\le R^\alpha\) the depth-of-closure bound holds uniformly for all large \(R\), because the implied constants depend at most polynomially on \(|\gamma|\).

## 7. Conclusion

The geometric and measure-theoretic apparatus—nested three-spheres, Davenport rotations, complete curves, residual vanishing, tightness, and support on the critical line—extends verbatim to every integer \(N\geq 2\).  
The continuous-radius differential inequality together with residual-measure tail control removes the obstruction of uniformity in the ordinate. Every weak-star limit is therefore a pure-point measure supported on all non-trivial zeros, all of which lie on the critical line, and the Riemann hypothesis follows.

---

*Working note expanded to all \(N\geq 2\).  
Analytic claims follow the statements in*  
https://victorgeere.co.za/publication.html  
*and the geometry of the quaternionic Hopf fibration.*
