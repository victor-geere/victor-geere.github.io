#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""certify_count_par.py — parallel Route B count, UNCONDITIONAL (`Lf_const=None`).

Equivalent to `I3_certificate(T, steps_per_unit, K, Lf_const=None)`, but the boxes
of the path are evaluated in a process pool.  The interval accumulation in
`I3_certificate` is

    Ire = Num(Ire.v + term.re.v, Ire.e + term.re.e + err)

i.e. centres add and error radii add independently, so the total is
**order-independent** and can be computed by summing per-box contributions in any
order.  That is what this script does.

Usage:
    python3 certify_count_par.py [T] [steps_per_unit] [K] [workers]

Each box is evaluated in its own worker *process* (`maxtasksperchild=1`) so that
no state leaks between boxes and a single bad box cannot poison the pool.
"""
import math
import os
import sys
from concurrent.futures import ProcessPoolExecutor
from fractions import Fraction as F

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)


def _boxes(T, steps_per_unit):
    h = F(1, 2)
    T = F(T)
    path = [((h, h), (F(1), h)), ((F(1), h), (F(1), T)), ((F(1), T), (h, T))]
    out = []
    for (P, Q) in path:
        dx, dy = Q[0] - P[0], Q[1] - P[1]
        L = math.sqrt(float(dx * dx + dy * dy))
        n = max(1, int(math.ceil(steps_per_unit * L)))
        for i in range(n):
            ax, ay = P[0] + dx * i / n, P[1] + dy * i / n
            bx, by = P[0] + dx * (i + 1) / n, P[1] + dy * (i + 1) / n
            out.append((str(min(ax, bx)), str(max(ax, bx)),
                        str(min(ay, by)), str(max(ay, by)),
                        str(dx / n), str(dy / n)))
    return out


def _one(task):
    """One box -> (centre_re, centre_im, err_re, err_im) as floats."""
    box, K = task
    import mpmath as mp
    mp.mp.dps = 40
    import eta_interval as E
    import ivmath as iv
    E.fast_mode()
    E._D = 10 ** 18
    sa, sb, sc, sd, sdx, sdy = box
    a, b, c, d = F(sa), F(sb), F(sc), F(sd)
    dx, dy = F(sdx), F(sdy)
    mx, my = (a + b) / 2, (c + d) / 2
    fm = E.xi_logderiv(mx, mx, my, my, K, 10, value_only=True)[0]
    _, fpb = E.xi_logderiv(min(a, b), max(a, b), min(c, d), max(c, d), K, 10)
    Lf = mp.sqrt((abs(fpb.re.v) + fpb.re.e) ** 2 + (abs(fpb.im.v) + fpb.im.e) ** 2)
    dsmod = mp.sqrt(mp.mpf(float(dx)) ** 2 + mp.mpf(float(dy)) ** 2)
    err = (mp.mpf(1) / 8) * dsmod ** 2 * Lf
    term = fm * E.Cx(iv.rat(dx), iv.rat(dy))
    return (float(term.re.v), float(term.im.v),
            float(term.re.e + err), float(term.im.e + err))


def main(T=33, steps_per_unit=32, K=100, workers=4):
    import mpmath as mp
    mp.mp.dps = 40
    boxes = _boxes(T, steps_per_unit)
    print("Route B T=%s PARALLEL, UNCONDITIONAL (Lf per step, no cited constant)"
          % T, flush=True)
    print("  config: fast mode work=60 EPS=1e-40, K=%d, steps/unit=%d, boxes=%d, workers=%d"
          % (K, steps_per_unit, len(boxes), workers), flush=True)
    import time
    t0 = time.time()
    re_v = im_v = re_e = im_e = 0.0
    done = 0
    fails = 0
    with ProcessPoolExecutor(max_workers=workers, max_tasks_per_child=1) as ex:
        for r in ex.map(_one, [(b, K) for b in boxes], chunksize=1):
            done += 1
            if r is None:
                fails += 1
                continue
            re_v += r[0]; im_v += r[1]; re_e += r[2]; im_e += r[3]
            if done % 100 == 0:
                print("  %d/%d boxes  (%.0fs)" % (done, len(boxes), time.time() - t0),
                      flush=True, file=sys.stderr)
    if fails:
        print("  %d box(es) FAILED -- result is not a certificate" % fails)
        return 1
    Nest = mp.mpf(im_v) / mp.pi
    Ne = mp.mpf(im_e) / mp.pi + mp.mpf('1e-12')
    k = int(mp.nint(Nest))
    ok = (Nest - Ne) > k - mp.mpf('0.5') and (Nest + Ne) < k + mp.mpf('0.5')
    print("  T=%s steps/unit=%d K=%d -> I3=(%s,%s)  N in [%s,%s]"
          % (T, steps_per_unit, K, mp.nstr(re_v, 10), mp.nstr(im_v, 10),
             mp.nstr(Nest - Ne, 8), mp.nstr(Nest + Ne, 8)), flush=True)
    print("  N(%s) in [%s,%s] -> %s  (%.0fs)"
          % (T, mp.nstr(Nest - Ne, 8), mp.nstr(Nest + Ne, 8),
             ("N(%s)=%d CERTIFIED" % (T, k)) if ok else "UNDECIDED",
             time.time() - t0), flush=True, file=sys.stderr)
    if ok:
        print("  UNCONDITIONAL: no cited |zeta'/zeta| bound was used; Lf is enclosed per step.",
              flush=True)
    return 0 if ok else 1


if __name__ == "__main__":
    argv = sys.argv[1:]
    T = argv[0] if len(argv) > 0 else 33
    steps = int(argv[1]) if len(argv) > 1 else 32
    K = int(argv[2]) if len(argv) > 2 else 100
    workers = int(argv[3]) if len(argv) > 3 else 4
    sys.exit(main(T, steps, K, workers))
