# First interval-certified analytic Gram entry

**Status:** priority item 1 is achieved for **one entry**: the Gaussian
diagonal \(W(0)\) is enclosed in a certified interval of width
\(4.89\cdot10^{-4}\). This is a numerical certificate in Python, not a Lean
proof; the Gram matrix as a whole is not certified, and no RH proof yet.

## 1. The result

For the Gaussian test \(\varphi_0(u)=e^{-u^2/(2\sigma^2)}\), \(\sigma=0.05\),
and the sibling cosh \(+\Omega\) convention,

\[
W(0)\in[0.042891644586498155,\;0.04338028696327071],
\qquad \text{width }4.89\cdot10^{-4}.
\]

The high-precision value \(0.0431359584\) lies inside. The computation is
`gaussian_W0_interval` in
[`../python/rescue_probe.py`](../python/rescue_probe.py); the test is
`test_gaussian_W0_interval_certificate`.

## 2. Method

1. **Fast certified \(\Omega\).** `omega_fast(t)` uses the recurrence
   \(\psi(z)=\psi(z+N)-\sum_{k<N}1/(z+k)\) with \(N=1000\), Binet's integral
   \[
   \psi(w)=\log w-\frac{1}{2w}
   -2\int_0^\infty\frac{u\,du}{(u^2+w^2)(e^{2\pi u}-1)},
   \]
   and the bound \(|u^2+w^2|\ge 3a^2/4\) (\(a=\operatorname{Re}w\)),
   giving a remainder \(\le 1/(9a^2)=1.1\cdot10^{-7}\). Width \(2.2\cdot10^{-7}\)
   at \(0.01\) s per point.
2. **Pole.** \(4\pi\sigma^2e^{\sigma^2/4}\) in interval arithmetic.
3. **Prime.** The exact finite sum \(n=2,\dots,7\); the tail beyond \(n=7\) is
   below \(10^{-100}\) because the Gaussian exponent at \(\log 8\) is
   \(-432\).
