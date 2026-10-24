# A's certification theorem for the greedy residual

**Kind:** Theorem
**Status:** PROVED (paper argument; verified numerically)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 6, line 537; "The ten things that stand" §4, line 617; Round 10 table (line 689, A's final statement); Round 9 closing, line 604

## Statement

> **A's certification theorem, which is the transferable result he has been looking for:** for α_n > 0 decreasing with Σα_n < ∞ and target θ/π ∈ (0, Σα_n), the residual r_{N+1} = r_N − δ_Nα_N satisfies (a) r_N non-increasing; (b) 0 ≤ r_N ≤ Σ_{k>N}α_k, a bound computable from N alone; (c) r_N → 0, terminating for every rational target; (d) for α_n = 1/(n+2) and θ = π, r_N = 0 for all N ≥ 4. Verified: π/(N+1) = 3.138×10⁻³ at N = 1000 and 3.142×10⁻⁶ at N = 10⁶, against zeta truncation magnitudes 2.23584 and 70.7035 at the same N.

Restated in the final synthesis:

> **A's certification theorem.** For α_n decreasing with Σα_n < ∞ and target in (0, Σα_n): r_N is non-increasing, 0 ≤ r_N ≤ Σ_{k>N}α_k is computable from N alone, r_N → 0, and termination holds exactly for rational targets. **Certification, not the sine, is the transferable idea.** It does not transfer to ζ, whose truncation error is non-monotone and unbounded at finite N.

## Hypotheses and notation

- α_n > 0 decreasing, n ≥ 0, with Σ_n α_n < ∞; target value θ/π ∈ (0, Σα_n).
- δ_N ∈ {0,1} is the greedy digit; r_N is the residual before step N; r_{N+1} = r_N − δ_Nα_N.
- (d) specialises to the harmonic alphabet α_n = 1/(n+2), target θ = π.

## Proof / evidence

The source states the four clauses as a theorem with the verification π/(N+1) = 3.138×10⁻³ at N = 1000 and 3.142×10⁻⁶ at N = 10⁶, against zeta truncation magnitudes 2.23584 and 70.7035 at the same N. Round 10 adds the exact instance: the certification is "certified by 0 ≤ r_N ≤ π/(N+1)". Agent B's closing note calls the greedy bound "an easy tail estimate"; the journal does not record a formal proof beyond the tail computation.

## Dependencies and related results

- [Greedy harmonic sine: |sin θ − s_N| ≤ π/(N+1) on [0,π]](research-journal-greedy-harmonic-sine-error-bound.md) — the harmonic instance of clause (b).
- [The AFE truncation floor: m = √(t/2π) terms, error O(t^{−1/4})](research-journal-afe-truncation-floor.md) — the object to which certification does **not** transfer.
- [A's corrected proposition on the termination/sampling dilemma](research-journal-greedy-termination-proposition.md) — clause (c) sharpened.
- [Certification requires zero information](research-journal-certification-zero-information.md) — the zeta-side counterpart.

## Notes

- The journal's framing: "**Certification, not the sine, is the idea that transfers — and it does not transfer to ζ, whose truncation error is non-monotone and unbounded at finite N.**"
- The source lists this among "the ten things that stand" and again in the Round 10 certified table.
