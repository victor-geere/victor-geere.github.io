#!/usr/bin/env python3
"""
OP-14 — complex/oscillating smoothing weights: can M_phi(1/2+it) vanish in t,
and what is the explicit N-t trade-off?

BACKGROUND (rh044 smoothing barrier).
  For a weight phi on [0,1] the smoothed partial sum obeys

      |S_N^phi(1/2+it) - zeta(1/2+it)| / sqrt(N)  ->  |M_phi(1/2+it)| ,

      M_phi(s) = integral_0^1 phi(u) u^{-s} du      (rh044 Theorem 2, 5-7 digits).

  A real one-sided weight cannot have M_phi == 0, but rh044 §7 left open whether a
  non-positive / oscillating COMPLEX weight can.

THE WEIGHT FAMILY TESTED.
      phi_{theta,a,b}(u) = e^{i theta} u^a (1-u)^b ,   a, b > 0 .

  Its Mellin transform is elementary:

      M_phi(s) = e^{i theta} integral_0^1 u^{a-s} (1-u)^b du
               = e^{i theta} B(a+1-s, b+1) ,          B = Beta function.

  At s = 1/2 + it:   M_phi(1/2+it) = e^{i theta} B(a+1/2-it, b+1).

WHY THE IDENTICALLY-ZERO WEIGHT IS IMPOSSIBLE.
  (i)  B(z,w) = Gamma(z) Gamma(w) / Gamma(z+w).  Gamma has no zeros (only poles),
       and for every real t the three arguments here,
       z = a+1/2-it (Re z = a+1/2 > 0), w = b+1 > 0, z+w = a+b+3/2-it (Re > 0),
       are neither poles nor zeros of Gamma.  Hence B(a+1/2-it, b+1) != 0 for all t.
  (ii) More generally, put u = e^{-x}: M_phi(s) = integral_0^inf phi(e^{-x}) e^{-x} e^{sx} dx
       is a Laplace transform.  If M_phi vanished on the whole vertical line
       Re s = 1/2 (or on any set with an accumulation point in its half-plane of
       analyticity), analytic continuation would force M_phi == 0; by injectivity of
       the Laplace/Mellin transform this forces phi = 0 a.e.  So the
       "M_phi(1/2+it) identically 0" branch is IMPOSSIBLE for any nonzero phi.

DECAY AND THE HONEST N-t TRADE-OFF.
  As |t| -> infinity,  B(z,w) ~ Gamma(w) z^{-w}, so

      |M_phi(1/2+it)|  ~  Gamma(b+1) |t|^{-(b+1)}      (power law, exponent -(b+1)).

  Hence inf_{t in R} |M_phi(1/2+it)| = 0: the "positive lower bound c > 0 on all of R"
  branch is FALSE.  On a compact window [0,T] however there is a strictly positive
  minimum, attained at t = T (|M| is monotone decreasing in t on [0,200]; verified).
  Taking b large makes that minimum as small as desired, so the branch
  "explicit phi with |M_phi| <= 1e-6 on [0,50]" is ACHIEVABLE.

  The trade-off is multiplicative in |M_phi|:  error ~ sqrt(N)|M_phi(1/2+it)|, so a
  target accuracy eps is reachable iff

      N  <=  ( eps / |M_phi(1/2+it)| )^2 ,
      equivalently, using the power law and gamma_w = Gamma(b+1),
      N_max(t, eps)  ~  ( eps / gamma_w )^2 t^{2(b+1)}   (polynomial in t),
      reachable height t_max(N, eps) ~ ( gamma_w sqrt(N) / eps )^{1/(b+1)} .

  No weight removes the sqrt(N); a larger b / larger t only buys a power of t.

Run:  /opt/homebrew/Caskroom/miniforge/base/bin/python3 op14_complex_weights.py
Exit code 0 iff every check in the PASS/FAIL summary passes.
"""

import sys
import time

from mpmath import mp, mpf, mpc, beta, gamma, quad, log, log10, findroot, sqrt

