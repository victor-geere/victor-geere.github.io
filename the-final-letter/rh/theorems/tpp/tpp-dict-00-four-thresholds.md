# the four thresholds `pN < pP < p* < q`

**Kind:** Theorem
**Status:** VERIFIED (numerical, rigorous enclosures)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — "Index. C — the ζ budgets and the reachable set", row C9, line 71

## Statement

The ledger row, verbatim:

> | C9 | the four thresholds `pN < pP < p* < q` | NUMERICAL (rigorous enclosures) | rh42 §6 |

## Hypotheses and notation

- `p*` is the positive-half completeness threshold, `ζ(p*) = 2`, quoted in the ledger as `p* = 1.7286472…` ([C6](tpp-dict-00-positive-half-complete-threshold.md)).
- `q` is the negative-half completeness threshold, `N(q) = 2·3^{−q}`, quoted in the ledger as `q = 2.0767752…` ([C7](tpp-dict-00-negative-half-complete-threshold.md)).
- `pN` and `pP` are the two further thresholds of round **rh42 §6** (the ledger gives their names and order but no numerical values in this row).
- The content is the strict chain `pN < pP < p* < q`.

## Proof / evidence

The ledger records `NUMERICAL (rigorous enclosures)` with source `rh42 §6` and gives no proof. The round's own record is [the four thresholds, enclosed](tpp-rh42-truths-four-thresholds-enclosed.md).

## Dependencies and related results

- [C6](tpp-dict-00-positive-half-complete-threshold.md) and [C7](tpp-dict-00-negative-half-complete-threshold.md) supply `p*` and `q`.
- [The pole split](tpp-dict-00-pole-split-budgets.md) (C4) is the asymptotic companion in the same index group.

## Notes


- This row's status is **numerical only** by the ledger's own label; the enclosures are described as *rigorous*, but the numerical leg is not a proof of a theorem and is not reported as one here.
- Only the two values `p* = 1.7286472…` and `q = 2.0767752…` appear numerically in this dictionary; the row states no numerical value for `pN` or `pP`, and none is invented.
- **Correction to a correction (session-003 audit, 2025-10-06).** The `evidence absent` qualifier that briefly stood here was **false** and has been reversed: a committed artefact does compute the numbers above — `research/twin-prime-parity/rounds/rh42/verify/helix_zeta_rerun.log`. The qualifier was assigned by a mechanical rule that looked only at this document and at the source it was harvested from, and only for artefact names, so it missed evaluators kept elsewhere in the tree. The original label is restored, unqualified. See `AUDIT-verification-labels-002.md` §6.
