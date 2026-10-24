#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
rh45/010/rigorous/kernel_probe.py  --  T6: an admissible kernel with an O(1) left side
                                        and a rapidly convergent zero side.

Run:  /opt/homebrew/Caskroom/miniforge/base/bin/python3 kernel_probe.py | tee kernel_probe.log

================================================================================
CONVENTION (the audited Weil form of 010/truths.md S1 and 010/index.html S3)
================================================================================
g is real and EVEN;  varphi(t) = int_R g(u) e^{i t u} du;  Phi(s) = int_R g(u) e^{(s-1/2)u} du,
so that Phi(1/2 + i gamma) = varphi(gamma) and Phi(s) = Phi(1-s).  Then

    sum_rho Phi(rho) = Phi(1) + Phi(0) + (1/2pi) int_R varphi(t) Psi(t) dt
                       - sum_{n>=2} (Lambda(n)/sqrt n) [ g(log n) + g(-log n) ],
    Psi(t) = -log pi + Re psi(1/4 + i t/2).

For even g:  LHS = 2 sum_{gamma>0} varphi(gamma),  Phi(1)+Phi(0) = 2 varphi(i/2)
             = 2 int g(u) e^{-u/2} du,  prime side = 2 sum Lambda(n) n^{-1/2} g(log n).

*** A LAMBDA GUARD ***  this probe uses a correct von Mangoldt Lambda and CHECKS it against
an independent trial-division Lambda, because computing log rad(n) instead of Lambda(n) is
exactly the sieve bug recorded in 010/von-mangoldt-sieve.html.  With the bug the Gaussian
gives a fake residual of -0.0858; with correct Lambda it is 1.6e-44.  The guard is printed.

================================================================================
THE THREE CONDITIONS OF 010/truths.md S7
================================================================================
  (i)   decay of Phi at the nontrivial zeros   -- CHECKED: |varphi(t)| = O(t^{-(m+1)}).
  (ii)  g compactly supported                  -- CHECKED by construction (main kernel).
  (iii) "decay at the trivial zeros s=-2,-4,..." -- NOT satisfiable as literally written by
        ANY non-zero even kernel, including the Gaussian (S5).  The operative content (the
        archimedean integral converges absolutely / the trivial zeros are regularised by it)
        is CHECKED.

