#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
012/rigorous/partial_tail.py — a partial-sum-plus-tail evaluator for
`zeta(s)`, `zeta(s,a)` and Dirichlet `L(s, chi)`, with an exact-rational
certificate.

    zeta(s)         = SUM_{k<M} (a+k)^{-s}                      (partial sum)
                    + b^{1-s}/(s-1) + b^{-s}/2
                    + SUM_{j=1..K} B_{2j}/(2j)! (s)_{2j-1} b^{-s-2j+1}
                    + R_K(s)                                     (tail)
    |R_K| <= |(s)_{2K+1}| * 2 zeta(2K+1) / (2 pi)^{2K+1} * b^{-sigma-2K}/(sigma+2K)

with `a > 0`, `b = a + M`, `(s)_n = s(s+1)...(s+n-1)` the rising factorial and
`B_{2j}` the Bernoulli numbers.  Every enclosure is exact-rational
(`fractions.Fraction`), including the transcendental factors (see `rativ.py`).

The evaluator records every complex operation it performs into a *certificate*:

  * `atoms` — trusted leaves (inputs `s`, rational constants, and the
    transcendental enclosures `log`, `exp`, `sin`, `cos`, `pi`, plus `div`);
  * `ops`   — the checkable cell: `add`, `sub`, `neg`, `scale`, `mul`,
    `inflate`, each declared with its output box.

The `ops` cell is replayed by an independent checker
(`verify_certificate.py`) and kernel-checked in Lean (`../lean/Replay.lean`).

CLI:
    python3 partial_tail.py zeta    --re 2 --im 0 --M 20 --K 8
    python3 partial_tail.py L       --chi 0,1,-1 --re 2 --im 0 --M 20 --K 8
    python3 partial_tail.py cert    --kind L --chi 0,1,-1 --re 2 --im 0 --out c.json
