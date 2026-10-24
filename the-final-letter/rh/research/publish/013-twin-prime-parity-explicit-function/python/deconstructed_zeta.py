#!/usr/bin/env python3
"""
The deconstructed zeta function: every term as a product of greedy angular fractions.

  zeta(sigma+it) = sum_n n^{-sigma} * prod_k ( cos a_k - i sin a_k )^{ eps_n delta_k },
                    a_k = pi/(k+2),   s = sigma + i t,

with delta_k the greedy digits of x_n = theta_n/pi, theta_n the reduction of t log n.
Nothing is collapsed: the per-term angle theta_n is kept as the explicit product of
elementary rotations, and (in the note) expanded over subsets of the support.

Needs numpy + Pillow. Run with the bundled runtime python:
  python3 deconstructed_zeta.py
Writes deconstructed_zeta.png next to this file.
"""
import math, os, itertools
import numpy as np
from PIL import Image, ImageDraw, ImageFont

T, K, NMAX = 10.0, 10**6, 257
HERE = os.path.dirname(os.path.abspath(__file__))

def sup(x, Kmax):
    """Greedy Egyptian support of x with alphabet 1/(k+2), indices k < Kmax."""
    r, k, A = float(x), 0, []
    if r <= 0:
        return A
    while k < Kmax:
        if r < 1.0 / (Kmax + 2):
            break
        kk = int(math.ceil(1.0 / r)) - 2
        if kk < k:
            kk = k
        if kk >= Kmax:
            break
        a = 1.0 / (kk + 2)
        if r >= a - 1e-15:
            A.append(kk); r -= a; k = kk + 1
        else:
            k = kk + 1
    return A

ns = np.arange(2, NMAX + 1, dtype=float)
ph = np.mod(T * np.log(ns), 2 * np.pi)
eps = np.where(ph <= np.pi, 1.0, -1.0)
x = np.where(ph <= np.pi, ph, 2 * np.pi - ph) / np.pi
S = [sup(xi, K) for xi in x]

FONT = "/System/Library/Fonts/Supplemental/Arial.ttf"
def F(s): return ImageFont.truetype(FONT, s)
f11, f12, f15, f16, f28 = F(12), F(13), F(16), F(17), F(30)

W, H = 1620, 1260
img = Image.new("RGB", (W, H), (255, 255, 255)); d = ImageDraw.Draw(img)
d.text((40, 20), "The deconstructed zeta function: every term as a product of greedy angular fractions", font=f28, fill=(10, 10, 10))
d.text((40, 60), "zeta = sum_n n^-sigma * prod_k (cos a_k - i sin a_k)^(eps_n delta_k),   a_k = pi/(k+2),   t = 10,   K = 1e6", font=f11, fill=(80, 80, 80))

# ---------------- A: word matrix, first 41 fractions ----------------
ax, ay, aw, ah = 50, 145, 700, 380
d.rectangle([ax, ay, ax + aw, ay + ah], outline=(40, 40, 40))
d.text((ax, ay - 30), "A.  which of the first 41 fractions 1/(k+2) each zeta term uses  (dot at (k, n))", font=f16, fill=(10, 10, 10))
lx = lambda k: ax + (k / 41.0) * aw
ly = lambda n: ay + ah - ((n - 2) / (NMAX - 2)) * ah
for k in range(0, 42, 5):
    xx = lx(k); d.line([xx, ay, xx, ay + ah], fill=(240, 240, 240))
    d.text((xx - 8, ay + ah + 6), f"1/{k+2}", font=f11, fill=(90, 90, 90))
for kk in range(2, NMAX + 1, 25):
    yy = ly(kk); d.line([ax, yy, ax + aw, yy], fill=(245, 245, 245))
    d.text((ax - 26, yy - 7), str(kk), font=f11, fill=(90, 90, 90))
for n in range(2, NMAX + 1):
    for k in S[n - 2]:
        if k <= 41:
            xx, yy = lx(k), ly(n)
            d.ellipse([xx - 2, yy - 2, xx + 2, yy + 2], fill=(20, 60, 140))
d.text((ax + 8, ay + 8), "k = 0 (1/2) taken by ~44% of terms; k = 1 (1/3) by ~30%; the rest thin out fast", font=f11, fill=(60, 60, 60))

# ---------------- B: full log range ----------------
bx, by, bw, bh = 50, 585, 700, 150
d.rectangle([bx, by, bx + bw, by + bh], outline=(40, 40, 40))
d.text((bx, by - 30), "B.  the same rows on the full range   (log10(k+2), k up to 1e6) — the far fractions are term-private", font=f16, fill=(10, 10, 10))
lxb = lambda k: bx + (math.log10(k + 2) / 6.3) * bw
for dec in range(0, 7):
    xx = lxb(10**dec - 2) if dec else bx
    d.line([xx, by, xx, by + bh], fill=(240, 240, 240))
    d.text((xx - 10, by + bh + 6), f"1e{dec}", font=f11, fill=(90, 90, 90))
for n in range(2, NMAX + 1):
    for k in S[n - 2]:
        xx, yy = lxb(k), ly(n)
        d.ellipse([xx - 1.6, yy - 1.6, xx + 1.6, yy + 1.6], fill=(20, 60, 140))
d.text((bx + 8, by + 8), "support size 2-5;  indexes span up to ~1e6", font=f11, fill=(60, 60, 60))

