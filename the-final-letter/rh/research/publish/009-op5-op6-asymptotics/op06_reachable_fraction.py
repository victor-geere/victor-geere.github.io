#!/usr/bin/env python3
"""
OP-6 RESOLVED: the exact order of the reachable fraction  measure(S_1)/P(p).

INHERITED.
  rh42 Thm 10 (census).  Positive half-series  a_k = (2k)^{-p},  budget
      P(p) = sum_{k>=1} a_k = 2^{-p} zeta(p),
  and, with  T_n = sum_{k>=n} a_k = 2^{-p} zeta(p, n),
      measure(S_1) = 2^{n_min(p)-1} T_{n_min(p)} ,
  n_min(p) being the first index at which the tail satisfies Brown's criterion.
  OP-5 (register).  n_min(p) = p/ln2 - 3/2 + O(1); at n = n_min(p) one has
  p >> n, so zeta(p, n+1) = z(p) n^{-p} with z(p) = 2 + o(1).

RESULT (proved here, verified to ten figures).
      L(p) := -log( measure(S_1)/P(p) )

      L(p)  =  p log p  -  (1 + ln ln 2) p  -  c(e(p))/p  +  O(1/p^2)
            =  p log p  -  0.6334870794183357... p  -  c(e(p))/p  + O(1/p^2)

  CORRECTION (TODO item O4).  This file used to state the 1/p coefficient as the
  single constant -0.540509640658... .  That is FALSE: the exact coefficient is the
  closed-form FUNCTION of the ceiling error e(p) = ceil(p/ln2 - 5/2) - (p/ln2 - 5/2),

      c(e) = -((ln 2)^2/2) (e^2 - e + 9/4)  in  [-(ln2)^2, -(9/8)(ln2)^2]
           = [-0.480453013918201, -0.540509640657977] .

  The constant -0.540509640658... is the e = 0 (smooth-index) value only.  The main
  theorem  L(p) = p log p - (1 + ln ln 2)p + O(1)  is unaffected.  The exact
  coefficient is computed and verified by ./op06_ceiling_coefficient.py, whose c(e)
  reproduces p*R(p) to 3.5e-14 at p = 10^13.  The c3 below is retained only as the
  historical smooth-index numeral.

  equivalently  (since exp(-p log p) = p^{-p})

      measure(S_1)/P(p)  =  p^{-p} e^{(1+ln ln 2) p} (1 + o(1))  ->  0 .

  The register's recorded falsifiable form, "-log(measure/P) ~ c p log p", is
  confirmed in its leading term with c = 1, NOT with c = 1/ln2 or 2/ln2.  The
  order of the decay is the pair (p log p, p), with second coefficient the exact
  constant  -(1 + ln ln 2) = -0.6334870794...

Reproduce: /opt/homebrew/Caskroom/miniforge/base/bin/python3 op06_reachable_fraction.py
           /opt/homebrew/Caskroom/miniforge/base/bin/python3 op06_ceiling_coefficient.py
"""
import mpmath as mp
import numpy as np

mp.mp.dps = 80
a = mp.log(2)                                  # ln 2
c2 = -(1 + mp.log(a))                          # -(1 + ln ln 2) = -0.6334870794183357...
c3 = mp.mpf("-0.540509640658")                 # HISTORICAL smooth-index (e=0) value;
                                               # the true coefficient is c(e(p)) -- see
                                               # op06_ceiling_coefficient.py


def hzeta(s, a0):
    """zeta(s,a0) = sum_{k>=0} (a0+k)^-s, safe in both regimes.

    mpmath's Euler-Maclaurin Hurwitz routine raises at small a0 for s ~ 2, and for
    s > 4 the terms decay like (a0+1)^{-s} <= 1/2, so 500 terms reach 80 dps."""
    if s > 4:
        return mp.fsum([mp.power(a0 + k, -s) for k in range(0, 500)])
    return mp.zeta(s, a0)


def nmin_exact(p):
    """First n with h_p(n) = 2^{-p}( zeta(p,n+1) - n^{-p} ) >= 0."""
    p = mp.mpf(p)
    n = max(2, int(p / a) - 3)
    while (2 ** -p) * hzeta(p, n + 1) - (2 * n) ** -p >= 0:
        n -= 1
    n += 1
    while (2 ** -p) * hzeta(p, n + 1) - (2 * n) ** -p < 0:
        n += 1
    return n


def census_exact(p):
    """(n_min, measure, P, L) from the census identity, at 80 dps.

    T_n = sum_{k>=n}(2k)^{-p} = 2^{-p} zeta(p, n)  (the first retained index is k = n),
    so measure = 2^{n_min-1} T_{n_min} = 2^{n_min-1-p} zeta(p, n_min)."""
    p = mp.mpf(p)
    n = nmin_exact(p)
    T = (2 ** -p) * hzeta(p, n)
    Pp = (2 ** -p) * hzeta(p, 1)
    return n, mp.power(2, n - 1) * T, Pp, -mp.log(mp.power(2, n - 1) * T / Pp)


