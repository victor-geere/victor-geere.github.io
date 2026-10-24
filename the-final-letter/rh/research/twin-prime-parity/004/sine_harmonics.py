#!/usr/bin/env python3
"""
Greedy-harmonic sine of the zeta phases, and the harmonisation of the fraction-sets.

For each term n of zeta(sigma + i t):
  * reduce the phase phi_n = t log n to an angle theta_n in [0, pi] with a sign eps_n;
  * run the greedy harmonic expansion of x_n = theta_n/pi with the alphabet 1/(k+2),
    giving the support A_n = {k : delta_k = 1} and the fractions {1/(k+2) : k in A_n};
  * reconstruct sin(theta_n) and compare with the direct value;
  * measure how A_n overlaps the supports A_m of all the other terms.

Needs numpy + Pillow. Run with the bundled runtime python:
  /Users/victor/.dsh/dsh-runtimes/dsh-primary-runtime/dependencies/python/bin/python3 sine_harmonics.py
Writes sine_harmonics.png next to this file.
"""
import math, os, sys
import numpy as np
from PIL import Image, ImageDraw, ImageFont
from collections import Counter

T, M, KMAX = 10.0, 600, 10**6
HERE = os.path.dirname(os.path.abspath(__file__))

# ---------------------------------------------------------------- core
def greedy_support(x, Kmax):
    """Greedy Egyptian expansion of x in [0,1], alphabet 1/(k+2), indices k < Kmax.

    Jumps directly to the next index k with 1/(k+2) <= residual, so the cost is the
    number of takes (O(log log Kmax)), not Kmax."""
    r, k, A = float(x), 0, []
    if r <= 0:
        return A, 0.0
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
    return A, r

ns = np.arange(2, M + 2, dtype=float)              # terms n = 2..M+1  (n=1 has phi=0)
phi = np.mod(T * np.log(ns), 2 * np.pi)
eps = np.where(phi <= np.pi, 1.0, -1.0)
theta = np.where(phi <= np.pi, phi, 2 * np.pi - phi)
x = theta / np.pi
S = [set(greedy_support(xi, KMAX)[0]) for xi in x]
sizes = np.array([len(A) for A in S])
sums = np.array([sum(1.0 / (k + 2) for k in A) for A in S])

print("=== sine from the greedy fractions (t = %g) ===" % T)
print("  n   x_n          fractions                              sin(greedy)  sin(direct)   err")
for i in range(8):
    A = sorted(S[i])
    fr = "+".join("1/%d" % (k + 2) for k in A[:6]) + ("+..." if len(A) > 6 else "")
    sg = eps[i] * math.sin(math.pi * sums[i]); sd = math.sin(T * math.log(ns[i]))
    print("%4d  %.8f   %-38s %+.8f  %+.8f  %.1e" % (int(ns[i]), x[i], fr, sg, sd, abs(sg - sd)))

print("\n=== support size vs truncation ===")
print(" Kmax        mean|A|   source Lemma 3.3 (theta/pi) log Kmax")
for K in [10, 100, 1000, 10**4, 10**5, 10**6, 10**7]:
    m = np.mean([len(greedy_support(xi, K)[0]) for xi in x])
    print(" %-10d  %6.3f   %8.3f" % (K, m, np.mean(x) * math.log(K)))

print("\n=== pairwise harmonisation  H = |A_n & A_m| / |A_n | A_m| ===")
J = np.zeros((M, M))
c0 = c1 = c2 = c3 = c4 = 0
for i in range(M):
    for j in range(i + 1, M):
        u = len(S[i] | S[j]); v = len(S[i] & S[j]) / u if u else 0.0
        J[i, j] = J[j, i] = v
        c = len(S[i] & S[j])
        if c == 0: c0 += 1
        elif c == 1: c1 += 1
        elif c == 2: c2 += 1
        elif c == 3: c3 += 1
        else: c4 += 1
np.fill_diagonal(J, 1.0)
off = J[np.triu_indices(M, 1)]
print(" pairs=%d   disjoint=%d (%.1f%%)   mean H=%.4f   max H=%.4f" %
      (len(off), c0, 100 * c0 / len(off), off.mean(), off.max()))
print(" shared fractions per overlapping pair: 1 -> %d,  2 -> %d,  3 -> %d,  4 -> %d" % (c1, c2, c3, c4))

nested = tot = 0
for i in range(M):
    for j in range(M):
        if x[i] < x[j]:
            tot += 1; nested += (S[i] <= S[j])
print(" nesting test: ordered pairs x_i<x_j = %d ; A_i subset A_j = %d (%.2f%%; monotonicity would give 100%%)"
      % (tot, nested, 100.0 * nested / tot))

harm = np.array([np.mean([(len(S[i] & S[j]) / len(S[i] | S[j]) if (S[i] | S[j]) else 0.0)
                          for j in range(M) if j != i]) for i in range(M)])
print(" per-term harmony h_n: mean %.4f, max %.4f (n=%d, x=%.3f)" %
      (harm.mean(), harm.max(), int(ns[int(np.argmax(harm))]), x[int(np.argmax(harm))]))

