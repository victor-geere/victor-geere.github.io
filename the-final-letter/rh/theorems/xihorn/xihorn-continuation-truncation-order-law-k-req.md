# (G6) The truncation-order law K_req ≈ c·√|z|, and precision is not the co-limit

**Kind:** Claim
**Status:** VERIFIED (numerical; K_req identical at 30, 45, 60 and 90 working digits)
**Area:** xi-horn
**Source:** [`xi-horn/CONTINUATION.md`](../../xi-horn/CONTINUATION.md) — §8.3 "The flow", truncation control

## Statement

> **Truncation control, measured rather than guessed.** The earlier text said "only z₁ and z₂ are trustworthy … z₄ is a pure truncation artifact, complex and mobile". The first half was right; the second was not, and neither could be settled at the time, because nobody had measured how many terms a given root needs. TODO **G6** measured it. Writing K_req(w, k) for the fewest terms at which the k-th root reaches its converged place to a relative 10⁻⁶ **and stays there**:
>
> ```
>     k          1     2     3     4     5     6     7     8     9
>     K_req     20    32    40    50    56    66    74    78    90        (w = 0)
> ```
>
> and K_req grows slowly with w as well — 20, 22, 22, 24, 26, 28, 30, 34 for k = 1 at w = 0, 1, 2, 4, 6, 8, 12, 16. Both dependencies collapse onto one variable: **K_req ≈ c·√|z| with c measured at 1.42 rising to 1.88**, which is what the coefficient decay predicts — A(w+2j) falls like (C/j)^j, so the largest term of Σ A(w+2j)y^j/j! sits at j\* = √(C|y|/e).
>
> So at K = 34 the earlier text had enough terms for z₁ and z₂ and not for z₃ (which needs 40); z₄ and z₅ were **not present at all** in their brackets, and what it saw as "z₄, complex and mobile" was an artifact of the cut. The fourth zero is real, is −925.6731 = −γ₄², and needs fifty terms. TODO **E5** records the retraction; the general lesson is that an unstable root is evidence of nothing either way until K_req is known.
>
> One more thing G6 settles, because it was assumed both ways in earlier text: **precision is not the co-limit here.** The same K_req comes out at 30, 45, 60 and 90 working digits, identically. Only the truncation binds.

## Hypotheses and notation

- K_req(w, k) is the fewest terms at which the k-th root of the degree-K truncation of F(w, ·) reaches its converged place to a relative 10⁻⁶ **and stays there**.
- z_k are the negative real zeros of F(w, ·) (equation (29)); A(w+2j) are its coefficients.
- c is the constant in the measured law K_req ≈ c·√|z|, measured at 1.42 rising to 1.88.
- j\* = √(C|y|/e) is the index of the largest term of Σ A(w+2j)y^j/j!, predicted by A(w+2j) falling like (C/j)^j.

## Proof / evidence

The source reports the measurement (TODO **G6**): a K_req table at w = 0 for k = 1 … 9 (20, 32, 40, 50, 56, 66, 74, 78, 90), growth in w for k = 1 (20, 22, 22, 24, 26, 28, 30, 34 at w = 0, 1, 2, 4, 6, 8, 12, 16), collapse of both dependencies onto K_req ≈ c·√|z| with c = 1.42 rising to 1.88, and the observation that the same K_req is obtained at 30, 45, 60 and 90 working digits. The predicted j\* = √(C|y|/e) is matched to the coefficient decay A(w+2j) ~ (C/j)^j.

## Dependencies and related results

- The two-variable object F(w, y) (29): [xihorn-continuation-two-variable-f-object.md](xihorn-continuation-two-variable-f-object.md).
- The zero flow whose roots are resolved: [xihorn-continuation-zero-flow.md](xihorn-continuation-zero-flow.md).
- The zero count inside a disc, which relies on G6's law to size the disc: [xihorn-continuation-non-integer-w-no-content.md](xihorn-continuation-non-integer-w-no-content.md).

## Notes

- The law K_req ≈ c·√|z| is a measured fit with c varying from 1.42 to 1.88, not an exact formula; the source says "which is what the coefficient decay predicts".
- TODO **E5** records the retraction of the earlier "z₄ is a pure truncation artifact, complex and mobile" claim; the fourth zero is real, −925.6731 = −γ₄², and needs fifty terms.
- The k = 1 growth list "20, 22, 22, 24, 26, 28, 30, 34" has eight entries paired in the source with w = 0, 1, 2, 4, 6, 8, 12, 16.
