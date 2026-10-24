# A(N) = log₂ log N + O(1) for irrational θ/π

**Kind:** Theorem
**Status:** VERIFIED (numerical; census to index 1.285×10⁸ — the O(1) is measured, not proved)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 7, lines 560–564; "The ten things that stand" §3, line 616; Round 9 closing, line 604; Round 8, line 576; "The single open problem", lines 713–719

## Statement

> **Consequence, which is the sharpest result of the second sitting:** there is **no universal constant**; c_k = (1−f)/(1+(1−f)r) depends only on the fractional part of 1/r_k. In log coordinates u_{k+1} = u_k(1+A_k)/A_k with A_k = 1−{u_k}, so log u_{k+1} = 2 log u_k + log((1+A_k)/A_k) — a slope-2 recurrence with bounded noise, giving
>
>   **A(N) = log₂ log N + O(1).**
>
> The mechanism is the **squaring of the residual**, not the divergence of the harmonic series.

And the Round 8 evidence:

> The orbit average of log c_k over 7–9 steps: **−0.4220 (1/π), −0.9309 (log 2), −0.5671 (√2−1), −1.2015 (e−2), −0.7155 (π−3), −0.5774 ((√5−1)/2)**. Bounded, negative, and **target-dependent** — so A(N) = log₂ log N + O(1) stands.

## Hypotheses and notation

- A(N) = #{n ≤ N : δ_n = 1} for irrational θ/π; δ_n are the greedy digits in the alphabet 1/(n+2).
- r_k are the residuals; u_k = 1/r_k; f = {u_k}; c_k = r_{k+1}/r_k²; log₂ is the base-2 logarithm.
- The recurrence log u_{k+1} = 2 log u_k + log((1+A_k)/A_k) with A_k = 1 − {u_k}.

## Proof / evidence

The census (n_{k+1} = ⌈1/r_k⌉ − 2) was completed to index 128 541 453 for π−3 at 200 digits; the source states "no further computation is needed to establish the law". The O(1) term was measured via orbit averages of log c_k over six targets. The upgrade of the O(1) from measured to proved is exactly the single open problem stated at the end of the journal.

## Dependencies and related results

- [The squaring law: r' = (1−f)r²/(1 + (1−f)r)](research-journal-squaring-law.md) — the derivation of the slope-2 recurrence.
- [The census law: n_{k+1} = ⌈1/r_k⌉ − 2](research-journal-census-law.md) — the census establishing the law numerically.
- [The orbit average of log c_k is bounded, negative and target-dependent](research-journal-orbit-average-log-c.md) — the measured O(1) control.
- [A(N) = Θ(1) for rational θ/π, density 0](research-journal-rational-digit-count-theta-one.md) — the rational regime.

## Notes

- The two corollaries the journal attaches: the O(1) is controlled exactly when Σ log c_k converges — equivalently when {1/r_k} stays away from 1 — and "neither agent proved this and neither did I."
- The source's own honest status: the law is measured, not proved. The single open problem is: "Prove or refute: for every irrational x ∈ (0,1), the orbit r ↦ r − 1/⌈1/r⌉ satisfies (1/K)Σ_{k≤K} log c_k → a limit independent of x as K → ∞ — equivalently, Σ_k log c_k is bounded. If true, A(N) = log₂ log N + O(1) upgrades from measured to **proved**, with a universal O(1)."
- Round 10 Correction 3 also records that the 7–9-step orbit averages are "**transients, not limits**", so the measured O(1) evidence is weaker than a first reading suggests.
