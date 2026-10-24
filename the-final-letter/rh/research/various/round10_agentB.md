# Agent B — Round 10 (final)

## (A) CLOSING VERDICT
STANDING, with evidence:
1. Greedy harmonic sine: s_N=sum_{n<=N}delta_n pi/(n+2), |sin th - s_N| <= pi/(N+1) on [0,pi].
   Terminates for rational theta/pi (exact rational arithmetic); support for theta=pi is {0,1,4}.
2. Product criterion: prod(1+a_n) converges to finite non-zero iff sum a_n converges;
   Euler local factor (1-p^-s)^-1-1 ~ p^-s is summable for sigma>1; prod n^-1/2 = (N!)^-1/2.
3. Sum identity: U_N = sum_{n<=N} n^{-it} ~ (N^{1-it}-1)/(1-it); |U_N| ~ N^{1/2}/|1/2+it|.
   Verified exactly: U_400 = 0.8491822187 - 28.33298692i.
4. M(t) = D K D is a diagonal similarity with |w_n|^2 real and t-free, so M(t)=M(0) exactly;
   no spectral event in t is possible. (My earlier "K diagonal" step was wrong; the conclusion
   survives by the similarity argument.)
5. Squaring law: with m=ceil(1/r), f=1/r-m+1, r' = (1-f)r^2/(1+(1-f)r), c=r'/r^2 -> 1-f.
   Hence A(N) = log_2 log N + O(1) with a target-dependent O(1).
6. 3-term unit-fraction uniqueness is a theorem, not a computation: 1/a+1/b+1/c=1 needs
   3/a>=1 so a<=3; a=2 gives 1/b+1/c=1/2 with b>2 => c=2b/(b-2)>b forces b<4 => (2,3,6);
   a=3 gives 1/b+1/c=2/3 but b>3 => <=1/2. UNIQUE, unconditionally, no bound on c.
   Therefore the perfect-number observation has no arithmetic content.
7. Sylvester-vs-Gauss: the greedy map r -> r - 1/ceil(1/r) is the Engel/Sylvester map, NOT the
   Gauss map. Gauss-Kuzmin belongs to x -> 1/x - floor(1/x) and does not apply. Both the
   mediator's Round-1 guess and A's Round-2 [RECALL] were wrong.
8. M - gamma = -0.3157184521 is exact via M = gamma + sum_p[log(1-1/p)+1/p]; it is a
   prime-indexed object and has no counterpart in a construction with no primes.
NOT:
- Any bridge to the zeros. The eigenvalue-drop claim is structurally impossible; the prime side
  of the explicit formula has amplitudes Lambda(n)/sqrt(n) growing like log p, which no
  finite-alphabet digit string can produce; frequency/amplitude (k log p, log p) needs division.
- A "certification" advantage over zeta: the greedy bound is an easy tail estimate; zeta at
  sigma=1/2 is a different (arithmetic) problem. The correct statement is only that bounding
  the zeta truncation error requires zero information.

## (1) COMPLEXITY LAW — SETTLED STRUCTURALLY, NO SIMPLE CLOSED FORM
Exact: every non-zero length-L factor is determined by (i,x,k) = (index of the first 1 in the
factor, its offset, number of further 1s whose cumulative gap <= L-x). p(L) = #{distinct
(i,x,k)} + [1 if some gap >= L]. Verified: 1/pi p(1..13) = 2..12,14,16 (matches the mediator's
12,14,16); log2 = 2,3,4,5,7,8,...,15; sqrt2-1 = ...,13,15,16; e-2 = 2,3,4,6,7,...
A's L+1+#pairs fails: 1/pi L=11 gives 13 vs 12, L=13 gives 15 vs 16; sqrt2-1 L=12 gives 14 vs 15.
The failure is structural: one long gap (594, 605 for 1/pi) is shared by several pairs, so pair
counts overcount, and near L equal to a gap length the (i,x,k) classes split differently.
Conclusion: p(L) IS determined by the gap sequence, but NOT by pairwise distances alone; no
formula in {L, #pairs, #distances} can work. The law is closed in the gap sequence and open only
if one insists on a closed form in L.

## (2) THE INVARIANT
For RATIONAL targets the orbit terminates in 7-12 steps, so there is no invariant measure to
discuss; the mediator's "no a.c.i.m." is correct but vacuous for the cases measured. For
irrational targets the orbit is infinite; whether the Sylvester/Engel map has an a.c.i.m. is not
settled here, and I do not claim it. What IS correct and provable: A(N) = log_2 log N
- sum_{k<=A(N)} log c_k + O(1), so the O(1) is controlled exactly when the partial sums of
log c_k converge, i.e. when {1/r_k} stays away from 1. The measured 7-9 step averages
(-0.42, -0.93, -0.57, -1.20, -0.72, -0.58) are TRANSIENTS of a doubly-exponentially short orbit,
not limits; target-dependence at 7-9 steps is expected and does not refute a universal limit.

## (3) CONSTANTS
H_{N+2}-1 = log N + gamma - 1 + o(1) with gamma = 0.5772156649015329: correct.
M = 0.2614972128 = gamma + sum_p[log(1-1/p)+1/p]: exact (Mertens), verified.
M - gamma = -0.3157184521. It is meaningful for the primes and has NO counterpart here: the
greedy construction contains no primes, and the cancellation in log(1-1/p)+1/p is a prime-specific
fact. It is a coincidence of two unrelated rearrangements.

## (B) THE NEXT COMPUTATION
Do not re-run the census. Compute the Birkhoff average of log c_k along a SINGLE long orbit at
very high precision: take an irrational target to 10^4 digits, iterate r -> r - 1/ceil(1/r),
recording log c_k until precision is exhausted. Target length: ~40-50 steps per target (the
double-exponential decay caps the length). Do this for 10-20 algebraically independent targets
and test whether the running averages converge to a common value, with a stated confidence band.
That directly tests the sharpest open problem.

## (C) SHARPEST OPEN PROBLEM
Prove or refute: for every irrational theta/pi, the Birkhoff averages (1/K) sum_{k<=K} log c_k
converge as K -> infinity to a limit independent of theta; equivalently, prove that the partial
sums sum_k log c_k are bounded, which is exactly what upgrades A(N) = log_2 log N + O(1) from
measured to proved.

## (D) CORRECTIONS
1. Item 1 (uniqueness) is not merely verified to 200000 -- it is a two-line theorem with no
   bound needed; state it that way.
2. Item 2's "no a.c.i.m." is vacuous for the measured (rational) targets; keep the Sylvester-vs-
   Gauss correction, but the measure statement needs irrational orbits.
3. Item 3's averages are transients, not limits; the O(1) is target-dependent only in the sense
   that a finite partial sum is, not that the asymptotic constant is.
4. Item 6's complexity data: the mediator's full sequence for 1/pi [2,...,12,14] and the quoted
   p(11)=12 are consistent (p(11)=12); A's claimed 13 is the error. My computation agrees with
   the mediator's 12,14,16.