4. **Density.** \(\sigma^2\int_{\mathbb R}e^{-\sigma^2t^2}\Omega(t)\,dt\)
   by the midpoint rule on \([0,T]\) with \(T=100\), \(h=0.01\), doubled for
   the even integral. The quadrature error is
   \(2\cdot(h^2/2)\int|f'|\), bounded by
   \(\sigma^2[M+L\sqrt\pi/(2\sigma)]\) with \(M=800\), \(L=10\).
   Error \(2.44\cdot10^{-4}\); the Gaussian tail beyond \(100\) is
   \(<10^{-12}\).

The dominant error is the midpoint quadrature; halving \(h\) quarters it
(\(\sim4.9\cdot10^{-4}\) to \(\sim1.2\cdot10^{-4}\)).

## 3. Rigour ledger

| ingredient | status |
|---|---|
| Binet identity and \(|u^2+w^2|\) bound | text proof, numerically checked |
| \(M=800\), \(L=10\) on \([0,100]\) | from the digamma series bound \(\lvert\psi\rvert\le\gamma+14.60(3/4+t/2)\) and \(\lvert\psi'\rvert\le20\) |
| interval arithmetic | `mpmath.iv`, with declared intervals for \(\pi\) and \(\log\pi\) |
| Lean-checked | only the PSD algebra (`two_by_two_pos`, `quadForm_perturb`), not this computation |

This is a numerical certificate with explicit bounds, not a Lean theorem.
The declared \(\pi\)/\(\log\pi\) intervals are the only non-library constants.

## 4. What this does and does not certify

- **Certifies:** one diagonal entry of the Gaussian Gram, to width
  \(4.9\cdot10^{-4}\).
- **Does not certify:** the off-diagonal entries, the positive semidefinite
  matrix, the compact-support Gram, or anything on the critical line. (The
  compact-support diagonal now has a wide interval of its own, note 47.)
- The sibling's certified Gaussian matrix has margin \(0.0227\); a \(2\times2\)
  or \(4\times4\) interval certificate is now within reach with the same
  machinery, since the entry width is \(5\cdot10^{-4}\ll0.02\).

## 5. Round 14: the matrix certificates

The entries are computed in one shared density pass; the 2×2 and 4×4 Gaussian
Gram matrices are then certified by centre-plus-slack with exact rational
leading minors.

**Correction found during the assembly.** The first version did not
symmetrise the interval entries: `W(c)` and `W(-c)` differ by about
`1.6e-5` in the interval arithmetic, so the matrix was not symmetric and the
leading-minor test was invalid. After replacing each entry by
`(W(c) + W(-c))/2`, both matrices certify:

| matrix | slack \(t\) | leading minors | verdict |
|---|---|---|---|
| \(2\times2\) | \(0.00762636\) | \(0.0355096,\ 0.00119656\) | CERTIFIED |
| \(4\times4\) | \(0.02092457\) | \(0.0222114,\ 2.2145\cdot10^{-4},\ 1.8127\cdot10^{-6},\ 1.4723\cdot10^{-8}\) | CERTIFIED |

The 4×4 smallest minor is thin (\(1.5\cdot10^{-8}\)), but it is an exact
rational check against the interval centres, and the `1e-9` slack covers the
float conversion.

A **6×6** basis \((-0.5,-0.3,-0.1,0.1,0.3,0.5)\), with \(h=0.01\), \(T=80\),
also certifies at slack \(t=0.0121006\); the leading minors are
\(0.031035,\ 6.913\cdot10^{-4},\ 1.538\cdot10^{-5},\ 3.404\cdot10^{-7},6.825\cdot10^{-9},\ 1.018\cdot10^{-10}\). The last is thin but exact.

An **8×8** basis, centres \(-0.5,-0.357,\dots,0.5\), certifies at
\(h=0.0025\), \(T=80\) (about 6 minutes): slack \(0.0010084\), leading
minors
\(0.042128,\ 1.186\cdot10^{-3},\ 2.309\cdot10^{-5},\ 4.150\cdot10^{-7},\)
\(6.236\cdot10^{-9},\ 8.990\cdot10^{-11},\ 1.227\cdot10^{-12},\ 1.576\cdot10^{-14}\).
At \(h=0.005\) the same computation **just misses**: slack
\(0.0040336\) against the margin \(0.004006\), last minor
\(-9\cdot10^{-18}\). Halving \(h\) suffices.

**Lean.** `gauss2_shadow_psd` in [`../lean/Shadow.lean`](../lean/Shadow.lean)
proves the rounded rational shadow of the 2×2 centre-minus-slack form is
positive semidefinite. Together with `quadForm_perturb`, the finite inference
"interval entries ⇒ PSD" is Lean-checked once the entry enclosures are
accepted. The enclosures themselves are the Python certificate above, not a
Lean theorem.

## 6. Outcome and next

1. The \(2\times2\) and \(4\times4\) Gaussian Gram matrices are certified; the
   \(4\times4\) case is the largest automated test.
2. The \(6\times6\) certificate was recomputed at \(h=0.005\), \(T=100\):
   uncertainty \(t=2.49\cdot10^{-3}\), smallest leading minor
   \(2.37\cdot10^{-10}>0\). A tighter run at \(h=0.004\), \(T=100\) gives
   \(t=1.60\cdot10^{-3}\), smallest minor \(3.33\cdot10^{-10}>0\) (round
   143); at \(h=0.003\), \(T=100\) it gives \(t=8.98\cdot10^{-4}\),
   smallest minor \(4.25\cdot10^{-10}>0\) (round 173). The \(h=0.004\)
   data are saved in [`python/gram6_certificate.json`](../python/gram6_certificate.json)
   (round 180), with a test rechecking the box certificate. Because the
   margin is only \(\sim4\cdot10^{-10}\), a rational Lean instance would be
   numerically fragile; the Lean finite cone-positivity certificates are the
   2×2 and 4×4 rungs, whose margins are \(\sim10^{-2}\). Wider centre sets do
   not help: at \(h=0.008\) the sets \(\{\pm0.16,\pm0.48,\pm0.8\}\) and
   \(\{\pm0.12,\pm0.36,\pm0.6\}\) give margins \(-3.2\cdot10^{-11}\) and
   \(+7.4\cdot10^{-12}\), i.e. the 6×6 Gaussian family is intrinsically
   near-singular. The margin remains thin, so this is a one-off certificate, not a
   default test. At \(h=0.02\), \(T=80\) the interval width exceeds the
   margin and the check fails (round 132).
3. The compact-support cosh \(+\Omega\) basis margin
   \(2.5\cdot10^{-5}\) needs the tighter setting; the compact diagonal is
   certified, the off-diagonal is not.
4. **The margin collapses** (note 45): the compact-support spectrum reaches
   zero by \(n=5\), and the Gaussian margin shrinks with the basis. The
   compact-support interval certificate by centre-plus-slack is therefore not
   the route to the cone.
5. No RH proof yet.

[Back to the dossier](../README.md) · [Interval status](42-interval-status.md) ·
[Certified-density blockade](43-certified-density-blockade.md) ·
[Research journal](../research-journal.md)
