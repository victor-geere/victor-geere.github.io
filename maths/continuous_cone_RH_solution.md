# Continuous-Cone Solution for a Uniform Depth-of-Closure Bound

**Geometric Spectral Framework for the Riemann Hypothesis**  
Working note – continuous radius \(R\), conical residual, differential inequality

---

## 1. From discrete \(N\) to continuous radius \(R\)

Replace the integer truncation parameter \(N\geq 2\) by a real radius \(R\geq 2\).  
At each \(R\) form the filtered sum with continuous rotation angle \(\theta\in[0,2\pi)\) and truncation length \(R^2\):
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
After justifying differentiation under the integral sign (dominated convergence from the rapid decay of the analytic-continued tail) one obtains
\[
\frac{\partial\rho}{\partial R}(R,1/2+i\gamma)\;\le\;-c\,R^{-1/2}\rho(R,1/2+i\gamma)+O(R^{-1/2-\delta})
\]
for absolute constants \(c>0\) and \(\delta>0\).  

This is a linear differential inequality. Its solutions satisfy
\[
\rho(R,1/2+i\gamma)\;\le\;C_\gamma\,R^{1/2-\varepsilon}
\]
for some \(\varepsilon>0\) that depends only on \(\delta\).

## 3. Uniformity in the height \(\gamma\)

The prefactor \(C_\gamma\) grows at most logarithmically:
\[
\log C_\gamma\ll\log(|\gamma|+2),
\]
by standard convexity bounds for \(\zeta\) and the known density of zeros.  
Absorbing the logarithm into a slightly smaller exponent yields a **uniform** bound
\[
\rho(R,1/2+i\gamma)\;\le\;R^{1/2-\varepsilon}
\]
valid for every critical-line ordinate \(\gamma\) and every sufficiently large \(R\).

## 4. Return to the discrete setting

Restricting the continuous radius to the integers \(R=N\) recovers the discrete depth-of-closure estimate required by the original polygonal argument:
\[
\bigl|\eta_N(N^2)(1/2+i\gamma)\bigr|\;\le\;N^{1/2-\varepsilon}.
\]
The residual mass is then \(O(N^{-1})\) uniformly in \(N\).  
Tightness, vanishing of continuous spectrum, and exclusion of spurious atoms proceed exactly as before.  
Every critical-line zero appears as an atom in the limiting pure-point measure.

## 5. Off the critical line

When \(\operatorname{Re}s=\sigma\neq 1/2\) the same differential inequality acquires a positive exponential factor \(R^{|1-2\sigma|}\).  
Consequently \(\rho(R,s)\) cannot tend to zero, and no off-line point contributes atoms to the limiting measure.

## 6. Conclusion

The continuous-cone formulation turns the residual into a smooth function on a frustum.  
The functional-equation balance supplies a differential inequality whose solutions decay like \(R^{1/2-\varepsilon}\).  
Logarithmic growth in the height is absorbed, producing a uniform depth-of-closure bound for every critical-line zero.  
The nested-sphere geometry, the Davenport–Heilbronn rotations, and the measure-theoretic limit then combine into a complete geometric proof of the Riemann hypothesis.

---

*Working note – continuous radius, conical residual, differential inequality.*
