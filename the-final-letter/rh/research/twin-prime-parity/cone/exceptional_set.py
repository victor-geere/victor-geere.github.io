#!/usr/bin/env python3
"""exceptional_set.py — goal 4, deliverable (1) and (2).

Where does the shift-2 correlation deviate, and is it the same place as the shift-1 correlation?

f1(n) = lambda(n) lambda(n+1)   -- SOLVED unconditionally (Matomaki-Radziwill-Tao)
f2(n) = lambda(n) lambda(n+2)   -- OPEN (the target)

Statistics on a geometric grid of scales x:
  S_i(x) = sum_{n<=x} f_i(n)                d_i(x) = S_i(x)/sqrt(x)      (un-averaged, normalised)
  L_i(x) = sum_{n<=x} f_i(n)/n              l_i(x) = L_i(x)/sqrt(log x)  (log-averaged, normalised)
  T_i(x,H) = sum_{x<n<=x+H} f_i(n)/sqrt(H)  (short intervals, H = x^theta)

The random model predicts d_i, l_i, T_i all O(1) with no structure.  Two independent random +-1
controls give the NULL distribution for every comparison statistic, in particular for the
correlation between the two deviation processes: that is what decides whether the h=1 and h=2
processes are "the same process".

HEURISTIC: finite range only.  No finite computation decides o(x).  Reported as data, never as
evidence about the limit.
"""
import numpy as np

N = 2 ** 26
GRID = 30000

def liouville_sieve(N: int) -> np.ndarray:
    omega = np.zeros(N + 1, dtype=np.uint8)
    sieve = np.ones(N + 1, dtype=bool)
    sieve[:2] = False
    for p in range(2, N + 1):
        if sieve[p]:
            sieve[p * p :: p] = False
            pk = p
            while pk <= N:
                omega[pk::pk] += 1
                pk *= p
    lam = np.where(omega % 2 == 0, 1, -1).astype(np.int8)
    lam[0] = 0
    return lam

def grid_points(N: int, M: int) -> np.ndarray:
    xs = np.unique(np.round(np.exp(np.linspace(np.log(1e4), np.log(N), M))).astype(np.int64))
    return xs[(xs >= 1000) & (xs <= N)]

def process(f: np.ndarray, xs: np.ndarray, chunk: int = 2 ** 23):
    """S[i] = sum_{n<=xs[i]} f(n),  L[i] = sum_{n<=xs[i]} f(n)/n, where f[i] = f(i+1).

    Single pass, chunked, exact: no reindexing tricks (an earlier reduceat version was silently
    wrong, and the brute-force self-check below is what caught it).
    """
    S = np.empty(xs.size, dtype=np.int64)
    L = np.empty(xs.size, dtype=np.float64)
    s, l, pos = 0, 0.0, 0
    for i in range(xs.size):
        x = int(xs[i])
        while pos < x:
            hi = min(x, pos + chunk)
            seg = f[pos:hi]
            s += int(np.sum(seg, dtype=np.int64))
            l += float(np.sum(seg / np.arange(pos + 1, hi + 1, dtype=np.float64)))
            pos = hi
        S[i] = s
        L[i] = l
    return S, L

def selfcheck(f: np.ndarray, name: str) -> None:
    """Compare the fast estimator with brute force on a few scales."""
    xs = np.array([1, 17, 500, 4999, 50000], dtype=np.int64)
    S, L = process(f, xs)
    w = np.arange(1, f.size + 1, dtype=np.float64)
    for i, x in enumerate(xs):
        sb = int(np.sum(f[:x], dtype=np.int64))
        lb = float(np.sum(f[:x] / w[:x]))
        assert S[i] == sb, f"{name} S mismatch at x={x}: {S[i]} vs {sb}"
        assert abs(L[i] - lb) < 1e-9, f"{name} L mismatch at x={x}: {L[i]} vs {lb}"
    print(f"[g4] self-check {name}: estimator matches brute force at {xs.tolist()}")

