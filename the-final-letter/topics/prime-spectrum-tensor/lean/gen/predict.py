#!/usr/bin/env python3
"""Predict the density-certificate half-width for a partition, without emitting Lean.

The per-panel error of `panels.py` is

    E_p = |q_mid| * h^3 / (4*wden) + max(A, B) * h * sw
    A   = q_mid - (q_lo - lip*h/2)
    B   = (q_hi + lip*h/2) - q_mid
    lip = 6/a   (a >= 1),  10  (a < 1)
    sw  = (1/400) / (1 + a^2/400)

with `q_lo, q_hi` an `Ω` bracket of half-width 1e-4 at the midpoint and `h = b-a`.
The certified half-width of `IntersectionForm.density` is

    K = sum_p E_p + 1/10000        (the tail bound).

`densityTerm = 2 * density`, so `densityTerm` has half-width `2*K`.

Usage
-----
    python3 predict.py --c 0 --grid uniform --h0 1/125 --h1 1/20
    python3 predict.py --c 1/5 --grid geo --ratio 1.05 --h0 1/200
    python3 predict.py --c 4/5 --grid opt --target 0.0006 --wden 200
"""

import argparse
import math
from fractions import Fraction as F

import panels as G


def edges_uniform(h0, h1):
    n0 = int(round(1 / F(h0)))
    n1 = int(round(59 / F(h1)))
    e = [F(0)]
    e += [F(i, n0) for i in range(1, n0 + 1)]
    e += [F(1) + F(59 * i, n1) for i in range(1, n1 + 1)]
    return e


def edges_geo(ratio, h0, start=F(1), stop=F(60)):
    """[0,1] uniform at h0, then geometric with the given ratio."""
    r = F(ratio)
    n0 = int(round(1 / F(h0)))
    e = [F(i, n0) for i in range(0, n0 + 1)]
    a = start
    while a < stop:
        b = a * r
        if b > stop:
            b = stop
        e.append(b)
        a = b
    return e


def edges_opt(k, h0, start=F(1), stop=F(60)):
    """h(a) = k * sqrt(a*(400+a^2)): equalises the marginal error."""
    n0 = int(round(1 / F(h0)))
    e = [F(i, n0) for i in range(0, n0 + 1)]
    a = float(start)
    kk = float(k)
    while a < float(stop) - 1e-12:
        h = kk * math.sqrt(a * (400 + a * a))
        b = min(a + h, float(stop))
        e.append(F(b).limit_denominator(10 ** 9))
        a = b
    e = sorted(set(e))
    return e


def panel_error2(a, b, c, wden, lipc=F(5, 2)):
    """Second-order (h^3) per-panel error: |(wΩ)″| ≤ B on the panel."""
    m = (a + b) / 2
    h = b - a
    qlo, qhi = G.omega_bracket(m)
    qmid = (qlo + qhi) / 2
    lip = lipc / a if a >= 1 else F(10)
    # panel bounds
    W = F(1, 400) / (1 + a * a / 400)                 # |w|
    W1 = F(1, 400) * (b / 200 + abs(c))               # |w'|
    # |w''| <= (1/400) e^{-a^2/400} (1/200 + b^2/40000 + c^2 + 2(b/200)|c|),
    # the panel-local decaying bound of WeightDeriv2.abs_deriv2_weight_le_div
    poly = F(1, 200) + b * b / 40000 + c * c + 2 * (b / 200) * abs(c)
    decay = F(math.floor(math.exp(-float(a * a) / 400) * 10 ** 12), 10 ** 12)
    W2 = F(1, 400) * (decay + F(1, 10 ** 12)) * poly
    Om = abs(qmid) + lip * h / 2                      # |Omega|
    L = lip                                           # |Omega'|
    S = (F(5) / (a * a)) if a >= 1 else F(10) * F(10)  # |Omega''| <= 5/t^2
    B = W2 * Om + 2 * (W1 * L) + W * S
    return G.ceil_at(B * h ** 3 / 4, G.DEC_OUT)


