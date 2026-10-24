# What the cancellation is — the twenty-three-digit collapse is the theta functional equation

**Kind:** Theorem
**Status:** CITED (literature; classical θ functional equation, exhibited numerically to twenty-three digits)
**Area:** xi-horn
**Source:** [`xi-horn/figure.html`](../../xi-horn/figure.html) — §2 "The mirror, measured", theorem box "What the cancellation is"

## Statement

> It is not a numerical misfortune. The twenty-three-digit collapse on the mirror side **is** the theta functional equation being enforced — the integers conspiring to reproduce, exactly, the mirror of the smooth positive side. Its magnitude is the content, and it is also why one must never evaluate Φ at negative u: use Φ(|u|), and double precision is sufficient everywhere.

## Hypotheses and notation

- Φ is Riemann's weight, a sum over the integers: Φ(u) = Σ<sub>n≥1</sub> φ<sub>n</sub>(u), with φ<sub>n</sub>(u) = (2π²n⁴e<sup>9u/2</sup> − 3πn²e<sup>5u/2</sup>)·e<sup>−πn²e<sup>2u</sup></sup>.
- Φ is even, positive and double-exponentially small; its evenness "is θ(1/x) = √x·θ(x), the functional equation, already installed" (source §1).
- "The mirror side" is u < 0; at u = −1.5 the shells sum to 0.95 in absolute value and produce 6.5×10<sup>−24</sup> (source §2, Figure 1 caption). The source calls this the twenty-three-digit collapse.
- The readout prints the condition number Σ|φ<sub>n</sub>| / |Φ| at the current extent.
- The subject is the completed function: Ξ(t) = ξ(½ + it) = 2(S<sub>+</sub> + S<sub>−</sub>) with S<sub>±</sub> = ∫<sub>0</sub><sup>∞</sup> Φ(u)e<sup>±itu</sup>du; for real t the two threads are conjugate and Ξ = 4 Re S<sub>+</sub>.

## Proof / evidence

The source states this as an identification rather than proving it: §1 installs the evenness of Φ as θ(1/x) = √x·θ(x) and the box asserts that the mirror-side collapse is that equation being enforced. The evidence it gives is numerical: all arithmetic is float64, "Φ is evaluated at |u| with six terms, which is accurate to 10<sup>−15</sup> relative down to Φ ~ 10<sup>−30</sup>", and the footer reports an offline cross-check against a 60-digit mpmath evaluation — Ξ at γ<sub>1</sub>…γ<sub>5</sub> returns ~2×10<sup>−17</sup> (machine zero), Ξ(17) = −5.433786×10<sup>−4</sup> against −5.433785679×10<sup>−4</sup>, γ(n) agrees to 10<sup>−9</sup> relative through n = 20, and the margin ratios reproduce the 60-digit values to six figures.

## Dependencies and related results

- Companion texts of the same directory: [README.md](../../xi-horn/README.md) ("the closure form"), [POSITIVITY.md](../../xi-horn/POSITIVITY.md) ("the shape form"), [INTEGERS.md](../../xi-horn/INTEGERS.md) ("the integer shells").
- [prime-horn.html](../../xi-horn/prime-horn.html) runs the same recipe on the primes; its (9) is the analogue of the pre-balanced bump.
- The classical theta functional equation θ(1/x) = √x·θ(x).

## Notes

- The box is a `box thm` but carries no number; it is the only theorem box in the source. Its title phrase is the box label "What the cancellation is".
- The same source's warn box ("What this is not") is explicit that nothing here is new: "Ξ as the transform of Φ is 1859; the Turán inequalities for ξ are a theorem (Csordas–Norfolk–Varga, 1986); the Jensen / Laguerre–Pólya criterion is classical and the Hermite limit is 2019. This page computes and draws; it discovers nothing."
- The "twenty-three digits" are float64 output, not a certified interval; the source's own precision claim is that evaluating Φ at |u| makes "double precision … sufficient everywhere".
- The source's §1 sentence "RH, here: the horn only closes when it is untilted" is an unlabelled prose reformulation of the critical strip, not harvested as a theorem.