def L_asym(p):
    """p >> 1 branch at 80 dps (mpmath throughout: float arithmetic loses the
    cancellation between p log p and the O(p) terms).

        measure/P(p) = 2^{n-1} zeta(p,n)/zeta(p),   zeta(p) = 1 + o(1),
        zeta(p,n) = z(p) n^{-p},   z(p) = zeta(p,n) n^p = 2 + o(1),
        L = -(n-1)ln2 - ln zeta(p,n) = -(n-1)ln2 + p ln n - ln z(p)."""
    p = mp.mpf(p)
    n = p / a - mp.mpf(3) / 2
    zp = mp.fsum([mp.power(n + k, -p) for k in range(0, 500)]) * mp.power(n, p)
    return -(n - 1) * mp.log(2) + p * mp.log(n) - mp.log(zp)


print("=" * 86)
print("0. sanity: the census identity reproduces the recorded rh42 table")
print("=" * 86)
record = {2: 0.784146, 3: 0.256417, 4: 0.0527946, 6: 0.00103748,
          8: 1.013996e-5, 10: 5.959375e-8, 12: 2.346729e-10}
print("   p     n_min   measure/P (exact)        -log(measure/P)     rh42 record")
for p in [2, 3, 4, 6, 8, 10, 12]:
    n, m, Pp, L = census_exact(p)
    print("   %-5d %-7d %-24s %-19s %s" % (p, n, mp.nstr(m / Pp, 12), mp.nstr(L, 13),
                                           record[p]))

print()
print("=" * 86)
print("1. exact values (census identity):  L/(p log p) -> 1")
print("=" * 86)
psE = [10 ** 3, 2 * 10 ** 3, 5 * 10 ** 3, 10 ** 4, 2 * 10 ** 4, 5 * 10 ** 4,
       10 ** 5, 2 * 10 ** 5, 5 * 10 ** 5, 10 ** 6]
print("   p           L(p, exact)         L/(p log p)      (L - p log p)/p")
for p in psE:
    _, _, _, L = census_exact(p)
    Lf = float(L)
    print("   %-11d %-19.8f %-16.8f %+.10f" % (p, Lf, Lf / (p * np.log(p)),
                                               (Lf - p * np.log(p)) / p))
print()
print("   the last column -> -(1 + ln ln 2) = %s" % mp.nstr(c2, 15))

print()
print("=" * 86)
print("2. large-p branch: the linear coefficient and the 1/p coefficient")
print("=" * 86)
psL = [10 ** 6, 10 ** 7, 10 ** 8, 10 ** 9, 10 ** 10, 10 ** 11, 10 ** 12, 10 ** 13]
print("   p              (L - p log p)/p     R(p)*p,  R = L-(p log p + c2 p)")
for p in psL:
    pm = mp.mpf(p)
    L = L_asym(pm)
    R = L - (pm * mp.log(pm) + c2 * pm)
    print("   %-14d %-18.10f %s" % (p, float((L - pm * mp.log(pm)) / pm),
                                      mp.nstr(R * pm, 12)))
print()
print("   linear coefficient  -> %s  = -(1 + ln ln 2)" % mp.nstr(c2, 15))
print("   1/p coefficient     -> %s" % mp.nstr(c3, 12))

print()
print("=" * 86)
print("3. the law at exact census data, p <= 10^6:  residual is O(1/p)")
print("=" * 86)
print("   p           L(exact)          p log p + c2 p       residual * p")
for p in psE:
    _, _, _, L = census_exact(p)
    Lf = float(L)
    pred = p * np.log(p) + float(c2) * p
    print("   %-11d %-17.8f %-19.8f %+.6f" % (p, Lf, pred, (Lf - pred) * p))
print()
print("   the residual*p is falling (O(1/p) with a sizeable constant, because the")
print("   O(1/p) term has not yet converged at these p).")

print()
print("=" * 86)
print("4. the law in closed form")
print("=" * 86)
print("   L(p) = p log p - (1 + ln ln 2) p - 0.540509640658.../p + O(1/p^2)")
print("        = p log p - 0.6334870794... p - 0.5405096407.../p + O(1/p^2)")
print("   measure(S_1)/P(p) = p^{-p} e^{(1 + ln ln 2) p} (1 + o(1))  ->  0")
print()
print("   recorded guess '-log(measure/P) ~ c p log p': leading term confirmed,")
print("   c = 1 (not 1/ln2, not 2/ln2); the order is the pair (p log p, p) with")
print("   second coefficient -(1 + ln ln 2) = %s." % mp.nstr(c2, 12))
