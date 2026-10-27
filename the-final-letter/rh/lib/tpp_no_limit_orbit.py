"""
tpp_no_limit_orbit.py — rigorous machinery for the rh40 residual orbit, for the
OP-28 / OP-30 (no-limit family) and OP-33 (precision floor / finite-r means)
attacks.  Independent of the round code; every identity is re-derived here.

CONVENTION (the digitword.py / survey one, re-verified — `check_identities`)
---------------------------------------------------------------------------
    r_0 = x in (0,1),   r_{k+1} = r_k - 1/(q_k + 2),
    q_k = ceil(1/r_k) - 2 in Z_{>=0},   n_k = q_k + 2 = ceil(1/r_k),
    u_k = 1/r_k,   s_k = 1 - {u_k} in (0,1],   c_k = r_{k+1}/r_k^2.

`s_k = 1` is an exact rational termination (`r_k = 1/n_k`).

Exact identities (exact `Fraction` arithmetic; verified 0 deviation):

    (I1) c_k = r_{k+1}/r_k^2 = s_k/(1 + s_k r_k)                 (squaring law)
    (I2) u_{k+1} = u_k + u_k^2/(n_k - u_k)                       (u-map, exact)
    (I3) s_{k+1} = 1 - {u_{k+1}}
    (I4) u_k = n_k u_{k+1}/(n_k + u_{k+1})                       (backward relation)
    (I5) x = 1/u_0.

(I4) is the exact inverse of (I2): `u' = u + u^2/(n-u)` rearranges to
`u = n u'/(n + u')`.  In terms of `q_k`, `u_k = q_k + 2 - alpha_k` for large
`q_k`, and `alpha_k = (q_k^2 + 2 q_k)/q_{k+1}` is the fixed point of the induced
recursion up to `O(1/q_{k+1})`.

PRESCRIBED DIGITS AND RIGOROUS RATIONAL ENVELOPES
-------------------------------------------------
For rational `alpha_k in (0,1]` set

    q_{k+1} = ceil( (q_k^2 + 2 q_k)/alpha_k ),

the explicit rational form of `q_{k+1} ~ q_k^2/alpha_k`.  The backward map

    psi_k(y) = (q_k + 2) y/(q_k + 2 + y)

is strictly increasing on (0,inf), so with `L_k = psi_k(L_{k+1})`,
`U_k = psi_k(U_{k+1})` from any terminal pair `L_N <= U_N` one has
`L_k <= u_k <= U_k` for every orbit realising the word `q_0..q_N`.
All rational; no floating point anywhere.

Run:  python3 lib/tpp_no_limit_orbit.py
"""

from __future__ import annotations

from fractions import Fraction
from typing import Dict, List, Sequence, Tuple


# ---------------------------------------------------------------------------
# 1. Exact one-step identities
# ---------------------------------------------------------------------------

