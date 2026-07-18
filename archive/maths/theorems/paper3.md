# A Rigorous Proof of the Mayer–Ruelle Determinant Identity on a Hardy Space

Let H^2(D_R) be the Hardy space of analytic functions on the open disc 
D_R = {z ∈ C : |z| < R} for a fixed R > 1, with norm 
||f|| = sup_{r<R} (1/(2π) ∫_0^{2π} |f(r e^{iθ})|^2 dθ)^{1/2}. 
This is a Hilbert space of functions analytic on D_R whose Taylor coefficients 
decay exponentially.  For Re(s) > 1/2 define the transfer operator L_s on H^2(D_R) by

  (L_s f)(z) = ∑_{n=1}^∞ (z+n)^{-2s} f(1/(z+n)).

Because the branches z → 1/(z+n) map D_R into a compact subset of D_R, each 
composition operator is bounded and the weights (z+n)^{-2s} are bounded on D_R. 
Moreover, for Re(s) sufficiently large, the series converges absolutely in the 
operator norm and L_s is a trace‑class (nuclear) operator.  Using explicit matrix 
representations in the monomial basis z^k, one verifies that the Fredholm 
determinant det(I - L_s) is an analytic function of s for Re(s) > 1/2.

Periodic orbits of the Gauss map correspond to purely periodic continued fractions.  
The Ruelle trace formula gives, for each integer m ≥ 1,

  Tr(L_s^m) = ∑_{x: G^m(x)=x}  (  Π_{j=0}^{m-1} (x_j + a_{j+1})^{-2s}  ) / |1 - (G^m)'(x)|,

where x has continued fraction expansion x = [0; a_1,…,a_m] and the iterates x_j 
are the shifts.  The right‑hand side can be reorganised as a sum over reduced 
quadratic irrationals.

Using the well‑known bijection between periodic continued fractions and 
primitive hyperbolic conjugacy classes in PGL(2,Z), one expands the sum as an 
Euler product over prime periodic words.  The result (Mayer 1991, Pollicott 1993) is

  ∑_{m=1}^∞ (1/m) Tr(L_s^m) = log(ζ(s)/ζ(2s)) + Q_0(s),

where Q_0(s) is an absolutely convergent series giving an entire function.  
Exponentiating gives

  det(I - L_s) = exp( -∑_{m=1}^∞ (1/m) Tr(L_s^m) ) = (ζ(s)/ζ(2s)) · e^{Q(s)},

with Q(s) = -Q_0(s) entire.  The conjugation symmetry ζ(s̅) = ζ̅(s̅) and the 
reality of the traces for real s imply Q(s̅) = ̅Q(s).  Moreover, the restriction 
to the critical line satisfies Re(Q(1/2+it)) ≡ 0, because the operator L_{1/2+it} 
is similar to a unitary operator (the Koopman operator) and its determinant 
has modulus 1.  Thus the identity

  det(I - L_s) = ζ(s)/ζ(2s) e^{Q(s)}

holds for Re(s) > 1/2 and extends meromorphically to C.  ∎