"""
Numerical companion to Addendum F of publication.html
(Fisher zeros of the coherent polygon, and the N=2 identity with the
averaged accumulated phase factor of Wei et al.).

Run:  python quantum_fisher_zeros_test.py
Needs numpy and mpmath only.

Part 1.  Lemma F.1: eta_2^{(M)}(s) = sum_{m<=M} (-1)^{m+1} m^{-s}, the
         truncated Dirichlet eta series, which is (up to sign and the
         partition-function normalisation) the averaged accumulated
         phase factor of the first system of Wei et al.; in the limit
         it is (1-2^{1-s}) zeta(s) (Lemma 2.2 at N=2).

Part 2.  Fisher zeros.  The zeros of the finite Dirichlet polynomial
         eta_N^{(N^2)}(s) are the Fisher zeros of the finite system
         (complex inverse temperature s).  They are located by the
         argument principle on a fine grid of boxes and refined by
         Newton's method, then binned by real part.  The plain partial
         sum H_{N^2}^{(s)} is run as a control, for comparison with
         Gonek-Ledoan (IMRN 2010): N_X(T) = (T/2pi) log X + O(X).
"""
import numpy as np
import mpmath as mp

mp.mp.dps = 30


# ---------------------------------------------------------------- part 1
def eta_N_coeffs(N, M):
    m = np.arange(1, M + 1)
    c = np.ones(M, dtype=float)
    c[(m % N) == 0] = 1 - N
    return m, c


def part1():
    print("Part 1. Lemma F.1: period-2 polygon = truncated Dirichlet eta series")
    print("  s                  M      |eta_2^{(M)}(s) - sum (-1)^{m+1} m^-s|   |eta_2^{(M)} - (1-2^{1-s})zeta|")
    for s in [mp.mpc(0.5, 14.134725), mp.mpc(0.5, 21.022040), mp.mpc(0.75, 30.0)]:
        for M in [4, 100, 10000]:
            m, c = eta_N_coeffs(2, M)
            eta = mp.fsum(mp.mpf(int(ci)) * mp.power(int(mi), -s) for mi, ci in zip(m, c))
            alt = mp.fsum(mp.mpf((-1) ** (int(mi) + 1)) * mp.power(int(mi), -s) for mi in m)
            lim = (1 - mp.power(2, 1 - s)) * mp.zeta(s)
            print(f"  {mp.nstr(s, 8):18s} {M:6d}   {mp.nstr(abs(eta - alt), 3):>10s}                          {mp.nstr(abs(eta - lim), 4)}")
    print()


# ---------------------------------------------------------------- part 2
def poly_on_grid(m, c, sig, t):
    """Evaluate sum c_m m^{-s} on the grid s = sig[:,None] + i t[None,:]."""
    out = np.zeros((len(sig), len(t)), dtype=complex)
    logm = np.log(m.astype(float))
    # chunk over m to bound memory
    step = 64
    for k in range(0, len(m), step):
        lm = logm[k:k + step]
        ck = c[k:k + step]
        # m^{-s} = exp(-sig log m) exp(-i t log m)
        a = np.exp(-np.outer(sig, lm)) * ck            # (S, K)
        b = np.exp(-1j * np.outer(t, lm))              # (T, K)
        out += a @ b.T
    return out


def winding_boxes(vals, bs, bt):
    """Winding number of vals (S x T grid values) around each box of bs x bt
    grid cells.  Returns integer array of shape (S//bs, T//bt)."""
    S, T = vals.shape
    ns, nt = (S - 1) // bs, (T - 1) // bt
    ph = np.angle(vals)
    # phase differences along sigma (rows) and t (columns), wrapped
    dS = np.angle(np.exp(1j * np.diff(ph, axis=0)))   # (S-1, T)
    dT = np.angle(np.exp(1j * np.diff(ph, axis=1)))   # (S, T-1)
    # cumulative sums for fast box sums
    cS = np.concatenate([np.zeros((1, T)), np.cumsum(dS, axis=0)], axis=0)  # (S, T)
    cT = np.concatenate([np.zeros((S, 1)), np.cumsum(dT, axis=1)], axis=1)  # (S, T)
    W = np.zeros((ns, nt), dtype=int)
    for i in range(ns):
        i0, i1 = i * bs, (i + 1) * bs
        for j in range(nt):
            j0, j1 = j * bt, (j + 1) * bt
            # counter-clockwise in (sigma, t): bottom (t=j0, sigma up), right (sigma=i1, t up),
            # top (t=j1, sigma down), left (sigma=i0, t down)
            bottom = cS[i1, j0] - cS[i0, j0]
            right = cT[i1, j1] - cT[i1, j0]
            top = -(cS[i1, j1] - cS[i0, j1])
            left = -(cT[i0, j1] - cT[i0, j0])
            W[i, j] = int(round((bottom + right + top + left) / (2 * np.pi)))
    return W


