#!/usr/bin/env python3
"""
005 - The eta Re and Im series built from PLAIN greedy harmonic sums of the VALUES.

Difference from 004.  There, the greedy Egyptian expansion was applied to the ANGLE
x_n = theta_n/pi, and both cos(theta_n) and sin(theta_n) were read off the same support
A_n through the compound-angle (cosine-addition) identity -- the "collapse".  Here the
sine and cosine of each term are expanded SEPARATELY, each as a plain greedy Egyptian
sum of its own numeric value:

    sin(phi_n) = sgn_n * ( sum_{k in B_n} 1/(k+2) + r_n ),   |r_n| < 1/(K+2)
    cos(phi_n) = tgn_n * ( sum_{k in C_n} 1/(k+2) + q_n ),   |q_n| < 1/(K+2)

No angle is ever added and no trig identity is used.  The digits delta^{sin}_{n,k} and
delta^{cos}_{n,k} in {0,1} are the binary selection.  Substituting:

    Im eta(s) = -sum_n (-1)^{n-1} n^{-sigma} sgn_n sum_{k in B_n} 1/(k+2) + tail
    Re eta(s) =  sum_n (-1)^{n-1} n^{-sigma} tgn_n sum_{k in C_n} 1/(k+2) + tail

Why this is a different object from 004:
  * one word per term in 004 (shared by cos and sin); TWO independent words here;
  * 004 reconstructs the value through products of elementary sin/cos (subset sums);
    here the value is a linear sum of unit fractions -- no products, no identity;
  * the value error is exactly the greedy residual r_n (004 paid a factor pi by MVT);
  * the selection is a quantizer of the VALUE, so its input density is the arcsine law
    of |sin(phi)| (resp. |cos(phi)|), not the uniform density of the angle.

Needs numpy + Pillow. Run with the bundled runtime python:
  /Users/victor/.dsh/dsh-runtimes/dsh-primary-runtime/dependencies/python/bin/python3 value_greedy.py
Writes value_greedy.png, value_greedy_im.tsv, value_greedy_re.tsv next to this file.
"""
import math, os
import numpy as np
from PIL import Image, ImageDraw, ImageFont
from collections import Counter

HERE = os.path.dirname(os.path.abspath(__file__))

# ------------------------------------------------------------------ parameters
GAMMA1 = 14.134725141734693790457251983562470270784257115699   # first zeta zero
SIGMA = 0.5                                                    # critical line
NTERMS = 200                                                   # terms of the series
NMAT = 200                                                     # rows drawn in the matrices
KMAX = 10**6                                                   # greedy truncation


# ------------------------------------------------------------------ core
def greedy_support(x, Kmax):
    """Greedy Egyptian expansion of x in [0,1] on 1/(k+2), indices k < Kmax.

    Identical algorithm to 004, but here it is fed the VALUE |sin phi| or |cos phi|
    rather than the angle theta/pi.  Jump form: next index = ceil(1/r) - 2."""
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


def decode(A):
    return [k + 2 for k in A]


def arcsine_leading(d):
    """P(first selected denominator = d) for y = |sin(phi)|, phi equidistributed.

    The greedy first denominator is ceil(1/y); y has the arcsine density
    2/(pi sqrt(1-y^2)), so P(ceil(1/y)=d) = (2/pi)(asin(1/(d-1)) - asin(1/d))."""
    if d < 2:
        return 0.0
    hi = math.pi / 2 if d == 2 else math.asin(1.0 / (d - 1))
    return (2.0 / math.pi) * (hi - math.asin(1.0 / d))


# ------------------------------------------------------------------ data
t = GAMMA1
ns = np.arange(1, NTERMS + 1, dtype=float)
phi = np.mod(t * np.log(ns), 2 * np.pi)
sn = np.sin(phi)
cs = np.cos(phi)
sgn = np.where(sn >= 0, 1.0, -1.0)
tgn = np.where(cs >= 0, 1.0, -1.0)

B, C, rsin, rcos = [], [], [], []
for i in range(NTERMS):
    a, r = greedy_support(abs(sn[i]), KMAX); B.append(a); rsin.append(r)
    a, r = greedy_support(abs(cs[i]), KMAX); C.append(a); rcos.append(r)

sumB = np.array([sum(1.0 / (k + 2) for k in a) for a in B])
sumC = np.array([sum(1.0 / (k + 2) for k in a) for a in C])

w = ((-1.0) ** (ns - 1)) * ns ** (-SIGMA)         # (-1)^{n-1} n^{-sigma}

Im_direct = float(-np.sum(w * sn))
Re_direct = float(np.sum(w * cs))
Im_value = float(-np.sum(w * sgn * sumB))
Re_value = float(np.sum(w * tgn * sumC))

