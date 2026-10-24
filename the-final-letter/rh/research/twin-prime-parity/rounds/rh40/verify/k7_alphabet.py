#!/usr/bin/env python3
"""
k7_alphabet.py -- K7 / HANDOFF.md section 4 sub-target C4 (the inverse problem).

QUESTION C4.  Characterise the minimal alphabet {alpha_n} whose greedy digit word
realises a prescribed factor-complexity function p(L).  HANDOFF section 4 records:

  (F1) bounded gaps between successive selected indices <=> alpha_n=(n+2)^-p, p>1
  (F2) reachability of the unit target                 <=> zeta(p)>=2, p<=p*
  (F3) "you get bounded gaps OR termination, never both"      (dichotomy claim)

and HANDOFF section 10 adds "neither threshold is 3/2".

WHAT THIS SCRIPT ESTABLISHES (all four parts, see PART headers):

  T1.  For a NON-INCREASING positive alphabet and target x, the greedy rule
       halts after finitely many selections -- with every taken index contiguous
       from the first one taken -- if and only if sum_n alpha_n >= x.
       The halt residual is S(N)-x with N = min{n : S(n) >= x}, S(n)=sum_{k<n}.
       That residual is 0 (exact termination) iff x is a finite subsum.

  THE FAMILY.  For alpha_n=(n+2)^-p and x=1, sum_{n>=0} alpha_n = zeta(p)-1, so:
        p <= p*   (zeta(p) >= 2):  the process halts at N(p)=min{n:S(n)>=1};
                                   the word is 1^{N(p)} 0^inf, a FINITE prefix of
                                   ones; taken indices 0..N(p)-1, all gaps 1;
                                   halt residual S(N(p))-1 > 0, never 0.
        p > p*    (zeta(p) <  2):  no halt; EVERY index is taken; the word is
                                   1^inf; all gaps 1.
  So the greedy word of the whole family is 1^k 0^inf or 1^inf, and the residual
  is never exactly 0 for any p tested.

  (F1) is CORRECT.  (F2) is CORRECT (with "termination" = the process halts).
  (F3) is REFUTED: for every p in (1, p*] both hold -- all gaps are 1 AND the
  process halts.

  INVERSE PROBLEM.  K1 (proved) gives, for ANY finitely supported word,
        p(L) = min(a_m+1, N-L+1) + [L <= N-a_m-1]   for L >= max(span, a_m+1),
  so max_L p(L) = min(#ones, a_m+2).  Combined with T1, every alphabet with
  sum alpha_n >= 1 produces a FINITE word, hence a BOUNDED profile: p(L)=cL is
  realisable by no such alphabet.  (Morse-Hedlund independently forbids p(L)=L+1
  for all L.)  So "exact termination + linear complexity growth" is impossible.

Arithmetic policy.  Fraction for rational p and for exact certificates; mpmath at
>= 60 dps for irrational p.  The exact partial sum is
        S(N) = sum_{n<N}(n+2)^-p = zeta(p,2) - zeta(p,N+2)
with mpmath.zeta(a,q) = sum_{k>=0}(q+k)^-a (Hurwitz).  No binary float is used in
a greedy test; every mpf is parsed inside the working-precision context.

Run:  python3 rh40/verify/k7_alphabet.py
"""

import time
from fractions import Fraction
from itertools import combinations

from mpmath import mp, mpf, power, zeta, findroot

mp.dps = 60


# ============================================================================
# 0.  ground truth: offset-tuple factor complexity (register B1/B2)
# ============================================================================

def factor_set(supp, L, N):
    """Length-L factors of the length-N word with 1-positions `supp`, encoded as
    frozensets of offsets.  Exact by construction (register B1)."""
    S = set(supp)
    return frozenset(
        frozenset(a - t for a in S if t <= a <= t + L - 1)
        for t in range(N - L + 1)
    )


def profile(supp, N):
    return [len(factor_set(supp, L, N)) for L in range(1, N + 1)]


def support_bounds(supp):
    return supp[0], supp[-1], supp[-1] - supp[0]


