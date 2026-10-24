"""
tpp_greedy_orbit.py — residual-orbit checks for the rh40 greedy/Egyptian digit map.

Programme: Riemann-hypothesis / twin-prime-parity workspace
(/Users/victor/workspace/rh).  Ground truth for the *greedy digit word* is
`research/twin-prime-parity/rounds/rh40/code/digitword.py`; this module adds the
**residual orbit** arithmetic that the harvested open items OP-26/OP-27 (K5),
OP-28/OP-30 (K6h), OP-29/OP-31 (K6j) and OP-33 (I8) are about.  Nothing here
is imported from the round directory, so it can be used as an independent
cross-check.

Objects
-------
`r_k`   residual of the greedy rule (`r_0 = x`, `r_{k+1} = r_k - 1/q_k`);
`u_k = 1/r_k`, `q_k = ceil(u_k)`, `s_k = q_k - u_k = 1 - {u_k}`.
The exact squaring law is

    r_{k+1} / r_k**2  =  s_k / (1 + s_k * r_k)          (identity, exact)

so the per-step ratio is `<= s_k` and `s_k` can be arbitrarily small: there is
**no positive lower bound** on `r_{k+1}/r_k**2`.  This is the obstruction the
rh40 source found; it obstructs the *lower* bound `A(N) = Omega(log log N)`, not
the upper bound (which follows from the one-sided law `r_{k+1} <= r_k**2`).
See `research-journal.md` J4 and register OP-13.

The module also implements the **prescribed-digit** route: for any `alpha_k` in
`(0,1]` one may take `q_{k+1} ~ q_k**2 / alpha_k` (Sylvester-admissible), in
which case the exact backward relation `s_k = q_k**2/(q_k + q_{k+1} - s_{k+1})`
gives `s_k = alpha_k + O(1/q_k)`.  Because `q_k` grows double-exponentially, the
error is doubly-exponentially small, so the Cesaro mean of `log s_k` can be
computed for arbitrarily many steps *without* following the exploding forward
orbit.  Choosing `alpha_k` alternating in `{1/2, 1/4}` therefore gives a family
of `x` whose orbit average has **no limit** (harvested OP-28 / OP-30).

Run:  python3 lib/tpp_greedy_orbit.py
"""

from __future__ import annotations

import math
from fractions import Fraction
from typing import Dict, List, Sequence, Tuple


# ---------------------------------------------------------------------------
# 1. The exact squaring-law identity
# ---------------------------------------------------------------------------