# ------------------------------------------------------------------ statistics
fB = Counter(k for a in B for k in a)
fC = Counter(k for a in C for k in a)
unionB = sorted(fB); unionC = sorted(fC)

Jab = np.array([(len(set(B[i]) & set(C[i])) / len(set(B[i]) | set(C[i])))
                if (B[i] or C[i]) else 0.0 for i in range(NTERMS)])
disjoint = float(np.mean([1.0 if not (set(B[i]) & set(C[i])) else 0.0 for i in range(NTERMS)]))

leadB = [a[0] + 2 if a else None for a in B]
leadC = [a[0] + 2 if a else None for a in C]
cB, cC = Counter(leadB), Counter(leadC)

sizeB = np.array([len(a) for a in B]); sizeC = np.array([len(a) for a in C])

print("=" * 104)
print("005 - plain greedy harmonic sums of the VALUES sin(phi_n), cos(phi_n)  (no angle addition)")
print("      s = %.3f + i*%.15f   terms n = 1..%d   truncation K = 1e6" % (SIGMA, GAMMA1, NTERMS))
print("=" * 104)

print("\n--- the two series, direct vs plain-greedy ---")
print("  M        Im eta_M direct      Im value         diff      Re eta_M direct      Re value         diff")
for M in [10, 50, 100, 200]:
    imd = float(-np.sum(w[:M] * sn[:M])); imv = float(-np.sum(w[:M] * sgn[:M] * sumB[:M]))
    red = float(np.sum(w[:M] * cs[:M])); rev = float(np.sum(w[:M] * tgn[:M] * sumC[:M]))
    print(" %-5d  % .12f   % .12f   %.2e  % .12f   % .12f   %.2e"
          % (M, imd, imv, abs(imd - imv), red, rev, abs(red - rev)))
print(" the 'value' columns are sum_n (-1)^{n-1} n^-sigma * (plain greedy sum of the value);")
print(" the difference is the accumulated greedy residual sum_n n^-sigma r_n.")

print("\n--- support (binary word) sizes ---")
print("  value |sin phi| :  mean |B| = %.3f   max = %d   distinct fractions = %d"
      % (sizeB.mean(), sizeB.max(), len(unionB)))
print("  value |cos phi| :  mean |C| = %.3f   max = %d   distinct fractions = %d"
      % (sizeC.mean(), sizeC.max(), len(unionC)))
print("  max residual sin = %.3e   max residual cos = %.3e   (bound 1/(K+2) = %.3e)"
      % (max(rsin), max(rcos), 1.0 / (KMAX + 2)))

print("\n--- leading denominator d1 = ceil(1/|value|): empirical vs the arcsine law ---")
print("   d      sin-value count   freq     cos-value count   freq     arcsine P(d)")
for d in range(2, 13):
    print("  %2d      %6d          %6.4f    %6d          %6.4f    %6.4f"
          % (d, cB.get(d, 0), cB.get(d, 0) / NTERMS, cC.get(d, 0), cC.get(d, 0) / NTERMS,
             arcsine_leading(d)))
tailB = sum(v for k, v in cB.items() if k and k > 12)
tailC = sum(v for k, v in cC.items() if k and k > 12)
tailP = sum(arcsine_leading(d) for d in range(13, 4000))
print("  >12      %6d          %6.4f    %6d          %6.4f    %6.4f"
      % (tailB, tailB / NTERMS, tailC, tailC / NTERMS, tailP))

print("\n--- most-selected fractions (the binary columns) ---")
print("   fraction   #terms sin   #terms cos")
ks = sorted(set(list(fB)[:]) | set(fC), key=lambda k: -(fB.get(k, 0) + fC.get(k, 0)))[:20]
for k in ks:
    print("   %-9s  %6d       %6d" % ("1/%d" % (k + 2), fB.get(k, 0), fC.get(k, 0)))

print("\n--- do the sine-word and the cosine-word of the SAME term overlap? ---")
print("  mean Jaccard(B_n, C_n) = %.4f    pairs with B_n and C_n disjoint = %.1f%%"
      % (Jab.mean(), 100 * disjoint))
print("  (in 004 cos and sin shared ONE word exactly; here they are two independent words)")

print("\n--- first 20 terms: the two binary words over the top fractions ---")
top = ks[:14]
print("      n   |sin|     |cos|     B_n (sine word)                 C_n (cosine word)")
for i in range(20):
    print("  %4d   %.5f   %.5f   %-30s   %-30s"
          % (i + 1, abs(sn[i]), abs(cs[i]),
             " ".join("1/%d" % (k + 2) for k in B[i][:5]),
             " ".join("1/%d" % (k + 2) for k in C[i][:5])))