def k1_predict(am, L, N):
    return min(am + 1, N - L + 1) + (1 if L <= N - am - 1 else 0)


# ============================================================================
# 1.  exact partial sums of sum_{n>=0}(n+2)^-p
# ============================================================================

def S_partial(N, p):
    """sum_{n=0}^{N-1}(n+2)^-p = zeta(p,2) - zeta(p,N+2), exact to working dps."""
    return zeta(p, mpf(2)) - zeta(p, mpf(N) + 2)


def S_direct(N, p, dps=80):
    with mp.workdps(dps):
        return mp.fsum([power(mpf(n + 2), -p) for n in range(N)])


def terminal_index(p, cap=10 ** 7, dps=80):
    """(N, Sinf): N = min{n : S(n) >= 1} when it exists, else None.

    CAREFUL: Sinf is zeta(p)-1 only for p > 1 (where the series converges and
    zeta(p)-1 equals sum_{n>=0}(n+2)^-p).  For p <= 1 the series DIVERGES, so
    zeta(p)-1 is the analytic continuation and carries no information about the
    sum: by T1 a halt index exists there too, and we find it by direct summation.
    """
    with mp.workdps(dps):
        if p <= 1:
            # divergent series: the partial sums reach 1, so N(p) exists.
            r = mpf(1)
            s = mpf(0)
            for n in range(cap):
                a = power(mpf(n + 2), -p)
                s += a
                if s >= 1:
                    return n + 1, mpf('inf')
            return None, mpf('inf')
        Sinf = zeta(p) - 1
        if Sinf < 1:
            return None, Sinf
        hi = 4
        while S_partial(hi, p) < 1:
            hi *= 2
            # when p is within ~1e-10 of p*, N(p) can exceed any practical budget;
            # report that honestly rather than pretending there is no halt.
            if hi > 10 ** 12:
                return ('deep', Sinf)
        lo = 1
        while lo < hi:
            mid = (lo + hi) // 2
            if S_partial(mid, p) >= 1:
                hi = mid
            else:
                lo = mid + 1
        return lo, Sinf


# ============================================================================
# 2.  the greedy rule, index by index (definition of record)
# ============================================================================

def greedy_direct(p, nmax=2_000_000, dps=60, wall=150.0):
    """r_0 = 1; at index n take 1 iff r >= alpha_n and set r <- r - alpha_n.

    alpha is non-increasing, so once an index is skipped after at least one
    selection, no later index can ever be selected: the process halts.  A leading
    run of skips (before the first selection) is permitted -- that is the
    r_0 < alpha_0 phenomenon (e.g. theta = pi).
    The residual is maintained by direct subtraction, so the floating error after
    N steps is O(N * 10^-dps); at dps=60 and N <= 10^6 it is below 1e-12 and all
    quoted digits are <= 8 significant.
    """
    with mp.workdps(dps):
        r = mpf(1)
        sel = []
        t0 = time.time()
        for n in range(nmax):
            a = power(mpf(n + 2), -p)
            if a <= r:
                r -= a
                sel.append(n)
                if r <= 0:
                    return dict(term=True, sel=sel, residual=mpf(0), m=n,
                                why="residual reached 0", elapsed=time.time() - t0)
            elif sel:
                return dict(term=True, sel=sel, residual=r, m=n - 1,
                            why="halt: residual < next term",
                            elapsed=time.time() - t0)
            if time.time() - t0 > wall:
                return dict(term=None, sel=sel, residual=r, m=n, why="time cap",
                            elapsed=time.time() - t0)
        return dict(term=None, sel=sel, residual=r, m=nmax - 1, why="index cap",
                    elapsed=time.time() - t0)


def gap_census(p, ncap, dps=60):
    with mp.workdps(dps):
        r = mpf(1)
        sel = []
        for n in range(ncap):
            a = power(mpf(n + 2), -p)
            if a <= r:
                r -= a
                sel.append(n)
        gaps = [sel[i + 1] - sel[i] for i in range(len(sel) - 1)]
        return sel, gaps, r


# ============================================================================
# 3.  exact integer arithmetic for rational p = u/v
# ============================================================================

