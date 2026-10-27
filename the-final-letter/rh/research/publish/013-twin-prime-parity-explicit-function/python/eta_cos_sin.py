#!/usr/bin/env python3
"""
The complex Dirichlet eta function at the first zeta zero, split into its
Re (cos) and Im (sin) series, with the Im terms expanded in greedy-harmonic sines
and displayed as boolean selectors.

Object:  eta(s) = sum_{n>=1} (-1)^{n-1} n^{-s} = (1 - 2^{1-s}) zeta(s),  s = sigma + i t.

With phi_n = t log n and n^{-s} = n^{-sigma} (cos phi_n - i sin phi_n):

    Re eta(s) =  sum_n (-1)^{n-1} n^{-sigma} cos(phi_n)        (cos series)
    Im eta(s) = -sum_n (-1)^{n-1} n^{-sigma} sin(phi_n)        (sin series)

Reducing phi_n to theta_n in [0,pi] with a sign eps_n (sin phi_n = eps_n sin theta_n)
and running the greedy Egyptian expansion of x_n = theta_n/pi on the alphabet
1/(k+2) with support A_n = {k : delta_k = 1}, the sine is reconstructed as

    sin(phi_n) = eps_n sin( pi * sum_{k in A_n} 1/(k+2) ) ,

so the Im series is a sum of greedy sines selected by the 0/1 digits delta_k.

The amplitudes (-1)^{n-1} n^{-sigma} are NOT on the unit circle: they are carried
outside the greedy word (the word is a function of theta_n alone). The script keeps
them explicit -- the greedy sentence supplies the phase, the alternating radial weight
supplies the modulus.

The first zeta zero is s = 1/2 + i*gamma_1 with gamma_1 = 14.134725141734693790...;
at that point eta(s) = 0 (the eta factor is finite there), so both series sum to 0.

Needs numpy + Pillow. Run with the bundled runtime python:
  python3 eta_cos_sin.py
Writes eta_cos_sin.png next to this file.
"""
import sys
import math, os, itertools
import numpy as np
from PIL import Image, ImageDraw, ImageFont
from collections import Counter

HERE = os.path.dirname(os.path.abspath(__file__))

# ------------------------------------------------------------------ parameters
GAMMA1 = 14.134725141734693790457251983562470270784257115699   # first zeta zero
SIGMA = 0.5                                                    # critical line
NTERMS = 100                                                   # "first 100 terms"
KMAX = 10**6                                                   # greedy truncation
RUNTIME = "python3"


# ------------------------------------------------------------------ core
def greedy_support(x, Kmax):
    """Greedy Egyptian expansion of x in [0,1] on 1/(k+2), indices k < Kmax.

    Jump form: from residual r the next index with 1/(k+2) <= r is k = ceil(1/r)-2,
    so the cost is the number of takes O(log log Kmax), not Kmax."""
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


def frac(k):
    return "1/%d" % (k + 2)


def eta_euler(s, N=60):
    """Independent high-accuracy eta via the Euler transform of the alternating series.

    sum_{n>=0} (-1)^n a_n = sum_{k>=0} Delta^k a_0 / 2^{k+1},  a_n = (n+1)^{-s},
    Delta a_n = a_n - a_{n+1}.  Verified against eta(2) = pi^2/12 and eta(1) = log 2."""
    a = [(n + 1) ** (-s) for n in range(N + 1)]
    row = a[:]
    tot = 0.0
    for k in range(N):
        tot += row[0] / 2.0 ** (k + 1)
        row = [row[i] - row[i + 1] for i in range(len(row) - 1)]
    return tot


# ------------------------------------------------------------------ data
t = GAMMA1
ns = np.arange(1, NTERMS + 1, dtype=float)
phi = np.mod(t * np.log(ns), 2 * np.pi)
eps = np.where(phi <= np.pi, 1.0, -1.0)
theta = np.where(phi <= np.pi, phi, 2 * np.pi - phi)
x = theta / np.pi

A = []          # greedy supports
fracsum = []    # sum of 1/(k+2)
resid = []      # residual after the takes
for xi in x:
    a, r = greedy_support(xi, KMAX)
    A.append(a); fracsum.append(sum(1.0 / (k + 2) for k in a)); resid.append(r)

