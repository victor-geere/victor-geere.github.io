# First compact-support interval entry

**Status:** the compact-support diagonal \(W_{00}\) is now enclosed in a valid
interval, but a **wide** one:

\[
W_{00}\in[-0.0022613,\;0.0026321],\qquad \text{width }4.89\cdot10^{-3},
\]

containing the exact value \(2.1468806878830666\cdot10^{-4}\). This is a
numerical certificate in Python, not a Lean proof. It is not tight enough for
positive-definiteness at the \(2.5\cdot10^{-5}\) margin, and no RH proof yet.

## 1. Decomposition

| term | value | status |
|---|---|---|
| pole | \(3.737190272\) | exact closed form \(1280\cosh1-1024\sinh1-768\) |
| prime | \(-1.118091418\) | exact finite sum \(n=2,\dots,7\); tail \(<10^{-100}\) |
| arch centre | \(-2.618913474\) | midpoint rule \(h=0.002\), \(T=40\) |
| quadrature error | \(5.27\cdot10^{-4}\) | \(h^2/2\int|f'|\) majorant |
| tail majorant | \(1.92\cdot10^{-3}\) | beyond \(T=40\) |

The dominant error is the **tail majorant**, not the quadrature.

## 2. Method

- \(h(x)=F_0*F_{0-}(x)=-x^5/30+2x^3/3-4x^2/3+16/15\) on \([0,2]\).
- Pole: \(\int_0^2 h\cosh(x/2)\) in closed form.
- Prime: \(-2\sum_{n=2}^7\Lambda(n)n^{-1/2}h(\log n)\), evaluated in interval
  arithmetic. The tail beyond \(n=7\) is below \(10^{-100}\) because
  \(\log 8>2\) exceeds the support.
- Arch: \((1/\pi)\int_0^\infty\hat F_0^2\Omega\) by the midpoint rule, with
  \(\hat F_0(t)=4(\sin t-t\cos t)/t^3\), the fast certified \(\Omega\)
  (`omega_fast`, width \(2.2\cdot10^{-7}\)), and the majorant
  \[
  |f'|\le 2B_0B_1M+B_0^2L,\quad
  B_0=\min(4/3,4(1+t)/t^3),\quad
  B_1=\begin{cases}2,&t\le1,\\4(t^2+3t+3)/t^4,&t>1,\end{cases}
  \]
  with \(M=5.872\) a certified bound on \(|\Omega|\) over \([0,40]\)
  (grid plus the \(\lvert\Omega'\rvert\le10\) Lipschitz bound) and \(L=10\).
- Error \(=h^2/2\int_0^\infty|f'|\); the tail integral is bounded separately.

## 3. What this certifies

- **Certifies:** one compact-support diagonal entry, to width
  \(4.9\cdot10^{-3}\).
- **Does not certify:** the off-diagonal entries, PSD, or any critical-line
  statement.
- The width is about \(200\) times the \(2.5\cdot10^{-5}\) margin of the
  adjacent \(2\times2\) block, so this does not yield a PSD certificate.

## 4. Why the width is large, and what tightening would take

The tail majorant \(1.92\cdot10^{-3}\) dominates: the crude \(B_0B_1\)
bounds overestimate the decaying integrand beyond \(T\). A sharper tail
integral (or a larger \(T\)) would reduce it. The quadrature error can be
reduced by halving \(h\). Neither changes the structural conclusion of note
45: the compact-support margin collapses, so a tight entry does not by itself
give the cone.

## 5. Tighter run

With \(h=0.001\), \(T=100\) (about 18 minutes):

\[
W_{00}\in[-3.80\cdot10^{-5},\;4.63\cdot10^{-4}],
\qquad \text{width }5.01\cdot10^{-4},
\]

again containing the exact value. The width is ten times smaller, but the
lower bound is still negative, so **positivity is not certified**. The
remaining errors are the quadrature majorant \(1.32\cdot10^{-4}\) and the
tail majorant \(1.19\cdot10^{-4}\); the crude \(B_0B_1\) envelope, not the
true integrand, controls the tail.

## 6. Certified positivity (hybrid grid)

A hybrid grid — fine \(h=0.001\) on \([0,100]\), coarse \(h=0.01\) on
\([100,400]\), sharp tail beyond \(400\) — gives

\[
W_{00}\in[4.436\cdot10^{-5},\;3.861\cdot10^{-4}],
\qquad \text{width }3.42\cdot10^{-4},
\]

with **positive lower bound**. The exact value lies inside. Errors:
quadrature \(1.69\cdot10^{-4}\), tail \(2.16\cdot10^{-6}\); the certified
\(|\Omega|\) bound on \([0,400]\) is \(7.872\). Runtime about 23 minutes.

This is the first **positivity** certificate on the compact-support rung
(a \(1\times1\) statement). It does not certify the matrix, and the margin
collapse still blocks the cone.

## 7. Bottom line

- The compact-support rung now has an interval-certified **positive entry**
  \(W_{00}>0\), alongside the tight Gaussian entries of note 44.
- It is not a PSD certificate and does not approach the cone.
- No RH proof yet.

[Back to the dossier](../README.md) · [Gaussian interval entries](44-first-interval-entry.md) ·
[Margin collapse](45-margin-collapse.md) · [Research journal](../research-journal.md)
