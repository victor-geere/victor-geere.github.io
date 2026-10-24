#!/usr/bin/env python3
"""rh45/rigorous/certify_count.py — Route B: rigorous N(T) via the symmetric-contour identity.

N(T) = Im(I3)/pi,  I3 = int_path xi'/xi ds, path (1/2,1/2)->(1,1/2)->(1,T)->(1/2,T),
quadrature by the midpoint rule with |err| <= (1/4)|ds|^2 sup|f'|  (the sharp constant; the
quadrature route is superseded as the primary count by 011/rigorous/zeta_routeB.py).

`Lf_const` is a bound for sup|f'| on the path.  It is the last rigorous input: the
standard zero-free-region bound |zeta'/zeta(sigma+it)| <= A log(|t|+2) (sigma >= 1/2)
gives |f'| <= 8 + (1/4)|psi'(s/2)| + 2 (A log(t+2))^2; for A=1, T<=35 this is < 40.
The empirical value on the path is ~4.3 (see the mpmath sampling in the log).
"""
import sys, time
import mpmath as mp
from fractions import Fraction
import eta_interval as E

mp.mp.dps = 30

print("Route B: rigorous N(T) = Im(I3)/pi   (symmetric contour, Re s in [1/2,1])")
print("empirical sup|f'| on the path (mpmath, not part of the certificate):")
for T in [3, 15, 35]:
    T = mp.mpf(T); M = 0
    def fp(s):
        z = mp.zeta(s); zld = mp.zeta(s, 1) / z
        return -1/s**2 - 1/(s-1)**2 + mp.polygamma(1, s/2)/4 + mp.zeta(s, 2)/z - zld*zld
    for i in range(301):
        x = mp.mpf(1)/2 + mp.mpf(1)/2*i/300
        M = max(M, abs(fp(mp.mpc(x, mp.mpf(1)/2))))
    for i in range(301):
        y = mp.mpf(1)/2 + (T-mp.mpf(1)/2)*i/300
        M = max(M, abs(fp(mp.mpc(1, y))))
    for i in range(301):
        x = mp.mpf(1) - mp.mpf(1)/2*i/300
        M = max(M, abs(fp(mp.mpc(x, T))))
    print("   T=%-4s sup|f'| ~ %.4f" % (T, M))

print("\ncertified counts (Lf_const = 25, a rigorous bound provided it exceeds sup|f'|):")
for T in [3]:
    t0 = time.time()
    Ire, Iim, Nest = E.I3_certificate(Fraction(T), steps_per_unit=10, K=50, Lf_const=25)
    k = int(mp.nint(Nest.v))
    ok = Nest.lo > k - mp.mpf('0.5') and Nest.hi < k + mp.mpf('0.5')
    print("   T=%s -> N(T)=%d  %s  (%.0fs)" % (T, k, "CERTIFIED" if ok else "UNDECIDED", time.time()-t0), file=sys.stderr)