sign = (-1.0) ** (ns - 1)                 # alternating sign (-1)^{n-1}
ampl = ns ** (-SIGMA)                     # radial weight n^{-sigma}
w = sign * ampl                           # full per-term amplitude (off the unit circle)

sin_direct = np.sin(phi)
cos_direct = np.cos(phi)
sin_greedy = np.array([eps[i] * math.sin(math.pi * fracsum[i]) for i in range(NTERMS)])
cos_greedy = np.array([math.cos(math.pi * fracsum[i]) for i in range(NTERMS)])

Re_series = float(np.sum(w * cos_direct))
Im_series = float(-np.sum(w * sin_direct))
Re_greedy = float(np.sum(w * cos_greedy))
Im_greedy = float(-np.sum(w * sin_greedy))

# grouped sine components across the 100 terms
freq = Counter(k for a in A for k in a)
union = sorted(freq)
shared = sorted([k for k in union if freq[k] > 1], key=lambda k: (-freq[k], k))
private = sorted([k for k in union if freq[k] == 1])
order = shared + private           # grouped columns, most-shared first
col = {k: i for i, k in enumerate(order)}
K = len(order)
B = np.zeros((NTERMS, K), dtype=int)
for i, a in enumerate(A):
    for k in a:
        B[i, col[k]] = 1

# ------------------------------------------------------------------ print
print("=" * 100)
print("Complex Dirichlet eta at the first zeta zero  s = %.6f + i*%.15f" % (SIGMA, GAMMA1), file=sys.stderr)
print("  eta(s) = sum_{n>=1} (-1)^{n-1} n^{-s} = (1 - 2^{1-s}) zeta(s) ;  eta(s) = 0 here")
print("=" * 100)

print("\n--- Re (cos) and Im (sin) series, partial sums to M ---")
print("  M        Re eta_M              Im eta_M             |eta_M|")
for M in [10, 20, 50, 100, 200, 500, 1000, 5000, 20000, 100000, 500000, 2000000]:
    n2 = np.arange(1, M + 1, dtype=float)
    ph = np.mod(t * np.log(n2), 2 * np.pi)
    z = ((-1.0) ** (n2 - 1)) * n2 ** (-SIGMA) * np.exp(-1j * ph)
    p = z.sum()
    print(" %-9d % .10f   % .10f   %.4e" % (M, p.real, p.imag, abs(p)))

print("\n--- first 100 terms of the Im (sin) series ---")
print("  n   phi_n mod 2pi   eps  x_n = th/pi   A_n (greedy k)              sum 1/(k+2)   sin direct   sin greedy    err        weight (off circle)")
for i in range(NTERMS):
    a = A[i]
    astr = ",".join(str(k) for k in a) if a else "-"
    if len(astr) > 34:
        astr = astr[:31] + "..."
    print("%4d  % .10f  %+d  %.8f   %-34s %.8f   % .8f  % .8f  %.1e  %+.6f"
          % (int(ns[i]), phi[i], int(eps[i]), x[i], astr, fracsum[i],
             sin_direct[i], sin_greedy[i], abs(sin_direct[i] - sin_greedy[i]), w[i]))

print("\n--- reconstruction of the first 100 terms ---")
print(" max |sin greedy - sin direct| = %.3e   (bound pi*(K+2)^-1 = %.3e)"
      % (np.max(np.abs(sin_greedy - sin_direct)), math.pi / (KMAX + 2)))
print(" max greedy residual          = %.3e" % max(resid))
print(" Re eta_100 (direct / greedy) = % .10f / % .10f  (diff %.3e)"
      % (Re_series, Re_greedy, abs(Re_series - Re_greedy)))
print(" Im eta_100 (direct / greedy) = % .10f / % .10f  (diff %.3e)"
      % (Im_series, Im_greedy, abs(Im_series - Im_greedy)))
print(" mean |A_n| = %.3f   max |A_n| = %d   distinct fractions over 100 terms = %d"
      % (np.mean([len(a) for a in A]), max(len(a) for a in A), K))

