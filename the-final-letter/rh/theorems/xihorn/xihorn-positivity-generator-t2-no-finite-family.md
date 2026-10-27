# Theorem 2 — no finite family, because the margin is the blindness

**Kind:** Theorem
**Status:** PROVED (paper argument)
**Area:** xi-horn
**Source:** [`xi-horn/positivity-generator.md`](../../xi-horn/positivity-generator.md) — §4 "Theorem 2 — no finite family, because the margin is the blindness"

## Statement

> **Theorem 2.** Let `V = span{f₁, …, f_N}` be finite-dimensional, with each
> `F_i = f̂_i` entire and `F_i(z) → 0` as `|Re z| → ∞` uniformly on
> `|Im z| ≤ ½` — true of every window in use anywhere in this arc. Let
> `λ_min(V) > 0` be the smallest eigenvalue of W restricted to V. Then there is
> a finite `T*(V)` such that for every `a > T*` and every `δ ∈ (0, ½]`, the form
> W restricted to V remains positive definite when the zero configuration is
> perturbed by a quadruple at `γ = ±a ± iδ`.
>
> **Hence `W|_V ⪰ 0` is compatible with off-line zeros, and no finite family
> generates.**

## Hypotheses and notation

- `V = span{f₁, …, f_N}` finite-dimensional; each `F_i = f̂_i` is entire and
  `F_i(z) → 0` as `|Re z| → ∞` uniformly on `|Im z| ≤ ½` — "true of every window
  in use anywhere in this arc".
- `λ_min(V) > 0`: the smallest eigenvalue of W restricted to V (a positive
  floor).
- The perturbed configuration is a **counterfactual**, "read exactly as rh10 §2
  reads its hypothetical pair at σ = 0.7: W is a continuous functional of the
  zero configuration, and the question is whether the certified inequality would
  still hold if the configuration were the wrong one."
- `ĥ(z) = f̂(z)f̂(−z)`.

## Proof / evidence

The source's proof, verbatim: "The four zeros of the quadruple contribute to
`W(Σc_i f_i)` the amount `2·2Re[ĥ(a+iδ)]` with `ĥ(z) = f̂(z)f̂(−z)`, a
perturbation of the Gram matrix of rank at most 2 and operator norm at most
`4N·max_i sup_{|Im z| ≤ ½, |Re z| = a} |F_i(z)|²`, which tends to 0 as `a → ∞`
by hypothesis. Choose T* so that this is below `λ_min(V)`; positive definiteness
survives any perturbation smaller than the smallest eigenvalue. ∎"

The computed price (§4.1, σ = 0.05, lattice spacing Δ = 0.5, sections of depth
n; the damage is computed exactly rather than bounded and is **not** monotone in
γ, so the crossover is found by scanning γ ∈ [0.25, 120] on a 0.25 grid):

```
  n    v_max   floor          δ = 0.10 (β = 0.60)   δ = 0.25 (β = 0.75)   δ = 0.40 (β = 0.90)
   6   2.5     1.1128e−02     blind at every γ      blind above γ = 7.75  blind above γ = 21.5
  10   4.5     2.2730e−03     blind above γ = 24.25 blind above γ = 37.75 blind above γ = 41.25
```

At n = 6 a quadruple at real part 0.60 "does, at *every* height in the scan,
less damage than the floor it would have to eat: its peak is 2.370e−3 against a
floor of 1.113e−2. **That certificate cannot see a single off-line zero at
β = 0.60 anywhere in the plane**, and its floor is precisely why."

## Dependencies and related results

- Immediate [Corollary: the margin is the blindness](xihorn-positivity-generator-c1-floor-blindness.md).
- Refutes §4.4 item 4 of [horn-helix-revisited.md](../../xi-horn/horn-helix-revisited.md) as literally posed; the
  surviving positive statement is [Theorem 1](xihorn-positivity-generator-t1-generator-minimal.md).
- "This is rh30 §7's reach with the Gershgorin bound replaced by the exact
  eigenvalue, and it agrees in shape": rh30's much larger sections reach
  γ = 3,477 to 18,580, its measured growth exponent n^{1.2} puts the section
  needed at n ≈ 1.8×10¹⁰.

## Notes

- "The theorem is qualitative; the number is what matters."
- The source draws a consequence the arc had not: "The arc has been maximising
  the wrong quantity. A larger certified floor is a *smaller* reach." rh19's
  headline — "coarse is stronger, by 93× at Δ = 0.24" — is, read through
  Theorem 2, "the discovery of a family that sees less".
- The source is careful that nothing computed elsewhere is wrong: "Nothing
  computed in those documents is wrong, and the floors are real theorems about
  real matrices. The inference that a bigger floor is better progress is the
  part that does not survive."
- The frame says the reach figure "cannot be improved by a better estimate: it
  is not an artefact of the bound, it is the content of having a floor."
