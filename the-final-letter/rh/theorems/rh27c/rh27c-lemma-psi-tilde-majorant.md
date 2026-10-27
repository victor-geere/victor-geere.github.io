# (a) The lemma — ψ̃(r) ≤ ln((2 + r)/2π)

**Kind:** Lemma
**Status:** PROVED (paper argument; verified on its head and its tail by separate arguments, sharpness by the −2/r law)
**Area:** rh-html
**Source:** [`rh27c.html`](../../html/rh27c.html) — §2 "(a) The lemma, and how little room is in it", eq. (1)

## Statement

> Everything in this document rests on one inequality:
>
> `ψ̃(r) = Re ψ(¼ + ir/2) − ln π  ≤  ln((2 + r)/2π)   for every r ≥ 0.`
>
> Two things make it worth stating rather than assuming. It is **concave** on the right, which is what lets Jensen through in §3; and it is **tight**, which is what makes the resulting ceiling sharp rather than merely finite.

The constant is sharp:

> The constant is sharp: the gap is negative at every finite r and closes like −2/r, so nothing smaller than ln(1/2π) works. It also explains a constant rh17 reported and did not derive — ψ̃(r) = ln(r/2π) + O(r<sup>−2</sup>), so r₊ is 2π to the accuracy of that remainder, and rh17's measured 6.289836 sits 0.0067 above it.

## Hypotheses and notation

- ψ̃(r) = Re ψ(¼ + ir/2) − ln π, ψ the digamma function.
- The inequality holds for every r ≥ 0; the right-hand side is ln((2 + r)/2π).
- ψ̃ is increasing (its r-derivative is Σ<sub>n≥0</sub> (n+¼)(r/2)/((n+¼)² + r²/4)², every term positive), which is what handles the head [0, 1].
- r₊ = 6.289836 is the measured zero of ψ̃; 2π = 6.283185; the gap closes like −2/r.

## Proof / evidence

Paper argument, in two parts, as the source gives it:

- **The tail, r ≥ 1.** Binet's second formula ψ(z) = ln z − 1/(2z) − 2∫<sub>0</sub><sup>∞</sup> t dt/((t² + z²)(e<sup>2πt</sup> − 1)); at z = ¼ + ir/2 the denominator satisfies |t² + z²| ≥ |Im z²| = r/4 for every t ≥ 0, and 2∫<sub>0</sub><sup>∞</sup> t dt/(e<sup>2πt</sup> − 1) = Γ(2)ζ(2)/(2π)² = 1/12 exactly, so the integral term is at most 1/(3r) in modulus. Re(1/2z) = (1/8)/(1/16 + r²/4) is positive and is discarded in the safe direction. Hence ψ̃(r) ≤ ½ln(1/16 + r²/4) − ln π + 1/(3r), leaving a margin ln(2(2+r)/√(1+4r²)) − 1/(3r), which is 0.6537 at r = 1 and shrinks like (5/3)/r. Positive throughout, checked out to r = 1.6×10⁵.
- **The head, 0 ≤ r ≤ 1.** The same estimate turns negative below r ≈ 0.24, so the head is done separately from monotonicity of ψ̃: on a panel [a, b] the left side is at most ψ̃(b) and the right at least ln((2+a)/2π), and 4000 panels give sup(ψ̃ − ln((2+r)/2π)) ≤ −1.2858 on [0, 1]. The source notes there is a factor e<sup>1.28</sup> of room at the low end.

The check suite reports the lemma "verified on its head and its tail by separate arguments and its sharpness by the −2/r law" and Binet's constant recomputed rather than cited.

## Dependencies and related results

- Binet's second formula; the digamma series; Γ(2)ζ(2)/(2π)² = 1/12.
- It explains rh17's measured r₊ = 6.289836 and the arc's L1 constant ([rh27a-l1-one-sided-cut](../rh27a/rh27a-l1-one-sided-cut.md)).
- It is the input to [rh27c-family-free-ceiling](rh27c-family-free-ceiling.md).

## Notes

- The source stresses "the constant ln(1/2π) is therefore the smallest that works"; the gap is negative at every finite r, so the inequality is strict.
- The inequality is nowhere near tight at the low end (a factor e<sup>1.28</sup> of room on [0, 1]).
