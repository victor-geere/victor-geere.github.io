"""Zero-sum growth for a compactly supported test function.

The tent F(x)=(1-|x|/A)_+ is compactly supported, so its Fourier transform
is entire of exponential type.  It decays on the real axis but grows like
e^{A|Im xi|/2} in imaginary directions, so the naive zero sum
sum_rho |Fhat(rho)|^2 diverges.  This is a distributional obstruction, not a
failure of the explicit formula.
"""

from __future__ import annotations

import mpmath as mp

__all__ = ["tent_F", "tent_Fhat", "growth"]

mp.mp.dps = 25


def tent_F(x, a=1.0):
    a = mp.mpf(a)
    return max(mp.mpf(0), 1 - abs(mp.mpf(x)) / a)


def tent_Fhat(xi, a=1.0):
    a = mp.mpf(a)
    return mp.quad(lambda x: tent_F(x, a) * mp.e**(-1j * xi * x), [-a, a])


def growth(gammas, a=1.0):
    return [abs(tent_Fhat(mp.mpf('0.5') + 1j * mp.mpf(g), a)) for g in gammas]


if __name__ == "__main__":  # pragma: no cover - manual demonstration
    gs = [1, 5, 10, 14, 20]
    print(list(zip(gs, [mp.nstr(v, 6) for v in growth(gs)])))
