#!/usr/bin/env python3
"""AGENT B, round 1 — exact full-L sweep of the finite-word first-difference identity.

For each word (support, N) and every L in [1, N-1] this computes, from the
definition of record (offset tuples of windows):

    p(L)   = |F(L)|
    RS(L)  = #{ f in F(L) : f+0 in F(L+1) and f+1 in F(L+1) }   (right-special)
    Z(L)   = #{ f in F(L) : f has no right extension inside the word }
           = |F(L)| - |{ prefix(g) : g in F(L+1) }|
    LS(L)  = #{ f in F(L) : f has both left extensions }

and tests  p(L+1)-p(L) == RS(L) - Z(L)   and   p(L+1)-p(L) == RS(L) - LS(L+1).

The p values are cross-checked against digitword.p_offset / p_bruteforce and
the RS values against digitword.right_special_count in agentB_audit.py; this
script only makes the same enumeration cheap enough for a full N = 13000 sweep.
"""
from __future__ import annotations
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "code"))
from digitword import p_offset  # noqa: E402

WORDS = {
    "1overpi": ((2, 13, 607), 1400),
    "log2": ((0, 4, 36, 6069), 13000),
    "sqrt2m1": ((1, 11, 251), 2000),
    "geom": ((10, 20, 40, 80), 500),
    "true_e2": ((0, 3, 53), 2000),
}


def first_index(sup, N):
    fi = [0] * (N + 1)
    j = 0
    m = len(sup)
    for t in range(N + 1):
        while j < m and sup[j] < t:
            j += 1
        fi[t] = j
    return fi


def fset(sup, N, L, fi):
    out = set()
    m = len(sup)
    for t in range(N - L + 1):
        k = fi[t]
        end = t + L
        tup = []
        ap = tup.append
        while k < m and sup[k] < end:
            ap(sup[k] - t)
            k += 1
        out.add(tuple(tup))
    return out


def sweep(ones, N, label, samples=()):
    sup = list(ones)
    fi = first_index(sup, N)
    F = fset(sup, N, 1, fi)
    P = [0] * (N + 1)
    RS = [0] * (N + 1)
    Z = [0] * (N + 1)
    LS = [0] * (N + 1)
    bad_id = []
    bad_naive = bad_naive2 = 0
    prevP = None
    for L in range(1, N):
        Fn = fset(sup, N, L + 1, fi)
        pL = len(F)
        P[L] = pL
        d2 = 0
        for f in F:
            if f in Fn and (f + (L,)) in Fn:
                d2 += 1
        RS[L] = d2
        img = set()
        for g in Fn:
            img.add(g[:-1] if (g and g[-1] == L) else g)
        Z[L] = len(F) - len(img)
        ls = 0
        for f in F:
            sh = tuple(x + 1 for x in f)
            if sh in F and ((0,) + sh) in F:
                ls += 1
        LS[L] = ls
        if prevP is not None and pL - prevP != RS[L - 1] - Z[L - 1]:
            bad_id.append(L - 1)
        prevP = pL
        F = Fn
    P[N] = p_offset(ones, N, N)
    assert P[N] == 1
    for L in range(1, N):
        lhs = P[L + 1] - P[L]
        if lhs != RS[L] - LS[L]:
            bad_naive += 1
        if lhs != RS[L] - LS[L + 1]:
            bad_naive2 += 1
    n = N - 1
    print(f"=== {label}: ones={tuple(ones)} N={N} span={sup[-1]-sup[0]} "
          f"gaps={[b-a for a,b in zip(sup,sup[1:])]}")
    print(f"  L swept = {n} (1..{N-1});  p(L+1)-p(L)=RS(L)-Z(L): "
          f"agrees {n-len(bad_id)}/{n}, failures={bad_id[:8]}")
    print(f"  naive RS(L)-LS(L)   agrees {n-bad_naive}/{n}")
    print(f"  naive RS(L)-LS(L+1) agrees {n-bad_naive2}/{n}")
    mx = max(P[1:N + 1])
    idx = [L for L in range(1, N + 1) if P[L] == mx]
    print(f"  max p = {mx} on exactly L in [{idx[0]}, {idx[-1]}] ({len(idx)} values)")
    dec = [L for L in range(1, N) if P[L + 1] - P[L] == -1]
    if dec:
        ok = [L for L in range(dec[0], N + 1) if P[L] == N - L + 1]
        print(f"  slope -1 for L in [{dec[0]}, {dec[-1]}]; N-a_m={N-sup[-1]}; "
              f"p(L)=N-L+1 on {len(ok)}/{N-dec[0]+1} values of L in "
              f"[{dec[0]},{N}]")
    for L in samples:
        if 1 <= L < N:
            print(f"    L={L}: p={P[L]} RS={RS[L]} Z={Z[L]} LS={LS[L]} "
                  f"p(L+1)-p(L)={P[L+1]-P[L]}")
    return P, RS, Z, LS


if __name__ == "__main__":
    which = sys.argv[1]
    ones, N = WORDS[which]
    samples = (605, 791, 792, 793, 794, 799, 800, 900, 1000, 1200, 1390, 1397, 1399)
    if which != "1overpi":
        samples = ()
    sweep(ones, N, which, samples)