def refine(m, c, s0):
    mm = [int(x) for x in m]
    cc = [mp.mpf(int(x)) for x in c]

    def f(s):
        return mp.fsum(ci * mp.power(mi, -s) for mi, ci in zip(mm, cc))

    try:
        return mp.findroot(f, mp.mpc(s0), tol=1e-18, maxsteps=60)
    except Exception:
        return None


def fisher_zeros(N, T, filtered=True, smin=-1.0, smax=3.0, h=0.01, box=10):
    M = N * N
    m, c = eta_N_coeffs(N, M)
    if not filtered:
        c = np.ones(M)
    sig = np.arange(smin, smax + h / 2, h)
    t = np.arange(0.0, T + h / 2, h)
    vals = poly_on_grid(m, c, sig, t)
    W = winding_boxes(vals, box, box)
    zeros = []
    for i, j in zip(*np.nonzero(W)):
        s0 = complex(sig[i * box] + h * box / 2, t[j * box] + h * box / 2)
        z = refine(m, c, s0)
        if z is not None and smin - 0.1 < z.real < smax + 0.1 and -0.1 < z.imag < T + 0.1:
            zeros.append((float(z.real), float(z.imag), int(W[i, j])))
    # de-duplicate (Newton from neighbouring boxes may hit the same zero)
    uniq = []
    for z in sorted(zeros, key=lambda q: (q[1], q[0])):
        if all(abs(z[0] - u[0]) + abs(z[1] - u[1]) > 1e-6 for u in uniq):
            uniq.append(z)
    return uniq, int(W.sum())


def part2():
    T = 60.0
    print("Part 2. Fisher zeros of eta_N^{(N^2)} (filtered) and of H_{N^2} (plain), 0 < t <= %.0f" % T)
    print("  Boxes with nonzero winding are refined by Newton; counts are of distinct zeros found.")
    print("  GL = (T/2pi) log X, the Gonek-Ledoan main term for the plain partial sum, X = N^2.")
    hdr = "  N   X=N^2  kind      #zeros   wind   GL    #sig>1  #sig<0  max Re  min Re  median Re  frac |Re-1/2|<0.1"
    print(hdr)
    rows = []
    for N in [5, 8, 10, 14, 20]:
        for filtered in (True, False):
            zs, wsum = fisher_zeros(N, T, filtered=filtered)
            re = np.array([z[0] for z in zs]) if zs else np.array([])
            GL = T / (2 * np.pi) * np.log(N * N)
            kind = "filtered" if filtered else "plain   "
            if len(re):
                line = (f"  {N:2d}  {N*N:5d}  {kind}  {len(zs):6d}  {wsum:5d}  {GL:5.1f}  "
                        f"{int((re > 1).sum()):6d}  {int((re < 0).sum()):6d}  {re.max():6.3f}  {re.min():6.3f}  "
                        f"{np.median(re):8.3f}   {float((np.abs(re - 0.5) < 0.1).mean()):.2f}")
            else:
                line = f"  {N:2d}  {N*N:5d}  {kind}  0"
            print(line)
            rows.append((N, kind, zs))
    print()
    print("  First zeros (t <= 30) of the filtered polygon, N = 10, against the Riemann zeros:")
    riemann = [14.134725, 21.022040, 25.010858, 30.424876]
    for N, kind, zs in rows:
        if N == 10 and kind.startswith("filtered"):
            for z in zs:
                if z[1] <= 31:
                    near = min(riemann, key=lambda g: abs(g - z[1]))
                    tag = f"  <- Riemann zero at {near:.6f}" if abs(near - z[1]) < 0.5 else ""
                    print(f"    {z[0]:+.6f} {z[1]:+.6f} i{tag}")


if __name__ == "__main__":
    part1()
    part2()
