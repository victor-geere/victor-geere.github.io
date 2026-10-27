# B2 — the ζ-budgets are index-parity objects; the twist-invariance identity

**Kind:** Claim
**Status:** VERIFIED (numerical — twist invariance exact: 0 mismatches on `10^6`; the supporting census is a finite table at `N=10^7`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/checks/06-numerical-checks.md`](../../research/twin-prime-parity/checks/06-numerical-checks.md) — § rh47, "Headline numbers" B2 (lines 651–664)

## Statement

> B2 — the ζ-budgets are **index-parity** objects. The `2×2` table at `N=10^7`:
>
> | | Ω even | Ω odd | total |
> |---|---|---|---|
> | n even | 2 501 146 | 2 498 854 | 5 000 000 |
> | n odd | 2 498 433 | 2 501 567 | 5 000 000 |
>
> independence expectation `2 499 789.5`; `χ²(1) = 2.9441`, `z = 0.9905`; `#{n ≤ N : index parity ≠ Ω parity} = 4 997 287 = 0.4997 N`; `Σ_{n≤N} λ(n)(−1)^n = 5426` (`5.43e-4·N`). The auditor strengthens this with **twist invariance**: `Σ λ(n)(−1)^n · λ(n+2)(−1)^{n+2} = Σ λ(n)λ(n+2)` **exactly** (0 mismatches on `10^6`), so index parity is invisible to the correlation itself. Auditor's `|S12(N)| = |Σ(−1)^n λ(n)|`: `464` at `10^5`, `1302` at `10^6`, log-log slope `0.464` (consistent with `½`, not `1`).

## Hypotheses and notation

- "Index parity" is the parity of `n` itself; "`Ω` parity" is the parity of the total number of prime factors with multiplicity, i.e. the value of `λ(n) = (−1)^{Ω(n)}`.
- `N = 10^7` is the census cut-off; the `2×2` table counts `n ≤ N` by (index parity) × (`Ω` parity).
- Twist invariance is the identity `Σ λ(n)(−1)^n · λ(n+2)(−1)^{n+2} = Σ λ(n)λ(n+2)`, the sign factors `(−1)^n(−1)^{n+2} = 1` cancelling identically.
- `S12(N) = Σ(−1)^n λ(n)` is the auditor's companion quantity.

## Proof / evidence

- `rh47/greedy_parity_probe.py` → `greedy_parity_probe.log` (current summary **`23 checks pass, 0 fail (wall clock 3.5 s)`**, confirmed by a scratch re-run); auditor `rh47/verify/independent_check.py` → `independent_check.log` (**`RESULT: 31/31 checks pass`**).
- The twist-invariance identity is reported with **0 mismatches on `10^6`**; the register's "What it establishes" says: "B2's strengthening is an exact identity (twist invariance), so even perfect index-parity knowledge cannot move `Σλ(n)λ(n+2)`."

## Dependencies and related results

- The register's *Cross-checking* table row "rh47 nominal `z`" and the B3 / sparse-bound entries of the same round.
- The same identity is ledger row `F7` ("index parity invisible to the correlation") of the dictionary source; its exact form is `THEOREM 5.5 (the twist-invariance identity, F7)` there, and the equivalent harvested file is `tpp-dict-03-twist-invariance.md`.

## Notes

- The register's labels: the budgets "separate *index* parity, not `Ω`-parity" (also *Corrections* item 7 of this register).
- The `χ²(1) = 2.9441` and `z = 0.9905` figures are the register's own readings of the `2×2` table against the independence expectation `2 499 789.5`; they are finite-range census statements at `N=10^7`.
- The superseded `21 checks pass, 1 fail` run in the same log (with `z = 0`, `μ₀ = −1.019104`) "should not be cited" (register's *Corrections* item 5).