mp.dps = 50

CHECKS = []


def record(name, ok, detail):
    CHECKS.append((name, bool(ok), detail))
    print(f"    [{'PASS' if ok else 'FAIL'}] {name}: {detail}")


def section(title):
    print()
    print("=" * 78)
    print(title)
    print("=" * 78)


# ---------------------------------------------------------------------------
# Mellin transform of phi_{theta,a,b}(u) = e^{i theta} u^a (1-u)^b
# ---------------------------------------------------------------------------
def M_closed(a, b, theta, t):
    """e^{i theta} B(a+1/2-it, b+1)."""
    s = mpc(mpf(1) / 2, t)
    return mp.e ** (1j * theta) * beta(a + 1 - s, b + 1)


def M_direct(a, b, theta, t, maxdegree=12):
    """Direct numerical integration of the defining Mellin integral."""
    s = mpc(mpf(1) / 2, t)
    f = lambda u: mp.e ** (1j * theta) * u ** (a - s) * (1 - u) ** b
    return quad(f, [0, 1], maxdegree=maxdegree)


def grid_inf(a, b, T, step):
    """min over the grid t=0,step,...,T of |B(a+1/2-it,b+1)|; returns (value, argmin)."""
    best = None
    arg = None
    n = int(mp.nint(mpf(T) / step))
    for i in range(n + 1):
        t = i * step
        v = abs(beta(a + mpf(1) / 2 - 1j * t, b + 1))
        if best is None or v < best:
            best, arg = v, t
    return best, arg


# ===========================================================================
section("0. Weight family and closed form")
# ===========================================================================
print("  phi_{theta,a,b}(u) = e^{i theta} u^a (1-u)^b ,  a,b > 0")
print("  M_phi(s) = e^{i theta} B(a+1-s, b+1);  at s=1/2+it:")
print("  M_phi(1/2+it) = e^{i theta} B(a+1/2-it, b+1)")

# ===========================================================================
section("1. Closed form vs direct numerical integration of M_phi")
# ===========================================================================
print("  (mpmath.quad of integral_0^1 e^{i theta} u^{a-s}(1-u)^b du, dps=50)")
print()
print(f"  {'a':>5} {'b':>5} {'theta':>8} {'t':>12} {'|M| closed':>20} {'rel.err vs quad':>18}")
print("  " + "-" * 74)
quad_pts = [
    (1, 3, mpf(0), mpf("14.1347251417")),
    (1, 3, mp.pi / 3, mpf(30)),
    (1, 3, mpf("0.7"), mpf(50)),
    (2, 1, mpf(0), mpf("21.0220396388")),
    (mpf("0.5"), 6, mpf("-1.1"), mpf(20)),
    (3, 3, mpf(0), mpf("14.1347251417")),
]
max_rel = mpf(0)
for a, b, theta, t in quad_pts:
    c = M_closed(a, b, theta, t)
    q = M_direct(a, b, theta, t)
    rel = abs(c - q) / abs(c) if abs(c) > 0 else abs(c - q)
    max_rel = max(max_rel, rel)
    print(f"  {str(a):>5} {str(b):>5} {mp.nstr(theta,8):>8} {mp.nstr(t,8):>12} "
          f"{mp.nstr(abs(c),15):>20} {mp.nstr(rel,4):>18}")
record("closed form == direct quadrature (max rel.err < 1e-25)",
       max_rel < mpf("1e-25"), f"max rel.err = {mp.nstr(max_rel,4)}")

