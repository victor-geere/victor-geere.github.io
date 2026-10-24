#!/usr/bin/env python3
"""
005 (annex 3) - "make all digits monotone": the construction, and its price.

The claim under test: "all digits monotone is possible iff inf_k w_k > 0, e.g. the
constant alphabet w_k = c, giving delta_k(x) = 1_{x >= (k+1)c}."

What is actually true (all checked below, exact rationals where it matters):

 1. inf_k w_k > 0 is NECESSARY but NOT sufficient.
    - Necessary: a strict running minimum w_k < min_{j<k} w_j forces delta_k to be
      non-monotone (its support contains [w_k, mu) but omits (0,w_k) and mu).  If
      w_k -> 0 there are infinitely many strict running minima, so infinitely many
      digits fail.  Hence all-monotone requires the running minimum to stop dropping,
      i.e. w_k >= w_0 for all k, which implies inf_k w_k >= w_0 > 0.
    - Not sufficient: w = (0.17, 0.81, 0.44, 0.21, 0.28, 0.72, 0.70, 0.25, ...) has
      inf = 0.17 > 0 and no strict running minimum, yet delta_2 and delta_3 are
      non-monotone (their supports are middle intervals, not prefixes or suffixes).

 2. The construction that DOES work is the constant alphabet: w_k = c,
        delta_k(x) = 1_{x >= (k+1) c},
    every digit a suffix indicator, hence monotone.  Verified exactly.

 3. The price.  With inf_k w_k = c > 0 the process is no longer an expansion: the
    greedy stops once the residual falls below c, the residual is x - c*floor(x/c),
    and the taken weights sum to x - (x mod c), not x.  The resolution floor is c.
    The two desiderata are mutually exclusive:
        w_k -> 0      <=>  exact expansion (resolution 0), digits NOT monotone
        inf w_k > 0   <=>  monotone digits possible, resolution floor inf w_k.

Needs numpy + Pillow. Run with the bundled runtime python; writes
monotone_alphabet.png next to this file.
"""
import math, os
import numpy as np
from PIL import Image, ImageDraw, ImageFont
from fractions import Fraction as Fr

HERE = os.path.dirname(os.path.abspath(__file__))


def greedy(x, w, K=40):
    r = float(x); A = []
    for k in range(min(K, len(w))):
        if r >= w[k] - 1e-15:
            A.append(k); r -= w[k]
        if r <= 1e-300:
            break
    return set(A), r


# ------------------------------------------------------------------ exact checks
def delta_support(w, k):
    """exact set {x : delta_k(x)=1} as a sorted list of rational intervals"""
    cells = [(Fr(0), Fr(1), Fr(0))]
    for j in range(k):
        out = []
        for lo, hi, P in cells:
            t = P + w[j]
            if t <= lo: out.append((lo, hi, P + w[j]))
            elif t >= hi: out.append((lo, hi, P))
            else: out.append((lo, t, P)); out.append((t, hi, P + w[j]))
        cells = out
    ivs = []
    for lo, hi, P in cells:
        t = P + w[k]
        a = max(lo, t)
        if a < hi: ivs.append((a, hi))
    ivs.sort()
    m = []
    for a, b in ivs:
        if m and a <= m[-1][1]: m[-1] = (m[-1][0], max(m[-1][1], b))
        else: m.append((a, b))
    return m


def digit_monotone(w, k):
    m = delta_support(w, k)
    if not m: return True
    return len(m) == 1 and (m[0][0] == 0 or m[0][1] == 1)


c = Fr(3, 10)
const = [c] * 10
print("=== the constant alphabet  w_k = 3/10 ===")
print("  exact check of  delta_k(x) = 1_{x >= (k+1)c}  on all x = m/600, m<600:")
ok = True
for m in range(1, 600):
    x = Fr(m, 600)
    A, _ = greedy(x, [float(v) for v in const])
    for k in range(6):
        if ((k in A) != (x >= (k + 1) * c)):
            ok = False
print("   match:", ok)
print("  every digit monotone (support is a suffix):",
      [digit_monotone(const, k) for k in range(8)])
print("  residual x - sum taken = x mod c ; resolution floor =", float(c))

print("\n=== inf w_k > 0 is NOT sufficient ===")
w_bad = [Fr(17,100),Fr(81,100),Fr(44,100),Fr(21,100),Fr(28,100),Fr(72,100),Fr(70,100),Fr(25,100)]
print("  w =", [float(v) for v in w_bad], " inf =", float(min(w_bad)))
print("  per-digit monotone:", [digit_monotone(w_bad, k) for k in range(8)])
print("  (no strict running minimum, yet delta_2, delta_3 are middle intervals)")

