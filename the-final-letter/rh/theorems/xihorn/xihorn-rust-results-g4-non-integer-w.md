# G4 — done. Non-integer w adds no content

**Kind:** Claim
**Status:** VERIFIED (numerical; argument-principle count against sign-change count at 25 of 25 points, K = 110 and K = 130)
**Area:** xi-horn
**Source:** [`xi-horn/rust/RESULTS.md`](../../xi-horn/rust/RESULTS.md) — Summary, "G4 — done. Non-integer w adds no content"

## Statement

> **G4 — done. Non-integer w adds no content.** The computable half of **C2**,
> and it needed G6 first. The method is a **count**: the argument principle gives
> the number of zeros of the truncation inside |y| ≤ Y as an integer, bisection
> gives the number of sign changes on [−Y, 0), and if the two agree every zero in
> the disc is real and negative with no room for a conjugate pair. Over
> w ∈ [0, 12] in 24 steps, at K = 110 and K = 130, inside the disc |y| ≤ 3352
> that G6's law licenses: **the two counts agree at all 25 sample points, at both
> truncations** — twelve real zeros at w = 0, ten by w = 12 as the flow carries
> them past the boundary. So §8.2's "for every w" is the same condition as "for
> every even integer", and §8 is a repackaging — which §8.4 now says. What it
> does not establish is anything outside the disc or at complex w: a zero beyond
> the boundary is unseen, not absent.

## Hypotheses and notation

- The trusted disc is |y| ≤ (K/1.9)² = **3352** at K = 110, from G6's law with its largest measured constant — "the safe direction, since a larger c makes the disc smaller".
- The count is the winding number of F_K around |y| = Y (the argument principle, no poles to worry about) against the number of sign changes on [−Y, 0).
- Sample: w ∈ [0, 12] in 24 steps, 25 points, at K = 110 and K = 130.
- Driver `bin/g4_content`.

## Proof / evidence

Numerical, by two integer counts: agreement at all 25 sample points at both truncations. The regression: at w = 0 the disc holds exactly the −γ_k² it should, found to 6.5e−20 … 3.0e−16. The method was chosen over Aberth, which "was tried first and is the wrong tool here: the coefficients span three hundred decades, so it starts every root on a Cauchy circle far outside the region of interest and converges slowly."

## Dependencies and related results

- [G6 — one law, and it was predicted before it was measured](xihorn-rust-results-g6-k-req-law.md) — licences the trusted disc.
- [B2 — ten roots, and the root-finder changed](xihorn-rust-results-b2-ten-roots.md) — the same roots, by a different method.
- [B3 — the widest scan](xihorn-rust-results-b3-widest-scan.md) — the same distinction between unseen and absent for the R scan.

## Notes

- The source is explicit about the limit: "what it does **not** establish: anything outside the disc, and anything at complex w. A zero beyond the boundary is unseen, not absent."
- It also records that the answer is negative for the question's content: "the continuum is not stronger, and §8 is a repackaging".
