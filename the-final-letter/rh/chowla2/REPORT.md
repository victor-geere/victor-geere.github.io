# C(K) = sum_{k<=K} lambda(2k-1)lambda(2k+1) = sum_{k<=K} lambda(4k^2-1): 26 exact reframings
All checks run in ~/workspace/rh/chowla2 (lambda sieved to 4*10^7). Labels:
IDENTITY = checked symbolically/numerically; CONJECTURE/HEURISTIC = unproved; FAILED = tried and broke.
Nothing here proves or disproves C(K)=o(K).

 1. C(K) = sum_{k<=K} b_k b_{k+1} with b_k := lambda(2k-1). [IDENTITY] shift 2 for lambda IS shift 1 for the
    odd-restricted Liouville sequence b. Checked K<=2e6 (two independent indexings agree). Useful because MRT is
    exactly the same statement for lambda itself; the whole gap is a change of sequence.
 2. b is completely multiplicative for the exotic commutative monoid (N, odot), k odot l = 2kl-k-l+1
    (b_{k odot l}=b_k b_l), isomorphic to (odd numbers, x) via k -> 2k-1; its atoms are {(p+1)/2 : p odd prime}
    = 2,3,4,6,7,9,10,12,15,16,19,... [IDENTITY] checked k,l<=400 and atoms<=40. So C(K) is a Chowla-type
    correlation of a completely multiplicative function on a monoid, against ORDINARY addition. Useful if a
    mean-value theorem exists for "multiplicative w.r.t. an exotic monoid, correlated with +1".
 3. General-h collapse: S(h) := sum_{n<=x}lambda(n)lambda(n+h) = sum_{m<=x/h}lambda(m)lambda(m+1) + R(h),
    R(h) = sum_{h∤n}...; hence by MRT, Chowla(h) <=> R(h)=o(x). [IDENTITY] checked h=2,3,4,6,12, x=2e5.
    The open content of ANY shift is the residual set {h ∤ n} (density 1-1/h); for h=2 that is the odd core.
 4. Chowla(2^j) = MRT + sum_{i<j} (odd core of shift 2^{j-i}); so the whole 2-power family collapses onto
    odd cores. [IDENTITY] checked j=1,2,3 (x=3e5).
 5. The m^2-1 dichotomy: sum_{m<=M} lambda(m^2-1) = C(floor(M/2)) + sum_{n<M/2}lambda(n)lambda(n+1).
    m odd => (m^2-1) = 8*T_n, lambda = -lambda(T_n) = lambda(n)lambda(n+1) => MRT (theorem);
    m even => (m^2-1) = 4k^2-1 => C(K) (open). [IDENTITY, checked M<=6000]. So h=1 and h=2 are the two halves
    of the single problem "does lambda have zero mean on m^2-1", separated by the parity of m.
 6. MRT restated: sum_{n<=x}lambda(n)lambda(n+1) = -sum_{n<=x}lambda(T_n) = o(x), T_n = n(n+1)/2.
    [IDENTITY] checked (also lambda(T_n) = -lambda(n)lambda(n+1)); numerically sum_{n<=8000}lambda(T_n) = -76.
    Contrast: C(K) = sum over the HYPERBOLIC sequence 4k^2-1; MRT = sum over TRIANGULAR numbers.
 7. lambda = mu * 1_sq and lambda(n) = mu(sfp(n)) (sfp = squarefree part). [IDENTITY] both checked n<=20000/5000.
    Hence C(K) = sum_{k<=K} mu(sfp(2k-1)) mu(sfp(2k+1)): a Mobius correlation of the squarefree parts of two
    coprime neighbours. Square-class form: [n] in Q*/Q*^2; lambda(n) = chi_2([n]) where chi_2 = sum of
    coordinates on the F_2-vector space Q*/Q*^2; C(K) = sum_k chi_2([4k^2-1]). [IDENTITY]
 8. Sign/pattern form: C(K) = K - 2D(K), D(K)=#{k<=K: lambda(4k^2-1) = -1}; so C(K)=o(K) <=> the 2x2 table of
    (lambda(2k-1),lambda(2k+1)) becomes rank-one: p_{ee'} = (1+e a+e' b+ee' c)/4 with a,b,c = C/K = o(1).
    [IDENTITY for the inversion formula, checked exactly at K=1e6,1e7; a,b -> 0 is the known PNT-type marginal
    sum_{k<=K}lambda(2k-1)=o(K) - checked: -0.00029 at K=1.9e7]. So Chowla(2) <=> all four sign patterns have
    density 1/4, and for +-1 variables with balanced marginals uncorrelatedness IS independence.
 9. Dirichlet series in k: G(s)=sum_k lambda(4k^2-1)k^{-s} = 2^s sum_{m odd squarefree} mu(m) sum_{(x,y): x^2-my^2=1,
    x even, 2<=x<=2K} x^{-s}. [IDENTITY, formal; inner sums converge for Re s>0] checked numerically at s=3 to
    1e-10. Pell form of the same fact: 4k^2-1 = m s^2 with m = sfp, and the map k <-> (m,s) is a bijection onto
    even-x Pell solutions; hence C(K) = sum_m mu(m) * #{even-x Pell solutions x^2-my^2=1, x<=2K}.
    [IDENTITY] checked k<=5000; m=5 provably never occurs (all x^2-5y^2=1 have x odd). Useful if Mobius sums over
    real-quadratic regulator data can be controlled.
10. Mobius-square expansion: C(K) = sum over coprime odd (d,e) of sum_{k<=K, d^2|2k-1, e^2|2k+1}
    mu((2k-1)/d^2)mu((2k+1)/e^2); the k-locus is exactly ONE residue class mod (de)^2, equivalently the
    solutions of the LINEAR equation e^2 n - d^2 m = 2, count = K/(de)^2 + O(1). [IDENTITY] checked (K=4000,
    and residues/class counts for (d,e)=(3,5),(7,3)).
11. mod-4 twist: g = lambda*chi_4 on odd n (g(p)=+1 iff p=3 mod 4) has L(s,g) = (1-4^{-s}) zeta(2s)/beta(s), and
    lambda(4k^2-1) = -g(4k^2-1), so C(K) = -sum_{k<=K} g(4k^2-1). [IDENTITY] checked numerically and
    coefficient-wise to n<=20000 (beta = Dirichlet beta). Reframing: the obstruction does NOT sit in the
    p=3 mod 4 primes; a method only using g(p)=+1 there is not enough.
12. Poisson/Gauss-sum form: C(K) = int_0^1 e(theta) A(theta) G(theta) dtheta with
    A(theta) = sum_{n=3 mod 4} lambda(n) e(n theta), G(theta) = sum_{a even <= 2K} e(-a^2 theta) (a theta
    series). [IDENTITY] verified exactly by FFT for K=37,200,640 (N=2^ceil log2(4K^2+2), no aliasing).
13. Wiener-Khinchin/periodogram form: C(K) = int_0^1 |B_K(theta)|^2 e(theta) dtheta, B_K = sum_{k<=K} b_k e(-k theta).
    [IDENTITY] verified exactly for K=1000 and K=30000. Chowla(2) <=> the first Fourier coefficient of the
    power spectrum of the odd-Liouville sequence vanishes.
14. Spectral dilation (the exact 2-adic mechanism): B(theta) = (1/2) e(-theta/2)[ A(theta/2) - A(theta/2+1/2) ],
    A(phi) = sum_{n<=2K} lambda(n)e(-n phi). [IDENTITY] verified at 5 frequencies to 1e-6. The odd restriction is
    literally "frequency doubling on the dual torus".
15. Gram/orthogonality form: with windows v_i = (lambda(i+1),...,lambda(i+K)), C(K) = <v_1,v_3> and MRT is
    <v_1,v_2> = o(K); Chowla is M/K -> I. [IDENTITY, elementary] Gram data at K=1e6:
    [[1e6,-1108,68,-424],[-1108,1e6,-1108,68],[68,-1108,1e6,-1108],[-424,68,-1108,1e6]].
16. Random-model / quantitative form: C(K) = O_eps(K^{1/2+eps}) is the prediction of the random-multiplicative
    (and of the squarefree-kernel-independence) heuristic; C(K)=o(K) is therefore far weaker than expected.
    [HEURISTIC] Data: log(max_{K<=X}|C|)/log X = 0.498,0.513,0.448,0.497,0.495 for X=1e4..2e7;
    max|C|/sqrt(X) = 0.49..1.17; iid +-1 control gives the same range. So the numerics look like white noise.
17. Log-averaged version is a THEOREM: sum_{k<=K} lambda(2k-1)lambda(2k+1)/k = o(log K) (Tao 2016, logarithmic
    two-point Chowla for fixed shift; the odd core is a sub-sum). [the theorem is real; my use of it is an
    IDENTITY-level reduction] Numerically the sum converges to -1.0331 at K=1.9e7 (ratio to log K = -0.062).
    So the entire remaining gap is the log-average -> natural-average transfer; I have no exact reformulation
    of that transfer that is not just the original statement. [HEURISTIC that this is the true gap]
18. Finite-field model I (character/Jacobsthal): for chi the Legendre symbol, sum_{k mod p} chi(4k^2-1) = -1 and
    sum_{n mod p} chi(n(n+2)) = -1 for every odd prime p (nondegenerate quadratic Gauss/Jacobsthal sum,
    disc = 16 resp. 4). [IDENTITY] checked 429 primes <3000 and general (a,b,c). The model answers "-1" for BOTH
    shifts, and shift 2 is perfectly behaved: it is blind to the obstruction.
19. Finite-field model II (F_q[t], exact): sum_{deg f=n} lambda(f) = +q^{n/2} (n even), -q^{(n+1)/2} (n odd),
    i.e. generating function (1-qu)/(1-qu^2) - exact square-root cancellation with NO main term. [IDENTITY]
    computed exactly for q=3 (n<=8), 5 (n<=6), 7 (n<=5). Moreover both shift-1 and shift-2 correlations, and the
    non-unit shift by the irreducible t, are O(q^{n/2}) with no obstruction; the "odd core" analogue
    (t ∤ f, i.e. f(0) != 0) is also tiny (e.g. q=5,n=6: -62 out of 15625). So this model predicts the
    number-field answer is YES and cannot locate the difficulty. Over F_q[t] the shift 2 is a unit at every
    place; over Z, 2 is the non-unit place - that is the only structural difference.
20. Algebraic number theory: 4k^2-1 = N_{Z[t]/(t^2-1)}(2k+t) (split algebra Q x Q), and n(n+1) =
    N(n+1/2+t) with t^2=1/4 - the h=1 case needs 2 INVERTED, h=2 does not ("2-integrality" dichotomy).
    [IDENTITY for the norm forms] FAILED as a discriminator: both are norms from split algebras, so the
    split-algebra reading does not separate h=1 from h=2.
21. Hyperbolic lattice form: 4k^2-1 = x^2-y^2 at the primitive lattice point (x,y)=(2k,1); C(K) = sum over these.
    Known half: x odd (both factors even, the 2-part collapses); open half: x even (both factors odd).
    [IDENTITY] equivalently lambda(4k^2-1) = -g(4k^2-1) with the mod-4 twist of item 11.
22. Statistical mechanics: sigma_k = lambda(2k-1) is a +-1 spin chain; C(K)/K is its mean nearest-neighbour bond
    correlation, from the multiplicative disorder. Chowla(2) <=> zero bond order (paramagnet); zero
    magnetization sum_{k<=K}sigma_k = o(K) is a theorem (PNT). [IDENTITY for the translation; HEURISTIC for the
    physics reading] Numerics: bond correlation C/K = 1.9e-4 at K=1.9e7.
23. Parity-blindness: Omega(4k^2-1) is Gaussian with mean ~ 2 log log(2K) (Erdos-Kac for polynomial values), so
    distributional information is useless; the question is the parity bit of Omega on a quadratic sequence -
    exactly Selberg's parity barrier, whose classical form says no dimension-1 sieve can see it.
    [HEURISTIC] Consequence: C(K)=o(K) is a parity-breaking statement, of the same family as twin-primes-type
    statements about n(n+2).
24. FAILED analogy (2-automatic model): Thue-Morse t has the identical 2-descent recursion (t(2n)=t(n),
    t(2n+1)=-t(n)) and t(2k-1)t(2k+1) = t(k-1)t(k); measured at N=2^21: sum t(n)t(n+1) = -699051 ~ -N/3, odd core
    = -349525. So the "automatic" model has correlation mean -1/3, NOT 0. The 2-adic recursion alone forces
    nothing; lambda's odd core does not do this (C/K = 2e-4). [FAILED: model too structured, wrong magnitude]
25. FAILED route: automorphic/shifted-convolution delta-symbol + Kuznetsov machinery (which gives
    sum_n a(n)a(n+h) bounds for Fourier coefficients of modular forms) does not apply: zeta(2s)/zeta(s) is not
    an automorphic L-function and lambda has no spectral expansion. Same for the "modular theta" hope in item 12:
    the theta side is modular, the lambda side is not. [FAILED]
26. FAILED route: Sarnak's conjecture does not apply directly: C(K) = <lambda(2k-1), lambda(2k+1)>_k pairs two
    positive-entropy multiplicative-ish sequences; neither is a deterministic (zero-entropy) weight.
    Also no Euler product / functional equation exists for G(s) (item 9), since {4k^2-1} is not closed under
    multiplication. [FAILED]

WHAT I COULD NOT DO
- No exact "log -> natural transfer" reformulation (item 17); every attempt reduced to the original statement.
- No exact finite decomposition of the indicator of {4k^2-1} into characters mod q (the quadratic sequence is
  not a union of residue classes), so no "finite Chebyshev/Fourier" reduction of C(K) to AP-sums of lambda.
- No reformulation forcing the 2 to be a "unit" (h odd, e.g. h=3) nor an explanation of why h=1 is provable and
  h=3 is not; the 2-adic descent story only separates h=1 from even h.
- No unconditional non-trivial bound on C(K) of any kind (not attempted as a proof; nothing here is a proof).
- The naive Pell quadratic expansion FAILED and is documented: writing the Mobius-square expansion terms as
  c n^2 - a m^2 = 2 is wrong (the cofactors are not square roots); the correct per-term equation is the LINEAR
  e^2 n - d^2 m = 2. Only the squarefree-part/Pell version (item 9) is quadratic.
- I could not attach C(K) to any of: class numbers, L-function special values, trace formulas, or a moduli space,
  beyond the (exact but useless) Pell bijection of item 9.