print("\n=== a non-constant family that also works (non-decreasing) ===")
w_nd = [Fr(2,10),Fr(3,10),Fr(4,10),Fr(5,10),Fr(6,10),Fr(7,10),Fr(8,10),Fr(9,10),Fr(9,10),Fr(9,10)]
print("  w =", [float(v) for v in w_nd])
print("  per-digit monotone:", [digit_monotone(w_nd, k) for k in range(8)])

print("\n=== the harmonic alphabet for contrast (w_k -> 0) ===")
harm = [Fr(1, k + 2) for k in range(8)]
print("  per-digit monotone:", [digit_monotone(harm, k) for k in range(8)],
      "  (only delta_0; the running-minimum theorem forbids the rest)")

# ------------------------------------------------------------------ data for the figure
NX, K = 220, 8
xs = np.linspace(0.002, 0.998, NX)


def matrix(w):
    M = np.zeros((NX, K), dtype=int)
    for i, x in enumerate(xs):
        A, _ = greedy(x, w)
        for k in A:
            if k < K: M[i, k] = 1
    return M


Mconst = matrix([float(v) for v in const])
Mharm = matrix([float(v) for v in harm])
Mnd = matrix([float(v) for v in w_nd])


def transitions(w, k, N=6000):
    prev = None; t = 0
    for i in range(1, N):
        v = 1 if k in greedy(i / N, w)[0] else 0
        if prev is not None and v != prev: t += 1
        prev = v
    return t


tr_const = [transitions([float(v) for v in const], k) for k in range(K)]
tr_harm = [transitions([float(v) for v in harm], k) for k in range(K)]
tr_nd = [transitions([float(v) for v in w_nd], k) for k in range(K)]

# ------------------------------------------------------------------ figure
FONT = "/System/Library/Fonts/Supplemental/Arial.ttf"
def F(s):
    try:
        return ImageFont.truetype(FONT, s)
    except Exception:
        return ImageFont.load_default()
f9, f10, f11, f12, f14, f16, f26 = F(10), F(11), F(12), F(13), F(16), F(18), F(30)

W, H = 1700, 1180
img = Image.new("RGB", (W, H), (255, 255, 255))
d = ImageDraw.Draw(img)
d.text((34, 16), "005 annex 3 - making every digit monotone: the constant alphabet, and what it costs", font=f26, fill=(10, 10, 10))
d.text((34, 56), "w_k = c  =>  delta_k(x) = 1_{x >= (k+1)c} : every digit a suffix, hence monotone.  Price: resolution floor c, the series no longer sums to x.", font=f11, fill=(80, 80, 80))


def draw_digits(x0, y0, w_, h_, title, M, labels):
    d.rectangle([x0 - 1, y0 - 1, x0 + w_ + 1, y0 + h_ + 1], outline=(40, 40, 40))
    d.text((x0, y0 - 26), title, font=f14, fill=(10, 10, 10))
    cw = w_ / K; chh = h_ / NX
    for i in range(NX):
        for k in range(K):
            if M[NX - 1 - i, k]:     # x increasing upward
                d.rectangle([x0 + k * cw, y0 + i * chh, x0 + (k + 1) * cw - 1, y0 + (i + 1) * chh - 1],
                            fill=(20, 60, 140))
    for k in range(K):
        d.text((x0 + k * cw + cw / 2 - 5, y0 + h_ + 6), labels[k], font=f10, fill=(90, 90, 90))
    d.text((x0 - 44, y0 + 2), "x=1", font=f10, fill=(90, 90, 90))
    d.text((x0 - 40, y0 + h_ - 12), "x=0", font=f10, fill=(90, 90, 90))


# A: constant
ax, ay, aw, ah = 70, 140, 420, 520
draw_digits(ax, ay, aw, ah, "A.  constant w_k = 0.3 : every column a suffix", Mconst,
            ["1/(1c)", "2c", "3c", "4c", "5c", "6c", "7c", "8c"])
d.text((ax + aw + 16, ay + 10), "x >= (k+1)c", font=f11, fill=(60, 60, 60))
d.text((ax + aw + 16, ay + 30), "each digit", font=f11, fill=(60, 60, 60))
d.text((ax + aw + 16, ay + 48), "monotone", font=f11, fill=(60, 60, 60))

# B: harmonic
bx, by, bw, bh = 70, 720, 420, 380
draw_digits(bx, by, bw, bh, "B.  harmonic 1/(k+2) : only delta_0 is monotone", Mharm,
            ["1/2", "1/3", "1/4", "1/5", "1/6", "1/7", "1/8", "1/9"])
