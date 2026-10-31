# Priority items: status after the Hadamard formalisation

**Status:** no RH proof yet. This note records the state of the five priority
items as of round 114.

## 1. Interval-certified analytic Gram entry

**Done on the tested rungs.** The first interval-certified analytic Gram entry
(Gaussian diagonal, width \(4.9\cdot10^{-4}\)) and the \(2\times2\), \(4\times4\),
\(6\times6\), \(8\times8\) cosh \(+\Omega\) matrices are certified PSD
(notes 44, 47); the compact-support diagonal is certified positive. The
finite-rung margin collapse (note 45) means these certificates do not reach
the full cone.

## 2. Critical-line continuation of the symbol identity

**Done.** `symbol_identity_continued` in `lean/Symbol.lean` proves the
identity for all \(s\ne1\), which includes the critical line; the explicit
critical-line form is `symbol_identity_critical_line` (at
\(s=1/2+it\), away from zeros). The earlier form was restricted to
\(\operatorname{Im}\xi>1\). See note 38.

## 3. Cone positivity (Weil's criterion)

**Open.** The finite Hodge-index inequality and the finite-rung positivity are
Lean-checked, but the global cone positivity requires the distributional
explicit formula, which is not formalised. This is the main RH-relevant gap.

## 4. Bost–Connes level compatibility

**Open.** The finite crossed-product KMS/Hodge results are proved; the
infinite Bost–Connes dense union and the level compatibility remain.

## 5. Scaling-site Riemann–Roch/Hodge index

**Open.** The local rank-three Hodge index and the abelian-surface model are
proved; the scaling-site statement is not.

## Hadamard input

The Hadamard/Weierstrass factorisation is Lean-checked up to the order-1
growth of the quotient \(f/P\) (notes 50, 52). The order-1 class
`HasLogGrowthOne` is closed under products, finite products, powers, scalar
multiples, controlled division, affine reparametrisation, and zero-free sums;
the genus-0 finite canonical products (polynomials) are in the class. Even
unconditionally the factorisation supplies only the zero-side product
representation; it is not an RH proof.

## Bottom line

- Items 1 and 2 are done on their tested rungs.
- Items 3–5 are open research-level targets.
- No RH proof yet.

[Back to the dossier](../README.md) · [Frontier](48-frontier.md) ·
[Research journal](../research-journal.md)
