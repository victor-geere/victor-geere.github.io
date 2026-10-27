#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
011/rigorous/zeta_routeB.py — the `zeta` Route-B count by rigorous argument tracking.

The `010` counts evaluate `I3 = int_path xi'/xi ds` by the midpoint rule with a curvature
bound `Lf = sup|(log xi)''|` taken from a *box* enclosure.  With the fixed interval
primitives (`EXP_NUM_ERRATUM.md`) the box enclosure is wider, `Lf` larger, and the
quadrature budget larger: at `T = 33`, `steps/unit = 40`, `K = 100` the re-run gives
`N in [3.304, 6.696]`, i.e. it no longer pins `N = 5`.

This module removes the curvature bound entirely, exactly as the Dirichlet count does.
Since `I3 = int_path logDeriv xi ds = Delta log xi`, its imaginary part is the continuous
change of `arg xi` along the path, and the count is

    N(T) = Im(I3)/pi = (Delta arg xi)/pi.

Tracking `arg xi` sample by sample needs only a rigorous *value* enclosure of

    xi(s) = (1/2) s(s-1) pi^{-s/2} Gamma(s/2) zeta(s),

which is assembled from the `010` engine's `zeta_point` and the rigorous shifted-Stirling
`Gamma` of `dirichlet_routeB.gamma_point`.  There is no derivative bound anywhere, so the
result is insensitive to how loose the box arithmetic is.

This is the same method that certifies the Dirichlet window for `chi_3`
(`dirichlet_routeB.dirichlet_I3_arg`).
"""
from __future__ import annotations

import os
import sys
from fractions import Fraction

_HERE = os.path.dirname(os.path.abspath(__file__))
if _HERE not in sys.path:
    sys.path.insert(0, _HERE)
_010 = os.path.abspath(os.path.join(_HERE, "..", "..", "010", "rigorous"))
if _010 not in sys.path:
    sys.path.insert(0, _010)

import mpmath as mp            # noqa: E402
import ivmath as iv            # noqa: E402
import eta_interval as E       # noqa: E402
import dirichlet_routeB as R   # noqa: E402  (gamma_point and interval helpers)

ZERO = E.ZERO
ONE = E.ONE
Cx = E.Cx
_fr = R._fr
_point = R._point


@iv._pin
def xi_value(s_re, s_im, K: int = 100) -> Cx:
    """Rigorous enclosure of the completed `xi(s) = 1/2 s(s-1) pi^{-s/2} Gamma(s/2) zeta(s)`."""
    sr, si = _fr(s_re), _fr(s_im)
    z = E.zeta_point(sr, sr, si, si, K)
    G = R.gamma_point(sr / 2, si / 2)
    logpi = E._log_num(iv.pi())
    # pi^{-s/2} = exp(-(s/2) log pi)
    re_exp = iv.rat(-sr / 2) * logpi
    im_exp = iv.rat(-si / 2) * logpi
    mag = R.D._exp_box(re_exp.lo, re_exp.hi)
    Pi = Cx(mag * iv.cos_num(im_exp), mag * iv.sin_num(im_exp))
    s = Cx(_point(sr, sr), _point(si, si))
    pref = E._cscale(s * (s - Cx(ONE, ZERO)), Fraction(1, 2))
    return pref * Pi * G * z


def _track(s_of, a, b, K, depth=0):
    ra, ia = s_of(a)
    rb, ib = s_of(b)
    A = R._arg_enclosure(xi_value(ra, ia, K))
    B = R._arg_enclosure(xi_value(rb, ib, K))
    d = R._unwrap(B - A)
    if abs(d.v) < mp.pi / 2 and d.e < mp.pi / 4:
        return d
    if depth >= 24:
        raise ValueError("zeta_routeB: failed to resolve arg xi (a zero on the path?)")
    m = (a + b) / 2
    return _track(s_of, a, m, K, depth + 1) + _track(s_of, m, b, K, depth + 1)


@iv._pin
def zeta_I3_arg(T, samples_per_unit: int = 8, K: int = 100, verbose: bool = False):
    """`(Iim, Nest)` for `N(T) = Im(I3)/pi`, by rigorous argument tracking."""
    T = _fr(T)
    segs, pt = R._path_param(T)
    total = iv.Num(0)
    for i in range(len(segs)):
        dx = segs[i][1][0] - segs[i][0][0]
        dy = segs[i][1][1] - segs[i][0][1]
        length = mp.sqrt(R.D._mpf(dx) ** 2 + R.D._mpf(dy) ** 2)
        n = max(1, int(mp.ceil(samples_per_unit * length)))
        for j in range(n):
            a, b = Fraction(j, n), Fraction(j + 1, n)
            total = total + _track(lambda u: pt(i, u), a, b, K)
        if verbose:
            print("    segment %d/%d done, running arg change %s"
                  % (i + 1, len(segs), mp.nstr(total.v, 12)), flush=True)
    Nest = iv.Num(total.v / mp.pi, total.e / mp.pi + mp.mpf('1e-12'))
    return total, Nest


def certify(T, samples_per_unit: int = 8, K: int = 100, verbose: bool = True):
    """`(k, Nest)` with `N(T) = k` certified, or `(None, Nest)`."""
    total, Nest = zeta_I3_arg(T, samples_per_unit, K, verbose)
    k = int(mp.nint(Nest.v))
    ok = Nest.lo > k - mp.mpf('0.5') and Nest.hi < k + mp.mpf('0.5')
    if verbose:
        print("  N(%s) in [%s, %s] -> %s"
              % (T, mp.nstr(Nest.lo, 10), mp.nstr(Nest.hi, 10),
                 ("N=%d CERTIFIED" % k) if ok else "UNDECIDED"), flush=True)
    return (k if ok else None), Nest


if __name__ == "__main__":
    E.fast_mode()
    argv = sys.argv[1:]
    T = argv[0] if argv else "15"
    samples = int(argv[1]) if len(argv) > 1 else 8
    K = int(argv[2]) if len(argv) > 2 else 100
    sys.exit(0 if certify(T, samples, K)[0] is not None else 1)
