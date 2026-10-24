# the barrier in one sentence (README): every greedy-sine object is an "additive character in `log n`"

**Kind:** Claim
**Status:** OPEN (heuristic; the README's own record correction declares the phrasing too wide and keeps the impossibility OPEN)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh47/README.md`](../../research/twin-prime-parity/rounds/rh47/README.md) — §2 "The bridge the goal needs — and the barrier", line 59

## Statement

> **The barrier in one sentence.**  Every greedy-sine object in rh41–rh45 is an
> **additive character in `log n`** — the word depends on `sin(2πθ)`, the budgets on
> `Σn^{−p}`, the balance on `Σn^{−it}` — whereas the parity obstruction is a statement
> about a **multiplicative** function, and rh46 verified concretely that the two do not
> mix.

## Hypotheses and notation

- `sin(2πθ)`: the height through which the greedy word factors (rh42 §8).
- `Σn^{−p}`: the zeta budgets `P(p) = 2^{−p}ζ(p)`, `N(p) = (1−2^{−p})ζ(p)−1` (rh42 §2).
- `Σn^{−it}`: the balance partial sums `S_N(t)` (rh43).
- The "parity obstruction" is the two-point Chowla statement `Σ_{n≤x} λ(n)λ(n+2) = o(x)`, marked **OPEN**.

## Proof / evidence

The README states the barrier as the round's summary of the three bridge rows, and rh46's concrete verification is the Euler-product failure ([B3](tpp-rh47-readme-bridge-b3-no-euler-product.md)). The README's closing record correction qualifies the statement:

> **Record correction.** … this round's own barrier phrasing ("additive character in `log n`"), which the audit showed is too wide — read it as *sign-blind alphabet, no arithmetic input*, with the impossibility kept **OPEN**.

So the object-level description is a heuristic; only the verified legs are proved.

## Dependencies and related results

- [README B1](tpp-rh47-readme-bridge-b1-no-signal.md), [README B2](tpp-rh47-readme-bridge-b2-index-parity-independent.md), [README B3](tpp-rh47-readme-bridge-b3-no-euler-product.md) — the three rows the sentence summarises.
- The corrected version in the ledger: [the corrected barrier, sign-blind alphabet with no arithmetic input](tpp-rh47-truths-corrected-barrier-open.md).
- Restated in HANDOFF: [the barrier in one sentence](tpp-rh47-handoff-barrier-additive-character-open.md).
- Earlier ledger row: [the corrected barrier](tpp-dict-00-corrected-barrier-open.md).

## Notes

- **This phrasing is explicitly corrected by the source itself.** The audit showed "additive character in `log n`" is too wide: `n^{−it}` is a *multiplicative* character on `(ℝ₊,×)`, and the budgets are *constants* in `p`, not characters. The corrected reading is *sign-blind alphabet, no arithmetic input*, and the impossibility is kept **OPEN**.
- The source's own statement that "the two do not mix" is a heuristic and "is not a theorem" (truths.md §3, correction 2).
