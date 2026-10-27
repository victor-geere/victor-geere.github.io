# §1.4 refinement — the sparse-modification bound `|S_A(x) − S(x)| ≤ 2·#{n ≤ x+2 : n ∈ A}`

**Kind:** Claim
**Status:** REFUTED (witness `A = {5}`, `x = 5`, `|ΔS| = 4 > 2`); **machine-checked in Lean 2026-10-11** as `Rh47.rh46_sparse_bound_false`.
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh46/README.md`](../../research/twin-prime-parity/rounds/rh46/README.md) — §1.4 "A refinement the auditor proved"; correction in the round's own trailing record note

## Statement

As stated in §1.4:

> A refinement the auditor proved: flipping a *sparse* set cannot work —
> `|S_A(x) − S(x)| ≤ 2·#{n ≤ x+2 : n ∈ A}`, so an `o(x)`-sized flip set moves the sum
> by `o(x)` only.  Positive density (as above, density `1/2`) is necessary.  The
> witness is not multiplicative (parity chains are pinned), which is the correct
> reading: prefix-indeterminacy holds for arbitrary `±1` extensions.

As corrected in the round's trailing record note:

> 2. the sparse-modification bound `≤ 2·#{n ≤ x+2 : n ∈ A}` is **false**; the correct
>    bound is `2·#{n ≤ x : n ∈ A or n+2 ∈ A} ≤ 4·#{m ≤ x+2 : m ∈ A}`
>    (witness `A = {5}`, `x = 5`).  The `o(x)` conclusion is unaffected.

## Hypotheses and notation

- `A` is the set on which the signs are flipped; `S_A(x)` the resulting correlation sum, `S(x)` the true one.
- `ΔS` is the difference `S_A(x) − S(x)`.
- The corrected count uses `#{n ≤ x : n ∈ A or n+2 ∈ A}`, i.e. it counts `n` for which either endpoint of the pair `(n, n+2)` is flipped.

## Proof / evidence

- The top-level programme README's correction table (row X2) records the witness: the round's claim `≤ 2·#{n ≤ x+2 : n ∈ A}` is "**false** — correct is `2·#{n ≤ x : n ∈ A or n+2 ∈ A} ≤ 4·#{m ≤ x+2 : m ∈ A}` | witness `A = {5}`, `x = 5`: `|ΔS| = 4 > 2` (rh47 §3)".
- The round's own trailing record note repeats the correction verbatim.
- The §1.4 conclusion — that an `o(x)`-sized flip set moves the sum by `o(x)` only, and that positive density is necessary — is preserved: "The `o(x)` conclusion is unaffected."

## Dependencies and related results

- Belongs to the finite-prefix indeterminacy discussion (§1.4, harvested separately).
- The corrected bound is also recorded in the dictionary ("F5 corrected sparse bound") and in the rh47 ledger.
- The round's §1.5 companion correction withdraws the Dirichlet-series route (harvested as the non-multiplicativity entry).

## Notes

- Harvested because the round's own record note labels the claim explicitly ("the sparse-modification bound ... is **false**"); the status is **REFUTED** and the corrected inequality is quoted exactly.
- The source's §1.4 attributes the (false) bound to "the auditor"; the correction likewise comes from the research harvest (rh47 §3).
- The inequality `2·#{n ≤ x : n ∈ A or n+2 ∈ A} ≤ 4·#{m ≤ x+2 : m ∈ A}` is quoted with the source's own formatting (the README writes it without escapes, so the union is plain text, not a table).
