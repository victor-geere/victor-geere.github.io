# The greedy squaring law of the residual orbit

**Kind:** Theorem
**Status:** VERIFIED (numerical, 30 digits; exact identity)
**Area:** workspace
**Source:** [`HANDOFF.md`](../../research/various/HANDOFF.md) — §2 "The object, defined exactly", lines 36–40; re-checked in §8.2 item 7

## Statement

> **Irrational x:** the process never terminates, and the selected indices satisfy exactly
>
> **n_{k+1} = ⌈1/r_k⌉ − 2**,   so   **r_{k+1} = r_k − 1/n_{k+1} = (1−f)r_k² / (1 + (1−f)r_k)**,  f = {1/r_k}.
>
> Hence A(N) := #{n ≤ N : δ_n = 1} = log₂ log N + O(1) — verified by direct census to index 128 541 453 (x = π−3).

## Hypotheses and notation

- The residual orbit is r₀ = x = θ/π ∈ (0, 1) with x irrational; the greedy rule selects n_{k+1} by the unsigned Egyptian rule of §2: if r<sub>n</sub> ≥ 1/(n+2) then δ<sub>n</sub> = 1 and r<sub>n+1</sub> = r<sub>n</sub> − 1/(n+2), else δ<sub>n</sub> = 0 and r<sub>n+1</sub> = r<sub>n</sub>.
- n_{k+1} is the (k+1)-st selected index; r<sub>k+1</sub> is the residual after that selection; f = {1/r<sub>k</sub>} is the fractional part of 1/r<sub>k</sub>.
- A(N) := #{n ≤ N : δ<sub>n</sub> = 1} is the census of selected indices up to N.

## Proof / evidence

The source states the identity as exact and reports the census check. §8.2 item 7 makes it a required regression test: "`test_greedy_squaring_law` — r' = (1−f)r²/(1+(1−f)r) to 30 digits at every step, for six irrational targets."

The census is by exact enumeration: A(N) = log₂ log N + O(1) "verified by direct census to index 128 541 453 (x = π−3)", with the enumerator listed in §9 as `verify/round7_AN_census.py` and the squaring law as `verify/round7_squaring_verify.py`. **The attribution is corrected here from `x = (π−3)/π` to `x = π−3`** (audit repair 5b, 2025-10-06): `round7_AN_census.py:38` lists `pi-3` among its six targets, the census journal prints the row `π−3`, and the figure is reproduced for that target alone by [`verify/census_128541453_verify.py`](../../verify/census_128541453_verify.py) (log: `verify/census_128541453_verify.log`). For `(π−3)/π` the same census ends at index 443 367 after three selections.

The source states this without proof of the identity in the document; it is presented as an exact algebraic rearrangement of the greedy step, with the numerical verification recorded.

## Dependencies and related results

- [handoff-offset-tuple-characterisation](handoff-offset-tuple-characterisation.md) — the ground-truth enumeration of the word the orbit generates.
- §2 records the parallel rigorously known regime for rational x: the process terminates, and the indices for θ = π are exactly {0, 1, 4} (1/2 + 1/3 + 1/6 = 1), verified with exact rational arithmetic.
- §4's open Problem C concerns the complexity p(L) of this word, not the orbit law itself.

## Notes

- The status is VERIFIED (numerical, 30 digits; exact identity): the source asserts the identity as "exactly" and supports it by the 30-digit step-by-step check on six irrational targets and the census to index 128 541 453, not by a written proof. That step-by-step check now has a stored log: `verify/round7_squaring_verify.log` (written 2025-10-06 by this repair; the script is `verify/round7_squaring_verify.py`).
- **Correction (audit repair 5b, 2025-10-06).** The census target printed above was `x = (π−3)/π` in both this file and its source `HANDOFF.md:40`; it is `x = π−3`. Three pieces of the archive's own record say so — `verify/round7_AN_census.py:38`, the row printed in `research-journal.md`, and the recomputation in `verify/census_128541453_verify.log`. Applied to both this file and `HANDOFF.md:40`.
- **A caveat the correction exposes, recorded not repaired.** §"Hypotheses" above fixes the orbit to `x = θ/π ∈ (0, 1)`, and under that convention `π−3 = 0.14159…` is *outside* the domain while `(π−3)/π = 0.04507…` is inside it. The enumerator and the journal nonetheless run the target `π−3`; the 128 541 453 figure therefore belongs to a parameter the document's own domain convention does not admit. The census itself is unaffected (the rule `n_{k+1} = ⌈1/r_k⌉ − 2` is applied to a positive real either way); what is unsupported is the claim that this run verifies the stated model at an admissible parameter. That step-by-step check now has a stored log: `verify/round7_squaring_verify.log` (run 2025-10-06 by this session's audit repair; the script is `verify/round7_squaring_verify.py` and reported no mismatch).
- **Correction (audit repair 5b, 2025-10-06).** The census target printed above was `x = (π−3)/π` in both this file and its source `HANDOFF.md:40`; it is `x = π−3`. Three pieces of the archive's own record say so — `verify/round7_AN_census.py:38`, the row printed in `research-journal.md`, and the recomputation in `verify/census_128541453_verify.log`. The correction was applied to this file **and** to the source line in `HANDOFF.md:40`.
- **A caveat the correction exposes, recorded not repaired.** §"Hypotheses" above fixes the orbit to `x = θ/π ∈ (0, 1)`, and under that convention `π−3 = 0.14159…` is *outside* the domain while `(π−3)/π = 0.04507…` is inside it. The enumerator and the journal nonetheless run the target `π−3`; the 128 541 453 figure belongs to a target that does not satisfy the document's own domain convention. The census itself is unaffected (the rule `n_{k+1} = ⌈1/r_k⌉ − 2` is applied to a positive real either way); what is unsupported is the claim that this run verifies the stated model at an admissible parameter.
- The census figure and the truncation/precision conventions are the source's own; the source insists elsewhere (§8.1) that no greedy test may be run in binary floats, because a float run once produced a spurious support.
- The document's own standing position is that the complexity law p(L) is **open**; only this orbit law and the structural facts of §3 are claimed as established.
