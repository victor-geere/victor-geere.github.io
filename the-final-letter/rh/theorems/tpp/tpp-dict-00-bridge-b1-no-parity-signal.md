# bridge B1: the greedy support carries no `λ`-parity signal

**Kind:** Theorem
**Status:** VERIFIED (numerical, with controls)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — "Index. F — the parity obstruction and the programme's barriers (rh46, rh47)", row F6, line 108

## Statement

The ledger row, verbatim:

> | F6 | **bridge B1**: the greedy support carries no `λ`-parity signal | NUMERICAL (with controls) | rh47 §2 |

## Hypotheses and notation

- "The greedy support" is `A(x)`, the set of taken indices of the greedy harmonic sine; `λ` is the Liouville function.
- "`λ`-parity signal" means a detectable correlation between the support and the parity of `Ω` (equivalently, the sign of `λ`).
- The evidence is **numerical, with controls** — the ledger's phrase.

## Proof / evidence

The ledger records `NUMERICAL (with controls)` with source `rh47 §2`; no proof is given. The capstone chapter records the disposal of bridge B1, with the witness statistics, as [B1 — the greedy support carries λ-parity signal (refuted)](tpp-dict-05-b1-greedy-support-lambda-parity-refuted.md): the nominal `z = −47.9` is killed by the positional control `z = +0.43` and the rank-matched control `z = +1.55`.

## Dependencies and related results

- [F7 — bridge B2: the ζ budgets split index parity, not Ω-parity](tpp-dict-00-bridge-b2-index-parity.md).
- [B7 — the support is Sylvester-sparse](tpp-dict-00-sylvester-sparse-support.md): the density `≈ 3.9·10⁻⁵` is what makes the support unusable as a positive-density witness.

## Notes


- Ledger entry restating round **rh47** (§2).
- This row is stated **positively** ("carries no signal") and evidenced **numerically with controls**; it is harvested as VERIFIED (numerical), not as a theorem.
- The workspace's other chapters state the mirror-image *claim* ("the greedy support carries `λ`-parity signal") and dispose of it as REFUTED; the two formulations are the same finding, recorded from opposite directions by the two sources.
- **Correction to a correction (session-003 audit, 2025-10-06).** The `evidence absent` qualifier that briefly stood here was **false** and has been reversed: a committed artefact does compute the numbers above — `research/twin-prime-parity/rounds/rh47/verify/greedy_parity_probe.log`. The qualifier was assigned by a mechanical rule that looked only at this document and at the source it was harvested from, and only for artefact names, so it missed evaluators kept elsewhere in the tree. The original label is restored, unqualified. See `AUDIT-verification-labels-002.md` §6.