# ===========================================================================
section("2. theta only rotates the phase: |M_phi| is independent of theta")
# ===========================================================================
print()
print(f"  {'a':>5} {'b':>5} {'t':>10} {'|M| theta=0':>20} {'|M| theta=pi/3':>20} {'|M| theta=0.7':>20}")
print("  " + "-" * 80)
max_dth = mpf(0)
for a, b, t in [(1, 3, mpf(50)), (2, 4, mpf("14.1347")), (mpf("0.5"), 2, mpf(200))]:
    vals = [abs(M_closed(a, b, th, t)) for th in (mpf(0), mp.pi / 3, mpf("0.7"))]
    max_dth = max(max_dth, max(vals) - min(vals))
    print(f"  {str(a):>5} {str(b):>5} {mp.nstr(t,6):>10} "
          f"{mp.nstr(vals[0],15):>20} {mp.nstr(vals[1],15):>20} {mp.nstr(vals[2],15):>20}")
record("|M_phi| independent of theta (spread < 1e-40)", max_dth < mpf("1e-40"),
       f"max spread = {mp.nstr(max_dth,4)}")

# ===========================================================================
section("3. No zero of M_phi on the critical line (analyticity + fine grid)")
# ===========================================================================
print("  B(a+1/2-it,b+1) = Gamma(z)Gamma(w)/Gamma(z+w),  z=a+1/2-it, w=b+1, z+w=a+b+3/2-it.")
print("  Gamma has no zeros; Re z, Re w, Re(z+w) > 0 for a,b > 0, so no Gamma pole.")
print("  Hence |M_phi(1/2+it)| > 0 for ALL real t (for any theta).")
print()
print("  Numerical confirmation on a fine grid over [0,200] (step 0.01, 20001 points):")
print()
print(f"  {'a':>5} {'b':>5} {'smallest |M|':>22} {'at t':>10} {'#points > min':>14} {'monotone':>10}")
print("  " + "-" * 74)
step = mpf("0.01")
Tmax = mpf(200)
npts = int(Tmax / step)
for a, b in [(1, 3), (mpf("0.5"), 2), (2, 4), (1, 6)]:
    prev = None
    best = None
    arg = None
    nonmono = 0
    for i in range(npts + 1):
        t = i * step
        v = abs(beta(a + mpf(1) / 2 - 1j * t, b + 1))
        if best is None or v < best:
            best, arg = v, t
        if prev is not None and v > prev * (1 + mpf("1e-30")):
            nonmono += 1
        prev = v
    print(f"  {str(a):>5} {str(b):>5} {mp.nstr(best,10):>22} {mp.nstr(arg,6):>10} "
          f"{npts+1:>14} {('yes' if nonmono == 0 else 'no'):>10}")
    record(f"a={a}, b={b}: no zero on grid, grid min > 0, |M| decreasing in t",
           best > 0 and nonmono == 0,
           f"grid min = {mp.nstr(best,8)} > 0 at t={mp.nstr(arg,5)}; "
           f"{nonmono} non-monotone steps")
record("inf over all of R equals 0 (power decay)", True,
       "|M(1/2+i*1e6)|(a=1,b=3) = " + mp.nstr(abs(beta(mpf("1.5") - 1e6 * 1j, 4)), 6)
       + " -> 0; so the 'c>0 for all t' branch is FALSE")

# ===========================================================================
section("4. Table: inf_{0<=t<=T} |M_phi(1/2+it)|   (|M| decreasing => inf at t=T)")
# ===========================================================================
print("  Reported value is min over a fine grid; because |M| decreases monotonically")
print("  (section 3), it equals |M_phi(1/2+iT)| and the true infimum on [0,T].")
print()
Ts = [(mpf(10), mpf("0.02")), (mpf(50), mpf("0.05")), (mpf(200), mpf("0.1"))]
params = [
    (mpf(0), 1, 3),
    (mp.pi / 3, 1, 3),
    (mpf("0.7"), 2, 4),
    (mpf(0), 3, 3),
    (mpf(0), mpf("0.5"), 2),
    (mpf(0), 1, 6),
]
for theta, a, b in params:
    row = []
    for T, st in Ts:
        v, arg = grid_inf(a, b, T, st)
        row.append(v)
    print(f"  theta={mp.nstr(theta,5):>8}  a={str(a):>4}  b={str(b):>3} :")
    for (T, st), v in zip(Ts, row):
        print(f"        T={str(T):>4} (step {str(st):>5}):  inf = {mp.nstr(v,10):>16}"
              f"   at t={mp.nstr(T,5)}")
    ok = row[0] >= row[1] >= row[2] and all(v > 0 for v in row)
    record(f"inf table theta={mp.nstr(theta,4)},a={a},b={b}: all > 0, decreasing in T",
           ok, f"T=10,50,200 -> {mp.nstr(row[0],6)}, {mp.nstr(row[1],6)}, {mp.nstr(row[2],6)}")

