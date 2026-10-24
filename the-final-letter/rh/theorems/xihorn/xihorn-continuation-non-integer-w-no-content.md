# (G4) Non-integer w adds no content — every zero is real and negative at and between the integers

**Kind:** Claim
**Status:** VERIFIED (numerical; bounded disc |y| ≤ 3352, real w only)
**Area:** xi-horn
**Source:** [`xi-horn/CONTINUATION.md`](../../xi-horn/CONTINUATION.md) — §8.4 "What this does and does not achieve"

## Statement

> **And the "for every w" is not doing any work, which is now measured rather than suspected.** §8.2 asks for F(w, ·) ∈ LP at *every* w where the classical criterion needs it only at the even integers, so the natural question is whether the continuum is stronger: does F(w, ·) acquire a complex zero at some non-integer w? TODO **G4** answers it, by counting rather than root-finding — the argument principle gives the number of zeros of the truncation inside |y| ≤ Y as an integer, and bisection gives the number of sign changes on [−Y, 0), and if the two agree there is no room for a conjugate pair.
>
> Over w ∈ [0, 12] in 24 steps, at two truncations (K = 110 and K = 130), inside the disc |y| ≤ 3352 that G6's law says a K = 110 truncation can speak for: **the two counts agree at all 25 sample points, at both truncations, without exception.** Every zero is real and negative, at the integers and between them.
>
> So within reach, **non-integer w adds no content**: "for every w" is the same condition as "for every even integer", and §8's continuation of the index is a repackaging. That is worth knowing and worth saying — it is the direction that decides whether §8 is more than presentation, and the answer is that it is not. What it is not is a proof: the disc is finite, the scan is over real w only, and a zero outside is unseen rather than absent — the same distinction that governs the R − 1 scan in §4.

## Hypotheses and notation

- F(w, ·) = Σ_{j≥0} A(w+2j)·y^j/j! is the two-variable object of (29).
- The counting method is the argument principle (number of zeros of the truncation inside |y| ≤ Y as an integer) against bisection (number of sign changes on [−Y, 0)); agreement leaves no room for a conjugate pair.
- Scan parameters: w ∈ [0, 12] in 24 steps (25 sample points), truncations K = 110 and K = 130, disc |y| ≤ 3352 — the radius G6's law says a K = 110 truncation can speak for.
- LP is the Laguerre–Pólya class.

## Proof / evidence

The source reports a numerical count (TODO **G4**): at both truncations, the argument-principle count and the sign-change count agree at all 25 sample points, so every zero in the disc is real and negative, at and between the integers. The disc radius is justified by the truncation-order law K_req ≈ c·√|z| of G6. The source states the limitations explicitly: the disc is finite, the scan is over real w only, and a zero outside is unseen rather than absent.

## Dependencies and related results

- The two-variable object F(w, y) (29): [xihorn-continuation-two-variable-f-object.md](xihorn-continuation-two-variable-f-object.md).
- The truncation-order law used to size the disc: [xihorn-continuation-truncation-order-law-k-req.md](xihorn-continuation-truncation-order-law-k-req.md).
- The same unseen-vs-absent distinction for the R − 1 scan: [xihorn-continuation-no-zero-of-r-minus-one.md](xihorn-continuation-no-zero-of-r-minus-one.md).

## Notes

- The source's conclusion is deliberately narrow: within the tested disc and for real w, the continuum adds no content; this is "not a proof".
- The source's surrounding remarks — "Restating uniformity is not obtaining it" and "the LP condition on F(w, ·) for all w is exactly as hard as it was — it is RH, rewritten once more" — are recorded in the companion file for (29).
