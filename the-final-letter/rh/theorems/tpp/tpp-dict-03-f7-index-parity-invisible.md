# F7 — index parity ≠ `Ω` parity; index parity invisible to the correlation (bridge B2)

**Kind:** Claim
**Status:** REFUTED (the bridge claim; the companion twist-invariance is THEOREM 5.5)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §6, barrier table row F7; bridge **B2** in §5.4

## Statement

> **F7** — index parity ≠ `Ω` parity; index parity invisible to the correlation: §5.4 (B2) + Theorem 5.5. Status: REFUTED + THEOREM (5.5).

The bridge row states the claim that was refuted:

> **B2** (`F7`): the ζ budgets `P(p) = 2^{−p}ζ(p)`, `N(p) = (1−2^{−p})ζ(p) − 1` carry `Ω`-parity information — REFUTED.

## Hypotheses and notation

- `P(p) = 2^{−p}ζ(p)` and `N(p) = (1−2^{−p})ζ(p) − 1` are the ζ budgets of `rh42/truths.md` §2–§3; `η` is the quantity with `P−N = 1−η`.
- `Ω`-parity is the parity of `Ω(n)`, i.e. `λ(n) = (−1)^{Ω(n)}` (Definitions 1.1–1.2); **index** parity is the parity of `n` itself.
- `χ²(1) = 2.944` (`z = 0.99`) at `N = 10⁷` is the measured independence figure.

## Proof / evidence

- Numerical refutation (source, §5.4): the budgets are sign-blind combinations of `ζ(p)` (`P+N = ζ−1`, `P−N = 1−η`) and separate **index** parity, not `Ω`-parity; measured independence `χ²(1) = 2.944` (`z = 0.99`) at `N = 10⁷`.
- Decisive strengthening: index parity is **invisible to the correlation itself**, `Σ λ(n)(−1)^n·λ(n+2)(−1)^{n+2} = Σ λ(n)λ(n+2)` exactly (0/10⁶ mismatches) — by [`THEOREM 5.5`](tpp-dict-03-twist-invariance.md).
- Sources: `rh47` §2; `rh42` §2.

## Dependencies and related results

- [`THEOREM 5.5` (twist-invariance identity)](tpp-dict-03-twist-invariance.md) — the theorem-level half of this row.
- [F6](tpp-dict-03-f6-no-signal-greedy-support.md) and [F9](tpp-dict-03-f9-corrected-barrier.md) (companion barrier rows); the `rh42` budget results are harvested in the `tpp-rh42-truths-*` files.
- Restated as barrier-row `F7` in the §7 ledger row "6 (F6–F8)".

## Notes

- This row has **two** epistemic halves: the refutation of bridge B2 (numerical, with the measured independence `χ²(1) = 2.944`) and the elementary theorem 5.5 (exact identity). The Status records the refutation and names the theorem; the theorem itself is harvested at [twist-invariance](tpp-dict-03-twist-invariance.md).
- The figures `χ²(1) = 2.944`, `z = 0.99`, `N = 10⁷`, `0/10⁶ mismatches`, and the budget identities `P+N = ζ−1`, `P−N = 1−η` are quoted exactly as the source gives them.
