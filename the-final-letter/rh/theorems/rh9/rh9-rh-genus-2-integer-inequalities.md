# RH for this curve, in integers

**Kind:** Theorem
**Status:** PROVED (paper argument; VERIFIED exactly in integer arithmetic at p = 7, 11, 13, 17, 19, 23, 29, 31)
**Area:** rh-html
**Source:** [`rh9.html`](../../html/rh9.html) — §5 "Genus 2, and RH as two integer inequalities", theorem box at lines 909–912

## Statement

> <i>e</i>₁² − 4(<i>e</i>₂ − 2<i>q</i>) ≥ 0 and <i>b<sub>j</sub></i>² ≤ 4<i>q</i>. Two inequalities in integers derived from two point counts. Verified at <i>p</i> = 7, 11, 13, 17, 19, 23, 29, 31 — exactly, in integer arithmetic, and independently by finding the four roots numerically and confirming they share the modulus <i>q</i><sup>−1/2</sup> to 10<sup>−7</sup>.

## Hypotheses and notation

- The curve is <i>C</i>: <i>y</i>² = <i>x</i>⁵ + <i>x</i> + 1, of genus 2 over 𝔽<sub><i>q</i></sub> (computed at prime <i>q</i> = <i>p</i>).
- <i>N</i>₁, <i>N</i>₂ are the point counts over 𝔽<sub><i>p</i></sub> and 𝔽<sub><i>p</i>²</sub>; the whole <i>L</i>-polynomial is determined by them, because the functional equation fixes the rest: (7) <i>L</i>(<i>T</i>) = 1 − <i>e</i>₁<i>T</i> + <i>e</i>₂<i>T</i>² − <i>q e</i>₁<i>T</i>³ + <i>q</i>²<i>T</i>⁴, with <i>e</i>₁ = <i>q</i>+1−<i>N</i>₁ and <i>e</i>₂ = (<i>e</i>₁² − (<i>q</i>²+1−<i>N</i>₂))/2.
- The substitution <i>u</i> = <i>x</i> + <i>q</i>/<i>x</i> in the reciprocal polynomial factors it into two real quadratics <i>x</i>² − <i>b<sub>j</sub>x</i> + <i>q</i>, whose coefficients are the roots of <i>u</i>² − <i>e</i>₁<i>u</i> + (<i>e</i>₂ − 2<i>q</i>) = 0.
- |α| = √<i>q</i> for all four roots exactly when both <i>b<sub>j</sub></i> are real with |<i>b<sub>j</sub></i>| ≤ 2√<i>q</i>; the two displayed inequalities are the integer forms of that condition.

## Proof / evidence

The source derives the equivalence by the substitution <i>u</i> = <i>x</i> + <i>q</i>/<i>x</i>: the reciprocal polynomial factors into two real quadratics <i>x</i>² − <i>b<sub>j</sub>x</i> + <i>q</i>, and |α| = √<i>q</i> for all four roots is equivalent to both <i>b<sub>j</sub></i> real with |<i>b<sub>j</sub></i>| ≤ 2√<i>q</i>.

It reports the verification: at <i>p</i> = 7, 11, 13, 17, 19, 23, 29, 31, "exactly, in integer arithmetic, and independently by finding the four roots numerically and confirming they share the modulus <i>q</i><sup>−1/2</sup> to 10<sup>−7</sup>."

## Dependencies and related results

- Hasse's theorem (1933) is stated in rh9 §4 for the elliptic (genus 1) case: zeros on |<i>T</i>| = <i>p</i><sup>−1/2</sup> ⟺ <i>a<sub>p</sub></i>² ≤ 4<i>p</i>; computed over all 780 good primes below 6000, with maximum ratio |<i>a<sub>p</sub></i>|/(2√<i>p</i>) = 0.991668.
- rh9 §8 gives the mechanism behind the rigidity: Weil's proof runs on the surface <i>C</i> × <i>C</i>, where the Hodge index theorem makes the intersection form definite on the relevant subspace and Cauchy–Schwarz forces |α| = √<i>q</i>.
- The source's §2 box "The consequence" (a `box rh`, not harvested) states the rationality Z(<i>T</i>) = <i>L</i>(<i>T</i>)/((1−<i>T</i>)(1−<i>qT</i>)) with <i>L</i> of degree 2<i>g</i>, hence finitely many zeros.

## Notes

- The rigidity for curves over finite fields is the Hasse–Weil theorem (CITED literature; the source's own §8 credits the Hodge index theorem on <i>C</i> × <i>C</i>). This box states the genus-2 form of it as two integer inequalities and records the finite integer certificates; the status is given for what the box itself establishes and checks.
- The source's framing: "Here it is a finite check on a quartic. The difference is not that the mathematics is easier; it is that <b>the object is finite-dimensional</b>."
- The verification set <i>p</i> = 7, 11, 13, 17, 19, 23, 29, 31 and the precision 10<sup>−7</sup> are quoted exactly.
