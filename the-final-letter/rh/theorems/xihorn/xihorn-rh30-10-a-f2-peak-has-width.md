# (F2) The peak has width

**Kind:** Claim
**Status:** PROVED (paper argument; 5.991 against the bound 23.706)
**Area:** xi-horn
**Source:** [`xi-horn/rh30-10-a.md`](../../xi-horn/rh30-10-a.md) — §4 "The two facts about q ⪰ 0 that no variation bound uses"

## Statement

> **(F2) The peak has width.** |p| is Lipschitz with constant D‖p‖_∞ = D√M
> (Bernstein, applied to e^{−iDθ/2}p and then undone). Hence for s ∈ (0,1),
>
> ```
> q ≥ M(1−s)²   on the arc  |θ − θ*| ≤ s/D  around any peak θ*               (6)
> ```

## Hypotheses and notation

- q feasible for (5), `q = |p|²`, `D = n − 1`, `M = ‖q‖_∞` as in
  [F1](xihorn-rh30-10-a-f1-mean-one-bounds.md) and [Theorem 1](xihorn-rh30-10-a-t1-lp-form-of-lambda-min.md);
  θ\* any peak of q.
- Bernstein's inequality for trigonometric polynomials, applied to
  `e^{−iDθ/2}p` and then undone.

## Proof / evidence

The source's derivation, verbatim: "|p| is Lipschitz with constant
D‖p‖_∞ = D√M (Bernstein, applied to e^{−iDθ/2}p and then undone). Hence for
s ∈ (0,1), q ≥ M(1−s)² on the arc |θ − θ*| ≤ s/D around any peak θ\* (6)."

Numerical check (§4, §10): "Verified: Lip(|p|) = 5.991 against the bound
D√M = 23.706; on the arc of half-length 1/(2D) the measured min of q is 8.557
against M/4 = 2.195."

## Dependencies and related results

- Bernstein's inequality (cited in the text of the derivation).
- The first branch of [Theorem 3](xihorn-rh30-10-a-t3-arc-mass-floor.md) is (6) integrated against μ: "the arc
  it produces has length 2s/D, so ∫q dμ ≥ M(1−s)²·A(2s/D)."
- Together with [F3](xihorn-rh30-10-a-f3-level-sets-few-long.md): "Neither fact is available to a variation
  bound: both are statements that a non-negative normalised polynomial *cannot
  be small everywhere*, and both are false for signed q of the same degree."

## Notes

- The source labels this "(F2) The peak has width" and calls it one of the
  facts §4 is about; it is harvested here as a Claim because it is explicitly
  labelled and is invoked by name in [Theorem 3](xihorn-rh30-10-a-t3-arc-mass-floor.md)'s proof.
- The name and the inequality (6) are the source's; the proof is the two-line
  Bernstein argument quoted above.