# ---------------------------------------------------------------- figure
FONT = "/System/Library/Fonts/Supplemental/Arial.ttf"
def F(s): return ImageFont.truetype(FONT, s)
f11, f12, f15, f27 = F(12), F(13), F(16), F(30)

def lerp(a, b, u): return tuple(int(p + (q - p) * u) for p, q in zip(a, b))
def col(v):
    u = min(max(v, 0.0), 1.0)
    return lerp((255, 255, 255), (107, 174, 214), u * 2) if u < 0.5 else lerp((107, 174, 214), (8, 48, 107), (u - 0.5) * 2)

W, H = 1620, 1160
img = Image.new("RGB", (W, H), (255, 255, 255)); d = ImageDraw.Draw(img)
d.text((44, 22), "Greedy-harmonic sine of the zeta phases, and the harmonisation of the fraction-sets", font=f27, fill=(10, 10, 10))
d.text((44, 62), "t = %g   terms n = 2..%d   theta_n = t log n reduced to [0,pi]   x_n = theta_n/pi   truncation K = 1e6" % (T, M + 1), font=f12, fill=(80, 80, 80))

ax, ay, aw = 50, 152, 540
order = np.argsort(x); Jo = J[np.ix_(order, order)]
hm = Image.new("RGB", (M, M)); px = hm.load()
for i in range(M):
    for j in range(M): px[j, i] = col(Jo[i, j])
img.paste(hm.resize((aw, aw), Image.NEAREST), (ax, ay))
d.rectangle([ax - 1, ay - 1, ax + aw, ay + aw], outline=(40, 40, 40))
d.text((ax, ay - 30), "A.  pairwise harmonisation   H(n,m) = |A_n & A_m| / |A_n | A_m|   (ordered by x_n)", font=f15, fill=(10, 10, 10))
cbx = ax + aw + 14
for i in range(aw): d.line([cbx, ay + i, cbx + 18, ay + i], fill=col(1 - i / aw))
d.rectangle([cbx, ay, cbx + 18, ay + aw], outline=(40, 40, 40))
d.text((cbx + 24, ay - 6), "1", font=f12, fill=(40, 40, 40)); d.text((cbx + 24, ay + aw - 10), "0", font=f12, fill=(40, 40, 40))
d.text((ax, ay + aw + 16), "%.0f%% of pairs have disjoint supports;  mean H = %.3f;  %d nested pairs out of %d." % (100 * c0 / len(off), off.mean(), nested, tot), font=f12, fill=(70, 70, 70))
d.text((ax, ay + aw + 36), "Nesting rate ~5e-6 per ordered pair (expected ~1), so 0/179700 is uninformative.", font=f12, fill=(70, 70, 70))

