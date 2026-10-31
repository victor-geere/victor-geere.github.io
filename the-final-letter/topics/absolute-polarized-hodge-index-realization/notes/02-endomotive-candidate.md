# The endomotive / modular-tower candidate

**Status:** a constructive candidate for the absolute realization. The
finite-level Hodge–Riemann positivity is standard and checked; the passage to
the CCM pairing is conjectural. No RH proof is claimed yet.

## 1. Why a tower, not a surface

The previous note constructed the local fibre \(E_p\times E_p\) and identified
the metric obstruction: the factor \(p^{-k/2}\) in the CCM local term is the
\(p\)-adic norm of the Tate period, not a complex intersection number.  A
single proper surface over a number field cannot carry this metric for all
\(p\).  The natural global object is the **modular tower**

\[
\mathcal{M}=\varprojlim_{N} X_0(N)
\]

with the Hecke correspondences, or equivalently the Bost–Connes endomotive

\[
\mathcal{A}_{\mathbb{Q}}
= C^*(\mathbb{Q}/\mathbb{Z})\rtimes\mathbb{N}^\times .
\]

The tower is not a variety, but it carries three structures that a single
surface lacks:

- the Hecke correspondences \(T_p\), which are algebraic at every finite level;
- the Petersson inner product and the Hodge–Riemann form on \(H^1\);
- the KMS/modular weight, whose half-weight is \(p^{-k/2}\).

## 2. The finite-level Hodge–Riemann positivity

At finite level \(X_0(N)\), the Hodge structure on \(H^1\) is polarised by the
intersection form.  The Hodge–Riemann form

\[
h(\alpha,\beta)=i\int_{X_0(N)}\alpha\wedge\overline{\beta}
\]

is positive definite, and the Hecke operators \(T_p\) are self-adjoint for
\(h\).  On the primitive part of the Néron–Severi space of
\(X_0(N)\times X_0(N)\) the intersection form is negative definite; for
\(X_0(11)\) (genus one) the rank-three model has signature \((1,2)\).  This
is the finite-level Hodge index; it is a theorem for every \(N\).

The Hecke eigenvalues \(a_p\) of a weight-two newform satisfy the
Ramanujan–Petersson bound \(|a_p|\le2\sqrt p\), which is the positivity of the
Frobenius eigenvalues in the polarised Hodge structure.  The finite-level
check in [`../python/modular_tower.py`](../python/modular_tower.py) verifies
this for the level-11 form

\[
f=q\prod_{n\ge1}(1-q^n)^2(1-q^{11n})^2
\]

at small primes.

## 3. The dictionary conjecture

The CCM local term is

\[
\frac{\log p}{p^{k/2}}\bigl(f(p^k)+f(p^{-k})\bigr).
\]

The factor \(p^{-k/2}\) is the **half-weight** of the Hecke/Frobenius
eigenvalue; in the endomotive it is the modular operator
\(\Delta^{1/2}\) of the KMS state at \(\beta=1\).  The factor \(\log p\) is the
**length of the periodic orbit**, i.e. the transverse datum, not a Hodge
weight.

**Conjecture (tower dictionary).** *There is a map \(\Phi\) from the CCM test
functions to the Hecke algebra of the tower such that*

\[
s(f,f)=\lim_{N\to\infty}\bigl\langle \Phi_N(f),\Phi_N(f)\bigr\rangle_{\mathrm{HR}}
+\ \text{archimedean boundary term},
\]

*where \(\langle\cdot,\cdot\rangle_{\mathrm{HR}}\) is the Hodge–Riemann form
and the limit is taken in the KMS state at \(\beta=1\).*

If the conjecture holds, the Hodge–Riemann bilinear relations give the Hodge
index on the tower, and the CCM pairing is negative definite on degree-zero
classes.  This would be the absolute realization, with the Hodge index coming
from the Hodge–Riemann relations rather than Yuan–Zhang.

## 4. The precise missing theorem

The conjecture separates into two statements:

1. **Weight matching.** The half-weight \(p^{-k/2}\) is the modular operator
   \(\Delta^{1/2}\) of the \(\beta=1\) KMS state.  This is plausible from the
   Bost–Connes theory, but the \(\beta=1\) state is the critical (pole) state;
   the modular operator must be taken as a limit \(\beta\to1^+\).
2. **Transverse matching.** The \(\log p\) factor is the length of the periodic
   orbit, not a Hodge weight.  A Hodge–Riemann form alone cannot produce it;
   one needs a **transverse Hodge–Riemann inequality** that pairs the
   Hodge–Riemann form with the transverse measure.  This is the noncommutative
   analogue of the longitudinal HRR of
   [`../../intersection-form-zeta/notes/07-riemann-roch-square.md`](../../intersection-form-zeta/notes/07-riemann-roch-square.md).

The second is the hard step.  The finite-level Hodge–Riemann positivity gives
the weights but not the lengths; the endomotive gives the lengths but its
KMS weight is not the Hodge–Riemann form.  The absolute realization must
combine them.

## 5. Finite-level check

For \(X_0(11)\), the Hecke eigenvalues of \(f\) are

\[
a_2=-2,\quad a_3=-1,\quad a_5=1,\quad a_7=-2,\quad a_{13}=4,
\]

and \(|a_p|\le2\sqrt p\) holds.  The Hodge–Riemann form is positive definite
on \(H^{1,0}\oplus H^{0,1}\); the intersection form on the Néron–Severi space
of \(X_0(11)\times X_0(11)\) has signature \((1,2)\), the local model of
note 01.  These are the finite-level shadows of the tower dictionary; they do
not prove the limit.

## 6. What this changes

The algebraic candidates failed because they lacked the metric.  The tower
candidate has the metric (half-weight) and the Hodge–Riemann positivity, but
not the transverse length.  The missing theorem is now a **transverse
Hodge–Riemann inequality**, not an algebraic surface.  This is a different
and more concrete target than a proper polarized surface over a number field.

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[Fibered construction](01-fibered-construction.md)
