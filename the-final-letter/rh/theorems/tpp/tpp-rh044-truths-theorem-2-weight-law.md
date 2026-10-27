# Theorem 2 (weight law)

**Kind:** Theorem
**Status:** VERIFIED (numerical, 5–7 digits at `N = 10^5`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh044/truths.md`](../../research/twin-prime-parity/rounds/rh044/truths.md) — §2 "The smoothing law (T2) — the round's main result", line 67

## Statement

For a bounded weight `φ : [0,1] → ℝ` whose Mellin transform `M_φ(s) = ∫_0^1 φ(u)u^{−s}du` converges,

```
|S_N^φ(1/2+it) − ζ(1/2+it)| / √N   →   |M_φ(s)| .
```

## Hypotheses and notation

- `φ : [0,1] → ℝ` is a bounded weight whose Mellin transform `M_φ(s) = ∫_0^1 φ(u)u^{−s}du` converges; the README writes the same transform as `M_φ(s) = ∫_0^1 φ(u)u^{−(1/2+it)}du`.
- `S_N^φ` is the smoothed partial sum; the sharp cutoff is `φ ≡ 1`, the divergent-at-0 case whose constant is `1/|s−1| = 1/√(1/4+t²)`.
- `s = 1/2 + it` on the critical line; the reported measurements are at `t = 14.134725141734693`.
- The ledger label for this result is **T2**; the round calls it its main result.

## Proof / evidence

The source: "**VERIFIED** to 5–7 digits at `N = 10^5`, `t = 14.134725141734693`, for six weights":

| weight `φ(u)` | measured `\|E\|/√N` | `\|M_φ(s)\|` | ratio |
|---|---|---|---|
| `1` (sharp) | 0.070703705 | `\|1/(s−1)\| = 0.070703528` | 1.0000025 |
| `u(1−u)` | 0.0049012629 | 0.0049012243 | 1.00001 |
| `(u(1−u))^3` | 0.00011771845 | 0.00011771845 | 1.000000 |
| `(1−cos 2πu)/2` | 0.0079729835 | 0.0079729835 | 1.000000 |
| `e^{−u}` | 0.026142297 | 0.026142378 | 0.999997 |

The ledger's status header defines VERIFIED as "independent recomputation in this round"; the round's auditor route is `verify/independent_check.py`, reported in the README as 43/43 checks passing.

## Dependencies and related results

- [Theorem 1 (Euler–Maclaurin, full first terms)](tpp-rh044-truths-theorem-1-euler-maclaurin-first-terms.md) — the sharp-cutoff case `φ ≡ 1`.
- [R2 — "smoothing removes the `√N` fluctuation"](tpp-rh044-truths-r2-smoothing-removes-sqrt-n.md) — the refuted contrary claim.
- [Consequence 1](tpp-rh044-truths-consequence-1-sqrt-n-growth-universal.md), [Consequence 2](tpp-rh044-truths-consequence-2-smoothing-buys-only-constant.md), [Consequence 3](tpp-rh044-truths-consequence-3-residual-closed-form.md), [Consequence 4](tpp-rh044-truths-consequence-4-bounded-error-vanishing-mellin.md) — the source's numbered consequences of this theorem.
- [Theorem 3 (Riemann's theta identity)](tpp-rh044-truths-theorem-3-riemann-theta-identity.md) — the route that reaches exponential accuracy instead.
- [README fact 2 — the smoothing law](tpp-rh044-readme-fact-2-smoothing-law.md) — restates this result.

## Notes

- The source labels this its main result and "the round's one genuinely new statement"; the evidence is numerical (5–7 digits at one height), not a proof, so the status is VERIFIED, not PROVED.
- The prose says "for six weights" while the accompanying table lists **five** rows (`1`, `u(1−u)`, `(u(1−u))^3`, `(1−cos 2πu)/2`, `e^{−u}`); the same "six weights" count appears in [R2](tpp-rh044-truths-r2-smoothing-removes-sqrt-n.md). The discrepancy is the source's and is recorded, not corrected, here.
- The source notes the round adds no new analytic input: the route through the functional equation is Riemann's (1859) / Riemann–Siegel (1932).
