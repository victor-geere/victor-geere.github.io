#!/usr/bin/env python3
"""
PHASE C - the honest zero locator: rate, cost, and the correction to Phase 1.

(A) natural truncation  S_N(s) = sum_{n<=N} (-1)^{n-1} n^{-s}
      zero nearest s0:   |s_N - s0| = (1/2) N^{-1/2} / |eta'(s0)| (1+o(1))
      |eta'(s0)| = 1.88269671  ->  0.2656 N^{-1/2}      (fitted slope -0.5263)
(B) Euler transform  E_K(s) = sum_{k<K} 2^{-(k+1)} Delta^k a_0(s),  a_n=(n+1)^{-s}
      zero error at K=40: 1.74e-8, geometric, factor ~1.89 per term
      E_K IS a length-K Dirichlet polynomial with coefficients c_j -> (-1)^j  =>
      Phase 1's "no selection beats N^{-1/2}" is FALSE for length-N Dirichlet
      polynomials; it is TRUE for coefficient-preserving truncations.
      cost: K ~ 1.25 t + 31 for error 1e-10  => Theta(t) terms, vs Riemann-Siegel
      Theta(sqrt(t)) - so the Euler transform is asymptotically WORSE.
(C) what the locator does: argument-principle counts in the strip 0.05<Re<0.95 match
      zeta exactly (10 at T=50, 79 at T=200) for N>=64; Newton seeded at each zeta
      zero matches 79/79 for N>=128 with mean shift 0.0061; but in the wide box
      -1<Re<2 the count grows with N (spurious zeros outside the strip).

Run with /opt/homebrew/Caskroom/miniforge/base/bin/python3 (mpmath).
"""
import numpy as np, math, mpmath as mp
mp.mp.dps = 30
S0 = mp.mpc('0.5', '14.13472514173469379045725198356247027078')

print("|eta'(s0)| =", mp.nstr(abs(mp.diff(mp.altzeta, S0)), 10),
      " ->  (1/2)/|eta'| =", mp.nstr(mp.mpf('0.5') / abs(mp.diff(mp.altzeta, S0)), 8))


def SN(s, N):
    return mp.fsum([((-1) ** (n - 1)) * mp.power(n, -s) for n in range(1, N + 1)])


def SNp(s, N):
    return mp.fsum([((-1) ** (n - 1)) * mp.power(n, -s) * (-mp.log(n)) for n in range(1, N + 1)])


def EK(s, K):
    row = [mp.power(n + 1, -s) for n in range(K)]; tot = mp.mpc(0)
    for k in range(K):
        tot += row[0] * mp.power(2, -(k + 1))
        row = [row[i] - row[i + 1] for i in range(len(row) - 1)]
    return tot


def newton(f, df, z, it=40):
    for _ in range(it):
        v = f(z); d = df(z)
        if d == 0 or abs(v) < mp.mpf(10) ** (-30):
            break
        z = z - v / d
    return z


print()
print("(A) natural truncation")
rows = []
for N in [10, 30, 100, 300, 1000, 3000, 10000]:
    z = newton(lambda s: SN(s, N), lambda s: SNp(s, N), S0 + mp.mpc('0.05', '0.05'))
    e = abs(z - S0); rows.append((N, float(e)))
    print("   N=%-6d |s_N-s0|=%.6e   *N^1/2 = %.4f" % (N, e, e * math.sqrt(N)))
Nv = np.array([r[0] for r in rows], float); Ev = np.array([r[1] for r in rows])
print("   fitted slope = %+.4f" % np.polyfit(np.log(Nv), np.log(Ev), 1)[0])

print()
print("(B) Euler transform")
for K in [10, 15, 20, 25, 30, 35, 40]:
    z = newton(lambda s: EK(s, K), lambda s: mp.diff(lambda x: EK(x, K), s), S0 + mp.mpc('0.05', '0.05'))
    print("   K=%-4d |s_K-s0| = %.6e" % (K, abs(z - S0)))
z40 = newton(lambda s: EK(s, 40), lambda s: mp.diff(lambda x: EK(x, 40), s), S0 + mp.mpc('0.05', '0.05'))
print("   K=40 zero:", mp.nstr(z40, 25))
# coefficients c_j of E_K as a Dirichlet polynomial
K = 40
c = [(-1) ** j * sum(mp.binomial(k, j) * mp.power(2, -(k + 1)) for k in range(j, K)) for j in range(6)]
print("   coefficients c_j (K=40):", [mp.nstr(x, 8) for x in c], " -> (-1)^j =", [(-1) ** j for j in range(6)])

print()
print("(C) strip counts vs zeta, and the wide-box degeneracy")
def etaN(P, N):
    P = np.asarray(P).ravel(); out = np.empty(P.shape, dtype=complex)
    n = np.arange(1, N + 1); logn = np.log(n); sgn = ((-1.0) ** (n - 1))
    for i in range(0, len(P), 2000):
        sl = P[i:i + 2000]
        A = np.exp(-np.outer(sl.real, logn)) * np.exp(-1j * np.outer(sl.imag, logn))
        out[i:i + 2000] = A @ sgn
    return out


def winding(N, a, b, c, d, npts=8000):
    xs = np.linspace(a, b, npts // 4, endpoint=False); ys = np.linspace(c, d, npts // 4, endpoint=False)
    w = np.concatenate([xs + 1j * c, b + 1j * ys, xs[::-1] + 1j * d, a + 1j * ys[::-1]])
    v = etaN(w, N)
    return np.sum(np.angle(v[1:] / v[:-1])) / (2 * math.pi)


def Nzeta(T):
    return T / (2 * math.pi) * math.log(T / (2 * math.pi)) - T / (2 * math.pi) + 7 / 8


for T in [50, 200]:
    print("   T=%d  zeta count ~ %.1f" % (T, Nzeta(T)))
    for N in [16, 32, 64, 128, 256, 512]:
        print("      N=%-4d narrow=%-8.1f wide=%-8.1f" % (
            N, winding(N, 0.05, 0.95, 0, T, 6000), winding(N, -1.0, 2.0, 0, T, 6000)))
print()
print("   Newton seeded at each zeta zero, N=512:")
Z = []
k = 1
while True:
    z = complex(mp.zetazero(k))
    if z.imag > 200:
        break
    Z.append(z); k += 1


def one(s, N):
    return complex(etaN(np.array([s]), N)[0])


d = []
for z in Z:
    r = z
    for _ in range(60):
        v = one(r, 512); h = 1e-7
        dd = (one(r + h, 512) - one(r - h, 512)) / (2 * h)
        if dd == 0:
            break
        r = r - v / dd
    d.append(abs(r - z))
d = np.array(d)
print("      matched (<0.05): %d/%d  mean=%.4f  max=%.4f  predicted=%.4f" % (
    int((d < 0.05).sum()), len(Z), d.mean(), d.max(), 0.2656 / math.sqrt(512)))
