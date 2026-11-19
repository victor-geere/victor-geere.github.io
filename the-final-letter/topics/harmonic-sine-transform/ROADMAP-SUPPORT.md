# Roadmap support matrix

This note records what the corpus and the refreshed
[proof–conjecture graph](../lean-conjecture-graph.html) actually supply for the
remaining HST roadmap gaps. It is a support/obstruction map, not a claim that any
open analytic statement is proved.

The graph was regenerated on 2026-11-18 from `index-lean.md`: 245 Lean files,
4,450 named proofs, 196 HST nodes. Candidate edges are keyword/topic matches, not
proofs; the table below names the concrete declarations where they exist.

## O5 — transfer operator and Fredholm determinant

**Supplied by the corpus**

- [`greedy-harmonic-transfer-operator`](../greedy-harmonic-transfer-operator/README.md):
  `GreedyHarmonicTransfer.transfer_nonneg`, `transfer_mono`,
  `transferIter_nonneg` — a weighted shift `(T a)_n = a_{n+1}/(n+2)`, not the
  archived `ℒ_s`.
- [`proof-99-global-harmonic-framework`](../proof-99-global-harmonic-framework/README.md):
  finite coefficient and rank-one determinant algebra (`GHF.det_rank_one`,
  `GHF.det_diagonal_sq_pos`), and an explicit statement that the Mayer–Ruelle
  similarity is unproved.

**Not supplied**

- A definition of the greedy map and its inverse branches.
- A proof that the greedy map is conjugate/similar to the Gauss map.
- The archived intertwining `ℒ_s = V 𝒢_s V⁻¹ + K_s` with trace-class `K_s`.
- Trace-classness, the periodic-orbit trace, and the determinant identity.

**Partial support.** The finite archived operator is defined and bounded (T130–T133);
the `k=1` weight series diverges (T134) while the weights are summable for
`k≥3` (T136), the finite operators are uniformly bounded for `k≥3` (T138), and the infinite
operator is constructed as their limit (T139–T140), confirming the `Re s>1`
threshold in the finite integer model. The only live Gauss/Mayer–Ruelle material is the finite `proof-99`
core; it does not connect to HST. The HST source's two operator descriptions
(R17) remain different and underived.

## O6 — explicit formula

**Supplied by the corpus**

- [`absolute-polarized-hodge-index-realization`](../absolute-polarized-hodge-index-realization/README.md)
  has Lean-checked finite explicit-formula and Gaussian-test machinery:
  `test_function_explicit_formula`, `explicit_formula_assembly`,
  `explicit_formula_gaussianZeroTest`.
- [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md) has finite
  Gaussian Weil–Gram certificates.

**Not supplied**

- The HST test-function class `S` and the weights `W_f(n)`.
- A derivation of those weights from the Haar expansion.
- A Perron/contour-shift proof for the HST coefficients.

**Obstruction status.** The existing explicit-formula work is for Gaussian test
functions, not the HST weighted Haar class. No formal bridge exists.

## O7 — Hilbert–Pólya and GRH

**Supplied by the corpus**

- [`greedy-harmonic-hilbert-polya`](../greedy-harmonic-hilbert-polya/README.md):
  local quadratics and Galerkin eigenvalues (`GHHP.Q0_roots`, `GHHP.Q_roots`,
  `GHHP.Q_vieta`).
- [`harmonic-categorical-hilbert-polya`](../harmonic-categorical-hilbert-polya/README.md):
  finite transfer matrix and determinant algebra (`HCHP.A_upperTriangular`,
  `HCHP.det_one_sub_A`).
- [`self-adjoint-ccm`](../self-adjoint-ccm/README.md): finite Hermitian
  compression and matching (`CCM.ccmMatrix_isHermitian`,
  `CCM.matchingProduct_unitary`).

**Not supplied**

- The operator domain and essential self-adjointness.
- Spectral flow or the eigenvalue–zero correspondence.
- A candidate whose spectrum is the zero set.

**Obstruction status.** The CCM constant-matching operator has a lattice spectrum
and is explicitly excluded in `WEIL-BRIDGE.md`. The greedy-HP Mellin bijectivity is
open. The finite cores are algebraic support, not a Hilbert–Pólya construction.

## P5–P7 — categorical side

**Supplied by the corpus**

- Finite MTC/Egyptian arithmetic in [`qefe`](../qefe/README.md) and
  [`qefe-research-notes`](../qefe-research-notes/README.md).

**Not supplied**

- R14 is resolved: there is no literal greedy–MTC tree bijection; only the
  transfer-operator connection remains.
- The `SU(2)_k` quantum-dimension limit against the HST Dirichlet series.
- The equidistribution argument.

**Status.** R14 is resolved. The categorical branch may use the transfer-operator
route (now initiated in [`../hst-transfer-operator`](../hst-transfer-operator/README.md)),
but the `SU(2)_k` limit and universal-attractor claims remain unproved.

## F4 — digit frequency

**Closed.** Exact cylinder measure (T55), mesh bound (T20/T23), digit-one measures
C13, zero-target frequency T124 and sample frequencies C14. The uniform bound
`D(N) ≤ log₂ N + 1` (T123) makes the digit density `O(log N/N) → 0` for every `θ`,
which is stronger than the a.e. frequency asked for.

## Remaining analytic frontier

The finite reconstruction is exhausted. The remaining items are not finite
bookkeeping tasks:

- **O5** needs a canonical transfer operator plus a trace-class/Fredholm
  determinant proof. The source's displayed map is refuted by R18 and its two
  operator formulas are inequivalent (R17). The finite truncations, infinite
  limit, linearity and bounds are proved here (T125–T150) and isolated in
  [`../hst-transfer-operator`](../hst-transfer-operator/README.md), but the
  determinant identity is not.
- **O6** depends on O5 and additionally requires the HST test-function class and
  weights `W_f(n)`, neither of which exists in the corpus.
- **O7** depends on O5/O6 and requires a self-adjoint operator with the zero set
  as spectrum. The finite HP/CCM cores elsewhere do not supply this; the CCM
  constant-matching candidate is refuted in `WEIL-BRIDGE.md`.
- **P5–P7** uses only the transfer-operator route; the literal greedy–MTC
  bijection is ruled out by R14.

These are research-programme blockers, not missing finite lemmas.
