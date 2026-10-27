# The corrected sparse-modification bound

**Kind:** Claim
**Status:** **PROVED (paper argument; machine-checked in Lean 2026-10-11 — OP-12 closed).** The `rh47` Lean layer was subsequently written: `Rh47/Sparse.lean` proves the corrected bound, its sharpness and the falsity of the inherited form (`check.sh --all` 2/2, axiom-clean).
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/checks/06-numerical-checks.md`](../../research/twin-prime-parity/checks/06-numerical-checks.md) — *Corrections and discrepancies*, item 2 (lines 759–767)

## Statement

> **rh46's sparse-modification bound is FALSE.** `chowla_two_point.log` SS4 and `independent_check.log` D4 state `|S_A(x) − S(x)| ≤ 2·#{n ≤ x+2 : n ∈ A}` "for ANY flip set `A`". The rh47 auditor refutes it: `A = {5}`, `x = 5` gives `|ΔS| = 4 > 2` (the two affected terms `n=3` and `n=5` each change by `−2`). **Correct bound:** `|S_A(x) − S(x)| ≤ 2·#{n ≤ x : n ∈ A or n+2 ∈ A} ≤ 4·#{m ≤ x+2 : m ∈ A}` (`rh47/verify/independent_check.log` C4a–C4b; `rh47/truths.md` §3). The `o(x)` conclusion is unaffected: a sparse `A` still moves `S` by `o(x)`.

## Hypotheses and notation

- `S(x) = Σ_{n≤x} λ(n)λ(n+2)`; `A ⊆ ℕ` is a finite flip set and `S_A(x)` is the same correlation computed with `λ` replaced by `−λ` on `A`.
- The naive/refuted form bounds `|S_A(x) − S(x)|` by `2·#{n ≤ x+2 : n ∈ A}`; the corrected form counts indices `n ≤ x` with `n ∈ A` **or** `n+2 ∈ A`, and then dominates that count by `4·#{m ≤ x+2 : m ∈ A}`.
- The register states the corrected bound in prose from `rh47/truths.md` §3 and the auditor's checks C4a–C4b.

## Proof / evidence

- Refutation witness: `A = {5}`, `x = 5`, `|ΔS| = 4 > 2`, each of the affected terms `n=3` and `n=5` changing by `−2`.
- Correct bound: `≤ 2·#{n ≤ x : n ∈ A or n+2 ∈ A} ≤ 4·#{m ≤ x+2 : m ∈ A}` (`rh47/verify/independent_check.log` C4a–C4b; `rh47/truths.md` §3).
- The register notes the `o(x)` conclusion of the original argument is unaffected.

## Dependencies and related results

- The non-multiplicativity / no-Euler-product entry and the finite-prefix-indeterminacy entry of the same register.
- The same corrected bound is registered as open problem `OP-12` in [`07-open-problems.md`](../../research/twin-prime-parity/open/07-open-problems.md) ("the `rh46` version is **REFUTED**"; correct bound "PROVED in prose … the `rh47` Lean layer is **empty**"), and it is the row `F5` of the dictionary ledger.

## Notes

- The source labels the `rh46` form "FALSE" and corrects it. At harvest time the correction was prose-only; it is now **machine-checked** (`Rh47/Sparse.lean`, 2026-10-11).
- This file harvests the corrected inequality (the positive content) and records the refuted form as its motivation; the refuted form itself is preserved verbatim above.
