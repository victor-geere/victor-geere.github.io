# Agent B — Round 2

## ACKNOWLEDGED ERROR
I wrote "∫₀^π P_n(cosθ)P_m(cosθ)dθ = 2/(2n+1)δ_nm, so K is diagonal." The P_n are greedy
digit functions δ_n(θ), NOT Legendre polynomials. The mediator's quadrature K
(max off-diag 0.8631) is correct. My conclusion happens to survive for the reason the
mediator gives: M(t)=DKD with D=diag((n+2)^{-1}) — |w_n|² REAL and t-free — so M(t)=M(0)
exactly. Moral: an ansatz whose ONLY t-dependence is a diagonal congruence cannot have a
spectral event in t. Retracted claim was structurally impossible, not merely unsupported.

## RECONCILIATION (confirmed exactly)
U_N = Σ_{n≤N} n^{-it}:  U_100=(4.3048056−5.3428702i) |6.8613127|
  U_400=(0.8491822187−28.33298692i) |28.34571|  <-- handoff's 0.849, −28.333 EXACT
  U_1600=(−71.946739−87.563485i) |113.33004|
  U_6400=(−447.51616−64.780088i) |452.18046|
A_N = Σ_{n≤N} n^{-1/2-it}: |A_N| = 0.7094,1.4150,2.8286,5.6565 at N=100,400,1600,6400.
|U_N|/N → 0.070653 ; |A_N|/√N → 0.070706 ; 1/|1/2+it| = 1/√(1/4+t²) = 0.07070352773.
Clean identity:  U_N ≈ ζ(1/2+it)·N^{1/2}·(N^{-it}/(1/2+it))  so |U_N| ≈ N^{1/2}/|1/2+it|,
and  A_N = Σ n^{-1/2}n^{-it}  is the same sum with the weight n^{-1/2} supplying exactly that
factor. Both families share the prefactor 1/|1/2+it|. N^{1/4} was the second moment, not the size.

## (i) PRODUCT THEOREM
∏(1+a_n) converges to a finite non-zero limit iff Σ a_n converges (and no factor 0);
with a_n ≥ −1 eventually, iff Σ a_n < ∞. Euler: a_p = (1−p^{-s})^{-1}−1 = Σ_{k≥1}p^{-ks} ~ p^{-s},
Σ_p p^{-s} < ∞ for σ>1 ⇒ finite non-zero. Annihilating case: a_n = n^{-1/2}−1, Σ_{n≤N} a_n =
2√N − N − c → −∞ ⇒ product = 0, and indeed ∏ n^{-1/2} = (N!)^{-1/2}, log = −½N log N + O(N).
Not summability but its failure by an entire power of N.

## (ii) EXPLICIT FORMULA — PARTIALLY VERIFIED, NORMALIZATION OPEN
Verified: Riemann–von Mangoldt N(T) = (T/2π)log(T/2πe) + 7/8 + S(T) + small.
  T=300: exact N = 138 (zetazero), main = 137.7119, S = +0.2881. NO PRIMES appear on the main
term; the prime information is entirely in S(T).
NOT verified: I could not pin the archimedean normalization. Λ-sieve now correct (checked
Λ(2)=Λ(4)=Λ(8)=log2, Λ(6)=0, Λ(9)=log3), Fourier pair verified. But with triangle and Gaussian
test functions the computed prime side P and archimedean term A do not close onto
Z = Σ_γ ĝ(γ): e.g. Gaussian R=4: Z=0.0 (ĝ too narrow to see any zero), P=70.149, A=−45.092,
(Z−A/2)/P = 0.3214, whereas a Weil-type identity wants −1 or −2. Reported as OPEN, not claimed.

## (iii) THE 1/2
Not forced by convergence. Σ n^{-s} converges for σ>1; conditional convergence of Σ n^{-it}
is σ>0. The abscissa of ζ is 1, which is what convergence sees. σ=1/2 is the functional-equation
axis and the abscissa of the Euler product's mirror — a symmetry, not a convergence threshold.
Also Σ|μ(n)|n^{-s} = ζ(s)/ζ(2s) has abscissa 1 and its own "critical" line at 1/2.

## (iv) LOG ZETA
log ζ(s) = Σ_{p,k} p^{-ks}/k (amplitude 1/k); −ζ'/ζ(s) = Σ Λ(n)n^{-s} (amplitude log p, no 1/k).
The explicit formula's prime side uses Λ: −Σ Λ(n)n^{-1/2}g(log n). So it matches −ζ'/ζ, not
log ζ. The 1/k is destroyed by differentiation: d/ds(p^{-ks}/k) = −(log p)p^{-ks}. This matters:
a greedy/additive mechanism would need to produce amplitude log p at frequency k log p, i.e.
resolve the pair (p,k) — exactly the prime-power resolution the digit string has no mechanism for.
