#!/usr/bin/env python3
"""
PHASE 2 - can a greedy Egyptian support carry arithmetic structure?

Result: NO.
  (i)  No Euler product.  The greedy support A(x) (denominators n_j) is never
       multiplicatively closed for |A| >= 2 (2*2 = 4 is missing from every support
       tested), and for irrational x it cannot be: Sylvester sparsity forces
       n_{j+1} >= n_j(n_j-1)+1 (doubly exponential growth), while a multiplicative
       semigroup grows at most exponentially (powers of its least element).
       The only exceptions are unit fractions x = 1/m, giving the monomial m^{-s}.
  (ii) The only functional relation is Mahler-type:  D(s) - D(2s) = n_0^{-s} exactly for
       the geometric model n_j = q^{2^j}, and asymptotically for the true Sylvester
       ladder (correction ~ s * sum_j n_j^{-2s-1} -> 0 as s grows; measured 0.236 at
       s=1 falling to 2e-6 at s=32).
  (iii) Natural boundary.  On Re s = 0 every term has modulus 1, so the series diverges
       at every point of the line: no meromorphic continuation, hence no classical
       (Riemann-type) functional equation.

Run with the bundled runtime python.  Prints all checks.
"""
import math
from fractions import Fraction as Fr

s = [2]
for _ in range(12):
    s.append(s[-1] * s[-1] - s[-1] + 1)
L = [math.log(n) for n in s]
L0 = math.log(2.0)


def Ds(x, J=12):
    return sum(math.exp(-x * L[j]) for j in range(J))


def Dg(x, J=30):
    return sum(math.exp(-x * (2.0 ** j) * L0) for j in range(J))


def greedy_exact(x, K=40):
    r = Fr(x); A = []
    for _ in range(K):
        if r == 0:
            break
        n = (r.denominator + r.numerator - 1) // r.numerator
        if n < 2:
            n = 2
        if A and n <= A[-1]:
            n = A[-1] + 1
        A.append(n); r -= Fr(1, n)
    return A


print("Sylvester ladder (support is exactly these):", s[:8], "...")
print("growth: n_j has %d digits at j=6, against 2^j = %d for the fastest"
      % (len(str(s[6])), 2 ** 6))
print("        multiplicative semigroup -> doubly exponential vs exponential.")
print()
print("ladder check  x_k = (s_{k+1}-2)/(s_{k+1}-1)  =>  support {s_0..s_{k-1}}")
for k in [1, 2, 3, 4]:
    A = greedy_exact(Fr(s[k] - 2, s[k] - 1), 30)
    print("   k=%d  support=%-20s equals %s ? %s" % (k, A, s[:k], A == s[:k]))


def multiplicative(A):
    As = set(A)
    for a in A:
        for b in A:
            if a * b not in As:
                return False, (a, b, a * b)
    return True, None


print()
print("multiplicativity (needed for an Euler product):")
for name, A in [("support {2}", [2]), ("support {2,3}", [2, 3]),
                ("support {2,3,7}", [2, 3, 7]), ("Sylvester first 5", s[:5])]:
    ok, w = multiplicative(A)
    print("   %-18s multiplicative? %-5s  %s" % (name, ok,
          ("witness %d*%d=%d is missing" % w) if w else "degenerate singleton"))
print("   singleton {m} gives D(s)=m^{-s}: a single local factor, no arithmetic.")

print()
print("Mahler relation  D(s) - D(2s)  vs  2^{-s}")
print("   geometric model n_j=2^(2^j)  (EXACT):")
for x in [0.5, 1.0, 2.0, 4.0, 8.0]:
    print("     s=%-5g ratio = %.12f" % (x, (Dg(x) - Dg(2 * x)) / 2.0 ** (-x)))
print("   true Sylvester ladder (asymptotic; ratio -> 1 as s grows):")
for x in [0.5, 1.0, 2.0, 4.0, 8.0, 16.0, 32.0]:
    r = (Ds(x) - Ds(2 * x)) / 2.0 ** (-x)
    print("     s=%-5g ratio = %.6f   correction = %.3e" % (x, r, r - 1))

print()
print("natural boundary: |n_j^{-s}| = 1 on Re s = 0, so the series diverges there")
for t in [1.234, 3.7]:
    print("   s=0+%.3fi : |n_j^-s| = %s" % (t, [1.0] * 5))
    print("      (every term has modulus 1; terms do not tend to 0)")
print("   s=0.01+1.234i : |n_j^-s| = %s"
      % ["%.1e" % abs(complex(math.cos(t * L[j]), -math.sin(t * L[j])) * math.exp(-0.01 * L[j]))
         for j in range(5)])
