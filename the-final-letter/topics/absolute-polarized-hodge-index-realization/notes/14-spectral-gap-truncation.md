# Spectral gap and truncation

> **Truncation diagnostic.** This note studies finite compressions, not the
> full-space spectral gap. It is superseded as evidence about the gap by
> [`22-continuum-gap.md`](22-continuum-gap.md).

**Status:** a numerical obstruction to a naive passage to the infinite limit.
For even basis size the degree-zero Hodge-index form is negative definite, but
its gap decreases with the basis size; for odd basis size the projected
symplectic form has a zero mode and the construction is undefined. This is a
precise condition on the global limit, not a no-go.

## 1. Method

For basis size \(K\), the fast CCM matrix of
[`09-ccm-pairing-probe.md`](09-ccm-pairing-probe.md) is orthonormalised with
the \(L^2\) Gram, projected onto the two degree-zero constraints, and reduced
to the antisymmetric form

\[
\widetilde\Omega_p=C^{T}\widetilde\Omega\,C.
\]

If \(\widetilde\Omega_p\) is invertible, the Hodge-index form is

\[
R_p=\widetilde\Omega_p U_p
=-(-\widetilde\Omega_p^2)^{1/2},
\]

whose eigenvalues are the negatives of the antisymmetric spectrum
\(\mu_1,\dots,\mu_{K-2}\).  The **gap** is \(\min_j\mu_j\).

## 2. The table

| \(K\) | dim | \(\mu\) spectrum | gap | status |
|---|---|---|---|---|
| 4 | 2 | \(0.415,0.415\) | \(0.415\) | negative definite |
| 5 | 3 | \(0,0.624,0.624\) | \(0\) | **degenerate** |
| 6 | 4 | \(0.250,0.250,0.836,0.836\) | \(0.250\) | negative definite |
| 7 | 5 | \(0,0.444,\dots\) | \(0\) | **degenerate** |
| 8 | 6 | \(0.191,0.191,0.603,0.603,1.280,1.280\) | \(0.191\) | negative definite |
| 10 | 8 | \(0.166,0.166,0.504,0.504,0.850,0.850,1.401,1.401\) | \(0.166\) | negative definite |

The even-\(K\) gaps decrease:

\[
0.415\ (K=4)\ \longrightarrow\ 0.250\ (K=6)\ \longrightarrow\
0.191\ (K=8)\ \longrightarrow\ 0.166\ (K=10).
\]

The successive ratios are

\[
0.60,\quad 0.76,\quad 0.87,
\]

so the decay is **slowing**.  A positive limit \(g_\infty>0\) is not
excluded by these four points.

The odd-\(K\) cases have a zero mode: \(\widetilde\Omega_p\) is singular, the
invertibility hypothesis of
[`13-orthonormal-degree-zero.md`](13-orthonormal-degree-zero.md) fails, and
\(R_p\) is not defined on the kernel.

## 3. Interpretation

- The finite Hodge-index sign is **not uniform** in the truncation.  The gap
  shrinks as the basis grows, so the negative definiteness of each finite
  \(R_p\) does not by itself give a uniform negative-definite limit.
- The odd-\(K\) zero mode shows that the degree-zero subspace and the
  truncation must be chosen so that the symplectic form is nondegenerate.
  A careless truncation produces a spurious kernel.
- Passing to the infinite Bost–Connes limit therefore requires one of:
  1. a proof of a **uniform lower bound** \(\min\mu_j\ge\epsilon>0\);
  2. a renormalisation or a restriction to a nondegenerate subspace;
  3. accepting only **negative semidefiniteness** in the limit.

The data show a decreasing gap with a slowing decay.  They are consistent
with a positive limit, but they do not prove one.  The correct conclusion is
that the uniform-gap question is **open**, not that a uniform gap is ruled
out.  The earlier reading of the \(K=4,6,8\) points as evidence for collapse
was too strong.

For \(K\ge12\) the \(L^2\) Gram becomes numerically singular in double
precision (the smallest eigenvalue underflows the inverse square root), so
the present truncation cannot decide the limit.  A higher-precision or
orthogonal basis is needed.

## 4. What this does not say

It does not rule out a different truncation, a different polarization, or a
different degree-zero subspace with a uniform gap.  It does not decide
whether the present even-\(K\) truncations have a uniform positive gap.  The
\(K=10\) point weakens the collapse reading.  No RH conclusion is drawn.

## 5. Numerical check

[`../python/truncation_gap.py`](../python/truncation_gap.py) computes the
table.  The tests in
[`../tests/test_truncation_gap.py`](../tests/test_truncation_gap.py) assert
the even-\(K\) negative definiteness, the odd-\(K\) zero mode, and the decrease
of the gap from \(K=4\) to \(K=6\).

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[Orthonormal degree-zero](13-orthonormal-degree-zero.md)