# ------------------------------------------------------------------ tsv
for tag, U, sets in [("im", unionB, B), ("re", unionC, C)]:
    path = os.path.join(HERE, "value_greedy_%s.tsv" % tag)
    with open(path, "w") as fh:
        fh.write("n\t" + "\t".join("1/%d" % (k + 2) for k in U) + "\n")
        for i in range(NTERMS):
            S = set(sets[i])
            fh.write("%d\t" % (i + 1) + "\t".join("1" if k in S else "0" for k in U) + "\n")
    print("\nselector matrix written to", path)

# ------------------------------------------------------------------ figure
FONT = "/System/Library/Fonts/Supplemental/Arial.ttf"
def F(s):
    try:
        return ImageFont.truetype(FONT, s)
    except Exception:
        return ImageFont.load_default()
f9, f11, f12, f14, f16, f26 = F(10), F(12), F(13), F(16), F(18), F(30)

W, H = 1760, 1560
img = Image.new("RGB", (W, H), (255, 255, 255))
d = ImageDraw.Draw(img)
d.text((34, 18), "005 - plain greedy harmonic sums of the values: the binary selection of the Im and Re series",
       font=f26, fill=(10, 10, 10))
d.text((34, 58), "sin(phi_n)=sgn*sum_{k in B_n}1/(k+2),  cos(phi_n)=tgn*sum_{k in C_n}1/(k+2)   -   no compound-angle identity   -   t=%.10f, sigma=%.1f, K=1e6"
       % (GAMMA1, SIGMA), font=f11, fill=(80, 80, 80))

MX0, MY0, MW, MH = 34, 150, 1010, 560
cellw = MW / max(len(unionB), len(unionC))
cellh = MH / NMAT


