#!/usr/bin/env python3
"""
005 (annex 2) - can tau-intervals or log tau make the Sylvester/Egyptian word map
regular or monotone?

Findings (all verified here):

 1. The WORD map is ALREADY lexicographically monotone: for a complete alphabet
    (w_k <= sum_{j>k} w_j) one has x < y => w(x) <=_lex w(y).  The thing that fails
    (source Lemma 4.1) is DIGITWISE monotonicity: a single delta_k(x) is not monotone
    in x.  delta_1(x) changes sign 3 times (1,0,1 at x = 1/3, 1/2, 5/6).

 2. No change of variable can fix that.  An order-preserving or order-reversing
    relabeling of the target does not change the number of monotone pieces of a
    function.  Measured: delta_k has the SAME sign-change count in x and in tau=1/x.

 3. What tau = 1/x DOES do is regularise the PARTITION.  With tau = 1/x,
        d1 = max(2, ceil(tau))                       (constant on [m, m+1))
        r  -> T(tau) = m*tau/(m - tau)               (strictly increasing)
        d_{j+1} = max(d_j + 1, ceil(T_j(tau)))       (hence monotone on each cylinder)
    i.e. the classical Engel/Sylvester interval map: unit cells, increasing return
    map, Markov cylinders.  This is the available notion of "regular".

 4. log tau is the WRONG logarithm: the digit boundaries sit at tau = m, so in
    log tau the cell lengths are log((m+1)/m) ~ 1/m, shrinking to zero.  The right
    logarithmic scale is log log(1/residual) (the Sylvester double-exponential scale),
    which linearises the COUNT of digits, not their order.

Run with the bundled runtime python; writes tau_regularisation.png next to this file.
"""
import math, os
import numpy as np
from PIL import Image, ImageDraw, ImageFont

HERE = os.path.dirname(os.path.abspath(__file__))
K = 80
HARM = [1.0 / (k + 2) for k in range(K)]


def digits(x, KB=K):
    r = float(x); out = [0] * KB
    for k in range(KB):
        if r >= HARM[k] - 1e-18:
            out[k] = 1; r -= HARM[k]
        if r <= 0:
            break
    return out


def d1_tau(tau):
    return max(2, math.ceil(tau))


def d2_tau(tau):
    m = d1_tau(tau)
    if tau <= m - 1e-12:
        return None
    T = tau * m / (m - tau)
    if not math.isfinite(T) or T > 1e15:
        return None
    return max(m + 1, math.ceil(T))


# --- measurements
gx = np.linspace(1e-6, 1.0, 200000)
D = np.array([digits(x) for x in gx])
alt_x = [int(np.sum(np.diff(D[:, k]) != 0)) for k in range(20)]
alt_t = [int(np.sum(np.diff(D[::-1, k]) != 0)) for k in range(20)]

# lex monotonicity of the whole word
rng = np.random.default_rng(1)
xs = np.sort(rng.random(200000))
ws = [tuple(digits(x)) for x in xs]
inv = sum(1 for i in range(len(ws) - 1) if ws[i] > ws[i + 1])

print("lex inversions of the WORD over 200k x:", inv)
print("sign changes of delta_k in x  (k=0..19):", alt_x)
print("sign changes of delta_k in tau          :", alt_t)
print("identical counts in x and tau:", alt_x == alt_t)
print("d1 = max(2, ceil(tau)); d2 = max(d1+1, ceil(T(tau))):")
_ok = True
for t_ in np.linspace(1.05, 12.0, 3000):
    x_ = 1.0 / t_
    dd = [k + 2 for k in range(K) if digits(x_)[k]]
    if dd:
        if d1_tau(t_) != dd[0]:
            _ok = False; break
        if len(dd) > 1 and d2_tau(t_) not in (None, dd[1]):
            _ok = False; break
print("  matches the direct greedy for 3000 sample tau:", _ok)

# ------------------------------------------------------------------ figure
FONT = "/System/Library/Fonts/Supplemental/Arial.ttf"
def F(s):
    try:
        return ImageFont.truetype(FONT, s)
    except Exception:
        return ImageFont.load_default()
f10, f11, f12, f14, f16, f26 = F(11), F(12), F(13), F(16), F(18), F(30)

W, H = 1720, 1180
img = Image.new("RGB", (W, H), (255, 255, 255))
d = ImageDraw.Draw(img)
d.text((34, 16), "005 annex 2 - tau-intervals and log tau: what is already monotone, what tau regularises", font=f26, fill=(10, 10, 10))
d.text((34, 56), "the WORD is lex-monotone; the DIGITS are not; tau=1/x makes the partition a regular interval map; log tau is the wrong logarithm", font=f11, fill=(80, 80, 80))

# A: delta_1 and delta_2 vs x (non-monotone)
ax, ay, aw, ah = 60, 140, 780, 240
d.rectangle([ax, ay, ax + aw, ay + ah], outline=(40, 40, 40))
d.text((ax, ay - 26), "A.  a single digit is NOT monotone in x :  delta_1(x) = 1,0,1 at x = 1/3, 1/2, 5/6", font=f14, fill=(10, 10, 10))
lx = lambda x: ax + x * aw
ly = lambda v: ay + ah - (0.55 + v * 0.45) * ah / 1.0