# ---------------- C: collapse path ----------------
cx, cy, cw, ch = 850, 145, 350, 330
cx0, cy0, r = cx + cw // 2, cy + ch // 2, int(min(cw, ch) * 0.40)
d.rectangle([cx, cy, cx + cw, cy + ch], outline=(40, 40, 40))
d.text((cx, cy - 30), "C.  the collapse of one term (n = 9)", font=f16, fill=(10, 10, 10))
d.ellipse([cx0 - r, cy0 - r, cx0 + r, cy0 + r], outline=(215, 215, 215))
d.line([cx0 - r, cy0, cx0 + r, cy0], fill=(235, 235, 235)); d.line([cx0, cy0 - r, cx0, cy0 + r], fill=(235, 235, 235))
A9 = S[7]; ang = 0.0; pts = [(1.0, 0.0)]
for k in A9:
    ang += math.pi / (k + 2); pts.append((math.cos(ang), math.sin(ang)))
for i in range(len(pts) - 1):
    p, q = pts[i], pts[i + 1]
    d.line([cx0 + p[0] * r, cy0 - p[1] * r, cx0 + q[0] * r, cy0 - q[1] * r], fill=(180, 30, 30), width=2)
for i, (px, py) in enumerate(pts):
    d.ellipse([cx0 + px * r - 4, cy0 - py * r - 4, cx0 + px * r + 4, cy0 - py * r + 4],
              fill=(20, 60, 140) if i == len(pts) - 1 else (180, 30, 30))
    if i < len(A9):
        d.text((cx0 + (px + 0.05) * r, cy0 - (py + 0.08) * r), "1/%d" % (A9[i] + 2), font=f11, fill=(120, 30, 30))
d.text((cx + 8, cy + 8), "A = %s" % A9, font=f11, fill=(20, 60, 140))
d.text((cx + 8, cy + 26), "sum = %.4f deg   ->   e^(i theta) = cos + i sin" % math.degrees(ang), font=f11, fill=(60, 60, 60))
d.text((cx + 8, cy + ch - 20), "before: 5 rotations;   after: one angle (the collapse)", font=f11, fill=(60, 60, 60))

# ---------------- D: 32 uncollapsed products ----------------
dx, dy, dw, dh = 850, 530, 350, 190
d.rectangle([dx, dy, dx + dw, dy + dh], outline=(40, 40, 40))
d.text((dx, dy - 30), "D.  the 32 uncollapsed products of n = 9", font=f16, fill=(10, 10, 10))
ct, st = [], []
for j in range(len(A9) + 1):
    for Sm in itertools.combinations(A9, j):
        Sm = set(Sm); p = 1.0
        for k in A9:
            p *= (math.sin(math.pi / (k + 2)) if k in Sm else math.cos(math.pi / (k + 2)))
        (ct if j % 2 == 0 else st).append(((-1) ** (j // 2) if j % 2 == 0 else (-1) ** ((j - 1) // 2)) * p)
allv = sorted(ct + st, key=lambda v: -abs(v)); mx = max(abs(v) for v in allv)
d.line([dx, dy + dh // 2, dx + dw, dy + dh // 2], fill=(120, 120, 120))
bwid = dw / len(allv)
for i, v in enumerate(allv):
    h = abs(v) / mx * (dh // 2 - 8); x0 = dx + i * bwid + 1
    col = (20, 60, 140) if v in ct else (185, 95, 30)
    d.rectangle([x0, dy + dh // 2 - (h if v > 0 else 0), x0 + bwid - 2, dy + dh // 2 + (0 if v > 0 else h)], fill=col)
d.text((dx + 8, dy + 6), "blue = 16 cos-subset terms   orange = 16 sin-subset terms", font=f11, fill=(60, 60, 60))
d.text((dx + 8, dy + 24), "cos-sum = %+.9f    sin-sum = %+.9f" % (sum(ct), sum(st)), font=f11, fill=(60, 60, 60))
d.text((dx + 8, dy + dh - 18), "the two big terms are 1/2*1/3 products; the rest is a tail", font=f11, fill=(90, 90, 90))

# ---------------- E: amplitude ----------------
ex, ey, ew, eh = 850, 760, 350, 190
d.rectangle([ex, ey, ex + ew, ey + eh], outline=(40, 40, 40))
d.text((ex, ey - 30), "E.  the outer amplitude n^-sigma (sigma = 1)", font=f16, fill=(10, 10, 10))
lxe = lambda n: ex + ((n - 2) / (NMAX - 2)) * ew
lye = lambda v: ey + eh - (math.log10(v) + 2.5) / 2.5 * eh
for nn in range(2, NMAX + 1):
    d.ellipse([lxe(nn) - 1.4, lye(1.0 / nn) - 1.4, lxe(nn) + 1.4, lye(1.0 / nn) + 1.4], fill=(120, 40, 140))
d.text((ex + 8, ey + 8), "modulus 1/n : the decay sits outside the rotation", font=f11, fill=(110, 40, 130))
d.text((ex + 8, ey + 26), "the greedy product contributes phase only", font=f11, fill=(60, 60, 60))

out = os.path.join(HERE, "deconstructed_zeta.png")
img.save(out)
print("figure written to", out)
for n in [2, 3, 4, 5, 9]:
    A = S[n - 2]; s = sum(math.pi / (k + 2) for k in A)
    print(" n=%d  A=%s  sum=%.6f deg  collapse=%.6f" % (n, A, math.degrees(s), math.sin(s) * eps[n - 2]))
