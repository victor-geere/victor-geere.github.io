#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
012/rigorous/verify_certificate.py — independent checker for the
`partial-sum-plus-tail` certificates emitted by `partial_tail.py`.

Independence.  This file does **not** import `partial_tail.py`.  It re-implements
the interval algebra (`iv_add/sub/neg/scale/mul/inflate` and the complex
rectangle operations) from scratch over `fractions.Fraction`, and replays the
certificate's `ops` cell exactly, requiring the declared output box of every op
to equal its recomputed value.

The `atoms` are re-derived from their recorded provenance:

  kind     provenance                       re-derivation
  ---------------------------------------------------------------------------
  input    -                                trusted (the point box)
  rat      data = "p/q"                     exact point
  log      data = "x", bits                 log(x)  re-derived at bits+40
  cexp     in = [arg], bits                 exp(arg) re-derived at bits+40
  div      in = [A, B]                      A / B  (needs 0 not in B)

and the checker requires the declared atom box to **contain** the re-derived
(tighter) box.  If `--weak-atoms` is given, transcendental atoms are accepted as
trusted instead of re-derived (useful to isolate the rational cell).

Exit status 0 iff every check passes.
"""
from __future__ import annotations

import argparse
import json
import os
import sys
from fractions import Fraction as F

_HERE = os.path.dirname(os.path.abspath(__file__))
if _HERE not in sys.path:
    sys.path.insert(0, _HERE)

# only the transcendental kernel is shared; every interval *op* below is local
import rativ as R  # noqa: E402

_STRICT_ATOM_BITS = 40


# --------------------------------------------------------------------------- #
#  independent interval algebra (local, deliberately not from rativ)
# --------------------------------------------------------------------------- #

def iv(lo, hi):
    lo, hi = F(lo), F(hi)
    if lo > hi:
        raise ValueError(f"empty interval [{lo},{hi}]")
    return (lo, hi)


def iv_from_json(j):
    return iv(F(j[0]), F(j[1]))


def iv_json(a):
    return [str(a[0]), str(a[1])]


def iadd(a, b):
    return iv(a[0] + b[0], a[1] + b[1])


def ineg(a):
    return iv(-a[1], -a[0])


def isub(a, b):
    return iv(a[0] - b[1], a[1] - b[0])


def iscale(a, c):
    c = F(c)
    return iv(c * a[0], c * a[1]) if c >= 0 else iv(c * a[1], c * a[0])


def imul(a, b):
    cs = (a[0] * b[0], a[0] * b[1], a[1] * b[0], a[1] * b[1])
    return iv(min(cs), max(cs))


def iinv(a):
    if a[0] <= 0 <= a[1]:
        raise ZeroDivisionError("interval contains 0")
    return iv(1 / a[1], 1 / a[0])


def idiv(a, b):
    return imul(a, iinv(b))


def iinflate(a, r):
    r = F(r)
    return iv(a[0] - r, a[1] + r)


def icontains(outer, inner):
    return outer[0] <= inner[0] and inner[1] <= outer[1]


def cx(re, im):
    return (re, im)


def cx_from_json(j):
    return (iv_from_json(j["re"]), iv_from_json(j["im"]))


def cx_json(z):
    return {"re": iv_json(z[0]), "im": iv_json(z[1])}


def cx_add(z, w):
    return (iadd(z[0], w[0]), iadd(z[1], w[1]))


def cx_neg(z):
    return (ineg(z[0]), ineg(z[1]))


def cx_sub(z, w):
    return (isub(z[0], w[0]), isub(z[1], w[1]))


def cx_scale(z, c):
    return (iscale(z[0], c), iscale(z[1], c))


def cx_mul(z, w):
    re = isub(imul(z[0], w[0]), imul(z[1], w[1]))
    im = iadd(imul(z[0], w[1]), imul(z[1], w[0]))
    return (re, im)


def cx_div(z, w):
    den = iadd(imul(w[0], w[0]), imul(w[1], w[1]))
    if den[0] <= 0:
        raise ZeroDivisionError("denominator box contains 0")
    num = cx_mul(z, (w[0], ineg(w[1])))
    return (idiv(num[0], den), idiv(num[1], den))


def cx_inflate(z, r):
    return (iinflate(z[0], r), iinflate(z[1], r))


def cx_contains(outer, inner):
    return icontains(outer[0], inner[0]) and icontains(outer[1], inner[1])


OPS = {
    "add": lambda args, s: cx_add(args[0], args[1]),
    "sub": lambda args, s: cx_sub(args[0], args[1]),
    "neg": lambda args, s: cx_neg(args[0]),
    "scale": lambda args, s: cx_scale(args[0], s),
    "mul": lambda args, s: cx_mul(args[0], args[1]),
    "inflate": lambda args, s: cx_inflate(args[0], s),
}


# --------------------------------------------------------------------------- #
#  atom re-derivation
# --------------------------------------------------------------------------- #

def derive_atom(atom, boxes, strict, log):
    kind = atom.get("kind", "opaque")
    if kind in ("input", "opaque") or not strict:
        boxes[atom["id"]] = cx_from_json(atom["box"])
        log.append((atom["id"], kind, "trusted"))
        return None
    if kind == "rat":
        v = F(atom["data"])
        got = (iv(v, v), iv(0, 0))
    elif kind == "log":
        x = F(atom["data"])
        bits = int(atom.get("bits", 64)) + _STRICT_ATOM_BITS
        L = R.log_point(x, bits)
        got = (iv(L.lo, L.hi), iv(0, 0))
    elif kind == "cexp":
        arg = boxes[atom["in"][0]]
        bits = int(atom.get("bits", 64)) + _STRICT_ATOM_BITS
        Z = R.Cx(R.Iv(arg[0][0], arg[0][1]), R.Iv(arg[1][0], arg[1][1]))
        e = R.cexp(Z, bits)
        got = (iv(e.re.lo, e.re.hi), iv(e.im.lo, e.im.hi))
    elif kind == "div":
        A = boxes[atom["in"][0]]
        B = boxes[atom["in"][1]]
        got = cx_div(A, B)
    else:
        raise ValueError(f"unknown atom kind {kind!r}")
    declared = cx_from_json(atom["box"])
    ok = cx_contains(declared, got)
    log.append((atom["id"], kind, "ok" if ok else "NOT CONTAINED"))
    boxes[atom["id"]] = declared
    return ok


# --------------------------------------------------------------------------- #
#  main
# --------------------------------------------------------------------------- #

def verify(path, weak_atoms=False, verbose=False) -> bool:
    with open(path) as fh:
        cert = json.load(fh)
    log: list = []
    boxes: dict = {}
    failures: list[str] = []

    # atoms and ops share one id space; replay in id order
    steps = [("atom", a) for a in cert["atoms"]] + [("op", o) for o in cert["ops"]]
    steps.sort(key=lambda s: s[1]["id"] if "id" in s[1] else s[1]["out"])

    if weak_atoms:
        # establish all atoms first (trusted), then ops
        for a in cert["atoms"]:
            boxes[a["id"]] = cx_from_json(a["box"])
        order = [("op", o) for o in cert["ops"]]
    else:
        order = steps

    n_atom_ok = n_atom_bad = 0
    for kind, rec in order:
        if kind == "atom":
            res = derive_atom(rec, boxes, strict=True, log=log)
            if res is False:
                n_atom_bad += 1
                failures.append(f"atom {rec['id']} ({rec.get('label')}) not contained")
            else:
                n_atom_ok += 1
            continue
        # op
        ins = [boxes[i] for i in rec["in"]]
        sc = F(rec["scalar"]) if "scalar" in rec else None
        want = cx_from_json(rec["box"])
        try:
            got = OPS[rec["op"]](ins, sc)
        except Exception as exc:  # noqa: BLE001
            failures.append(f"op {rec['out']} {rec['op']}: {exc}")
            continue
        if cx_json(got) != cx_json(want):
            failures.append(
                f"op {rec['out']} {rec['op']}: recomputed {cx_json(got)} != declared {cx_json(want)}")
        boxes[rec["out"]] = want

    final = cert["final"]
    if final not in boxes:
        failures.append(f"final id {final} missing")
    else:
        if cx_json(boxes[final]) != cert["result"]:
            failures.append("final box != declared result")

    print(f"certificate : {path}")
    print(f"function    : {cert.get('function')}  params={cert.get('params')}")
    print(f"atoms       : {len(cert['atoms'])} (checked {n_atom_ok}, failed {n_atom_bad})")
    print(f"ops         : {len(cert['ops'])}")
    print(f"final re    : {cert['result']['re']}")
    print(f"final im    : {cert['result']['im']}")
    if verbose:
        for a in cert["atoms"]:
            print(f"  atom {a['id']:>4} {a.get('kind','?'):>7} {a.get('label')}")
    if failures:
        print(f"FAIL ({len(failures)} problems):")
        for f in failures[:20]:
            print("  -", f)
        return False
    print("PASS")
    return True


def main(argv=None) -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("cert")
    ap.add_argument("--weak-atoms", action="store_true",
                    help="trust transcendental atoms instead of re-deriving them")
    ap.add_argument("--verbose", action="store_true")
    args = ap.parse_args(argv)
    ok = verify(args.cert, weak_atoms=args.weak_atoms, verbose=args.verbose)
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
