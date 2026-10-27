# (F3) The level sets are few and long

**Kind:** Claim
**Status:** PROVED (paper argument)
**Area:** xi-horn
**Source:** [`xi-horn/rh30-10-a.md`](../../xi-horn/rh30-10-a.md) — §4 "The two facts about q ⪰ 0 that no variation bound uses"

## Statement

> **(F3) The level sets are few and long.** For t ∈ (0,1),
>
> ```
> |{q ≥ t}| ≥ 2π(1−t)/M,  and {q ≥ t} is a union of at most D arcs            (7)
> ```
>
> — the first from 2π = ∫q ≤ t(2π − |E|) + M|E|; the second because a trig
> polynomial of degree D takes the value t at most 2D times.

## Hypotheses and notation

- q feasible for (5), `D = n − 1`, `M = ‖q‖_∞`, as in
  [F1](xihorn-rh30-10-a-f1-mean-one-bounds.md) and [Theorem 1](xihorn-rh30-10-a-t1-lp-form-of-lambda-min.md).
- `E = {q ≥ t}` for t ∈ (0,1); |E| its measure; `{q ≥ t}` is a union of at most
  D arcs.
- The first inequality: `2π = ∫q ≤ t(2π − |E|) + M|E|`.
- The second: a trig polynomial of degree D takes the value t at most 2D times.

## Proof / evidence

The source's derivation, verbatim: "— the first from 2π = ∫q ≤ t(2π − |E|) +
M|E|; the second because a trig polynomial of degree D takes the value t at most
2D times."

## Dependencies and related results

- Used in the second branch of [Theorem 3](xihorn-rh30-10-a-t3-arc-mass-floor.md): "put E = {q ≥ t}; then
  ∫q dμ ≥ t·μ(E). By (7), E is a union of k ≤ D disjoint arcs of lengths ℓ₁…ℓ_k
  with Σℓ_i ≥ 2π(1−t)/M …"
- With [F2](xihorn-rh30-10-a-f2-peak-has-width.md), one of the facts the source says no variation bound uses:
  "Neither fact is available to a variation bound: both are statements that a
  non-negative normalised polynomial *cannot be small everywhere*, and both are
  false for signed q of the same degree."

## Notes

- The source labels this "(F3) The level sets are few and long" and calls it one
  of the facts §4 is about; it is harvested here as a Claim because it is
  explicitly labelled and is invoked by name in [Theorem 3](xihorn-rh30-10-a-t3-arc-mass-floor.md)'s proof.
- Nearby and related but not harvested: (8), the exact n-grid quadrature
  `(1/n)Σ_{r<n} q(θ₀ + 2πr/n) = 1`, which the source says "has no error term at
  all, which is what makes it tempting; §7 records why it cannot be used on its
  own" (verified to 2.7e−15 over 50 rotations). It is stated as an equation used
  in the proof's bookkeeping, not as a labelled result.
