# B2 — done. Ten roots, and the root-finder changed

**Kind:** Claim
**Status:** VERIFIED (numerical; every entry stable between K = 128 and K = 140)
**Area:** xi-horn
**Source:** [`xi-horn/rust/RESULTS.md`](../../xi-horn/rust/RESULTS.md) — Summary, "B2 — done. Ten roots, and the root-finder changed"

## Statement

> **B2 — done. Ten roots, and the root-finder changed.** Bisection inside a
> one-root bracket instead of a global solve: it needs only the sign of F, cannot
> converge to a neighbour, and cannot report a root outside the bracket. Ten
> roots at w = 0 against −γ_k², five columns (z₁ … z₅) across w = 0 … 12, every
> entry stable between K = 128 and K = 140. This is the table **A4** pastes into
> CONTINUATION §8.3 in place of one whose z₂ column was wrong at w = 0, 8 and 12.

## Hypotheses and notation

- F(w, ·) is the flow function of CONTINUATION §8; at w = 0 its zeros are exactly −γ_k².
- The method is bisection inside a one-root bracket — it needs only the sign of F, cannot converge to a neighbour, and cannot report a root outside the bracket; Aberth is kept and agrees but is no longer what is trusted.
- Stability is asserted between K = 128 and K = 140; ten roots at w = 0 against −γ_k² for k = 1 … 10, agreeing to 6.5e−20 … 3.0e−16 relative at K = 170.
- Driver `bin/b2_flow [k] [digits]`; module `flow.rs`.

## Proof / evidence

Numerical: ten roots at w = 0 matched against −γ_k² to 6.5e−20 … 3.0e−16 (the twenty-digit γ_k table's own rounding), five columns across w = 0 … 12 stable between K = 128 and K = 140, and the root-finder change that made it work. The source records that the earlier two-root resolution and its z₄ call were superseded (see the other B2 entry).

## Dependencies and related results

- [B2 — z₄ is not a truncation artifact](xihorn-rust-results-b2-z4-not-an-artifact.md) — the earlier B2 result this supersedes.
- [G6 — one law, and it was predicted before it was measured](xihorn-rust-results-g6-k-req-law.md) — "K_req is no longer open".
- [G4 — non-integer w adds no content](xihorn-rust-results-g4-non-integer-w.md) — a regression on the same roots.

## Notes

- The source records **E20** against this work: a bracket wide enough to hold two roots has no sign change at all, so bisection reports "no root" exactly where the root is best resolved — hit twice while building G6.
