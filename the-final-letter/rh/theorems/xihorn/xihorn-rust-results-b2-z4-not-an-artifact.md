# B2 — z₄ is not a truncation artifact; §8.3's z₂ row is wrong

**Kind:** Claim
**Status:** VERIFIED (numerical; 60 digits, K = 48 and 60)
**Area:** xi-horn
**Source:** [`xi-horn/rust/RESULTS.md`](../../xi-horn/rust/RESULTS.md) — Summary, "B2 — three zeros resolved where CONTINUATION §8.3 resolved two, and its z₄ call was wrong"

## Statement

> **B2 — three zeros resolved where CONTINUATION §8.3 resolved two, and its z₄
> call was wrong.** At K = 48 and 60 digits, w = 0 gives z₁, z₂, z₃ =
> −199.7905, −441.9262, −625.5430, all correct to the digits printed against
> −γ₁², −γ₂², −γ₃² — so z₃, "still drifting at K = 40" in §8.3, is resolved. And
> z₄ = **−925.6828** against −γ₄² = −925.67309, a relative 1.0e−05: it is not
> "a pure truncation artifact", it is the fourth zero under-resolved. Two
> further findings: §8.3's z₂ row is **wrong** at w = 0 (it prints −442.41 where
> the exact answer is −441.9262), at w = 8 and at w = 12; and the truncation
> requirement **grows with w** — at w = 12, K = 40 and K = 48 still disagree on
> z₃ by 9%. So "z₂ stabilises from K = 28" is a small-w statement.

## Hypotheses and notation

- F(w, ·) is the flow function of CONTINUATION §8; at w = 0 its zeros are exactly −γ_k².
- z_k denotes the k-th zero in w = 0 ordering; K is the truncation order of the series used.
- The anchor is external: the twenty-digit γ_k table.

## Proof / evidence

Numerical at K = 48 and 60 digits: z₁, z₂, z₃ = −199.7905, −441.9262, −625.5430 match −γ₁², −γ₂², −γ₃² to the digits printed; z₄ = −925.6828 against −γ₄² = −925.67309, a relative 1.0e−05, so it is "the fourth zero under-resolved", not spurious. The z₂ row error and the growth of the truncation requirement with w are both measured (at w = 12, K = 40 and K = 48 still disagree on z₃ by 9%).

## Dependencies and related results

- [B2 — ten roots, and the root-finder changed](xihorn-rust-results-b2-ten-roots.md) — the later, superseding B2 result.
- [A3 — Γ_Φ near w = 0](xihorn-rust-results-a3-gamma-phi-near-zero.md) — the exact zeros −γ_k².
- [G6 — the truncation law](xihorn-rust-results-g6-k-req-law.md) — measures the K_req that this entry's "under-resolved" reading implied.

## Notes

- **E5** records the same correction: "z₄ is a pure truncation artifact" is wrong; at K = 48 it lands 1.0e−05 from −γ₄². The general lesson is stated in E5: "an unstable root is *evidence of nothing either way* until K_req is known (**G6**)."
