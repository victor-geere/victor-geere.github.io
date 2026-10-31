# The finite KMS Hodge index

**Status:** a proved finite-dimensional theorem for the transverse form of a
KMS state. It is the local model of the endomotive candidate; the global
Bost–Connes limit and the CCM dictionary remain open. No RH proof is claimed yet.

## 1. The finite model

Let \(\mathcal{A}=M_n(\mathbb{C})\) and let

\[
\varphi(a)=\operatorname{Tr}(\rho a),
\qquad
\rho=\operatorname{diag}(p_1,\dots,p_n),
\quad p_i>0,\quad \sum_i p_i=1,
\]

be a faithful state.  Put

\[
H=-\log\rho=\operatorname{diag}(h_i),\qquad h_i=-\log p_i,
\]

and let \(\delta(a)=[H,a]=Ha-aH\) be the transverse (modular) derivation.
Define the **transverse form**

\[
B(a,b)=\varphi\bigl(a^*\delta(b)\bigr).
\]

This is the finite-level analogue of the transverse Hodge–Riemann pairing of
the endomotive: \(\varphi\) is the KMS state, \(H\) is the scaling Hamiltonian,
and \(\delta\) is the infinitesimal periodic-orbit length.

## 2. The theorem

**Theorem (finite KMS Hodge index).** *For every self-adjoint
\(a\in M_n(\mathbb{C})\),*

\[
\operatorname{Re}B(a,a)
=\frac12\sum_{i,j}(p_i-p_j)\,|a_{ij}|^2\log\frac{p_i}{p_j}
\ge0,
\]

*with equality if and only if \([H,a]=0\).  Consequently \(-B\) is negative
semidefinite; on the kernel of \(\varphi\), where the degree is zero, it is the
Hodge-index form.*

*Proof.*  For self-adjoint \(a\) one has \(a_{ji}=\overline{a_{ij}}\), so
\(|a_{ij}|=|a_{ji}|\).  Since \(H\) is diagonal,

\[
B(a,a)
=\sum_{i,j}p_i\,\overline{a_{ij}}\,(h_j-h_i)\,a_{ij}
=\sum_{i,j}p_i\,|a_{ij}|^2\log\frac{p_i}{p_j}.
\]

The expression is real.  Averaging it with the same sum after exchanging
\(i\) and \(j\) gives

\[
B(a,a)
=\frac12\sum_{i,j}(p_i-p_j)\,|a_{ij}|^2\log\frac{p_i}{p_j}.
\]

For \(x,y>0\), \((x-y)\log(x/y)\ge0\), with equality iff \(x=y\).  Hence every
term is nonnegative.  Equality for all nonzero \(a_{ij}\) forces \(p_i=p_j\),
i.e. \(a\) commutes with \(H\). ∎

The sign is the Hodge-index sign on the self-adjoint part: the transverse
form is **non-positive** on degree-zero classes after flipping the
orientation.  This is the finite-level
positivity that the absolute realization needs.

## 3. Relation to the endomotive candidate

The Bost–Connes algebra is the infinite-dimensional crossed product
\(C^*(\mathbb{Q}/\mathbb{Z})\rtimes\mathbb{N}^\times\), with KMS states
\(\varphi_\beta\) for \(\beta>1\).  At finite level, its local pieces are
matrix algebras of the form above, and the modular derivation is the
infinitesimal scaling.  The theorem proves the Hodge-index sign for these
finite pieces, with no assumption on the zeros.

What remains:

1. **The limit.**  The Bost–Connes algebra is infinite-dimensional and the
   critical state at \(\beta=1\) is a limit, not a state.  The theorem must be
   extended to the KMS weight at \(\beta=1\) and to the crossed product.
2. **The CCM dictionary.**  The transverse form \(B\) uses the modular
   derivation \(H\); the CCM local term uses the periodic-orbit length
   \(\log p\) and the half-weight \(p^{-k/2}\).  Identifying \(H\) with the
   length generator and \(\varphi\) with the CCM trace is the missing
   dictionary.
3. **The half-weight.**  The finite theorem uses the modular Hamiltonian
   \(H\) and the state \(\rho=e^{-H}\).  The CCM local term uses the
   half-weight \(p^{-k/2}\), i.e. \(\Delta^{1/2}=e^{-H/2}\), not
   \(\Delta\).  The half-weight form is not a KMS state at \(\beta=1/2\)
   in the usual sense (the Bost–Connes KMS states exist only for
   \(\beta>1\)); it requires a separate modular-form argument.
4. **The archimedean term.**  The finite model has no archimedean place; the
   boundary term of the explicit formula is absent.

The theorem does not prove RH; it proves that the **sign** of the transverse
form is correct in the finite KMS model.  The remaining gap is the global
assembly and the dictionary.

## 4. Numerical check

[`../python/kms_transverse.py`](../python/kms_transverse.py) builds random
density matrices for \(n=2,3,4\), forms the matrix of \(-B\) on the kernel of
\(\varphi\), and checks that all eigenvalues are non-positive.  It also checks
the explicit formula for \(B(a,a)\) and the equality case.  The tests are in
[`../tests/test_kms_transverse.py`](../tests/test_kms_transverse.py).

The finite theorem is a local positivity result; it does not by itself give
the absolute polarized realization.

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[Endomotive candidate](02-endomotive-candidate.md)
