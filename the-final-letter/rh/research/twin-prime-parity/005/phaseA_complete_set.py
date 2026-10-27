#!/usr/bin/env python3
"""
PHASE A - the complete classification of greedy Egyptian supports on 1/(k+2).

Alphabet w_k = 1/(k+2) (strictly decreasing to 0). Greedy expansion with strictly
increasing indices: k_1 = max(0, ceil(1/x) - 2), and after subtracting w_{k_j} from the
residual r_{j-1},
      k_j = max(k_{j-1} + 1, ceil(1/r_{j-1}) - 2) .
Because the alphabet is infinite and tends to 0, the greedy never stops while the residual
is positive: rationals terminate, irrationals give infinite words.

THEOREM (admissibility = tail condition).
A strictly increasing word k_1 < k_2 < ... is a greedy support iff for every j with
k_j > k_{j-1} + 1 (taking k_0 = -1):
        sum_{i>=j} 1/(k_i + 2)  <  1/(k_j + 1) .
The condition is NOT local in k alone: it constrains the whole tail, because the greedy
constraint at step j involves the residual sum_{i>=j} w_{k_i}.  (The plausible-looking local
law k_{j+1} >= k_j^2 + 3k_j + 1 is FALSE: the greedy expansion of 1 is [0,1,4] in k, i.e.
1 = 1/2 + 1/3 + 1/6, and 4 < 1^2 + 3*1 + 1 = 5.)

Corollaries.
  * the greedy expansion of 1 is [0,1,4], NOT the Sylvester word;
  * the Sylvester word k_j = s_j - 2 (s_{j+1} = s_j^2 - s_j + 1) sits exactly on the
    boundary: its tail equals the bound, so it is the LAZY/Sylvester expansion, not greedy;
  * the ladder targets x_m = (s_m - 2)/(s_m - 1) have greedy supports exactly
    {s_0, ..., s_{m-1}} (verified exactly for m = 2..5).

Run with the bundled python (exact Fractions).
"""
from fractions import Fraction as F
import random

KMAX = 10 ** 6


def greedy(x, Kmax=KMAX):
    r = F(x); A = []; k = 0
    while r > 0 and k < Kmax:
        kk = (r.denominator + r.numerator - 1) // r.numerator - 2
        if kk < k:
            kk = k
        if kk >= Kmax:
            break
        w = F(1, kk + 2)
        if r >= w:
            A.append(kk); r -= w; k = kk + 1
        else:
            k = kk + 1
    return A, r


def tail_law(A):
    n = len(A)
    for j in range(n):
        prev = A[j - 1] if j > 0 else -1
        if A[j] > prev + 1:
            if not (sum(F(1, A[i] + 2) for i in range(j, n)) < F(1, A[j] + 1)):
                return False
    return True


print("PHASE A - complete classification of greedy supports on 1/(k+2)")
print()
print("NECESSITY: exact greedy expansions of rationals with denominator <= 80")
rng = random.Random(5); tested = 0; viol = 0
for _ in range(20000):
    q = rng.randint(2, 80); p = rng.randint(1, q)
    A, r = greedy(F(p, q))
    if r != 0:
        continue
    tested += 1
    if not tail_law(A):
        viol += 1
print("   terminating expansions tested: %d   tail-law violations: %d" % (tested, viol))

print()
print("SUFFICIENCY: law-satisfying words rebuilt from x = their exact sum")
rng = random.Random(23); cand = []; tried = 0
while len(cand) < 4000 and tried < 400000:
    tried += 1; A = []; k = rng.randint(0, 2)
    for _ in range(rng.randint(1, 4)):
        A.append(k); k += rng.randint(1, 60)
    if tail_law(A):
        cand.append(A)
ok = 0
for A in cand:
    S = sum(F(1, e + 2) for e in A)
    B, r = greedy(S)
    if B == A and r == 0:
        ok += 1
print("   law-satisfying words tested: %d   reproduced by greedy(sum): %d" % (len(cand), ok))

print()
print("SOUNDNESS: law-violating words are not realisable")
rng = random.Random(31); nb = 0; bad = 0
for _ in range(20000):
    A = []; k = rng.randint(0, 2)
    for _ in range(rng.randint(2, 3)):
        A.append(k); k += rng.randint(1, 40)
    if tail_law(A):
        continue
    nb += 1
    S = sum(F(1, e + 2) for e in A)
    if greedy(S)[0] == A:
        bad += 1
print("   law-violating words tested: %d   realised: %d  (expect 0)" % (nb, bad))

print()
print("THE FAMOUS WORDS")
print("   greedy(1) =", greedy(F(1))[0], "  i.e. 1 = 1/2 + 1/3 + 1/6")
s = [2]
for _ in range(7):
    s.append(s[-1] * s[-1] - s[-1] + 1)
syl = [e - 2 for e in s]
print("   Sylvester word (k_j = s_j-2):", syl[:6], "...")
j = 3
tail_inf = F(1, s[j] - 1)          # exact: sum_{i>=j} 1/s_i = 1/(s_j - 1)
print("   at j=%d: tail = 1/(s_j-1) = %s   bound 1/(k_j+1) = %s   -> %s" % (
    j, tail_inf, F(1, syl[j] + 1),
    "EQUALITY: not greedy (it is the lazy/Sylvester expansion)" if tail_inf == F(1, syl[j] + 1) else "strengthened"))
print()
print("   ladder targets x_m = (s_m-2)/(s_m-1) and their greedy supports:")
for m in range(2, 6):
    A, r = greedy(F(s[m] - 2, s[m] - 1))
    print("      m=%d  x=%-12s  k-support=%-18s  denominators=%s" % (
        m, F(s[m] - 2, s[m] - 1), A, [e + 2 for e in A]))

print()
print("DOES COMPLETENESS BUY ANYTHING FOR ZERO LOCATION?")
print("   No. x -> A(x) is an exact bijection onto admissible words, so replacing cos(theta_n)")
print("   by Re prod_{k in A_n} e^{i alpha_k} is a change of coordinates on the phase.  The sum")
print("   stays over n; every term is identical.  A 'complete set' at height t is the finite")
print("   union U_N = union_{n<=N} A_n(t), and entering it into the sum changes nothing.")
