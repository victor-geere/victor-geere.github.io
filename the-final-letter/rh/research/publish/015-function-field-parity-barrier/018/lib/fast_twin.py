"""018/lib/fast_twin.py — fast twin-qrime counts via a numpy irreducibility sieve.

A monic degree-`n` polynomial over `F_q` is encoded by its lower `n`
coefficients in base `q`:  index `i = c_0 + c_1 q + ... + c_{n-1} q^{n-1}`.
The leading coefficient is always `1`.

To find the irreducible degree-`n` polynomials we sieve: a monic degree-`n`
polynomial is reducible iff it has a monic irreducible factor of degree
`e <= n/2`.  For each such `g` we mark all multiples `f = g*h` with `deg h =
n-e`.  The marking is vectorised over `h` with a convolution matrix.

`twin_count_fast(q, n)` then counts `f` with both `f` and `f+2` irreducible.
"""
import numpy as np

_CACHE = {}


def _cast_powers(q, d):
    return q ** np.arange(d, dtype=np.int64)


def _monic_digit_matrix(size, m, q, offset=0, chunk=None):
    """Rows are `m` lower-coefficient digits of `h` for indices `offset..offset+chunk-1`."""
    idx = np.arange(offset, offset + size, dtype=np.int64)
    H = np.empty((size, m + 1), dtype=np.int64)
    for j in range(m):
        H[:, j] = (idx // q ** j) % q
    H[:, m] = 1
    return H


def _irr_flags(q, d):
    """Boolean array of length q^d; True iff the encoded monic poly is irreducible."""
    flag = np.ones(q ** d, dtype=bool)
    if d <= 1:
        return flag
    powers = _cast_powers(q, d)
    for e in range(1, d // 2 + 1):
        gees = irr_indices(q, e)
        G = np.empty((len(gees), e + 1), dtype=np.int64)
        for j in range(e):
            G[:, j] = (gees // q ** j) % q
        G[:, e] = 1
        m = d - e
        size = q ** m
        # chunk so that the (size, m+1) matrix stays modest
        chunk = max(1, 1_500_000 // (m + 1))
        for start in range(0, size, chunk):
            cnt = min(chunk, size - start)
            H = _monic_digit_matrix(cnt, m, q, offset=start)
            for gi in range(len(gees)):
                g = G[gi]
                T = np.zeros((m + 1, d), dtype=np.int64)
                for i in range(e + 1):
                    js = np.arange(min(m + 1, d - i))
                    T[js, js + i] = g[i]
                F = (H @ T) % q
                flag[F @ powers] = False
    return flag


def irr_indices(q, d):
    """Indices of monic irreducible degree-`d` polynomials over `F_q`."""
    key = (q, d)
    if key not in _CACHE:
        if d <= 1:
            _CACHE[key] = np.arange(q, dtype=np.int64)
        else:
            _CACHE[key] = np.nonzero(_irr_flags(q, d))[0].astype(np.int64)
    return _CACHE[key]


def twin_count_fast(q, n, delta=2, chunk=4_000_000):
    """#{f monic deg n : f and f+delta both irreducible}."""
    flag = _irr_flags(q, n)
    total = 0
    qn = q ** n
    for start in range(0, qn, chunk):
        end = min(start + chunk, qn)
        idx = np.arange(start, end, dtype=np.int64)
        c0 = idx % q
        idx2 = idx - c0 + (c0 + delta) % q
        total += int(np.sum(flag[start:end] & flag[idx2]))
    return total


if __name__ == "__main__":
    import sys
    for arg in sys.argv[1:]:
        q, n = map(int, arg.split(','))
        print(f"{q},{n},{twin_count_fast(q, n)}", flush=True)