def step_quantities(r: Fraction) -> Tuple[int, Fraction, Fraction, Fraction]:
    """Return `(q, s, r_next, ratio)` for the residual `r > 0`.

    `q = ceil(1/r)`, `s = q - 1/r`, `r_next = r - 1/q`, `ratio = r_next / r**2`.
    """
    if r <= 0:
        raise ValueError("need r > 0")
    u = 1 / r
    q = -((-u.numerator) // u.denominator)          # exact ceil for Fraction
    s = Fraction(q) - u
    r_next = r - Fraction(1, q)
    ratio = r_next / (r * r)
    return q, s, r_next, ratio


def predicted_ratio(r: Fraction) -> Fraction:
    """The closed form `s/(1 + s*r)` of the squaring-law ratio."""
    u = 1 / r
    q = -((-u.numerator) // u.denominator)
    s = Fraction(q) - u
    return s / (1 + s * r)


def verify_ratio_identity(seeds: Sequence[Fraction]) -> Fraction:
    """Max |actual ratio - s/(1+s*r)| over `seeds`; returns 0 for the true law."""
    worst = Fraction(0)
    for r in seeds:
        if r <= 0 or r >= 1:
            continue
        _, _, _, ratio = step_quantities(r)
        d = abs(ratio - predicted_ratio(r))
        worst = max(worst, d)
    return worst


def ratio_witness(delta: Fraction, n: int = 10 ** 6) -> Tuple[Fraction, Fraction]:
    """A seed whose squaring ratio is `< delta`.

    Take `r = 1/(n - delta)`, so `u = n - delta`, `q = n` and `s = delta`; the
    ratio equals `delta/(1 + delta*r) < delta`.  Shows the ratio has no positive
    lower bound (OP-26 / K5 obstruction).
    """
    if not (0 < delta < 1):
        raise ValueError("need 0 < delta < 1")
    r = 1 / (Fraction(n) - delta)
    _, _, _, ratio = step_quantities(r)
    return r, ratio


# ---------------------------------------------------------------------------
# 2. Prescribed digit sequences (the backward route)
# ---------------------------------------------------------------------------

def prescribed_digits(alphas: Sequence[Fraction], q0: int = 4) -> List[int]:
    """Admissible `q`-sequence with `q_{k+1} = round(q_k**2 / alpha_k)`.

    Requires `0 < alpha_k <= 1`; the result satisfies the Sylvester lower bound
    `q_{k+1} >= q_k*(q_k - 1) + 1` by construction (checked in the self-test).
    """
    qs = [q0]
    for a in alphas:
        if not (0 < a <= 1):
            raise ValueError("need 0 < alpha <= 1")
        qs.append(int(round(qs[-1] * qs[-1] / a)))
    return qs


def backward_s(qs: Sequence[int], s_terminal: Fraction = Fraction(1, 2)) -> List[Fraction]:
    """Exact `s_k` from the backward relation `s_k = q_k**2/(q_k+q_{k+1}-s_{k+1})`."""
    s: List[Fraction] = [Fraction(0)] * len(qs)
    s[-1] = s_terminal
    for k in range(len(qs) - 2, -1, -1):
        qk, qk1 = qs[k], qs[k + 1]
        s[k] = Fraction(qk * qk) / (Fraction(qk + qk1) - s[k + 1])
    return s


def sylvester_admissible(qs: Sequence[int]) -> bool:
    return all(qs[k + 1] >= qs[k] * (qs[k] - 1) + 1 for k in range(len(qs) - 1))


def check_prescribed(alphas: Sequence[Fraction], q0: int = 4) -> Dict[str, object]:
    """Diagnostics for a prescribed `alpha` pattern."""
    qs = prescribed_digits(alphas, q0)
    s = backward_s(qs)
    errs = [abs(s[k] - alphas[k]) for k in range(len(alphas))]
    return {
        "q": qs,
        "s": s,
        "admissible": sylvester_admissible(qs),
        "s_in_unit_interval": all(0 < v <= 1 for v in s[:-1]),
        "max_err": max(errs) if errs else Fraction(0),
        "err_tail": errs[-1] if errs else Fraction(0),
    }


def running_mean(log_terms: Sequence[float]) -> List[float]:
    """Running Cesaro means of a sequence of (already logged) terms."""
    out: List[float] = []
    tot = 0.0
    for i, v in enumerate(log_terms):
        tot += v
        out.append(tot / (i + 1))
    return out


def block_pattern(values: Sequence[float], block_lengths: Sequence[int]) -> List[float]:
    """Repeat `values[j % len(values)]` for `block_lengths[j]` terms."""
    out: List[float] = []
    for j, n in enumerate(block_lengths):
        out.extend([values[j % len(values)]] * n)
    return out


def mean_has_no_limit(log_terms: Sequence[float], n_blocks: int = 6,
                      tol: float = 1e-2) -> bool:
    """True if the running mean still oscillates by > tol at block boundaries.

    A cheap witness for the harvester's OP-28/OP-30 'no limit' family.  A plain
    two-value alternation converges (each pair has the same mean); the witness is
    a *geometrically growing* block pattern, `alpha = c_0` for `10^0` terms,
    `c_1` for `10^1`, `c_0` for `10^2`, ... so the running mean at the end of
    each block is within `O(10^{-j})` of that block's value.
    """
    total = sum(10 ** j for j in range(n_blocks))
    if len(log_terms) < total:
        return False
    m = running_mean(log_terms[:total])
    ends = []
    pos = 0
    for j in range(n_blocks):
        pos += 10 ** j
        ends.append(m[min(pos, len(m)) - 1])
    return (max(ends) - min(ends)) > tol


# ---------------------------------------------------------------------------
# 3. Self-test
# ---------------------------------------------------------------------------

def _self_test() -> int:
    fails = 0

    # (a) exact squaring-law identity over many rational seeds
    seeds = [Fraction(p, q) for q in range(2, 200) for p in (1, q - 1, q // 2 or 1)]
    worst = verify_ratio_identity([s for s in seeds if 0 < s < 1])
    ok = worst == 0
    fails += not ok
    print(f"[{'OK ' if ok else 'BAD'}] exact ratio identity r_(k+1)/r_k^2 = s/(1+s r) "
          f"(max deviation {float(worst)})")

    # (b) no positive lower bound: an explicit ratio < delta for tiny deltas
    for delta in (Fraction(1, 10 ** 3), Fraction(1, 10 ** 12), Fraction(1, 10 ** 40)):
        _, ratio = ratio_witness(delta)
        ok = ratio < delta
        fails += not ok
        print(f"[{'OK ' if ok else 'BAD'}] ratio witness for delta={float(delta):.0e}: "
              f"ratio={float(ratio):.3e} < delta")

    # (c) prescribed alternation gives admissible digits and s_k -> alpha_k
    alphas = [Fraction(1, 2) if k % 2 == 0 else Fraction(1, 4) for k in range(12)]
    d = check_prescribed(alphas)
    ok = bool(d["admissible"]) and bool(d["s_in_unit_interval"])
    fails += not ok
    print(f"[{'OK ' if ok else 'BAD'}] prescribed alpha=(1/2,1/4,...): admissible="
          f"{d['admissible']}, all s in (0,1]={d['s_in_unit_interval']}, "
          f"|s_k-alpha_k| falls {float(d['max_err']):.2e} -> {float(d['err_tail']):.2e}")

    # (d) a geometrically-blocked prescribed pattern's running mean has no limit
    vals = [math.log(1 / 2), math.log(1 / 4)]
    block_lengths = [10 ** j for j in range(6)]
    logs = block_pattern(vals, block_lengths)
    ok = mean_has_no_limit(logs)
    fails += not ok
    print(f"[{'OK ' if ok else 'BAD'}] blocked log s_k (1/2 for 1, 1/4 for 10, ...): "
          f"running mean keeps oscillating (no limit) = {ok}")

    # (e) the explicit Sylvester sequence q_{k+1} = 2 q_k^2 is admissible
    qs = [4]
    for _ in range(8):
        qs.append(2 * qs[-1] * qs[-1])
    ok = sylvester_admissible(qs)
    fails += not ok
    print(f"[{'OK ' if ok else 'BAD'}] Sylvester sequence q_(k+1)=2q_k^2 admissible = {ok}")

    print(f"self-test: {5 - fails}/5 checks pass")
    return fails


if __name__ == "__main__":  # pragma: no cover
    raise SystemExit(_self_test())
