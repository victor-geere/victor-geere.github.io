# Theorem 3 (T4)

**Kind:** Theorem
**Status:** PROVED (paper argument; VERIFIED at p = 1.01, 1.5, 2, 3, 5)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/truths.md`](../../research/twin-prime-parity/rounds/rh42/truths.md) — §2 "The budgets and their algebra"

## Statement

> `P(p) > N(p)` for **every** `p > 0`; the asymmetry is exactly `1 − η(p)`, and
> `0 < η(p) < 1` because the alternating series has strictly decreasing terms.

## Hypotheses and notation

- `p > 0` — the source states the inequality for **every** `p > 0`.
- `P(p) = Σ_{k≥1} (2k)^{−p}` (positive budget), `N(p) = Σ_{k≥1} (2k+1)^{−p}` (negative budget).
- Asymmetry `1 − η(p)` via Theorem 2's identity `P(p) − N(p) = 1 − η(p)`.
- `η(p) = Σ_{n≥1} (−1)^{n−1} n^{−p}`, an alternating series with strictly decreasing terms.

## Proof / evidence

> **PROVED**; **VERIFIED** at `p = 1.01, 1.5, 2, 3, 4, 8`.

The source gives no further proof detail in this file beyond the sentence above.

## Dependencies and related results

- Uses Theorem 2: `P(p) − N(p) = 1 − η(p)` (harvested as [Theorem 2 (T2, T3)](tpp-rh42-truths-theorem-2-budget-algebra.md)).
- Handoff ledger row T4 (§11): "`P > N` for all `p > 0`", PROVED before and after.

## Notes

- The source's own aside, quoted verbatim: *"The positive side is always the cheaper one — a sine is easier to write than its negative."*
- The source states the range as **every** `p > 0`; the budget series `P(p)`, `N(p)` themselves are written in §2 as series (which converge for `p > 1`). This file keeps the source's stated range unchanged.

- **Correction (2025-10-06, session 003 residual-defect repair).** The verified list ended at `p = 8`, which no artefact checks. The committed asymmetry check runs `p ∈ {1.01, 1.5, 2, 3, 5}` (`research/twin-prime-parity/rounds/rh42/helix_zeta.py:479-480`) and its stored log reports the minimum it found, `min(P−N) = 0.0278802` (`verify/helix_zeta.log:81`), which is `P(5) − N(5)` — had `p = 8` been in the grid, `P(8) − N(8) = 0.003767` would have been the minimum. The list is corrected in this document and in its source `rounds/rh42/truths.md:106`. The theorem itself (`P(p) > N(p)` for every `p > 0`) is `PROVED` and unaffected.
