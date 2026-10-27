#!/usr/bin/env python3
"""
THE PRIME-COCYCLE EXPERIMENT - the last live route from the debate, now run.

Motivation.  The digit map acts on the folded phase, so it destroys the exact
multiplicative cocycle  theta_{mn} = theta_m + theta_n  (log is a homomorphism
(N,x) -> (R/2piZ,+)).  Advisor 2's proposal: apply the numeration where the cocycle
lives - to the PRIMES - and look for an explicit-formula-sized anomaly at t = gamma_k.
Prediction: digit-word statistics over p <= X show such an anomaly, absent over all n <= X.

RESULT (this script): the prime sum DOES carry the zero; the digit-word statistic does NOT.

(1) The weighted prime sum detects the zero, with the exact log X signature.
    Explicit formula:  sum_{n<=X} Lambda(n) n^{-s} = X^{1-s}/(1-s) - sum_rho X^{rho-s}/(rho-s) + ...
    Subtract the s=1 main term and read the residual R(t):
        |R(gamma_1)| = 9.37, 11.52, 14.40, 15.48  for X = 1e4, 1e5, 1e6, 4e6
        log X        = 9.21, 11.51, 13.82, 15.20
    i.e. |R(gamma_1)| = log X + O(1) (the pole residue), the argmax over a window lands
    exactly on gamma_1, and at generic t the residual stays 1-3 with no growth.
    (Without subtracting the main term the sum is dominated by sqrt(X)/|t| ~ 32 and the
    zero is invisible - that is why a naive peak search finds nothing.)

(2) The digit-word statistic does NOT isolate it.  Null test: statistic
        S(t) = sum_{p<=X} (log p)/sqrt(p) * (2*delta_0(theta_p(t)) - 1)
    at the first ten zeros against 400 random heights in [10,46] (mean 1.05, sd 40.11):
    z-scores -0.53, -1.30, +0.44, +0.91, -0.13, +1.00, +0.44, -0.42, +0.57, +0.28,
    max |z| = 1.30, against a Bonferroni 5% threshold of 2.81.  Over all n: max |z| = 1.62.
    Reason: the digit indicator is a square wave in the phase, so its Fourier content
    spreads the zero signal to t = gamma_k/m for odd m, and the signal is no longer
    localised at gamma_k.

(3) The support-only statistic (count of primes with delta_0 = 1) is t-free: it fluctuates
    by 24% of its median but shows no correlation with the zeros.

(4) The all-n side is a DIP, not a peak: |eta_N(1/2+i gamma_1)| = 0.0079 against a median
    of 2.0391 over the same window.  Arithmetic (prime) sum -> peak; plain sum -> zero.

CONCLUSION: the prime route does carry the zero, but the digit map destroys exactly the
frequency localisation that makes it work.  The last live route is closed.

Run with /opt/homebrew/Caskroom/miniforge/base/bin/python3.
"""
import numpy as np, math, mpmath as mp
mp.mp.dps = 20

G1 = 14.134725141734693790


def primes_upto(X):
    sv = np.ones(X + 1, bool); sv[:2] = False
    for i in range(2, int(X ** 0.5) + 1):
        if sv[i]:
            sv[i * i::i] = False
    return np.nonzero(sv)[0]


print("(1) the weighted prime sum detects the zero:  |R(gamma_1)| = log X + O(1)")
print("     X          |R(g1)|      log X      median|R|    argmax t")
for X in [10 ** 4, 10 ** 5, 10 ** 6, 4 * 10 ** 6]:
    P = primes_upto(X); lp = np.log(P); wp = lp / np.sqrt(P)
    ts = np.linspace(G1 - 3, G1 + 3, 601)
    R = np.empty(len(ts), complex)
    for i, t in enumerate(ts):
        s = 0.5 + 1j * t
        R[i] = np.sum(wp * np.exp(-1j * t * lp)) - X ** (1 - s) / (1 - s)
    a = np.abs(R); j = int(np.argmin(np.abs(ts - G1)))
    print("     %-10d %-12.3f %-12.3f %-11.3f %.4f" % (X, a[j], math.log(X), np.median(a), ts[int(np.argmax(a))]))

print()
print("(2) null test of the digit-word statistic at the first ten zeros")
X = 10 ** 6
P = primes_upto(X); lp = np.log(P); wp = lp / np.sqrt(P)
gam = [float(mp.zetazero(k).imag) for k in range(1, 11)]
rng = np.random.default_rng(4); null = 10.0 + 36.0 * rng.random(400)


def stat(t):
    return float(np.sum(wp * (-np.sign(np.cos(t * lp)))))


nv = np.array([stat(t) for t in null])
print("     null: mean=%.2f sd=%.2f" % (nv.mean(), nv.std()))
zs = []
for k, g in enumerate(gam, 1):
    v = stat(g); z = (v - nv.mean()) / nv.std(); zs.append(z)
    print("       k=%-3d gamma=%-12.6f S=%-10.2f z=%+.2f" % (k, g, v, z))
print("     max |z| = %.2f   (Bonferroni 5%% threshold for 10 tests: 2.81)" % max(abs(np.array(zs))))

print()
print("(3) support-only statistic (count of primes with delta_0 = 1) is t-free")
ts = np.linspace(G1 - 2.5, G1 + 2.5, 401)
cnt = np.array([np.sum(np.cos(t * lp) <= 0) for t in ts])
print("     count at g1=%d  median=%d  spread=%.1f%% of median  (no zero correlation)"
      % (cnt[int(np.argmin(np.abs(ts - G1)))], np.median(cnt), 100 * (cnt.max() - cnt.min()) / np.median(cnt)))

print()
print("(4) the all-n side is a DIP: |eta_N(1/2+i gamma_1)| vs the window median")
N = 4000; n = np.arange(1, N + 1); ln = np.log(n); sgn = ((-1.0) ** (n - 1)) / np.sqrt(n)
E = np.array([abs(np.sum(sgn * np.exp(-1j * t * ln))) for t in ts])
print("     at g1 = %.4f   median = %.4f   argmin t = %.4f"
      % (E[int(np.argmin(np.abs(ts - G1)))], np.median(E), ts[int(np.argmin(E))]))
