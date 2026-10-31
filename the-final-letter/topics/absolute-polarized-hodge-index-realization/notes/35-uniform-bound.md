# The uniform bound fails

> **Correction (round 45).** The growth of \(\|H_N\|\) is not an obstruction. Unbounded modular Hamiltonians are compatible with compatible positive forms, and the tensor-factor example exhibits this. This “obstruction” is withdrawn. See [38-rescue.md](38-rescue.md) §2.2.

**Status (original, superseded by the banner above):** a precise obstruction to the naive inductive-limit step. The
finite KMS form satisfies \(B(a,a)\le2\|H\|\|a\|^2\), but for KMS weights
\(p^{-k\beta}\) the modular Hamiltonian grows with the level, and at
\(\beta=1\) the state is not normalizable. The uniform bound over the finite
levels therefore fails in the naive normalization; a renormalized or relative
modular form is required.

## 1. The finite bound

For a finite-dimensional algebra with faithful state \(\rho\) and
\(H=-\log\rho\),

\[
B(a,a)=\operatorname{Re}\operatorname{Tr}\bigl(\rho\,a^*[H,a]\bigr)
\le2\|H\|_{\mathrm{op}}\|a\|^2.
\]

This is the elementary bound used implicitly in the finite theorem.  It is
uniform in the algebra element but **not** in the state.

## 2. The KMS scaling

For a Bost–Connes KMS weight at inverse temperature \(\beta\), a periodic
orbit of length \(k\) at prime \(p\) carries weight \(p^{-k\beta}\), so the
modular Hamiltonian has eigenvalue

\[
h_{p,k}=\beta k\log p.
\]

As the finite level \(N\) grows, the largest \(k\) grows, and

\[
\|H_N\|\sim\beta\log N.
\]

At \(\beta=1\), the partition function \(\zeta(\beta)\) has a pole; the
normalized state does not exist in the limit, and the truncated weights are
not uniformly summable.  The bound \(2\|H_N\|\|a\|^2\) therefore grows with
\(N\) and cannot be made uniform.

## 3. Consequence

The conditional inductive-limit theorem of
[`34-inductive-limit.md`](34-inductive-limit.md) requires
\(\sup_N\|B_N\|<\infty\).  The naive KMS forms do **not** satisfy this:

- \(\|H_N\|\) grows like \(\log N\);
- the \(\beta=1\) state is critical and not normalizable;
- the finite-level forms must be renormalized, or replaced by **relative**
  modular forms with respect to a reference state.

This is a precise obstruction to the inductive limit as stated.  It does not
invalidate the finite theorem; it identifies the renormalization needed for
the infinite limit.

## 4. What would work

1. A relative modular operator \(\Delta_{\varphi|\psi}\) with a reference
   state \(\psi\), removing the divergent normalization.
2. A uniform bound on the relative forms, not the absolute ones.
3. A critical-state limit at \(\beta=1\) in the Connes–Consani sense.

None of these is established.

## 5. Numerical check

[`../python/uniform_bound.py`](../python/uniform_bound.py) verifies the
finite bound \(B(a,a)\le2\|H\|\|a\|^2\) for random states and shows the KMS
norm growth \(\beta k\log p\).  The tests are in
[`../tests/test_uniform_bound.py`](../tests/test_uniform_bound.py).

No RH proof is claimed yet.

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[The inductive-limit step](34-inductive-limit.md)
