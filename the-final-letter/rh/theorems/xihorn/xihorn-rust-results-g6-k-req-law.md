# G6 — done. One law, and it was predicted before it was measured

**Kind:** Claim
**Status:** VERIFIED (numerical; K_req identical at 30, 45, 60 and 90 digits; anchor external, matched to 6.5e−20 … 3.0e−16)
**Area:** xi-horn
**Source:** [`xi-horn/rust/RESULTS.md`](../../xi-horn/rust/RESULTS.md) — Summary, "G6 — done. One law, and it was predicted before it was measured"

## Statement

> **G6 — done. One law, and it was predicted before it was measured.**
> K_req(w,k) is the fewest terms at which the k-th root of F(w, ·) reaches its
> converged place to a relative 10⁻⁶ **and stays there**. At w = 0 it runs
> **20, 32, 40, 50, 56, 66, 74, 78, 90, 94** for k = 1 … 10, and 20, 22, 22, 24,
> 26, 28, 30, 34, 40 for k = 1 across w = 0 … 24. **Forty-one measurements from
> nine values of w and ten root indices collapse onto one curve**: K_req/√|z|
> rises smoothly from **1.415 to 1.889** while √|z| runs 14.1 → 49.8, fitted
> exponent 1.229 in √|z|. That is what the coefficient decay predicts —
> A(w+2j) falls like (C/j)^j, so the largest term of Σ A(w+2j)y^j/j! sits at
> j\* = √(C|y|/e), giving K_req a function of |z| alone plus the logarithmic
> drift C carries. The anchor is **external**: at w = 0 the roots are −γ_k²,
> matched to 6.5e−20 … 3.0e−16 at K = 170 — the twenty-digit γ_k table's own
> rounding. And **precision does not bind**: identical K_req at 30, 45, 60 and
> 90 digits (**E21**).

## Hypotheses and notation

- K_req(w, k) is the fewest terms at which the k-th root of F(w, ·) reaches its converged place to a relative tolerance 10⁻⁶ **and stays there for every larger K** — "the second half being what separates a law from a coincidence".
- A(w+2j) is a(j + w/2); the prediction is K_req a function of √|z| alone.
- Forty-one measurements: nine values of w and ten root indices; driver `bin/g6_kreq`, module `flow.rs`.

## Proof / evidence

Numerical, with the law predicted from the coefficient decay before measurement, the collapse of 41 measurements onto one curve (K_req/√|z| from 1.415 to 1.889 as √|z| runs 14.1 → 49.8, fitted exponent 1.229), the external anchor at w = 0 (−γ_k² from the twenty-digit table, matched to 6.5e−20 … 3.0e−16 at K = 170), and the precision check (identical K_req at 30, 45, 60 and 90 digits).

## Dependencies and related results

- [G6 in TODO.md](../../xi-horn/TODO.md) — the register entry for the same measurements; H_track.md does not cover G6.
- [B2 — ten roots, and the root-finder changed](xihorn-rust-results-b2-ten-roots.md) — the root-finder change that made K_req measurable; K_req "is no longer open — see G6".
- [G4 — non-integer w adds no content](xihorn-rust-results-g4-non-integer-w.md) — uses G6's law to licence the trusted disc |y| ≤ 3352.
- [O'S] Theorem 1.4 — [harvested](xihorn-h-track-os-theorem-1-4.md) — the coefficient decay the prediction rests on.

## Notes

- **E21**: the premise that "the two limits bind together — truncation and precision" is wrong; only truncation binds, and at 30 digits requested the answer is already the one 90 digits gives.
- **E20** records a bracket bug hit twice while building this, including a false "K_req(10) > 170" that survived a whole run.
