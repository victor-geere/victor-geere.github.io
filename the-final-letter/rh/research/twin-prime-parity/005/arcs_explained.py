#!/usr/bin/env python3
"""
005 (annex) - why the binary selection shows periodic "(((" arcs.

The arcs are the lobe structure of the phase.  With phi_n = t log n and
w_n = phi_n mod pi, the value is exactly

    y_n = |sin(phi_n)| = sin(w_n),        w_n in [0, pi),

because |sin| has period pi.  A "lobe" is one traversal of w from 0 to pi: y rises
from 0 to 1 and falls back to 0.  Within one lobe the greedy first denominator is

    d1 = max(2, ceil(1/sin w)),

which is huge at the lobe edges (y -> 0) and 2 at the lobe centre (w = pi/2).  The
second take removes 1/d1 and its denominator d2 traces the same shape shifted right;
d3 the same again.  Hence one nested set of "(" arcs per lobe, and the whole pattern
repeats once per lobe.

Lobes are periodic in log n, not in n:  t log n advances by pi when n is multiplied by
exp(pi/t) = 1.2489..., so on a linear n axis the pattern stretches ("periodic" only up
to the geometric spacing).

Run with the bundled runtime python; writes arcs_explained.png next to this file.
"""
import math, os
import numpy as np
from PIL import Image, ImageDraw, ImageFont
from collections import Counter

HERE = os.path.dirname(os.path.abspath(__file__))
GAMMA1 = 14.134725141734693790457251983562470270784257115699
KMAX = 10**6
N = 240


def greedy_support(x, Kmax=KMAX):
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


t = GAMMA1
ns = np.arange(1, N + 1, dtype=float)
ph = t * np.log(ns)
w = np.mod(ph, math.pi)
y = np.abs(np.sin(ph))

