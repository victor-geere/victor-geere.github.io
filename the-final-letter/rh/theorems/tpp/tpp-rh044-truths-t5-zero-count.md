# T5 — the zero count

**Kind:** Claim
**Status:** VERIFIED (numerical, with caveat)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh044/truths.md`](../../research/twin-prime-parity/rounds/rh044/truths.md) — §5 "The zero count (T5)", line 149

## Statement

> **VERIFIED with caveat.**  `N(30) = 3`, `N(35) = 5` (counted via `Z`-sign changes).
> The Riemann–von Mangoldt main term is `(T/2π)log(T/2πe) + 7/8 = 3.5647` at `T = 30`,
> so `N(30) − main = −0.5647 = S(30)/π`, inside the expected oscillation; the main term
> alone rounds to 4 and does **not** determine the count.

## Hypotheses and notation

- `N(T)` denotes the zero count, obtained in this round via sign changes of the Riemann–Siegel `Z`-function.
- `S(T)` is the argument term of the Riemann–von Mangoldt formula.
- The main term is `(T/2π)log(T/2πe) + 7/8`, evaluated at `T = 30` to `3.5647`.

## Proof / evidence

Numerical: the counts are obtained via `Z`-sign changes; the difference `N(30) − main = −0.5647` is identified with `S(30)/π` and is reported as inside the expected oscillation.

## Dependencies and related results

- [T4 — zero localisation](tpp-rh044-truths-t4-zero-localisation.md) — the same `Z`-based bracketing that lists five zeros below `35`.
- [README fact 5 — the zero count](tpp-rh044-readme-fact-5-zero-count.md) — restates this result.

## Notes


- The caveat is the source's own: "the main term alone rounds to 4 and does **not** determine the count".
- `N(35) = 5` agrees with the five zeros listed in [T4](tpp-rh044-truths-t4-zero-localisation.md).
- **Correction to a correction (session-003 audit, 2025-10-06).** The `evidence absent` qualifier that briefly stood here was **false** and has been reversed: a committed artefact does compute the numbers above — `research/twin-prime-parity/rounds/rh044/verify/independent_check.log`. The qualifier was assigned by a mechanical rule that looked only at this document and at the source it was harvested from, and only for artefact names, so it missed evaluators kept elsewhere in the tree. The original label is restored, unqualified. See `AUDIT-verification-labels-002.md` §6.
