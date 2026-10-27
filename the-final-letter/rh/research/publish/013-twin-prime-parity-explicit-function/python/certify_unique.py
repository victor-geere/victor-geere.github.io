#!/usr/bin/env python3
"""rh45/rigorous/certify_unique.py — Theorem A certificates: unique simple on-line zeros.

Usage:  python3 certify_unique.py [nzeros]        (default 5)

For each of the first `nzeros` zeros of zeta a bracket of width 1e-3 (or narrower) is
exhibited with *enclosed* Z(a) < 0 < Z(b) (or the mirror) and an *enclosed one-signed*
Z' on the bracket.  Together with the machine-checked Lean theorem

    Rh45Routes.exists_unique_root_of_sign_change   (and the _neg mirror)

this proves that the bracket contains exactly one zero of zeta, that it is simple, and
that it lies on the critical line.

The Euler-accelerated eta enclosure needs K ~ 0.25 t for a usable (not merely valid)
enclosure, and the *derivative* enclosure Z' needs more; the K ladder below is tried in
order and the first K that yields a certificate is used.  gamma_1..gamma_5 succeed at the
historical K = 90, so their output is unchanged.
"""
import sys
import time, sys
import mpmath as mp
from fractions import Fraction
import eta_interval as E

mp.mp.dps = 60
NZEROS = int(sys.argv[1]) if len(sys.argv) > 1 else 5
K_LADDER = (90, 100, 140, 180, 220, 260, 320)
GAM = [mp.im(mp.zetazero(k)) for k in range(1, NZEROS + 1)]


def certify(t0):
    """First (K, certificate) in the ladder that succeeds."""
    for K in K_LADDER:
        cert = E.unique_simple_certificate(t0, K=K)
        if cert is not None:
            return K, cert
    return None, None


print("Theorem A certificates: Z(a)<0<Z(b) and Z' one-signed on [a,b]"
      "  (=> unique simple on-line zero)")
fails = 0
for k, g in enumerate(GAM, 1):
    t0 = Fraction(mp.nstr(g, 45))
    t = time.time()
    K, cert = certify(t0)
    if cert is None:
        print("  gamma_%d (t=%.4f): NO CERTIFICATE in K ladder %s" % (k, float(g), K_LADDER))
        fails += 1
        continue
    a, b, Za, Zb, Zpb = cert
    print("  gamma_%d (t=%.4f): K=%d | width %.1e | Z(a) in [%s,%s] | Z(b) in [%s,%s] | Z' in [%s,%s]  (%.0fs)"
          % (k, float(g), K, float(b - a), mp.nstr(Za.lo, 6), mp.nstr(Za.hi, 6),
             mp.nstr(Zb.lo, 6), mp.nstr(Zb.hi, 6), mp.nstr(Zpb.lo, 6), mp.nstr(Zpb.hi, 6),
             time.time() - t), file=sys.stderr)
print("certificates:", len(GAM) - fails, "/", len(GAM))
sys.exit(1 if fails else 0)
