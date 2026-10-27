# Theorem 8 (rational termination)

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/TRUTHS.md`](../../research/twin-prime-parity/rounds/rh41/TRUTHS.md) — §3 "The support: greedy orbits"

## Statement

> **Theorem 8 (rational termination).** Every rational `x` terminates; `x = 1` (θ = π) has support exactly `{0, 1, 4}` since `1/2 + 1/3 + 1/6 = 1`.

## Hypotheses and notation

- `x ∈ (0,1)` is the target of the greedy rule; "terminates" means the residual reaches `0` at some finite step.
- The support of `x = 1` is the set of taken indices; `x = 1` corresponds to `θ = π` on the pages' helix parametrisation.
- `1/2 + 1/3 + 1/6 = 1` is the source's own arithmetic justification.

## Proof / evidence

The source states the theorem as PROVED (a written argument) and gives no proof text in this file (evidence: `rigorous_check.py` in the round folder, 31/31 pass).

Machine-checked in `Rh41/GreedyResidual.lean`, namespace `Rh41.Harmonic`: `Harmonic.terminates_rat`, `Harmonic.terminates_of_pos_lt_one`, `Harmonic.terminates_from`, plus the tail formulation `Harmonic.residual_shift`, `Harmonic.residual_eventually_zero`, and `Harmonic.taken_one_iff` for the support `{0,1,4}`. The file uses no `native_decide`; the proof is driven by the numerator-decrease lemma `num_sub_inv_lt`.

## Dependencies and related results

- [Theorem 7 (maps)](tpp-rh41-truths-theorem-7-induced-maps.md) — the orbit identities on the same dynamics.
- [All 277 reduced p/q with q ≤ 30 terminate](tpp-rh41-truths-claim-rational-census-q-le-30.md) — the numerical census of this theorem's finite instances.
- The signed-round sequel: [R5 — "every rational target terminates" at general p](tpp-rh42-truths-r5-rational-termination-general-p.md) — records that termination of rational targets is a `p = 1` theorem.

## Notes

- The round's Lean README notes that `Harmonic.terminates_from` keeps the invariant `r < 1/(i+1)`: the numerator-decrease measure fails for arbitrary `(i, r)`, while `Harmonic.terminates_rat` needs no extra hypothesis.
- "Terminates" here is finite termination (the residual hits `0`). The round's Lean README warns that `TRUTHS.md` also uses "termination" for "the residual tends to `0`" elsewhere in the same document.