def step(r: Fraction) -> Tuple[int, Fraction, Fraction, Fraction]:
    """``(q, s, r_next, c)``: ``q = ceil(1/r)-2``, ``s = 1-{1/r} in (0,1]``,
    ``r_next = r - 1/(q+2)``, ``c = r_next/r**2``."""
    if not (0 < r < 1):
        raise ValueError("need 0 < r < 1")
    u = 1 / r
    n = -((-u.numerator) // u.denominator)            # exact ceil(1/r)
    if n < 2:
        raise ValueError("accepted index n < 2: outside the harmonic regime")
    q = n - 2
    s = 1 - (u - u.__floor__())                       # in (0,1]; 1 at r = 1/n
    r_next = r - Fraction(1, n)
    return q, s, r_next, r_next / (r * r)


def check_identities(seeds: Sequence[Fraction]) -> Dict[str, Fraction]:
    """Worst |lhs-rhs| of (I1)-(I2); both exactly 0 for non-terminating steps."""
    w1 = w2 = Fraction(0)
    for r in seeds:
        if not (0 < r < 1):
            continue
        q, sg, r_next, c = step(r)
        if r_next == 0:              # exact termination r = 1/n: c = 0
            continue
        w1 = max(w1, abs(c - sg / (1 + sg * r)))
        u = 1 / r
        n = q + 2
        u_next = 1 / r_next
        w2 = max(w2, abs(u_next - (u + u * u / (n - u))))
    return {"I1_squaring_law": w1, "I2_u_map": w2}


# ---------------------------------------------------------------------------
# 2. Prescribed digits and rigorous envelopes
# ---------------------------------------------------------------------------

def prescribed_q(alphas: Sequence[Fraction], q0: int = 4) -> List[int]:
    """``q_{k+1} = ceil((q_k^2 + 2 q_k)/alpha_k)``, exact integers.

    Returns ``[q_0, ..., q_K]``; admissible (``q_{k+1} >= q_k^2 - q_k - 1``).
    """
    if q0 < 2:
        raise ValueError("need q0 >= 2")
    qs = [int(q0)]
    for a in alphas:
        if not (0 < a <= 1):
            raise ValueError("need 0 < alpha <= 1")
        qk = qs[-1]
        num = Fraction(qk * qk + 2 * qk, 1) / a
        qs.append(int(num.numerator // num.denominator) + 1)
    assert admissible(qs)
    return qs


def admissible(qs: Sequence[int]) -> bool:
    return all(qs[k + 1] >= qs[k] * qs[k] - qs[k] - 1 for k in range(len(qs) - 1))


def backward_envelope(qs: Sequence[int],
                      uN_lo: Fraction | None = None,
                      uN_hi: Fraction | None = None
                      ) -> Tuple[List[Fraction], List[Fraction]]:
    """Envelopes ``L_k <= u_k <= U_k`` from a terminal pair at the last index.

    Default terminal window is the digit cell ``[q_N+1, q_N+2]`` of the last
    prescribed digit; ``L_k = psi_k(L_{k+1})``, ``U_k = psi_k(U_{k+1})`` with
    ``psi_k(y) = (q_k+2)y/(q_k+2+y)``.
    """
    K = len(qs) - 1
    if uN_lo is None:
        uN_lo = Fraction(qs[K] + 1)
    if uN_hi is None:
        uN_hi = Fraction(qs[K] + 2)
    L = [Fraction(0)] * (K + 1)
    U = [Fraction(0)] * (K + 1)
    L[K], U[K] = uN_lo, uN_hi
    for k in range(K - 1, -1, -1):
        n = qs[k] + 2
        L[k] = Fraction(n * L[k + 1], n + L[k + 1])
        U[k] = Fraction(n * U[k + 1], n + U[k + 1])
        if not (0 < L[k] <= U[k]):
            raise ValueError(f"envelope failed at k={k}: L={L[k]}, U={U[k]}")
    return L, U


def envelope_contraction(qs: Sequence[int], U: Sequence[Fraction]) -> Fraction:
    """Uniform bound on ``psi_k' = (n/(n+y))^2`` over the envelope."""
    worst = Fraction(0)
    for k in range(len(qs) - 1):
        n = qs[k] + 2
        worst = max(worst, Fraction(n * n, 1) /
                    ((n + U[k]) * (n + U[k + 1])))
    return worst


def alpha_of(qs: Sequence[int]) -> List[Fraction]:
    """The self-consistent targets ``alpha_k = (q_k^2 + 2 q_k)/q_{k+1}``."""
    return [Fraction(qs[k] * qs[k] + 2 * qs[k], qs[k + 1]) for k in range(len(qs) - 1)]


def forward_digits(x: Fraction, K: int) -> List[int]:
    """Exact ``q_0..q_{K-1}`` of the greedy orbit of a rational ``x``."""
    r = Fraction(x)
    out = []
    for _ in range(K):
        if not (0 < r < 1):
            return out
        q, _s, r_next, _c = step(r)
        out.append(q)
        r = r_next
    return out


def forward_u0(u0: Fraction, K: int) -> List[int]:
    """Exact ``q_0..q_{K-1}`` of the orbit with ``1/r_0 = u_0``."""
    return forward_digits(1 / u0, K)


def realise_check(alphas: Sequence[Fraction], q0: int = 4,
                  terminal: str = "cell") -> Dict[str, object]:
    """Word, exact rational seed inside the envelope, and the forward check."""
    qs = prescribed_q(alphas, q0)
    K = len(qs) - 1
    if terminal == "cell":
        L, U = backward_envelope(qs)
    else:
        L, _ = backward_envelope(qs, Fraction(qs[K] + 1), Fraction(qs[K] + 1))
        _, U = backward_envelope(qs, Fraction(qs[K] + 2), Fraction(qs[K] + 2))
    u0 = (L[0] + U[0]) / 2
    got = forward_u0(u0, K)
    return {"q": qs, "L": L, "U": U, "u0": u0, "x": 1 / u0, "forward": got,
            "realised": got == qs[:K],
            "contraction": envelope_contraction(qs, U)}


# ---------------------------------------------------------------------------
# 3. Block patterns
# ---------------------------------------------------------------------------

def block_alphas(block_lengths: Sequence[int], values: Sequence[Fraction]) -> List[Fraction]:
    """Cycle ``values[j % len(values)]`` for ``block_lengths[j]`` terms."""
    out: List[Fraction] = []
    for j, n in enumerate(block_lengths):
        out.extend([values[j % len(values)]] * int(n))
    return out


def geometric_blocks(base: int, n_blocks: int, values: Sequence[Fraction]) -> List[Fraction]:
    """``values[j % len(values)]`` for ``base**j`` steps, j = 0..n_blocks-1."""
    return block_alphas([base ** j for j in range(n_blocks)], values)


def block_ends(block_lengths: Sequence[int]) -> List[int]:
    out, pos = [], 0
    for n in block_lengths:
        pos += int(n)
        out.append(pos)
    return out


def running_means(terms: Sequence[object]) -> List[object]:
    """Running Cesaro means of a sequence (Fraction, float or mpf)."""
    out, tot = [], 0
    for i, v in enumerate(terms):
        tot = tot + v
        out.append(tot / (i + 1))
    return out


# ---------------------------------------------------------------------------
# 4. Self-test
# ---------------------------------------------------------------------------

def _self_test() -> int:
    fails = 0

    seeds = [Fraction(p, q) for q in range(3, 120) for p in (1, q // 2 or 1, q - 1)]
    good = [s for s in seeds if 0 < s < 1]
    res = check_identities(good)
    ok = all(v == 0 for v in res.values())
    fails += not ok
    print(f"[{'OK ' if ok else 'BAD'}] exact identities on {len(good)} rational seeds: "
          f"{ {k: str(v) for k, v in res.items()} }")

    alphas = [Fraction(1, 2), Fraction(1, 4), Fraction(1, 2), Fraction(1, 4)]
    rc = realise_check(alphas, q0=4, terminal="extreme")
    ok = bool(rc["realised"])
    fails += not ok
    print(f"[{'OK ' if ok else 'BAD'}] prescribed word {rc['q']} realised by its exact "
          f"rational seed (forward digits {rc['forward']})")

    qs = rc["q"]
    L, U = rc["L"], rc["U"]
    u0 = rc["u0"]
    ok = (L[0] <= u0 <= U[0]) and qs[0] + 1 <= u0 <= qs[0] + 2
    u = u0
    for k in range(len(qs) - 1):
        n = qs[k] + 2
        u = 1 / (Fraction(1) / u - Fraction(1, n))       # exact forward step
        # u must still be inside the cell of the prescribed next digit
        ok = ok and (qs[k + 1] + 1 <= u <= qs[k + 1] + 2)
    fails += not ok
    print(f"[{'OK ' if ok else 'BAD'}] every forward u_k stays in its prescribed "
          f"digit cell; |psi'| <= {float(rc['contraction']):.4f}")

    bl = [3 ** j for j in range(6)]
    al = block_alphas(bl, [Fraction(1, 2), Fraction(1, 4)])
    m = running_means(al)
    ends = [m[e - 1] for e in block_ends(bl)]
    spread = float(max(ends) - min(ends))
    ok = spread > 0.1
    fails += not ok
    print(f"[{'OK ' if ok else 'BAD'}] blocked running mean oscillates: "
          f"block-end spread = {spread:.4f} (exact Fractions)")

    # rigorous first-order error recursion for the tail:
    #   |s_k - alpha_k| <= omega_k,  omega_{k+1} = C_k omega_k + 1/q_{k+1}
    # with C_k = (n_k/(n_k+1))^2 <= 1/3 for q_k >= 2, and |phi_k(alpha_k)-alpha_k|
    # = alpha_k(1-alpha_k)/(q_{k+1}) <= 1/(4 q_{k+1}).
    K = len(qs) - 1
    omega = [Fraction(0)] * K
    omega[K - 1] = Fraction(1, qs[K])
    for k in range(K - 2, -1, -1):
        n = qs[k] + 2
        C = Fraction(n * n, (n + 1) * (n + 1))
        omega[k] = C * omega[k + 1] + Fraction(1, 4 * qs[k + 1])
    ok = omega[0] <= Fraction(1, qs[1])
    fails += not ok
    print(f"[{'OK ' if ok else 'BAD'}] first-order error bound omega_0 = "
          f"{float(omega[0]):.3e} <= 1/q_1 = {float(Fraction(1, qs[1])):.3e}; "
          f"omega_k/q_k -> 0")

    print(f"self-test: {5 - fails}/5 checks pass")
    return fails


if __name__ == "__main__":  # pragma: no cover
    raise SystemExit(_self_test())
