# The three-distance theorem (Sós 1958, Surányi 1958)

**Kind:** Theorem
**Status:** CITED (literature; verified numerically)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 3, lines 282 and 296; Synthesis §10, line 430; "The ten things that stand" §10, line 623

## Statement

> **Three-distance theorem (Sós 1958, Surányi 1958), verified:** for irrational θ the N gaps of the sorted fractional parts {kθ} take at most three distinct values, the largest being the sum of the other two. Measured for θ = (√5−1)/2 at N = 8, 13, 21, 34: always exactly 3 values, e.g. N = 34 → {0.013156, 0.021286, 0.034442} with 0.034442 = 0.013156 + 0.021286. Verified also for 1/π, log 2, and the angle γ₁/2π.

The summary table in the same round:

> | {kθ}, θ irrational | at most **3** gaps, largest = sum of other two (Sós 1958, Surányi 1958) | irrational rotation |

## Hypotheses and notation

- θ irrational; {kθ} are the fractional parts of kθ, k = 1, …, N; the "N gaps" are the gaps between consecutive points of the sorted set on the circle.
- γ₁ = 14.1347251417 is the first zeta zero ordinate; the tested angle is γ₁/2π.
- "The gap sizes are governed by the continued fraction denominators of θ."

## Proof / evidence

The source cites the theorem (Sós 1958, Surányi 1958) and reports an independent numerical verification: exactly 3 distinct gaps for θ = (√5−1)/2 at N = 8, 13, 21, 34, with the largest equal to the sum of the other two at N = 34 ({0.013156, 0.021286, 0.034442}); verified also for 1/π, log 2, and γ₁/2π. No proof is given.

## Dependencies and related results

- [The envelope law: Σ_{n≤N} n^{−σ} sin(t log n) ≈ N^{1−σ}/|1−σ+it|](research-journal-envelope-exponent-law.md) — the sine sum over the rotation that never settles.
- [Measured GUE level repulsion in the zeta zeros](research-journal-zero-level-repulsion.md) — the sequence for which the three-distance law fails.
- [Morse–Hedlund: p(L) = L + 1 for all L iff Sturmian](research-journal-morse-hedlund.md) — the complexity characterisation of the same rotation codings.

## Notes

- The source is careful about scope: "I tested the three-distance law against the *zero heights* and against the *prime phases*, and both failed. The zero failure is the real finding; the prime-phase test was mis-designed, because the primes are not an arithmetic progression, so Sós–Surányi does not apply to them a priori. I record the mis-design rather than the result."
- The journal's use of the theorem is to conclude that the greedy construction's rigid angle schedule {π/(n+2)} is the wrong model for the zero side: "the reconstruction of rigidity → repulsion is the second, independent obstruction."
- Round 7 adds, for the digit word itself: "Three-distance applies to the orbit {nθ}, not to the gaps between the 1s of this word." So this file records only the theorem as stated; it is not claimed for the greedy word.
