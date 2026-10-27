#!/usr/bin/env python3
"""
cone_critical_probe.py — numerics for the cone note.

  * lambda(n) via  lambda(n) = sum_{d^2 | n} mu(n/d^2)     (fast vectorised sieve)
  * f(n) = lambda(n) lambda(n+2)
  * critical-cone (p = 1/2) log-averages and direct means
  * the residue ladder  K(eps) = eps * sum_{n<=M} f(n) (n(n+2))^{-(1+eps)/2}
    with rigorous truncation bar  M^{-eps}, and the majorant control
    Kmaj(eps) = eps * sum_{n<=M} (n(n+2))^{-(1+eps)/2}  ->  1   (the spurious pole)
  * the pair-greedy completeness threshold  zeta(p) = 2 + 2^{1-p}

House rules: exact rational / >=60 dps for the analytic constants (mpmath);
every reported number carries its truncation.
"""
import numpy as np, time, math, sys
from math import isqrt

M      = 100_000_000          # summation limit
CHUNK  = 10_000_000
EPS    = [0.5, 0.3, 0.2, 0.15, 0.1, 0.07, 0.05]
CHECK  = []   # rows are reported at chunk boundaries (true x = b)

t0 = time.time()

# ---------- lambda(n) = (-1)^Omega(n) via a prime-power sieve ----------
from math import isqrt
sieve = np.ones(M+1, dtype=bool); sieve[:2] = False
for i in range(2, isqrt(M)+1):
    if sieve[i]: sieve[i*i::i] = False
primes = np.nonzero(sieve)[0]; del sieve
print(f"[sieve] {len(primes)} primes up to {M} in {time.time()-t0:.1f}s")
Omega = np.zeros(M+1, dtype=np.int16)
for j, p in enumerate(primes):
    pk = int(p)
    while pk <= M:
        Omega[pk::pk] += 1
        pk *= p
    if j % 1_000_000 == 0 and j:
        print(f"[sieve]   {j} primes done ({time.time()-t0:.1f}s)", flush=True)
del primes
lam = (1 - 2*(Omega & 1)).astype(np.int8); del Omega
lam[0] = 0
print(f"[sieve] lambda up to {M} in {time.time()-t0:.1f}s   "
      f"lambda(1..12) = {lam[1:13].tolist()}")
assert set(np.unique(lam[1:]).tolist()) == {-1, 1}, "lambda must be +-1"
print(f"[sieve] partial-sum check  sum_{{n<=1000}} lambda = {int(lam[1:1001].sum())}")

# ---------- chunked accumulators ----------
S = 0                                   # running sum of f
acc = {k: 0.0 for k in
       ("L1", "Lc", "C1", "C15", "C2")}
K    = {e: 0.0 for e in EPS}            # signed residue ladder
Kmaj = {e: 0.0 for e in EPS}            # majorant control
R    = {e: 0.0 for e in EPS}            # plain residue ladder, weight n^{-1-eps}
Rmaj = {e: 0.0 for e in EPS}
rows = []
for a in range(1, M+1, CHUNK):
    b = min(a+CHUNK-1, M-2)
    if b < a: break
    n  = np.arange(a, b+1, dtype=np.float64)
    fn = (lam[a:b+1].astype(np.float64) * lam[a+2:b+3].astype(np.float64))
    S += int(fn.sum())
    nn2 = n*(n+2.0)
    invn = 1.0/n
    acc["L1"]  += float(np.dot(fn, invn))
    acc["Lc"]  += float(np.dot(fn, 1.0/np.sqrt(nn2)))
    acc["C1"]  += float(np.dot(fn, 1.0/nn2))
    acc["C15"] += float(np.dot(fn, nn2**-1.5))
    acc["C2"]  += float(np.dot(fn, nn2**-2.0))
    for e in EPS:
        p = (1.0+e)/2.0
        w = nn2**(-p)
        K[e]    += float(np.dot(fn, w))
        Kmaj[e] += float(w.sum())
        v = n**(-(1.0+e))
        R[e]    += float(np.dot(fn, v))
        Rmaj[e] += float(v.sum())
    rows.append((b, S, acc["L1"], acc["Lc"]))