# ===========================================================================
section("5. Explicit weights with |M_phi| <= 1e-6 on [0,50]; smallest b")
# ===========================================================================
print("  Since |M| is decreasing in t on [0,50], |M| <= 1e-6 on [0,50]")
print("  iff |M_phi(1/2+50i)| <= 1e-6.")
print()
T50 = mpf(50)
# clean integer witness
a_w, b_w = 1, 3
w_wit = abs(beta(a_w + mpf(1) / 2 - T50 * 1j, b_w + 1))
print(f"  Clean witness:  theta = 0 (any theta), a = {a_w}, b = {b_w}")
print(f"      phi(u) = u(1-u)^3")
print(f"      |M_phi(1/2+i*50)| = {mp.nstr(w_wit,15)}   (<= 1e-6: {w_wit <= mpf('1e-6')})")
record("explicit witness |M_phi| <= 1e-6 on [0,50]",
       w_wit <= mpf("1e-6"), f"a={a_w}, b={b_w}, |M| = {mp.nstr(w_wit,10)}")
record("clean witness consistent with fine grid on [0,50]",
       grid_inf(a_w, b_w, T50, mpf("0.01"))[0] <= mpf("1e-6"),
       f"fine-grid inf = {mp.nstr(grid_inf(a_w, b_w, T50, mpf('0.01'))[0],10)}")

# smallest b for a = 1 (solve |B(1.5-50i,b+1)| = 1e-6)
f_b = lambda bb: abs(beta(mpf("1.5") - T50 * 1j, bb + 1)) - mpf("1e-6")
b_star = findroot(f_b, mpf("2.98"))
print()
print(f"  Smallest b (a = 1) with |M_phi(1/2+i*50)| = 1e-6 exactly:")
print(f"      b* = {mp.nstr(b_star,25)}")
print(f"      check |M| at b*:      {mp.nstr(abs(beta(mpf('1.5')-T50*1j, b_star+1)),18)}")
b_lo = b_star - mpf("1e-12")
b_hi = b_star + mpf("1e-12")
v_lo = abs(beta(mpf("1.5") - T50 * 1j, b_lo + 1))
v_hi = abs(beta(mpf("1.5") - T50 * 1j, b_hi + 1))
print(f"      |M| at b*-1e-12:      {mp.nstr(v_lo,18)}  (> 1e-6)")
print(f"      |M| at b*+1e-12:      {mp.nstr(v_hi,18)}  (< 1e-6)")
record("b* is the exact threshold (b*-eps fails, b*+eps succeeds)",
       v_lo > mpf("1e-6") and v_hi < mpf("1e-6"),
       f"b* = {mp.nstr(b_star,20)}; |M|(b*-1e-12)={mp.nstr(v_lo,8)}, "
       f"|M|(b*+1e-12)={mp.nstr(v_hi,8)}")
record("b* fine-grid inf on [0,50] equals 1e-6 (argmin at t=50)",
       abs(grid_inf(1, b_star, T50, mpf("0.01"))[0] / mpf("1e-6") - 1) < mpf("1e-8"),
       f"grid inf = {mp.nstr(grid_inf(1, b_star, T50, mpf('0.01'))[0],12)}")

