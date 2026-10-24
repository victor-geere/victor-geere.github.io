# The exponential alphabet gives bounded gaps and termination (the dichotomy is false)

**Kind:** Theorem
**Status:** VERIFIED (exact rational arithmetic)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/K_remaining.md`](../../research/twin-prime-parity/rounds/rh40/K_remaining.md) — §5.4 "The dichotomy is nevertheless FALSE"

## Statement

> Not via the power family, but via the **exponential alphabet**, verified in exact
> rationals by the mediator:
>
> ```
> α_n = 2^{−(n+1)},   x = 1   ⟹   taken = {0,1,2,3,…},   max gap = 1,
> ```
>
> and the process halts when the residual reaches 0 (it is `2^{−(n+1)}` after `n`
> steps, so it never overshoots; the target is met exactly in the limit).

And the conclusion is stated by the source in bold:

> **"You get bounded gaps OR termination, never both" is FALSE.** One alphabet can
> have both. (The handoff's `α_n = c·2^{−n}` counterexample was therefore right all
> along.)

## Hypotheses and notation

- `α_n = 2^{−(n+1)}` is the exponential alphabet; `x = 1` is the target.
- `taken` is the set of indices selected by the greedy rule; the process "halts when the residual reaches 0".
- `max gap = 1` means every gap between consecutive taken indices is exactly 1, i.e. the taken set is an initial segment without holes.
- The dichotomy being refuted is "you get bounded gaps OR termination, never both" (the delegated report's structural claim, refuted in §5.2 for the power family and here for the exponential alphabet).

## Proof / evidence

The source's evidence: "verified in exact rationals by the mediator", with the observation that after `n` steps the residual is `2^{−(n+1)}`, so the process never overshoots and the target is met exactly in the limit. The source records that the handoff's counterexample `α_n = c·2^{−n}` was right all along.

Evidence files named by the source for K7: [`verify/k7_alphabet.py`](../../research/twin-prime-parity/rounds/rh40/verify/k7_alphabet.py) (delegated) and the mediator's independent recomputation.

## Dependencies and related results

- [Termination criterion for a greedy alphabet (and the ζ(p) threshold)](tpp-rh40-k-remaining-termination-criterion.md) — the criterion invoked for halting ("the process halts when the residual reaches 0").
- [The corrected structure theorem (power family)](tpp-rh40-k-remaining-structure-theorem.md) — the other half of K7 §5, where the power family does have unbounded gaps.
- [The inverse problem has no halting alphabet with linear complexity](tpp-rh40-k-remaining-inverse-problem-negative.md) — §5.5, the "inverse problem proper".
- [Theorem 11 (dichotomy false)](tpp-rh41-truths-theorem-11-dichotomy-false.md) — the later round's statement of the same counterexample.

## Notes

- **Restatement round.** The same counterexample is "Theorem 11 (dichotomy false)" in the later round `research/twin-prime-parity/rounds/rh41/TRUTHS.md`, harvested as [Theorem 11 (dichotomy false)](tpp-rh41-truths-theorem-11-dichotomy-false.md); there the statement is that `α_n = 2^{−(n+1)}`, `x = 1` selects **every** index.
- The source's §5.4 records that the delegated report's central structural claim is refuted (§5.2), "so the corrected statement is given here" (the structure theorem).
- The source's status for this item is the exact-rational verification quoted above; no paper proof of the dichotomy's failure beyond this explicit alphabet is claimed.
- "What remains open" in §5.5 is recorded by the source as non-monotone alphabets, "where the taken set need not be an initial segment (`α = [29/40, 1/2, 1/4, 3/20]`, `x = 7/8` gives taken `{0,3}`), so richer complexity profiles may be realisable there." The example `α = [29/40, 1/2, 1/4, 3/20]`, `x = 7/8`, `taken = {0,3}` is quoted exactly as printed.
