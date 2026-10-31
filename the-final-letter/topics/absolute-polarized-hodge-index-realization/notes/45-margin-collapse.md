# The margin collapse: finite certificates do not reach the cone

**Status:** a negative structural result. As the test basis grows, the
smallest eigenvalue of the finite Weil Gram collapses toward zero:

- compact support: \(1.28\cdot10^{-9}\ (n=4)\to0\ (n=5)\to0\ (n=6)\);
- Gaussian: \(0.0227\ (n=4)\to0.0167\ (n=6)\to0.0040\ (n=8)\).

Centre-plus-slack interval certification needs a positive margin. There is no
uniform margin, so no finite certificate of this kind upgrades to the cone.
No RH proof yet.

## 1. The measurements

**Compact support**, basis \(F_k=(1-x^2)_+x^{2k}\), exact cosh \(+\Omega\)
Gram (closed-form transforms, `mp.quad` on \([0,\infty)\), exact finite prime
sum), `dps=25`:

| \(n\) | smallest eigenvalues |
|---|---|
| 4 | \(1.28\cdot10^{-9},\ 1.11\cdot10^{-7},\ 9.96\cdot10^{-5},\ 1.67\cdot10^{-3}\) |
| 5 | \(0,\ 3.2\cdot10^{-9},\ 6.88\cdot10^{-7},\ 1.21\cdot10^{-4},\ 2.32\cdot10^{-3}\) |
| 6 | \(0,\ 3.0\cdot10^{-10},\ 3.6\cdot10^{-9},\ 2.56\cdot10^{-6},\ 1.31\cdot10^{-4},\ 2.88\cdot10^{-3}\) |

The zero is at the numerical floor; the near-zero eigenvalues shrink as the
basis grows. The form is numerically **singular**.

**Gaussian**, centres spread over \([-0.5,0.5]\):

| \(n\) | smallest eigenvalue |
|---|---|
| 4 | \(0.0227\) |
| 6 | \(0.0167\) |
| 8 | \(0.0040\) |
| 10 | \(2.41\cdot10^{-4}\) |

Here the entries are positive definite, but the margin shrinks as the
centres densify. By \(n=10\) it is \(2.41\cdot10^{-4}\), below the interval
slack (about \(10^{-3}\)) at the resolution that certified \(n=8\); a
\(10\times10\) interval certificate would need a much finer grid and is not
attempted. (The 8-point value uses the sibling routine with its finite
\(T\); the trend is indicative, not certified.)

### High-precision confirmation

The small eigenvalues are not a precision floor:

| \(n\) | `dps` | smallest eigenvalue |
|---|---|---|
| 4 | 40 | \(1.2828\cdot10^{-9}\) |
| 4 | 50 | \(1.282875514106\cdot10^{-9}\) |
| 5 | 40 | \(7.891\cdot10^{-12}\) |
| 6 | 25 | \(<10^{-12}\) |

The `dps=40` and `dps=50` values for \(n=4\) agree to the displayed digits, so
the \(10^{-9}\) margin is real. The corresponding eigenvectors are broad, not
sparse: for \(n=4\),
\((-0.288,0.722,-0.607,0.169)\); for \(n=5\),
\((-0.054,0.334,-0.693,0.607,-0.195)\). There is no simple sparse kernel
vector to project out.

## 2. Why this blocks the finite-certificate route

The interval PSD certificates of notes 44 use

\[
G\in G_0+[-t,t],\qquad G_0-tI\succ0,
\]

with rational leading minors. They certify **positive definiteness** of
\(G_0-tI\). If the true smallest eigenvalue is \(0\) (or below the slack),
there is no \(t>0\) for which \(G_0-tI\) is positive definite, and the method
fails. More generally, a shrinking margin means the slack must shrink with
the basis, so the certificates do not converge uniformly.

The finite algebra of this is Lean-checked: `hodge_index_equality_kernel`
says that a vanishing discriminant forces a kernel direction, and
`margin_nonincrease` says that enlarging the test set cannot increase the
margin. The collapse is a structural order-theoretic fact, not a numerical
accident.

The cone positivity is a statement about the **whole** test space. A sequence
of finite positive-definite Gram matrices with margins tending to zero does
not imply it: the limit form may be only semidefinite, with a kernel. The
missing input is a **kernel/rank analysis** of the limit form, not a larger
certificate.

## 3. What survives

- The Gaussian \(2\times2\), \(4\times4\), \(6\times6\) interval certificates
  are valid for those finite bases (notes 44).
- The exact identities (archimedean contour, symbol, functional equation,
  zero pairing, critical-line symmetry) are unaffected.
- The structural conclusion: the finite Gram route reaches only the
  semidefinite edge; it cannot close the cone.

## 4. What this means for the programme

This is the precise wall behind the earlier "no uniform gap" diagnostics. The
programme can keep producing finite certificates, but they will not approach
the cone positivity; the RH step needs a global positivity theorem (Weil's
criterion) or a kernel/rank theorem for the limit form. Neither is currently
available.

## 5. Bottom line

- The finite-rung margin collapses; finite **positive-definite** certificates
  do not upgrade to the cone.
- The compact-support form is numerically singular by \(n=5\).
- No RH proof yet.

[Back to the dossier](../README.md) · [Interval certificates](44-first-interval-entry.md) ·
[Lean core](../lean/README.md) · [Research journal](../research-journal.md)
