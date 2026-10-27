# Remark F.11 (What Lemma F.10 shows, and the sign of \(\Lambda\))

| Field | Value |
|---|---|
| Type | Remark |
| Status | Remark |
| Source | [publication.html Addendum F](../../geometric-dynamical-phase-transitions/publication.html#addf) · Addendum F. Quantum answers: where the physics literature sits against each gap |
| Proof in source | no separate proof block |

## Statement

Nothing in Sections 4–12 evaluates the polygon at more than one zero at a time; Lemma F.10 is the first statement in the paper that sums it over zeros, and the moment it does, the Euler product appears as \(\Lambda\). Landau's argument is the residue computation of \(\int x^{s}(\zeta'/\zeta)(s)\,ds\), and it applies verbatim to any Dirichlet series with a functional equation and leading coefficient \(1\), with \(\Lambda\) replaced by the coefficients \(\Lambda_f\) of \(-f'/f\) (a Dirichlet series for \(\sigma\) large) and the zeros in \(\sigma>1\) included in the sum. So the *form* of Lemma F.10 transfers to the Davenport–Heilbronn twist and fails the litmus; what does not transfer is the *sign*: \(\Lambda(m)\ge0\), whereas \(\Lambda_f(m)\) is complex with no sign. That is Weil positivity's prime side in the polygon's own coordinates — the arithmetic positivity of Section 14, located in the register. On the tightness window (\(T\le N^{1/2-\varepsilon}\)) the error term \(N^4\log N\) swamps the main term, so the polygon cannot use Lemma F.10 where it works; in the regime \(T\gg N^4\log N\) the formula is informative and the polygon's pointwise control (Theorem 4.3) is not. The two regimes do not overlap, which is one more description of the wall.

## Proof

_No separate proof is given in the source. The statement is either a definition, a remark, a cited result, or is argued inline in the surrounding section._