ACCEPTANCE: |LHS| >= 0.1 and |RHS-LHS| <= 1e-20 at some K <= 1000.
"""

import sys
import time
import mpmath as mp

DPS = 60
mp.mp.dps = DPS
T0 = time.time()

CHK = []


def log(msg=""):
    print(msg, flush=True)


def check(label, ok, detail=""):
    CHK.append(bool(ok))
    log("  [%s] %s%s" % ("ok" if ok else "FAIL", label, ("  -- " + detail) if detail else ""))


SEP = "-" * 78

# ---------------------------------------------------------------------------
# 0.  instruments
# ---------------------------------------------------------------------------
def psi_bar(t):
    """Psi(t) = -log pi + Re psi(1/4 + i t/2)."""
    return -mp.log(mp.pi) + mp.re(mp.digamma(mp.mpf(1) / 4 + 1j * t / 2))


def sieve_lambda(nmax):
    """von Mangoldt Lambda(n): Lambda(p^k) = log p, else 0."""
    lam = [mp.mpf(0)] * (nmax + 1)
    is_p = [True] * (nmax + 1)
    for p in range(2, nmax + 1):
        if is_p[p]:
            pk = p
            while pk <= nmax:
                lam[pk] = mp.log(p)
                pk *= p
            for m in range(p * p, nmax + 1, p):
                is_p[m] = False
    return lam


def lam_trial(n):
    """Independent Lambda(n) by trial division (guard only)."""
    x, d = n, 2
    while d * d <= x:
        if x % d == 0:
            p = d
            while x % p == 0:
                x //= p
            return mp.log(p) if x == 1 else mp.mpf(0)
        d += 1
    return mp.log(n) if n > 1 else mp.mpf(0)


def lam_lograd(n):
    """The buggy object: log rad(n) = sum of log p over distinct p | n."""
    x, rad, d = n, mp.mpf(0), 2
    while d * d <= x:
        if x % d == 0:
            rad += mp.log(d)
            while x % d == 0:
                x //= d
        d += 1
    if x > 1:
        rad += mp.log(x)
    return rad


ZEROS = []


def zeros(K):
    global ZEROS
    if len(ZEROS) < K:
        ZEROS = [mp.im(mp.zetazero(j)) for j in range(1, K + 1)]
    return ZEROS[:K]


# ---------------------------------------------------------------------------
# 1.  kernels: each returns a dict with g, phi, support, m, and an envelope
# ---------------------------------------------------------------------------
def kernel_bump(A, m, a):
    """MAIN KERNEL: g(u) = C (1-u^2/A^2)^m cos(a u) on [-A,A], 0 outside.

    Compactly supported and C^{m-1}.  Its Fourier transform is elementary:
       M(x) = int_{-A}^{A}(1-(u/A)^2)^m e^{i x u} du
            = A sqrt(pi) m! (2/(A|x|))^{m+1/2} J_{m+1/2}(A|x|),
       M(0) = A sqrt(pi) m!/Gamma(m+3/2),
       varphi(t) = C/2 [ M(t-a) + M(t+a) ].
    C = 2/(M(0)+M(2a)) normalises varphi(a) ~ 1, hence LHS = 2 sum varphi(gamma) ~ 2.
    """
    A = mp.mpf(A)
    a = mp.mpf(a)
    nu = mp.mpf(m) + mp.mpf(1) / 2
    M0 = A * mp.sqrt(mp.pi) * mp.factorial(m) / mp.gamma(mp.mpf(m) + mp.mpf(3) / 2)

    def M(x):
        y = A * abs(x)
        if y < mp.mpf("1e-30"):
            return M0
        return A * mp.sqrt(mp.pi) * mp.factorial(m) * (2 / y) ** nu * mp.besselj(nu, y)

    C = 2 / (M(0) + M(2 * a))

    def g(u):
        if abs(u) >= A:
            return mp.mpf(0)
        return C * (1 - (u / A) ** 2) ** m * mp.cos(a * u)

    def phi(t):
        return C / 2 * (M(t - a) + M(t + a))

    def Phi(s):
        """Phi(s) = int g(u) e^{(s-1/2)u}du, evaluated by the endpoint-flat substitution
        u = -A + t (t in [0,2A]), which removes the J^{m}-type endpoint behaviour."""
        c = s - mp.mpf(1) / 2
        f = lambda t: C * (t / A) ** m * (2 - t / A) ** m * mp.cos(a * (t - A)) * mp.e ** (c * (t - A))
        return mp.quad(f, [0, A / 2, A, mp.mpf(3) * A / 2, 2 * A])

    # envelope for t beyond the support of the main lobe: |varphi(t)| <= C A sqrt(pi) m! (2/(A(t-a)))^nu
    pref = C * A * mp.sqrt(mp.pi) * mp.factorial(m)

    def env(t):
        y = A * (t - a)
        if y <= 0:
            return C * M0
        return pref * (2 / y) ** nu

    return dict(g=g, phi=phi, support=A, m=m, env=env, kind="bump A=%g m=%d" % (A, m),
                alpha=mp.mpf(m) + 1, Phi=Phi)


def kernel_gaussian():
    g = lambda u: mp.e ** (-u * u / 2) / mp.sqrt(2 * mp.pi)
    phi = lambda t: mp.e ** (-t * t / 2)
    env = lambda t: mp.e ** (-t * t / 2)

    def envint(T):
        # rigorous tail of int_T^inf e^{-t^2/2}(log t+2) dt  (crude, Gaussian: negligible)
        return mp.mpf(0)
    return dict(g=g, phi=phi, support=None, m=None, env=env, kind="Gaussian", alpha=None,
                envint=envint)


def kernel_modgauss(a, sigma=mp.mpf(1)):
    """g(u) = cos(a u) e^{-u^2/(2 sigma^2)}; varphi(t) = sigma sqrt(2pi)/2 [e^{-s^2(t-a)^2/2}+e^{-s^2(t+a)^2/2}]."""
    amp = sigma * mp.sqrt(2 * mp.pi) / 2

    def g(u):
        return mp.e ** (-u * u / (2 * sigma * sigma)) * mp.cos(a * u)

    def phi(t):
        return amp * (mp.e ** (-sigma * sigma * (t - a) ** 2 / 2)
                      + mp.e ** (-sigma * sigma * (t + a) ** 2 / 2))
    env = lambda t: phi(t) if t > 0 else amp
    return dict(g=g, phi=phi, support=None, m=None, env=env,
                kind="modGauss s=%.2g" % sigma, alpha=None, envint=lambda T: mp.mpf(0))


# ---------------------------------------------------------------------------
# 2.  the three pieces of the identity, with truncation bounds
# ---------------------------------------------------------------------------
def lhs_and_zero_tail(K, phi, kern):
    """LHS = 2 sum_{j<=K} varphi(gamma_j), plus the density-integrated tail bound beyond gamma_K.

    With dN(t) <= (1/2pi) log(t/2pi) dt + dt (standard density estimate, truths S3/S5),
        sum_{gamma>G} |varphi(gamma)| <= int_G^inf |varphi(t)| (log(t/2pi)/(2pi) + 1) dt <= env.
    """
    G = zeros(K)
    L = 2 * sum(phi(g) for g in G)
    if kern["support"] is None:
        return L, None
    T = G[-1]
    f = lambda t: kern["env"](t) * (mp.log(t / (2 * mp.pi)) / (2 * mp.pi) + 1)
    tail = mp.quad(f, [T, T + 5, T + 20, T + 100, T + 1000, T + 10000])
    return L, 2 * tail


def poles(kern):
    """Phi(1)+Phi(0) = 2 int g(u) e^{-u/2} du."""
    g, A = kern["g"], kern["support"]
    if A is None:
        return 2 * mp.quad(lambda u: g(u) * mp.e ** (-u / 2), [-mp.inf, -10, 0, 10, mp.inf])
    return 2 * mp.quad(lambda u: g(u) * mp.e ** (-u / 2), [-A, -A / 2, 0, A / 2, A])


def arch(kern, T, extra=()):
    """(1/2pi) int_R varphi Psi = (1/pi) int_0^inf varphi Psi; returns (value, tail bound)."""
    phi = kern["phi"]
    pts = sorted(set([mp.mpf(0), mp.mpf(T)] + [mp.mpf(p) for p in extra if 0 < p <= T]))
    val = (1 / mp.pi) * mp.quad(lambda t: phi(t) * psi_bar(t), pts)
    if kern["support"] is None:
        return val, mp.mpf(0)
    # tail: |varphi| <= env, |Psi(t)| <= log t + 2 for t >= 2
    f = lambda t: kern["env"](t) * (mp.log(t) + 2) / mp.pi
    tail = mp.quad(f, [T, T + 10, T + 50, T + 200, T + 2000, T + 20000])
    return val, tail


def prime_side(kern, nmax, lam):
    """sum_{n>=2} Lambda(n) n^{-1/2}[g(log n)+g(-log n)], plus a Chebyshev tail bound.

    Compact support: only n <= e^A contribute, the sum is FINITE and exact (tail 0).
    Non-compact: truncate at nmax; tail <= M(log N) 3 (log 4) N^{-1/4}, M = sup|g| on [log N,inf).
    """
    g, A = kern["g"], kern["support"]
    tot = mp.mpf(0)
    for n in range(2, nmax + 1):
        if lam[n] != 0:
            u = mp.log(n)
            if A is not None and u > A:
                continue
            tot += lam[n] / mp.sqrt(n) * (g(u) + g(-u))
    tail = mp.mpf(0)
    if A is None:
        uN = mp.log(nmax)
        MN = abs(g(uN))
        tail = MN * 3 * mp.log(4) * mp.mpf(nmax) ** (mp.mpf(-1) / 4)
    return tot, tail


# ---------------------------------------------------------------------------
def candidate(kern, K, T, Nmax, lam, arch_extra):
    L, ztail = lhs_and_zero_tail(K, kern["phi"], kern)
    Pol = poles(kern)
    Arc, atail = arch(kern, T, arch_extra)
    Pri, ptail = prime_side(kern, Nmax, lam)
    RHS = Pol + Arc - Pri
    return dict(kern=kern, name=kern["kind"], L=L, Pol=Pol, Arc=Arc, Pri=Pri, RHS=RHS,
                res=RHS - L, ztail=ztail, atail=atail, ptail=ptail, K=K, T=T, Nmax=Nmax)


# ---------------------------------------------------------------------------
# MAIN
# ---------------------------------------------------------------------------
log("=" * 78)
log("T6 -- AN ADMISSIBLE KERNEL WITH AN O(1) LEFT SIDE")
log("=" * 78)
log("mp.dps = %d   python %s" % (mp.mp.dps, sys.version.split()[0]))
log()

log("S0.  von Mangoldt Lambda guard (the round's sieve bug is log rad, not Lambda)")
log(SEP)
N_GUARD = 3000
lam_g = sieve_lambda(N_GUARD)
bad_lam = sum(1 for n in range(2, N_GUARD + 1) if abs(lam_g[n] - lam_trial(n)) > mp.mpf("1e-40"))
bad_rad = sum(1 for n in range(2, N_GUARD + 1) if abs(lam_g[n] - lam_lograd(n)) > mp.mpf("1e-40"))
log("  sieve Lambda vs trial-division Lambda, n<=%d : %d mismatch(es)" % (N_GUARD, bad_lam))
log("  sieve Lambda vs log rad(n),            n<=%d : %d mismatch(es)  <- must be large"
    % (N_GUARD, bad_rad))
check("Lambda(p^k)=log p reproduced and differs from log rad", bad_lam == 0 and bad_rad > 0,
      "Lam mismatches=%d, lograd mismatches=%d" % (bad_lam, bad_rad))
log()

a = mp.im(mp.zetazero(1))
log("S1.  The kernels (all real, even; a = gamma_1 = %s)" % mp.nstr(a, 25))
log(SEP)
log("  (G) Gaussian           g = e^{-u^2/2}/sqrt(2pi)                    [not compact]")
log("  (M) modulated Gaussian g = cos(a u) e^{-u^2/2}                     [not compact]")
log("  (C) compact bump       g = C (1-u^2/A^2)^m cos(a u) on [-A,A]      [COMPACT]")
log("      varphi(t) = C/2[M(t-a)+M(t+a)], M(x)=A sqrt(pi) m! (2/(A|x|))^{m+1/2} J_{m+1/2}(A|x|)")
log()

NMAX = 2_000_000
lam_big = sieve_lambda(NMAX)
N12 = int(mp.e ** 12)
lam_12 = sieve_lambda(N12)
N8 = int(mp.e ** 8)
lam_8 = sieve_lambda(N8)
log("  prime tables: Lambda(n) to %d (Gaussian/modGauss), %d (A=12), %d (A=8)"
    % (NMAX, N12, N8))

K = 100
GARCH = [0, 1, 2, 3, 5, 8, 12, 16, 20, 25, 30]
MARCH = [0, 2, 5, 8, 10, 12, 13, 14, 15, 16, 18, 22, 26, 30]
BARCH = [0, 2, 5, 8, 9, 10, 11, 12, 13, 14, 14.13, 15, 16, 18, 20, 22, 25, 30, 35, 40, 50, 60]

cands = []
cands.append(candidate(kernel_gaussian(), K, 30, NMAX, lam_big, GARCH))
cands.append(candidate(kernel_modgauss(a, mp.mpf(1)), K, 30, NMAX, lam_big, MARCH))
cands.append(candidate(kernel_bump(12, 40, a), K, 60, N12, lam_12, BARCH))
cands.append(candidate(kernel_bump(8, 40, a), K, 60, N8, lam_8, BARCH))
cands.append(candidate(kernel_bump(12, 24, a), K, 60, N12, lam_12, BARCH))

log()
log("S2.  THE TABLE   (K = %d zero terms, so gamma_K = %s)" % (K, mp.nstr(zeros(K)[-1], 10)))
log(SEP)
hdr = "  %-16s %-13s %-12s %-11s %-11s %-10s" % (
    "kernel", "|LHS|", "|RHS-LHS|", "zero tail", "arch tail", "prime cut N")
log(hdr)
log("  " + "-" * (len(hdr) - 2))
for c in cands:
    zt = "-" if c["ztail"] is None else "%.1e" % abs(c["ztail"])
    log("  %-16s %-13s %-12s %-11s %-11s %-10d"
        % (c["name"], mp.nstr(abs(c["L"]), 8), "%.2e" % abs(c["res"]), zt,
           "%.1e" % abs(c["atail"]), c["Nmax"]))
log()
log("  components:")
for c in cands:
    log("   %-16s poles=%s  arch=%s  primes=%s  LHS=%s  RHS-LHS=%s"
        % (c["name"], mp.nstr(c["Pol"], 12), mp.nstr(c["Arc"], 12), mp.nstr(c["Pri"], 12),
           mp.nstr(c["L"], 14), mp.nstr(c["res"], 6)))
log()

main = [c for c in cands if c["name"] == "bump A=12 m=40"][0]
check("|LHS| >= 0.1 for the compact bump A=12 m=40", abs(main["L"]) >= mp.mpf("0.1"),
      "|LHS| = %s" % mp.nstr(abs(main["L"]), 12))
check("|RHS-LHS| <= 1e-20 at K=%d for the compact bump" % K,
      abs(main["res"]) <= mp.mpf("1e-20"), "residual = %s" % mp.nstr(main["res"], 6))
check("g compactly supported (condition ii)", main["kern"]["support"] == 12, "supp g = [-12,12]")
check("archimedean integral converges (operative content of iii)",
      abs(main["atail"]) < mp.mpf("1e-20"), "arch tail = %s" % mp.nstr(main["atail"], 6))
check("prime side finite and exact (condition ii consequence)",
      main["ptail"] == 0 and main["Nmax"] == N12, "N = e^12 = %d" % N12)
log()

log("S3.  Condition (i): decay of varphi at the nontrivial zeros")
log(SEP)
kb = kernel_bump(12, 40, a)
m = 40
Z = zeros(150)
log("    t              |varphi(t)|        |varphi(t)| t^{m+1}")
for t in [a, Z[1], Z[2], mp.mpf(50), mp.mpf(100), Z[99], mp.mpf(300), mp.mpf(500)]:
    log("   %-14s %-17s %s" % (mp.nstr(t, 8), mp.nstr(abs(kb["phi"](t)), 8),
                              mp.nstr(abs(kb["phi"](t)) * t ** (m + 1), 8)))
ok_i = all(abs(kb["phi"](t)) <= kb["env"](t) for t in Z[1:])
const_i = kb["env"](mp.mpf(10) ** 6) * (mp.mpf(10) ** 6) ** (m + 1)
log("   envelope check |varphi(gamma)| <= env(gamma) for gamma >= gamma_2 : %s" % ok_i)
log("   and env(t) t^{m+1} -> C A sqrt(pi) m! (2/A)^{m+1} = %s as t -> infinity"
    % mp.nstr(kb["env"](mp.mpf(10) ** 8) * (mp.mpf(10) ** 8) ** (m + 1), 6))
check("(i) |varphi(gamma)| bounded by the t^{-(m+1)} envelope along the zeros", ok_i,
      "varphi ~ t^{-%d}" % (m + 1))
log()

log("S4.  Condition (iii): 'decay at the trivial zeros' -- why the literal reading is empty")
log(SEP)
log("  Phi(-2n) = int g(u) e^{-(2n+1/2)u} du is dominated by u = -A and GROWS for every")
log("  non-zero even g (after Phi(s)=Phi(1-s) the trivial zeros mirror s = 2n+1):")
gg = kernel_gaussian()
for n in [1, 2, 3, 5, 10]:
    s = -2 * n
    vg = mp.e ** ((s - mp.mpf(1) / 2) ** 2 / 2) / mp.sqrt(2 * mp.pi)
    vb = kb["Phi"](s)
    log("   n=%-3d  Phi_Gauss(-2n)=%-14s Phi_bump(-2n)=%s"
        % (n, mp.nstr(vg, 8), mp.nstr(vb, 8)))
log("  Hence the literal claim '(iii) Phi(-2n)->0' fails for the Gaussian family too; it is a")
log("  convention artefact.  The operative requirement is absolute convergence of the")
log("  archimedean integral, varphi(t)=o(1/log t), which holds here.")
check("(iii) archimedean term well defined / absolutely convergent",
      abs(main["atail"]) < mp.mpf("1e-20"), "tail %s" % mp.nstr(main["atail"], 6))
log()

log("S6.  Structural side: Paley-Wiener, and why the literal negative claim (B) is false")
log(SEP)
log("  THEOREM.  If g != 0 is compactly supported and |varphi(t)| <= C e^{-c|t|} on R for some")
log("  c>0, then g = 0.  (Proof: g(u) = (1/2pi) int varphi(t) e^{-itu}dt converges absolutely")
log("  and defines a holomorphic function in |Im u| < c; on the real axis it vanishes for")
log("  |u| > A, an open set meeting the strip, so g = 0 by analytic continuation.)")
log("  So a compactly supported kernel gives only algebraic / super-polynomial decay of")
log("  varphi, never exponential decay.  The claim 'O(1) LHS forces a zero-side tail")
log("  >= c/log G for every compactly supported even g' is therefore FALSE:")
G100 = zeros(K)[-1]
log("      compact bump A=12 m=40:  |LHS| = %s ,  zero-tail bound at G = gamma_%d = %s is %s"
    % (mp.nstr(abs(main["L"]), 8), K, mp.nstr(G100, 8), mp.nstr(main["ztail"], 6)))
log("      while 1/log G = %s -- the tail is many orders of magnitude below c/log G."
    % mp.nstr(1 / mp.log(G100), 6))
log("  Correct structural statement: if g is C^m and vanishes to order m at the endpoints of")
log("  its support, then varphi(t) = O(t^{-(m+1)}) and the zero tail beyond G is O((log G)G^{-m}).")
log("  Convergence needs m >= 1; m = 0 (a jump, e.g. the Cauchy kernel) is the divergent")
log("  boundary case of truths S1.")
check("(B) refuted by the compact bump witness", abs(main["ztail"]) < 1 / mp.log(G100),
      "tail %s  <<  1/log G = %s" % (mp.nstr(main["ztail"], 4), mp.nstr(1 / mp.log(G100), 4)))
log()

log("=" * 78)
log("SUMMARY: %d/%d checks passed   (%.1f s)" % (sum(CHK), len(CHK), time.time() - T0))
log("OUTCOME (A): the compactly supported even kernel")
log("  g(u) = C (1 - u^2/144)^40 cos(gamma_1 u),   |u| <= 12,")
log("meets (i) [varphi(t) = O(t^{-41})] and (ii) [compact support, finite exact prime sum],")
log("with |LHS| = %s (O(1)) and |RHS - LHS| = %s at K = %d zero terms."
    % (mp.nstr(abs(main["L"]), 8), mp.nstr(abs(main["res"]), 6), K))
log("=" * 78)

sys.exit(0 if all(CHK) else 1)
