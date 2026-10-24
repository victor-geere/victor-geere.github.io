# T9 — the signed support has only even/odd indices (all gaps even, `≥ 2`)

**Kind:** Claim
**Status:** VERIFIED (numerical, parity of every take for four `θ`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh42/HANDOFF.md) — §6 "The rh42 ledger", row T9; §5.6.3

## Statement

> The signed word's support is parity-locked. Every take of a positive target sits at an
> even index, every take of a negative target at an odd index; hence **all gaps are even and
> at least 2**.

The ledger row states it as: "the signed support has only even/odd indices (all gaps even, ≥ 2)".

## Hypotheses and notation

- Signed alphabet `α_n = (−1)^n/(n+2)^p`: even `n` is positive, odd `n` is negative (the term is taken only when its sign matches the residual).
- "support" = the set of indices at which a term is taken.
- "gaps" = differences between consecutive taken indices.

## Proof / evidence

> | T9 | the signed support has only even/odd indices (all gaps even, ≥ 2) | **VERIFIED** | parity of every take for four `θ` |

The source's §5.6.3 adds: "rh41's complexity law applies verbatim (the Lean `complexity_main` is generic in the support — re-checked on the Tau supports `{0,2,4,10}`, `{2,6,38}`, `{0,8}`), but the *C1 regime and the plateau onset* of a signed word are governed by this parity constraint, which the unsigned word does not have."

## Dependencies and related results

- Uses the sign alternation of the alphabet (§2) and the signed rule.
- The Lean layer (§4 here and the lean README, `Rh42/Tau.lean`) proves the parity lock (`tauStep_eq_self_of_odd`, `take_parity`, `tauStep_eq_self_of_even`, `take_parity_neg`) and the even gaps (`support_gap_even_and_two_le`, `support_gap_even`).
- Restates `rh42/truths.md` Theorem 14 (parity lock).

## Notes

- The row's status is `VERIFIED` only (four values of `θ`); the corresponding Lean declarations listed in the lean README are machine-checked, but this HANDOFF row does not invoke them.
- Tau supports `{0,2,4,10}`, `{2,6,38}`, `{0,8}` are quoted exactly.
