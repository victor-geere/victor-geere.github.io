# Description of the programme

## What this is

`the-final-letter/` is the synthesis of two research corpora and one certified-computation layer:

1. [`summary/`](../../summary/README.md) — the geometric DQPT/spectral-measure programme for the Riemann hypothesis, based on the canonical paper `publication.html`.
2. [`summary-rh/`](../../summary-rh/README.md) — the greedy-harmonic-sine/twin-prime parity programme in `~/workspace/rh`, based on the 13-section ledger and 15 published papers.
3. [`topics/partial-sum-plus-tail/`](../../topics/partial-sum-plus-tail/README.md) — Objective III, the certified partial-sum-plus-tail evaluator for `ζ`, `ζ(s,a)` and `L(s,χ)`, reconstructed from `~/workspace/rh/research/twin-prime-parity/012/`.

The sources are not merged by copying their files. They are rewritten into a single argument with a shared vocabulary, a shared status ledger, a shared wall/bridge analysis, and a shared Lean spine.

## The two questions

**The Riemann question.** Can the non-trivial zeros of `ζ` be realised as the support of a spectral measure built from finite Euler-sum polygons, and can the equality of the balanced and unrestricted supports be proved?

**The parity question.** Can the greedy harmonic sine — a deterministic, sign-blind object — solve the parity problem for the twin prime conjecture by producing a positive-density correlation with `Ω`?

## The two answers

**Riemann.** The programme proves the conversion: RH is equivalent to the equality of the supports of the balanced and unrestricted measure families. It proves that the additive toolbox cannot prove RH, by running the same construction on the Davenport–Heilbronn function and correctly reporting a false RH there. The remaining gap is the absence of a right-half atom of the unrestricted measure, equivalently the joint non-vanishing of `K = ¼ Re ξ` and `S = ¼ Im ξ`, equivalently Weil positivity for the repaired current.

**Parity.** The programme proves the finite-prefix indeterminacy theorem: two functions agreeing on a prefix can have different correlation sums, so no finite computation can decide two-point Chowla. It proves that the greedy support is Sylvester-sparse, that the shifted product is not multiplicative, and that the five proposed bridges (support parity, budget parity, ζ-machinery, positive-density support, arithmetic alphabet) fail. The remaining gap is a sign-blind rule with positive-density multiplicative coupling to `Ω`, made precise as OP-19.

## The third objective

The two answers are negative: each identifies a wall that the local methods cannot cross. The **third objective** is positive and supplies the computation layer those walls need. It is a certified partial-sum-plus-tail evaluator: Euler–Maclaurin splits `ζ(s)`, `ζ(s,a)` or `L(s,χ)` into a finite partial sum, the Bernoulli corrections and an explicit tail; exact rational interval arithmetic encloses every factor; a straight-line certificate records every rational operation and is replayed by an independent checker and kernel-checked in Lean; and `π`, `log`, `exp`, `sin` and `cos` are enclosed by Lean theorems. The eta cos/sin split is proved in the same core.

The evaluator is an instrument, not a bridge. It does not prove either wall. Its final enclosure of `ζ(s)` is still conditional on the Euler–Maclaurin identity and the explicit tail bound, which have a written proof in [notes/euler-maclaurin-proof.md](../../topics/partial-sum-plus-tail/notes/euler-maclaurin-proof.md) but are not Lean-formalised, and no theorem about either wall yet uses a certified enclosure as a hypothesis. Its contribution is that finite-scale claims can now be stated with a replayable certificate instead of floating point.

## The common shape

Both programmes follow the same four-step shape:

1. **Convert** the wall into an equality or a correlation statement.
2. **Prove a sharpness/litmus**: the conversion is not vacuous, and the local toolbox cannot force the conclusion. The Davenport–Heilbronn twist is the RH litmus; the finite-prefix theorem and the Sylvester-sparsity theorem are the parity litmus.
3. **Locate the missing input** as a global arithmetic positivity, not an estimate.
4. **Formalise the part that is formalisable** — the finite-prefix core, the definitions of the walls, and the elementary facts — and leave the walls as definitions, not axioms.

The final letter is the statement of that common shape, and the argument that the shape is a wall rather than a door.

## What the programme is not

It is not a proof of RH. It is not a proof of the twin prime conjecture. It is not a proof of Chowla, Sarnak, or Elliott. It is not a claim that the two walls are equivalent; they are structurally analogous, not logically equivalent. It is not a claim that no future method can close them; it is a claim that the methods surveyed here cannot. It is not a floating-point numerical library: the evaluator's computation layer is exact rational arithmetic with a replayable certificate, and its analytic inputs are kept as explicit source claims.

[Back to README](README.md) · [Back to index](../../index.html)