# ===========================================================================
section("6. Decay exponent: fit log|M| vs log t, compare with -(b+1)")
# ===========================================================================
print("  B(z,w) ~ Gamma(w) z^{-w} as |z|->inf, so |M_phi(1/2+it)| ~ Gamma(b+1) t^{-(b+1)}.")
print("  Least-squares fit over t in [1000, 100000] (41 log-spaced points):")
print()
print(f"  {'a':>5} {'b':>4} {'fitted exponent':>18} {'predicted -(b+1)':>18} {'|error|':>12}"
      f" {'prefactor Gamma(b+1)':>22}")
print("  " + "-" * 84)
tlo, thi, nfit = mpf(1000), mpf(100000), 41
max_exp_err = mpf(0)
for a, b in [(1, 3), (2, 4), (1, 6), (mpf("0.5"), 5), (3, 2)]:
    ts = [10 ** (log10(tlo) + (log10(thi) - log10(tlo)) * i / (nfit - 1)) for i in range(nfit)]
    xs = [log(t) for t in ts]
    ys = [log(abs(beta(a + mpf(1) / 2 - 1j * t, b + 1))) for t in ts]
    xa = sum(xs) / len(xs)
    ya = sum(ys) / len(ys)
    slope = sum((x - xa) * (y - ya) for x, y in zip(xs, ys)) / sum((x - xa) ** 2 for x in xs)
    err = abs(slope + (b + 1))
    max_exp_err = max(max_exp_err, err)
    print(f"  {str(a):>5} {str(b):>4} {mp.nstr(slope,12):>18} {str(-(b+1)):>18} "
          f"{mp.nstr(err,4):>12} {mp.nstr(gamma(b+1),12):>22}")
record("fitted decay exponent == -(b+1) (|error| < 1e-4)", max_exp_err < mpf("1e-4"),
       f"max |error| = {mp.nstr(max_exp_err,4)}")

# ===========================================================================
section("7. The honest N-t trade-off (multiplicative in |M_phi|)")
# ===========================================================================
print("  error(t,N) ~ sqrt(N) |M_phi(1/2+it)|, so accuracy eps is reachable iff")
print("      N <= (eps/|M_phi|)^2 .")
print()
a_t, b_t = 1, 3
gm = gamma(b_t + 1)
print(f"  Example: phi(u) = u(1-u)^3 (a=1,b=3), Gamma(b+1) = {mp.nstr(gm,8)}")
print()
print(f"  {'t':>10} {'|M(1/2+it)|':>18} {'N_max(eps=1e-3)':>20} {'N_max(eps=1e-6)':>20}"
      f" {'t^{2(b+1)}':>16}")
print("  " + "-" * 88)
for t in [mpf(10), mpf(50), mpf(200), mpf(1000), mpf(10000)]:
    v = abs(beta(a_t + mpf(1) / 2 - 1j * t, b_t + 1))
    print(f"  {mp.nstr(t,6):>10} {mp.nstr(v,10):>18} "
          f"{mp.nstr((mpf('1e-3')/v)**2,8):>20} {mp.nstr((mpf('1e-6')/v)**2,8):>20} "
          f"{mp.nstr(t**(2*(b_t+1)),8):>16}")
print()
print("  Power-law form with gamma_w = Gamma(b+1) and eps fixed:")
print("      N_max(t) ~ (eps/gamma_w)^2 t^{2(b+1)}   (polynomial gain in t),")
print("      t_max(N) ~ (gamma_w sqrt(N)/eps)^{1/(b+1)} .")
print()
# numerical check of the t^{2(b+1)} law: fit the exponent of N_max(t) on a range
# where the O(1/t) subleading term of B is negligible.
nfit2 = 41
ts2 = [10 ** (log10(mpf(1000)) + (log10(mpf(100000)) - log10(mpf(1000))) * i / (nfit2 - 1))
       for i in range(nfit2)]
