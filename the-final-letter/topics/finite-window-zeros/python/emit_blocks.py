"""Rational mirror of the Lean `CpowBox` layer, for block-box emission.

This ports the *rational interval* definitions from
`topics/partial-sum-plus-tail/lean/{IBox,Transcend,CpowBox}.lean` and
`Cert.lean`'s `pairBox`, then folds them with outward grid rounding.

It is a reference emitter: it computes block boxes for the eta partial sum at
``s = 1/2 + 14i``.  The Lean side already proves the fold and membership
lemmas; this script supplies literal block endpoints.
"""

from __future__ import annotations

import argparse
import json
from fractions import Fraction as F
from math import factorial, floor, log2

# ---------------------------------------------------------------- intervals

Iv = tuple[F, F]
Cx = tuple[Iv, Iv]


def add(a: Iv, b: Iv) -> Iv:
    return (a[0] + b[0], a[1] + b[1])


def neg(a: Iv) -> Iv:
    return (-a[1], -a[0])


def sub(a: Iv, b: Iv) -> Iv:
    return add(a, neg(b))


def scale(q: F, a: Iv) -> Iv:
    return (q * a[0], q * a[1]) if q >= 0 else (q * a[1], q * a[0])


def mul(a: Iv, b: Iv) -> Iv:
    corners = (a[0] * b[0], a[0] * b[1], a[1] * b[0], a[1] * b[1])
    return (min(corners), max(corners))


def inflate(r: F, a: Iv) -> Iv:
    return (a[0] - r, a[1] + r)


def pow_iv(a: Iv, n: int) -> Iv:
    out: Iv = (F(1), F(1))
    for _ in range(n):
        out = mul(out, a)
    return out


def cx_add(z: Cx, w: Cx) -> Cx:
    return (add(z[0], w[0]), add(z[1], w[1]))


def cx_neg(z: Cx) -> Cx:
    return (neg(z[0]), neg(z[1]))


def cx_sub(z: Cx, w: Cx) -> Cx:
    return cx_add(z, cx_neg(w))


def cx_mul(z: Cx, w: Cx) -> Cx:
    return (sub(mul(z[0], w[0]), mul(z[1], w[1])),
            add(mul(z[0], w[1]), mul(z[1], w[0])))


def cx_scale(q: F, z: Cx) -> Cx:
    return (scale(q, z[0]), scale(q, z[1]))


def cx_inflate(r: F, z: Cx) -> Cx:
    return (inflate(r, z[0]), inflate(r, z[1]))


def cx_pow(z: Cx, n: int) -> Cx:
    out: Cx = ((F(1), F(1)), (F(0), F(0)))
    for _ in range(n):
        out = cx_mul(out, z)
    return out


# ------------------------------------------------------------------- exp/log


def exp_taylor(n: int, a: Iv) -> Iv:
    out: Iv = (F(0), F(0))
    for k in range(n):
        out = add(out, scale(F(1, factorial(k)), pow_iv(a, k)))
    return out


def exp_rem(n: int) -> F:
    return F(n + 1, factorial(n) * n)


def exp_iv_general(k: int, a: Iv) -> Iv:
    box = inflate(exp_rem(k), exp_taylor(k, scale(F(1, k), a)))
    return pow_iv(box, k)


def log_term(a: F, k: int) -> F:
    t = a / (a + 2)
    return 2 * F(1, 2 * k + 1) * t ** (2 * k + 1)


def log_partial(n: int, a: F) -> F:
    return sum((log_term(a, k) for k in range(n)), F(0))


def log_rem(n: int, a: F) -> F:
    t = a / (a + 2)
    return 2 * t ** (2 * n + 1) / ((2 * n + 1) * (1 - t * t))


def log_iv(n: int, a: Iv) -> Iv:
    return (log_partial(n, a[0] - 1),
            log_partial(n, a[1] - 1) + log_rem(n, a[1] - 1))


def log_iv_rat(n: int, b: int) -> Iv:
    L = floor(log2(b))
    p = 2 ** L
    return add(log_iv(n, (F(b, p), F(b, p))), scale(F(L), log_iv(n, (F(2), F(2)))))


# ---------------------------------------------------------------- exp(i t)


def exp_i_taylor(n: int, a: Iv) -> Cx:
    out: Cx = ((F(0), F(0)), (F(0), F(0)))
    for k in range(n):
        term = cx_scale(F(1, factorial(k)), cx_pow(((F(0), F(0)), a), k))
        out = cx_add(out, term)
    return out


def exp_i_box(k: int, n: int, a: Iv) -> Cx:
    inner = cx_inflate(exp_rem(n), exp_i_taylor(n, scale(F(1, k), a)))
    return cx_pow(inner, k)


# ------------------------------------------------------------------ cpowBox


def cpow_exponent(n: int, b: int, s: Cx) -> Cx:
    return cx_mul(cx_neg(s), (log_iv_rat(n, b), (F(0), F(0))))


def cpow_box(n: int, k: int, ki: int, nn: int, b: int, s: Cx) -> Cx:
    p = cpow_exponent(n, b, s)
    er = exp_iv_general(k, p[0])
    tr = exp_i_box(ki, nn, p[1])
    return (mul(er, tr[0]), mul(er, tr[1]))


# ------------------------------------------------------------------- pairs

S14: Cx = ((F(1, 2), F(1, 2)), (F(14), F(14)))
PARAMS = (10, 10, 256, 12)  # N, k, kI, n  (paramsFast)


def pair_box(m: int) -> Cx:
    n, k, ki, nn = PARAMS
    b1, b2 = 2 * m + 1, 2 * m + 2
    return cx_sub(cpow_box(n, k, ki, nn, b1, S14),
                  cpow_box(n, k, ki, nn, b2, S14))


# --------------------------------------------------------------- snapping


def snap_iv(a: Iv, grid_den: int = 10 ** 12) -> Iv:
    lo = F(floor(a[0] * grid_den), grid_den)
    hi = F(-((-a[1] * grid_den).__floor__()), grid_den)
    return (lo, hi)


def snap_cx(z: Cx) -> Cx:
    return (snap_iv(z[0]), snap_iv(z[1]))


def block_box(offset: int, size: int) -> Cx:
    out: Cx = ((F(0), F(0)), (F(0), F(0)))
    for m in range(offset, offset + size):
        out = snap_cx(cx_add(pair_box(m), out))
    return out


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--terms", type=int, default=100)
    ap.add_argument("--block", type=int, default=100)
    ap.add_argument("--json", action="store_true")
    args = ap.parse_args()
    boxes = [block_box(o, args.block) for o in range(0, args.terms, args.block)]
    if args.json:
        print(json.dumps([[[str(v) for v in iv] for iv in z] for z in boxes]))
    else:
        for o, z in zip(range(0, args.terms, args.block), boxes):
            print(o, z)


if __name__ == "__main__":
    main()
