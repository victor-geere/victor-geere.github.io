# Theorem 3.2 (attainability)

**Kind:** Theorem
**Status:** PROVED (Lean for `N = 3`; `N = 4` by certified numerical enclosure; PROOF-SKETCH + VERIFIED numerically to `N = 200` for all `N`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/04-zeta-relations.md`](../../research/twin-prime-parity/dictionary/04-zeta-relations.md) — §3 "The balance split at `Re(S) = 0` (rh43)", "Theorem 3.2 (attainability)", line 80

## Statement

> **Theorem 3.2 (attainability).**  For every `N ≥ 2` there is `t` with `Re S_N(t) = 0`:
> `N = 2` balances exactly at `t = π/log 2` (a **tangential** zero — the first draft's
> "N = 2 has no root" is REFUTED), and `N = 3` via `Re S_3(5/2) < 0 < 3 = Re S_3(0)`
> (IVT; the certified value is `−0.084335758298…`).  Certified 47-digit root brackets
> exist for `N = 3…50`; roots for all `N ≥ 3` follow from equidistribution
> (PROOF-SKETCH + VERIFIED to `N = 200`).

## Hypotheses and notation

- `S_N(t) = Σ_{n≤N} n^{−it}` as in [Theorem 3.1](tpp-dict-04-balance-split-identity.md); `t` is real.
- "Tangential" zero at `N = 2` refers to `t = π/log 2`, where the balance condition of Theorem 3.1 holds exactly.
- IVT = the intermediate value theorem; the certified value `−0.084335758298…` is printed with the `N = 3` bracket `Re S_3(5/2) < 0 < 3 = Re S_3(0)`. The source does not say which quantity this value is, and it is reproduced as printed.
- "Certified 47-digit root brackets" exist for `N = 3…50`; the all-`N` argument is a **PROOF-SKETCH** plus verification to `N = 200`.

## Proof / evidence

The source's status line, verbatim:

> *Status:* THEOREM (`N=3,4`, Lean) + NUMERICAL (brackets) + PROOF-SKETCH (all `N`).

So the fully proved part is `N = 3` (Lean); `N = 4` rests on the certified numerical enclosure; `N = 3…50` is supported by certified 47-digit brackets; the extension to all `N ≥ 3` is a proof sketch resting on equidistribution, verified numerically to `N = 200`.

## Dependencies and related results

- [Theorem 3.1 (the identity)](tpp-dict-04-balance-split-identity.md) — supplies the balance condition.
- [Theorem 3.3 (the complex split is a different question)](tpp-dict-04-complex-split-different-question.md) — treats the analogous complex-zero question.

## Notes

- Ledger entry for the **rh43** round (section headed "(rh43)").
- The source flags the all-`N` claim explicitly as PROOF-SKETCH + VERIFIED (not fully proved) and records that the first draft's "N = 2 has no root" is **REFUTED**. Both hedges are reproduced and must not be dropped.

- **Correction (2025-10-06, session 003 residual-defect repair).** This document said the fully proved part is `N = 3, 4` **(Lean)**. It is `N = 3`: the rh43 Lean development formalises that witness only. `research/twin-prime-parity/rounds/rh43/truths.md:155` states it in the archive's own words — "(The Lean development currently formalises the `N = 3` witness; the `N = 4` enclosure is the numerical route's.)" — and no `*.lean` file declares an `N = 4` result. `N = 4` stands on the certified numerical enclosure, which is a different and weaker kind of support; the Status and the evidence section now say so.
