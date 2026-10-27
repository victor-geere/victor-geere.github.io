# Theorem 3 (Riemann's theta identity)

**Kind:** Theorem
**Status:** CITED (literature, classical — Riemann 1859; independently re-verified numerically)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh044/truths.md`](../../research/twin-prime-parity/rounds/rh044/truths.md) — §3 "Exponential accuracy needs the functional equation (T3)", line 111

## Statement

```
π^{−s/2}Γ(s/2)ζ(s) = 1/(s(s−1)) + ½[A(s) + A(1−s)] ,   A(s) = ∫_1^∞ x^{s/2−1}(θ(x)−1)dx ,
```

with `θ(x) = Σ_{n∈ℤ} e^{−πn²x}` and `θ(1/x) = √x θ(x)`.

## Hypotheses and notation

- `θ(x) = Σ_{n∈ℤ} e^{−πn²x}` is the Jacobi theta function, with the functional equation `θ(1/x) = √x θ(x)`.
- `A(s) = ∫_1^∞ x^{s/2−1}(θ(x)−1)dx`; `Γ` is the gamma function and `ζ` the Riemann zeta function.
- The ledger label for this section is **T3**.

## Proof / evidence

The source: "**PROVED** (classical; Riemann 1859), **VERIFIED** by the auditor's independent route (own theta + own incomplete gamma, no import from the round): agreement with `ζ` to `5.7·10^{−69}` (`s = 2`), `1.8·10^{−68}` (`s = 4`), `1.0·10^{−64}` (`s = 1/2+it₁`). The rigorous tail bound decays like `e^{−πX}`: `B(X) = 7.9·10^{−7}, 1.6·10^{−12}, 1.2·10^{−23}, 1.0·10^{−45}, 1.9·10^{−48}` at `X = 4, 8, 16, 32, 34`."

No proof is given in the source; it is quoted as classical (Riemann 1859).

## Dependencies and related results

- [R4 — the theta identity `ζ(s) = 1/(s−1) + 1/s + …`](tpp-rh044-truths-r4-theta-identity-correction.md) — a misstated variant of this identity, refuted (off by exactly `1/s`).
- [Theorem 2 (weight law)](tpp-rh044-truths-theorem-2-weight-law.md) — the one-sided route whose `√N·|M_φ(s)|` error this identity replaces by an `e^{−πX}` tail.
- [README fact 3 — exponential accuracy needs the functional equation](tpp-rh044-readme-fact-3-exponential-accuracy.md) — restates this result.

## Notes

- The source marks this `PROVED (classical; Riemann 1859)`; per the harvest SPEC, a classical result set out as a labelled rung of the argument carries **Status CITED (literature)**. The source states it without proof.
- The round's R4 correction records that the frequently quoted form `ζ(s) = 1/(s−1) + 1/s + …` is off by exactly `1/s` (it returns `1.547197551` at `s = 2`).
- The source's conclusion: "A one-sided smoothed sum has error `√N·|M_φ(s)|`; the theta route is `e^{−πX}`-accurate with `O(√t)` terms", and exponential accuracy is reachable only through the functional equation.
