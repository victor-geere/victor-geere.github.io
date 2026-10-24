# The census law: n_{k+1} = ⌈1/r_k⌉ − 2

**Kind:** Proposition
**Status:** VERIFIED (numerical; predictions exact to 4–5 digits for six targets, census to index 1.285×10⁸)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 7, lines 541–552; "The ten things that stand" §2, line 615

## Statement

> **The census B proposed as "the computation worth a year", done by jumping to the next selected index at 200 digits.** Testing n_{k+1} = ⌈1/r_k⌉ − 2:

| θ/π | selected indices | residuals | prediction 1/r_k |
|---|---|---|---|
| 1/π | 2, 13, 607, **845027**, 1010073215737 | 0.06831, 0.001643, 1.183e−6, 9.90e−13 | 14.639, 608.561, 845028.0, 1.010e12 |
| log 2 | 0, 4, 36, 6069, **144715219** | 0.1931, 0.02648, 1.647e−4, 6.91e−9, 1.706e−17 | 5.177, 37.764, 6070.75, 1.447e8 |
| √2−1 | 1, 11, 251, **218199** | 0.08088, 0.003957, 4.583e−6, 1.631e−11 | 12.364, 252.707, 218200 |
| e−2 | 0, 3, 53, 9997 | 0.2183, 0.01828, 1.000e−4, 2.762e−10 | 4.581, 54.699, 9998.97 |
| (√5−1)/2 | 0, 7, 143, 37984 | 0.118, 0.006923, 2.633e−5, 4.263e−10 | 8.472, 144.449, 37985.4 |
| π−3 | 6, 59, 5018, **128541453** | 0.01659, 1.992e−4, 7.780e−9, 6.138e−18 | 60.268, 5019.8, 1.28541e8 |

> The prediction is exact to 4–5 digits every time. **The census is complete: it reaches index 128 541 453 for π−3, and no further computation is needed to establish the law.**

Final synthesis:

> **For irrational θ/π the census is complete and the law is exact:** n_{k+1} = ⌈1/r_k⌉ − 2, verified to 4–5 digits for six targets, reaching index 845 027 (1/π), 218 199 (√2−1), 144 715 219 (log 2), 128 541 453 (π−3).

## Hypotheses and notation

- r_k is the greedy residual after the k-th selection; n_{k+1} is the next selected greedy index; the denominator of the alphabet element taken is n_{k+1} + 2.
- ⌈·⌉ is the ceiling; the computation was done at 200 digits.
- "Selected indices" are the positions n with δ_n = 1.

## Proof / evidence

Numerical, at 200 digits of working precision, by jumping directly to the next selected index. The prediction 1/r_k matches the realised index (minus 2) to 4–5 significant digits at every listed step for all six targets. The census reaches index 128 541 453 for π−3 without precision loss.

## Dependencies and related results

- [The squaring law: r' = (1−f)r²/(1 + (1−f)r)](research-journal-squaring-law.md) — the closed form of the same recurrence.
- [A(N) = log₂ log N + O(1) for irrational θ/π](research-journal-digit-count-log-log-law.md) — the counting consequence.
- [Greedy harmonic sine: |sin θ − s_N| ≤ π/(N+1) on [0,π]](research-journal-greedy-harmonic-sine-error-bound.md) — the construction the census belongs to.

## Notes

- The status is VERIFIED (numerical): the source says "no further computation is needed to establish the law", but it is an empirical law confirmed on six targets, not a proof.
- Round 10 records this among the certified STANDING results: "The squaring law r' = (1−f)r²/(1+(1−f)r) ⇒ A(N) = log₂ log N + O(1) — verified to every digit at 120 dps; census to index 1.285e8."
