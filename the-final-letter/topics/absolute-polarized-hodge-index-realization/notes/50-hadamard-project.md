# Hadamard project: scope and milestone 1

**Status:** the zero-side formalisation commissioned as option 1 has begun.
Milestone 1 (Weierstrass elementary factors and finite canonical products) is
Lean-checked. The infinite product and the Hadamard factorisation are later
milestones. No RH proof yet.

## 1. Scope

The distributional explicit formula's zero side needs the factorisation of
the completed zeta over its zeros. The project is staged:

| milestone | content | status |
|---|---|---|
| 1 | Weierstrass elementary factors, finite canonical products, their zeros | **Lean-checked** |
| 2 | convergence of the infinite canonical product from \(\sum |z_n|^{-(p+1)}<\infty\) | **Lean-checked, including analyticity on the ball** |
| 3 | Hadamard factorisation of entire functions of finite order (Jensen/Poisson–Jensen) | open |
| 4 | application to \(\xi(s)\), zero counting, and the zero-side explicit formula | open |

## 2. Milestone 1 (Lean-checked)

[`../lean/Hadamard.lean`](../lean/Hadamard.lean):

| name | statement |
|---|---|
| `weierstrassFactor p z` | \(E_p(z)=(1-z)\exp\bigl(\sum_{k=1}^{p}z^k/k\bigr)\) |
| `weierstrassFactor_zero` | \(E_p(0)=1\) |
| `weierstrassFactor_one` | \(E_p(1)=0\) |
| `weierstrassFactor_eq_zero_iff` | \(E_p(z)=0\iff z=1\) |
| `differentiable_weierstrassFactor` | \(E_p\) is entire |
| `finiteCanonicalProduct p S z` | \(\prod_{w\in S}E_p(z/w)\) |
| `finiteCanonicalProduct_eq_zero_iff` | if \(0\notin S\), the product vanishes exactly on \(S\) |
| `differentiable_finiteCanonicalProduct` | the finite product is entire |

The proofs use `Complex.exp_ne_zero` for the exponential factor and the
`Finset` product-zero lemma. No `sorry`.

### Milestone 2 (started)

`logDeriv_weierstrassFactor`: for \(z\ne1\),

