"""Compare the CCM archimedean symbol with the Weil archimedean factor.

CCM:  A_arch(xi) = (1/2)(log pi - psi(-i xi/2)).
Weil: Omega(t) = Re psi(1/4 + i t/2) - log pi.

Both have a single positive sign change, but at different points, and their
behaviour at 0 and infinity is opposite.  They are not constant multiples.
"""

from __future__ import annotations

import mpmath as mp

from arch_symbol import arch_real

__all__ = ["weil_omega", "crossings"]

mp.mp.dps = 25


def weil_omega(t: float) -> float:
    return float(mp.re(mp.digamma(mp.mpf(1) / 4 + 1j * mp.mpf(t) / 2)) - mp.log(mp.pi))


def crossings() -> dict:
    return {
        "ccm": float(mp.findroot(lambda x: mp.re(
            mp.mpf(1) / 2 * (mp.log(mp.pi) - mp.digamma(-1j * mp.mpf(x) / 2))
        ), 7.0)),
        "weil": float(mp.findroot(lambda t: mp.re(
            mp.digamma(mp.mpf(1) / 4 + 1j * mp.mpf(t) / 2)
        ) - mp.log(mp.pi), 6.0)),
    }


if __name__ == "__main__":  # pragma: no cover - manual demonstration
    print(crossings())
    for t in (0.01, 2, 4, 6, 6.22885, 6.28319, 8, 10):
        print(t, "Omega", weil_omega(t), "A_ccm", arch_real(t))
