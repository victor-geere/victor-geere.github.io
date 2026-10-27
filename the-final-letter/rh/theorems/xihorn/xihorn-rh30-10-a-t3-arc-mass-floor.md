# Theorem 3

**Kind:** Theorem
**Status:** PROVED (paper argument; 500 measures checked, 0 violations)
**Area:** xi-horn
**Source:** [`xi-horn/rh30-10-a.md`](../../xi-horn/rh30-10-a.md) — §5 "The floor"

## Statement

> **Theorem 3.** Let Ǎ be the convex envelope of A on [0, 2π]. Then for every
> n ≥ 2, with D = n−1,
>
> ```
> λ_min(T_n(μ)) ≥ min      max { max  M(1−s)²·A(2s/D) ,                     (9)
>                 1≤M≤n           s∈(0,1)
>                                 max  t·D·Ǎ( 2π(1−t)/(MD) ) }
>                                 t∈(0,1)
> ```

## Hypotheses and notation

- `A(ℓ) = min { μ(I) : I an arc of length ℓ }` — the **emptiest-arc mass** (3);
  `Ǎ` its lower convex envelope on [0, 2π].
- μ a finite positive measure on 𝕋 as in
  [Theorem 1](xihorn-rh30-10-a-t1-lp-form-of-lambda-min.md); `D = n − 1`; `T_n(μ)` the Toeplitz moment
  matrix.
- The bound's only positional input is A; the source's three summary
  properties: "**It needs no eigenvalue.** Its only input is the arc-mass
  function A — elementary, computable from a sorted list of atoms"; "**It needs
  no retention sweep**, though it accepts one ([Theorem 4](xihorn-rh30-10-a-t4-monotonicity-in-measure.md))";
  "**It is one-sided in the zero table.** More atoms only raise A."

## Proof / evidence

The source's proof, verbatim: "Fix a feasible q and let M = ‖q‖_∞, which lies
in [1, n] by (F1). The first branch is (6) integrated against μ: the arc it
produces has length 2s/D, so ∫q dμ ≥ M(1−s)²·A(2s/D). For the second, put
E = {q ≥ t}; then ∫q dμ ≥ t·μ(E). By (7), E is a union of k ≤ D disjoint arcs
of lengths ℓ₁…ℓ_k with Σℓ_i ≥ 2π(1−t)/M, so μ(E) = Σμ(I_i) ≥ ΣA(ℓ_i) ≥ ΣǍ(ℓ_i)
≥ k·Ǎ(Σℓ_i/k). Ǎ is convex with Ǎ(0) = 0, so Ǎ(x)/x is non-decreasing and
k·Ǎ(S/k) is non-increasing in k; since k ≤ D this is ≥ D·Ǎ(2π(1−t)/(MD)). Both
branches hold for every feasible q, M is not ours to choose, and the minimiser
of (5) is feasible. ∎"

**Validity, checked** (§5, §10): "500 measures over five families (crystals,
random positions, random positions with w ~ U⁵ weights, equidistributed
positions with k^{−3} weights, two-cluster configurations), n from 2 to 60:
**0 violations**, 78 non-vacuous cases, minimum ratio truth/bound 8.14."

## Dependencies and related results

- [Theorem 1](xihorn-rh30-10-a-t1-lp-form-of-lambda-min.md) (the LP rewriting the proof minimises over),
  [F1](xihorn-rh30-10-a-f1-mean-one-bounds.md) (M ∈ [1, n]), [F2](xihorn-rh30-10-a-f2-peak-has-width.md) (the peak-width inequality (6))
  and [F3](xihorn-rh30-10-a-f3-level-sets-few-long.md) (the level-set inequality (7)).
- [Theorem 4](xihorn-rh30-10-a-t4-monotonicity-in-measure.md) is what lets (9) be evaluated on any finite
  sub-table of ordinates, with no tail estimate.
- The source says this is the first relaxation in the arc that keeps positivity
  itself: rh31 §8 (a) asked a lemma to deliver "every emptiest-arc computation
  becomes a certified floor".

## Notes

- The source's own verdict is that the bound **loses** (§6, on a surrogate
  window — a plain sinc⁴, not rh27a's searched window, so "they are not
  certificates and no λ_min here is one of the arc's nine"): it is 25× to 200×
  below route two wherever route two is alive, and it dies *first* — at
  n = 1 + 1/g_max = 131 against route two's n = 1 + 1/ℓ_max = 228. "A fourth
  route, and a fourth failure."
- Two implementation caveats stated by the source: in (9) the second branch was
  maximised over t on a 99-point grid but the first branch was fixed at s = ½,
  "so its column slightly understates the theorem"; and the convex hull's grid
  **must** resolve g_max, "else the hull is positive where A is 0 and the floor
  is overstated" — an error that "cost this document a full pass".
- §8 (b): "The two branches of (9) are not sharp. … (F1)'s upper end M ≤ n is
  used nowhere."
