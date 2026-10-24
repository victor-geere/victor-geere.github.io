# (10) There is no ceiling over all windows of support Δ — the min–max is +∞

**Kind:** Theorem
**Status:** PROVED (paper argument)
**Area:** rh-html
**Source:** [`rh25.html`](../../html/rh25.html) — §4 "(c) The supremum over all windows", equations (9)–(10)

## Statement

> It is, and the analysis says the question has no answer. Start with the observation that makes it elementary:
>
> (9) at v = 0 the comb is empty, because ln 2 = 0.693 > 2Δ = 0.48 and C<sub>h</sub> is supported in [−2Δ, 2Δ].
>
> So E<sub>h</sub>(0) — the diagonal entry of every section in the arc — is pole plus arch and contains no prime power at all. It is pure archimedean, and the archimedean term is (1/π)∫Ĉ<sub>h</sub>(r)ψ̃(r)dr with ψ̃(r) = Re ψ(¼ + ir/2) − ln π growing like ln(r/2). Put the window's energy at frequency r₀ and the integral has to follow.
>
> Explicitly, for h(t) = √2 cos(r₀t)φ<sub>Δ</sub>(t) at unit energy, E<sub>h</sub>(0)/C<sub>h</sub>(0) equals ψ̃(r₀) to 0.05% at r₀ = 200, 10³, 5×10³ and 2.5×10⁴ — three decades, three digits. And inside the M-family, where the machinery of §3 computes the maximum exactly, the largest attainable value is ψ̃ at the family's own band edge to 0.28%: 2.809 at M = 8, 5.596 at M = 128, rising by about ln 2 at every doubling and not stopping. Nothing can cancel it. Both of the other terms are bounded uniformly in h at a fixed section size: the comb at node v is at most the gear mass there times sup|C<sub>h</sub>| ≤ C<sub>h</sub>(0), and the pole is 2ĥ(i/2)²cosh(v/2) ≤ 4Δcosh²(Δ/2)cosh(v/2)·C<sub>h</sub>(0) by Cauchy–Schwarz on the support. Only the arch grows. So for any test vector c, choosing r₀ where the almost-periodic T(r) = |Σ<sub>p</sub>c<sub>p</sub>e<sup>irv<sub>p</sub></sup>|² is near its supremum makes c<sup>T</sup>T<sub>h</sub>c as large as one likes. Hence
>
> (10) min<sub>c</sub> max<sub>h</sub> c<sup>T</sup>T<sub>h</sub>c = +∞ over h supported in [−Δ, Δ] at unit energy, for every test set.
>
> while m₀ = max<sub>h</sub> min<sub>c</sub> stays finite, because for a given high-frequency h the minimising c is free to sit at a zero of T — and T, a non-negative trigonometric polynomial of degree n−1 per period, has plenty. **The duality gap is infinite.** There is no ceiling over all windows of support Δ, not because nobody has computed it but because the quantity it would bound is unbounded.

## Hypotheses and notation

- Δ = 0.24; C<sub>h</sub> = h⋆ȟ is supported in [−2Δ, 2Δ]; ln 2 = 0.693 > 2Δ = 0.48, so the comb is empty at v = 0.
- ψ̃(r) = Re ψ(¼ + ir/2) − ln π grows like ln(r/2); Ĉ<sub>h</sub>(r) = |ĥ(r)|².
- The explicit sequence is h(t) = √2 cos(r₀t)φ<sub>Δ</sub>(t) at unit energy; T(r) = |Σ<sub>p</sub>c<sub>p</sub>e<sup>irv<sub>p</sub></sup>|² is the test-vector trigonometric polynomial, non-negative of degree n−1 per period.
- m₀ = max<sub>h</sub>min<sub>c</sub>; the ceiling sought was min<sub>c</sub>max<sub>h</sub>.

## Proof / evidence

- At v = 0 the kernel is pole plus arch only, so E<sub>h</sub>(0) is controlled by the archimedean integral (1/π)∫Ĉ<sub>h</sub>(r)ψ̃(r)dr, which grows like ln(r/2) when the energy is placed at frequency r₀.
- Uniform bounds on the other two terms, quoted verbatim: the comb term ≤ gear mass · sup|C<sub>h</sub>| ≤ C<sub>h</sub>(0); the pole term ≤ 4Δcosh²(Δ/2)cosh(v/2)·C<sub>h</sub>(0) by Cauchy–Schwarz.
- Numerical corroboration: E<sub>h</sub>(0)/C<sub>h</sub>(0) equals ψ̃(r₀) to 0.05% at r₀ = 200, 10³, 5×10³, 2.5×10⁴; inside the M-family the maximum is ψ̃ at the family's own band edge to 0.28% (2.809 at M = 8, 5.596 at M = 128).
- m₀ stays finite because the minimising c can sit at a zero of T.

## Dependencies and related results

- Retires the question raised by [rh24's family ladder](../rh24/rh24-family-ladder-convergence.md): "rh24 observed the ceilings growing along the ladder and asked for the version over *all* h of support Δ".
- [rh22's ceiling (3)](../rh22/rh22-ceiling-for-every-window.md) and [rh23's comparison](../rh23/rh23-ceiling-comparison-8-vs-16.md) bound only their own families and are unaffected: "The published ceilings remain theorems about the families they were computed for; nothing rh22–rh24 asserted is affected."
- The source's own successor item: "Any ceiling over a larger class has to control the frequency content of h, and the family index M is precisely such a control."

## Notes

- The source labels this "genuinely analysis rather than computation" and states that it "dissolved the question rather than answering it".
- The numbers 0.693, 0.48, 0.05%, 0.28%, 2.809, 5.596, ln 2 are quoted exactly.
