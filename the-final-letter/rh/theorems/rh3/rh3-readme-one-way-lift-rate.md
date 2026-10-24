# The uniform-pitch lift and its rate (11)

**Kind:** Theorem
**Status:** PROVED (paper argument)
**Area:** workspace
**Source:** [`rh3/README.md`](../../rh3/README.md) — §5 "The ledger: the uniform-pitch lift", equations (10) and (11), lines 116–136

## Statement

> ϑ̃(x) = (x − 1)·p − t·log x (10), with p = A + c·τ, A = π (half-turns on) or 0 (off), c = max(0, ⌈(t − A)/τ⌉) — whole turns per level (the "carry").
>
> Its rate is ϑ̃′(x) = p − t/x, strictly increasing in x, and ≥ 0 everywhere (11), so the thread never backs off, its rate never jumps at a station, and at the turning ring `x* = t/π` the rate is exactly *c* turns per level.

## Hypotheses and notation

- The bare lab angle before lifting is ϑ<sub>n</sub> = α<sub>n</sub> + ρ<sub>n</sub> = (n−1)π − t·log n (eq. (8)), with α<sub>n</sub> = (n−1)π the half-turns (α<sub>n</sub> ≡ 0 with `half = off`) and ρ<sub>n</sub> = −t·log n the torsion.
- τ = 2π. σ and *t* are the real and imaginary parts of s = σ + i·t; σ ∈ (0, ∞), *t* ∈ ℝ.
- The lift is a function of the continuous level x ∈ [1, ∞); the ledger samples it at integers, δ<sub>n</sub> = ϑ̃(n)/τ (eq. (12)).
- `x* = t/π` is the turning ring of §4 (eq. (9)); "the rate is exactly *c* turns per level" at x* means ϑ̃′(x*) = c·τ.

## Proof / evidence

The source states the rate and its two properties without proof: it fixes the whole-turn freedom once, for the whole thread, as a single uniform pitch, then asserts that this makes ϑ̃′ = p − t/x "strictly increasing in x, and ≥ 0 everywhere". It is an elementary consequence of the definitions (−t/x increases in x for t > 0 and the carry fixes p), but the document does not spell the argument out.

The document supports the claim with computed values at *t* = γ₁, half-turns on: c = 2, p = π + 2τ = 5π = 15.70796…, p/τ = 2.5 turns per level, and the ledger δ₁…δ₁₀ = 0.00 0.94 2.53 4.38 6.38 8.47 10.62 12.82 15.06 17.32 (τ) with increments Δδ = 0.94 1.59 1.85 2.00 2.09 2.15 2.20 2.24 2.26 rising monotonically toward p/τ = 2.5.

## Dependencies and related results

- [rh3-readme-lift-hits-every-station](rh3-readme-lift-hits-every-station.md) — the companion statement that ϑ̃(n) ≡ ϑ<sub>n</sub> (mod 2π) for every *n*.
- The source contrasts this uniform lift with the per-segment booking of rh6 (2): that lift is also monotone but its *rate* is not — at *t* = γ₁ the segments demand 0.94, 0.59, 0.85, 1.00, 0.09 turns, and "the 1.00 → 0.09 collapse is a residual artefact, not a fact about the numeral."

## Notes

- Section §5 is the construction's fixing of the winding, not a claim about ζ. The document's standing disclaimer (§12) says nothing in rh3 or in this file is a step toward the Riemann Hypothesis; it is "the construction the rest of the arc argues about, written down so it can be drawn the same way twice."
- The source writes the lifted angle with a combining tilde (ϑ̃); that markup is preserved here verbatim.
