# The census identity — `#intervals = 2^{n_min−1}`, `measure = 2^{n_min−1} T_{n_min}`

**Kind:** Claim
**Status:** PROVED (Lean, global form — `Rh42/Reachable.lean`, per the register; the register's own evidence for the recorded numbers is VERIFIED numerical, two independent routes to `3.89e-62`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/checks/06-numerical-checks.md`](../../research/twin-prime-parity/checks/06-numerical-checks.md) — § rh42, "Headline numbers" and "What it does not" (lines 107–141)

## Statement

> Census theorem `#intervals = 2^{n_min−1}`, `measure = 2^{n_min−1} T_{n_min}` checked for `p = 1.2 … 12`; the two independent routes agree to `3.89e-62`.

The register's restatement of its strength:

> The `R6` monotonicity of the reachable fraction and the `R2` interval count are verified for `p ∈ {1.2, …, 12}`; the general statement is the census theorem in Lean.

The source's quantitative consequence, as used in the register's reachable-fraction line:

> Reachable fraction of the budget: `1.0` up to `p*`, then `0.937`, `0.784`, `0.658`, `0.491`, `0.256`, `0.0528`, `0.00104` at `p = 1.8, 2, 2.2, 2.5, 3, 4, 6`.

## Hypotheses and notation

- `n_min = n_min(p)` is the first index at which the relevant half-tail of the alphabet becomes complete (the register's § rh42 uses it for both halves).
- `T_{n_min}` is the common length of each of the `2^{n_min−1}` disjoint intervals whose union is the reachable set `S_1`.
- `p*` is the ζ-threshold `ζ(p*) = 2` of the same round.

## Proof / evidence

- Numerical verification on the ladder `p = 1.2 … 12`: `rh42/reachable.py` → `rh42/verify/reachable.log`; the register records that "the two independent routes agree to `3.89e-62`".
- The general statement is attributed by the register to the Lean module `Rh42/Reachable.lean` (Lean log `rh42/verify/lean_check.log`: `Rh42/Reachable.lean`, `Budget.lean`, `Tau.lean`, `Rh42.lean` all OK, `exit=0`). **The register names the module but not the declaration.**

## Dependencies and related results

- The exact reachable sets at `p=2, 3` and the budget identities of the same round; the completeness thresholds `p*` and `q`.
- `n_min(p)` is the object of the open problem `OP-5` in [`07-open-problems.md`](../../research/twin-prime-parity/open/07-open-problems.md).

## Notes

- The register prints the census formula as a formula about the number of intervals and their total measure; the "checked" clause is explicitly restricted to `p = 1.2 … 12`, with the general statement moved to Lean.
- The register is explicit that the reachable-fraction monotonicity and interval-count checks on that ladder do **not** establish the general statement.
