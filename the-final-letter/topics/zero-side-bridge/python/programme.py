"""Numerical probes for the zero-side bridge (C1–C2).

The identity under test is

    Σ_ρ ĝ_c((ρ − 1/2)/i)  =  (W(c) + W(−c))/2  =  gaussianGramEntry 0 c σ

at `σ = 1/20`, summed over the first non-trivial zeros.  The arithmetic side is
computed from its three terms (pole, density, prime); the zero side from
`mpmath.zetazero`.  These are finite sanity checks, not a proof: the truncation,
the quadrature and the sieve are all explicit, and the equality as a theorem is
the open obligation of the programme.
"""

from __future__ import annotations

import mpmath as mp

mp.mp.dps = 30

SIGMA = mp.mpf(1) / 20
SIEVE = 400_000
ZEROS = 40


def zero_side(c: mp.mpf, n: int = ZEROS) -> mp.mpf:
    """`Σ_ρ ĝ_c((ρ − 1/2)/i)` over the first `n` zero *pairs*.

    `zetazero k` returns the zero with positive imaginary part; the zero set is
    closed under conjugation, and `ĝ_c(−γ) = conj(ĝ_c(γ))` for real `c`, so each
    pair contributes `2 · 2πσ² e^{−σ²γ²} cos(cγ)`.
    """
    total = mp.mpf(0)
    for k in range(1, n + 1):
        gamma = mp.im(mp.zetazero(k))
        total += 2 * 2 * mp.pi * SIGMA ** 2 * mp.exp(-(SIGMA * gamma) ** 2) * mp.cos(c * gamma)
    return total


def _von_mangoldt(n: int):
    """`(m, Λ(m)/√m)` for every prime power `m ≤ n`."""
    sieve = bytearray([1]) * (n + 1)
    sieve[0] = sieve[1] = 0
    for i in range(2, int(n ** 0.5) + 1):
        if sieve[i]:
            sieve[i * i::i] = bytearray(len(sieve[i * i::i]))
    out = []
    for p in range(2, n + 1):
        if sieve[p]:
            lp = mp.log(p)
            q = p
            while q <= n:
                out.append((q, lp / mp.sqrt(q)))
                q *= p
    return out


_VM = _von_mangoldt(SIEVE)


def _omega(t: mp.mpf) -> mp.mpf:
    return mp.re(mp.digamma(mp.mpf(1) / 4 + 1j * t / 2)) - mp.log(mp.pi)


def pole(c: mp.mpf) -> mp.mpf:
    """`4πσ² e^{σ²/4} cosh(c/2)`, the pole term of `W`."""
    return 4 * mp.pi * SIGMA ** 2 * mp.exp(SIGMA ** 2 / 4) * mp.cosh(c / 2)


def density(c: mp.mpf) -> mp.mpf:
    """`2σ² ∫ e^{−σ²t²} cos(ct) Ω(t) dt` (the doubled density term)."""
    return 2 * SIGMA ** 2 * mp.quad(
        lambda t: mp.exp(-(SIGMA * t) ** 2) * mp.cos(c * t) * _omega(t), [0, 200])


def prime(c: mp.mpf) -> mp.mpf:
    """`−2 Σ Λ(n)/√n · h_c(log n)`, truncated at the sieve."""
    s4 = 4 * SIGMA ** 2
    return -2 * sum(
        a * mp.sqrt(mp.pi) * SIGMA * mp.exp(-(mp.log(m) - c) ** 2 / s4) for m, a in _VM)


def gram_entry(c: mp.mpf) -> mp.mpf:
    """`(W(c) + W(−c))/2`, the symmetrised Weil kernel."""
    return pole(c) + density(c) + (prime(c) + prime(-c)) / 2


SEPARATIONS = [mp.mpf(k) / 5 for k in range(5)]


def table():
    """The `(c, zero side, arithmetic side, difference)` rows of C1."""
    rows = []
    for c in SEPARATIONS:
        zs = zero_side(c)
        ar = gram_entry(c)
        rows.append((c, zs, ar, zs - ar))
    return rows


if __name__ == "__main__":
    print(f"{'c':>4} {'zero side':>22} {'arithmetic side':>22} {'difference':>12}")
    for c, zs, ar, d in table():
        print(f"{str(c):>4} {mp.nstr(zs, 20):>22} {mp.nstr(ar, 20):>22} {mp.nstr(d, 3):>12}")