print("\n--- independent check: eta by Euler transform of the alternating series ---")
s0 = complex(SIGMA, GAMMA1)
et = eta_euler(s0)
print(" eta(2) Euler = %.15f   exact pi^2/12 = %.15f" % (eta_euler(complex(2, 0)).real, math.pi ** 2 / 12), file=sys.stderr)
print(" eta(1) Euler = %.15f   exact log 2   = %.15f" % (eta_euler(complex(1, 0)).real, math.log(2)), file=sys.stderr)
print(" eta(1/2 + i*gamma_1) = %.3e %+.3ej   |eta| = %.3e   (=> eta = 0 at the zero)"
      % (et.real, et.imag, abs(et)), file=sys.stderr)
print(" the 100-term partial sum has |eta_100| = %.3e, so the first 100 terms are still %.0e"
      % (abs(complex(Re_series, Im_series)), abs(complex(Re_series, Im_series)))
      + " from the limit (the M^-1/2 tail at Re s = 1/2)")

print("\n--- why the radial weight n^-1/2 cannot be dropped (the terms are off the unit circle) ---")
Mlist = [10, 50, 100, 500, 2000, 10000]
print("  M     unweighted sum (-1)^(n-1) sin(phi_n)    weighted Im partial sum")
for M in Mlist:
    n2 = np.arange(1, M + 1, dtype=float)
    ph2 = np.mod(t * np.log(n2), 2 * np.pi)
    sg2 = np.sin(ph2)
    unw = float(np.sum(((-1.0) ** (n2 - 1)) * sg2))
    wei = float(np.sum(((-1.0) ** n2) * n2 ** (-SIGMA) * sg2))
    print(" %-6d % .6f                          % .6f" % (M, unw, wei))
print(" the unweighted sum does not settle (the unit-circle version diverges);")
print(" the n^-1/2 weight is what makes the Im series converge.")

print("\n--- the sine expansion unrolled for one term (n = 2, A_2 = %s, eps = %+d) ---"
      % (A[1], int(eps[1])))
