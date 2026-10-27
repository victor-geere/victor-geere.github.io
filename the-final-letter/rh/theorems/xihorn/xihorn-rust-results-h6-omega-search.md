# H6 — done. O'S picked the optimal Gaussian; the translation was left on the table

**Kind:** Claim
**Status:** VERIFIED (numerical; T identical at 60, 120 and 240 digits at every d from 100 to 1400)
**Area:** xi-horn
**Source:** [`xi-horn/rust/RESULTS.md`](../../xi-horn/rust/RESULTS.md) — Summary, "H6 — done. [O'S] picked the optimal Gaussian; the translation was left on the table, and it is worth a change of exponent"

## Statement

> **H6 — done. [O'S] picked the optimal Gaussian; the translation was left on the
> table, and it is worth a change of exponent.** One formula contains both
> papers' criteria (validated to 6.05e−77 against (8.2) and 8.39e−69 against
> (2.9)), and the search has two dials because the Laguerre–Pólya class already
> contains the affine group. **ν** — the Hermite content of Ω — has a
> razor-sharp optimum exactly at [O'S]'s Ω = e^{−z²}: a 1% move costs four
> decades either way. **μ** — the translation — does not: χ₂(μ) = γ(n+2) −
> 2μγ(n+1) + μ²γ(n) has roots **μ± = γ(n+1)/γ(n)·(1 ± √2·Δ(n+2))**, with Δ the
> uniformizer [GOR⁺] introduce for J, and at μ± the dominant term of Turán's sum
> vanishes: T at (8,20) falls from 5.412e−7 to **2.662e−16**. That changes the
> power of d from **d^3.015** to **d^4.011**, takes d_max at n = 0 from **400 to
> 10141**, and gives n₀(d) = 0 for every d ≤ 1000 where [O'S]'s P needs up to
> 23. Every other Ω tried is worse: the Bessel family of [O'S] Theorem 3.9,
> cos z, Ω = 1 in either form and every non-unit Gaussian all fail at d = 2 or 3.
> And d_max is **not** scale-invariant — measured d_max ∝ σ^{−4/3} to three
> figures (**E19**).

## Hypotheses and notation

- The one formula is the Turán value T = Σ_{k=0}^{d−2} 2^k·k!·c_k² / (2^d·(d−1)!·c_d²) < 1 with c_k = C(d, d−k)·χ_{d−k} and χ_j = Σ_i C(j,i)·γ(n+i)σ^i·M_{j−i}, M := Ω(σz)·e^{z²}.
- ν = 1 − βσ² is the Gaussian dial; μ the translation; the shift τ = μ− is computed once at n = 0 and applied at every n, as Theorem 3.5 requires.
- d_max is the largest d with T < 1 at n = 0, σ = 1; driver `bin/h6_omega`, module `omega`.

## Proof / evidence

Numerical, with the two published criteria as validation points (6.05e−77 for [O'S] (8.2), 8.39e−69 for [GOR⁺] (2.9), 50 cells each) and a precision cross-check: T is identical at 60, 120 and 240 digits at every d from 100 to 1400.

## Dependencies and related results

- [[H6 from H_track.md](xihorn-h-track-h6-omega-search.md) — the track's fuller account, including the leaderboard, the dial tables and the verdict.
- [[O'S] Theorem 3.5](xihorn-todo-os-theorem-3-5.md) — the criterion the search ranges over.
- [H3 — a table neither paper has](xihorn-rust-results-h3-turan-onset.md) — supplies the cost function; E19 qualifies its "d ≤ 400".
- [G6 — the truncation law](xihorn-rust-results-g6-k-req-law.md).

## Notes

- **E19**: "d ≤ 400 at n = 0" is a property of a normalisation, not of Ω; the comparison 400 against 7 remains correct "as a statement about **those two published criteria**".
- The source repeats that nothing here is closer to RH — these are sufficient conditions on finitely many (d, n).