def panel_error(a, b, c, wden, lipc=F(6)):
    m = (a + b) / 2
    h = b - a
    qlo, qhi = G.omega_bracket(m)
    qmid = (qlo + qhi) / 2
    lip = lipc / a if a >= 1 else F(10)
    sw = F(1, 400) / (1 + a * a / 400)
    delta = (qhi - qlo) / 2 + lip * h / 2
    E1 = G.ceil_at(abs(qmid) * h ** 3 / (4 * wden) + delta * h * sw, G.DEC_OUT)
    # node bracket
    y = m * m * G.SIGMA2
    _, _, _, _, _, efinal = G.exp_data(y)
    elo, ehi = efinal
    e0 = (elo + ehi) / 2
    epse = (ehi - elo) / 2
    if c == 0:
        w0 = G.floor_at(e0 / 400, G.DEC)
        eps = epse / 400 + (e0 / 400 - w0)
        if eps < epse / 400:
            eps = epse / 400
    else:
        _, _, _, _, _, _, cfinal, _ = G.cos_data(c * m)
        clo, chi = cfinal
        c0 = (clo + chi) / 2
        epsc = (chi - clo) / 2
        w0 = G.floor_at(e0 * c0 / 400, G.DEC)
        eps = (epse + abs(e0) * epsc) / 400 + abs(e0 * c0 / 400 - w0)
    E = G.ceil_at(E1 + abs(qmid) * h * eps, G.DEC_OUT)
    return E


def total(edges, c, wden, lipc=F(6), order=1):
    """(K, T): the certified half-width and the midpoint sum `T`."""
    S = F(0); T = F(0)
    for p in range(len(edges) - 1):
        a, b = edges[p], edges[p + 1]
        m = (a + b) / 2
        h = b - a
        qlo, qhi = G.omega_bracket(m)
        qmid = (qlo + qhi) / 2
        y = m * m * G.SIGMA2
        _, _, _, _, _, efinal = G.exp_data(y)
        e0 = (efinal[0] + efinal[1]) / 2
        if c == 0:
            w0 = G.floor_at(e0 / 400, G.DEC)
        else:
            _, _, _, _, _, _, cfinal, _ = G.cos_data(c * m)
            c0 = (cfinal[0] + cfinal[1]) / 2
            w0 = G.floor_at(e0 * c0 / 400, G.DEC)
        if order == 2:
            S += panel_error2(a, b, c, wden, lipc)
        else:
            S += panel_error(a, b, c, wden, lipc)
        T += qmid * h * w0
    return S + F(1, 10000), T


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--c", default="0")
    ap.add_argument("--grid", default="uniform", choices=["uniform", "geo", "opt"])
    ap.add_argument("--h0", default="1/125")
    ap.add_argument("--h1", default="1/20")
    ap.add_argument("--ratio", default="1.05")
    ap.add_argument("--k", default="0.005")
    ap.add_argument("--wden", type=int, default=400)
    ap.add_argument("--edges", default="", help="explicit partition file")
    ap.add_argument("--order", type=int, default=1,
                    help="panel rule: 1 (midpoint, h^2) or 2 (second-order, h^3)")
    ap.add_argument("--lip-c", default="6",
                    help="Lipschitz coefficient C in |Omega'| <= C/t (6 or 5/2)")
    a = ap.parse_args()
    c = F(a.c)
    if a.edges:
        e = [F(x.strip()) for x in open(a.edges) if x.strip()]
    elif a.grid == "uniform":
        e = edges_uniform(a.h0, a.h1)
    elif a.grid == "geo":
        e = edges_geo(a.ratio, a.h0)
    else:
        e = edges_opt(a.k, a.h0)
    K, T = total(e, c, a.wden, F(a.lip_c), a.order)
    print(f"c={a.c} grid={a.grid} panels={len(e)-1}  K={float(K):.6e}  "
          f"densityTerm half-width={float(2*K):.6e}")
    print(f"   density band = [{float(T - K):.9f}, {float(T + K):.9f}]  "
          f"densityTerm band = [{float(2*(T - K)):.9f}, {float(2*(T + K)):.9f}]")


if __name__ == "__main__":
    main()