odd = []
for r in range(1, len(A[1]) + 1, 2):
    for sub in itertools.combinations(A[1], r):
        s = set(sub); p = 1.0
        for k in A[1]:
            p *= math.sin(math.pi / (k + 2)) if k in s else math.cos(math.pi / (k + 2))
        odd.append(((-1) ** ((r - 1) // 2) * p, sorted(s)))
odd.sort(key=lambda t: -abs(t[0]))
print("  S (sine factors)          A \\ S (cosine factors)     term")
for v, sub in odd:
    comp = sorted(set(A[1]) - set(sub))
    print("  %-24s  %-24s  %+.9f" % ("{" + ",".join(map(str, sub)) + "}",
                                     "{" + ",".join(map(str, comp)) + "}", v))
print("  sum S = %+.9f ;  eps=-1 => sin phi_2 = %+.9f ;  direct = %+.9f"
      % (sum(v for v, _ in odd), -sum(v for v, _ in odd), math.sin(phi[1])))
print("  the singleton subsets containing index 1, 19 or 2357 vanish: 1/2 contributes cos(pi/2)=0")
print("  unless k=0 is a sine factor; the leading term is S = {0}.")

print("\n--- grouped greedy sine components (columns of the selector) ---")
print(" shared by >1 term: %d   private to one term: %d   total %d" % (len(shared), len(private), K))
print(" most-shared components (fraction : #terms):")
print("   " + "   ".join("%s:%d" % (frac(k), freq[k]) for k in shared[:20]))
print(" private components (k : fraction) grouped by term:")
for i in range(NTERMS):
    pv = sorted(k for k in A[i] if freq[k] == 1)
    if pv:
        print("   n=%3d : %s" % (int(ns[i]), "  ".join("%s(k=%d)" % (frac(k), k) for k in pv)))

print("\n--- boolean selectors of the 100 terms (grouped columns: %d most-shared, then %d private) ---"
      % (len(shared), len(private)))
hdr = "".join("|" if k in shared else "." for k in order)
print("     " + hdr + "   ('|' = shared component, '.' = private)")
for i in range(NTERMS):
    row = "".join(str(B[i, j]) for j in range(K))
    print("n=%3d %s" % (int(ns[i]), row))

print("\ncolumn legend (grouped order):")
print("  shared:  " + "  ".join("%s" % frac(k) for k in shared))
print("  private: " + "  ".join("%s" % frac(k) for k in private))

print("\n--- compact selector matrix: only the %d components shared by >1 term ---" % len(shared))
print("  n  " + "".join("%3d" % (k + 2) for k in shared))
print("     " + "---" * len(shared))
for i in range(NTERMS):
    print("%4d " % int(ns[i]) + "".join("%3d" % B[i, col[k]] for k in shared))
print("  (column headers are denominators d of the fraction 1/d; each row is the 0/1 selector of term n)")

# machine-readable full selector: rows = n, columns = all 196 fractions in increasing k
tsv = os.path.join(HERE, "eta_selectors.tsv")
with open(tsv, "w") as fh:
    fh.write("n\t" + "\t".join(frac(k) for k in union) + "\n")
    for i in range(NTERMS):
        Aset = set(A[i])
        fh.write("%d\t" % int(ns[i]) + "\t".join("1" if k in Aset else "0" for k in union) + "\n")
print("\nfull selector matrix written to", tsv, "(columns in increasing k)")

# ------------------------------------------------------------------ figure
FONT = "/System/Library/Fonts/Supplemental/Arial.ttf"
def F(s):
    try:
        return ImageFont.truetype(FONT, s)
    except Exception:
        return ImageFont.load_default()
f10, f11, f12, f14, f16, f26 = F(11), F(12), F(13), F(16), F(18), F(32)

W, H = 1660, 1240
img = Image.new("RGB", (W, H), (255, 255, 255))
d = ImageDraw.Draw(img)
d.text((40, 20), "The Dirichlet eta function at the first zeta zero: Im (sin) series as greedy-harmonic boolean selectors",
       font=f26, fill=(10, 10, 10))
d.text((40, 62), "s = 1/2 + i*14.1347251417346938   eta(s) = 0   Im eta = -sum_n (-1)^(n-1) n^-1/2 sin(t log n),  sin(t log n) = eps_n sin(pi*sum_{k in A_n} 1/(k+2))",
       font=f10, fill=(80, 80, 80))

# ---- A: Re/Im partial sums
ax, ay, aw, ah = 50, 150, 470, 260
d.rectangle([ax, ay, ax + aw, ay + ah], outline=(40, 40, 40))
d.text((ax, ay - 30), "A.  Re (cos) and Im (sin) series of eta, partial sums to M", font=f16, fill=(10, 10, 10))
Ms = [10, 20, 50, 100, 200, 500, 1000, 5000, 20000, 100000, 500000, 2000000]
ReM, ImM = [], []
for M in Ms:
    n2 = np.arange(1, M + 1, dtype=float)
    ph = np.mod(t * np.log(n2), 2 * np.pi)
    z = ((-1.0) ** (n2 - 1)) * n2 ** (-SIGMA) * np.exp(-1j * ph)
    p = z.sum(); ReM.append(p.real); ImM.append(p.imag)
lim = 0.20
lxa = lambda M: ax + (math.log10(M) - 1) / (math.log10(Ms[-1]) - 1) * aw
lya = lambda v: ay + ah / 2 - (v / lim) * (ah / 2)
d.line([ax, lya(0), ax + aw, lya(0)], fill=(120, 120, 120))
for v in [-0.2, -0.1, 0.1, 0.2]:
    d.line([ax, lya(v), ax + aw, lya(v)], fill=(238, 238, 238))
    d.text((ax - 30, lya(v) - 7), "%+.1f" % v, font=f10, fill=(90, 90, 90))
for M in [10, 100, 10000, 1000000]:
    d.line([lxa(M), ay, lxa(M), ay + ah], fill=(242, 242, 242))
    d.text((lxa(M) - 14, ay + ah + 6), "%g" % M, font=f10, fill=(90, 90, 90))
ptsR = [(lxa(M), lya(v)) for M, v in zip(Ms, ReM)]
ptsI = [(lxa(M), lya(v)) for M, v in zip(Ms, ImM)]
for i in range(len(Ms) - 1):
    d.line([ptsR[i], ptsR[i + 1]], fill=(20, 60, 140), width=3)
    d.line([ptsI[i], ptsI[i + 1]], fill=(185, 95, 30), width=3)
for p in ptsR: d.ellipse([p[0] - 3, p[1] - 3, p[0] + 3, p[1] + 3], fill=(20, 60, 140))
for p in ptsI: d.ellipse([p[0] - 3, p[1] - 3, p[0] + 3, p[1] + 3], fill=(185, 95, 30))
d.text((ax + 8, ay + 8), "blue = Re (cos series)   orange = Im (sin series)", font=f11, fill=(60, 60, 60))
d.text((ax + 8, ay + 26), "both -> 0 like M^-1/2 (conditional, no prefactor needed: eta is the", font=f10, fill=(100, 100, 100))
d.text((ax + 8, ay + 42), "convergent alternating handle for Re s > 0)", font=f10, fill=(100, 100, 100))
d.text((ax, ay + ah + 24), "at M = 100:  Re = %+.6f   Im = %+.6f" % (Re_series, Im_series), font=f11, fill=(70, 70, 70))

# ---- B: term amplitudes are off the unit circle
bx, by, bw, bh = 570, 150, 320, 260
d.rectangle([bx, by, bx + bw, by + bh], outline=(40, 40, 40))
d.text((bx, by - 30), "B.  the Im terms are not on the unit circle", font=f16, fill=(10, 10, 10))
lxb = lambda n: bx + (n - 1) / (NTERMS - 1) * bw
lyb = lambda v: by + bh - (v / 1.05) * bh
for v in [0, 0.25, 0.5, 0.75, 1.0]:
    d.line([bx, lyb(v), bx + bw, lyb(v)], fill=(238, 238, 238))
    d.text((bx - 32, lyb(v) - 7), "%.2f" % v, font=f10, fill=(90, 90, 90))
d.line([bx, lyb(1.0), bx + bw, lyb(1.0)], fill=(200, 60, 60))
d.text((bx + bw - 118, lyb(1.0) + 4), "unit circle  r = 1", font=f10, fill=(200, 60, 60))
for i in range(NTERMS):
    r = ampl[i]
    c = (20, 60, 140) if sign[i] > 0 else (185, 95, 30)
    d.ellipse([lxb(ns[i]) - 2.5, lyb(r) - 2.5, lxb(ns[i]) + 2.5, lyb(r) + 2.5], fill=c)
d.text((bx + 6, by + 8), "radius n^-1/2, never 1:", font=f11, fill=(60, 60, 60))
d.text((bx + 6, by + 24), "blue = sign +, orange = sign -", font=f10, fill=(100, 100, 100))
d.text((bx + 6, by + 40), "word supplies phase only", font=f10, fill=(100, 100, 100))

# ---- C: selector matrix
cx0, cy0 = 940, 150
cw, ch = 660, 470
cellw = cw / K
cellh = ch / NTERMS
d.rectangle([cx0 - 1, cy0 - 1, cx0 + cw + 1, cy0 + ch + 1], outline=(40, 40, 40))
d.text((cx0, cy0 - 30), "C.  boolean selectors delta_k of the greedy sine decomposition (100 terms x %d components)" % K,
       font=f14, fill=(10, 10, 10))
for i in range(NTERMS):
    for j in range(K):
        if B[i, j]:
            c = (20, 70, 165) if order[j] in shared else (60, 150, 90)
            d.rectangle([cx0 + j * cellw, cy0 + i * cellh,
                         cx0 + (j + 1) * cellw - 0.4, cy0 + (i + 1) * cellh - 0.4], fill=c)
d.line([cx0 + len(shared) * cellw, cy0, cx0 + len(shared) * cellw, cy0 + ch], fill=(210, 40, 40), width=2)
d.text((cx0 - 30, cy0 + 2), "n=1", font=f10, fill=(90, 90, 90))
d.text((cx0 - 42, cy0 + ch - 12), "n=100", font=f10, fill=(90, 90, 90))
d.text((cx0 + 4, cy0 + ch + 6), "blue = component shared by >1 term (%d)      green = private to one term (%d)"
       % (len(shared), len(private)), font=f11, fill=(60, 60, 60))
d.text((cx0 - 30, cy0 + ch + 26), "columns: most-shared first (1/2, 1/3, 1/4, ...), then private in k order; red line separates the two groups",
       font=f10, fill=(100, 100, 100))
# label every 5th shared column with its fraction
for j in range(0, len(shared), 5):
    k = order[j]
    d.text((cx0 + j * cellw - 6, cy0 - 14), "1/%d" % (k + 2), font=f10, fill=(90, 90, 90))

# ---- D: component frequency
dx0, dy0, dw, dh = 50, 700, 470, 250
d.rectangle([dx0, dy0, dx0 + dw, dy0 + dh], outline=(40, 40, 40))
d.text((dx0, dy0 - 30), "D.  how often each greedy sine component is selected", font=f16, fill=(10, 10, 10))
ks = sorted(union, key=lambda k: -freq[k])[:24]
mx = max(freq.values())
bwid = dw / len(ks)
for i, k in enumerate(ks):
    h = freq[k] / mx * (dh - 30)
    c = (20, 70, 165) if freq[k] > 1 else (60, 150, 90)
    d.rectangle([dx0 + i * bwid + 3, dy0 + dh - h, dx0 + (i + 1) * bwid - 3, dy0 + dh], fill=c)
    if i % 2 == 0:
        d.text((dx0 + i * bwid + 1, dy0 + dh + 4), "%d" % (k + 2), font=f10, fill=(80, 80, 80))
d.text((dx0 + 8, dy0 + 8), "x label = denominator of the fraction 1/(k+2);  top = %d terms (1/2)" % mx, font=f11, fill=(60, 60, 60))
d.text((dx0 + 8, dy0 + 24), "%d of %d components are used by exactly one term" % (len(private), K), font=f11, fill=(60, 60, 60))

# ---- E: reconstruction error
ex0, ey0, ew, eh = 570, 700, 470, 250
d.rectangle([ex0, ey0, ex0 + ew, ey0 + eh], outline=(40, 40, 40))
d.text((ex0, ey0 - 30), "E.  greedy sine reconstruction error per term", font=f16, fill=(10, 10, 10))
err = np.abs(sin_greedy - sin_direct)
lye = lambda v: ey0 + eh - (math.log10(max(v, 1e-16)) + 7) / 7 * eh
for dec in range(-7, 1):
    d.line([ex0, lye(10.0 ** dec), ex0 + ew, lye(10.0 ** dec)], fill=(238, 238, 238))
    d.text((ex0 - 30, lye(10.0 ** dec) - 7), "1e%d" % dec, font=f10, fill=(90, 90, 90))
lxe = lambda n: ex0 + (n - 1) / (NTERMS - 1) * ew
for i in range(NTERMS):
    d.ellipse([lxe(ns[i]) - 2, lye(max(err[i], 1e-16)) - 2, lxe(ns[i]) + 2, lye(max(err[i], 1e-16)) + 2],
              fill=(120, 40, 140))
d.text((ex0 + 8, ey0 + 8), "max error = %.2e;  bound pi/(K+2) = %.2e" % (err.max(), math.pi / (KMAX + 2)), font=f11, fill=(110, 40, 130))
d.text((ex0 + 8, ey0 + 24), "error = truncation, tracked by the residual r_n", font=f10, fill=(100, 100, 100))

# ---- F: text summary
fx0, fy0 = 1090, 700
d.text((fx0, fy0 - 30), "F.  the identity in one block", font=f16, fill=(10, 10, 10))
lines = [
    "eta(s) = sum_{n>=1} (-1)^(n-1) n^{-s}",
    "       = Re eta + i Im eta",
    "",
    "Re eta =  sum_n (-1)^(n-1) n^-1/2 cos(t log n)",
    "Im eta = -sum_n (-1)^(n-1) n^-1/2 sin(t log n)",
    "",
    "sin(t log n) = eps_n sin( pi sum_{k in A_n} 1/(k+2) )",
    "A_n = { k : delta_k(theta_n) = 1 }   (greedy digits)",
    "",
    "delta_k in {0,1} are the boolean selectors",
    "(0 excluded, 1 included) shown in panel C.",
    "",
    "at s = 1/2 + i*14.134725...:  eta = 0,",
    "so both series must cancel; the Im selector",
    "rows are what the greedy sine sum reads.",
]
for i, s in enumerate(lines):
    col = (10, 10, 10) if i < 6 else (60, 60, 60)
    d.text((fx0, fy0 + i * 16), s, font=f11, fill=col)

out = os.path.join(HERE, "eta_cos_sin.png")
img.save(out)
print("\nfigure written to", out)