A = [greedy_support(yi) for yi in y]
den = [[k + 2 for k in a] for a in A]
union = sorted(set(k for a in A for k in a))
LOBES = int(ph[-1] // math.pi) - int(ph[0] // math.pi)
PERIOD = math.exp(math.pi / t)

# lobe boundaries (w wraps): row index where floor(ph/pi) changes
lo = (ph // math.pi).astype(int)
bounds = [i + 1 for i in range(1, N) if lo[i] != lo[i - 1]]

def pred_d1(wi):
    s = math.sin(wi)
    if s <= 1.0 / (KMAX + 2):
        return None
    return max(2, math.ceil(1.0 / s))


print("t = %.15f   terms n = 1..%d" % (t, N))
print("lobes spanned: %d   geometric period n -> n*%.6f" % (LOBES, PERIOD))
_ok = True
for i in range(N):
    p = pred_d1(w[i])
    if not den[i]:
        if p is not None:
            _ok = False
    elif p != den[i][0]:
        _ok = False
print("check: d1 = max(2, ceil(1/sin w)) for every non-empty term:", _ok)
print("check: greedy denominators strictly increase:",
      all(all(den[i][j] < den[i][j + 1] for j in range(len(den[i]) - 1)) for i in range(N)))
print("first four denominators for n = 40..52 (the arcs):")
for i in range(39, 52):
    print("  n=%3d  w=%.4f  y=%.4f  d = %s" % (i + 1, w[i], y[i], den[i][:5]))

# ------------------------------------------------------------------ figure
FONT = "/System/Library/Fonts/Supplemental/Arial.ttf"
def F(s):
    try:
        return ImageFont.truetype(FONT, s)
    except Exception:
        return ImageFont.load_default()
f10, f11, f12, f14, f16, f26 = F(11), F(12), F(13), F(16), F(18), F(30)

W, H = 1760, 1420
img = Image.new("RGB", (W, H), (255, 255, 255))
d = ImageDraw.Draw(img)
d.text((34, 16), "005 annex - the periodic \"(((\" arcs are the lobe structure of |sin(t log n)|", font=f26, fill=(10, 10, 10))
d.text((34, 56), "y_n = |sin(phi_n)| = sin(w_n),  w_n = phi_n mod pi;  one nested set of arcs per lobe;  lobes repeat at n -> n*exp(pi/t) = n*%.4f" % PERIOD,
       font=f11, fill=(80, 80, 80))

L, R = 70, 40
PW = W - L - R

def cellcol(v):
    return (20, 60, 140) if v else (255, 255, 255)

# A. y_n vs n
ax, ay, aw, ah = L, 130, PW, 220
d.rectangle([ax, ay, ax + aw, ay + ah], outline=(40, 40, 40))
d.text((ax, ay - 26), "A.  the value  y_n = |sin(t log n)|  and the lobe boundaries (vertical lines)", font=f16, fill=(10, 10, 10))
lx = lambda n: ax + (n - 1) / (N - 1) * aw
ly = lambda v: ay + ah - v * ah
for b in bounds:
    d.line([lx(b), ay, lx(b), ay + ah], fill=(235, 210, 210))
for v in [0, 0.5, 1.0]:
    d.line([ax, ly(v), ax + aw, ly(v)], fill=(238, 238, 238))
    d.text((ax - 34, ly(v) - 7), "%.1f" % v, font=f10, fill=(90, 90, 90))
pts = [(lx(ns[i]), ly(y[i])) for i in range(N)]
for i in range(N - 1):
    d.line([pts[i], pts[i + 1]], fill=(180, 30, 30), width=2)
d.text((ax + 8, ay + 6), "red = |sin|;  pink verticals = lobe edges (w = 0 or pi);  the 1/2 threshold at y = 0.5", font=f11, fill=(120, 40, 40))

# B. denominators d1..d4 vs n on a log axis
bx, by, bw, bh = L, 420, PW, 280
d.rectangle([bx, by, bx + bw, by + bh], outline=(40, 40, 40))
d.text((bx, by - 26), "B.  the loci of the 1st..4th greedy takes: each traces one \"(\" per lobe, nested", font=f16, fill=(10, 10, 10))
lyd = lambda dd: by + bh - (math.log10(max(dd, 2)) / 6.0) * bh
for dec in range(0, 7):
    yy = by + bh - dec / 6.0 * bh
    d.line([bx, yy, bx + bw, yy], fill=(238, 238, 238))
    d.text((bx - 30, yy - 7), "1e%d" % dec, font=f10, fill=(90, 90, 90))
for b in bounds:
    d.line([lx(b), by, lx(b), by + bh], fill=(235, 210, 210))
cols = [(20, 60, 140), (185, 95, 30), (20, 130, 80), (120, 40, 140)]
for j in range(4):
    seq = [(lx(ns[i]), lyd(den[i][j])) for i in range(N) if len(den[i]) > j]
    for i in range(len(seq) - 1):
        if abs(seq[i + 1][0] - seq[i][0]) < 40:
            d.line([seq[i], seq[i + 1]], fill=cols[j], width=2)
    for p in seq:
        d.ellipse([p[0] - 2, p[1] - 2, p[0] + 2, p[1] + 2], fill=cols[j])
d.text((bx + 8, by + 6), "blue d1, orange d2, green d3, purple d4   (denominators are strictly increasing within a term)", font=f11, fill=(60, 60, 60))
d.text((bx + 8, by + 24), "each colour descends to its minimum at the lobe centre (w = pi/2) and rises at the edges", font=f11, fill=(60, 60, 60))

# C. the binary matrix
cx, cy, cw, ch = L, 780, PW, 480
d.rectangle([cx - 1, cy - 1, cx + cw + 1, cy + ch + 1], outline=(40, 40, 40))
d.text((cx, cy - 26), "C.  the binary selection (black = 1) over the same rows; the arcs are the take-loci of B", font=f16, fill=(10, 10, 10))
colw = cw / len(union)
rowh = ch / N
idx = {k: j for j, k in enumerate(union)}
for i in range(N):
    for k in A[i]:
        j = idx[k]
        d.rectangle([cx + j * colw, cy + i * rowh, cx + (j + 1) * colw - 0.2, cy + (i + 1) * rowh - 0.2],
                    fill=(20, 60, 140))
for b in bounds:
    d.line([cx, cy + b * rowh, cx + cw, cy + b * rowh], fill=(220, 60, 60))
d.text((cx - 34, cy + 2), "n=1", font=f10, fill=(90, 90, 90))
d.text((cx - 44, cy + ch - 12), "n=%d" % N, font=f10, fill=(90, 90, 90))
step = max(1, len(union) // 14)
for j in range(0, len(union), step):
    d.text((cx + j * colw - 6, cy + ch + 6), "%d" % (union[j] + 2), font=f10, fill=(90, 90, 90))
d.text((cx + cw / 2 - 40, cy + ch + 22), "fraction 1/(k+2)", font=f11, fill=(70, 70, 70))
d.text((cx + 8, cy + 8), "red horizontals = lobe boundaries; one \"(((\" nest per band between them", font=f11, fill=(200, 40, 40))

out = os.path.join(HERE, "arcs_explained.png")
img.save(out)
print("\nfigure written to", out)