def draw_matrix(x0, y0, title, U, sets, shared_colour):
    cols = len(U)
    cwd = MW / cols
    d.rectangle([x0 - 1, y0 - 1, x0 + MW + 1, y0 + MH + 1], outline=(40, 40, 40))
    idx = {k: j for j, k in enumerate(U)}
    for i in range(NMAT):
        row = sets[i]
        for k in row:
            j = idx[k]
            d.rectangle([x0 + j * cwd, y0 + i * cellh,
                         x0 + (j + 1) * cwd - 0.3, y0 + (i + 1) * cellh - 0.3], fill=shared_colour)
    d.text((x0 - 30, y0 + 2), "n=1", font=f9, fill=(90, 90, 90))
    d.text((x0 - 42, y0 + MH - 12), "n=%d" % NMAT, font=f9, fill=(90, 90, 90))
    d.text((x0 + MW / 2 - 40, y0 + MH + 8), "fraction 1/(k+2)", font=f11, fill=(70, 70, 70))
    step = max(1, cols // 12)
    for j in range(0, cols, step):
        d.text((x0 + j * cwd - 6, y0 - 14), "%d" % (U[j] + 2), font=f9, fill=(90, 90, 90))
    return cwd


d.text((MX0, MY0 - 52), "A.  Im series: greedy Egyptian word of |sin(phi_n)|   (%d columns, mean |B|=%.2f)"
       % (len(unionB), sizeB.mean()), font=f16, fill=(10, 10, 10))
draw_matrix(MX0, MY0, "", unionB, B, (20, 60, 140))

d.text((MX0, MY0 + MH + 46), "B.  Re series: greedy Egyptian word of |cos(phi_n)|   (%d columns, mean |C|=%.2f)"
       % (len(unionC), sizeC.mean()), font=f16, fill=(10, 10, 10))
draw_matrix(MX0, MY0 + MH + 76, "", unionC, C, (185, 95, 30))

RX, RW = 1090, 630

def panel(x0, y0, w, h, title):
    d.rectangle([x0, y0, x0 + w, y0 + h], outline=(40, 40, 40))
    d.text((x0, y0 - 26), title, font=f14, fill=(10, 10, 10))

# C. leading denominator vs arcsine
cy = 150
panel(RX, cy, RW, 250, "C.  leading denominator d1 = ceil(1/|value|): empirical vs arcsine law")
ds = list(range(2, 13))
mx = max(max(cB.get(x, 0) for x in ds), max(cC.get(x, 0) for x in ds))
bw = RW / (len(ds) + 1)
for i, x in enumerate(ds):
    hb = cB.get(x, 0) / mx * 180
    hc = cC.get(x, 0) / mx * 180
    d.rectangle([RX + i * bw + 4, cy + 210 - hb, RX + i * bw + bw / 2 - 2, cy + 210], fill=(20, 60, 140))
    d.rectangle([RX + i * bw + bw / 2 + 2, cy + 210 - hc, RX + i * bw + bw - 4, cy + 210], fill=(185, 95, 30))
    d.text((RX + i * bw + bw / 2 - 4, cy + 214), "%d" % x, font=f9, fill=(80, 80, 80))
pp = [(RX + (i + 0.5) * bw, cy + 210 - arcsine_leading(x) * NTERMS / mx * 180) for i, x in enumerate(ds)]
for i in range(len(pp) - 1):
    d.line([pp[i], pp[i + 1]], fill=(20, 130, 80), width=3)
for p in pp:
    d.ellipse([p[0] - 3, p[1] - 3, p[0] + 3, p[1] + 3], fill=(20, 130, 80))
d.text((RX + 8, cy + 8), "blue sin-value  orange cos-value  green arcsine prediction", font=f11, fill=(60, 60, 60))
d.text((RX + 8, cy + 26), "y=|sin phi| has arcsine density 2/(pi sqrt(1-y^2)): P(1/2 taken)=2/3", font=f11, fill=(60, 60, 60))

# D. selection frequency
dy = 440
panel(RX, dy, RW, 250, "D.  how often each fraction is selected (binary column frequency)")
tops = ks[:18]
mx2 = max(max(fB.get(k, 0) for k in tops), max(fC.get(k, 0) for k in tops))
bw2 = RW / len(tops)
for i, k in enumerate(tops):
    hb = fB.get(k, 0) / mx2 * 170
    hc = fC.get(k, 0) / mx2 * 170
    d.rectangle([RX + i * bw2 + 2, dy + 200 - hb, RX + i * bw2 + bw2 / 2 - 1, dy + 200], fill=(20, 60, 140))
    d.rectangle([RX + i * bw2 + bw2 / 2 + 1, dy + 200 - hc, RX + i * bw2 + bw2 - 2, dy + 200], fill=(185, 95, 30))
    d.text((RX + i * bw2 + bw2 / 2 - 8, dy + 204), "1/%d" % (k + 2), font=f9, fill=(80, 80, 80))
d.text((RX + 8, dy + 8), "the low fractions carry almost all the selection; the rest is term-private",
       font=f11, fill=(60, 60, 60))

# E. support-size histogram
ey = 730
panel(RX, ey, RW, 220, "E.  support size |B| and |C| (binary weight of the word)")
maxs = max(sizeB.max(), sizeC.max())
bws = (RW - 40) / maxs
for s_ in range(1, maxs + 1):
    cb = int(np.sum(sizeB == s_)); cc = int(np.sum(sizeC == s_))
    hb = cb / NTERMS * 120; hc = cc / NTERMS * 120
    x0 = RX + 20 + (s_ - 1) * bws
    d.rectangle([x0, ey + 190 - hb, x0 + bws * 0.40, ey + 190], fill=(20, 60, 140))
    d.rectangle([x0 + bws * 0.44, ey + 190 - hc, x0 + bws * 0.84, ey + 190], fill=(185, 95, 30))
    d.text((x0 + bws * 0.28, ey + 194), "%d" % s_, font=f9, fill=(80, 80, 80))
d.text((RX + 8, ey + 8), "mean |B|=%.2f  |C|=%.2f   (Sylvester growth O(log log K))" % (sizeB.mean(), sizeC.mean()),
       font=f11, fill=(60, 60, 60))
d.text((RX + 8, ey + 26), "blue = |B| (sine word)   orange = |C| (cosine word)", font=f11, fill=(60, 60, 60))

# F. overlap + residuals
fy = 980
panel(RX, fy, RW, 230, "F.  the two words of the same term: overlap and residuals")
hist, _ = np.histogram(Jab, bins=np.linspace(0, 1, 11))
mxh = max(hist.max(), 1)
base = fy + 200
for i in range(10):
    hh = hist[i] / mxh * 80
    x0 = RX + 30 + i * (RW - 60) / 10
    d.rectangle([x0, base - hh, x0 + (RW - 60) / 10 - 4, base], fill=(120, 40, 140))
    d.text((x0, base + 4), "%.1f" % (i / 10), font=f9, fill=(80, 80, 80))
d.text((RX + 8, fy + 8), "Jaccard(B_n,C_n): mean %.3f,  %.0f%% of terms are disjoint" % (Jab.mean(), 100 * disjoint),
       font=f11, fill=(60, 60, 60))
d.text((RX + 8, fy + 30), "max residual sin %.2e, cos %.2e" % (max(rsin), max(rcos)), font=f11, fill=(60, 60, 60))
d.text((RX + 8, fy + 52), "the value error IS the greedy residual (no pi factor)", font=f11, fill=(60, 60, 60))

out = os.path.join(HERE, "value_greedy.png")
img.save(out)
print("\nfigure written to", out)