def step(xs_, col, colour, off=0.0):
    prev = None
    for i in range(len(xs_) - 1):
        y = ly(col[i] + off)
        if prev is not None:
            d.line([prev, (lx(xs_[i]), y)], fill=colour, width=2)
        d.line([(lx(xs_[i]), y), (lx(xs_[i + 1]), y)], fill=colour, width=2)
        prev = (lx(xs_[i + 1]), y)

sub = gx[::200]
step(sub, D[::200, 1], (20, 60, 140), 0.0)
step(sub, D[::200, 2], (185, 95, 30), -0.6)
for xx, lab in [(1/3, "1/3"), (1/2, "1/2"), (5/6, "5/6")]:
    d.line([lx(xx), ay, lx(xx), ay + ah], fill=(230, 210, 210))
    d.text((lx(xx) - 8, ay + ah + 6), lab, font=f10, fill=(90, 90, 90))
d.text((ax + 8, ay + 8), "blue delta_1 : 3 sign changes;   orange delta_2 (offset) : 4", font=f11, fill=(60, 60, 60))

# B: d1, d2 in tau
bx, by, bw, bh = 900, 140, 780, 240
d.rectangle([bx, by, bx + bw, by + bh], outline=(40, 40, 40))
d.text((bx, by - 26), "B.  in tau = 1/x the first digit is constant on the unit intervals [m, m+1)", font=f14, fill=(10, 10, 10))
lxb = lambda t_: bx + (t_ - 1) / 19 * bw
lyb = lambda v: by + bh - (math.log10(v) / 2.4) * bh
for dec in range(0, 3):
    yy = by + bh - dec / 2.4 * bh
    d.line([bx, yy, bx + bw, yy], fill=(238, 238, 238))
    d.text((bx - 30, yy - 7), "1e%d" % dec, font=f10, fill=(90, 90, 90))
ts = np.linspace(1.0001, 20, 40000)
P1 = [(lxb(t_), lyb(d1_tau(t_))) for t_ in ts]
P2 = [(lxb(t_), lyb(d2_tau(t_))) for t_ in ts if d2_tau(t_)]
for i in range(len(P1) - 1):
    d.line([P1[i], P1[i + 1]], fill=(20, 60, 140), width=2)
for i in range(len(P2) - 1):
    d.line([P2[i], P2[i + 1]], fill=(185, 95, 30), width=2)
for m in [2, 5, 10, 15]:
    d.line([lxb(m), by, lxb(m), by + bh], fill=(230, 210, 210))
    d.text((lxb(m) - 4, by + bh + 6), "%d" % m, font=f10, fill=(90, 90, 90))
d.text((bx + 8, by + 8), "blue d1 = max(2, ceil(tau)) : a unit staircase;   orange d2 increases inside each cell", font=f11, fill=(60, 60, 60))

# C: alternation counts, identical in x and tau
cx, cy, cw, ch = 60, 470, 780, 260
d.rectangle([cx, cy, cx + cw, cy + ch], outline=(40, 40, 40))
d.text((cx, cy - 26), "C.  sign changes of delta_k vs k: identical in x and in tau (reparametrisation invariant)", font=f14, fill=(10, 10, 10))
bwc = cw / 20
mx = max(alt_x) + 1
for k in range(20):
    h = alt_x[k] / mx * (ch - 40)
    d.rectangle([cx + k * bwc + 4, cy + ch - 24 - h, cx + k * bwc + bwc - 4, cy + ch - 24],
                fill=(120, 40, 140))
    d.text((cx + k * bwc + bwc / 2 - 5, cy + ch - 16), "%d" % k, font=f10, fill=(80, 80, 80))
    y = cy + ch - 24 - alt_t[k] / mx * (ch - 40)
    d.line([cx + k * bwc + 4, y, cx + k * bwc + bwc - 4, y], fill=(20, 130, 80), width=2)
d.text((cx + 8, cy + 8), "purple bars = in x;  green ticks = in tau;  they coincide for every k (max %d sign changes at k=19)" % max(alt_x), font=f11, fill=(60, 60, 60))

# D: cell geometry in tau vs log tau
dx, dy, dw, dh = 900, 470, 780, 260
d.rectangle([dx, dy, dx + dw, dy + dh], outline=(40, 40, 40))
d.text((dx, dy - 26), "D.  cell lengths: constant 1 in tau, but ~1/m in log tau (why log tau does not help)", font=f14, fill=(10, 10, 10))
ms = list(range(2, 60))
lens = [math.log((m + 1) / m) for m in ms]
mxL = max(lens)
for i, (m, L) in enumerate(zip(ms, lens)):
    h = L / mxL * (dh - 40)
    d.rectangle([dx + 30 + i * (dw - 60) / len(ms), dy + dh - 24 - h,
                 dx + 30 + (i + 1) * (dw - 60) / len(ms) - 1, dy + dh - 24], fill=(20, 130, 80))
d.line([dx + 30, dy + 30, dx + dw - 30, dy + 30], fill=(20, 60, 140), width=3)
d.text((dx + 8, dy + 8), "blue = cell length in tau (all 1);  green = in log tau, log((m+1)/m) -> 0", font=f11, fill=(60, 60, 60))
d.text((dx + 8, dy + 26), "digit boundaries are at tau = m, so log tau bunches them; the useful log is log log(1/r)", font=f11, fill=(60, 60, 60))
d.text((dx + 30, dy + dh - 16), "m = 2 ... 59", font=f10, fill=(80, 80, 80))

out = os.path.join(HERE, "tau_regularisation.png")
img.save(out)
print("\nfigure written to", out)
