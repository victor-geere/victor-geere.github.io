# The exact perturbation of the correlation by one sign flip (stated, not proved)

**Kind:** Claim
**Status:** CONJECTURED (stated in the source, not proved there; recorded as a comment, with no Lean declaration)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean) — comment block lines 407–419 (named `corrSlice_sub_corr_self_eq` in the file header, lines 57–60)

## Statement

The source states (verbatim, comment block):

> **The exact perturbation of the correlation by one sign flip (stated, not proved here).**
> Changing the *value* of `λ` at the single index `a` changes `corr h N` through exactly
> the two summands containing `λ a`: the summand at `n = a` and the summand at `n = a - h`.
> At `N = a` both are present, so
>
> `corrSlice h a a - corr h a = -2 λ(a) λ(a + h) - 2 λ(a - h) λ(a)`
>
> for `h ≥ 1`, `a ≥ 1` (the `n = a - h` term vanishes if `a - h < 1`). The right-hand side
> is a fixed `±2`-valued statistic of `λ`, nonzero because `λ` is a sign at every nonzero
> argument.

## Hypotheses and notation

- `λ(a) = (-1)^{Ω(a)}`; `corr h N = ∑_{1 ≤ n ≤ N} λ(n)λ(n+h)`; `corrSlice h a N` is the same sum with `λ` replaced by the slice `λ^{(a)}` (value at `a` negated).
- Hypotheses as stated by the source: `h ≥ 1`, `a ≥ 1`, and `N = a`; the `n = a - h` term vanishes if `a - h < 1`.

## Proof / evidence

The source states this without proof in the file's comment block and says so explicitly: "The `Finset`-level manipulation establishing the displayed identity is the one spot in this file that is recorded as a statement rather than elaborated." It is named `corrSlice_sub_corr_self_eq` in the file header (lines 57–60) and has **no** Lean declaration; the file explains that the perturbation's `ℓ²`-mass and the prefix agreement are its rigorously proved companions (`corrSliceSqSub`, `corrSlice_eq_corr_of_lt`). The source does give the reasoning that both affected summands contain `λ a`. Hence status CONJECTURED: asserted, argued informally, but not established in the source.

## Dependencies and related results

- Companions proved in full: [The slice perturbation has ℓ²-mass exactly 4](lean-rh46-chowla-corrslice-perturbation-l2-mass-four.md), [Prefix agreement of the slice correlations with corr h N](lean-rh46-chowla-corrslice-prefix-agreement.md).
- The elaborated declaration [The logical core, second half: 2λ(a)λ(a+h) is nonzero](lean-rh46-chowla-corrslice-sign-statistic-nonzero.md) proves only that the `±2` statistic is nonzero; it does not state this identity.

## Notes

- Status must not be read as PROVED. The source's own label is "(stated, not proved here)" and the header calls it a statement "recorded rather than elaborated".
- The identity is not an open mathematical problem — it is a finite algebraic manipulation of the two sums — but the harvest reports exactly what the source establishes: an unelaborated statement.
- Kind is Claim because the source presents it as a stated identity, not as a `theorem`/`lemma`/`proposition`/`corollary` declaration.
