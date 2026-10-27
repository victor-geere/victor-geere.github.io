# the barrier in one sentence (HANDOFF): every greedy-sine object is an "additive character in `log n`"

**Kind:** Claim
**Status:** OPEN (heuristic; the source's own record correction declares the phrasing too wide and keeps the impossibility OPEN)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh47/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh47/HANDOFF.md) — §2 "The bridge that the goal needs — and the barrier", line 79

## Statement

> **The barrier, in one sentence.**  Every greedy-sine object in rh41–rh45 is an
> *additive character in `log n`* (the word depends on `sin(2πθ)`, the budgets on
> `Σn^{−p}`, the balance on `Σn^{−it}`), whereas the parity obstruction is a statement
> about a *multiplicative* function — and rh46 verified concretely that the two do not
> mix: the naive Euler product of the correlation Dirichlet series differs from the
> true value by `2.0144` at `s=2`, i.e. the correlation has no Euler product.

## Hypotheses and notation

- `sin(2πθ)`: the height the greedy word factors through (rh42 §8).
- `Σn^{−p}`: the zeta budgets `P(p) = 2^{−p}ζ(p)`, `N(p) = (1−2^{−p})ζ(p)−1`.
- `Σn^{−it}`: the balance partial sums `S_N(t)` (rh43).
- The concrete verification is the Euler-product failure of the correlation Dirichlet series, discrepancy `2.0144` at `s=2`.

## Proof / evidence

The HANDOFF states the barrier and cites rh46's concrete verification (the Euler-product failure, discrepancy `2.0144` at `s=2`). Its own audit correction then qualifies the statement:

> **Two corrections the audit forced on this document's §2 barrier** (recorded in [`truths.md`](../../research/twin-prime-parity/rounds/rh47/truths.md) §3): the phrase "additive character in `log n`" is too wide (`n^{−it}` is multiplicative on `(ℝ₊,×)`; the budgets are constants), and the barrier must read **sign-blind, no arithmetic input** … And "the two do not mix" is a heuristic that must stay **OPEN**, unlike the two verified legs.

## Dependencies and related results

- [HANDOFF B1](tpp-rh47-handoff-bridge-b1-no-mechanism-known.md), [HANDOFF B2](tpp-rh47-handoff-bridge-b2-index-parity-refuted.md), [HANDOFF B3](tpp-rh47-handoff-bridge-b3-balance-route-refuted.md) — the three rows the sentence summarises.
- The corrected version: [the corrected barrier, sign-blind alphabet with no arithmetic input](tpp-rh47-truths-corrected-barrier-open.md).
- Restated in the README: [the barrier in one sentence](tpp-rh47-readme-barrier-additive-character-open.md).
- [H4 — the goal cannot be reached as it stands](tpp-rh47-handoff-h4-goal-unreachable-open.md) — the round's honest conclusion.
- Earlier ledger row: [the corrected barrier](tpp-dict-00-corrected-barrier-open.md).

## Notes

- **Corrected in the source.** The phrase "additive character in `log n`" is too wide: `n^{−it}` is *multiplicative* on `(ℝ₊,×)`, and the budgets are *constants* in `p`. The corrected reading is *sign-blind, no arithmetic input*, and "the two do not mix" must stay **OPEN**.
- The source's own rounding `2.0144` corresponds to the ledger's `|difference| = 2.01438655` against the tail `1.84·10⁻⁵`.
