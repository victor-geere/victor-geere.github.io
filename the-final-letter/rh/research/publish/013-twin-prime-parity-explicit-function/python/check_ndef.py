#!/usr/bin/env python3
"""010/rigorous/check_ndef.py — regression test for the `ndef` / `cdiv` soundness bug.

`eta_interval.ndef(x, y)` (and therefore `Cx` division, `cdiv`) used the interval-division
formula for a **nonnegative** numerator, `[x.lo/y.hi, x.hi/y.lo]`.  For `x < 0` the map
`y ↦ x/y` is increasing in `y`, so the true extremes are `x.lo/y.lo` and `x.hi/y.hi`; the
old formula under-covered by `|x|·Δy/y²`.  Since `cdiv` feeds the *signed* combination
`a.re*b.re + a.im*b.im` as numerator, every complex division was affected: a random test
found 1584/3000 containment failures before the fix and 0/3000 after.

    python3 check_ndef.py       # exit 0 iff all containments hold
"""
import random
import sys
import mpmath as mp

mp.mp.dps = 80
import ivmath as iv
import eta_interval as E

E.fast_mode()
random.seed(7)
fails = 0


def check(name, ok, detail=""):
    global fails
    print(("  PASS  " if ok else "  FAIL  ") + name + (("   " + detail) if detail else ""))
    if not ok:
        fails += 1


def rnd():
    return mp.mpf(random.uniform(-5, 5))


def rnde():
    return mp.mpf(random.uniform(0, 0.5))


print("010/rigorous/check_ndef.py — ndef / cdiv containment on signed numerators")

N = 3000
bad_ndef = 0
for _ in range(N):
    x = iv.Num(rnd(), rnde())
    yv = rnd()
    y = iv.Num(yv if yv > 1 else mp.mpf("1.2"), rnde())
    if y.lo <= 0:
        continue
    q = E.ndef(x, y)
    vals = [a / b for a in (x.lo, x.hi) for b in (y.lo, y.hi)]
    lo, hi = min(vals), max(vals)
    if not ((q.v - q.e) <= lo + mp.mpf("1e-60") and hi <= (q.v + q.e) + mp.mpf("1e-60")):
        bad_ndef += 1
check(f"ndef contains x/y at all four corners ({N} random signed numerators)",
      bad_ndef == 0, f"{bad_ndef} failures (pre-fix: ~1584/3000)")

bad_cdiv = 0
trials = 0
for _ in range(800):
    a = E.Cx(iv.Num(rnd(), rnde()), iv.Num(rnd(), rnde()))
    b = E.Cx(iv.Num(mp.mpf("1.5"), rnde()), iv.Num(mp.mpf("0.7"), rnde()))
    if (b.re * b.re + b.im * b.im).lo <= 0:
        continue
    qc = E.cdiv(a, b)
    trials += 1
    for _ in range(60):
        ar = a.re.v + a.re.e * random.uniform(-1, 1)
        ai = a.im.v + a.im.e * random.uniform(-1, 1)
        br = b.re.v + b.re.e * random.uniform(-1, 1)
        bi = b.im.v + b.im.e * random.uniform(-1, 1)
        z = mp.mpc(ar, ai) / mp.mpc(br, bi)
        if not (qc.re.contains(z.real) and qc.im.contains(z.imag)):
            bad_cdiv += 1
            break
check(f"cdiv contains a/b on sampled rectangle points ({trials} divisions)",
      bad_cdiv == 0, f"{bad_cdiv} divisions with an uncovered point")

print(("\n0 fail(s)" if not fails else f"\n{fails} FAILURE(S)"))
sys.exit(1 if fails else 0)
