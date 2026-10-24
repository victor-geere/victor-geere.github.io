# "Im at fixed Re" has content only when |z| is also pinned at 1

**Kind:** Proposition
**Status:** PROVED (paper argument; verified numerically)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 3 framing, lines 279–280; Round 0e, line 99

## Statement

> - **|z| = 1, Re z = cos θ fixed:** Im z^k = sin(kθ). Bounded by 1 for all k; for irrational θ/π the set {sin(kθ)} is *dense* in [−1,1] but never settles; for rational θ/π it is periodic (θ = π/2 gives the period-4 cycle 1, 0, −1, 0). Verified for θ = 30°, 45°, 60°, 75°, 89°.
> - **|z| ≠ 1 with Re z = u fixed:** there is no independent question. |z^k| = |z|^k, so Im z^k = |z|^k·(v/|z|) — the imaginary part scales with the *full modulus* to the k-th power, and the ratio Im z^k/|z|^k is the fixed number v/|z|. Measured: (u,v) = (0.3,0.4) → 0.4, 0.24, 0.044, −0.0336, −0.03116; (0.6,0.8) → 0.8, 0.96, 0.352, −0.5376, −0.99712; (0.9,0.8) → 0.8, 1.44, 1.432, 0.4896, −1.19512. **So "Im at fixed Re" has content only when |z| is also pinned at 1.** That is a clean theorem-shaped negative result.

## Hypotheses and notation

- z = u + iv with |z| = 1 in the first case (u = cos θ, v = sin θ); z ↦ z^k.
- In the second case |z| ≠ 1 with u = Re z fixed and v = Im z; the ratio v/|z| is a fixed number.
- "Content only when |z| is also pinned at 1" means: away from the unit circle the imaginary part merely scales as |z|^k, so no independent fixed-Re question exists.

## Proof / evidence

The elementary computation |z^k| = |z|^k implies Im z^k = |z|^k·(v/|z|); the source gives this derivation and reports the three (u,v) measurement series. The boundedness and density statements on the unit circle are stated and were verified for θ = 30°, 45°, 60°, 75°, 89°; Round 0e gives the sampled values (e.g. θ = 30° → 0.5, 0.866, 0.5, −0.866, 0.866, 0.866, 0.866 for k = 1, 2, 5, 10, 100, 1000, 10⁴; θ = 89° → 0.9998, 0.0349, 0.9962, 0.1736, −0.9848, 0.9848, 0.9848).

## Dependencies and related results

- [The envelope law: Σ_{n≤N} n^{−σ} sin(t log n) ≈ N^{1−σ}/|1−σ+it|](research-journal-envelope-exponent-law.md) — the redirect of the question to the height family, where σ plays Re and t the angle.
- [The three-distance theorem (Sós 1958, Surányi 1958)](research-journal-three-distance-theorem.md) — the equidistribution behind "dense but never settling".

## Notes

- The source labels this "a clean theorem-shaped negative result" and states the redirection explicitly: "Away from |z| = 1 there is nothing to see (|z| < 1 decays, |z| > 1 blows up), so the only fixed-Re family with bounded imaginary part *is* the unit circle."
- The later Round 3 usage notes that even on the unit circle the sum over the rotation never settles; that is a property of the sine sum, not of this scaling result.
