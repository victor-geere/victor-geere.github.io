# The smoothing law — the round's main result

**Kind:** Theorem
**Status:** VERIFIED (numerical, 5–7 digits at `N = 10^5`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh044/README.md`](../../research/twin-prime-parity/rounds/rh044/README.md) — "The settled facts", fact 2, lines 50–67

## Statement

```
|S_N^φ(1/2+it) − ζ(1/2+it)| / √N  →  |M_φ(s)| ,   M_φ(s) = ∫_0^1 φ(u)u^{−(1/2+it)}du
```

The source's table:

| weight `φ(u)` | measured `\|E\|/√N` at `N = 10^5` | `\|M_φ(s)\|` | ratio |
|---|---|---|---|
| `1` (sharp) | 0.070703705 | `\|1/(s−1)\| = 0.070703528` | 1.0000025 |
| `u(1−u)` | 0.0049012629 | 0.0049012243 | 1.00001 |
| `(u(1−u))^3` | 0.00011771845 | 0.00011771845 | 1.000000 |
| `(1−cos 2πu)/2` | 0.0079729835 | 0.0079729835 | 1.000000 |
| `e^{−u}` | 0.026142297 | 0.026142378 | 0.999997 |

with the accompanying prose: "So **smoothing does not remove the `√N`** (the last-decade exponent is `0.5000` for every weight); it rescales the constant, by up to a factor `600` for `(u(1−u))^3`. *(An earlier draft claimed the smoothed error is `O(N^{−1/2})`; that is refuted by the same measurements and corrected here.)*"

## Hypotheses and notation

- `S_N^φ` is the smoothed partial sum and `M_φ(s) = ∫_0^1 φ(u)u^{−(1/2+it)}du` its Mellin transform (the README's normalisation; the ledger writes `M_φ(s) = ∫_0^1 φ(u)u^{−s}du`).
- `E = S_N^φ − ζ` is the smoothed error; `s = 1/2 + it`.
- The last-decade exponent is the log–log exponent over `N = 10^4 → 10^5`.

## Proof / evidence

The README lists this under "The settled facts (verified by the round and by its independent auditor)" and gives the table above. The ledger's version records the status "**VERIFIED** to 5–7 digits at `N = 10^5`, `t = 14.134725141734693`, for six weights"; the round's auditor route is `verify/independent_check.py` (reported in the README as 43/43 checks passing).

## Dependencies and related results

- [Theorem 2 (weight law)](tpp-rh044-truths-theorem-2-weight-law.md) — the source's ledger version of this result (T2); this file is its README restatement.
- [R2 — "smoothing removes the `√N` fluctuation"](tpp-rh044-truths-r2-smoothing-removes-sqrt-n.md) — the refuted earlier-draft claim mentioned in the prose.
- [README fact 1](tpp-rh044-readme-fact-1-sharp-cutoff-euler-maclaurin.md) — the sharp-cutoff case.

## Notes

- Restatement of round **rh044** §2 (the ledger's T2, the round's main result); the evidence is numerical (5–7 digits at one height), not a proof.
- The prose says "for six weights" while the table lists five rows; the discrepancy is the source's and is recorded, not corrected, here (the same count appears in [R2](tpp-rh044-truths-r2-smoothing-removes-sqrt-n.md)).
