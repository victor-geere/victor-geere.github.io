# Handoff — the helix bookkeeping and Weil positivity

**Status:** research note, not a theorem and not a bridge.  
**Audience:** the next researcher who wants to test whether the helix
structure can be turned into a positivity proof.  
**Related:** Objective III dossier
[`topics/partial-sum-plus-tail`](topics/partial-sum-plus-tail/README.md),
proof layer C
[`categories/05-proofs/proofs.md`](categories/05-proofs/proofs.md#c-the-certified-evaluation-layer),
and the working status page §3.4 (kept outside this folder).

## 0. One-paragraph summary

The Dirichlet terms \(n^{-s}\) are not an unordered set. For fixed
\(s=\sigma+it\), the sequence
\[
z_n(s)=n^{-s}=n^{-\sigma}e^{-it\log n}
\]
is a discrete logarithmic helix: its argument is strictly monotone, its
successive phase increments are eventually smaller than \(2\pi\), and its
radius \(n^{-\sigma}\) decreases. This is a real and useful structure for
summation by parts, van der Corput estimates, \(2\pi\)-turn block
decompositions, and Euler–Maclaurin tails. It does **not** by itself give
Weil positivity. The helix controls the argument and the amplitude; Weil
positivity is a quadratic form on test functions. To become a bridge, the
helix has to produce a positive factorization of the Weil form — squares,
orthogonal blocks, or a positive operator — with cross terms and tails
controlled in operator norm, and with an Euler-product input that the
Davenport–Heilbronn twist does not have.

## 1. Definitions

Let \(s=\sigma+it\), \(t\ne0\), and \(n\ge1\). Define the continuous phase
lift
\[
\theta(x)=-t\log x,\qquad \theta_n=\theta(n)=-t\log n,
\]
and the continuous helix
\[
z(x)=x^{-\sigma}e^{-it\log x}=x^{-\sigma}e^{i\theta(x)}.
\]
The terms of the Dirichlet series are \(z_n=z(n)\).

The phase is a lift, not a new value: \(e^{i\theta_n}=n^{-it}\) exactly.
Choosing the lift only records how many turns have been made. It does not
change \(z_n\).

## 2. Elementary helix properties

### H1. Strictly monotone argument

For \(t>0\), \(\theta_n\) is strictly decreasing; for \(t<0\), strictly
increasing. There is no change of rotation direction.

### H2. Monotone phase step

\[
\Delta_n=\theta_{n+1}-\theta_n
=-t\log\!\left(1+\frac1n\right).
\]
For \(t>0\), \(\Delta_n<0\), and \(|\Delta_n|\) decreases strictly to \(0\).
The step is eventually smaller than \(2\pi\):
\[
|\Delta_n|<2\pi
\quad\Longleftrightarrow\quad
n>\frac{1}{e^{2\pi/|t|}-1}
\sim \frac{|t|}{2\pi}.
\]
So the “every term is within a \(2\pi\) increment of the previous term”
condition is true for all sufficiently large \(n\). It is a statement about
the step size, not about the sign of the projection.

### H3. Total winding

From \(M\) to \(N\),
\[
|\theta_N-\theta_M|=|t|\log\frac NM.
\]
The total winding is unbounded as \(N\to\infty\). The helix wraps infinitely
often. A finite \(2\pi\)-turn block is one loop; it is not a terminal object.

### H4. Decreasing radius

For \(\sigma>0\),
\[
\left|\frac{z_{n+1}}{z_n}\right|
=\left(1+\frac1n\right)^{-\sigma}<1.
\]
The amplitude decreases monotonically to \(0\), but slowly when
\(\sigma\) is near \(1/2\). The ratio tends to \(1\), so adjacent terms have
almost the same radius.

### H5. Constant pitch angle in the continuous limit

\[
\frac{dz}{dx}
=z(x)\left(-\frac{\sigma+it}{x}\right).
\]
The tangent makes a constant angle
\(\arctan(t/\sigma)\) with the radius. The continuous curve is a logarithmic
spiral, not a circle. The discrete chain is a polygonal approximation to it.

### H6. One-turn block residual

A \(2\pi\)-turn block is a full loop of the spiral. If the radius were
constant, the vector sum of a full turn would cancel exactly. The residual
comes from the change of radius across the turn. Schematically, the block
sum is of order
\[
\text{amplitude}\times
\frac{\text{relative change of amplitude per turn}}
{\sqrt{(\sigma-1)^2+t^2}}
\]
in the continuous model, up to constants. The important point is qualitative:
a full-turn block is a **small residual**, not a positive number. Its
direction is determined by the amplitude gradient, not by the phase alone.
The formula above is a guide for experiments, not a theorem of this note.

### H7. Summation-by-parts consequence

Because the phase is monotone and the amplitude is monotone, the helix is
amenable to summation by parts and van der Corput. A schematic bound is
\[
\left|\sum_{n=M}^{N}z_n\right|
\le C\left(\frac{|z_M|}{|\Delta_M|}+|z_N|\right),
\]
with \(C\) a harmless absolute constant and the usual hypotheses on the
phase. This is the kind of estimate the helix actually gives: a bound on the
**magnitude** of a partial sum. It is not a lower bound and not a positivity
statement.

## 3. What the helix does not give

### 3.1 Monotone rotation is not positive projection

The real part is
\[
\Re z_n=n^{-\sigma}\cos(t\log n).
\]
The cosine changes sign every half-turn. A helix can rotate in one direction
forever while its projection onto the real axis oscillates. “No term has a
negative rotation” means the argument is monotone; it does not mean the
contribution is positive.

### 3.2 Total winding is unbounded

The condition \(|\Delta_n|<2\pi\) is eventually true, but the accumulated
angle is \(t\log N\). There is no finite truncation after which the helix
has “settled” into one direction. Grouping into \(2\pi\)-turn blocks produces
many blocks, and the block residuals need their own summation argument.

### 3.3 A scalar helix sum is not the Weil form

Even a proof that
\[
\Re\sum_{n\le N}z_n>0
\]
for some range would be a statement about one scalar sum. Weil positivity is
\[
W(f,f)\ge0\quad\text{for every test function }f.
\]
It is a quadratic form. A decomposition of \(\zeta\) into helix blocks does
not automatically decompose \(W\). The cross terms between blocks remain:
\[
W(f,f)=\sum_j W_j(f,f)+\sum_{j\ne k}W_{j,k}(f,f)+R(f,f).
\]
The off-diagonal terms \(W_{j,k}\) can have either sign. They are exactly
where the cancellation can live.

### 3.4 Conditional convergence at \(\sigma\le1\)

For \(\sigma>1\), the Dirichlet series converges absolutely, and any
reasonable grouping preserves the sum. For \(\sigma\le1\), the series is not
absolutely convergent. Regrouping, decimation, or “partial sum plus tail per
block” is a summation method that needs its own convergence theorem. The
helix lift does not supply that theorem.

### 3.5 The Davenport–Heilbronn litmus

The helix is built from \(n^{-\sigma}\) and \(t\log n\). It uses no Euler
product. The same construction applies verbatim to the Davenport–Heilbronn
function, which has every additive feature and no Euler product and for which
RH is false. Therefore a helix-only argument cannot be the missing arithmetic
input. Any bridge must add a multiplicativity/positivity ingredient that DH
lacks.

## 4. What would turn the helix into a bridge

A bridge is a proof of \(W(f,f)\ge0\) for all test functions \(f\). The
helix can be part of such a proof only if it supplies one of the following
structures.

### B1. Sum-of-squares factorization

Find operators \(A_j\), built from the helix blocks, such that
\[
W(f,f)=\sum_j \|A_j f\|^2+R(f,f),
\]
with \(R\ge0\), or with a coercive lower bound
\[
\sum_j \|A_j f\|^2\ge\varepsilon\|f\|^2
\quad\text{and}\quad
\|R\|\le\frac{\varepsilon}{2}.
\]
Then \(W\ge\varepsilon/2\) on the unit sphere. The helix must define the
\(A_j\), not merely the scalar block sums.

### B2. Orthogonal block decomposition

Show that the cross terms vanish,
\[
W_{j,k}=0\qquad(j\ne k),
\]
or that they are dominated by the diagonal:
\[
\left|\sum_{j\ne k}W_{j,k}(f,f)\right|
\le(1-\delta)\sum_j W_j(f,f).
\]
This is much stronger than “the blocks are small”. It is an operator-level
orthogonality statement, and it must hold uniformly in height and block
number.

### B3. Positive operator

Write
\[
W(f,f)=\langle f,Af\rangle
\]
and prove \(A\ge0\) by spectral, transfer-operator, or Lee–Yang methods. A
finite block matrix can refute a candidate by exhibiting a negative
eigenvalue, but it cannot prove \(A\ge0\) on an infinite-dimensional cone.
The helix could help construct \(A\), but the positivity proof is separate.

### B4. Positive measure

Write
\[
W(f,f)=\int|\hat f|^2\,d\mu
\]
and prove \(\mu\ge0\). A helix decomposition would have to produce a
positive measure, not just a sum of scalar residuals. This is the
measure-theoretic form of B1/B3.

### B5. Euler-product input that fails for DH

The construction must use a property the DH twist does not have: the Euler
product, complete multiplicativity, a positive local factorization, or a
ferromagnetic/Lee–Yang structure. A helix decomposition by \(n\) or by
\(2\pi\)-turn blocks is additive. If the bridge does not add multiplicativity,
it fails the litmus.

### B6. Uniform operator-norm tails

Euler–Maclaurin gives a tail bound for a scalar. A bridge needs a bound on
the remainder **as a quadratic form**:
\[
\|R\|_{\mathrm{op}}\le \varepsilon,
\]
uniform in the height, the block, and the test function. A scalar interval
enclosure is not enough.

### B7. All test functions, not finitely many

A finite Gram matrix over a test basis can refute a candidate. A proof needs
either an identity for all \(f\), or a density argument with uniform bounds.
“The first hundred test functions are positive” is not a proof.

## 5. Concrete experiments

### E1. Helix diagnostics

For several \((\sigma,t)\), compute the \(2\pi\)-turn blocks
\[
B_k=\left\{n:\theta_n\in[\theta_0-2\pi k,\theta_0-2\pi(k+1))\right\},
\]
and record
\[
T_k=\sum_{n\in B_k}z_n,\qquad \arg T_k,\qquad |T_k|.
\]
Questions:

- Is \(\arg T_k\) monotone (after a consistent lift)?
- Is \(|T_k|\) decreasing?
- Do the \(T_k\) themselves form a helix, or do they scatter?

If the \(T_k\) do not form a controlled helix, the block-level version of the
idea fails at the first test.

### E2. Cross-term audit

For a finite test basis \((f_i)\), compute the Gram matrix of the full form
and of the block-diagonal approximation. The difference is the cross-term
matrix. A negative eigenvalue of the full matrix, with positive diagonal
blocks, is an immediate counterexample to “diagonal positivity is enough”.

### E3. DH litmus

Run E1 and E2 on the Davenport–Heilbronn function. If the helix diagnostics
or the finite Gram matrices behave the same way as for \(\zeta\), the method
is not consuming the missing arithmetic input.

### E4. Tail operator norm

For a proposed block decomposition, estimate the operator norm of the
Euler–Maclaurin remainder on the test basis. A scalar tail bound that is
small is not enough; the remainder must be small relative to a positive
lower bound.

### E5. Look for a square

Try to write a block contribution as
\[
W_j(f,f)=\|A_jf\|^2
\]
or as a positive kernel
\[
W_j(f,f)=\iint f(x)\overline{f(y)}\,K_j(x,y)\,dx\,dy
\]
with \(K_j\) positive semidefinite. If no such representation appears, the
helix is not yet a positivity mechanism.

## 6. Candidate Lean/Python targets

These are targets, not claims that they are already proved.

- **Python:** exact \(2\pi\)-turn block construction; block-vector
  statistics; finite Gram matrices with rational or interval entries;
  comparison \(\zeta\) vs DH.
- **Lean:** monotonicity of the phase lift; the phase-step formula; the
  \(2\pi\) threshold; a summation-by-parts helix bound; a finite
  counterexample showing that positive diagonal blocks do not imply a
  positive full form.
- **Lean, only if the mathematics is found:** a sum-of-squares identity or
  an orthogonal-block theorem for a specific decomposition. Do not formalise
  a bridge before the bridge exists.

## 7. Open questions

1. Do the \(2\pi\)-turn block sums \(T_k\) themselves form a helix with
   monotone argument and decreasing norm? If not, is there a natural
   renormalisation that makes them one?
2. Is there a positive kernel on the block index \(k\) that makes the block
   cross terms controllable?
3. Can the explicit formula be written in terms of helix block sums without
   losing the arithmetic side?
4. Does any helix decomposition commute with the Euler product, or is it
   necessarily additive?
5. Is there a sum-of-squares identity for \(W\) whose terms are built from
   \(2\pi\)-turn blocks?
6. Can the finite Gram-matrix experiments produce a genuine negative
   eigenvalue for a natural decomposition? A clean refutation is a useful
   result.

## 8. Handoff checklist

- [ ] Read this note and the status page §3.4.
- [ ] Re-run the helix diagnostics for \(\zeta\) and DH; record the block
      statistics.
- [ ] Build one finite Gram matrix and check the cross-term matrix, not only
      the diagonal blocks.
- [ ] Try one sum-of-squares ansatz; record why it fails or what remains.
- [ ] Do not claim a bridge unless B1–B7 are addressed.
- [ ] Record negative results in the research journal; they are part of the
      map.

## 9. One-sentence handoff

**The helix is a correct and useful description of the phase bookkeeping, but
it controls magnitude and rotation, not the quadratic form \(W(f,f)\); it
becomes a bridge only if it is upgraded to a positive factorization or an
orthogonal block decomposition with operator-norm tails and an Euler-product
input that the DH twist lacks.**

**Where that upgrade actually lives (survey of the topic dossiers):**
[`bridge-to-weil-positivity.md`](bridge-to-weil-positivity.md) checks B1–B7 against the
topics. The short form: the helix supplies only B2/B6 bookkeeping; the best bridge is
B4, the CCM point-interaction operator in
[`topics/self-adjoint-ccm`](topics/self-adjoint-ccm/README.md), landing in the Weil
current of [`topics/prime-spectrum-tensor`](topics/prime-spectrum-tensor/README.md); the
Lee–Yang route is closed by the geometric programme's own off-critical polygon zeros.
