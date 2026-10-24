# No spectral event in t is possible under a diagonal similarity: min|eig| = 1.269263e−04 at every t

**Kind:** Theorem
**Status:** PROVED (paper argument; verified numerically from t = 0 to 55)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 0c, line 78; Round 1 ruling, line 186; Round 2 Agent B answer, line 230; Synthesis §8, line 426; "The ten things that stand" §9, line 622; Round 10 table, line 682

## Statement

> The eigenvalue is *constant in t to every digit computed*. The reason is structural, not numerical: at s = ½+it the weight has modulus (n+2)^{−1} **independently of t**, so M = D K D is a fixed diagonal similarity transform of K, and a similarity leaves the eigenvalue order completely unchanged. There is no mechanism in this ansatz by which a zero could ever show up. … In the fixed-½+it form the claim is **impossible**, not merely unsupported. This is the deeper kill, and it is worth recording as a general lesson: an ansatz whose only t-dependence is a diagonal scaling can never detect a spectral event in t.

Formally:

> M_{n,m}(s) = K(n,m)(n+2)^{−(s+1/2)}(m+2)^{−(s+1/2)} at s = ½+it has |w_n| = (n+2)^{−1}, which is real and t-free, so M(t) = D K D with D = diag((n+2)^{−1}) **independent of t**, and M(t) = M(0) exactly for every t. This uses only the moduli; it is insensitive to whether K is diagonal… Measured min |eig| = 1.269263e−04 at every t tested, identical to all digits.

Round 10 certification:

> M(t) = DKD is a diagonal similarity, t-free, so no spectral event in t is possible — min|eig| = 1.269263e−04 at every t ∈ [0,55].

## Hypotheses and notation

- φ_n = δ_n(θ) − θ/π (greedy digit function); K(n,m) = ∫₀^π φ_n φ_m is the Gram matrix.
- M_{n,m}(s) = K(n,m)(n+2)^{−(s+1/2)}(m+2)^{−(s+1/2)}; s = ½ + it; D = diag((n+2)^{−1}).
- "Spectral event in t" means any change with t in the ordered eigenvalue magnitudes (in particular an eigenvalue drop at a zero ordinate).

## Proof / evidence

Paper argument: at s = ½ + it the weight modulus is (n+2)^{−1}, real and independent of t, so M(t) = D K D with D independent of t; a diagonal similarity preserves eigenvalue orders exactly. Numerical certificate: min |eig| = **1.269263e−04** at every t tested (0, 5, 10, 14.134725, 20, 21.022040, 25, 30.424876, 40, 50, 55; and from 0 to 55 in the later restatements), identical to all digits computed. The source also notes the Gram matrix itself is not diagonal: max |off-diagonal| = **0.8631** (200 001-point quadrature; Agent B's Legendre-orthogonality argument for diagonality was wrong and he acknowledged it), with largest eigenvalue growing like N and smallest decaying like N^{−2}, so the condition number grows like N².

## Dependencies and related results

- [Greedy harmonic sine: |sin θ − s_N| ≤ π/(N+1) on [0,π]](research-journal-greedy-harmonic-sine-error-bound.md) — the construction whose eigensolve this refutes.
- [No canonical finite object vanishes exactly at a zero](research-journal-no-finite-object-vanishes-at-zero.md) — the broader obstruction.
- [The AFE truncation floor: canonical m = √(t/2π) terms, error O(t^{−1/4})](research-journal-afe-truncation-floor.md) — the independent truncation obstruction.

## Notes

- The source records the retraction it refutes: the handoff's claim that the smallest eigenvalue of M(s) drops 7–11 orders at the zeros is "not merely unfounded, it is structurally impossible in this ansatz." The handoff's original eigensolve was also traced to a plot of `simulateMinEigenvalue` = −11·exp(−8·dist²).
- The journal's Round 2 accepts Agent B's crisp reformulation: "an ansatz whose only t-dependence is a diagonal congruence is a fixed matrix up to similarity, and similarity cannot create or destroy a spectral event; therefore the retracted claim was structurally impossible, not merely unsupported."