\[
\frac{E_p'(z)}{E_p(z)}=-\frac{1}{1-z}+\sum_{k=0}^{p-1}z^k .
\]

This is the exact log-derivative used in the Hadamard product's logarithmic
derivative. The compact form \(E_p'(z)=-z^p e^{S_p(z)}\) and the telescoping
identity \((1-z)\sum_{k<p}z^k=1-z^p\) are also Lean-checked. These reduce the
convergence bound to the estimate \(|S_p(w)|\le1\) for \(|w|\le1/2\) — now
Lean-checked as `norm_weierstrassSum_le_one` — and the integral identity. The path derivative
\(t\mapsto E_p(tz)\) and the exponential bound
\(\lVert e^{S_p(tz)}\rVert\le e\) on \(t\in[0,1]\) are Lean-checked
(`hasDerivAt_weierstrassPath`, `norm_cexp_weierstrassSum_le_exp_one`); the integral identity
\(E_p(z)-1=-z^{p+1}\int_0^1 t^p e^{S_p(tz)}dt\) is now Lean-checked in the
form of the convergence bound
\(\lVert E_p(z)-1\rVert\le e\,\lVert z\rVert^{p+1}\) for
\(\lVert z\rVert\le1/2\)
(`norm_weierstrassFactor_sub_one_le`). This is the key estimate for the
infinite product; in terms of the zero it gives
\(\lVert E_p(z/a)-1\rVert\le e\lVert z\rVert^{p+1}/\lVert a\rVert^{p+1}\)
(`norm_weierstrassFactor_div_sub_one_le`). The summability of the perturbations is Lean-checked
(`summable_weierstrassFactor_sub_one`): if \(2\lVert z\rVert\le\lVert a_n\rVert\) and
\(\sum\lVert z\rVert^{p+1}/\lVert a_n\rVert^{p+1}<\infty\), then
\(\sum(E_p(z/a_n)-1)\) converges. The `HasProd` assembly is Lean-checked
(`multipliable_weierstrassFactor`, `hasProd_weierstrassFactor`): under
\(2\lVert z\rVert\le\lVert a_n\rVert\) and
\(\sum\lVert z\rVert^{p+1}/\lVert a_n\rVert^{p+1}<\infty\), the product
\(\prod_n E_p(z/a_n)\) converges.

The finite product's log-derivative is Lean-checked:
\(P_S'/P_S(z)=\sum_{w\in S}(1/w)E_p'/E_p(z/w)\).
The **zero set** of the infinite product is Lean-checked: the value at
\(z=0\) is \(1\) (`hasProd_weierstrassFactor_zero`), the product vanishes at
each \(a_k\) (`hasProd_weierstrassFactor_at_zero`), and off the zeros it is
nonzero (`tprod_weierstrassFactor_ne_zero`, via the log series). The product also converges **uniformly on compact sets**
(`hasProdUniformlyOn_weierstrassFactor`), via Mathlib's
`Summable.hasProdUniformlyOn_nat_one_add` with the majorant
\(eR^{p+1}/\lVert a_n\rVert^{p+1}\). The compact-to-local bridge and the analyticity are Lean-checked:
`tendstoUniformlyOn_weierstrassFactor_closedBall`,
`tendstoLocallyUniformlyOn_weierstrassFactor_ball`, and
`analyticOnNhd_tprod_weierstrassFactor_ball`. The infinite canonical product is
analytic on the ball of radius \(R\) where \(2R\le\lVert a_n\rVert\) and
\(\sum R^{p+1}/\lVert a_n\rVert^{p+1}<\infty\). **Milestone 2 is complete.**
**Milestone 3 is next.** Mathlib supplies Jensen's formula
(`MeromorphicOn.circleAverage_log_norm`, `AnalyticOnNhd.circleAverage_log_norm`)
and Jensen's inequality for the divisor (`AnalyticOnNhd.sum_divisor_le`), so
the zero-counting input is available. Jensen's formula and Jensen's inequality are now instantiated for our finite
canonical product (`Jensen_finiteCanonicalProduct`,
`sum_divisor_finiteCanonicalProduct_le`). What remains for the Hadamard product theorem is the order/genus machinery
and the zero-free-quotient argument. On the quotient: Mathlib has a
**continuous** logarithm of a zero-free function on a simply connected domain
(`Complex.exists_continuousOn_eqOn_exp_comp`, continuous only), not the
differentiable logarithm needed to write the quotient as `exp` of an entire
function. The differentiable upgrade is the next concrete target, followed by
the order/genus estimates and the Hadamard factorisation theorem.

**Route for the differentiable log.** Work on a ball (where the canonical
product is analytic, milestone 2). The log-derivative `f'/f` is holomorphic
on the ball, and Mathlib's Morera theorem for disks
(`DifferentiableOn.isExactOn_ball`) gives a primitive `G` with `G' = f'/f`.
Then `f * exp(-G)` has derivative zero on the ball, hence is constant, and
the constant is adjusted to write `f = exp(G + c)`. This avoids the
continuous-log detour and uses only ball primitives. The constant-on-a-ball step is Lean-checked
(`eq_const_of_deriv_eq_zero_ball`): a holomorphic function on a ball with zero
derivative is constant. The derivative algebra is Lean-checked:
`hasDerivAt_mul_cexp_neg_of_logDeriv`, `const_mul_cexp_neg_of_primitive`, and
`exists_cexp_of_primitive`. The last says: on a ball, if `G' = f'/f` and `f`
is zero-free, then `f = exp (G + c₀)`. The primitive exists by Mathlib's `DifferentiableOn.isExactOn_ball`
applied to `f'/f` (differentiable since `f` is holomorphic and zero-free), and
the unconditional result is `exists_differentiable_cexp_ball`: on a ball, a
holomorphic zero-free function is `exp g` with `g` holomorphic. This is the
differentiable logarithm needed for the zero-free quotient. Milestone 3 is the Hadamard factorisation.

## 3. What the next milestones require

**Milestone 2** needs the convergence criterion for
\(\prod_n E_p(z/a_n)\): absolute convergence of
\(\sum_n |z/a_n|^{p+1}\) on compact sets, plus the product's analyticity and
zero set. Mathlib has `HasProd`/`tprod` but not this canonical-product
construction.

**Milestone 3** is the hard one: the Hadamard factorisation theorem
(entire functions of finite order, genus, canonical products) with Jensen's
formula. Mathlib has neither Jensen's formula for entire functions nor the
Hadamard product. This is the external build identified in
[48-frontier.md](48-frontier.md).

**Milestone 4** needs zero counting for \(\zeta\) (Riemann–von Mangoldt or at
least \(\sum_\rho 1/|\rho|^2<\infty\)), which is also absent.

## 4. Bottom line

- Milestone 1 is proved in Lean; the file builds with the other six.
- Milestones 2–4 are the substantial new formalisation.
- No RH proof yet.

[Back to the dossier](../README.md) · [Frontier](48-frontier.md) ·
[Lean core](../lean/README.md) · [Research journal](../research-journal.md)
