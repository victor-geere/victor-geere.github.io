# The sharp cutoff does not converge *at a zero* in the practical sense (constant `1/√(2t)`)

**Kind:** Claim
**Status:** REFUTED (the constant `1/√(2t)` is corrected to `1/|s−1| = 1/√(1/4+t²)` in §0.5 of the same file)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh044/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh044/HANDOFF.md) — §0 "What is verified before any claim is made", item 1, lines 40–43

## Statement

> 1. **The sharp cutoff does not converge *at a zero* in the practical sense**: the
>    difference grows like `√N`, with the exact constant `1/√(2t) = 0.0707036…` — the
>    measured column `|S_N−ζ|/√N` is `0.07094, 0.07081, 0.07075, 0.07073, 0.07071`.
>    The partial sum itself is `≈ √(N)/(√2 t)`, i.e. it never "sees" the zero.

## Hypotheses and notation

- Reconnaissance setting: `t = 14.134725141734693` (the first zero `t₁`), system Python with `mpmath` at 40–120 dps, `|ζ(1/2+it)| ~ 1e-16`.
- `S_N(s) = Σ_{n≤N} n^{−s}` is the sharp partial sum; the measured column corresponds to `N = 100, 200, 400, 800, 1600`.
- The source introduces the item as one of "Two facts, both new to this round (rh43 asserted the first qualitatively; the constant `1/√(2t)` is now identified)".

## Proof / evidence

Measured in the source's reconnaissance table: `|S_N − ζ|/√N = 0.07094, 0.07081, 0.07075, 0.07073, 0.07071`. The constant is corrected in the same file's §0.5 Outcome: "the sharp-cutoff constant is `1/|s−1| = 1/√(1/4+t²)`, **not** `1/√(2t)` (factor 2.66 at `t = 14.13`)". The corrected law is [Theorem 1](tpp-rh044-truths-theorem-1-euler-maclaurin-first-terms.md); the ledger refutation is [R1](tpp-rh044-truths-r1-sharp-fluctuation-constant.md).

## Dependencies and related results

- [R1 — the sharp fluctuation constant is `1/√(2t)`](tpp-rh044-truths-r1-sharp-fluctuation-constant.md) — the ledger's row for the same wrong claim.
- [R3 — the scaled ratio `|S_N|·√(2t)/√N → 1`](tpp-rh044-truths-r3-sharp-scaled-ratio-limit.md).
- [Theorem 1 (Euler–Maclaurin, full first terms)](tpp-rh044-truths-theorem-1-euler-maclaurin-first-terms.md) — the corrected constant.
- [README fact 1](tpp-rh044-readme-fact-1-sharp-cutoff-euler-maclaurin.md) — the corrected version restated.

## Notes

- The `√N`-growth part of the claim survives; only the quoted constant `1/√(2t)` is refuted by the round's own §0.5 and by [R1](tpp-rh044-truths-r1-sharp-fluctuation-constant.md).
- This is reconnaissance ("before any claim is made"); the round's later outcome supersedes the constant. The harvest keeps it with Status REFUTED rather than PROVED.
