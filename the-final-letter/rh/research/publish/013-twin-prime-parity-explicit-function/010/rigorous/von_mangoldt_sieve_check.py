#!/usr/bin/env python3
"""von_mangoldt_sieve_check.py — reproduce the numbers in ../von-mangoldt-sieve.html.

1. the exact buggy linear sieve vs  log rad(n)  and vs  Lambda(n)   (n <= 10 000)
2. the summatory functions at x = 2000
3. the prime-sum shift for the Route C kernel g(u)=e^{-u^2/2}cos(14u)/sqrt(2pi), N=2000
"""
import mpmath as mp
mp.mp.dps = 30


def buggy_sieve(n):
    lam = [mp.mpf(0)] * (n + 1); primes = []; comp = [False] * (n + 1)
    for i in range(2, n + 1):
        if not comp[i]:
            primes.append(i); lam[i] = mp.log(i)
            for j in range(i * i, n + 1, i):
                comp[j] = True
        if i > 1:
            for p in primes:
                if p * i > n:
                    break
                comp[p * i] = True
                if i % p == 0:
                    lam[p * i] = lam[i]; break
                else:
                    lam[p * i] = lam[p] + lam[i]
    return lam


def log_rad(n):
    if n == 1:
        return mp.mpf(0)
    r, m, p = 1, n, 2
    while p * p <= m:
        if m % p == 0:
            r *= p
            while m % p == 0:
                m //= p
        p += 1
    if m > 1:
        r *= m
    return mp.log(r)


def vonmangoldt(n):
    if n == 1:
        return mp.mpf(0)
    m, p = n, 2
    while p * p <= m:
        if m % p == 0:
            while m % p == 0:
                m //= p
            return mp.log(p) if m == 1 else mp.mpf(0)
        p += 1
    return mp.log(m)


N = 10000
bug = buggy_sieve(N)
mm_rad = [n for n in range(2, N + 1) if abs(bug[n] - log_rad(n)) > mp.mpf('1e-25')]
mm_vm = [n for n in range(2, N + 1) if abs(bug[n] - vonmangoldt(n)) > mp.mpf('1e-25')]
print("1. buggy vs log rad, n<=%d : %d mismatches" % (N, len(mm_rad)))
print("   buggy vs Lambda , n<=%d : %d mismatches, first: %s" % (N, len(mm_vm), mm_vm[:12]))

s_vm = mp.fsum([vonmangoldt(n) for n in range(2, 2001)])
s_rad = mp.fsum([log_rad(n) for n in range(2, 2001)])
print("2. sum Lambda(2..2000) = %s ; sum log rad = %s ; ratio %s"
      % (mp.nstr(s_vm, 8), mp.nstr(s_rad, 9), mp.nstr(s_rad / s_vm, 6)))

th = mp.mpf(14)
g = lambda u: mp.e ** (-u * u / 2) * mp.cos(th * u) / mp.sqrt(2 * mp.pi)
term = lambda f, n: (f(n) / mp.sqrt(n)) * (g(mp.log(n)) + g(-mp.log(n)))
PSb = mp.fsum([term(lambda k: bug[k], n) for n in range(2, 2001)])
PSc = mp.fsum([term(vonmangoldt, n) for n in range(2, 2001)])
D = mp.fsum([term(lambda k: log_rad(k) - vonmangoldt(k), n) for n in range(2, 2001)])
print("3. PS(log rad) = %s" % mp.nstr(PSb, 14))
print("   PS(Lambda)  = %s" % mp.nstr(PSc, 14))
print("   difference  = %s   (= sum of (lograd-Lambda) terms: %s)" % (mp.nstr(PSb - PSc, 14), mp.nstr(D, 14)))
