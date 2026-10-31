"""Exact archimedean symbol of the CCM functional.

On the Fourier mode e^{i xi x} (x = log u), the archimedean term is

    A_arch(xi) = int_0^inf (e^{(2+i xi)x}-1)/(e^{2x}-1) dx + c,
    c = (log pi + gamma)/2.

Expanding 1/(e^{2x}-1) = sum_{k>=1} e^{-2kx} gives

    A_arch(xi) = sum_{m>=0} (1/(2m - i xi) - 1/(2m+2)) + c
               = (1/2)(log pi - psi(-i xi/2)),

where psi is the digamma function.  The pole at xi=0 is the archimedean pole.
"""

from __future__ import annotations

import mpmath as mp

__all__ = ["arch_symbol", "arch_series", "tail", "arch_real", "arch_imag", "arch_crossing"]


def arch_symbol(xi: float) -> complex:
    return 0.5 * (mp.log(mp.pi) - mp.digamma(-1j * mp.mpf(xi) / 2))


def arch_series(xi: float, m_max: int = 200000) -> complex:
    xi = mp.mpf(xi)
    total = mp.mpf(0)
    for m in range(m_max):
        total += 1 / (2 * m - 1j * xi) - 1 / (2 * m + 2)
    return total + (mp.log(mp.pi) + mp.euler) / 2


def arch_real(xi: float) -> float:
    return float(mp.re(arch_symbol(xi)))


def arch_imag(xi: float) -> float:
    return float(mp.im(arch_symbol(xi)))


def arch_crossing() -> float:
    """Positive xi where Re A_arch(xi) = 0 (around 6.22885)."""
    return float(mp.findroot(lambda x: mp.re(arch_symbol(x)), 7.0))


if __name__ == "__main__":  # pragma: no cover - manual demonstration
    mp.mp.dps = 30
    for xi in (0.5, 1.0, 2.0, 5.0):
        s = arch_series(xi, 100000)
        f = arch_symbol(xi)
        print(xi, "series", mp.nstr(s, 12), "formula", mp.nstr(f, 12),
              "diff", mp.nstr(s - f, 6), "tail", tail(100000))
