# H5 — done. [O'S] Table 1 reproduced from its own coefficient chain, and the asymptotic is not a shortcut

**Kind:** Claim
**Status:** VERIFIED (numerical; all four Table 1 rows to every digit printed; c₁ to 5.0e−76)
**Area:** xi-horn
**Source:** [`xi-horn/rust/RESULTS.md`](../../xi-horn/rust/RESULTS.md) — Summary, "H5 — done. [O'S] Table 1 reproduced from its own coefficient chain, and the asymptotic is not a shortcut"

## Statement

> **H5 — done. [O'S] Table 1 reproduced from its own coefficient chain, and the
> asymptotic is not a shortcut.** Theorem 1.4's c_k are described through five
> formulas resting on partial ordinary Bell polynomials; all of it is
> implemented, and it reproduces μ₁, c₁ (to 5.0e−76), c₂, Stirling's κ_m =
> 1, 1/12, 1/288, −139/51840, −571/2488320, and **all four rows of Table 1** at
> n = 1000 to every digit printed. Where the series turns around: **7 digits at
> n = 3, 11 at n = 10**, still rising at K = 24 for n ≥ 200 (58.5 digits at
> n = 1000). It costs **four times more** than the quadrature at K = 24 and stops
> at 21 digits at K = 7, so the quadrature stays. [GOR⁺]'s L_M is checked against
> W(2n/π) through the derived gap w − L ≈ (3L/8+1)/((π/2)e^L(1+L)), three to four
> figures at every n; and (3.2)'s ambiguous radical is settled by the same factor
> of 8 — √(2π/K) tends to 8, 1/√(2πK) to 4/π.

## Hypotheses and notation

- The c_k chain rests on the partial ordinary Bell polynomials B̂_{i,j} of [O'S] (2.1): ℓ_i (2.6), a_r (7.4), μ_r (7.7), κ_m (7.11), κ*_k and c_k (7.13).
- w := W(2n/π); [GOR⁺]'s alternative parameter is L_M, the unique positive root of M = L_M·(π·e^{L_M} + ¾).
- Driver `bin/h5_asymptotic`; module `lambert`.

## Proof / evidence

Numerical: μ₁, c₁ (to 5.0e−76 relative), c₂, Stirling's κ_m from (7.11) alone, (7.14) against the crate's exact n!/(2n)!, all four rows of [O'S] Table 1 at n = 1000 to every digit printed, and the L_M-versus-W gap relation holding to three or four figures at every n. The turnaround and the timing comparison are measured rather than assumed.

## Dependencies and related results

- [[H5 from H_track.md](xihorn-h-track-h5-lambert-w-asymptotic.md) — the track's fuller account with the tables.
- [O'S Theorem 1.4](xihorn-todo-os-theorem-1-4.md) — the quoted asymptotic.
- [H1 — a(1000) matches O'S Table 1](xihorn-rust-results-h1-a1000-against-os-table-1.md) — the same value from another direction.
- [G5 — done, and the answer is 4](xihorn-rust-results-g5-watson-constant-4.md) — reuses Lambert's W from this module.

## Notes

- The radial ambiguity of (3.2) is settled by the same factor of 8; **E18** applies to both (3.1) and (3.2).
