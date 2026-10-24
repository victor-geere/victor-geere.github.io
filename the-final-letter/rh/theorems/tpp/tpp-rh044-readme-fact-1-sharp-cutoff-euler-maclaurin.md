# The sharp cutoff is the Euler–Maclaurin main term

**Kind:** Theorem
**Status:** PROVED (paper argument, Euler–Maclaurin; checked to 5 digits at `N = 10^5`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh044/README.md`](../../research/twin-prime-parity/rounds/rh044/README.md) — "The settled facts", fact 1, lines 34–48

## Statement

```
S_N(s) = N^{1−s}/(1−s) + ζ(s) + O(N^{−1/2})        (checked to 5 digits at N = 10^5)
|S_N(1/2+it) − ζ(1/2+it)| / √N  →  1/|s−1| = 1/√(1/4 + t²)
```

The source's table of measured `|S_N−ζ|/√N`:

| `t` | `1/√(1/4+t²)` | at `N = 10^2, 10^3, 10^4, 10^5` |
|---|---|---|
| 14.134725141734693 | 0.0707035277318 | 0.0709386, 0.0707218, 0.07070530, 0.07070370 |
| 21.022039638771555 | 0.0475556741611 | 0.0477615, 0.0475684, 0.04755687, 0.04755579 |

and the accompanying prose: "At a zero, `S_N ≈ √N/|s−1|` — the zero appears only after cancellation. *(An earlier draft of this round claimed the constant `1/√(2t)`; that is wrong by a factor `2.66` at `t = 14.13` and is corrected here.)*"

## Hypotheses and notation

- `S_N(s) = Σ_{n≤N} n^{−s}` is the sharp partial sum; `ζ` is the Riemann zeta function; `s = 1/2 + it`.
- The expansion is the Euler–Maclaurin expansion; the source writes the remainder as `O(N^{−1/2})` after isolating the main term `N^{1−s}/(1−s)`.
- The two tabulated heights are the first two zeros, `t₁ = 14.134725141734693` and `t₂ = 21.022039638771555`.

## Proof / evidence

The source states the law as a settled fact "verified by the round and by its independent auditor", with the explicit check "checked to 5 digits at `N = 10^5`"; the table gives the measured column at four values of `N` for each of the two heights. The underlying theorem with the full Euler–Maclaurin terms and coefficient checks is [Theorem 1](tpp-rh044-truths-theorem-1-euler-maclaurin-first-terms.md).

## Dependencies and related results

- [Theorem 1 (Euler–Maclaurin, full first terms)](tpp-rh044-truths-theorem-1-euler-maclaurin-first-terms.md) — the source's ledger version of this result (T1); this file is its README restatement.
- [R1 — the sharp fluctuation constant is `1/√(2t)`](tpp-rh044-truths-r1-sharp-fluctuation-constant.md) — the refuted earlier-draft constant mentioned in the prose.
- [HANDOFF fact 1](tpp-rh044-handoff-fact-1-sharp-cutoff-constant.md) — the reconnaissance version with the wrong constant.

## Notes

- Restatement of round **rh044** §1 (the ledger's T1); the README adds nothing beyond the table and the correction note.
- The remainder here is `O(N^{−1/2})`; the ledger's modulus statement is `|S_N(s) − ζ(s)| = √N/|s−1| + O(1)`. Both are the source's own renderings of the same expansion.