for e in EPS:
    K[e] *= e; Kmaj[e] *= e; R[e] *= e; Rmaj[e] *= e
print(f"[sums] chunked accumulation done in {time.time()-t0:.1f}s")

# ---------- report ----------
print("\n=== direct mean  S(x)/x  and  log-averages ===")
print("     x        S(x)        S(x)/x        sum f(n)/n     (1/log x)*...   sum f(n)/sqrt(n(n+2))  /log x")
for (c, Sx, L1, Lc) in rows:
    print(f"{c:>10}  {Sx:>10}  {Sx/c: .6e}   {L1: .6f}     {L1/math.log(c): .6f}"
          f"       {Lc: .6f}    {Lc/math.log(c): .6f}")

print("\n=== convergent cone invariants (absolute tails: 1/M for p=1, ...) ===")
print(f"  C_f(1)   = sum f(n)/(n(n+2))      = {acc['C1']: .10f}   (+- {1.0/M:.1e})")
print(f"  C_f(1.5) = sum f(n)/(n(n+2))^1.5  = {acc['C15']: .10f}")
print(f"  C_f(2)   = sum f(n)/(n(n+2))^2    = {acc['C2']: .10f}")
print(f"  B(1) = 2*C_f(1) (one-power identity) = {2*acc['C1']: .10f}")

print("\n=== residue ladder:  K(eps) = eps * sum f(n)(n(n+2))^{-(1+eps)/2} ===")
print("   eps     p=1/2+eps/2        K(eps)        bar M^-eps     Kmaj(eps)   R(eps)      Rmaj(eps)")
for e in EPS:
    p = 0.5+e/2
    print(f"  {e:5}   {p:10.4f}   {K[e]: .8f}     {M**(-e):.3e}     {Kmaj[e]: .8f}   {R[e]: .8f}   {Rmaj[e]: .8f}")

print("\n=== pair-greedy completeness threshold   zeta(p) = 2 + 2^(1-p) ===")
import mpmath as mp
mp.mp.dps = 50
z  = mp.zeta
pP = mp.findroot(lambda p: 2**(-p)*z(p) - 1, 1.465)
pN = mp.findroot(lambda p: (1-2**(-p))*z(p) - 2, 1.378)
ps = mp.findroot(lambda p: z(p) - 2, 1.7286)
q  = mp.findroot(lambda p: ((1-2**(-p))*z(p) - 1) - 2*mp.mpf(3)**(-p), 2.0768)
pp = mp.findroot(lambda p: z(p) - (2 + 2**(1-p)), 1.48)
print(f"  pN     = {mp.nstr(pN,20)}   (N(pN)=1)")
print(f"  pP     = {mp.nstr(pP,20)}   (P(pP)=1)")
print(f"  p_pair = {mp.nstr(pp,20)}   (pair alphabet complete, first Brown condition)")
print(f"  p*     = {mp.nstr(ps,20)}   (zeta=2)")
print(f"  q      = {mp.nstr(q ,20)}   (negative half complete)")
print(f"  ordering  pN < pP < p_pair < p* < q : "
      f"{pN < pP < pp < ps < q}")
print("\n  certificate checks at the rational bracket 147/100, 149/100:")
for num, den in ((147,100),(149,100)):
    p = mp.mpf(num)/den
    print(f"   p={num}/{den}:  zeta(p)={mp.nstr(z(p),12)}   "
          f"2+2^(1-p)={mp.nstr(2+2**(1-p),12)}   "
          f"Phi=zeta-2-2^(1-p)={mp.nstr(z(p)-(2+2**(1-p)),6)}   "
          f"P(p)=2^-p zeta={mp.nstr(2**(-p)*z(p),12)}")
print("\n[done] total %.1fs" % (time.time()-t0))
