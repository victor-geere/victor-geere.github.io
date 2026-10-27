# The lattice is the better conditioned sampling; the multiplicative sampling has the better structure

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh34.html`](../../html/rh34.html) — §6 "What the fold buys"

## Statement

> The trade is not a floor for a floor, and the lattice wins the half that can be measured. At matched dimension the lattice holds 0.9586 at n = 8 where G holds 0.5685, and 0.7938 at n = 24 where G holds 0.2939; the ratio falls to 0.33 across that range.

> The reason is bunching. The gear rates crowd together at the top — the smallest gap in a length-32 Dirichlet polynomial is log(32/31) = 0.0317, about a quarter of the lattice's Δ = 0.12 — so G has near-duplicate rows that a Toeplitz matrix on an equispaced lattice never has. Equispacing is the best-conditioned sampling of a given reach, which is why the arc chose it, and it pays for that conditioning with the fold.

> So the two objects divide cleanly. **The lattice is the better conditioned one; the multiplicative sampling is the better structured one** — it cannot be fooled by an alias, because it has none.

## Hypotheses and notation

- "The lattice" is the arc's Toeplitz matrix on an equispaced grid of step Δ; "G" is §3's unwrapped Gram on the gear rates.
- Matched dimension means the same n / N.
- The smallest rate gap in a length-32 Dirichlet polynomial is log(32/31) = 0.0317.

## Proof / evidence

Numerical at matched dimension: lattice 0.9586 vs G 0.5685 at n = 8, lattice 0.7938 vs G 0.2939 at n = 24, ratio 0.33 across the range. The mechanism offered is bunching: log(32/31) = 0.0317 against Δ = 0.12.

## Dependencies and related results

- [rh34-unwrapped-gram-and-dirichlet-polynomial](rh34-unwrapped-gram-and-dirichlet-polynomial.md) and [rh34-no-uniform-dirichlet-floor](rh34-no-uniform-dirichlet-floor.md) — the two floors compared.
- rh34 §8 (a) — the successor question: whether λ<sub>min</sub>(G) is governed by the minimum log-gap, the counting function of {log i − log j}, or neither.
- [rh35-statistics-do-not-predict-the-floor](../rh35/rh35-statistics-do-not-predict-the-floor.md) — the answer: none of the three statistics predicts the floor.

## Notes


- The source's §6 reading blames bunching "on one number (the smallest gap) and one comparison"; rh35 §3 then refutes the minimum-gap statistic as a predictor, so this explanation does not survive.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
