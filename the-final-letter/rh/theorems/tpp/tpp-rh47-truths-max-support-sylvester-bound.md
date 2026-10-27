# `|A| ≥ 20` forces `max A ≥ s₂₀` (the Sylvester sequence), a 106 721-digit number

**Kind:** Corollary
**Status:** VERIFIED (numerical, 0 violations in 53 159 consecutive pairs)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh47/truths.md`](../../research/twin-prime-parity/rounds/rh47/truths.md) — §1, "Consequences (both VERIFIED numerically, 0 violations in 53 159 consecutive pairs)", line 33

## Statement

> `|A| ≥ 20` forces `max A ≥ s₂₀` (the Sylvester sequence), a number with **106 721 digits** — so a target whose support is large enough for a parity statistic has its largest index far beyond any computable `λ`.  (The class is non-empty: the ladder `x_k = (s_{k+1}−2)/(s_{k+1}−1)` has support exactly `{s₁,…,s_k}`.)

## Hypotheses and notation

- `A` is the support of the greedy word, `|A|` its cardinality, `max A` its largest element (source §1).
- `s₂₀` is the 20th term of the **Sylvester sequence**.
- `λ` is the Liouville function.
- The class of targets with `|A| ≥ 20` is shown non-empty by the ladder `x_k = (s_{k+1}−2)/(s_{k+1}−1)`, whose support is exactly `{s₁,…,s_k}`.

## Proof / evidence

The source tags this consequence "VERIFIED numerically, 0 violations in 53 159 consecutive pairs" and gives the Sylvester-sparse inequality
[`m_{i+1} ≥ m_i (m_i − 1) + 1`](tpp-rh47-truths-sylvester-sparse-support.md) as its basis.

The source also records the emptiness of the specified test domain:

> This is why the round's *specified* test (`|A| ≥ 20`) has an **empty domain**: of 19 900 rational targets with denominators `≤ 200` and 400 random ones with denominators up to `10¹²`, **none** has `|A| ≥ 20` (max sizes 11 and 18).

## Dependencies and related results

- [The greedy support is Sylvester-sparse](tpp-rh47-truths-sylvester-sparse-support.md) — the inequality this bound iterates.
- Sibling consequence: [the support density is `≈ 3.9·10⁻⁵`](tpp-rh47-truths-support-density-3-9e-5.md).
- Restated elsewhere in this round: [README §1.5](tpp-rh47-readme-sylvester-sparse-support.md), [HANDOFF H1](tpp-rh47-handoff-h1-sylvester-sparse-support.md).

## Notes

- The "106 721 digits" figure is quoted exactly as the source gives it; the source does not reproduce `s₂₀` itself.
- The label "Consequences" and the tag "both VERIFIED numerically, 0 violations in 53 159 consecutive pairs" cover this bullet together with the density bullet; the underlying inequality is proved, the iteration and the digit count are the numerical leg.
