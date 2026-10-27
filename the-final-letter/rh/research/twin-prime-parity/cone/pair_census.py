#!/usr/bin/env python3
"""
pair_census.py — the radial-pair reachable set (the rh42 census analogue).

The pair alphabet is  a_k = (4k+2)^{-p} + (4k+4)^{-p},  k >= 0,  with total
A = sum_k a_k = P(p) = 2^{-p} zeta(p)  (p > 1).  Brown's criterion says the
sub-sums of (a_k) fill [0, A] iff a_k <= T_k := sum_{j>k} a_j for every k.

Reported here:
  * the Brown ratios a_k / T_k and the slack T_k / a_k (the k >= 1 slack);
  * the census: for p > p_pair only k = 0 fails (the all-k theorem), so the
    reachable set is exactly  [0, T_1] U [a_0, a_0 + T_1]  — two intervals with
    a gap of length 2 a_0 - A; for p <= p_pair it is the single interval [0, A].
"""
import mpmath as mp
mp.mp.dps = 50
z = mp.zeta

pN = mp.findroot(lambda p: (1-2**(-p))*z(p) - 2, 1.378)
pP = mp.findroot(lambda p: 2**(-p)*z(p) - 1, 1.465)
pp = mp.findroot(lambda p: z(p) - (2 + 2**(1-p)), 1.48)
ps = mp.findroot(lambda p: z(p) - 2, 1.7286)

def a(p, k):   return mp.mpf(4*k+2)**(-p) + mp.mpf(4*k+4)**(-p)
def total(p):  return 2**(-p)*z(p)          # P(p)
def tail(p, k):  # sum_{j>k} a_j  =  sum_{even m >= 4k+6} m^{-p}
    return total(p) - sum(a(p, j) for j in range(k+1))

print("thresholds:  pN =", mp.nstr(pN,12), " pP =", mp.nstr(pP,12),
      " p_pair =", mp.nstr(pp,12), " p* =", mp.nstr(ps,12))
print()
print("=== Brown ratios  r_k = a_k / T_k   (r_k <= 1  <=>  condition k holds) ===")
hdr = "     p    " + "".join(f"   r_{k}  " for k in range(7)) + "   min_{k>=1} T_k/a_k"
print(hdr)
for pv in [mp.mpf('1.40'), mp.mpf('1.45'), pp, mp.mpf('1.48'), mp.mpf('1.50'), mp.mpf('1.60')]:
    rs = []
    for k in range(7):
        ak, Tk = a(pv,k), tail(pv,k)
        rs.append(ak/Tk)
    slack = min(tail(pv,k)/a(pv,k) for k in range(1,7))
    print(f"  {mp.nstr(pv,8):>8}  " + "".join(f" {mp.nstr(r,6):>7}" for r in rs) + f"      {mp.nstr(slack,6)}")
print()
print("=== census:  intervals and gap of the reachable set ===")
print("     p        A = P(p)      a_0        T_1 = A - a_0    gap = 2a_0 - A   intervals  measure")
for pv in [mp.mpf('1.40'), mp.mpf('1.45'), pp, mp.mpf('1.48'), mp.mpf('1.50'), mp.mpf('1.60'), mp.mpf('2')]:
    A, a0 = total(pv), a(pv,0)
    T1 = A - a0
    gap = 2*a0 - A
    if a0 <= T1:
        print(f"  {mp.nstr(pv,8):>8}  {mp.nstr(A,10):>12} {mp.nstr(a0,10):>11} {mp.nstr(T1,12):>14}"
              f"   {'--':>13}        1     {mp.nstr(A,10)}")
    else:
        print(f"  {mp.nstr(pv,8):>8}  {mp.nstr(A,10):>12} {mp.nstr(a0,10):>11} {mp.nstr(T1,12):>14}"
              f"   {mp.nstr(gap,10):>12}        2     {mp.nstr(2*T1,10)}")
print()
print("=== recursion depth and census (from the ratios) ===")
print("  the reachable set is a union of 2^j intervals, where j = #{k : a_k > T_k}")
print("     p        depth j    intervals    measure of the reachable set   first gap")
for pv in [mp.mpf('1.40'), mp.mpf('1.45'), pp, mp.mpf('1.48'), mp.mpf('1.50'), mp.mpf('1.60'), mp.mpf('2'), mp.mpf('3')]:
    j = 0
    while a(pv, j) > tail(pv, j) and j < 200:
        j += 1
    # At depth j the levels 0..j-1 have failed and the tail from j is complete, so the
    # reachable set is 2^j copies of [0, sum_{i>=j} a_i] : measure = 2^j (A - sum_{i<j} a_i).
    # For j = 0 this is A itself (the two pieces merge), and the formula still holds.
    rem = total(pv) - sum(a(pv, i) for i in range(j))
    meas = (2**j) * rem if j < 60 else mp.inf
    gap = f"{mp.nstr(a(pv,0) - total(pv) + a(pv,0), 10)}" if j >= 1 else "--"
    print(f"  {mp.nstr(pv,8):>8}   {j:>6}      {2**j if j<60 else 'inf':>8}      {mp.nstr(meas,10):>14}   {gap:>14}")

print()
print("=== tail completeness: max_{1 <= k <= 200} a_k / T_k  (<= 1 means the tail is complete) ===")
print("     p        max ratio k>=1     tail complete?    -> census")
for pv in [mp.mpf('1.40'), mp.mpf('1.45'), pp, mp.mpf('1.48'), mp.mpf('1.50'), mp.mpf('1.60'), mp.mpf('2')]:
    mx = max(a(pv,k)/tail(pv,k) for k in range(1,201))
    ok = mx <= 1
    j = 0
    while a(pv,j) > tail(pv,j) and j < 200:
        j += 1
    print(f"  {mp.nstr(pv,8):>8}      {mp.nstr(mx,8):>10}          {str(ok):>6}        "
          f"{'1 interval [0, A]' if j==0 else f'2^j = {2**j} interval(s), gap {mp.nstr(2*a(pv,0)-total(pv),8)}'}")
print("\n[done]")
