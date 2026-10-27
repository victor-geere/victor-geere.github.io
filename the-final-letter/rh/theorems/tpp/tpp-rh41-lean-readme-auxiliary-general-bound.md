# The auxiliary general bound p(L) ≤ a_m + 2

**Kind:** Lemma
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/README.md`](../../research/twin-prime-parity/rounds/rh41/lean/README.md) — §1 "The complexity function", Corollary 4 row

## Statement

> With the auxiliary general bound `complexity_le_max_add_two` (`p(L) ≤ a_m + 2` for *every* `L`, which is what makes the maximum exactly `a_m + 2`).

## Hypotheses and notation

- Same objects as [Theorem 1 (main)](tpp-rh41-truths-theorem-1-complexity-main.md): support `0 ≤ a_0 < … < a_m`, truncation length `N`, `p(L)` the number of distinct length-`L` factors.
- The bound holds for **every** `L` (no large-`L` restriction), and is one-sided: it is what upgrades the attained plateau value `a_m + 2` of [Corollary 2](tpp-rh41-truths-corollary-2-plateau.md) to the maximum in [Corollary 4](tpp-rh41-truths-corollary-4-max-complexity.md).

## Proof / evidence

The README names the declaration `DigitWord.complexity_le_max_add_two` in `Rh41/DigitWord.lean` under the Corollary 4 row; the README's header states there is no `sorry`, no `admit` and no project-specific `axiom` in the development.

## Dependencies and related results

- [Corollary 4](tpp-rh41-truths-corollary-4-max-complexity.md) — the maximum statement this bound completes.
- [Corollary 2 (plateau)](tpp-rh41-truths-corollary-2-plateau.md) — the attained value.

## Notes

- The source states this bound only in parentheses attached to the Corollary 4 row of the Lean README; it is harvested because it is a named Lean declaration whose stated content (`p(L) ≤ a_m + 2` for every `L`) is not printed in `TRUTHS.md` and it is the ingredient that makes the maximum exact.