def main():
    print(f"[g4] sieve to N = {N} ...", flush=True)
    lam = liouville_sieve(N)
    print(f"[g4] lambda(1..8) = {lam[1:9].tolist()}")
    f1 = (lam[1:N] * lam[2:N + 1]).astype(np.int8)        # n = 1 .. N-1
    f2 = (lam[1:N - 1] * lam[3:N + 1]).astype(np.int8)    # n = 1 .. N-2
    rng = np.random.default_rng(20240607)
    c1 = rng.choice(np.array([-1, 1], dtype=np.int8), size=f1.size)
    c2 = rng.choice(np.array([-1, 1], dtype=np.int8), size=f2.size)

    selfcheck(f1, "f1")
    selfcheck(f2, "f2")
    xs = grid_points(min(f1.size, f2.size), GRID)      # x <= min length, so every prefix exists
    X = xs.astype(np.float64)
    print(f"[g4] grid: {xs.size} scales from {xs[0]} to {xs[-1]}")

    res = {}
    for name, f in (("f1", f1), ("f2", f2), ("ctrl1", c1), ("ctrl2", c2)):
        S, L = process(f, xs)
        d = S / np.sqrt(X)
        l = L / np.sqrt(np.log(X))
        res[name] = (S, L, d, l)
        print(f"[g4] {name:6s}: S(N)/sqrt(N) = {d[-1]:+.3f}   max_x |d(x)| = "
              f"{np.max(np.abs(d)):.3f} at x = {xs[int(np.argmax(np.abs(d)))]}   "
              f"max_x |l(x)| = {np.max(np.abs(l)):.3f}   "
              f"frac |d|>2: {np.mean(np.abs(d) > 2):.4f}  |d|>3: {np.mean(np.abs(d) > 3):.4f}")

    # ---- the comparison that decides the question ----
    print("\n[g4] --- is the h=2 process the same process as h=1? ---")
    for a, b, lbl in (("f1", "f2", "lambda-shifts"), ("ctrl1", "ctrl2", "NULL (independent)")):
        da, db = res[a][2], res[b][2]
        r = float(np.corrcoef(da, db)[0, 1])
        ra = np.argsort(-np.abs(da))[:20]
        rb = np.argsort(-np.abs(db))[:20]
        overlap = len(set(ra.tolist()) & set(rb.tolist()))
        print(f"[g4]   corr(d_a, d_b) = {r:+.4f}   top-20 extreme-scale overlap = {overlap}/20   [{lbl}]")

    # where do the extremes sit, and how extreme is f2 there?
    d1, d2 = res["f1"][2], res["f2"][2]
    top = np.argsort(-np.abs(d2))[:10]
    print("\n[g4] top-10 extreme scales of the OPEN case (h=2), with the SOLVED case (h=1) for contrast:")
    print("[g4]      x          log2 x     d2(x)     d1(x)    rank of |d1| there")
    order1 = np.argsort(-np.abs(d1))
    rank1 = np.empty_like(order1); rank1[order1] = np.arange(1, order1.size + 1)
    for i in top:
        print(f"[g4]   {xs[i]:>10d}   {np.log2(xs[i]):8.2f}   {d2[i]:+7.3f}   {d1[i]:+7.3f}"
              f"    {rank1[i]:>6d}")

    # ---- short intervals, computed at EXACT boundaries (the grid is too coarse to resolve
    #      windows like x^0.1, so we add every x + H as an extra boundary and diff exactly) ----
    print("\n[g4] short-interval statistics max_x |T(x,H)| (H = x^theta), random model predicts O(1):")
    for theta in (0.10, 0.25, 0.50):
        Hs = np.maximum((X ** theta).astype(np.int64), 1)
        row = []
        for name, f in (("f1", f1), ("f2", f2), ("ctrl1", c1), ("ctrl2", c2)):
            bounds = np.unique(np.concatenate((xs, xs + Hs)))
            bounds = bounds[bounds <= f.size]
            Sb, _ = process(f, bounds)
            pos = np.searchsorted(bounds, xs)
            posH = np.searchsorted(bounds, xs + Hs).clip(0, bounds.size - 1)
            T = (Sb[posH] - Sb[pos]) / np.sqrt(Hs)
            row.append(np.max(np.abs(T)))
        print(f"[g4]   theta = {theta:.2f}:  f1 {row[0]:6.2f}   f2 {row[1]:6.2f}   "
              f"ctrl1 {row[2]:6.2f}   ctrl2 {row[3]:6.2f}   (exact windows)")

    # ---- null distribution for corr(d_a, d_b): many independent control pairs at smaller N ----
    N2, PAIRS = 2 ** 22, 40
    xs2 = grid_points(N2 - 2, 4000)
    rng2 = np.random.default_rng(12345)
    nulls = []
    for _ in range(PAIRS):
        a = rng2.choice(np.array([-1, 1], dtype=np.int8), size=N2 - 2)
        b = rng2.choice(np.array([-1, 1], dtype=np.int8), size=N2 - 2)
        da = process(a, xs2)[0] / np.sqrt(xs2.astype(np.float64))
        db = process(b, xs2)[0] / np.sqrt(xs2.astype(np.float64))
        nulls.append(float(np.corrcoef(da, db)[0, 1]))
    nulls = np.array(nulls)
    obs_corr = float(np.corrcoef(d1, d2)[0, 1])
    print(f"\n[g4] null calibration for corr(d_a,d_b) at N=2^22, {PAIRS} independent pairs: "
          f"mean {nulls.mean():+.4f}, sd {nulls.std():.4f}, "
          f"range [{nulls.min():+.3f}, {nulls.max():+.3f}]")
    print(f"[g4]   observed corr for the two lambda shifts (at N=2^26): {obs_corr:+.4f} "
          f"-> z = {(obs_corr - nulls.mean()) / nulls.std():+.2f} against the null")

    print("\n[g4] HEURISTIC ONLY: finite-range diagnostic; no finite computation decides o(x).")

if __name__ == "__main__":
    main()
