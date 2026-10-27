# Smoothing removes the fluctuations

**Kind:** Claim
**Status:** REFUTED (the smoothed error keeps the `√N` growth; only the constant is rescaled)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh044/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh044/HANDOFF.md) — §0 "What is verified before any claim is made", item 2, lines 44–57

## Statement

> 2. **Smoothing removes the fluctuations** (the error drops by a factor ~100 at
>    `N = 800`), but the residual is *still algebraic*, an oscillating tail.  The
>    candidate laws to be settled in this round:
>
>    * `|S_N^φ − ζ| = O(N^{-σ})` for a smooth weight `φ` with `φ(1) ≠ 0`
>      (on the critical line: `O(N^{-1/2})`);
>    * the fluctuation term `O(√N)` of the sharp cutoff is eliminated by *any* weight
>      with `φ(1) = 0`;
>    * `|E_N^exp − ζ| = O(N^{σ-1})` for the exponential weight `e^{-n/N}`
>      (`O(N^{-1/2})` on the critical line);
>    * **exponential** accuracy requires the functional equation: the classical
>      `ζ(s) = (1/(s-1)) + (1/s) θ-integral` (Riemann's theta smoothing) gives
>      `|ζ − ζ_θ| ≤ e^{-πN}` with `O(√N)` terms, and that is the only route here that
>      reaches `o(N^{-A})` for every `A`.

## Hypotheses and notation

- `S_N^φ` is the smoothed partial sum with weight `φ`; `E_N^exp` denotes the exponential-weight partial sum with weight `e^{−n/N}`.
- `σ = Re s`; on the critical line `σ = 1/2`.
- The four bullets are the source's "candidate laws to be settled in this round" — hypotheses, not established results.
- The source frames the item as the second of "Two facts, both new to this round".

## Proof / evidence

The same file's §0.5 Outcome corrects the item: "**smoothing does not remove the `√N`**: `|S_N^φ − ζ|/√N → |M_φ(s)| = |∫_0^1 φ(u)u^{−s}du|`, verified to 5–7 digits for six weights; the growth exponent is `0.5000` for every one of them, and smoothing only rescales the constant (best tested weight `(u(1−u))^3`, factor 600)". The settled law is [Theorem 2](tpp-rh044-truths-theorem-2-weight-law.md); the ledger refutation is [R2](tpp-rh044-truths-r2-smoothing-removes-sqrt-n.md). Of the four candidate laws, the first, second and third are refuted by the same measurements; the fourth (exponential accuracy via the functional equation) survives and is [Theorem 3](tpp-rh044-truths-theorem-3-riemann-theta-identity.md).

## Dependencies and related results

- [Theorem 2 (weight law)](tpp-rh044-truths-theorem-2-weight-law.md) — the correcting result.
- [R2 — "smoothing removes the `√N` fluctuation"](tpp-rh044-truths-r2-smoothing-removes-sqrt-n.md) — the ledger's row for this claim.
- [R4 — the theta identity `ζ(s) = 1/(s−1) + 1/s + …`](tpp-rh044-truths-r4-theta-identity-correction.md) — the variance of the classical identity quoted in the fourth bullet.
- [Theorem 3 (Riemann's theta identity)](tpp-rh044-truths-theorem-3-riemann-theta-identity.md) — the surviving fourth candidate.
- [README fact 2](tpp-rh044-readme-fact-2-smoothing-law.md) — the corrected version restated.

## Notes

- The quoted candidate laws are the round's hypotheses; they are reproduced verbatim because the item's own claim ("smoothing removes the fluctuations") cannot be read apart from them. They are not harvested as separate results.
- The theta form quoted in the fourth bullet is the misquoted variant refuted in [R4](tpp-rh044-truths-r4-theta-identity-correction.md).
- The item is kept with Status REFUTED because the round's §0.5 supersedes its central assertion.
