# M8 — two counterexamples printed in HANDOFF.md §5 do not reproduce

**Kind:** Claim
**Status:** REFUTED (numerical; the two recorded witnesses are wrong, though the laws they were meant to refute are genuinely false)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/README.md`](../../research/twin-prime-parity/rounds/rh40/README.md) — §4 "Corrections established at programme open", item **M8** (lines 165–181)

## Statement

> **M8 — two counterexamples printed in HANDOFF.md §5 do not reproduce.** §5 is the "do not re-derive" list, so its counterexamples matter. The mediator recomputed all of them:
>
> | §5 claim | reproduces? |
> |---|---|
> | pairs law fails: 1/π, L=11 → 13 vs 12 | ✅ (first failure is exactly L = 11) |
> | pairs law fails: 1/π, L=13 → 15 vs 16 | ✅ |
> | pairs law fails: log 2, L=6 → 9 vs 8 | ❌ **both sides give 8**; the true first failure for log 2 is L = 4 (pairs 6 vs exact 5) |
> | distance law fails: 1/π, L=12 → 13 vs 14 | ❌ **both sides give 14**; the true first failure is L = 11 (distances 13 vs exact 12) |
> | `Σ(L−d_i)_+` fails: 1/π, L=20 → 30 vs 24 | ✅ |
> | model D fails: {139,151}, N=172, L=13 → 25 vs 15 | ✅ |
> | B's triple fails: {19,50,83}, L=1 → 4 vs 2 | ✅ (truth 2) |
>
> The disproofs stand — every law on the list is genuinely false — but two of the recorded witnesses are wrong, and a regression test that used them would have passed for the wrong reason. The tests now pin the **true** first failures.

## Hypotheses and notation

- The "§5 claim" column quotes the counterexample records of `HANDOFF.md` §5, the "do not re-derive" list of refuted laws: the pairs law, the distinct-distance law, the `Σ(L−d_i)_+` law, "model D", and Agent B's triple `(index, offset, count)`.
- "→ x vs y" means the law predicts `x` where the exact value is `y`; ✅/❌ marks whether the recorded witness reproduces.
- `p(L)` is the factor complexity of the truncation `w_N`; for `log 2` the truncation is `N = 13000`, support `{0,4,36,6069}`, and for `1/π` it is `N = 1400`, support `{2,13,607}`.

## Proof / evidence

The source states this without proof: the finding is the mediator's exact recomputation of every §5 counterexample. The README records that `tests/test_complexity.py` "now pin[s] the **true** first failures". Separately harvested files record the laws themselves as refuted: [pairs law](../handoff/handoff-pair-count-law-refuted.md), [distinct-distance law](../handoff/handoff-distinct-distance-law-refuted.md), [distance-sum law](../handoff/handoff-distance-sum-law-refuted.md), [model D](../handoff/handoff-saturation-candidate-d-refuted.md).

## Dependencies and related results

- [Refuted: p(L) = L + 1 + #{pairs of 1s at distance ≤ L}](../handoff/handoff-pair-count-law-refuted.md) — the first two rows and the corrected `log 2` row.
- [Refuted: p(L) = L + 1 + #{distinct distances ≤ L}](../handoff/handoff-distinct-distance-law-refuted.md) — the corrected `1/π` distance row.
- [Refuted: p(L) = L + 1 + Σ_i (L − d_i)+](../handoff/handoff-distance-sum-law-refuted.md) — a row that reproduces.
- [Refuted: candidate model D, p(L) = min(L + span, N − L + 1)](../handoff/handoff-saturation-candidate-d-refuted.md) — a row that reproduces.

## Notes

- This is a reproducibility correction, not a new mathematics: the source says plainly that "the disproofs stand — every law on the list is genuinely false", and only the recorded witnesses were wrong.
- `HANDOFF.md` §5 is the same list the round-1 brief forbids the agents to re-propose ("Already disproved — do not re-propose").
