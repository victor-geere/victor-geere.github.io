"""Univariate interval Taylor jets for the certified density quadrature.

A ``Jet`` stores the value and the first ``N`` derivatives of a function at
a point, each as an ``mpmath.iv`` interval.  The arithmetic is the usual
formal Taylor algebra with binomial convolution, so composing the same
formula with an interval-valued variable encloses the derivative functions
on that interval.

This module is intentionally small: it supports the operations needed by
``omega_t_jet`` (+, -, *, reciprocal, log, exp, cos, sin).  It is a
certified-arithmetic layer, not a proof of the final certificate.
"""

from __future__ import annotations

from math import comb

import mpmath as mp


def _iv(x) -> mp.iv.mpf:
    if isinstance(x, mp.iv.mpf):
        return x
    x = mp.mpf(x)
    return mp.iv.mpf([x, x])


def _zero() -> mp.iv.mpf:
    return mp.iv.mpf([0, 0])


class Jet:
    """Value and first ``N`` derivatives, each an interval."""

    def __init__(self, coeffs):
        self.c = [_iv(x) for x in coeffs]

    def __len__(self):
        return len(self.c)

    @property
    def order(self):
        return len(self.c) - 1

    def __getitem__(self, i):
        return self.c[i]

    def __add__(self, other):
        other = other if isinstance(other, Jet) else Jet.const(other, self.order)
        n = max(len(self), len(other))
        out = []
        for i in range(n):
            a = self.c[i] if i < len(self) else _zero()
            b = other.c[i] if i < len(other) else _zero()
            out.append(a + b)
        return Jet(out)

    __radd__ = __add__

    def __neg__(self):
        return Jet([-x for x in self.c])

    def __sub__(self, other):
        return self + (-(other if isinstance(other, Jet) else Jet.const(other, self.order)))

    def __rsub__(self, other):
        return (other if isinstance(other, Jet) else Jet.const(other, self.order)) - self

    def __mul__(self, other):
        other = other if isinstance(other, Jet) else Jet.const(other, self.order)
        n = max(len(self), len(other))
        out = [_zero() for _ in range(n)]
        for i in range(n):
            a = self.c[i] if i < len(self) else _zero()
            if a == _zero():
                continue
            for j in range(n - i):
                b = other.c[j] if j < len(other) else _zero()
                if b == _zero():
                    continue
                out[i + j] += comb(i + j, i) * a * b
        return Jet(out)

    __rmul__ = __mul__

    def __truediv__(self, other):
        return self * (other.inv() if isinstance(other, Jet) else Jet.const(other, self.order).inv())

    def __rtruediv__(self, other):
        return (other if isinstance(other, Jet) else Jet.const(other, self.order)) * self.inv()

    @classmethod
    def const(cls, x, order=5):
        return cls([_iv(x)] + [_zero() for _ in range(order)])

    @classmethod
    def variable(cls, x, order=5):
        return cls([_iv(x), _iv(1)] + [_zero() for _ in range(order - 1)])

    def derivative(self):
        """Derivative jet, one order lower (derivative representation)."""
        return Jet([self.c[i + 1] for i in range(len(self) - 1)])

    def inv(self):
        """Reciprocal via the formal identity ``f * f^{-1} = 1``."""
        if len(self) == 0:
            raise ValueError("empty jet")
        h0 = 1 / self.c[0]
        h = [h0]
        for n in range(1, len(self)):
            s = _zero()
            for k in range(1, n + 1):
                s += comb(n, k) * self.c[k] * h[n - k]
            h.append(-h0 * s)
        return Jet(h)

    def log(self):
        """Logarithm: ``h0 = log f0``, ``h_n = (f'/f)_{n-1}/n``."""
        if not (self.c[0].a > 0):
            raise ValueError("log requires a positive value interval")
        d = self.derivative() * self.inv()
        out = [mp.iv.log(self.c[0])]
        for n in range(1, len(self)):
            out.append(d[n - 1])
        return Jet(out)

    def exp(self):
        """Exponential: ``h0 = exp f0``, ``h_n = (1/n) Σ k f_k h_{n-k}``."""
        h0 = mp.iv.exp(self.c[0])
        h = [h0]
        fp = self.derivative()
        for n in range(1, len(self)):
            s = _zero()
            for k in range(n):
                s += comb(n - 1, k) * h[k] * fp[n - 1 - k]
            h.append(s)
        return Jet(h)

    def cos_sin(self):
        """Return ``(cos f, sin f)`` using the coupled derivative recurrences."""
        c = [mp.iv.cos(self.c[0])]
        s = [mp.iv.sin(self.c[0])]
        fp = self.derivative()
        for n in range(1, len(self)):
            # (cos f)' = -sin(f) f',  (sin f)' = cos(f) f'
            cprod = Jet(s[:n]) * fp if n > 1 else Jet([s[0]]) * fp
            sprod = Jet(c[:n]) * fp if n > 1 else Jet([c[0]]) * fp
            c.append(-cprod[n - 1])
            s.append(sprod[n - 1])
        return Jet(c), Jet(s)

    def __repr__(self):
        return f"Jet({self.c!r})"