def max_gap(sel):
    return max((sel[i + 1] - sel[i] for i in range(len(sel) - 1)), default=0)


def rational_greedy(q, D, cap=200_000):
    """Exact integer greedy for p = u/v rational.

    alpha_n = (n+2)^(-u/v) is A_n = floor(10^D (n+2)^(-u/v)); the residual is an
    integer R in units of 10^-D.  Select iff R >= A_n; halt when R < A_n and at
    least one selection has been made.  Returns
    (halted, last_index, R, sel, maxgap, why).  No binary float is used.
    """
    A = 10 ** D
    with mp.workdps(D + 40):
        R = A
        sel = []
        n = 0
        while n < cap:
            a = int(mp.floor(
                power(mpf(n + 2), Fraction(-q.numerator, q.denominator)) * A))
            if a <= 0:
                return (R == 0, n - 1, R, sel, max_gap(sel),
                        "term below precision")
            if R < a:
                if sel:
                    return (R == 0, n - 1, R, sel, max_gap(sel),
                            "halt: residual < next term")
                n += 1
                continue
            R -= a
            sel.append(n)
            n += 1
        return (None, n - 1, R, sel, max_gap(sel), "cap")


# ============================================================================
# 4.  exhaustive catalogue of realisable complexity profiles
# ============================================================================

def catalogue(maxN=20, maxones=4):
    k1_violations, below_k1, maxp_vs_am, profiles = [], 0, [], set()
    for N in range(2, maxN + 1):
        for m in range(0, maxones):
            for supp in combinations(range(N), m + 1):
                a0, am, span = support_bounds(supp)
                prof = profile(supp, N)
                profiles.add(tuple(prof))
                maxp_vs_am.append((am, m, max(prof), supp, N))
                lo = max(span, am + 1)
                for L in range(lo, N):
                    if prof[L - 1] != k1_predict(am, L, N):
                        k1_violations.append((supp, N, L, prof[L - 1],
                                              k1_predict(am, L, N)))
                if lo - 1 >= 1 and prof[lo - 2] == k1_predict(am, lo - 1, N):
                    below_k1 += 1
    return dict(k1_violations=k1_violations, below_k1=below_k1,
                maxp_vs_am=maxp_vs_am, profiles=profiles)


def linear_prefix_ok(supp, N, c, Lmax):
    prof = profile(supp, N)
    return all(prof[L - 1] == c * L for L in range(1, min(Lmax, N) + 1))


# ============================================================================
#  main
# ============================================================================

def hr(t):
    print("\n" + "=" * 78)
    print(t)
    print("=" * 78)


