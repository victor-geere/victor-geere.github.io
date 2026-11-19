# Isometry status

The Haar isometry is proved up to one structural lemma about split nodes. This
note records exactly what is closed and what remains, so the ledger is not read
as claiming more than the Lean development contains.

## Proved

- The normalised wavelet has zero integral (T56–T57).
- The root indicator has unit norm, is orthogonal to every wavelet, and is
  distinct from every wavelet (T90–T91, T95).
- The normalised wavelet has unit `L²` norm (T60–T61).
- The wavelet is supported on its parent and constant on each child (T63, T65).
- Disjoint-parent wavelets are orthogonal (T64).
- Nested-in-left and nested-in-right wavelets are orthogonal (T66–T67).
- Distinct same-depth partition nodes are disjoint, hence orthogonal (T73–T74).
- The partition is a tree: deeper nodes are contained in or disjoint from
  shallower nodes, and any two nodes are disjoint or nested (T77, T80).
- The exact child-or-self refinement and one-step child containment (T81–T82).
- The two child intervals at a cut point are disjoint (T83).
- Every normalised generator is the root or a partition-node wavelet (T92),
  has unit norm (T93), exposes its parent data (T94), and same-parent wavelets
  are equal (T96–T97).

## Isometry is now proved

A node can persist unsplit across depths. T84 proves the needed statement:

> If `d ∈ partitionR n` and `d ∈ partitionR (n+1)`, then `d.hi ≤ cutR n d`.

Equivalently, a node that is present at two consecutive depths is unsplit at
the earlier one. T85 adds membership monotonicity: a node present at depths
`m < n` is already present at `m + 1`. With T84–T86, a splitting node cannot reappear deeper. T87 then proves
arbitrary-depth child containment:

1. A splitting node at depth `m` cannot reappear at any depth `> m`.
2. A deeper node inside a splitting node therefore lies in its left or right
   child.
3. T66–T67 give orthogonality for every nested pair, T64 covers the disjoint
   pair, and T88 packages the four local cases. T89 proves general pairwise
   orthogonality from the partition tree, and T98 assembles distinct-generator
   orthogonality for `haarGensNorm`.
4. T101 packages `haarGensNorm N` as a unit-norm, pairwise-orthogonal family.
   T99–T100 prove the two-term and scaled two-term norm identities, and T102–T106 supply single-generator scaling, orthogonal-block additivity (two and
   three blocks), cross-term linearity and squared-sum integrability for the
   finite-sum induction.

## Lean targets

- `partitionR_subset_child_of_lt` — arbitrary-depth child containment.
- `haar_orthogonal` — pairwise orthogonality from the tree order.
- `hst_isometry` — the final coefficient-map isometry.

No Riemann-hypothesis or GRH claim is involved.
