# The inductive-limit step

> **Correction (round 45).** The uniform bound is not needed. Compatibility alone gives the limit form on the dense union ([38-rescue.md](38-rescue.md), Lemma 2.1); the theorem here proves a stronger-than-necessary norm-continuity statement. The compatibility-only core is now Lean-checked as `limit_well_defined`,
and the limit form itself is constructed on the union `⋃ₙ Vₙ` with
`limitForm_nonpos`, in [`../lean/Limit.lean`](../lean/Limit.lean).

**Status (original, superseded by the banner above):** a conditional theorem for passing the finite KMS Hodge index to
the Bost–Connes dense union. The finite-level forms are negative semidefinite;
the limit is negative semidefinite **if** the finite-level forms satisfy a
uniform bound. That uniform bound is the open hypothesis. This is the
strongest rigorous substitute for the infinite limit currently in the
dossier.

## 1. The finite levels

Let \(\mathcal{A}_N\) be the finite-level Hecke algebra of the Bost–Connes
system at level \(N\), with its faithful KMS restriction \(\varphi_N\) and
modular Hamiltonian \(H_N\).  The finite theorem of
[`05-finite-crossed-product.md`](05-finite-crossed-product.md) gives, for
self-adjoint \(a\),

\[
B_N(a,a)=\operatorname{Re}\varphi_N\bigl(a^*[H_N,a]\bigr)\ge0,
\]

so \(-B_N\preceq0\) on the self-adjoint part of \(\ker\varphi_N\).

The Bost–Connes algebra contains the dense union
\(\bigcup_N\mathcal{A}_N\); its closure is the crossed product
\(C^*(\mathbb{Q}/\mathbb{Z})\rtimes\mathbb{N}^\times\).

## 2. The conditional theorem

**Theorem (conditional).** *Suppose there is a state \(\varphi\) on the
closure whose restrictions are \(\varphi_N\), and suppose the forms
\(B_N\) satisfy a uniform bound*

\[
\sup_N\|B_N\|_{\mathrm{op}}\le C<\infty
\]

*on the self-adjoint parts, with a uniform negative gap on the degree-zero
subspaces.  Then the limit form \(B\) is negative semidefinite on the
degree-zero subspace of the closure.*

*Proof.*  On the dense union, each \(B_N\) is negative semidefinite.  A
uniform operator bound makes the forms equicontinuous, so they extend by
continuity to the closure.  The limit of negative semidefinite forms is
negative semidefinite. ∎

## 3. What is missing

The uniform bound is not proved.  The truncation studies of notes 14–21 are
diagnostics of finite compressions, not of the operator-algebra forms, and
they show that the gap is delicate.  A proof would require:

1. a uniform bound on the modular Hamiltonians \(H_N\) in the relevant
   topology;
2. compatibility of the polarizations under the inclusions
   \(\mathcal{A}_N\subset\mathcal{A}_{N'}\);
3. control of the critical \(\beta=1\) limit, where the KMS state is not
   normalizable.

None of these is established.

## 4. What this achieves

- It connects the finite theorem to the infinite object through a precise
  continuity argument.
- It isolates the remaining analytic input: a uniform bound and a uniform
  gap.
- It does not prove the Bost–Connes limit, the CCM sign, or RH.

This is the correct shape of the infinite-limit step; the hypotheses are
open.

## 5. Next

1. Prove or disprove the uniform bound for the finite Hecke algebras.
2. Identify the correct topology and the critical-state limit.
3. Relate the limit form to the CCM symbol \(M\).
4. Return to the sign convention and the normalization dictionary.

No RH proof is claimed yet.

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[Status](30-status.md)