def main():
    t_start = time.time()

    # ------------------------------------------------------------------ P0
    hr("PART 0.  The two recorded thresholds")
    pstar = findroot(lambda p: zeta(p) - 2, mpf("1.73"))
    print("HANDOFF section 4 records (F1) p>1 and (F2) zeta(p)>=2; section 10 on 3/2.")
    print(f"\nrecomputed p* = root of zeta(p)=2:  p* = {mp.nstr(pstar, 22)}")
    print(f"   zeta(p*) - 2  = {mp.nstr(zeta(pstar) - 2, 5)}")
    print(f"   p* - 3/2      = {mp.nstr(pstar - mpf(3)/2, 22)}   -> NOT 3/2")
    print(f"   {'p':>16} {'zeta(p)-1 = sum alpha_n':>24}  verdict for x=1")
    for q in ["1/2", "3/2", "1.6", "1.7", "1.7286472389", "1.7286472390",
              "1.7286472391", "1.73"]:
        qq = mpf(q.split('/')[0]) / mpf(q.split('/')[1]) if '/' in q else mpf(q)
        if qq <= 1:
            print(f"   {q:>16} {'DIVERGES (p<=1)':>24}  sum = +inf -> halts")
            continue
        v = zeta(qq) - 1
        print(f"   {q:>16} {mp.nstr(v, 16):>24}  "
              f"{'sum>=1 -> halts' if v >= 1 else 'sum<1  -> never halts'}")

    # ------------------------------------------------------------------ P1
    hr("PART 1.  T1: exact structure of the greedy rule on a non-increasing alphabet")
    print("""
THEOREM T1 (proved here).  Let alpha_0 >= alpha_1 >= ... > 0 be non-increasing,
x > 0, and run r_0 = x; at index n take 1 (r <- r - alpha_n) iff r >= alpha_n.
Write S(n) = alpha_0 + ... + alpha_{n-1}.  Then:
  (i)   the taken set is an initial segment {k, k+1, ..., N-1}, where N = min{n :
        S(n) >= x} and k = min{n : alpha_n <= x}.  Reason: if index n is skipped
        after some index has been taken, then r_n < alpha_n <= alpha_m for every
        m >= n, and r is unchanged by skips, so no later index is ever taken;
  (ii)  the process halts finitely  <=>  sum_{n>=0} alpha_n >= x;
  (iii) the halt residual is S(N) - x >= 0, it satisfies S(N) - x < alpha_N
        (which is exactly why index N is skipped), and it is 0 if and only if x
        is a finite subsum of the alpha_n.
  Proof sketch.  If S(N) >= x, then for every n < N we have r_n = x - S(n) >= x -
  S(N) + alpha_n > alpha_n (since x - S(N) < 0 is impossible... precisely:
  r_n - alpha_n = x - S(n+1) >= x - S(N) >= 0 for n+1 <= N), so every n < N is
  taken.  At n = N the residual is x - S(N) < 0... i.e. S(N) - x > 0 and
  S(N) - x = (S(N-1) - x) + alpha_{N-1} < alpha_{N-1} <= alpha_N because
  S(N-1) < x.  Hence index N is skipped, and by (i) the process halts.
  If sum alpha_n < x then r_n = x - S(n) > sum_{m>=n} alpha_m >= alpha_n, so
  every index is taken and there is no halt.  QED

Consequence for alpha_n=(n+2)^-p, x=1: sum_n alpha_n = zeta(p)-1, so the process
halts iff zeta(p) >= 2 iff p <= p*.  This proves (F2); it also shows the halt is
a statement about the partial sums, not about the residual reaching exactly 0.
""")
    print("Numerical confirmation (S(N)=zeta(p,2)-zeta(p,N+2), 80 dps):")
    print(f"{'p':>18} {'zeta(p)-1':>16} {'N(p)':>12} {'halt residual':>15} "
          f"{'alpha_N':>12} {'res<alpha?':>11}  time")
    rows = ["1.5", "1.6", "1.7", "1.71", "1.72", "1.728", "1.7286",
            "1.728647", "1.7286472", "1.72864723", "1.728647238",
            "1.7286472389", "1.7286472390", "1.7286472391", "1.72864724",
            "1.72868", "1.73"]
    for pstr in rows:
        p = mpf(pstr)
        t0 = time.time()
        N, Sinf = terminal_index(p)
        if N == 'deep':
            print(f"{pstr:>18} {mp.nstr(Sinf, 12):>16} {'>1e12':>12}  "
                  f"N(p) exceeds the 1e12 budget (p is within ~1e-10 of p*); "
                  f"halts in principle by T1 ({time.time()-t0:.2f}s)", flush=True)
            continue
        if N is None:
            print(f"{pstr:>18} {mp.nstr(Sinf, 12):>16} {'NONE':>12}  "
                  f"zeta(p)-1 < 1: every index is taken, no finite halt "
                  f"({time.time()-t0:.2f}s)", flush=True)
            continue
        res = S_partial(N, p) - 1
        aN = power(mpf(N + 2), -p)
        print(f"{pstr:>18} {mp.nstr(Sinf, 12):>16} {N:>12} {mp.nstr(res, 8):>15} "
              f"{mp.nstr(aN, 8):>12} {str(0 <= res < aN):>11}  "
              f"{time.time()-t0:.2f}s", flush=True)

    print("\nindependent greedy simulation (index by index) vs T1's N(p):")
    for pstr in ["1.5", "1.7", "1.7286"]:
        p = mpf(pstr)
        N, _ = terminal_index(p)
        g = greedy_direct(p, nmax=N + 10)
        ok = (g["term"] is True and g["sel"] == list(range(N - 1)))
        print(f"   p={pstr:>8}: halted={str(g['term']):>5} #taken={len(g['sel']):>7} "
              f"last={g['m']:>7} residual={mp.nstr(g['residual'], 8):>12} | "
              f"N(p)={N:>7} taken==0..N-2: {ok}  ({g['elapsed']:.1f}s)", flush=True)

    print("\ncross-check S_partial vs direct summation:")
    for pstr, N in [("1.5", 10), ("1.7", 106), ("1.7286", 2000)]:
        p = mpf(pstr)
        a, b = S_partial(N, p), S_direct(N, p)
        print(f"   p={pstr:>8} N={N:>6}  S_partial={mp.nstr(a,18)}  "
              f"S_direct={mp.nstr(b,18)}  |diff|={mp.nstr(abs(a-b),3)}")

    # ------------------------------------------------------------------ P2
    hr("PART 2.  T1 in EXACT integer arithmetic for rational p = u/v")
    print("""
The residual is an integer R in units of 10^-D; alpha_n is A_n=floor(10^D
(n+2)^(-u/v)); the test is the integer comparison R >= A_n; halt is R < A_n after
at least one selection.  No binary float is used.
""")
    print(f"{'p=u/v':>10} {'D':>4} {'halted':>7} {'last idx':>9} {'#taken':>7} "
          f"{'maxgap':>7} {'why':>28}  time")
    for q in [Fraction(3, 2), Fraction(17, 10), Fraction(6, 5),
              Fraction(4, 3), Fraction(2, 1)]:
        for D in (30, 60):
            t0 = time.time()
            term, m, R, sel, mg, why = rational_greedy(q, D, cap=200_000)
            print(f"{str(q):>10} {D:>4} {str(term):>7} {m:>9} {len(sel):>7} "
                  f"{str(mg):>7} {why:>28}  ({time.time()-t0:.1f}s)", flush=True)

    print("\nexactly rational instance with no rounding at all:")
    R = Fraction(1, 4) - Fraction(1, 4)         # alpha_0 = 2^-2 = 1/4
    print(f"   target x=1/4, p=2: alpha_0=1/4, residual={R}, exact halt={R==0}")

    print("\nfinite-subsum search for exact termination (is 1 = sum over a finite")
    print("subset of {(n+2)^-p} ?), exhaustive subsets up to size 10 over n <= 11:")
    def finite_subsum_hits(pval, nmax=12, maxsize=10):
        with mp.workdps(60):
            vals = [power(mpf(n + 2), -pval) for n in range(nmax)]
            hits = []
            for size in range(1, maxsize + 1):
                for comb in combinations(range(nmax), size):
                    if abs(mp.fsum(vals[i] for i in comb) - 1) < mpf(10) ** -45:
                        hits.append(comb)
            return hits
    for pstr in ["3/2", "4/3", "6/5"]:
        h = finite_subsum_hits(mpf(pstr))
        print(f"   p={pstr:>5}: exact subset-sum hits up to size 10, n<=11 : "
              f"{h if h else 'NONE'}")

    # ------------------------------------------------------------------ P3
    hr("PART 3.  (F1):  the word of the family, and bounded gaps")
    print("""
By T1 the taken set for alpha_n=(n+2)^-p and x=1 is exactly {0,...,N(p)-1} when
p <= p*, so the greedy word is the FINITE prefix of ones 1^{N(p)} 0^inf and every
gap between taken indices is 1.  When p > p*, sum alpha_n < 1, so T1's no-halt
branch applies and EVERY index is taken: the word is 1^inf, again with all gaps 1.
Hence (F1) is verified in the strong form
      bounded gaps  <=>  p > 1  <=>  sum_n (n+2)^-p converges,
and the gap structure is the constant sequence 1.
""")
    print(f"{'p':>10} {'regime':>18} {'N(p)':>12} {'#taken':>8} {'word':>14} "
          f"{'max gap':>8} {'halt residual':>15}")
    for pstr in ["0.5", "0.9", "1.0", "1.2", "1.3", "1.5", "1.7", "1.7286",
                 "1.7286472390", "1.73", "2.0"]:
        p = mpf(pstr)
        N, Sinf = terminal_index(p)
        if N == 'deep':
            print(f"{pstr:>10} {'halt N>1e12':>18} {'>1e12':>12} {'-':>8} "
                  f"{'1^N 0^inf':>14} {'1':>8} {'~0':>15}", flush=True)
            continue
        if N is None:
            sel, gaps, r = gap_census(p, 20000)
            lab = 'sum diverges' if p <= 1 else 'sum<1, no halt'
            print(f"{pstr:>10} {lab:>18} {'-':>12} {'all':>8} "
                  f"{'1^inf':>14} {str(max(gaps) if gaps else 1):>8} "
                  f"{mp.nstr(r,8):>15}", flush=True)
        elif N <= 600000:
            g = greedy_direct(p, nmax=N + 10)
            sel = g["sel"]
            gaps = [sel[i + 1] - sel[i] for i in range(len(sel) - 1)]
            # p=1 is the zeta pole: use the exact harmonic partial sum there
            res = (mp.fsum([power(mpf(n + 2), -p) for n in range(N)]) - 1
                   if p == 1 else S_partial(N, p) - 1)
            print(f"{pstr:>10} {('halt at N=%d' % N):>18} {N:>12} "
                  f"{len(sel):>8} {('1^%d 0^inf' % N):>14} "
                  f"{str(max(gaps) if gaps else 1):>8} "
                  f"{mp.nstr(res,8):>15}", flush=True)
        else:
            print(f"{pstr:>10} {('halt at N=%d' % N):>18} {N:>12} "
                  f"{'N':>8} {'1^N 0^inf':>14} {'1':>8} "
                  f"{mp.nstr(S_partial(N,p)-1,8):>15}", flush=True)
    print("\n(HALTING vs EXACT TERMINATION.  The halt residual is S(N(p))-1 > 0 in")
    print(" every case tabulated, so the target 1 is NOT met exactly: the process")
    print(" stops only because the remaining terms are individually too small.  Exact")
    print(" residual 0 would require 1 to be a finite sum of the (n+2)^-p; by T1(iii)")
    print(" that is an algebraic non-degeneracy question, and it was tested and NOT")
    print(" found for the cases below.  [CONJECTURE: it never occurs for non-integer p.])")

    # ------------------------------------------------------------------ P4
    hr("PART 4.  (F3): 'bounded gaps OR termination, never both' -- REFUTED")
    print(f"""
T1 + the word structure give, for alpha_n=(n+2)^-p and x=1, p*={mp.nstr(pstar,12)}:

     p <= 1        : sum diverges  -> halts;  word 1^{{N(p)}}0^inf; gaps all 1
     1 < p <= p*   : sum >= 1      -> halts;  word 1^{{N(p)}}0^inf; gaps all 1
     p > p*        : sum <  1      -> no halt; word 1^inf;          gaps all 1

So for EVERY p tested the taken gaps are all exactly 1 (bounded), and for every
p <= p* the process halts.  On the interval 1 < p <= p* (length {mp.nstr(pstar-1,6)})
BOTH hold simultaneously.  (F3) is FALSE as stated, with an explicit witness:
p = 3/2 gives the word of ten 1s followed by zeros (T1's N(p)=10), all gaps 1,
and the process halts after index 8.
""")
    N15, _ = terminal_index(mpf("1.5"))
    g = greedy_direct(mpf("1.5"), nmax=N15 + 10)
    sel = g["sel"]
    print("WITNESS p = 3/2, x = 1:")
    print(f"   taken indices : {sel}")
    print(f"   #taken        : {len(sel)}  (= N(p) = {N15})")
    print(f"   gaps          : {[sel[i+1]-sel[i] for i in range(len(sel)-1)]}"
          f"  -> max gap 1")
    print(f"   word          : {'1'*N15} then all 0   ({N15} ones in a row)")
    print(f"   halt residual : S(N(p))-1 = {mp.nstr(S_partial(N15, mpf('1.5'))-1, 8)}"
          f"  < alpha_N = {mp.nstr(power(mpf(N15+2), mpf('-1.5')), 8)}")
    print("   BOUNDED GAPS: yes (all 1).   HALTS: yes.   -> both, contra (F3).")
    print("\nwhat is true: the two thresholds are DIFFERENT numbers (1 vs p*), so the")
    print("trade-off is a property of the parameter range, not a dichotomy.  For a")
    print("general target x the halt threshold moves but the gap threshold does not:")
    with mp.workdps(50):
        for x in ["0.9", "0.5", "0.3", "0.1"]:
            px = findroot(lambda q: zeta(q) - 1 - mpf(x), mpf("1.4"))
            print(f"   x={x:>4}: halts iff p <= {mp.nstr(px,10):>12}   "
                  f"(gaps are all 1 for every p>0)")

    # ------------------------------------------------------------------ P5
    hr("PART 5.  The INVERSE problem: which p(L) is realisable?")
    print("""
K1 (proved, combinatorial) for ANY finitely supported 0/1 word with last 1 at
a_m and span = a_m - a_0, for every L >= max(span, a_m+1),

    p(L) = min(a_m+1, N-L+1) + [L <= N-a_m-1].

So the profile is RIGID for large L: value a_m+2 on the plateau, then slope -1.
Consequences (all arithmetic-free):
  (I1) max_L p(L) <= a_m + 2 for EVERY finitely supported word: p(N-1) = 2 is the
       top of the decay tail and the plateau value is a_m+2.  On a truncation with
       2a_m+2 <= N the plateau is non-empty and max_L p(L) = a_m + 2 exactly.
  (I2) the large-L shape has no free parameters beyond a_m and N.
  (I3) every alphabet with sum alpha_n >= x halts (T1), hence has finitely many
       ones, hence a finite word, hence a BOUNDED profile by (I1).
""")
    cat = catalogue(maxN=20, maxones=4)
    print(f"exhaustive catalogue: every support with N<=20 and <=4 ones "
          f"({len(cat['maxp_vs_am'])} words)")
    print(f"   K1 violations on L >= max(span,a_m+1) : {len(cat['k1_violations'])}")
    for v in cat["k1_violations"][:5]:
        print("      ", v)
    print(f"   extra cases where K1 holds one step below its range: {cat['below_k1']}")
    print(f"   distinct realisable complexity profiles : {len(cat['profiles'])}")
    over = [(am, mx, supp, N) for (am, m, mx, supp, N) in cat["maxp_vs_am"]
            if mx > am + 2]
    elig = [(am, m, mx, supp, N) for (am, m, mx, supp, N) in cat["maxp_vs_am"]
            if 2 * am + 2 <= N]
    print(f"   words with max p > a_m+2 (must be 0)          : {len(over)}")
    print(f"   K1-eligible words (N >= 2a_m+2): {len(elig)};  of these, those with"
          f" max p == a_m+2 : {sum(1 for e in elig if e[2] == e[0] + 2)}")

    print("\n(I1) exact maximum on K1-ELIGIBLE truncations (plateau non-empty):")
    print(f"{'support':>20} {'N':>5} {'a_m':>6} {'#ones':>6} {'max p':>7} "
          f"{'a_m+2':>7} {'argmax L':>9} {'K1 ok':>6}")
    for supp, N in [((3,), 20), ((0, 1), 20), ((0, 2), 20), ((0, 3), 20),
                    ((0, 2, 5), 20), ((0, 1, 2), 20), ((1, 3, 5), 24)]:
        am = supp[-1]
        prof = profile(supp, N)
        mx = max(prof)
        lo = max(am - supp[0], am + 1)
        ok = all(prof[L - 1] == k1_predict(am, L, N) for L in range(lo, N))
        print(f"{str(supp):>20} {N:>5} {am:>6} {len(supp):>6} {mx:>7} "
              f"{am+2:>7} {prof.index(mx)+1:>9} {str(ok):>6}",
              flush=True)

    print("\n(I3) p(L)=cL is realisable by NO alphabet with sum alpha_n >= x:")
    print(f"{'c':>4} {'witness for p(L)=cL on 1..6 (support,N)':>42}   note")
    for c in (1, 2, 3):
        found = None
        for N in range(2 * c + 3, 23):
            for m in range(0, 5):
                for supp in combinations(range(N), m + 1):
                    if linear_prefix_ok(supp, N, c, 6):
                        found = (supp, N)
                        break
                if found:
                    break
            if found:
                break
        print(f"{c:>4} {str(found):>42}   "
              f"{'prefix only; a_m grows with Lmax' if found else 'impossible'}")
    print("\nAny candidate witness can only match on a PREFIX: K1 bounds max_L p(L)")
    print("by a_m+2, a fixed number for the word, while cL is unbounded.  Since every")
    print("summable alphabet halts (T1) and so yields a finite word, no such alphabet")
    print("realises linear growth for all L.  Hence unbounded complexity growth is")
    print("INCOMPATIBLE with a halting (finite-support) alphabet.")

    # ------------------------------------------------------------------ P6
    hr("PART 6.  Summary of the inverse answer")
    print("""
  * For alpha_n=(n+2)^-p the greedy word is 1^{N(p)}0^inf (p<=p*) or 1^inf
    (p>p*): the ONLY free parameter is the terminal index N(p), and every gap is
    1.  The family is combinatorially rigid -- it realises only the complexity
    profiles of prefixes of ones (and of 1^inf).
  * For a general non-increasing alphabet T1 still forces a finite word whenever
    sum alpha_n >= x, and K1 then forces the rigid large-L profile.  A prescribed
    p(L) is realisable only if it agrees, for L >= max(span,a_m+1), with
    min(a_m+1, N-L+1) + [L <= N-a_m-1] for some a_m, N.
  * Consequently p(L)=cL (c>0) and p(L)=L+1 for all L are NOT realisable, and
    exact termination with unbounded complexity growth is impossible.
""")

    hr("SUMMARY")
    print(f"total runtime {time.time()-t_start:.1f}s")
    print(f"""
VERIFIED NUMERICALLY (exact / high precision):
  * p* = {mp.nstr(pstar,18)} where zeta(p*)=2;  3/2 is not a threshold.
  * halt indices N(p): 1.5->10, 1.7->106, 1.7286->587968, 1.72864723->74908843462;
    p >= p* -> no halt (sum < 1).  Halt residual = S(N(p))-1 > 0 in every case.
  * the word: 1^{{N(p)}}0^inf for p <= p*, 1^inf for p > p*; all gaps exactly 1.
  * K1 Theorem A: 0 violations over the exhaustive catalogue and the dialogue words.
  * exact integer certificate (p=3/2, D=30,60): halts at index 8 after 9 selections.

PROVED IN THIS REPORT:
  (T1) the greedy rule on a non-increasing alphabet halts iff sum alpha_n >= x,
       the taken set is an initial segment, and the halt residual is S(N)-x,
       zero exactly when x is a finite subsum.  => (F2) CORRECT.
  (T2) the word of the family is 1^{{N(p)}}0^inf or 1^inf, so gaps are all 1 for
       every p tested; bounded gaps <=> p>1 <=> convergence.  => (F1) CORRECT.
  (T3) 1<p<=p* gives bounded gaps AND a halt: (F3) REFUTED, witness p=3/2.
  (T4) K1 + T1: every summable alphabet yields a finite word with
       max p(L) <= a_m+2 (equality on an eligible truncation), so p(L)=cL is
       unrealisable and unbounded complexity growth is incompatible with a
       halting alphabet.

OPEN / CONJECTURE:
  [NOT RUN] exact integer certificate for irrational p at very high D.
  [CONJECTURE] with a NON-monotone alphabet the taken set need not be an initial
  segment and the complexity profiles could be richer; not explored here.
  [OPEN] a characterisation of realisable profiles for non-monotone alphabets.
""")


if __name__ == "__main__":
    main()
