# Nested-spheres working note — claim inventory

**Source:** [`maths/nested_spheres_RH.md`](maths/nested_spheres_RH.md) and [`maths/nested_spheres_RH.html`](maths/nested_spheres_RH.html).
**Verdict:** the set-up, exact identity, parity independence and sampling error are consistent with the canonical paper; the support/depth claims and the final RH conclusion are **not established**.

## Claims and status

| # | Claim | Status |
|---|---|---|
| Definition 1.1 | Mean-zero coefficients $c_m(N)=1-N$ if $N\mid m$, $1$ otherwise. | Correct; same filter as canonical Definition 3.1. |
| Lemma 1.2 | Purification identity $\sum_{m\ge1}c_m(N)m^{-s}=(1-N^{1-s})\zeta(s)$, meromorphic continuation. | Correct; elementary, same as canonical Lemma 2.2. |
| Definition 1.3 | Coherent polygonal sum $\eta_N(M)(s)=\sum_{m\le M}c_m(N)m^{-s}$, quadratic link $M=N^2$. | Definition; consistent with canonical Definition 3.1. |
| Definition 2.1 | Embed the polygon on a three-sphere fibre of the quaternionic Hopf fibration; nested radii scaled by $N^{-1}$. | Geometric model; no analytic consequence by itself. The interactive picture is [`viz.html`](viz.html). |
| Lemma 2.2 | Parity independence: all estimates hold for every integer $N\ge2$. | True for the exact filter and the canonical estimates; the canonical paper also does not require parity. |
| Definition 3.1 | Complete fibre curves: great-circle orbits or Hopf images of trigonometric curves. | Definition. |
| Lemma 3.2 | Hausdorff distance between polygon and complete curve is $O(N^{-1})$ uniformly in height $t$. | Correct; the canonical paper cites this note for the $O(N^{-1})$ comparison (Lemma 4.3.3). |
| Definition 4.1 | Path-closure of depth $\delta$: $\rho_N(t)\le N^\delta$; depth $N^{1/2-\varepsilon}$ means $\rho_N(t)\le N^{1/2-\varepsilon}$. | Definition; the canonical paper uses a more refined relative/balanced definition (Definition 5.1), because an absolute threshold alone is not enough. |
| Theorem 4.2 | Balanced path-closures of the stated depth occur **iff** $\operatorname{Re}s=1/2$. | **Overstated.** The canonical Theorem 5.2 says balanced closures are confined to $\sigma\le\tfrac12+\varepsilon/2$ and that critical-line zeros produce them. It does not say every balanced closure lies exactly on the line, and with a fixed aperture it does not. |
| Definition 4.3 | Residual measure $\mu_N(dt)=\rho_N(t)(1+t^2)^{-1}dt$. | Definition; cf. canonical Definition 8.1. |
| Lemma 4.4 | $\lVert\mu_N\rVert=O(N^{-1})$ uniformly. | The factor $1/N$ is the canonical residual-density normalisation, but the proof here uses a second-moment bound and a dyadic improvement; the canonical proof is different (Theorem 11.1). Treat as unsupported as written. |
| Lemma 4.5 | Second-moment bound $\int_{-T}^T\lvert\eta_N(N^2)(\tfrac12+it)\rvert^2dt\le C_0NT\log(2T)$. | **Not correct as stated.** Canonical Theorem 7.1 is $TN\log N+N^3$: the spike term contributes an additive $N^3$ independent of $T$, which the note drops. At fixed $T$ and large $N$ the note’s bound is therefore too strong. |
| Theorem 5.1 | Tightness of $\{\mu_N\}$. | True in the canonical paper (Theorem 9.1), but the proof here relies on the unsupported Lemma 4.4 and Prokhorov. |
| Theorem 5.2 | Every weak-star limit is pure-point and supported on imaginary parts of non-trivial zeros **that lie on the critical line**. | **Not established.** This is stronger than the canonical Theorem 10.1/12.2, which allow unrestricted atoms at right-half zeros. Claiming support only on the line is already RH. |
| Theorem 6.1 | Depth-of-closure $\lvert\eta_R(R^2)(\tfrac12+i\gamma)\rvert\le C_\gamma R^{1/2-\eta}$. | **Not established.** It rests on the continuous-radius differential inequality, which uses the false local-diagonal constant. Canonical depth comes from Theorem 4.1 at zeros instead. |
| Lemma 6.2 | Residual-measure tails $O(R^{-\alpha/2})$. | Unsupported as written; canonical tail control is Lemma 9.6, with a different proof and rate. |
| Conclusion | “Every weak-star limit is supported on all non-trivial zeros, all of which lie on the critical line, and the Riemann hypothesis follows.” | **Not accepted.** The canonical paper proves a conversion (Corollary 12.3), not RH. The right-half unrestricted atom is the surviving gap. |

## Where the argument overreaches

Two steps carry the conclusion:

1. **Depth from the continuous-radius differential inequality.** This is the same false $c_1=\tfrac12$ route as in the continuous-cone note. The canonical paper withdrew it. See [continuous-cone.md](summary/13-working-notes/continuous-cone.md) for the exact integral.
2. **Support only on the critical line.** The canonical measure theory proves that every limit is supported on zeros of $\Xi$ (Theorem 10.1), and that the left half-strip is removed by Marty speed (Lemma 4.8). It does **not** remove the right half-strip: a right-half zero remains an unrestricted atom. The equality of supports is exactly the open statement (Corollary 12.3).

## What survives

The exact filter, the all-$N$ parity independence, the nested-fibre geometric picture, and the $O(N^{-1})$ sampling error are usable. The note is a valuable record of the geometric intuition; it is not a proof.

## What to read instead

- [Lemma 2.2 (Purification identity)](summary/02-exact-filter-and-remainder/01-lemma-2.2.md)
- [Lemma 4.3.3 (Completed curve)](summary/03-geometry-and-identity-l/01-lemma-4.3.3.md)
- [Theorem 9.1 (Tightness)](summary/05-spectral-measures-and-tightness/08-theorem-9.1.md)
- [Theorem 10.1 (No spurious atoms)](summary/05-spectral-measures-and-tightness/09-theorem-10.1.md)
- [Corollary 12.3 (Conversion)](summary/05-spectral-measures-and-tightness/13-corollary-12.3.md)

[Back to folder README](summary/13-working-notes/README.md) · [Back to the summary index](summary/README.md)