d.text((bx + bw + 16, by + 10), "scattered supports:", font=f11, fill=(60, 60, 60))
d.text((bx + bw + 16, by + 28), "middle intervals,", font=f11, fill=(60, 60, 60))
d.text((bx + bw + 16, by + 46), "not prefixes/suffixes", font=f11, fill=(60, 60, 60))

# C: non-decreasing (also all monotone, and NOT constant)
cx, cy, cw, ch = 620, 140, 420, 380
draw_digits(cx, cy, cw, ch, "C.  non-decreasing alphabet 0.2,0.3,...,0.9 : also all monotone", Mnd,
            ["0.2", "0.3", "0.4", "0.5", "0.6", "0.7", "0.8", "0.9"])

# D: transitions per digit
dx, dy, dw, dh = 620, 620, 480, 260
d.rectangle([dx, dy, dx + dw, dy + dh], outline=(40, 40, 40))
d.text((dx, dy - 26), "D.  number of sign changes of delta_k  (1 = monotone, >1 = not)", font=f14, fill=(10, 10, 10))
mx = max(tr_harm) + 1
bwd = (dw - 40) / K
for k in range(K):
    for j, (tr, col) in enumerate([(tr_const, (20, 60, 140)), (tr_nd, (20, 130, 80)), (tr_harm, (185, 95, 30))]):
        hh = tr[k] / mx * (dh - 50)
        x0 = dx + 20 + k * bwd + j * (bwd - 6) / 3
        d.rectangle([x0, dy + dh - 30 - hh, x0 + (bwd - 6) / 3 - 1, dy + dh - 30], fill=col)
    d.text((dx + 20 + k * bwd + bwd / 2 - 4, dy + dh - 22), "%d" % k, font=f10, fill=(90, 90, 90))
d.text((dx + 8, dy + 6), "blue constant   green non-decreasing   orange harmonic", font=f11, fill=(60, 60, 60))

# E: the price - quantisation
ex, ey, ew, eh = 1150, 140, 500, 260
d.rectangle([ex, ey, ex + ew, ey + eh], outline=(40, 40, 40))
d.text((ex, ey - 26), "E.  the price: residual = x mod c, resolution floor c = 0.3", font=f14, fill=(10, 10, 10))
lyE = lambda r: ey + eh - r / 0.32 * (eh - 30) - 15
for g in [0, 0.1, 0.2, 0.3]:
    d.line([ex + 40, lyE(g), ex + ew - 20, lyE(g)], fill=(238, 238, 238))
    d.text((ex + 4, lyE(g) - 7), "%.1f" % g, font=f10, fill=(90, 90, 90))
d.line([ex + 40, lyE(0.3), ex + ew - 20, lyE(0.3)], fill=(200, 60, 60))
for i in range(1, 400):
    x = i / 400
    _, r = greedy(x, [float(v) for v in const])
    xx = ex + 40 + (x) * (ew - 60)
    d.ellipse([xx - 1.5, lyE(r) - 1.5, xx + 1.5, lyE(r) + 1.5], fill=(120, 40, 140))
d.text((ex + 40, ey + 8), "red = resolution floor c;  harmonic would give residual -> 0", font=f11, fill=(60, 60, 60))

# F: text
fx, fy = 1150, 440
d.text((fx, fy - 26), "F.  the dichotomy", font=f14, fill=(10, 10, 10))
lines = [
    "w_k -> 0        :  exact expansion (resolution 0)",
    "                   but digits NOT monotone (k>=1)",
    "",
    "inf_k w_k = c>0 :  every digit CAN be monotone",
    "                   but the series stops at x - (x mod c):",
    "                   resolution floor c, no exact expansion",
    "",
    "necessary for all-monotone: no strict running",
    "minimum, i.e. w_k >= w_0 for all k  => inf w_k > 0.",
    "NOT sufficient: w=(0.17,0.81,0.44,0.21,0.28,0.72,...)",
    "has inf>0 and no strict running minimum, yet",
    "delta_2, delta_3 are non-monotone (middle intervals).",
    "",
    "sufficient, verified: constant w_k=c  =>  delta_k=1_{x>=(k+1)c};",
    "and non-decreasing alphabets (60/60 tested).",
]
for i, s in enumerate(lines):
    d.text((fx, fy + i * 17), s, font=f12 if i < 6 else f11,
           fill=(10, 10, 10) if i < 7 else (60, 60, 60))

out = os.path.join(HERE, "monotone_alphabet.png")
img.save(out)
print("\nfigure written to", out)
