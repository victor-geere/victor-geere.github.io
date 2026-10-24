# B1 — the greedy support correlates with `λ`'s parity class: no mechanism known (HANDOFF)

**Kind:** Claim
**Status:** OPEN (no mechanism known; the signed support's parity lock is a rigidity, not a bridge)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh47/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh47/HANDOFF.md) — §2 "The bridge that the goal needs — and the barrier", table row **B1**, line 75

## Statement

> | # | candidate bridge | status |
> |---|---|---|
> | **B1** | the greedy *support* correlates with `λ`'s parity class | no mechanism known; the unsigned greedy word is a deterministic function of the target `x` alone, with **no arithmetic input**, while `λ` is multiplicative.  The signed support is parity-locked (rh42), which forces all its gaps even — a *rigidity* that constrains the word but says nothing about `Ω` |

## Hypotheses and notation

- `λ(n) = (−1)^{Ω(n)}` is the Liouville function; `Ω` counts prime factors with multiplicity.
- The *unsigned* greedy word depends on the target `x` alone, with no arithmetic input.
- The *signed* support is **parity-locked** (rh42, `Rh42/Tau.lean`): all its gaps are even (`≥ 2`).

## Proof / evidence

The HANDOFF records the absence of a mechanism for B1, not a refutation; the parity lock is attributed to rh42 (`Rh42/Tau.lean`). This round's reconciled findings on the bridge are the numerical nulls of `truths.md` §2 (see [B1 in the ledger](tpp-rh47-truths-bridge-b1-no-lambda-parity-signal.md)).

## Dependencies and related results

- [HANDOFF B2](tpp-rh47-handoff-bridge-b2-index-parity-refuted.md) and [HANDOFF B3](tpp-rh47-handoff-bridge-b3-balance-route-refuted.md) — the other rows of the same table.
- [HANDOFF barrier](tpp-rh47-handoff-barrier-additive-character-open.md) — the one-sentence summary the rows support.
- [B1 in the ledger (REFUTED, no signal)](tpp-rh47-truths-bridge-b1-no-lambda-parity-signal.md) and [B1 in the README](tpp-rh47-readme-bridge-b1-no-signal.md) — the same bridge at different status wording.
- [Parity lock: the signed support has all gaps even `≥ 2`](tpp-dict-00-parity-lock-signed-support-gaps.md) — the harvested rh42 result invoked here.

## Notes

- **Status differs by source.** The HANDOFF says "no mechanism known" (kept here as OPEN); the ledger `truths.md` §2 says **REFUTED (no signal)**, and the README says "no signal above a size-matched control". The three must not be conflated.
- The HANDOFF's own summary sentence calls B1 "no signal (B1)" in H3, which is the stronger ledger reading.
