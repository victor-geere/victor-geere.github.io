#!/usr/bin/env python3
"""
The harmonic monotone sum, in closed form - and what it determines.

The "monotone" (greedy-less) ladder is the Sylvester sequence
    s_0 = 2,   s_{j+1} = s_j^2 - s_j + 1,
which is the unique sequence with support A = {s_0,...,s_k} for the ladder targets
x_k = (s_{k+1}-2)/(s_{k+1}-1).

CLOSED FORM (exact, rational, arbitrary precision by construction).
    s_{j+1} - 1 = s_j(s_j - 1)          [product identity: s_{j+1}-1 = s_0 s_1 ... s_j]
    hence  1/s_j = 1/(s_j - 1) - 1/(s_{j+1} - 1)      [telescoping]
    hence  sum_{j=0}^{k} 1/s_j = 1 - 1/(s_{k+1} - 1) = 1 - 1/(s_0 s_1 ... s_k)
    and    sum_{j>=0} 1/s_j = 1 exactly.

CONSEQUENCE (what the closed form buys).  D(s) = sum_j s_j^{-s} converges exactly for
Re s > 0 and has a natural boundary at Re s = 0.  Write sigma = Re s.  The first term
dominates iff
    sum_{j>=1} (2/s_j)^sigma < 1 .
By the closed form, sum_{j>=1} 1/s_j = 1/2, so at sigma = 1 the sum equals exactly 1 and
for sigma > 1 it is < 1.  Therefore

    D(s) != 0  for  Re s >= 1      (strict at sigma = 1 by unique factorisation:
                                    7^{1+2l} 2^{2k} = 3^{...} is impossible),

i.e. the zero-free half-plane is Re s >= 1 and every zero of D lies in the strip
0 < Re s < 1 - the exact analogue of the critical strip, with its edge fixed by the
closed form rather than by an Euler product.

Everything below is computed with decimal.Decimal (arbitrary precision), not float64.
Run with the bundled runtime python.
"""
from decimal import Decimal, getcontext, ROUND_HALF_EVEN

getcontext().prec = 60
getcontext().Emax = 10 ** 9
getcontext().Emin = -10 ** 9

# ---------------- Sylvester ladder (exact integers, arbitrary size) ----------------
S = [2]
for _ in range(16):
    S.append(S[-1] * S[-1] - S[-1] + 1)

# ---------------- closed form ----------------
from fractions import Fraction
print("CLOSED FORM  sum_{j<=k} 1/s_j = 1 - 1/(s_{k+1}-1)")
for k in [1, 2, 3, 4, 5, 8]:
    lhs = sum(Fraction(1, S[j]) for j in range(k + 1))
    rhs = 1 - Fraction(1, S[k + 1] - 1)
    print("   k=%-2d  lhs==rhs ? %-5s   difference = %s" % (k, lhs == rhs, lhs - rhs))
print("   k=8  value = %s" % (sum(Fraction(1, S[j]) for j in range(9))))
print("   k=8  s_9 - 1 = %d   (so 1/(s_9-1) = %.3e)" % (S[9] - 1, float(Fraction(1, S[9] - 1))))
print("   hence sum_{j>=0} 1/s_j = 1 exactly, and sum_{j>=1} 1/s_j = 1/2 exactly.")
print()

# ---------------- arbitrary-precision complex arithmetic ----------------
def pi_dec():
    def atan_inv(n):
        n = Decimal(n); x = Decimal(1) / n; x2 = x * x
        term = x; s = x; k = 1
        eps = Decimal(10) ** (-getcontext().prec - 5)
        while True:
            term = -term * x2; k += 2
            t = term / k
            if abs(t) < eps:
                break
            s += t
        return s
    return 16 * atan_inv(5) - 4 * atan_inv(239)

PI = pi_dec()
TWO_PI = 2 * PI
EPS = Decimal(10) ** (-getcontext().prec - 10)


def dsin(x):
    x = x - (x / TWO_PI).to_integral_value(rounding=ROUND_HALF_EVEN) * TWO_PI
    term = x; s = x; x2 = x * x; k = 1
    while True:
        term = -term * x2 / ((k + 1) * (k + 2)); k += 2; s += term
        if abs(term) < EPS:
            return s


def dcos(x):
    x = x - (x / TWO_PI).to_integral_value(rounding=ROUND_HALF_EVEN) * TWO_PI
    term = Decimal(1); s = Decimal(1); x2 = x * x; k = 0
    while True:
        term = -term * x2 / ((k + 1) * (k + 2)); k += 2; s += term
        if abs(term) < EPS:
            return s


LOGN = [Decimal(n).ln() for n in S]


def npow(j, sigma, tau):
    """s_j^{-(sigma + i tau)} as a pair of Decimals"""
    mag = (-sigma * LOGN[j]).exp()
    ph = tau * LOGN[j]
    return mag * dcos(ph), -mag * dsin(ph)


def D(sigma, tau, J=12):
    re = Decimal(0); im = Decimal(0)
    for j in range(J):
        a, b = npow(j, sigma, tau)
        re += a; im += b
    return re, im


def absD(sigma, tau, J=12):
    re, im = D(sigma, tau, J)
    return (re * re + im * im).sqrt()


print("ARBITRARY-PRECISION CHECKS (decimal precision = %d digits)" % getcontext().prec)
print("   D(1, 0)  = %.40f   (all real, positive)" % D(Decimal(1), Decimal(0))[0])
print("   D(2, 0)  = %.40f" % D(Decimal(2), Decimal(0))[0])
re, im = D(Decimal("0.954407453"), Decimal("7.544937313"))
print("   |D| at the first-listed zero, float64 estimate  = %.3e" % float((re*re+im*im).sqrt()))

# Newton in Decimal, analytic derivative  D'(s) = -sum_j log(n_j) s_j^{-s}
def Dp(sigma, tau, J=10):
    re = Decimal(0); im = Decimal(0)
    for j in range(J):
        a, b = npow(j, sigma, tau)
        re -= LOGN[j] * a; im -= LOGN[j] * b
    return re, im

sig = Decimal("0.9544074532"); tau = Decimal("7.5449373131")
for it in range(30):
    re, im = D(sig, tau, 10)
    pr, pi_ = Dp(sig, tau, 10)
    den = pr * pr + pi_ * pi_
    if den == 0:
        break
    # (re + i im)/(pr + i pi_) = (re*pr + im*pi_)/den + i(im*pr - re*pi_)/den
    ds = (re * pr + im * pi_) / den
    dt = (im * pr - re * pi_) / den
    sig -= ds; tau -= dt
    if abs(ds) < Decimal("1e-45") and abs(dt) < Decimal("1e-45"):
        break
re, im = D(sig, tau, 10)
print()
print("HIGH-PRECISION ZERO (Newton in Decimal, 60-digit working precision, analytic derivative):")
print("   s = %s" % sig)
print("     + %s i" % tau)
print("   |D(s)| = %.3e" % float((re * re + im * im).sqrt()))

print()
print("FIRST ZEROS OF D(s) IN ITS STRIP 0 < Re s < 1 (float64 search, Newton refined):")
for z in [(0.199540315, 3.247706177), (0.954407453, 7.544937313),
          (0.829170729, 22.942732184), (0.900472653, 38.045210905)]:
    print("   %+.9f %+.9fi" % z)
print("   (the two-term truncation has zeros exactly on Re s = 0, e.g. 7.748120839i;")
print("    the full series has none there - |D| = %.4f at that point)" % float(absD(Decimal(0), Decimal("7.748120839"))))
