# The budget sign-blindness package

**Kind:** Claim
**Status:** VERIFIED (numerical — identity residuals `≤ 1.32e-81`; twist invariance exact, 0 mismatches on `10^6`; separation of *index* parity only)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/checks/06-numerical-checks.md`](../../research/twin-prime-parity/checks/06-numerical-checks.md) — § rh42, "Headline numbers" (lines 70–83); § rh47, B2 (lines 651–664); *Corrections and discrepancies*, item 7

## Statement

> Budgets `P(p)=2^{−p}ζ(p)` (even m), `N(p)=(1−2^{−p})ζ(p)−1` (odd m ≥ 3) … Identity residuals `P+N−(ζ(p)−1)` and `P−N−(1−η(p))` are `≤ 1.32e-81` (`helix_zeta.log` §1).

> B2 — the ζ-budgets are **index-parity** objects. … independence expectation `2 499 789.5`; `χ²(1) = 2.9441`, `z = 0.9905`; `#{n ≤ N : index parity ≠ Ω parity} = 4 997 287 = 0.4997 N` … The auditor strengthens this with **twist invariance**: `Σ λ(n)(−1)^n · λ(n+2)(−1)^{n+2} = Σ λ(n)λ(n+2)` **exactly** (0 mismatches on `10^6`), so index parity is invisible to the correlation itself.

The register's own compression of the package (the "budget sign-blindness" leg of the barrier):

> the proved legs are budget sign-blindness (plus twist invariance) and the Euler-product failure; "the two do not mix" is not established.

## Hypotheses and notation

- `P(p)` is the even-`m` budget, `N(p)` the odd-`m` budget (`m ≥ 3`); `η(p)` is the quantity in `P−N = 1−η(p)`.
- "Sign-blind" means the budgets are built from prime-side magnitudes only and are constant in the target's sign structure; they separate *index* parity (parity of `n`), not `Ω`-parity (the parity of `Ω(n)`, i.e. `λ(n)`).
- Twist invariance: the factors `(−1)^n` and `(−1)^{n+2}` multiply to `1`, so the identity holds term by term.

## Proof / evidence

- Budget identities: `rh42/helix_zeta.py` → `rh42/verify/helix_zeta.log` (**`ALL 80 CHECKS PASS`**, `exit=0`), reproduced bit-identically by `helix_zeta_rerun.log`; residuals `≤ 1.32e-81`.
- Twist invariance: auditor `rh47/verify/independent_check.py` → `independent_check.log` (**`RESULT: 31/31 checks pass`**); 0 mismatches on `10^6`.
- Census at `N=10^7`: `rh47/greedy_parity_probe.py` → `greedy_parity_probe.log` (current block **`23 checks pass, 0 fail (wall clock 3.5 s)`**).

## Dependencies and related results

- The Sylvester-sparsity theorem and the non-multiplicativity / no-Euler-product entry of the same source.
- `OP-12`, `OP-16`, `OP-18` of [`07-open-problems.md`](../../research/twin-prime-parity/open/07-open-problems.md); the barrier downgrade entry of this harvest (`tpp-open-07-barrier-downgraded-to-heuristic.md`).
- Dictionary ledger rows `F7` (index parity invisible) and `F9` (the corrected barrier).

## Notes

- *Corrections* item 7 of the register: "The budgets separate *index* parity, not `Ω`-parity (rh47 §2)."
- The `z = 0` / `μ₀ = −1.019104` block in the same probe log is a superseded buggy intermediate: "The `21/1` block should not be cited" (*Corrections* item 5).
- The register is careful that this is a *proved leg* of the barrier only: the impossibility conclusion ("the two do not mix") is a HEURISTIC, not a theorem (register's "What it does not", § rh47).