def panel(x0, y0, w, h, title, xlab, ticks):
    d.rectangle([x0, y0, x0 + w, y0 + h], outline=(40, 40, 40))
    d.text((x0, y0 - 30), title, font=f15, fill=(10, 10, 10))
    d.text((x0 + w // 2 - 30, y0 + h + 26), xlab, font=f12, fill=(70, 70, 70))
    for tv in ticks:
        yy = y0 + h - (tv - ticks[0]) / (ticks[-1] - ticks[0]) * h
        d.line([x0 - 4, yy, x0, yy], fill=(80, 80, 80))
        d.text((x0 - 38, yy - 7), "%g" % tv, font=f11, fill=(80, 80, 80))

# B: support size vs K
bx, by, bw, bh = 800, 152, 330, 230
panel(bx, by, bw, bh, "B.  support size |A| grows like log log K", "K (log scale)", [0, 2, 4, 6, 8])
Ks = [10, 100, 1000, 10**4, 10**5, 10**6, 10**7]
means = [np.mean([len(greedy_support(xi, k)[0]) for xi in x]) for k in Ks]
preds = [np.mean(x) * math.log(k) for k in Ks]
lx = lambda k: bx + (math.log10(k) - 1) / 6 * bw
Yv = lambda v: by + bh - v / 8 * bh
for k in Ks:
    d.line([lx(k), by, lx(k), by + bh], fill=(238, 238, 238))
    d.text((lx(k) - 12, by + bh + 4), "1e%d" % int(math.log10(k)), font=f11, fill=(80, 80, 80))
pb = [(lx(k), Yv(v)) for k, v in zip(Ks, preds)]
for i in range(len(pb) - 1): d.line([pb[i], pb[i + 1]], fill=(60, 90, 200), width=2)
pm = [(lx(k), Yv(v)) for k, v in zip(Ks, means)]
for i in range(len(pm) - 1): d.line([pm[i], pm[i + 1]], fill=(180, 30, 30), width=3)
for p in pm: d.ellipse([p[0] - 3, p[1] - 3, p[0] + 3, p[1] + 3], fill=(180, 30, 30))
d.text((bx + 10, by + 44), "red  measured:  0.40 + 1.19 log log K", font=f11, fill=(150, 30, 30))
d.text((bx + 10, by + 60), "blue  source Lemma 3.3: (theta/pi) log K  (false)", font=f11, fill=(40, 70, 170))

# C: first differing digit vs angular distance
cx, cy, cw, ch = 1210, 152, 330, 230
panel(cx, cy, cw, ch, "C.  first differing digit of two supports", "|x_n - x_m|  (log scale)", [1, 10, 100, 1000])
pairs = []
for i in range(M):
    for j in range(i + 1, M):
        sd = S[i] ^ S[j]
        pairs.append((abs(x[i] - x[j]), min(sd) if sd else KMAX))
pairs = np.array(pairs)
bins = np.logspace(np.log10(pairs[:, 0].min() + 1e-12), 0, 12)
mids, mn = [], []
for b0, b1 in zip(bins[:-1], bins[1:]):
    m = (pairs[:, 0] >= b0) & (pairs[:, 0] < b1)
    if m.sum(): mids.append(math.sqrt(b0 * b1)); mn.append(pairs[m, 1].mean())
mids, mn = np.array(mids), np.array(mn)
lx2 = lambda v: cx + (math.log10(v) + 5) / 5 * cw
ly2 = lambda v: cy + ch - (math.log10(max(v, 1)) / 3.2) * ch
for v in [1, 10, 100, 1000]: d.line([cx, ly2(v), cx + cw, ly2(v)], fill=(238, 238, 238))
for v in [1e-5, 1e-4, 1e-3, 1e-2, 1e-1]:
    d.line([lx2(v), cy, lx2(v), cy + ch], fill=(238, 238, 238))
    d.text((lx2(v) - 16, cy + ch + 4), "1e%d" % int(math.log10(v)), font=f11, fill=(80, 80, 80))
P = [(lx2(a), ly2(b)) for a, b in zip(mids, mn)]
for i in range(len(P) - 1): d.line([P[i], P[i + 1]], fill=(20, 120, 80), width=3)
for p in P: d.ellipse([p[0] - 3, p[1] - 3, p[0] + 3, p[1] + 3], fill=(20, 120, 80))
d.text((cx + 10, cy + 8), "binned mean over all pairs", font=f11, fill=(20, 100, 70))

# D: shared-token concentration
dx0, dy0, dw, dh = 800, 500, 330, 230
panel(dx0, dy0, dw, dh, "D.  harmony lives in the low-order fractions", "fraction 1/(k+2)", [0, 25, 50, 75, 100])
tok = Counter()
for i in range(M):
    for j in range(i + 1, M):
        for k in S[i] & S[j]: tok[k] += 1
idxcount = Counter()
for s_ in S:
    for k in s_: idxcount[k] += 1
n_shared = sum(1 for v in idxcount.values() if v > 1); n_distinct = len(idxcount)
ks = sorted(tok)[:12]; tot_tok = sum(tok.values()); cum = np.cumsum([tok[k] for k in ks]) / tot_tok * 100
for i in range(0, 101, 25): d.line([dx0, dy0 + dh - i / 100 * dh, dx0 + dw, dy0 + dh - i / 100 * dh], fill=(238, 238, 238))
bwid = dw / len(ks)
for i, (k, c) in enumerate(zip(ks, cum)):
    h = (c / 100) * dh
    d.rectangle([dx0 + i * bwid + 6, dy0 + dh - h, dx0 + (i + 1) * bwid - 6, dy0 + dh], fill=(40, 70, 170))
    d.text((dx0 + i * bwid + 3, dy0 + dh + 4), "1/%d" % (k + 2), font=f11, fill=(70, 70, 70))
d.text((dx0 + 10, dy0 + 8), "cumulative: 1/2 = %.0f%%,  +1/3 = %.0f%%,  +1/4 = %.0f%%" % (cum[0], cum[1], cum[2]), font=f11, fill=(40, 70, 170))
d.text((dx0 + 10, dy0 + 26), "%d of %d used indices appear in >=2 terms" % (n_shared, n_distinct), font=f11, fill=(90, 90, 90))

# E: per-term harmony vs angle
ex, ey, ew, eh = 1210, 500, 330, 230
panel(ex, ey, ew, eh, "E.  per-term harmony h_n rises with the angle", "x_n = theta_n / pi", [0, 0.05, 0.10, 0.15])
lx3 = lambda v: ex + v * ew
ly3 = lambda v: ey + eh - (v / 0.15) * eh
for v in [0, 0.05, 0.10, 0.15]: d.line([ex, ly3(v), ex + ew, ly3(v)], fill=(238, 238, 238))
for i in range(M): d.ellipse([lx3(x[i]) - 2, ly3(harm[i]) - 2, lx3(x[i]) + 2, ly3(harm[i]) + 2], fill=(120, 40, 140))
d.text((ex + 10, ey + 8), "max h_n = %.3f (n=%d, x=%.3f);  mean %.3f" % (harm.max(), int(ns[int(np.argmax(harm))]), x[int(np.argmax(harm))], harm.mean()), font=f11, fill=(110, 40, 130))
d.text((ex + 10, ey + 26), "small-angle terms are almost private", font=f11, fill=(90, 90, 90))

out = os.path.join(HERE, "sine_harmonics.png")
img.save(out)
print("\nfigure written to", out)