"""
from __future__ import annotations

import argparse
import json
import os
import sys
from fractions import Fraction as F
from math import factorial as _ifact

_HERE = os.path.dirname(os.path.abspath(__file__))
if _HERE not in sys.path:
    sys.path.insert(0, _HERE)

import rativ as R                                   # noqa: E402
from rativ import Iv, Cx, Cx_real, log_point, exp_point, pi_iv, cexp, q  # noqa: E402

DEFAULT_BITS = 64


# --------------------------------------------------------------------------- #
#  Bernoulli numbers (exact) and factorials
# --------------------------------------------------------------------------- #

_BERN: list[F] = [F(1)]


def bernoulli(n: int) -> F:
    """B_n with the standard convention B_1 = -1/2 (only even n are used)."""
    while len(_BERN) <= n:
        m = len(_BERN)
        s = F(0)
        for k in range(m):
            s += _binom(m + 1, k) * _BERN[k]
        _BERN.append(-s / (m + 1))
    return _BERN[n]


def _binom(n: int, k: int) -> int:
    from math import comb
    return comb(n, k)


# --------------------------------------------------------------------------- #
#  the certificate recorder
# --------------------------------------------------------------------------- #

def _box_json(b: Cx) -> dict:
    return {"re": [str(b.re.lo), str(b.re.hi)], "im": [str(b.im.lo), str(b.im.hi)]}


class Node:
    __slots__ = ("box", "id")

    def __init__(self, box: Cx, nid: int):
        self.box = box
        self.id = nid


class Recorder:
    """Records the `ops` cell (Lean-checkable) and the trusted `atoms`."""

    def __init__(self):
        self.atoms: list[dict] = []
        self.ops: list[dict] = []
        self._next = 0

    def _id(self) -> int:
        i = self._next
        self._next += 1
        return i

    def atom(self, label: str, box: Cx, kind: str = "opaque",
             ins: tuple = (), data=None, bits: int | None = None) -> Node:
        i = self._id()
        rec = {"id": i, "label": label, "kind": kind, "box": _box_json(box)}
        if ins:
            rec["in"] = [x.id for x in ins]
        if data is not None:
            rec["data"] = data
        if bits is not None:
            rec["bits"] = bits
        self.atoms.append(rec)
        return Node(box, i)

    def op(self, name: str, out: Cx, ins: list[Node], scalar: F | None = None) -> Node:
        i = self._id()
        rec = {"op": name, "out": i, "box": _box_json(out),
               "in": [x.id for x in ins]}
        if scalar is not None:
            rec["scalar"] = str(scalar)
        self.ops.append(rec)
        return Node(out, i)


class Builder:
    """Thin wrapper: every complex operation is recorded."""

    def __init__(self):
        self.rec = Recorder()

    # -- trusted leaves (with provenance for independent re-derivation) ----- #
    def atom(self, label: str, box: Cx, **kw) -> Node:
        return self.rec.atom(label, box, **kw)

    def input_atom(self, label: str, box: Cx) -> Node:
        return self.atom(label, box, kind="input")

    def rat(self, v) -> Node:
        v = q(v)
        return self.atom(f"rat({v})", Cx_real(v), kind="rat", data=str(v))

    def log_atom(self, x, bits: int) -> Node:
        x = q(x)
        L = log_point(x, bits)
        return self.atom(f"log({x})", Cx(L, Iv.pt(0)),
                         kind="log", data=str(x), bits=bits)

    def cexp_atom(self, Z: Node, bits: int, label: str) -> Node:
        return self.atom(label, cexp(Z.box, bits), kind="cexp", ins=(Z,), bits=bits)

    def div_atom(self, A: Node, B: Node, label: str) -> Node:
        return self.atom(label, A.box.div(B.box), kind="div", ins=(A, B))

    # -- checkable ops ----------------------------------------------------- #
    def add(self, A: Node, B: Node) -> Node:
        return self.rec.op("add", A.box.add(B.box), [A, B])

    def sub(self, A: Node, B: Node) -> Node:
        return self.rec.op("sub", A.box.sub(B.box), [A, B])

    def neg(self, A: Node) -> Node:
        return self.rec.op("neg", A.box.neg(), [A])

    def scale(self, A: Node, c) -> Node:
        c = q(c)
        return self.rec.op("scale", A.box.scale(c), [A], scalar=c)

    def mul(self, A: Node, B: Node) -> Node:
        return self.rec.op("mul", A.box.mul(B.box), [A, B])

    def inflate(self, A: Node, r) -> Node:
        r = q(r)
        return self.rec.op("inflate", A.box.inflate(r), [A], scalar=r)

    def sum_nodes(self, nodes: list[Node]) -> Node:
        acc = self.rat(0)
        for n in nodes:
            acc = self.add(acc, n)
        return acc


# --------------------------------------------------------------------------- #
#  the Euler-Maclaurin tail bound
# --------------------------------------------------------------------------- #

def tail_radius(s_re: Iv, s_im: Iv, a: F, M: int, K: int, bits: int) -> F:
    """Explicit rational upper bound for |R_K| (see module docstring)."""
    if K < 1:
        raise ValueError("tail_radius: need K >= 1")
    b = a + M
    Lb = log_point(b, bits)
    sigma_lo = s_re.lo
    if sigma_lo <= 0:
        raise ValueError("tail_radius: need Re s > 0")
    absre = max(abs(s_re.lo), abs(s_re.hi))
    absim = max(abs(s_im.lo), abs(s_im.hi))
    # |(s)_{2K+1}| <= prod_{i=0}^{2K} (|Re s| + i + |Im s|)   (triangle ineq.)
    nr = F(1)
    for i in range(2 * K + 1):
        nr *= (absre + i + absim)
    zeta_ub = 1 + F(1, 2 * K)                      # zeta(m) <= 1 + 1/(m-1)
    denom = (pi_iv(bits).scale(2)).lo ** (2 * K + 1)   # ((2pi)^(2K+1)) lower bd
    exp_ub = exp_point(-(sigma_lo + 2 * K) * Lb.hi, bits).hi  # b^{-sigma-2K}
    return nr * 2 * zeta_ub / denom * exp_ub / (sigma_lo + 2 * K)


# --------------------------------------------------------------------------- #
#  Hurwitz zeta and Dirichlet L
# --------------------------------------------------------------------------- #

def hurwitz_zeta(B: Builder, a: F, S: Node, M: int, K: int, bits: int) -> Node:
    """EM evaluator for zeta(s, a), a > 0."""
    a = q(a)
    if a <= 0:
        raise ValueError("hurwitz_zeta: a must be positive")
    parts: list[Node] = []
    for k in range(M):
        Lk = B.log_atom(a + k, bits)
        arg = B.mul(B.neg(S), Lk)
        parts.append(B.cexp_atom(arg, bits, f"({a}+{k})^(-s)"))
    b = a + M
    Lb = B.log_atom(b, bits)
    one = B.rat(1)
    # + b^(1-s)/(s-1)
    num = B.cexp_atom(B.mul(B.sub(one, S), Lb), bits, f"{b}^(1-s)")
    den = B.sub(S, one)
    parts.append(B.div_atom(num, den, f"{b}^(1-s)/(s-1)"))
    # + (1/2) b^(-s)
    parts.append(B.scale(B.cexp_atom(B.mul(B.neg(S), Lb), bits, f"{b}^(-s)"), F(1, 2)))
    # + sum_j B_{2j}/(2j)! (s)_{2j-1} b^(-s-2j+1)
    for j in range(1, K + 1):
        coef = bernoulli(2 * j) / _ifact(2 * j)
        rising = B.rat(1)
        for i in range(2 * j - 1):
            rising = B.mul(rising, B.add(S, B.rat(i)))
        arg = B.mul(B.neg(B.add(S, B.rat(2 * j - 1))), Lb)
        term = B.mul(B.cexp_atom(arg, bits, f"{b}^(-s-{2*j-1})"), rising)
        parts.append(B.scale(term, coef))
    head = B.sum_nodes(parts)
    r = tail_radius(S.box.re, S.box.im, a, M, K, bits)
    return B.inflate(head, r)


def dirichlet_L(B: Builder, chi: list[int], S: Node, M: int, K: int, bits: int) -> Node:
    """L(s, chi) = N^{-s} sum_{a=1}^{N-1} chi(a) zeta(s, a/N)."""
    N = len(chi)
    if N < 2 or chi[0] != 0:
        raise ValueError("dirichlet_L: chi must have length >= 2 and chi[0] = 0")
    terms = []
    for a in range(1, N):
        if chi[a] == 0:
            continue
        z = hurwitz_zeta(B, F(a, N), S, M, K, bits)
        terms.append(B.scale(z, F(chi[a])))
    tot = B.sum_nodes(terms) if terms else B.rat(0)
    LN = B.log_atom(N, bits)
    Ns = B.cexp_atom(B.mul(B.neg(S), LN), bits, f"{N}^(-s)")
    return B.mul(Ns, tot)


# --------------------------------------------------------------------------- #
#  driver
# --------------------------------------------------------------------------- #

def evaluate(kind: str, re_lo, re_hi, im_lo, im_hi, M: int, K: int, bits: int,
             chi: list[int] | None = None, a: F = F(1)) -> tuple[Builder, Node]:
    B = Builder()
    S = B.input_atom("s", Cx(Iv(q(re_lo), q(re_hi)), Iv(q(im_lo), q(im_hi))))
    if kind == "zeta":
        out = hurwitz_zeta(B, a, S, M, K, bits)
    elif kind == "L":
        out = dirichlet_L(B, chi, S, M, K, bits)
    else:
        raise ValueError(f"unknown kind {kind!r}")
    return B, out


def certificate(B: Builder, out: Node, kind: str, params: dict) -> dict:
    return {
        "kind": "partial-sum-plus-tail/em",
        "version": 1,
        "evaluator": "012/rigorous/partial_tail.py",
        "function": kind,
        "params": params,
        "atoms": B.rec.atoms,
        "ops": B.rec.ops,
        "final": out.id,
        "result": _box_json(out.box),
    }


def _fmt(iv: Iv, digits: int = 30) -> str:
    import mpmath as mp
    mp.mp.dps = digits + 10
    lo = mp.mpf(iv.lo.numerator) / iv.lo.denominator
    hi = mp.mpf(iv.hi.numerator) / iv.hi.denominator
    return f"[{mp.nstr(lo, digits)}, {mp.nstr(hi, digits)}]"


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("kind", choices=["zeta", "L", "cert"])
    ap.add_argument("--re", default="2")
    ap.add_argument("--im", default="0")
    ap.add_argument("--a", default="1")
    ap.add_argument("--chi", default="0,1,-1")
    ap.add_argument("--M", type=int, default=20)
    ap.add_argument("--K", type=int, default=8)
    ap.add_argument("--bits", type=int, default=DEFAULT_BITS)
    ap.add_argument("--out", default=None)
    args = ap.parse_args(argv)

    re_lo = re_hi = q(args.re)
    im_lo = im_hi = q(args.im)
    chi = [int(s) for s in args.chi.split(",")]
    kind = "L" if args.kind in ("L", "cert") else "zeta"
    if args.kind == "cert":
        kind = "L" if args.chi else "zeta"

    B, out = evaluate(kind, re_lo, re_hi, im_lo, im_hi, args.M, args.K, args.bits,
                      chi=chi, a=q(args.a))
    print(f"{kind}({args.re} + {args.im}i)  M={args.M} K={args.K} bits={args.bits}")
    print(f"  re = {_fmt(out.box.re)}")
    print(f"  im = {_fmt(out.box.im)}")
    print(f"  atoms={len(B.rec.atoms)} ops={len(B.rec.ops)}")
    if args.out:
        cert = certificate(B, out, kind,
                           {"re_lo": str(re_lo), "re_hi": str(re_hi),
                            "im_lo": str(im_lo), "im_hi": str(im_hi),
                            "M": args.M, "K": args.K, "bits": args.bits,
                            "chi": chi, "a": str(q(args.a))})
        with open(args.out, "w") as fh:
            json.dump(cert, fh, indent=1)
        print(f"  certificate -> {args.out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
