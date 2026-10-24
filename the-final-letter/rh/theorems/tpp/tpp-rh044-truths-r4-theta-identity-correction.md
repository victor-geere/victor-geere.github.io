# R4 — the theta identity `ζ(s) = 1/(s−1) + 1/s + …`

**Kind:** Claim
**Status:** REFUTED (off by exactly `1/s`: at `s = 2` it returns `1.547197551`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh044/truths.md`](../../research/twin-prime-parity/rounds/rh044/truths.md) — §0 "The corrections this round had to make to its own first draft", row R4, line 34

## Statement

The ledger row, verbatim:

> | R4 | theta identity `ζ(s) = 1/(s−1) + 1/s + …` | false (off by exactly `1/s`: at `s = 2` it returns `1.547197551`).  The classical identity is `π^{−s/2}Γ(s/2)ζ(s) = 1/(s(s−1)) + ½[A(s)+A(1−s)]`, `A(s) = ∫_1^∞ x^{s/2−1}(θ(x)−1)dx` |

## Hypotheses and notation

- `θ(x) = Σ_{n∈ℤ} e^{−πn²x}` is the Jacobi theta function; `Γ` is the gamma function.
- `A(s) = ∫_1^∞ x^{s/2−1}(θ(x)−1)dx`.
- The test value quoted by the source is `s = 2`, where the wrong form returns `1.547197551`.

## Proof / evidence

Refuted by the round's main agent before the audit (source line 36): the form is off by exactly `1/s`, returning `1.547197551` at `s = 2`. The corrected classical identity is stated in the same row and is harvested as [Theorem 3 (Riemann's theta identity)](tpp-rh044-truths-theorem-3-riemann-theta-identity.md).

## Dependencies and related results

- [Theorem 3 (Riemann's theta identity)](tpp-rh044-truths-theorem-3-riemann-theta-identity.md) — the classical identity that replaces this form.
- [handoff fact 2](tpp-rh044-handoff-fact-2-smoothing-removes-fluctuations.md) — the reconnaissance bullet quoting the related (wrong) theta form `ζ(s) = (1/(s-1)) + (1/s) θ-integral`.

## Notes

- "off by exactly `1/s`" is the source's own characterisation; no derivation is reproduced here.
- This is the only one of R1–R4 not caught by the auditor: the source says it was found by the main agent before the audit.
