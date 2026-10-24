# (5)–(6) The two threads — S₋(U) = conj(S₊(U)) pointwise, and Ξ(t) = 4·Re S₊(∞)

**Kind:** Proposition
**Status:** PROVED (paper argument, elementary; by evenness)
**Area:** xi-horn
**Source:** [`xi-horn/README.md`](../../xi-horn/README.md) — §4 "The two threads, and what a zero looks like", equations (5)–(6)

## Statement

> Draw the **one-sided partial integral** on each sheet:
>
> ```
> S₊(U) = ∫₀^U Φ(u)·e^{itu} du            the +u thread
> S₋(U) = ∫₀^U Φ(u)·e^{−itu} du = conj(S₊(U))     the −u thread                (5)
> ```
>
> By evenness the −u sheet's thread is the **complex conjugate** of the +u sheet's, pointwise. That is the dual, drawn — not asserted. Both threads start at the throat, spiral outward with speed |Φ(u)|, and terminate at conjugate endpoints. Total arc length of each is `∫₀^∞Φ = 0.12428`, independent of *t*.
>
> The value is the sum of the pair:
>
> ```
> Ξ(t) = 2·( S₊(∞) + S₋(∞) ) = 4·Re S₊(∞)                                     (6)
> ```

## Hypotheses and notation

- Φ is the horn's weight, even and positive on ℝ (equation (1)); t is real in this section.
- S₊(U) = ∫₀^U Φ(u)·e^{itu}du is the +u thread; S₋(U) = ∫₀^U Φ(u)·e^{−itu}du is the −u thread.
- conj denotes complex conjugation; the −u sheet's weight is Φ(−u) = Φ(u) by evenness, and Φ is real.
- The arc length of each thread is ∫₀^∞ Φ = 0.12428, independent of t.
- Ξ(t) = ξ(½ + it) is the completed zeta function (equation (2)).

## Proof / evidence

The source derives the conjugacy directly: on the −u sheet the integral is ∫₀^U Φ(u)e^{−itu}du, which is the complex conjugate of S₊(U) because Φ is real; the pointwise identity is exact. Summing the two one-sided integrals and using (2) gives Ξ(t) = 2(S₊(∞) + S₋(∞)) = 4·Re S₊(∞). The arc length ∫₀^∞ Φ = 0.12428 is quoted from §1 and is independent of t.

## Dependencies and related results

- The normalisation (2): [xihorn-readme-xi-as-fourier-transform.md](xihorn-readme-xi-as-fourier-transform.md).
- The closure criterion that follows: [xihorn-readme-closure-criterion.md](xihorn-readme-closure-criterion.md).
- The weight's total mass ∫₀^∞Φ = 0.1242801945: [xihorn-readme-phi-positive-and-double-exponentially-small.md](xihorn-readme-phi-positive-and-double-exponentially-small.md).

## Notes

- The source phrases the conjugacy as "the dual, drawn — not asserted"; the derivation is one line from evenness and is reproduced in the file above.
- The t here is real; the tilt of §5 makes t complex and breaks the conjugacy.
