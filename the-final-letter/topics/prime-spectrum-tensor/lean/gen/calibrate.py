#!/usr/bin/env python3
"""Reproduce (and optionally check) the calibration table of ../CALIBRATION.md.

Computes the Gaussian Weil kernel at `sigma = 1/20` from its three terms,
builds the exact Gram matrices for `n = 4, …, 7`, and reports

  * the smallest eigenvalue of each,
  * the Rayleigh quotient of the recorded witness vector,
  * the certified halfwidth implied by the entrywise bound.

With `--check` the computed values are compared with the recorded ones and the
script exits non-zero on a mismatch, so it can be used as a regression test for
any reimplementation of the kernel.
"""
import argparse, sys
from fractions import Fraction as F

import numpy as np
import mpmath as mp

mp.mp.dps = 25

SIG = mp.mpf('0.05')
S2 = SIG ** 2
SIEVE = 400000

WITNESS = {
    4: [-0.298, -0.641, -0.641, -0.298],
    5: [0.490, 0.510, 0.0, -0.510, -0.490],
    6: [-0.437, -0.521, -0.193, 0.193, 0.521, 0.437],
    7: [-0.397, -0.504, -0.296, 0.0, 0.296, 0.504, 0.397],
}
EPS = {4: F(12, 10000), 5: F(36, 10000), 6: F(8, 10000), 7: F(11, 10000)}
RECORDED = {4: 0.022709744, 5: 0.021423798, 6: 0.016707856, 7: 0.012437486}


def omega(t):
    return mp.re(mp.digamma(mp.mpf(1) / 4 + 1j * t / 2)) - mp.log(mp.pi)


def pole(c):
    return 4 * mp.pi * S2 * mp.exp(S2 / 4) * mp.cosh(c / 2)


def density(c):
    return 2 * S2 * mp.quad(lambda t: mp.exp(-(SIG * t) ** 2) * mp.cos(c * t) * omega(t), [0, 200])


def logns(n):
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


LOGN = logns(SIEVE)


def prime(c):
    return -2 * sum(a * mp.sqrt(mp.pi) * SIG * mp.exp(-(mp.log(n) - c) ** 2 / (4 * S2))
                    for n, a in LOGN)


def entry(c):
    return pole(c) + density(c) + (prime(c) + prime(-c)) / 2


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--check", action="store_true")
    a = ap.parse_args()
    bad = 0
    print(f"{'n':>2} {'lambda_min':>13} {'witness ray':>13} {'sum|x|':>9} "
          f"{'eps':>7} {'cert halfwidth':>15}")
    for n in (4, 5, 6, 7):
        G = np.array([[float(entry(mp.mpf(abs(i - j)) / 5)) for j in range(n)] for i in range(n)])
        x = np.array(WITNESS[n])
        x = x / np.linalg.norm(x)
        ray = float(x @ G @ x)
        l1 = np.abs(x).sum()
        hw = float(EPS[n]) * l1 ** 2
        print(f"{n:>2} {np.linalg.eigvalsh(G).min():>13.9f} {ray:>13.9f} {l1:>9.5f} "
              f"{float(EPS[n]):>7.4f} {hw:>15.3e}")
        if a.check and abs(ray - RECORDED[n]) > 1e-7:
            print(f"   MISMATCH: recorded {RECORDED[n]}, computed {ray}", file=sys.stderr)
            bad += 1
    if a.check:
        print("calibration OK" if bad == 0 else f"{bad} mismatches")
        sys.exit(1 if bad else 0)


if __name__ == "__main__":
    main()
