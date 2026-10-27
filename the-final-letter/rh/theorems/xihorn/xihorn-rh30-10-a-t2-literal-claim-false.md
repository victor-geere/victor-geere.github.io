# Theorem 2

**Kind:** Theorem
**Status:** PROVED (paper argument)
**Area:** xi-horn
**Source:** [`xi-horn/rh30-10-a.md`](../../xi-horn/rh30-10-a.md) — §3 "The literal claim is false"

## Statement

> **Theorem 2.** There is no function F with λ_min/‖μ‖ = F(n/N_eff), and none
> with λ_min ≥ c‖μ‖F(n/N_eff) for F positive below 1.

## Hypotheses and notation

- `N_eff = ‖μ‖ / (2 max_γ ĥ(γ)²)` (4), rh30 §2 — "a statement about the weights
  alone (rh30 §2, asserted there to 1 part in 10¹²)".
- `‖μ‖ = E_h(0)`; `λ_min` the smallest eigenvalue of `T_n(μ)`; μ as in
  [Theorem 1](xihorn-rh30-10-a-t1-lp-form-of-lambda-min.md).
- The statement is a refutation of the "literal claim" of rh30 §10 (a), which
  asked for a proof that λ_min/E_h(0) is a function of n/N_eff, or failing that
  for `λ_min ≥ c·E_h(0)·F(n/N_eff)` with F explicit and positive below 1.

## Proof / evidence

The source's proof, verbatim: "N_eff is a statement about the weights alone
(rh30 §2, asserted there to 1 part in 10¹²). Fix the weights and n; then
n/N_eff is fixed while λ_min ranges over four decades. Computed, at N = 400
atoms with weights w_k = k^{−2} and n = 25 throughout, λ_min/‖μ‖ is

```
  positions scattered on the circle          1.035e−02
  positions on an exact grid, weights winding monotonically   1.813e−03
  positions clustered in an arc of length 0.05                0   (−1.8e−15)
```

The third is exactly zero: a degree-24 polynomial can be made uniformly small on
a short arc, so the whole measure is annihilated at n/N_eff far below 1. ∎"

The source further notes that "**rh30's own §5 contains the counterexample**,
three sections before the claim": its four controls at Δ′ = 0.12, n = 151
include
```
  true positions, true weights — the arc        λ_min/‖μ‖ = 0.2846
  grid positions, true weights                  λ_min/‖μ‖ = 2.9433e−06
```
"— identical weights, hence identical N_eff = 95.7, identical n, and λ_min
9.7×10⁴ apart."

## Dependencies and related results

- [Theorem 1](xihorn-rh30-10-a-t1-lp-form-of-lambda-min.md) (the LP form used to exhibit annihilation on a short
  arc); [Theorem 3](xihorn-rh30-10-a-t3-arc-mass-floor.md) and [Theorem 4](xihorn-rh30-10-a-t4-monotonicity-in-measure.md) are the file's surviving
  positive results.
- The source's reading: "What survives is the conditional form: **the collapse
  is a law about the arc's own family**, whose positions are {γΔ′ mod 2π} and
  are equidistributed unconditionally (Hlawka, via rh30 §5). Any proof must
  carry a positional hypothesis."
- rh31 §3 reported the law "breaks off its native family"; rh31 §7 listed
  "λ_min is not a function of n/N_eff" among the things it is not.

## Notes

- The source states the consequence plainly: rh30 §10 (a) "was therefore
  **unprovable as written from the moment it was written**, and … the nine
  documents which left it open were leaving open a false statement."
- The status is PROVED (paper argument): the source's own Theorem 2 is the
  **negative** statement (a nonexistence result), established by the computed
  counterexamples above; it is this theorem that refutes the literal collapse
  claim, which is recorded here rather than as a separate REFUTED entry.
- The third computed case is a numerical zero (`−1.8e−15`), described by the
  source as "exactly zero"; the argument for exactness is the degree-24
  polynomial made uniformly small on a short arc, not the floating-point value.
