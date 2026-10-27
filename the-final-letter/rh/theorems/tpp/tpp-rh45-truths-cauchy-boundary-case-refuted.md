# C1e (Cauchy `a = 1/2` to 20 digits) is refuted as stated

**Kind:** Claim
**Status:** REFUTED (as stated; the kernel is on the boundary)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh45/truths.md`](../../research/twin-prime-parity/rounds/rh45/truths.md) — §3 "The auditor's four failures — over-strong criteria, not false claims", row C1e; §1 for the boundary analysis

## Statement

> | check | verdict | reality |
> |---|---|---|
> | C1e (Cauchy `a=1/2` to 20 digits) | REFUTED as stated | the kernel is on the boundary: prime sum diverges, zero sum converges like `log G/G`. The corrected companion (`a=1`) is verified at ~2 digits, limited by the zero-side tail estimate |

The source's §1 gives the boundary analysis:

> the Cauchy kernel at `a=1/2` is the boundary case (its prime sum `π Σ Λ(n)/n`
> diverges like `π log N`, its zero side converges like `log G/G`), which is why the
> naive Cauchy test in the draft could not work at all.

## Hypotheses and notation

- Cauchy kernel: `g = (π/2)e^{−|u|}` with parameter `a`; the companion at `a = 1` has `φ(t) = π/(1+t²)`.
- `G` is the zero-sum cutoff in the auditor's Cauchy test; the prime sum is `π Σ Λ(n)/n`, which diverges like `π log N`.
- "to 20 digits" is the criterion the check demanded.

## Proof / evidence

- The verdict is the auditor's: the check fails as stated because the `a = 1/2` kernel sits exactly on the boundary of admissibility (prime sum divergent, zero sum only `log G/G`).
- The corrected companion (`a = 1`) is verified at ~2 digits in the round's four-kernel table, limited by the zero-side tail estimate; see [The correct explicit formula](tpp-rh45-truths-correct-explicit-formula.md).

## Dependencies and related results

- [The correct explicit formula](tpp-rh45-truths-correct-explicit-formula.md) — the four-kernel verification, whose Cauchy row is the `a=1` companion.
- [The first draft's explicit formula is wrong twice](tpp-rh45-truths-draft-formula-refuted.md) — the draft's other two errors.
- The same boundary statement is made in [`README.md`](../../research/twin-prime-parity/rounds/rh45/README.md) (harvested with [What my first draft got wrong](tpp-rh45-readme-draft-errors-refuted.md)).

## Notes

- The source classifies this and the other three auditor "failures" as "over-strong criteria, not false claims": the `a = 1/2` kernel could not meet the 20-digit criterion, but the corrected explicit formula itself is not refuted by it.
- The source gives no proof of the divergence rates; they are stated as the auditor's numerical/analytic diagnosis.
