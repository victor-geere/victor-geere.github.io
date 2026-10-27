# rh45 — the corrected Weil explicit formula and the naive-normalisation refutation

**Kind:** Claim
**Status:** CITED (literature for the explicit formula itself: "The explicit formula is a known theorem"; VERIFIED (numerical) for the corrected convention, on four kernels to 44–63 digits; the naive normalisation is REFUTED)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/checks/06-numerical-checks.md`](../../research/twin-prime-parity/checks/06-numerical-checks.md) — § rh45, "Headline numbers" (lines 392–413); *Corrections and discrepancies*, item 7

## Statement

> Corrected Weil explicit formula
> `Σ_ρ Φ(ρ) = Φ(1)+Φ(0) − Σ_{n≥2} Λ(n)/√n [g(log n)+g(−log n)] + (1/2π)∫_ℝ φ(t)Ψ(t)dt`,
> `Ψ(t) = −log π + Re ψ(1/4+it/2)`, `Φ(1)+Φ(0) = 2φ(i/2)` for even `g`:
>
> | kernel | LHS | RHS − LHS | truncation bound |
> |---|---|---|---|
> | Gaussian `φ=e^{−t²/2}` | 8.2619765949e-44 | 1.56477e-44 | zero 3.18799e-12151, prime 2.27964e-43 |
> | modulated Gaussian (`θ=γ₁`) | 1.0000000000500724334 | 9.63025e-46 | zero 5.88835e-10743 |
> | narrow Gaussian (`σ=¼`) | 0.00388829070707166133 | −1.10094e-63 | zero 2.6715589e-761 |
> | Cauchy companion `a=1` | 0.12539427897704363758 | +0.01870876736 | density estimate 0.01189760566 (≈2 digits only) |
>
> Falsification of the round's naive normalisation (C1d/Gaussian): literal `RHS − LHS = 0.536580471657` (reading A) and `1.57877108264` (reading B), decomposing as pole-argument error `F(1)+F(0) − 2φ(i/2) = −0.65976624642101921005` plus missing archimedean `−1.1963467180780578254`.

The register's *Corrections* item 7 restates the correction:

> **rh45's naive explicit formula.** Pole terms `F(1)+F(0)` and the omitted archimedean integral make the literal RHS wrong by `0.536580471657` (reading A). The correction is itemised: `−0.65976624642101921005` (pole arguments) and `−1.1963467180780578254` (missing archimedean).

## Hypotheses and notation

- `Φ` is the Mellin-type transform of the test function `g`, `φ` its Fourier companion; `g` even, so `Φ(1)+Φ(0) = 2φ(i/2)`.
- `Ψ(t) = −log π + Re ψ(1/4+it/2)` is the archimedean term (`ψ` = digamma); `Λ` is the von Mangoldt function; the sum `Σ_ρ` is over the nontrivial zeros.
- `γ₁ = 14.1347251417346937904572519836…` is the first zero ordinate (used for the modulated Gaussian).
- "Reading A" and "reading B" are the two literal readings of the round's normalisation that the auditor tested.

## Proof / evidence

- The corrected convention is verified on four kernels: "verified on four kernels to 44–63 digits (the Cauchy companion only to ~2 digits, honestly labelled)".
- Auditor `rh45/verify/independent_check.py` → `rh45/verify/independent_check.log`, final line **`FINAL: 19/21 checks pass (t=307.2s)`**; Lean `Rh45/Explicit.lean`, `Rh45.lean` OK. The round script's own log **does not exist** (the run was interrupted), so all numbers here are the auditor's.
- The two rigorous **refutations** the register attributes to this round: "the naive normalisation is wrong (decomposition given), and the `a=1/2` Cauchy kernel cannot be verified as stated (the divergence computation is exact)".
- The register's own caveat on the formula's status: "The explicit formula is a known theorem; the numerics confirm the implementation and fix the convention. They say nothing about RH."

## Dependencies and related results

- The register's *Corrections* item 4 (the rh45 ledger count `17/21` is stale; the log's `19/21` is authoritative) and item 13 (the missing `explicit_formula.log`).
- `OP-10` of [`07-open-problems.md`](../../research/twin-prime-parity/open/07-open-problems.md): "An admissible explicit-formula kernel with an `O(1)` left side and a rapidly converging zero sum" is **OPEN**.

## Notes

- The register classifies the formula as literature ("a known theorem") and the numerical work as confirming the implementation and fixing the convention; the kernel table's Gaussian LHS is `~1e-44`, so "those kernels check `0 = 0`; only the modulated Gaussian has an `O(1)` LHS".
- The `C4.1` cost refutation and the `a=1/2` Cauchy-kernel refutation are recorded in this register; the latter is the boundary case of the same formula.
- `rh45/truths.md`'s pass count is stale (it says `17/21` with four failures); the log is authoritative (*Corrections* item 4).
