# The function-field template

**Status:** standard mathematics, recorded as a source claim. Nothing in this
note is formalised in `lean/Topic.lean` beyond the rank-three Hodge-index core.

## The statement

Let `C` be a smooth projective curve of genus `g` over `F_q`. Its zeta function
is

\[
Z(C,T)=\prod_{x\in C}\frac{1}{1-T^{\deg x}}
      =\frac{P_1(T)}{(1-T)(1-qT)},
\qquad
P_1(T)=\prod_{i=1}^{2g}(1-\alpha_iT),
\]

with `P_1 ∈ Z[T]` of degree `2g`. The Riemann hypothesis for `C` is

\[
|\alpha_i|=\sqrt q \qquad (i=1,\dots,2g).
\]

Weil proved this for curves (1948); Deligne proved the higher-dimensional
analogue (1974). The elliptic case `g = 1` is Hasse's bound.

## The three ingredients

The proof has a shape worth isolating, because the `ζ` problem is a statement
about which of the three ingredients is missing.

1. **A surface.** `S = C × C`.
2. **A correspondence.** The graph `Γ ⊂ S` of the Frobenius endomorphism.
3. **A positivity.** The Hodge index theorem on the Néron–Severi space of `S`.

The Lefschetz trace formula is the bridge between (2) and the zeta function:

\[
\#C(F_q) = 1 - \sum_i \alpha_i + q,
\]

and more generally `Z(C,T)` is the characteristic polynomial of Frobenius on
`H^1(C)`.

## The intersection numbers

Let `H = {pt} × C`, `V = C × {pt}` and `Δ` be the diagonal. The intersection
numbers are

\[
H^2=V^2=0,\qquad H\cdot V=H\cdot\Delta=V\cdot\Delta=1,\qquad
\Delta^2=2-2g.
\]

For `g = 1` the diagonal is an elliptic curve with trivial normal bundle, so
`Δ² = 0`, and on the rank-three span of `H, V, Δ` the Gram matrix is

\[
\begin{pmatrix}
0&1&1\\
1&0&1\\
1&1&0
\end{pmatrix}.
\]

This is the matrix formalised in [`../lean/Topic.lean`](../lean/Topic.lean):
`B` is the pairing, `B_self` computes the self-intersection, and `A = H+V+Δ`
is the ample class with `A² = 6`.

## The positivity

The Hodge index theorem says the intersection form on `NS(S) ⊗ R` has signature
`(1, ρ-1)`: one positive direction (the ample class) and `ρ-1` negative ones.
In the rank-three model this is the pair of facts

\[
A^2 = 6 > 0,
\qquad
D\cdot A = 0 \implies D^2 \le 0,
\]

with equality only at `D = 0`. The quantitative form is

\[
6\,D^2 \le (A\cdot D)^2,
\]

whose defect is the sum of squares
`2((a-b)² + (b-c)² + (c-a)²)`. The Lean core proves all of this
(T5–T9).

## How the bound comes out

The standard Castelnuovo–Weil argument applies the Hodge index to the graph of
Frobenius and the diagonal. The graph has the intersection numbers

\[
\Gamma\cdot H = 1,\qquad
\Gamma\cdot V = q,\qquad
\Gamma\cdot\Delta = q+1-a,
\]

where `a = q+1-\#C(F_q)`. The Hodge index turns these into an inequality on
`a`; the functional equation, which pairs `α` with `q/α`, supplies the
opposite inequality; together they force `|α| = √q`.

For an elliptic curve there is a shorter route that makes the positivity
explicit: the Rosati involution on `End(E) ⊗ R` is positive definite, and
Frobenius satisfies `π π̄ = q`, so `|π| = √q`. This is the same positivity in
a different coordinate system.

## What the template demands for `ζ`

Transplanting the argument would require:

1. an object with an intersection form and a Hodge index (a "surface");
2. a correspondence `Γ` whose Lefschetz trace is `ξ`, or equivalently whose
   characteristic polynomial has the non-trivial zeros as eigenvalues;
3. an identification of the functional equation `s ↦ 1-s` with the
   `α ↦ q/α` symmetry.

The arithmetic side has (1) and (3) in a precise sense, and is missing (2).
That is the subject of [`02-arithmetic-obstruction.md`](02-arithmetic-obstruction.md).
