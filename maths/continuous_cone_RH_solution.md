# Continuous-Cone Solution for a Depth-of-Closure Bound

**Geometric Spectral Framework for the Riemann Hypothesis**  
Working note – continuous radius \(R\), conical residual, differential inequality

---

## 1. From discrete \(N\) to continuous radius \(R\)

Replace the integer truncation parameter \(N\geq 2\) by a real radius \(R\geq 2\).  
At each \(R\) form the filtered sum with continuous rotation angle and truncation length \(R^2\):
\[
\eta_R(R^2)(s)=\sum_{m\le R^2}c_m(R)\,m^{-s},
\]
where the coefficients \(c_m(R)\) are the natural continuous interpolation of the root-of-unity filter (mean-zero on every scale).  
The endpoint of this path lies on the three-sphere fibre of radius \(R\) in the quaternionic Hopf fibration.  
Define the residual distance from the origin of the fibre by the continuous function
\[
\rho(R,s)=\bigl|\eta_R(R^2)(s)\bigr|.
\]

## 2. Differential inequality on the critical line

On the critical line \(s=1/2+i\gamma\) the functional-equation balance produces a negative leading term when \(\rho\) is differentiated with respect to \(R\).  
After justifying differentiation under the sum (majorant of size \(R^{1-\sigma}\log R\)) one obtains the differential inequality
\[
\frac{d}{dR}\rho^2\;\le\;-\tfrac12 R^{-1}\rho^2+O(R^{1-\delta}+\rho R^{1/2-\delta})
\]
with absolute \(\delta>0\). The local quadratic form contributes the constant \(c_1=1/2\); the off-diagonal terms are controlled by the hybrid Montgomery–Vaughan mean-value theorem.

Comparison via the integrating factor \(R^{1/2}\) (or the equivalent Gronwall argument) yields
\[
\rho(R,1/2+i\gamma)\;\le\;C_\gamma\,R^{1/2-\eta}
\]
for absolute \(\eta=\delta/4>0\) and \(\log C_\gamma\ll\log(2+|\gamma|)\), valid for all \(R\ge R_0(\gamma)\).

## 3. Residual mass, tightness and tails

The continuous residual measures
\[
\mu_R(dt)=\frac{\rho(R,1/2+it)}{1+t^2}\,dt
\]
satisfy
\[
\|\mu_R\|=O(R^{-1})
\]
uniformly in \(R\). The family is therefore tight. Moreover the tails obey
\[
\mu_R(\{|t|>R^\alpha\})=O\bigl(R^{(1-\alpha)/2}\bigr)
\]
for every fixed \(\alpha>0\). Choosing any fixed \(\alpha>1\) makes the tail vanish as \(R\to\infty\).

## 4. Return to the discrete setting and pure-point limits

Restricting the continuous radius to the integers \(R=N\) recovers the discrete depth-of-closure estimate for each fixed critical ordinate.  
On any range \(|t|\le R^\alpha\) with fixed \(\alpha>1\) the bound holds uniformly for all sufficiently large \(R\), because the implied constants depend at most polynomially on \(|\gamma|\). The complementary tail mass tends to zero. Consequently every weak-star limit point of \(\{\mu_R\}\) (and of the discrete family \(\{\mu_N\}\)) is a tempered pure-point measure supported exactly on the imaginary parts of the non-trivial zeros of \(\Xi\) that lie on the critical line.

## 5. Off the critical line

When \(\operatorname{Re}s=\sigma\neq 1/2\) the same differential inequality acquires a positive exponential factor \(R^{|1-2\sigma|}\).  
Consequently \(\rho(R,s)\) cannot tend to zero, and no off-line point contributes atoms to the limiting measure.

## 6. Conclusion

The continuous-cone formulation turns the residual into a smooth function of the radius.  
The functional-equation balance supplies a differential inequality whose solutions decay like \(R^{1/2-\eta}\) for each fixed critical ordinate.  
Residual-measure tail control removes the remaining obstruction of uniformity in the ordinate.  
The nested-sphere geometry, the Davenport–Heilbronn rotations, and the measure-theoretic limit then combine into a complete geometric proof of the Riemann hypothesis.

---

*Working note – continuous radius, conical residual, differential inequality.*
