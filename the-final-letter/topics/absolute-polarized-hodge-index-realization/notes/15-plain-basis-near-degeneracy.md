# Plain basis and the near-degeneracy at \(K=16\)

> **Truncation diagnostic.** This note studies finite compressions, not the
> full-space spectral gap. It is superseded as evidence about the gap by
> [`22-continuum-gap.md`](22-continuum-gap.md).

**Status:** a better-conditioned truncation that reaches \(K=20\) and reveals
genuine near-degeneracies. The gap is not monotone and drops to about
\(0.037\) at \(K=16\); this is stable under quadrature refinement. A uniform
positive gap is therefore not established by the truncations, though it is
not disproved.

## 1. Why change the basis

The windowed basis

\[
F_k(x)=\sin\!\left(\frac{k\pi x}{2A}\right)\cos\!\left(\frac{\pi x}{2A}\right)
\]

has a rapidly ill-conditioned \(L^2\) Gram: for \(K\ge12\) the smallest
eigenvalue underflows the inverse square root in double precision.  The plain
sine basis

\[
F_k(x)=\sin\!\left(\frac{k\pi(x+A)}{2A}\right),\qquad |x|\le A,
\]

is orthogonal on \([-A,A]\) with Gram \(A I\), so the polarization is diagonal
and the computation is stable to \(K=20\).

## 2. The gaps

| \(K\) | gap \(\min\mu\) |
|---|---|
| 12 | \(0.2449\) |
| 14 | \(0.1629\) |
| 16 | \(0.0370\) |
| 18 | \(0.0588\) |
| 20 | \(0.0668\) |

The sequence is **not monotone**: the \(K=16\) gap is below both \(K=14\) and
\(K=18\).  It is not a quadrature artefact: the \(K=16\) value is stable to
eight digits under 100, 200, and 300 Gauss–Legendre nodes.

## 3. Interpretation

- The windowed-basis collapse of
  [`14-spectral-gap-truncation.md`](14-spectral-gap-truncation.md) was partly a
  conditioning artefact; the plain basis is stable.
- But the plain basis reveals a genuine **near-degeneracy** at \(K=16\).
- The non-monotonicity means the gap can drop again at larger \(K\).  A
  uniform lower bound is not established by these truncations.
- This does not prove the gap collapses to zero; it shows that the truncation
  route cannot settle the uniform-gap question.

## 4. What this means for the construction

The finite Hodge-index form remains negative definite for each \(K\) where
the projected symplectic form is invertible.  The question is whether the
negative definiteness survives the infinite limit with a uniform gap.  The
plain-basis data make that question delicate: a proof would need a direct
lower bound on the antisymmetric spectrum, not a monotone truncation
argument.  If the gap does collapse, the limit is only negative semidefinite;
the Hodge-index inequality would still hold, but not strict definiteness.

## 5. Numerical check

[`../python/plain_basis_gap.py`](../python/plain_basis_gap.py) implements the
plain-basis matrix and the gap.  The tests in
[`../tests/test_plain_basis_gap.py`](../tests/test_plain_basis_gap.py) assert
the \(K=12\) and \(K=16\) values, the non-monotonicity, and the quadrature
stability of the \(K=16\) near-degeneracy.

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[Spectral gap and truncation](14-spectral-gap-truncation.md)