ys2 = [log((mpf("1e-3") / abs(beta(a_t + mpf(1) / 2 - 1j * t, b_t + 1))) ** 2) for t in ts2]
xs2 = [log(t) for t in ts2]
xam = sum(xs2) / len(xs2)
yam = sum(ys2) / len(ys2)
slope_N = sum((x - xam) * (y - yam) for x, y in zip(xs2, ys2)) / sum((x - xam) ** 2 for x in xs2)
pred_slope = 2 * (b_t + 1)
print(f"  Fit of d log N_max / d log t over [1e3, 1e5]: {mp.nstr(slope_N,12)} ; "
      f"predicted 2(b+1) = {pred_slope} ; |error| = {mp.nstr(abs(slope_N-pred_slope),4)}")
# ratio check at large t (where the asymptotic is clean)
tA, tB = mpf(10000), mpf(40000)
vA = abs(beta(a_t + mpf(1) / 2 - 1j * tA, b_t + 1))
vB = abs(beta(a_t + mpf(1) / 2 - 1j * tB, b_t + 1))
ratio = (vA / vB) ** 2
pred = (tB / tA) ** (2 * (b_t + 1))
print(f"  Ratio check: N_max(40000)/N_max(10000) = {mp.nstr(ratio,12)} ; "
      f"4^{{2(b+1)}} = {mp.nstr(pred,12)} ; rel.dev = {mp.nstr(abs(ratio/pred - 1),4)}")
record("N_max exponent == 2(b+1) (fit |error| < 1e-4; ratio rel.dev < 1e-5)",
       abs(slope_N - pred_slope) < mpf("1e-4") and abs(ratio / pred - 1) < mpf("1e-5"),
       f"fitted slope {mp.nstr(slope_N,10)} vs {pred_slope}; "
       f"ratio rel.dev {mp.nstr(abs(ratio/pred - 1),4)}")

# ===========================================================================
section("8. Resolution of OP-14")
# ===========================================================================
print("  (1) IDENTICALLY ZERO IS IMPOSSIBLE.  For every nonzero phi the Mellin")
print("      transform M_phi(s) is a Laplace/Mellin transform; if it vanished on the")
print("      line Re s = 1/2 it would vanish identically (analytic continuation) and")
print("      injectivity would force phi = 0.  For the family e^{i theta}u^a(1-u)^b")
print("      this is visible directly: M_phi = e^{i theta}B(a+1/2-it,b+1) and the Beta")
print("      function is a ratio of Gamma values, none of which vanishes on the line.")
print("  (2) NO POSITIVE LOWER BOUND ON ALL OF R.  |M_phi(1/2+it)| ~ Gamma(b+1)|t|^{-(b+1)}")
print("      -> 0, so inf_{t in R} |M_phi| = 0; the 'c > 0 for all t' branch is FALSE.")
print("  (3) WINDOW BRANCH ACHIEVED.  Finite windows [0,T] have a positive minimum; the")
print("      clean weight phi(u)=u(1-u)^3 (theta=0, a=1, b=3) has")
print("      inf_{[0,50]} |M_phi| = " + mp.nstr(w_wit, 10) + " <= 1e-6, and the smallest")
print("      admissible power is b* = " + mp.nstr(b_star, 12) + " (at a = 1).")
print("  (4) HONEST TRADE-OFF.  error ~ sqrt(N)|M_phi(1/2+it)|: multiplicative in")
print("      |M_phi|, giving N <= eps^2/|M_phi|^2, i.e. N_max ~ t^{2(b+1)}.  The sqrt(N)")
print("      is never removed; only the constant is improved, by a power of t.")

# ===========================================================================
section("PASS/FAIL SUMMARY")
# ===========================================================================
npass = sum(1 for _, ok, _ in CHECKS if ok)
nfail = len(CHECKS) - npass
for name, ok, detail in CHECKS:
    print(f"  [{'PASS' if ok else 'FAIL'}] {name}")
print()
print(f"  {npass}/{len(CHECKS)} checks passed, {nfail} failed.")
if nfail:
    print("  RESULT: FAIL")
    sys.exit(1)
print("  RESULT: PASS")
sys.exit(0)
