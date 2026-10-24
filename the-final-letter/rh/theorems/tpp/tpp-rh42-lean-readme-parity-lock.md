# Theorem 14, parity lock — a positive target only ever takes even indices; a negative target odd ones

**Kind:** Theorem
**Status:** PROVED (Lean, machine-checked; no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/lean/README.md`](../../research/twin-prime-parity/rounds/rh42/lean/README.md) — `### Rh42/Tau.lean — truths.md §7`

## Statement

> | `truths.md` | Lean | notes |
> |---|---|---|
> | Theorem 14, parity lock | `tauStep_eq_self_of_odd`, `take_parity`, `tauStep_eq_self_of_even`, `take_parity_neg` | a positive target only ever takes even indices; a negative target odd ones |

## Hypotheses and notation

- Signed alphabet `α_n = (−1)^n/(n+2)^p`: even `n` positive, odd `n` negative.
- `tauStep_eq_self_of_odd` / `tauStep_eq_self_of_even`: the residual is unchanged at an index whose sign does not match.
- `take_parity` / `take_parity_neg`: the parity of the indices actually taken, for a positive and a negative target respectively.
- "Theorem 14" is the `truths.md` numbering of the round.

## Proof / evidence

The evidence is the machine-checked declarations in `Rh42/Tau.lean` (`truths.md` §7), built by `./check.sh --all` with no `sorry`/`admit`/`axiom`/`native_decide` (README preamble).

## Dependencies and related results

- Uses the alphabet and rule declarations `tauTerm`, `tauStep`, `tauTake`, `tauTake_iff`.
- The residual/support layer is `tauResidual`, `tauResidual_succ`, `tauTaken`, `support`, `mem_support`, `tauResidual_nonneg`, `tauResidual_nonpos` in the same file.
- Same content as the round's HANDOFF ledger row T9 (parity-locked support), harvested separately, and as `rh42/truths.md` Theorem 14.
- The even-gap consequence is the companion entry (`support_gap_even_and_two_le`, `support_gap_even`).

## Notes

- Quoted from the README's notes column verbatim; no Lean signatures are printed in the source.
- The HANDOFF states the same as `VERIFIED` numerically for four `θ`; here it is Lean-certified.
