# Hadamard project: status and frontier

**Status:** a Lean-checked Hadamard factorisation up to the order-1 growth
estimate. No RH proof yet.

## 1. What is Lean-checked

In `lean/Hadamard.lean`:

- Weierstrass elementary factors, finite and infinite canonical products,
  convergence, analyticity, zeros with multiplicity.
- Jensen's formula and Jensen's inequality; the general zero-counting bound.
- Zero-free logarithms on balls and on the whole plane.
- The canonical product is entire (`differentiable_tprod_weierstrassFactor`).
- The quotient normal form `Q` of `f/P` is entire and zero-free
  (`exists_entire_zeroFree_quotient`).
- The global identity `f = P · Q` (`eq_mul_quotientNF`).
- The quotient-form Hadamard factorisation `f = P · exp g`
  (`exists_factorization_of_divisor_match`).
- The affine refinement from linear log-growth
  (`exists_affine_factorization_of_divisor_match`), with the order-1 property
  `HasLogGrowthOne` and its algebra (constants, identity, affine functions,
  powers, affine exponentials, products, finite products, scalar
  multiples, zero-free sums, affine reparametrisations), and the
  nonnegative-constant variant `HasLogGrowthOneNonneg` is closed under
  products and finite products, which gives
  `hasLogGrowthOne_finiteCanonicalProduct_zero`: the genus-0 finite canonical
  product (a polynomial) is order-1. Powers of any order-1 function are
  order-1 (`HasLogGrowthOne.pow`), division by a function bounded below
  by a positive constant preserves the property
  (`hasLogGrowthOne_div_of_lower_bound`), and adding a constant preserves the
  property (`hasLogGrowthOne_add_const`).
- **Every complex polynomial has order-1 log-growth**
  (`polynomial_hasLogGrowthOne`), via the split factorisation into linear
  factors and the multiset-product closure.
- Borel–Carathéodory in linear form
  (`exists_norm_le_of_re_le_linear`): linear real-part growth gives
  `‖g z‖ ≤ C(1+‖z‖)`.
- The **zero-free order-1 theorem**
  (`exists_affine_cexp_of_zeroFree_logGrowth`): a zero-free entire function
  with `HasLogGrowthOne` is `exp (a + bz)`. Combined with the divisor match,
  this is the analytic heart of the order-1 Hadamard factorisation. The final
  assembly is `exists_affine_factorization_of_zeroFree_quotient`: a zero-free
  order-1 quotient gives `f = P · exp (a + bz)`.

## 2. What remains for the order-1 theorem

The single missing analytic input is

\[
\log \|Q(z)\| \le A\|z\| + B,
\]

i.e. the order-1 growth of the zero-free quotient `Q = f/P`. The classical
proof bounds `log|P|` **below** away from the zeros (minimum modulus) and
combines it with the order-1 growth of `f`; the zeros are handled by removing
small disks and using the maximum principle.

This is a substantial analytic estimate (the order theory of canonical
products), not yet formalised. No truncation is involved; it is a genuine
open formalisation target.

## 3. Why this is not an RH proof

Even the unconditional order-1 Hadamard factorisation would only give the
zero-side product representation. The Riemann hypothesis still requires the
**cone positivity** (Weil's criterion) and the explicit formula, which are
separate research-level targets of the dossier. The Hadamard project supplies
one input, not the proof.

## 4. Numerical status

The positivity certificates in the dossier are interval-certified where
claimed. The earlier truncated Hadamard numerical check was withdrawn (journal
round 124); no truncated numerical claim is made here.

## 5. Bottom line

- The Hadamard/Weierstrass machinery is Lean-checked up to the order-1 growth
  estimate.
- The order-1 growth of `f/P` is the remaining formalisation gap.
- No RH proof yet.

[Back to the dossier](../README.md) · [Hadamard project](50-hadamard-project.md) ·
[Research journal](../research-journal.md)
