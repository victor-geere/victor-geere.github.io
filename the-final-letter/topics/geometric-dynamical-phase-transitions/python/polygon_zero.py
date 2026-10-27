"""A rigorous interval certificate of an off-critical zero of the N=2 polygon.

The polygon is `eta_2(s) = 1 - 2^{-s} + 3^{-s} - 4^{-s}`. We use the
Krawczyk interval operator on a small complex box: if `K(X) ⊂ int(X)`, then
`X` contains a unique zero. The certified box has real part strictly away
from `1/2`, so the polygon does not confine its zeros to the critical line.
"""

from __future__ import annotations

from mpmath import iv

# Centres and half-width of the two certified boxes.
CENTRES = [
    (0.578020715100285, 18.645458136506736),
    (0.8001391446430497, 26.741599404537162),
]
HALF_WIDTH = iv.mpf("1e-4")


def f(z):
    return 1 - iv.exp(-z * iv.log(2)) + iv.exp(-z * iv.log(3)) - iv.exp(-z * iv.log(4))


def fp(z):
    return (iv.log(2) * iv.exp(-z * iv.log(2))
            - iv.log(3) * iv.exp(-z * iv.log(3))
            + iv.log(4) * iv.exp(-z * iv.log(4)))


def box(centre=CENTRES[0]):
    x, y = centre
    return iv.mpc((x - HALF_WIDTH, x + HALF_WIDTH), (y - HALF_WIDTH, y + HALF_WIDTH))


def contains(inner, outer) -> bool:
    return (outer.real.a <= inner.real.a and inner.real.b <= outer.real.b
            and outer.imag.a <= inner.imag.a and inner.imag.b <= outer.imag.b)


def krawczyk_image(centre=CENTRES[0]):
    X = box(centre)
    mid = iv.mpc(*centre)
    c = 1 / fp(mid)
    return mid - c * f(mid) + (1 - c * fp(X)) * (X - mid)


def certified(centre=CENTRES[0]) -> bool:
    return contains(krawczyk_image(centre), box(centre))


def real_part_interval(centre=CENTRES[0]) -> tuple[float, float]:
    X = box(centre)
    return float(X.real.a), float(X.real.b)


def off_critical_certificate(centre=CENTRES[0]) -> bool:
    lo, hi = real_part_interval(centre)
    return certified(centre) and (hi < 0.5 or 0.5 < lo)


def all_certified() -> bool:
    return all(certified(c) for c in CENTRES)


def two_distinct_real_parts() -> bool:
    intervals = [real_part_interval(c) for c in CENTRES]
    return intervals[0][1] < intervals[1][0] or intervals[1][1] < intervals[0][0]
